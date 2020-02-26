Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06AC1170677
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 18:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgBZRrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 12:47:49 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35910 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgBZRrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 12:47:49 -0500
Received: by mail-pg1-f193.google.com with SMTP id d9so32129pgu.3
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 09:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wPHpIqXAqt+du0BxNpnYvniWJILbeASE2RtqbgYeh3I=;
        b=mNrb3to3/HX1Sa1VMpIdcaMMINXbOi2hcuvUqYjiLSLOIWoZD8Wn9eB6CzhksuhEc1
         EJo2zw4tMjrB2XULbKJNuHwbtUu9f9rgupsz9TvXy/NpuvmrictoSY7kiZ3OyC6BlqhH
         uSyKRspX40PtOje1Bq7U5qAOcSEykcHOO872dSFTiosKSCzvV9F2v+XxxVC2J1pPG7as
         HrxxlCCT1QL73x29cH7C8WB3IMr0n3dgGjAiHSnHCsUWG9MA/TO6NMs4D5kDzAlRSbxG
         1VOuW6BeT0nXnsYjeUv3YI59SHNU/IDLl+BirrY870To/RgCaS/J0mOg5lVcK03lhEDS
         tWJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wPHpIqXAqt+du0BxNpnYvniWJILbeASE2RtqbgYeh3I=;
        b=U0szwhe9FEfL12kFClJjH2eE+aLIGbm0B6gaTuhoIMdB4ohWj6gGeug/wIXITTzcUd
         RG3jLmJyplmUbyL7wTziKFL/rKqev+m3Li2nkHWaLwn4HsJ4rlo4NYrqn0m7D/otdLa8
         bbMzm6CxDqJlSRpvaaiEaf94MsJWoFYyI+DugvWNla5Nqbd3Oy6b3ei2BKYeyAYgqSQ6
         EeV0Tc2UPfnWT6ic50N8upqGELfi02NFp1Suxdvol7/yLcEMy8HjeD9pR6Xap2/c1sy7
         1oTMUtobrkStwrgTdUzvWpb+IRNESXrdhX7zfZtx571Br6FW06K2sABsat1MUdYgEmcU
         RTlQ==
X-Gm-Message-State: APjAAAUL5ej6OdqIyXKbqkS28kHm6fk/w0PQy2rnflaxWia15XlXiU3l
        vJUebkUZFIsf1UBWrHLi2Sk=
X-Google-Smtp-Source: APXvYqx3k7OwJOCZAoprTs42mpFFVbUkvzRCaHoFN3nWFsv3DI72mxXCcZZ9iXO6F055XCjH31ZfwA==
X-Received: by 2002:a63:504d:: with SMTP id q13mr96342pgl.315.1582739267867;
        Wed, 26 Feb 2020 09:47:47 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id s130sm4074394pfc.62.2020.02.26.09.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 09:47:46 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 06/10] net: rmnet: print error message when command fails
Date:   Wed, 26 Feb 2020 17:47:40 +0000
Message-Id: <20200226174740.5636-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When rmnet netlink command fails, it doesn't print any error message.
So, users couldn't know the exact reason.
In order to tell the exact reason to the user, the extack error message
is used in this patch.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 .../ethernet/qualcomm/rmnet/rmnet_config.c    | 26 ++++++++++++-------
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   | 10 +++----
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.h   |  3 ++-
 3 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index c8b1bfe127ac..93745cd45c29 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -141,11 +141,10 @@ static int rmnet_newlink(struct net *src_net, struct net_device *dev,
 	}
 
 	real_dev = __dev_get_by_index(src_net, nla_get_u32(tb[IFLA_LINK]));
-	if (!real_dev || !dev)
+	if (!real_dev || !dev) {
+		NL_SET_ERR_MSG_MOD(extack, "link does not exist");
 		return -ENODEV;
-
-	if (!data[IFLA_RMNET_MUX_ID])
-		return -EINVAL;
+	}
 
 	ep = kzalloc(sizeof(*ep), GFP_ATOMIC);
 	if (!ep)
