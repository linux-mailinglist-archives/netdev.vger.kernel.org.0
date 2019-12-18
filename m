Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B521242E5
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 10:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfLRJTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 04:19:16 -0500
Received: from mail.dlink.ru ([178.170.168.18]:57768 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbfLRJTP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 04:19:15 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id F1EC31B20120; Wed, 18 Dec 2019 12:19:10 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru F1EC31B20120
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1576660751; bh=dacXOshgO7/LdPb/5UECyNXY1P7mbC7VYs/cQiweRR8=;
        h=From:To:Cc:Subject:Date;
        b=DOq9x7S1dsO5H3WvE5Cu5xnECZ5E7Lg6u/KgEDo7VD//WoXfboKcSX84oXGuMQnyL
         0vAaLvoXqKYs//aIwhjkkTTPHWUse+WRxzpqd/elp6g+DE2AYemImG643xE9PBh085
         TUi8fy57RN8M+/a207IEGM813GxzkggZk3q2D2uY=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 244C61B20380;
        Wed, 18 Dec 2019 12:18:57 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 244C61B20380
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 5BD631B20367;
        Wed, 18 Dec 2019 12:18:55 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Wed, 18 Dec 2019 12:18:55 +0300 (MSK)
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Aaron Tomlin <atomlin@redhat.com>,
        Matteo Croce <mcroce@redhat.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Edward Cree <ecree@solarflare.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH net] net: core: sysctl: fix compiler warning when only cBPF is present
Date:   Wed, 18 Dec 2019 12:18:21 +0300
Message-Id: <20191218091821.7080-1-alobakin@dlink.ru>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

proc_dointvec_minmax_bpf_restricted() has been firstly introduced
in commit 2e4a30983b0f ("bpf: restrict access to core bpf sysctls")
under CONFIG_HAVE_EBPF_JIT. Then, this ifdef has been removed in
ede95a63b5e8 ("bpf: add bpf_jit_limit knob to restrict unpriv
allocations"), because a new sysctl, bpf_jit_limit, made use of it.
Finally, this parameter has become long instead of integer with
fdadd04931c2 ("bpf: fix bpf_jit_limit knob for PAGE_SIZE >= 64K")
and thus, a new proc_dolongvec_minmax_bpf_restricted() has been
added.
With this last change, we got back to that
proc_dointvec_minmax_bpf_restricted() is used only under
CONFIG_HAVE_EBPF_JIT, but the corresponding ifdef has not been
brought back.

So, in configurations like CONFIG_BPF_JIT=y && CONFIG_HAVE_EBPF_JIT=n
since v4.20 we have:

  CC      net/core/sysctl_net_core.o
net/core/sysctl_net_core.c:292:1: warning: ‘proc_dointvec_minmax_bpf_restricted’ defined but not used [-Wunused-function]
  292 | proc_dointvec_minmax_bpf_restricted(struct ctl_table *table, int write,
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Suppress this by guarding it with CONFIG_HAVE_EBPF_JIT again.

Fixes: fdadd04931c2 ("bpf: fix bpf_jit_limit knob for PAGE_SIZE >= 64K")
Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
---
 net/core/sysctl_net_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index eb29e5adc84d..70211c9edb02 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -288,6 +288,7 @@ static int proc_dointvec_minmax_bpf_enable(struct ctl_table *table, int write,
 	return ret;
 }
 
+#ifdef CONFIG_HAVE_EBPF_JIT
 static int
 proc_dointvec_minmax_bpf_restricted(struct ctl_table *table, int write,
 				    void __user *buffer, size_t *lenp,
@@ -298,6 +299,7 @@ proc_dointvec_minmax_bpf_restricted(struct ctl_table *table, int write,
 
 	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 }
+#endif /* CONFIG_HAVE_EBPF_JIT */
 
 static int
 proc_dolongvec_minmax_bpf_restricted(struct ctl_table *table, int write,
-- 
2.24.1

