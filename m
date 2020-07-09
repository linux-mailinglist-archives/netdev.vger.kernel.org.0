Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF2F219D6C
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 12:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgGIKRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 06:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbgGIKRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 06:17:30 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FBEC061A0B
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 03:17:30 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id a6so1747069wrm.4
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 03:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D0K4+C2nqch/Dt0T+zQEU+kLab8A/OUkn21nq14ouXc=;
        b=cNEue4pLm4xx7N1oFLvWO//qIoPtWIXI+ZrXDfZe4WD3bZCUAaLK4F3lxa7Q50uKFj
         VRNPamQJxJZi8rrpUDHC+2vHrDzM0fznAyO8fqRZKR4rB1gReuufbSkpoPMjAlXZlmDy
         4lqyU/Bfkh6KVGOwBTQRHMs0sjr04knHgIDswNMQ4/anuwJsvaW1hkiDaQbUApW0ebGe
         zc3sC1pCRMRStEr2Zo/dHZnTIuA6hNX9vrQgRxtMH0/93ImjlDEvlHNVQ2k3pYVuLcB2
         u97fRG0nZ/dbfWUgvBYdkxKJ5QiXac12FCmqyC/utZ/Ja7OYg0xKS2YRC/CW69c9lver
         FSxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D0K4+C2nqch/Dt0T+zQEU+kLab8A/OUkn21nq14ouXc=;
        b=K9pHTrTFanBoV2VBs/PPznbVOgdp6gL988S20kxDZyTeFd4NpON+Sj6K887/nsqnnb
         KB5xKK1M6mJnwpxL1EIAn+83nWVXsRZCK5Awt26xSDtPmVegutFBppE894pkEUCv23wd
         a4hZ5qjOvKMzBGQiPM4jph4R2iQ0VoxPSONacRZsTiPgfv00LLNeZKuWdNqDPlVCBkEL
         kC7wDJ42XagnNh/z9b9VWorcQuAJfAaljGP2igRq8IFsDdI9iQfHMrc69oltm8nxUMtv
         hon+8IV/gunH+hF2iRmh98QJ8nORWaMUsOedVrvggw8WPvHC9OuJsDPk3tH21ffVjdmz
         YVig==
X-Gm-Message-State: AOAM531Vfk09quLO2zjC9GfP0grI1LiRYxogXUW1GAgP3cOhCAcSLFcP
        8Qu6GKY5AM5rCEEzHw7sr40=
X-Google-Smtp-Source: ABdhPJyux2cqLXVjyLKnfLCBdG52rK9NKUIUzHX5BBWeDn7kpmzFUCLGQat17s4TbvHXMAucEO51Lg==
X-Received: by 2002:adf:f8cb:: with SMTP id f11mr66059783wrq.358.1594289848688;
        Thu, 09 Jul 2020 03:17:28 -0700 (PDT)
Received: from localhost.localdomain ([77.139.6.232])
        by smtp.gmail.com with ESMTPSA id o21sm3988607wmh.18.2020.07.09.03.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 03:17:27 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     steffen.klassert@secunet.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, netdev@vger.kernel.org
Cc:     Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec-next 2/2] xfrm interface: store xfrmi contexts in a hash by if_id
Date:   Thu,  9 Jul 2020 13:16:52 +0300
Message-Id: <20200709101652.1911784-3-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709101652.1911784-1-eyal.birger@gmail.com>
References: <20200709101652.1911784-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xfrmi_lookup() is called on every packet. Using a single list for
looking up if_id becomes a bottleneck when having many xfrm interfaces.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 net/xfrm/xfrm_interface.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 069dafeba873..f4ec117e9110 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -49,20 +49,28 @@ static struct rtnl_link_ops xfrmi_link_ops __read_mostly;
 static unsigned int xfrmi_net_id __read_mostly;
 static const struct net_device_ops xfrmi_netdev_ops;
 
