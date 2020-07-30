Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264D3232B7F
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 07:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbgG3FmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 01:42:03 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:56032 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728586AbgG3Fls (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 01:41:48 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 44A57205E7;
        Thu, 30 Jul 2020 07:41:46 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id pCV4bMxH2EPV; Thu, 30 Jul 2020 07:41:45 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 4D00020270;
        Thu, 30 Jul 2020 07:41:45 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 30 Jul 2020 07:41:45 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 30 Jul
 2020 07:41:44 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 2D5FA3184651; Thu, 30 Jul 2020 07:41:44 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 02/19] xfrm: add is_ipip to struct xfrm_input_afinfo
Date:   Thu, 30 Jul 2020 07:41:13 +0200
Message-ID: <20200730054130.16923-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200730054130.16923-1-steffen.klassert@secunet.com>
References: <20200730054130.16923-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

This patch is to add a new member is_ipip to struct xfrm_input_afinfo,
to allow another group family of callback functions to be registered
with is_ipip set.

This will be used for doing a callback for struct xfrm(6)_tunnel of
ipip/ipv6 tunnels in xfrm_input() by calling xfrm_rcv_cb(), which is
needed by ipip/ipv6 tunnels' support in ip(6)_vti and xfrm interface
in the next patches.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h    |  3 ++-
 net/xfrm/xfrm_input.c | 24 +++++++++++++-----------
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index e20b2b27ec48..4666bc9e59ab 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -373,7 +373,8 @@ struct xfrm_state_afinfo *xfrm_state_get_afinfo(unsigned int family);
 struct xfrm_state_afinfo *xfrm_state_afinfo_get_rcu(unsigned int family);
 
 struct xfrm_input_afinfo {
-	unsigned int		family;
+	u8			family;
+	bool			is_ipip;
 	int			(*callback)(struct sk_buff *skb, u8 protocol,
 					    int err);
 };
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index bd984ff17c2d..37456d022cfa 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -42,7 +42,7 @@ struct xfrm_trans_cb {
 #define XFRM_TRANS_SKB_CB(__skb) ((struct xfrm_trans_cb *)&((__skb)->cb[0]))
 
 static DEFINE_SPINLOCK(xfrm_input_afinfo_lock);
-static struct xfrm_input_afinfo const __rcu *xfrm_input_afinfo[AF_INET6 + 1];
+static struct xfrm_input_afinfo const __rcu *xfrm_input_afinfo[2][AF_INET6 + 1];
 
 static struct gro_cells gro_cells;
 static struct net_device xfrm_napi_dev;
@@ -53,14 +53,14 @@ int xfrm_input_register_afinfo(const struct xfrm_input_afinfo *afinfo)
 {
 	int err = 0;
 
-	if (WARN_ON(afinfo->family >= ARRAY_SIZE(xfrm_input_afinfo)))
+	if (WARN_ON(afinfo->family > AF_INET6))
 		return -EAFNOSUPPORT;
 
 	spin_lock_bh(&xfrm_input_afinfo_lock);
-	if (unlikely(xfrm_input_afinfo[afinfo->family] != NULL))
+	if (unlikely(xfrm_input_afinfo[afinfo->is_ipip][afinfo->family]))
 		err = -EEXIST;
 	else
-		rcu_assign_pointer(xfrm_input_afinfo[afinfo->family], afinfo);
+		rcu_assign_pointer(xfrm_input_afinfo[afinfo->is_ipip][afinfo->family], afinfo);
 	spin_unlock_bh(&xfrm_input_afinfo_lock);
 	return err;
 }
@@ -71,11 +71,11 @@ int xfrm_input_unregister_afinfo(const struct xfrm_input_afinfo *afinfo)
 	int err = 0;
 
 	spin_lock_bh(&xfrm_input_afinfo_lock);
-	if (likely(xfrm_input_afinfo[afinfo->family] != NULL)) {
-		if (unlikely(xfrm_input_afinfo[afinfo->family] != afinfo))
+	if (likely(xfrm_input_afinfo[afinfo->is_ipip][afinfo->family])) {
+		if (unlikely(xfrm_input_afinfo[afinfo->is_ipip][afinfo->family] != afinfo))
 			err = -EINVAL;
 		else
-			RCU_INIT_POINTER(xfrm_input_afinfo[afinfo->family], NULL);
+			RCU_INIT_POINTER(xfrm_input_afinfo[afinfo->is_ipip][afinfo->family], NULL);
 	}
 	spin_unlock_bh(&xfrm_input_afinfo_lock);
 	synchronize_rcu();
@@ -83,15 +83,15 @@ int xfrm_input_unregister_afinfo(const struct xfrm_input_afinfo *afinfo)
 }
 EXPORT_SYMBOL(xfrm_input_unregister_afinfo);
 
-static const struct xfrm_input_afinfo *xfrm_input_get_afinfo(unsigned int family)
+static const struct xfrm_input_afinfo *xfrm_input_get_afinfo(u8 family, bool is_ipip)
 {
 	const struct xfrm_input_afinfo *afinfo;
 
-	if (WARN_ON_ONCE(family >= ARRAY_SIZE(xfrm_input_afinfo)))
+	if (WARN_ON_ONCE(family > AF_INET6))
 		return NULL;
 
 	rcu_read_lock();
-	afinfo = rcu_dereference(xfrm_input_afinfo[family]);
+	afinfo = rcu_dereference(xfrm_input_afinfo[is_ipip][family]);
 	if (unlikely(!afinfo))
 		rcu_read_unlock();
 	return afinfo;
@@ -100,9 +100,11 @@ static const struct xfrm_input_afinfo *xfrm_input_get_afinfo(unsigned int family
 static int xfrm_rcv_cb(struct sk_buff *skb, unsigned int family, u8 protocol,
 		       int err)
 {
+	bool is_ipip = (protocol == IPPROTO_IPIP || protocol == IPPROTO_IPV6);
+	const struct xfrm_input_afinfo *afinfo;
 	int ret;
-	const struct xfrm_input_afinfo *afinfo = xfrm_input_get_afinfo(family);
 
+	afinfo = xfrm_input_get_afinfo(family, is_ipip);
 	if (!afinfo)
 		return -EAFNOSUPPORT;
 
-- 
2.17.1

