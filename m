Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6BA2FC492
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 00:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbhASXK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 18:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728901AbhASXJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 18:09:31 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8D9C06179A
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:08:20 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id bx12so9552557edb.8
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:08:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=myj5i3kT7k2aekuHYKS754bdh8A9rqPaCuXnQ8l2Esk=;
        b=mnGbed7KH85ILw3m5+k37DkHQW+y0uIH2oiq62BjsjRhh5av3ChIxzmaFzJoQxAi+4
         UwQhfMb0/Uk8LX4OVjriK4Hb1HACL0sSEEUEYFEbWKAnd8U7hQJIb8y7tYqryILI5hhD
         29HiMj1nTjVuppK6FUD2/RenCi0pQbDSYcYzEMMUzBkL6GDRPDYE4oIrb+7hX/YKjzY8
         H0PsSnNgxlf+835GkS1yeaBlshVv+GgfR2W+pt4y0jG4w1RSiLeZL8eawTYr4tqp1PCz
         iq1mYZZZzUGr045pwpLqYwjo2LMrzX8V7cT+OPfr/HtoABHkiTGxQyDG3dNZoMuDGkB1
         Z+4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=myj5i3kT7k2aekuHYKS754bdh8A9rqPaCuXnQ8l2Esk=;
        b=RJK/hOxfwOLvJjHi0R7JrSzT56je3Z4iRZqSoSVIP/noHzTYmF5jBVrTsjXwTDibEi
         KAayNoIskabQx4Mn324BYrmgzVei4mQT+iSlWKOR/kPIp7Pfn7/f/6cEB91YEHWSKKqX
         wVqqUaSIDlw94LdgvV+BL1joreSSQIVdL/ncO6bSkzvlvSuSpU9Qo8mpsJS+YAOkQoIP
         xXdUkqqmFqPpvA+DXzg7jJ6HdSeBftb11xnvU7oC20udb0ueOnmt2xwgjG2OcJdN5XvS
         ubZgWdkJ3Vg7Avcfj8wCgBQ8aJ2I+FMXYDY0cVB6Mon1jXSLRBzoqYyVmdK10lw8fNMH
         e4og==
X-Gm-Message-State: AOAM533Pl7d5sAa//fVv34YiIsw5Tb4RMzITyHQWkWBLfVQJri2qwEoX
        FZ/gOHCH1RY0t2pBLjFe1Ho=
X-Google-Smtp-Source: ABdhPJyadyD3lFNOcQc2QM2iI51BGIDROPjcMIf03hkHTVKCA/g5+B6sWlh5heg3yT3drNcnOYhZTw==
X-Received: by 2002:aa7:cfda:: with SMTP id r26mr5063564edy.142.1611097699282;
        Tue, 19 Jan 2021 15:08:19 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id lh26sm94197ejb.119.2021.01.19.15.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 15:08:18 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
Subject: [PATCH v4 net-next 13/16] net: mscc: ocelot: export struct ocelot_frame_info
Date:   Wed, 20 Jan 2021 01:07:46 +0200
Message-Id: <20210119230749.1178874-14-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119230749.1178874-1-olteanv@gmail.com>
References: <20210119230749.1178874-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Because felix DSA must now be able to extract a frame in 2 stages over
MMIO (first the XFH then the frame data), it needs access to this
internal ocelot structure that holds the unpacked information from the
Extraction Frame Header.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot.c         | 4 ++--
 drivers/net/ethernet/mscc/ocelot.h         | 9 ---------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 4 ++--
 include/soc/mscc/ocelot.h                  | 9 +++++++++
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 506a997be8e7..adebec0be684 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -571,7 +571,7 @@ EXPORT_SYMBOL(ocelot_get_txtstamp);
  * bit 16: tag type 0: C-tag, 1: S-tag
  * bit 0-11: VID
  */
-static int ocelot_gen_ifh(u32 *ifh, struct frame_info *info)
+static int ocelot_gen_ifh(u32 *ifh, struct ocelot_frame_info *info)
 {
 	ifh[0] = IFH_INJ_BYPASS | ((0x1ff & info->rew_op) << 21);
 	ifh[1] = (0xf00 & info->port) >> 8;
@@ -597,7 +597,7 @@ EXPORT_SYMBOL(ocelot_can_inject);
 void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 			      u32 rew_op, struct sk_buff *skb)
 {
-	struct frame_info info = {};
+	struct ocelot_frame_info info = {};
 	u32 ifh[OCELOT_TAG_LEN / 4];
 	unsigned int i, count, last;
 
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index e8621dbc14f7..4585e5c5d9cb 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -32,15 +32,6 @@
 
 #define OCELOT_PTP_QUEUE_SZ	128
 
-struct frame_info {
-	u32 len;
-	u16 port;
-	u16 vid;
-	u8 tag_type;
-	u16 rew_op;
-	u32 timestamp;	/* rew_val */
-};
-
 struct ocelot_port_tc {
 	bool block_shared;
 	unsigned long offload_cnt;
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 4bd3b59eba1b..f07170ce76d9 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -532,7 +532,7 @@ static int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
 	return 0;
 }
 
-static int ocelot_parse_ifh(u32 *_ifh, struct frame_info *info)
+static int ocelot_parse_ifh(u32 *_ifh, struct ocelot_frame_info *info)
 {
 	u8 llen, wlen;
 	u64 ifh[2];
@@ -606,10 +606,10 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 
 	while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp)) {
 		struct skb_shared_hwtstamps *shhwtstamps;
+		struct ocelot_frame_info info = {};
 		struct ocelot_port_private *priv;
 		struct ocelot_port *ocelot_port;
 		u64 tod_in_ns, full_ts_in_ns;
-		struct frame_info info = {};
 		struct net_device *dev;
 		u32 ifh[4], val, *buf;
 		struct timespec64 ts;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index eb81d05da134..d7169c56a64a 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -688,6 +688,15 @@ struct ocelot_policer {
 	u32 burst; /* bytes */
 };
 
+struct ocelot_frame_info {
+	u32 len;
+	u16 port;
+	u16 vid;
+	u8 tag_type;
+	u16 rew_op;
+	u32 timestamp;	/* rew_val */
+};
+
 #define ocelot_read_ix(ocelot, reg, gi, ri) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
 #define ocelot_read_gix(ocelot, reg, gi) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi))
 #define ocelot_read_rix(ocelot, reg, ri) __ocelot_read_ix(ocelot, reg, reg##_RSZ * (ri))
-- 
2.25.1

