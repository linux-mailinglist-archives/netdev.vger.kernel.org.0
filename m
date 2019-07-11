Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE78065DB9
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 18:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbfGKQnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 12:43:17 -0400
Received: from gateway32.websitewelcome.com ([192.185.145.122]:30960 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728405AbfGKQnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 12:43:16 -0400
X-Greylist: delayed 1241 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Jul 2019 12:43:16 EDT
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id 39A352C9D5
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 11:22:35 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id lbq7h3O2TdnCelbq7ha7qS; Thu, 11 Jul 2019 11:22:35 -0500
X-Authority-Reason: nr=8
Received: from cablelink-187-160-61-213.pcs.intercable.net ([187.160.61.213]:24662 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hlbq6-002Yit-1g; Thu, 11 Jul 2019 11:22:34 -0500
Date:   Thu, 11 Jul 2019 11:22:33 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lawrence Brakmo <brakmo@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH][bpf-next] bpf: verifier: avoid fall-through warnings
Message-ID: <20190711162233.GA6977@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.160.61.213
X-Source-L: No
X-Exim-ID: 1hlbq6-002Yit-1g
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: cablelink-187-160-61-213.pcs.intercable.net (embeddedor) [187.160.61.213]:24662
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 13
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, this patch silences
the following warning:

kernel/bpf/verifier.c: In function ‘check_return_code’:
kernel/bpf/verifier.c:6106:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
   if (env->prog->expected_attach_type == BPF_CGROUP_UDP4_RECVMSG ||
      ^
kernel/bpf/verifier.c:6109:2: note: here
  case BPF_PROG_TYPE_CGROUP_SKB:
  ^~~~

Warning level 3 was used: -Wimplicit-fallthrough=3

Notice that is much clearer to explicitly add breaks in each case
statement (that actually contains some code), rather than letting
the code to fall through.

This patch is part of the ongoing efforts to enable
-Wimplicit-fallthrough.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---

NOTE: -Wimplicit-fallthrough will be enabled globally in v5.3. So, I
      suggest you to take this patch for 5.3-rc1.

 kernel/bpf/verifier.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a2e763703c30..44c3b947400e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6106,11 +6106,13 @@ static int check_return_code(struct bpf_verifier_env *env)
 		if (env->prog->expected_attach_type == BPF_CGROUP_UDP4_RECVMSG ||
 		    env->prog->expected_attach_type == BPF_CGROUP_UDP6_RECVMSG)
 			range = tnum_range(1, 1);
+		break;
 	case BPF_PROG_TYPE_CGROUP_SKB:
 		if (env->prog->expected_attach_type == BPF_CGROUP_INET_EGRESS) {
 			range = tnum_range(0, 3);
 			enforce_attach_type_range = tnum_range(2, 3);
 		}
+		break;
 	case BPF_PROG_TYPE_CGROUP_SOCK:
 	case BPF_PROG_TYPE_SOCK_OPS:
 	case BPF_PROG_TYPE_CGROUP_DEVICE:
-- 
2.21.0