@@ -158,7 +157,7 @@ static int rmnet_newlink(struct net *src_net, struct net_device *dev,
 		goto err0;
 
 	port = rmnet_get_port_rtnl(real_dev);
-	err = rmnet_vnd_newlink(mux_id, dev, port, real_dev, ep);
+	err = rmnet_vnd_newlink(mux_id, dev, port, real_dev, ep, extack);
 	if (err)
 		goto err1;
 
@@ -275,12 +274,16 @@ static int rmnet_rtnl_validate(struct nlattr *tb[], struct nlattr *data[],
 {
 	u16 mux_id;
 
-	if (!data || !data[IFLA_RMNET_MUX_ID])
+	if (!data || !data[IFLA_RMNET_MUX_ID]) {
+		NL_SET_ERR_MSG_MOD(extack, "MUX ID not specifies");
 		return -EINVAL;
+	}
 
 	mux_id = nla_get_u16(data[IFLA_RMNET_MUX_ID]);
-	if (mux_id > (RMNET_MAX_LOGICAL_EP - 1))
+	if (mux_id > (RMNET_MAX_LOGICAL_EP - 1)) {
+		NL_SET_ERR_MSG_MOD(extack, "invalid MUX ID");
 		return -ERANGE;
+	}
 
 	return 0;
 }
@@ -414,11 +417,16 @@ int rmnet_add_bridge(struct net_device *rmnet_dev,
 	/* If there is more than one rmnet dev attached, its probably being
 	 * used for muxing. Skip the briding in that case
 	 */
-	if (port->nr_rmnet_devs > 1)
+	if (port->nr_rmnet_devs > 1) {
+		NL_SET_ERR_MSG_MOD(extack, "more than one rmnet dev attached");
 		return -EINVAL;
+	}
 
-	if (rmnet_is_real_dev_registered(slave_dev))
+	if (rmnet_is_real_dev_registered(slave_dev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "dev is already attached another rmnet dev");
 		return -EBUSY;
+	}
 
 	err = rmnet_register_real_device(slave_dev);
 	if (err)
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index a26e76e9d382..90c19033ebe0 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -224,16 +224,16 @@ void rmnet_vnd_setup(struct net_device *rmnet_dev)
 int rmnet_vnd_newlink(u8 id, struct net_device *rmnet_dev,
 		      struct rmnet_port *port,
 		      struct net_device *real_dev,
-		      struct rmnet_endpoint *ep)
+		      struct rmnet_endpoint *ep,
+		      struct netlink_ext_ack *extack)
 {
 	struct rmnet_priv *priv = netdev_priv(rmnet_dev);
 	int rc;
 
-	if (ep->egress_dev)
-		return -EINVAL;
-
-	if (rmnet_get_endpoint(port, id))
+	if (rmnet_get_endpoint(port, id)) {
+		NL_SET_ERR_MSG_MOD(extack, "MUX ID already exists");
 		return -EBUSY;
+	}
 
 	rmnet_dev->hw_features = NETIF_F_RXCSUM;
 	rmnet_dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
index 54cbaf3c3bc4..d8fa76e8e9c4 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
@@ -11,7 +11,8 @@ int rmnet_vnd_do_flow_control(struct net_device *dev, int enable);
 int rmnet_vnd_newlink(u8 id, struct net_device *rmnet_dev,
 		      struct rmnet_port *port,
 		      struct net_device *real_dev,
-		      struct rmnet_endpoint *ep);
+		      struct rmnet_endpoint *ep,
+		      struct netlink_ext_ack *extack);
 int rmnet_vnd_dellink(u8 id, struct rmnet_port *port,
 		      struct rmnet_endpoint *ep);
 void rmnet_vnd_rx_fixup(struct sk_buff *skb, struct net_device *dev);
-- 
2.17.1

