Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176E71DC3F1
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 02:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgEUAhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 20:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727969AbgEUAhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 20:37:24 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8736AC061A0E;
        Wed, 20 May 2020 17:37:24 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jbZD8-00Cge1-Q8; Thu, 21 May 2020 00:37:22 +0000
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 07/19] ip6_mc_msfilter(): pass the address list separately
Date:   Thu, 21 May 2020 01:37:09 +0100
Message-Id: <20200521003721.3023783-7-viro@ZenIV.linux.org.uk>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200521003721.3023783-1-viro@ZenIV.linux.org.uk>
References: <20200521003657.GE23230@ZenIV.linux.org.uk>
 <20200521003721.3023783-1-viro@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

that way we'll be able to reuse it for compat case

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/net/ipv6.h       | 3 ++-
 net/ipv6/ipv6_sockglue.c | 2 +-
 net/ipv6/mcast.c         | 7 ++++---
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index c45eb78d970f..39a00d3ef5e2 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1136,7 +1136,8 @@ struct group_filter;
 
 int ip6_mc_source(int add, int omode, struct sock *sk,
 		  struct group_source_req *pgsr);
-int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf);
+int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
+		  struct sockaddr_storage *list);
 int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
 		  struct sockaddr_storage __user *p);
 
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 0bbafe73bdde..7d3ecc0e69d1 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -780,7 +780,7 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 			retv = -EINVAL;
 			break;
 		}
-		retv = ip6_mc_msfilter(sk, gsf);
+		retv = ip6_mc_msfilter(sk, gsf, gsf->gf_slist);
 		kfree(gsf);
 
 		break;
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 97d796c7d6c0..7e12d2114158 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -457,7 +457,8 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 	return err;
 }
 
-int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf)
+int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
+		    struct sockaddr_storage *list)
 {
 	const struct in6_addr *group;
 	struct ipv6_mc_socklist *pmc;
@@ -509,10 +510,10 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf)
 			goto done;
 		}
 		newpsl->sl_max = newpsl->sl_count = gsf->gf_numsrc;
-		for (i = 0; i < newpsl->sl_count; ++i) {
+		for (i = 0; i < newpsl->sl_count; ++i, ++list) {
 			struct sockaddr_in6 *psin6;
 
-			psin6 = (struct sockaddr_in6 *)&gsf->gf_slist[i];
+			psin6 = (struct sockaddr_in6 *)list;
 			newpsl->sl_addr[i] = psin6->sin6_addr;
 		}
 		err = ip6_mc_add_src(idev, group, gsf->gf_fmode,
-- 
2.11.0

