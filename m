Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEED6219D69
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 12:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgGIKR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 06:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbgGIKR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 06:17:27 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC11C061A0B
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 03:17:27 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id l2so1243304wmf.0
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 03:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dx7AWW/y8nrFHRfzMfnYM5/Rl5A3rBbQovnBEVFwtSQ=;
        b=a89bsqJ8HJE1UoI6TuoXYTq9p4Sa20cCvMRbC70HX9PgRYlWWa3avpCYw70d7Y3LXK
         u8jHqeXiTx8f5Hm4IGw8FSZ5YByt3I1CiWTATjtsZgIyOt7kIEnoPHjHNdoWHSmtiKDg
         mFELFlkCWIkktprbWrVHAcR/lYbt7Jh3i7yYXOUZMi9LpQS3xfix7T4Ycgyri5ABsIvb
         OFYkrer4GWfyJvZ6J+EerNYR2N8qMeDWYHDGzgRKjeBDFpRSea0spOaBOnL4nNRgJ5k4
         N5J6Yumqnpbd+KT2uka5DCsK09SbXvwh/M4gZIa9fHuGsDqCge3ySXR6wGTNzg4lNQLU
         TqlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dx7AWW/y8nrFHRfzMfnYM5/Rl5A3rBbQovnBEVFwtSQ=;
        b=tOPSMPTd6hPFQKDYg7ZBGtFJOQzS20xluyk0H/I2knZOZYV2AEuqpNZvgfK2rKUT8v
         fzHH8Yg2YI10l0J6BaNi8Ooqn8HE4UAiC82m2Z5jDiMW8apzFKF01Tl/NyHP6rsAmyly
         pO7jxv6hIH7rNbKm+uyoUATtUFs54+NQs0Iwf78hRtNwSNBnwLeRcZgXwNSzSNAUvgtu
         tTPKMupIIUBX+e1VAgOBheM4LxMx2VyDbjZzjtL8DOWK1mGZwl/rhKyIuAapzupV2qbY
         QA9x8cRJ9xWyDvFLe5OgQ6wJj8O2bkmxN9pslqCbrVRAx7hgNwd910VZh0Wl/H6hF8Bj
         sClA==
X-Gm-Message-State: AOAM531A1JEO8Zzynx7/cd8k+r23b9dhycrAJg++9p2NHUNZ92jX+O7z
        N21qNt2wjW+SPSC11Phqxvk=
X-Google-Smtp-Source: ABdhPJzu2osOui+4DQU/mPmnKwg+BFM6BqvfazB550VZRiZyHZryratSwELqYW+N/bFKPSsSpwhZig==
X-Received: by 2002:a1c:bb43:: with SMTP id l64mr13918142wmf.151.1594289845993;
        Thu, 09 Jul 2020 03:17:25 -0700 (PDT)
Received: from localhost.localdomain ([77.139.6.232])
        by smtp.gmail.com with ESMTPSA id o21sm3988607wmh.18.2020.07.09.03.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 03:17:25 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     steffen.klassert@secunet.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, netdev@vger.kernel.org
Cc:     Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec-next 1/2] xfrm interface: avoid xi lookup in xfrmi_decode_session()
Date:   Thu,  9 Jul 2020 13:16:51 +0300
Message-Id: <20200709101652.1911784-2-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709101652.1911784-1-eyal.birger@gmail.com>
References: <20200709101652.1911784-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The xfrmi context exists in the netdevice priv context.
Avoid looking for it in a separate list.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 net/xfrm/xfrm_interface.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index c407ecbc5d46..069dafeba873 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -47,6 +47,7 @@ static int xfrmi_dev_init(struct net_device *dev);
 static void xfrmi_dev_setup(struct net_device *dev);
 static struct rtnl_link_ops xfrmi_link_ops __read_mostly;
 static unsigned int xfrmi_net_id __read_mostly;
+static const struct net_device_ops xfrmi_netdev_ops;
 
 struct xfrmi_net {
 	/* lists for storing interfaces in use */
@@ -73,8 +74,7 @@ static struct xfrm_if *xfrmi_lookup(struct net *net, struct xfrm_state *x)
 static struct xfrm_if *xfrmi_decode_session(struct sk_buff *skb,
 					    unsigned short family)
 {
-	struct xfrmi_net *xfrmn;
-	struct xfrm_if *xi;
+	struct net_device *dev;
 	int ifindex = 0;
 
 	if (!secpath_exists(skb) || !skb->dev)
@@ -88,18 +88,21 @@ static struct xfrm_if *xfrmi_decode_session(struct sk_buff *skb,
 		ifindex = inet_sdif(skb);
 		break;
 	}
-	if (!ifindex)
-		ifindex = skb->dev->ifindex;
 
-	xfrmn = net_generic(xs_net(xfrm_input_state(skb)), xfrmi_net_id);
+	if (ifindex) {
+		struct net *net = xs_net(xfrm_input_state(skb));
 
-	for_each_xfrmi_rcu(xfrmn->xfrmi[0], xi) {
-		if (ifindex == xi->dev->ifindex &&
-			(xi->dev->flags & IFF_UP))
-				return xi;
+		dev = dev_get_by_index_rcu(net, ifindex);
+	} else {
+		dev = skb->dev;
 	}
 
-	return NULL;
+	if (!dev || !(dev->flags & IFF_UP))
+		return NULL;
+	if (dev->netdev_ops != &xfrmi_netdev_ops)
+		return NULL;
+
+	return netdev_priv(dev);
 }
 
 static void xfrmi_link(struct xfrmi_net *xfrmn, struct xfrm_if *xi)
-- 
2.25.1

