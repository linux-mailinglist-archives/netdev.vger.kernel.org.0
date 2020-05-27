Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8C11E5070
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 23:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgE0VZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 17:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgE0VZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 17:25:52 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68675C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 14:25:52 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id q24so2121255pjd.1
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 14:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XrPj9WCNTD6bgr3G2lR6FwLG+4X3iEWwErApM0srLv4=;
        b=NH6/r9iPS/uzwKPre/+U2pA+G8Flg1KOmM0ka/Lkf3qBJjW4qDoepYfcRO6K4bRlSW
         83CNIdHy45GKRs9YGUzzJGXBqaGuh0VM2Wx/3WouXkWJldOnCNdAi1s+7Ypf394O5J2C
         zBo17pNnziZswzpDCkSZyXavJzOlZKFup9xMw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XrPj9WCNTD6bgr3G2lR6FwLG+4X3iEWwErApM0srLv4=;
        b=CjAOeBVIPClnmsEQKn0Ud4u/rYZ1mKU4BSQrt6dHChZCYto6Q+BSCC07T7Uss6Rf6D
         FpILipMdMw2JSloVL6Vit1xI3cA4kmLiKnISRF6OAj5YjGF5W1LZGvnFkJy4lTluM70X
         ovIN14qWLj6HpXUWOX+Pnad9XbUfFcGez8QTx892DpF8MZEZshIYOgbFn3lq413VK5ei
         EFVEFV2PBEPTmE74ptGD2x360JMJ0B7gA1RNn9VK4kBO+DU7xu2EgjgFWYLtxs5g3nHj
         +VBsI/8UnGee4iGxaAitos3BqijepCitFQkhLzbF/n3KRDvAzrTueUFMLy5dOfvsL11o
         NJBw==
X-Gm-Message-State: AOAM5302D5ydA20sNBBT3TSb9mpPv8NvffUWT411j6pn6YF6aAWtYo/7
        2aDoVxUrT3VpxO2AUgfZwIwEIfwpdnGMd7SqBGdjf1mPyEXEWqMpMdABYKaRsx7g3+1ELqCAPsK
        y1wm6InnAR4Fly/ji5PIY/qv231+PIOjGhdUfdWRbG7YbDkJwPl2P9qu7xgYIpVMqbFcqlNXS
X-Google-Smtp-Source: ABdhPJxV3cfwhyE+fPqeWn5WCBX7B0XZ05LEEB7WSYyb9v6g439CVSKQT67OHvoNPBd7ymELC54j1A==
X-Received: by 2002:a17:90a:394b:: with SMTP id n11mr371732pjf.100.1590614751346;
        Wed, 27 May 2020 14:25:51 -0700 (PDT)
Received: from localhost.localdomain ([2600:8802:202:f600::ddf])
        by smtp.gmail.com with ESMTPSA id c4sm2770344pfb.130.2020.05.27.14.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 14:25:50 -0700 (PDT)
From:   Edwin Peer <edwin.peer@broadcom.com>
To:     netdev@vger.kernel.org
Cc:     Edwin Peer <edwin.peer@broadcom.com>, edumazet@google.com,
        linville@tuxdriver.com, shemminger@vyatta.com,
        mirq-linux@rere.qmqm.pl, jesse.brandeburg@intel.com,
        jchapman@katalix.com, david@weave.works, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, sridhar.samudrala@intel.com,
        jiri@mellanox.com, geoff@infradead.org, mokuno@sm.sony.co.jp,
        msink@permonline.ru, mporter@kernel.crashing.org,
        inaky.perez-gonzalez@intel.com, jwi@linux.ibm.com,
        kgraul@linux.ibm.com, ubraun@linux.ibm.com,
        grant.likely@secretlab.ca, hadi@cyberus.ca, dsahern@kernel.org,
        shrijeet@gmail.com, jon.mason@intel.com, dave.jiang@intel.com,
        saeedm@mellanox.com, hadarh@mellanox.com, ogerlitz@mellanox.com,
        allenbh@gmail.com, michael.chan@broadcom.com
Subject: [RFC PATCH net-next 04/11] net: geneve: constrain upper VLAN MTU using IFF_NO_VLAN_ROOM
Date:   Wed, 27 May 2020 14:25:05 -0700
Message-Id: <20200527212512.17901-5-edwin.peer@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527212512.17901-1-edwin.peer@broadcom.com>
References: <20200527212512.17901-1-edwin.peer@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Constrain the MTU of upper VLAN devices if the MTU of the Geneve device
is configured to its default optimal size, which does not leave space
for a nested VLAN tag without causing fragmentation. If the underlying
best MTU is not known, then the worst case is assumed and any upper VLAN
devices will always be adjusted to accommodate the VLAN tag.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
---
 drivers/net/geneve.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 8d790cf85b21..9c8e6f242f77 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -67,6 +67,7 @@ struct geneve_dev {
 	bool		   use_udp6_rx_checksums;
 	bool		   ttl_inherit;
 	enum ifla_geneve_df df;
+	int		   best_mtu;
 };
 
 struct geneve_sock {
@@ -1020,12 +1021,15 @@ static netdev_tx_t geneve_xmit(struct sk_buff *skb, struct net_device *dev)
 
 static int geneve_change_mtu(struct net_device *dev, int new_mtu)
 {
+	struct geneve_dev *geneve = netdev_priv(dev);
+
 	if (new_mtu > dev->max_mtu)
 		new_mtu = dev->max_mtu;
 	else if (new_mtu < dev->min_mtu)
 		new_mtu = dev->min_mtu;
 
 	dev->mtu = new_mtu;
+	__vlan_constrain_mtu(dev, geneve->best_mtu);
 	return 0;
 }
 
@@ -1497,7 +1501,6 @@ static void geneve_link_config(struct net_device *dev,
 			       struct ip_tunnel_info *info, struct nlattr *tb[])
 {
 	struct geneve_dev *geneve = netdev_priv(dev);
-	int ldev_mtu = 0;
 
 	if (tb[IFLA_MTU]) {
 		geneve_change_mtu(dev, nla_get_u32(tb[IFLA_MTU]));
@@ -1510,7 +1513,7 @@ static void geneve_link_config(struct net_device *dev,
 		struct rtable *rt = ip_route_output_key(geneve->net, &fl4);
 
 		if (!IS_ERR(rt) && rt->dst.dev) {
-			ldev_mtu = rt->dst.dev->mtu - GENEVE_IPV4_HLEN;
+			geneve->best_mtu = rt->dst.dev->mtu - GENEVE_IPV4_HLEN;
 			ip_rt_put(rt);
 		}
 		break;
@@ -1526,17 +1529,19 @@ static void geneve_link_config(struct net_device *dev,
 				NULL, 0);
 
 		if (rt && rt->dst.dev)
-			ldev_mtu = rt->dst.dev->mtu - GENEVE_IPV6_HLEN;
+			geneve->best_mtu = rt->dst.dev->mtu - GENEVE_IPV6_HLEN;
 		ip6_rt_put(rt);
 		break;
 	}
 #endif
 	}
 
-	if (ldev_mtu <= 0)
+	geneve->best_mtu -= info->options_len;
+
+	if (geneve->best_mtu <= 0)
 		return;
 
-	geneve_change_mtu(dev, ldev_mtu - info->options_len);
+	geneve_change_mtu(dev, geneve->best_mtu);
 }
 
 static int geneve_newlink(struct net *net, struct net_device *dev,
-- 
2.26.2

