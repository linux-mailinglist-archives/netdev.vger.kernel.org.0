Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7544E6E5E80
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 12:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbjDRKUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 06:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbjDRKTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 06:19:48 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906847AA9;
        Tue, 18 Apr 2023 03:19:35 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0VgQLRIi_1681813160;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VgQLRIi_1681813160)
          by smtp.aliyun-inc.com;
          Tue, 18 Apr 2023 18:19:31 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, pabeni@redhat.com, song@kernel.org,
        sdf@google.com, haoluo@google.com, yhs@fb.com, edumazet@google.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, jolsa@kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [RFC PATCH bpf-next v2 0/5] net/smc: Introduce BPF injection capability 
Date:   Tue, 18 Apr 2023 18:19:15 +0800
Message-Id: <1681813160-120214-1-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

This patches attempt to introduce BPF injection capability for SMC,
and add selftest to ensure code stability.

As we all know that the SMC protocol is not suitable for all scenarios,
especially for short-lived. However, for most applications, they cannot
guarantee that there are no such scenarios at all. Therefore, apps
may need some specific strategies to decide shall we need to use SMC
or not, for example, apps can limit the scope of the SMC to a specific
IP address or port.

Based on the consideration of transparent replacement, we hope that apps
can remain transparent even if they need to formulate some specific
strategies for SMC using. That is, do not need to recompile their code.

On the other hand, we need to ensure the scalability of strategies
implementation. Although it is simple to use socket options or sysctl,
it will bring more complexity to subsequent expansion.

Fortunately, BPF can solve these concerns very well, users can write
thire own strategies in eBPF to choose whether to use SMC or not.
And it's quite easy for them to modify their strategies in the future.

This patches implement injection capability for SMC via struct_ops.
In that way, we can add new injection scenarios in the future.

v2 -> v1:

1. Fix complie error if CONFIG_BPF_SYSCALL set while CONFIG_SMC_BPF not.
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202304070326.mYVdiX9k-lkp@intel.com/

2. Fix potential reference leaks, smc_destruct may be prematurely retired
due to pre conditions.

D. Wythe (5):
  net/smc: move smc_sock related structure definition
  net/smc: net/smc: allow smc to negotiate protocols on policies
  net/smc: allow set or get smc negotiator by sockopt
  bpf: add smc negotiator support in BPF struct_ops
  bpf/selftests: add selftest for SMC bpf capability

 include/net/smc.h                                | 268 +++++++++++++++++
 include/uapi/linux/smc.h                         |   1 +
 kernel/bpf/bpf_struct_ops_types.h                |   4 +
 net/Makefile                                     |   1 +
 net/smc/Kconfig                                  |  13 +
 net/smc/af_smc.c                                 | 203 ++++++++++---
 net/smc/bpf_smc.c                                | 360 +++++++++++++++++++++++
 net/smc/smc.h                                    | 224 --------------
 tools/testing/selftests/bpf/prog_tests/bpf_smc.c | 107 +++++++
 tools/testing/selftests/bpf/progs/bpf_smc.c      | 265 +++++++++++++++++
 10 files changed, 1187 insertions(+), 259 deletions(-)
 create mode 100644 net/smc/bpf_smc.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_smc.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_smc.c

-- 
1.8.3.1

