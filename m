Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6156A55A2
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 10:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbjB1JZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 04:25:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjB1JZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 04:25:06 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BFF55A7;
        Tue, 28 Feb 2023 01:25:03 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0Vcix4w._1677576294;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0Vcix4w._1677576294)
          by smtp.aliyun-inc.com;
          Tue, 28 Feb 2023 17:25:00 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next v3 0/4] net/smc: Introduce BPF injection capability
Date:   Tue, 28 Feb 2023 17:24:50 +0800
Message-Id: <1677576294-33411-1-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
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

v3 -> v2: 
    1. fix checkpatch error and warning.
    2. split patch for better review.
    3. enhance selftest to cover more scenarios.

v2 -> v1:
    1. fix compile error and warning.

D. Wythe (4):
  net/smc: move smc_sock related structure definition
  bpf: add SMC support in BPF struct_ops
  net/smc: add BPF injection on smc negotiation
  bpf/selftests: add selftest for SMC bpf capability

 include/linux/btf_ids.h                          |  12 +
 include/net/smc.h                                | 248 ++++++++++++++++++
 kernel/bpf/bpf_struct_ops_types.h                |   4 +
 net/Makefile                                     |   5 +
 net/smc/af_smc.c                                 |  15 +-
 net/smc/bpf_smc_struct_ops.c                     | 148 +++++++++++
 net/smc/smc.h                                    | 224 ----------------
 tools/testing/selftests/bpf/prog_tests/bpf_smc.c |  37 +++
 tools/testing/selftests/bpf/progs/bpf_smc.c      | 320 +++++++++++++++++++++++
 9 files changed, 788 insertions(+), 225 deletions(-)
 create mode 100644 net/smc/bpf_smc_struct_ops.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_smc.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_smc.c

-- 
1.8.3.1