+#define XFRMI_HASH_BITS	8
+#define XFRMI_HASH_SIZE	BIT(XFRMI_HASH_BITS)
+
 struct xfrmi_net {
 	/* lists for storing interfaces in use */
-	struct xfrm_if __rcu *xfrmi[1];
+	struct xfrm_if __rcu *xfrmi[XFRMI_HASH_SIZE];
 };
 
 #define for_each_xfrmi_rcu(start, xi) \
 	for (xi = rcu_dereference(start); xi; xi = rcu_dereference(xi->next))
 
+static u32 xfrmi_hash(u32 if_id)
+{
+	return hash_32(if_id, XFRMI_HASH_BITS);
+}
+
 static struct xfrm_if *xfrmi_lookup(struct net *net, struct xfrm_state *x)
 {
 	struct xfrmi_net *xfrmn = net_generic(net, xfrmi_net_id);
 	struct xfrm_if *xi;
 
-	for_each_xfrmi_rcu(xfrmn->xfrmi[0], xi) {
+	for_each_xfrmi_rcu(xfrmn->xfrmi[xfrmi_hash(x->if_id)], xi) {
 		if (x->if_id == xi->p.if_id &&
 		    (xi->dev->flags & IFF_UP))
 			return xi;
@@ -107,7 +115,7 @@ static struct xfrm_if *xfrmi_decode_session(struct sk_buff *skb,
 
 static void xfrmi_link(struct xfrmi_net *xfrmn, struct xfrm_if *xi)
 {
-	struct xfrm_if __rcu **xip = &xfrmn->xfrmi[0];
+	struct xfrm_if __rcu **xip = &xfrmn->xfrmi[xfrmi_hash(xi->p.if_id)];
 
 	rcu_assign_pointer(xi->next , rtnl_dereference(*xip));
 	rcu_assign_pointer(*xip, xi);
@@ -118,7 +126,7 @@ static void xfrmi_unlink(struct xfrmi_net *xfrmn, struct xfrm_if *xi)
 	struct xfrm_if __rcu **xip;
 	struct xfrm_if *iter;
 
-	for (xip = &xfrmn->xfrmi[0];
+	for (xip = &xfrmn->xfrmi[xfrmi_hash(xi->p.if_id)];
 	     (iter = rtnl_dereference(*xip)) != NULL;
 	     xip = &iter->next) {
 		if (xi == iter) {
@@ -162,7 +170,7 @@ static struct xfrm_if *xfrmi_locate(struct net *net, struct xfrm_if_parms *p)
 	struct xfrm_if *xi;
 	struct xfrmi_net *xfrmn = net_generic(net, xfrmi_net_id);
 
-	for (xip = &xfrmn->xfrmi[0];
+	for (xip = &xfrmn->xfrmi[xfrmi_hash(p->if_id)];
 	     (xi = rtnl_dereference(*xip)) != NULL;
 	     xip = &xi->next)
 		if (xi->p.if_id == p->if_id)
@@ -761,11 +769,14 @@ static void __net_exit xfrmi_exit_batch_net(struct list_head *net_exit_list)
 		struct xfrmi_net *xfrmn = net_generic(net, xfrmi_net_id);
 		struct xfrm_if __rcu **xip;
 		struct xfrm_if *xi;
+		int i;
 
-		for (xip = &xfrmn->xfrmi[0];
-		     (xi = rtnl_dereference(*xip)) != NULL;
-		     xip = &xi->next)
-			unregister_netdevice_queue(xi->dev, &list);
+		for (i = 0; i < XFRMI_HASH_SIZE; i++) {
+			for (xip = &xfrmn->xfrmi[i];
+			     (xi = rtnl_dereference(*xip)) != NULL;
+			     xip = &xi->next)
+				unregister_netdevice_queue(xi->dev, &list);
+		}
 	}
 	unregister_netdevice_many(&list);
 	rtnl_unlock();
-- 
2.25.1

