Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B3C31A8AD
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbhBMAP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbhBMAPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 19:15:48 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 684ADC06178B
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:14:34 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id bl23so2055655ejb.5
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SkZcJ2UK+EP0SMZLkH6rev/Av75d1+jR+VPI29qZh7k=;
        b=UAe0YGlxrvfivTAKKz6VRalK+3PwI8Hl29WKSUN/K/XouQkMqZzrU9nmVRvxo3Rkq0
         F7AYS07m+Hc10N0xExfLL4T+ua4N7C5Odg/tzWKS6EZR4dwRwNVC78fjzaSU7Jj72NBE
         YUr6U6J7WiWSauj4aJcrXfcEeW4OrmWaDC7x6tg+JuZGpgfjqiuadGZrLKY8fcOQBt/4
         /UQZTpgZ9opG4Fvg01eLWrVpwPduBHqnUxQa93CwJezBmz+9fRwPC+t4xjgtPa12Z9ej
         w682CgoRGfjzvg1KL0bf/wrUOD2OCM4wgtaeVF0e7sy1VU4TT2asbYXf+zlyhmafYTV7
         LOow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SkZcJ2UK+EP0SMZLkH6rev/Av75d1+jR+VPI29qZh7k=;
        b=F9m8mC+S11KAPGI/lA0zJY3K5V6cnyfefUQDOi2h4tloqoS93W0QDO1JenhkBqdtZv
         lTrN8OhdGpVTGmq2DkSKjCSQKc5S4CU2pBrSG/gsDn5IPhdfFr0SNgyPshpl5rnPZw6J
         g56RU56oT4+Pkb0a8bNW/87GJCBwXqOSPe72b8M7u4Hrt1h1TLaLKvARJsIHx6nP7spR
         0nbhCEj0MvFqqTK5E45pRPt3Ubi2UPVKZ7UvJ+WzDiRxbh0R/4igiSJCoh+rp9i8paK7
         hLFDboygvl0jeH5Yw/yAGFgM9r8Er1Vn07svAkAviKvlz5ooqmfU9CAow3KbWNFXQgZ7
         Ay0A==
X-Gm-Message-State: AOAM531SY6RsivH7DiYDXOZIzXeFnpnMu62fM+tR4PDG1z7UODl36Xc2
        nzfx+AWyWD345N+9bLur330=
X-Google-Smtp-Source: ABdhPJyELQCA0IyKnGWQ/3AI73CWnV1BNoYmmc8walZr1Kd2EwnFMU8FXQUnVT9Z7+szqa4zkK7SSw==
X-Received: by 2002:a17:906:7d4d:: with SMTP id l13mr5341999ejp.107.1613175273184;
        Fri, 12 Feb 2021 16:14:33 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id c1sm7015606eja.81.2021.02.12.16.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 16:14:32 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 06/12] net: dsa: tag_ocelot: avoid accessing ds->priv in ocelot_rcv
Date:   Sat, 13 Feb 2021 02:14:06 +0200
Message-Id: <20210213001412.4154051-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213001412.4154051-1-olteanv@gmail.com>
References: <20210213001412.4154051-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Taggers should be written to do something valid irrespective of the
switch driver that they are attached to. This is even more true now,
because since the introduction of the .change_tag_protocol method, a
certain tagger is not necessarily strictly associated with a driver any
longer, and I would like to be able to test all taggers with dsa_loop in
the future.

In the case of ocelot, it needs to move the classified VLAN from the DSA
tag into the skb if the port is VLAN-aware. We can allow it to do that
by looking at the dp->vlan_filtering property, no need to invoke
structures which are specific to ocelot.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_ocelot.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 16a1afd5b8e1..225b145fd131 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -177,12 +177,10 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 				  struct net_device *netdev,
 				  struct packet_type *pt)
 {
-	struct dsa_port *cpu_dp = netdev->dsa_ptr;
-	struct dsa_switch *ds = cpu_dp->ds;
-	struct ocelot *ocelot = ds->priv;
 	u64 src_port, qos_class;
 	u64 vlan_tci, tag_type;
 	u8 *start = skb->data;
+	struct dsa_port *dp;
 	u8 *extraction;
 	u16 vlan_tpid;
 
@@ -243,9 +241,10 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 	 * equal to the pvid of the ingress port and should not be used for
 	 * processing.
 	 */
+	dp = dsa_slave_to_port(skb->dev);
 	vlan_tpid = tag_type ? ETH_P_8021AD : ETH_P_8021Q;
 
-	if (ocelot->ports[src_port]->vlan_aware &&
+	if (dsa_port_is_vlan_filtering(dp) &&
 	    eth_hdr(skb)->h_proto == htons(vlan_tpid)) {
 		u16 dummy_vlan_tci;
 
-- 
2.25.1

