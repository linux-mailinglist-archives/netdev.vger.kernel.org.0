Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7A85782AA
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235154AbiGRMph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235156AbiGRMpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:45:35 -0400
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C45AB9C;
        Mon, 18 Jul 2022 05:45:33 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VJlyRhm_1658148329;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VJlyRhm_1658148329)
          by smtp.aliyun-inc.com;
          Mon, 18 Jul 2022 20:45:30 +0800
Date:   Mon, 18 Jul 2022 20:45:28 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Wenjia Zhang <wenjia@linux.ibm.com>
Cc:     Wen Gu <guwen@linux.alibaba.com>, kgraul@linux.ibm.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/6] net/smc: Introduce virtually contiguous
 buffers for SMC-R
Message-ID: <YtVV6IWF0cKxJaWe@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <1657791845-1060-1-git-send-email-guwen@linux.alibaba.com>
 <345053d6-5ecb-066d-8eeb-7637da1d7370@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <345053d6-5ecb-066d-8eeb-7637da1d7370@linux.ibm.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 14, 2022 at 05:16:47PM +0200, Wenjia Zhang wrote:
> 
> 
> On 14.07.22 11:43, Wen Gu wrote:
> > On long-running enterprise production servers, high-order contiguous
> > memory pages are usually very rare and in most cases we can only get
> > fragmented pages.
> > 
> > When replacing TCP with SMC-R in such production scenarios, attempting
> > to allocate high-order physically contiguous sndbufs and RMBs may result
> > in frequent memory compaction, which will cause unexpected hung issue
> > and further stability risks.
> > 
> > So this patch set is aimed to allow SMC-R link group to use virtually
> > contiguous sndbufs and RMBs to avoid potential issues mentioned above.
> > Whether to use physically or virtually contiguous buffers can be set
> > by sysctl smcr_buf_type.
> > 
> > Note that using virtually contiguous buffers will bring an acceptable
> > performance regression, which can be mainly divided into two parts:
> > 
> > 1) regression in data path, which is brought by additional address
> >     translation of sndbuf by RNIC in Tx. But in general, translating
> >     address through MTT is fast. According to qperf test, this part
> >     regression is basically less than 10% in latency and bandwidth.
> >     (see patch 5/6 for details)
> > 
> > 2) regression in buffer initialization and destruction path, which is
> >     brought by additional MR operations of sndbufs. But thanks to link
> >     group buffer reuse mechanism, the impact of this kind of regression
> >     decreases as times of buffer reuse increases.
> > 
> > Patch set overview:
> > - Patch 1/6 and 2/6 mainly about simplifying and optimizing DMA sync
> >    operation, which will reduce overhead on the data path, especially
> >    when using virtually contiguous buffers;
> > - Patch 3/6 and 4/6 introduce a sysctl smcr_buf_type to set the type
> >    of buffers in new created link group;
> > - Patch 5/6 allows SMC-R to use virtually contiguous sndbufs and RMBs,
> >    including buffer creation, destruction, MR operation and access;
> > - patch 6/6 extends netlink attribute for buffer type of SMC-R link group;
> > 
> > v1->v2:
> > - Patch 5/6 fixes build issue on 32bit;
> > - Patch 3/6 adds description of new sysctl in smc-sysctl.rst;
> > 
> > Guangguan Wang (2):
> >    net/smc: remove redundant dma sync ops
> >    net/smc: optimize for smc_sndbuf_sync_sg_for_device and
> >      smc_rmb_sync_sg_for_cpu
> > 
> > Wen Gu (4):
> >    net/smc: Introduce a sysctl for setting SMC-R buffer type
> >    net/smc: Use sysctl-specified types of buffers in new link group
> >    net/smc: Allow virtually contiguous sndbufs or RMBs for SMC-R
> >    net/smc: Extend SMC-R link group netlink attribute
> > 
> >   Documentation/networking/smc-sysctl.rst |  13 ++
> >   include/net/netns/smc.h                 |   1 +
> >   include/uapi/linux/smc.h                |   1 +
> >   net/smc/af_smc.c                        |  68 +++++++--
> >   net/smc/smc_clc.c                       |   8 +-
> >   net/smc/smc_clc.h                       |   2 +-
> >   net/smc/smc_core.c                      | 246 +++++++++++++++++++++-----------
> >   net/smc/smc_core.h                      |  20 ++-
> >   net/smc/smc_ib.c                        |  44 +++++-
> >   net/smc/smc_ib.h                        |   2 +
> >   net/smc/smc_llc.c                       |  33 +++--
> >   net/smc/smc_rx.c                        |  92 +++++++++---
> >   net/smc/smc_sysctl.c                    |  11 ++
> >   net/smc/smc_tx.c                        |  10 +-
> >   14 files changed, 404 insertions(+), 147 deletions(-)
> > 
> This idea is very cool! Thank you for your effort! But we still need to
> verify if this solution can run well on our system. I'll come to you soon.

Hi Wenjia,

We have noticed that SMC community is becoming more active recently.
More and more companies have shown their interests in SMC.
Correspondingly, patches are also increasing. We (Alibaba) are trying to
apply SMC into cloud production environment, extending its abilities and
enhancing the performance. We also contributed some work to community in
the past period of time. So we are more than happy to help review SMC
patches together. If you need, we are very glad to be reviewers to share
the review work.

Hope to hear from you, thank you.

Best wishes,
Tony Lu
