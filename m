Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D867512BB51
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 22:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbfL0VhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 16:37:00 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35679 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbfL0Vg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 16:36:56 -0500
Received: by mail-wm1-f68.google.com with SMTP id p17so9333391wmb.0
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 13:36:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xfN39Oz9ZmU3S9X/6XdkFgiI/Sthvy4DYI4YSniTb7c=;
        b=EHSf9KU4DMULjdTdwlddRnmQSykp56QBoXBk4ODRMXPUSyLvNjUOPsmSE2udNOnQS/
         u8b/bdCBUlIXlzU2rk6PjACUoRNKoD0xhXf30k9peN5kdTrXojH80clpf+rCZ3dncS7j
         qtBdSW5hMZWJCXOOMT+5TWGAxsGSoL/M43hswvncinXwFM2rW/VIero2Fa2CUkHH6/cN
         i83BXLdVgZHpFyeFOJBYbEpxpYFrEOTNSYFB330YzdxqdwfXZ52CVzeEJTd2l5Tl4dP9
         Pn7PgHusWpfz0jWxgNNRdhGC7UAFPEOI/u3bqpvCcPaYrDK24NX+V3+9Jsy+NDPn9X+x
         bMdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xfN39Oz9ZmU3S9X/6XdkFgiI/Sthvy4DYI4YSniTb7c=;
        b=qS2B4EZ+jw90mKXIblFNWNuLjKu3dqhE8wGyi3Vz+VRRpE4Nq9rmNQxOzfB/01Slgg
         0EVD0a0NSMyijXMqMlLV811ZjPWrL0BYLCrzN8GsgESqzETXEyUET/HYpvi66tB8Rbyc
         CWRJanBC8PWqj7ijNZa9QJhX7XhfMbWg4s9DXwy++tpktFpIu76nUfvtBPIhi8Z2+HQo
         jss5Ft1pQv3TS8mWGgn89vyQPxxm6e6+R1Pmuk/aLHFg+XAcEiusXPaJthM9ttcyA/mA
         jE/6Hq7tkhkBKRg+pfEgE7qO8knpWKoGSQsmyB2mtgKmZyybA2z7J57vSdxpvEpE0N5u
         ETCg==
X-Gm-Message-State: APjAAAWnHX7hUvAm4hveTxZY9/FjjHzsNNN5Xqbd86aqUdrx/7OpIYcy
        jThqQRlauAQoslBbpjX8jZQ=
X-Google-Smtp-Source: APXvYqyBL+6WP0bmhhAf2VlbXadsIs26o5yafMWxF9EI/1YKtIn2K45SLSxKzy+bJaTZHfycQu3H/Q==
X-Received: by 2002:a1c:5a0a:: with SMTP id o10mr20177157wmb.114.1577482614478;
        Fri, 27 Dec 2019 13:36:54 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id v3sm36330504wru.32.2019.12.27.13.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2019 13:36:54 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 04/11] net: dsa: Pass pcs_poll flag from driver to PHYLINK
Date:   Fri, 27 Dec 2019 23:36:19 +0200
Message-Id: <20191227213626.4404-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191227213626.4404-1-olteanv@gmail.com>
References: <20191227213626.4404-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The DSA drivers that implement .phylink_mac_link_state should normally
register an interrupt for the PCS, from which they should call
phylink_mac_change(). However not all switches implement this, and those
who don't should set this flag in dsa_switch in the .setup callback, so
that PHYLINK will poll for a few ms until the in-band AN link timer
expires and the PCS state settles.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
- Patch is new.

 include/net/dsa.h | 5 +++++
 net/dsa/port.c    | 1 +
 2 files changed, 6 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index da5578db228e..dab1c4415f1e 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -283,6 +283,11 @@ struct dsa_switch {
 	 */
 	bool			vlan_filtering;
 
+	/* MAC PCS does not provide link state change interrupt, and requires
+	 * polling. Flag passed on to PHYLINK.
+	 */
+	bool			pcs_poll;
+
 	size_t num_ports;
 };
 
diff --git a/net/dsa/port.c b/net/dsa/port.c
index ffb5601f7ed6..774facb8d547 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -599,6 +599,7 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
 
 	dp->pl_config.dev = ds->dev;
 	dp->pl_config.type = PHYLINK_DEV;
+	dp->pl_config.pcs_poll = ds->pcs_poll;
 
 	dp->pl = phylink_create(&dp->pl_config, of_fwnode_handle(port_dn),
 				mode, &dsa_port_phylink_mac_ops);
-- 
2.17.1

