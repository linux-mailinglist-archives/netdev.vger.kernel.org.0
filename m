Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D25C3B259B
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 05:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhFXDpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 23:45:35 -0400
Received: from m15113.mail.126.com ([220.181.15.113]:52462 "EHLO
        m15113.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbhFXDpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 23:45:34 -0400
X-Greylist: delayed 1855 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jun 2021 23:45:30 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=ZWj0Q6/WjEB+dhV4sA
        W2ogBo3fGHmEGWlm73E5q45qo=; b=FuzIQiqpsGuFePpdcVQdxqOqF/lGPMEIf7
        L4lUZcNIYqsN66/GScyUyxWPNqopNQWKnt6Aio/5d6fW9U2mPO2KJBlLPEaFPw3W
        kpzPAwzoBv908K3lAjyNUslfi7XfMqkq1NAQsITYnVNzCT1uK2Ym/I+CYqaXjaeZ
        oYz8KDgI4=
Received: from localhost.localdomain (unknown [124.64.11.23])
        by smtp3 (Coremail) with SMTP id DcmowAAX_v6H99NgagNRSg--.30979S4;
        Thu, 24 Jun 2021 11:10:03 +0800 (CST)
From:   zhang kai <zhangkaiheb@126.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        zhang kai <zhangkaiheb@126.com>
Subject: [PATCH] ipv6: delete useless dst check in ip6_dst_lookup_tail
Date:   Thu, 24 Jun 2021 11:09:14 +0800
Message-Id: <20210624030914.15808-1-zhangkaiheb@126.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: DcmowAAX_v6H99NgagNRSg--.30979S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7GryrWw4UtrykJw4DZF45GFg_yoWkZrg_Za
        n2k34j9r4kXrn5G3WUuw43tFykCFZrtF1FqFW2vFZ3t34rJFWq9rn7Ar93ArZ3WFW8GFyD
        JrZYqr1rCF4IqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUtEf5UUUUU==
X-Originating-IP: [124.64.11.23]
X-CM-SenderInfo: x2kd0wxndlxvbe6rjloofrz/1tbi2Qu7-lpEBzBkSgAAsQ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

parameter dst always points to null.

Signed-off-by: zhang kai <zhangkaiheb@126.com>
---
 net/ipv6/ip6_output.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index ff4f9ebcf..3b632e469 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1055,13 +1055,11 @@ static int ip6_dst_lookup_tail(struct net *net, const struct sock *sk,
 	 * ip6_route_output will fail given src=any saddr, though, so
 	 * that's why we try it again later.
 	 */
-	if (ipv6_addr_any(&fl6->saddr) && (!*dst || !(*dst)->error)) {
+	if (ipv6_addr_any(&fl6->saddr)) {
 		struct fib6_info *from;
 		struct rt6_info *rt;
-		bool had_dst = *dst != NULL;
 
-		if (!had_dst)
-			*dst = ip6_route_output(net, sk, fl6);
+		*dst = ip6_route_output(net, sk, fl6);
 		rt = (*dst)->error ? NULL : (struct rt6_info *)*dst;
 
 		rcu_read_lock();
@@ -1078,7 +1076,7 @@ static int ip6_dst_lookup_tail(struct net *net, const struct sock *sk,
 		 * never existed and let the SA-enabled version take
 		 * over.
 		 */
-		if (!had_dst && (*dst)->error) {
+		if ((*dst)->error) {
 			dst_release(*dst);
 			*dst = NULL;
 		}
-- 
2.17.1

