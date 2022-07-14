Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D39A57494F
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 11:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238245AbiGNJoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 05:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiGNJoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 05:44:20 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB47C11C1A;
        Thu, 14 Jul 2022 02:44:17 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VJImA7W_1657791845;
Received: from localhost(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VJImA7W_1657791845)
          by smtp.aliyun-inc.com;
          Thu, 14 Jul 2022 17:44:14 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/6] net/smc: Introduce virtually contiguous buffers for SMC-R
Date:   Thu, 14 Jul 2022 17:43:59 +0800
Message-Id: <1657791845-1060-1-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On long-running enterprise production servers, high-order contiguous
memory pages are usually very rare and in most cases we can only get
fragmented pages.

When replacing TCP with SMC-R in such production scenarios, attempting
to allocate high-order physically contiguous sndbufs and RMBs may result
in frequent memory compaction, which will cause unexpected hung issue
and further stability risks.

So this patch set is aimed to allow SMC-R link group to use virtually
contiguous sndbufs and RMBs to avoid potential issues mentioned above.
Whether to use physically or virtually contiguous buffers can be set
by sysctl smcr_buf_type.

Note that using virtually contiguous buffers will bring an acceptable
performance regression, which can be mainly divided into two parts:

1) regression in data path, which is brought by additional address
   translation of sndbuf by RNIC in Tx. But in general, translating
   address through MTT is fast. According to qperf test, this part
   regression is basically less than 10% in latency and bandwidth.
   (see patch 5/6 for details)

2) regression in buffer initialization and destruction path, which is
   brought by additional MR operations of sndbufs. But thanks to link
   group buffer reuse mechanism, the impact of this kind of regression
   decreases as times of buffer reuse increases.

Patch set overview:
- Patch 1/6 and 2/6 mainly about simplifying and optimizing DMA sync
  operation, which will reduce overhead on the data path, especially
  when using virtually contiguous buffers;
- Patch 3/6 and 4/6 introduce a sysctl smcr_buf_type to set the type
  of buffers in new created link group;
- Patch 5/6 allows SMC-R to use virtually contiguous sndbufs and RMBs,
  including buffer creation, destruction, MR operation and access;
- patch 6/6 extends netlink attribute for buffer type of SMC-R link group;

v1->v2:
- Patch 5/6 fixes build issue on 32bit;
- Patch 3/6 adds description of new sysctl in smc-sysctl.rst;

Guangguan Wang (2):
  net/smc: remove redundant dma sync ops
  net/smc: optimize for smc_sndbuf_sync_sg_for_device and
    smc_rmb_sync_sg_for_cpu

Wen Gu (4):
  net/smc: Introduce a sysctl for setting SMC-R buffer type
  net/smc: Use sysctl-specified types of buffers in new link group
  net/smc: Allow virtually contiguous sndbufs or RMBs for SMC-R
  net/smc: Extend SMC-R link group netlink attribute

 Documentation/networking/smc-sysctl.rst |  13 ++
 include/net/netns/smc.h                 |   1 +
 include/uapi/linux/smc.h                |   1 +
 net/smc/af_smc.c                        |  68 +++++++--
 net/smc/smc_clc.c                       |   8 +-
 net/smc/smc_clc.h                       |   2 +-
 net/smc/smc_core.c                      | 246 +++++++++++++++++++++-----------
 net/smc/smc_core.h                      |  20 ++-
 net/smc/smc_ib.c                        |  44 +++++-
 net/smc/smc_ib.h                        |   2 +
 net/smc/smc_llc.c                       |  33 +++--
 net/smc/smc_rx.c                        |  92 +++++++++---
 net/smc/smc_sysctl.c                    |  11 ++
 net/smc/smc_tx.c                        |  10 +-
 14 files changed, 404 insertions(+), 147 deletions(-)

-- 
1.8.3.1

