Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FFA1DD924
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 23:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730613AbgEUVLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 17:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730602AbgEUVK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 17:10:58 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80CEBC061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:10:58 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id x1so10539243ejd.8
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PTgQbBvJIIShG3QEmW73X3/Ipq2Ev776Y3DL4ft32sw=;
        b=li9Xr5iaHNp3pFaKKAu54IVx9n+Nz7cxtIB+wF56BXbN/zlWqfnUvpHAKjLt8NNU0s
         g/BChiatT9rWPiherEHgzEVnEN09ZOXZSzfhnp72o4Rx2TwMXKlOT//uT1JS7JReMXUf
         38SvXt4E1WbSsXIMexy3s2IZAgDDirQMnG0wvnDD/QsbTnB6LJPFjPh5NrURFVt5Mf6H
         w/AEaAC2TpcETxNBy2rW3Tv1SP0FC2unqUhRWslo/t9SpIaXUtse1LkkaYfmX5HmiVvP
         Mv3tiNFmkzvw7NAOdHjGWDDlu24id36mil5VH4150nwv6FkRUVNQH6bpXkEjMDqEVO3c
         Mx6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PTgQbBvJIIShG3QEmW73X3/Ipq2Ev776Y3DL4ft32sw=;
        b=l9lH4WfRnIPPj3Oj5clDbnmeEqv9G5izfIPIxlKC7H6FgMznM6G2EAmt0NU73ARF9c
         sTOKlz17Qe8Z8RLZ/lnCZlx3VIBF5bvcYurQX1B6PMaLPZMHiVAIj/lP489QziuBAAHS
         nfE3cvayVxkHiDAAVL2p6TvvsZZAwZbgoM0GC9SZ6Gsl0KRd8ZoItIc1MIGEOmoBhlkN
         cLkcDmBEX7UowwS/ad1hq1k4ervCDRCGtpDQM1npSEW90lJcsZRE0Ed48ZY0uuTOclPh
         x1A/bn9b8eZKno3zuCgG/H9kegvqZAUl+vZ6QzJwaEwnn8KfrHQBk8+tn3vqpjfkiGtp
         mB0Q==
X-Gm-Message-State: AOAM532qsmBEBANKPrYLMa81q3NXKKY0I2C7kQjEcRNsEVvNbxUIhv+E
        Ck+B8+crzk8+PIP4qPUoueM=
X-Google-Smtp-Source: ABdhPJytKUeSsqkoAfWiOO1nddJSz48dxCK6g4XFe0pRezN4qtspIP55qsl1BRDRICl/gdb/wbtRwQ==
X-Received: by 2002:a17:906:ae93:: with SMTP id md19mr5410426ejb.4.1590095457256;
        Thu, 21 May 2020 14:10:57 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id h8sm5797637edk.72.2020.05.21.14.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 14:10:56 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        ivecera@redhat.com, netdev@vger.kernel.org,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH RFC net-next 05/13] net: bridge: multicast: propagate br_mc_disabled_update() return
Date:   Fri, 22 May 2020 00:10:28 +0300
Message-Id: <20200521211036.668624-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200521211036.668624-1-olteanv@gmail.com>
References: <20200521211036.668624-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

Some Ethernet switches might not be able to support disabling multicast
flooding globally when e.g: several bridges span the same physical
device, propagate the return value of br_mc_disabled_update() such that
this propagates correctly to user-space.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_multicast.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index ad12fe3fca8c..9e93035b1483 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -809,7 +809,7 @@ static void br_ip6_multicast_port_query_expired(struct timer_list *t)
 }
 #endif
 
-static void br_mc_disabled_update(struct net_device *dev, bool value)
+static int br_mc_disabled_update(struct net_device *dev, bool value)
 {
 	struct switchdev_attr attr = {
 		.orig_dev = dev,
@@ -818,11 +818,13 @@ static void br_mc_disabled_update(struct net_device *dev, bool value)
 		.u.mc_disabled = !value,
 	};
 
-	switchdev_port_attr_set(dev, &attr);
+	return switchdev_port_attr_set(dev, &attr);
 }
 
 int br_multicast_add_port(struct net_bridge_port *port)
 {
+	int ret;
+
 	port->multicast_router = MDB_RTR_TYPE_TEMP_QUERY;
 
 	timer_setup(&port->multicast_router_timer,
@@ -833,8 +835,11 @@ int br_multicast_add_port(struct net_bridge_port *port)
 	timer_setup(&port->ip6_own_query.timer,
 		    br_ip6_multicast_port_query_expired, 0);
 #endif
-	br_mc_disabled_update(port->dev,
-			      br_opt_get(port->br, BROPT_MULTICAST_ENABLED));
+	ret = br_mc_disabled_update(port->dev,
+				    br_opt_get(port->br,
+					       BROPT_MULTICAST_ENABLED));
+	if (ret)
+		return ret;
 
 	port->mcast_stats = netdev_alloc_pcpu_stats(struct bridge_mcast_stats);
 	if (!port->mcast_stats)
@@ -2049,12 +2054,16 @@ static void br_multicast_start_querier(struct net_bridge *br,
 int br_multicast_toggle(struct net_bridge *br, unsigned long val)
 {
 	struct net_bridge_port *port;
+	int err = 0;
 
 	spin_lock_bh(&br->multicast_lock);
 	if (!!br_opt_get(br, BROPT_MULTICAST_ENABLED) == !!val)
 		goto unlock;
 
-	br_mc_disabled_update(br->dev, val);
+	err = br_mc_disabled_update(br->dev, val);
+	if (err && err != -EOPNOTSUPP)
+		goto unlock;
+
 	br_opt_toggle(br, BROPT_MULTICAST_ENABLED, !!val);
 	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED)) {
 		br_multicast_leave_snoopers(br);
@@ -2071,7 +2080,7 @@ int br_multicast_toggle(struct net_bridge *br, unsigned long val)
 unlock:
 	spin_unlock_bh(&br->multicast_lock);
 
-	return 0;
+	return err;
 }
 
 bool br_multicast_enabled(const struct net_device *dev)
-- 
2.25.1

