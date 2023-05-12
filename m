Return-Path: <netdev+bounces-2032-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 31E86700039
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:25:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 323C71C21118
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 06:24:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 329EB187D;
	Fri, 12 May 2023 06:24:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B7AA2A;
	Fri, 12 May 2023 06:24:57 +0000 (UTC)
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE3C40DD;
	Thu, 11 May 2023 23:24:54 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0ViNyZFl_1683872684;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0ViNyZFl_1683872684)
          by smtp.aliyun-inc.com;
          Fri, 12 May 2023 14:24:49 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com>
To: kgraul@linux.ibm.com,
	wenjia@linux.ibm.com,
	jaka@linux.ibm.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	pabeni@redhat.com,
	song@kernel.org,
	sdf@google.com,
	haoluo@google.com,
	yhs@fb.com,
	edumazet@google.com,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	jolsa@kernel.org,
	guwen@linux.alibaba.com
Cc: kuba@kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [PATCH bpf-next v1 0/5] net/smc: Introduce BPF injection capability
Date: Fri, 12 May 2023 14:24:39 +0800
Message-Id: <1683872684-64872-1-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

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

v1:

1. split bpf_smc.c 
2. remove unnecessary symbol exports

D. Wythe (5):
  net/smc: move smc_sock related structure definition
  net/smc: allow smc to negotiate protocols on policies
  net/smc: allow set or get smc negotiator by sockopt
  bpf: add smc negotiator support in BPF struct_ops
  bpf/selftests: add selftest for SMC bpf capability

 include/net/smc.h                                | 257 ++++++++++++++++++++++
 include/uapi/linux/smc.h                         |   1 +
 kernel/bpf/bpf_struct_ops_types.h                |   4 +
 net/Makefile                                     |   1 +
 net/smc/Kconfig                                  |  11 +
 net/smc/af_smc.c                                 | 265 ++++++++++++++++++++---
 net/smc/bpf_smc.c                                | 171 +++++++++++++++
 net/smc/smc.h                                    | 224 -------------------
 net/smc/smc_negotiator.c                         | 119 ++++++++++
 net/smc/smc_negotiator.h                         | 116 ++++++++++
 tools/testing/selftests/bpf/prog_tests/bpf_smc.c | 107 +++++++++
 tools/testing/selftests/bpf/progs/bpf_smc.c      | 265 +++++++++++++++++++++++
 12 files changed, 1282 insertions(+), 259 deletions(-)
 create mode 100644 net/smc/bpf_smc.c
 create mode 100644 net/smc/smc_negotiator.c
 create mode 100644 net/smc/smc_negotiator.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_smc.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_smc.c

-- 
1.8.3.1


