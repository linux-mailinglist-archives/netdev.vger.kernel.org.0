Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474E0202A5F
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 13:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730006AbgFULqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 07:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729986AbgFULqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 07:46:22 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C34C061794
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 04:46:21 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id ga4so1466038ejb.11
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 04:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sKAJG4HHlI042Ouwfo2siqx4jA6VZx3K+THkxXSLEzk=;
        b=kmLLUsOOC4Bo9P/K3QpYD+3JS/Yi/tZOXazWCiIk7EwT7zLbw386WTa1bawYBbCVX5
         ty6pq4N78Y7SwIg83d5OuhAQBeW2k8hnH52KTFaJOxvdtWkYfd07Sz8wduKnbJGd/N3H
         I60hJEUZqG2xkyYPpPKI4q4VYG2yl1tdHraqNqwKazssNEXmbYOunvU4uaJP6nI4ceXy
         Fnm95LqKvEi5sKReUzFNw3/VCdY1gS4gJvkvtZWoo26uL8QdsZBiw64FX2MzIjUiQdOr
         dv2YZD/71hlYD6PqOD+fRezRiE6j518kkS+j4SxajBKwbSIHjHpBuHy2rfyT0lTezsGg
         Mo6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sKAJG4HHlI042Ouwfo2siqx4jA6VZx3K+THkxXSLEzk=;
        b=nAXFMkc11xzhzHxG9S+9vgbajRx+8ILT13VoqPLhD0FBCsyANg91KPn+iGgnNtQ3r+
         DKDw9TPzHH+bcGT2l4jO/XBHw+uLPQY8Ka+BLkCdD1l9DbklEj7QAuC6ScrXTPbJZ0la
         XLoy3zrGluTFh+FkS59L8Lrad+m3iIn9+kb0tq52o+tS7dfzBICalaGpN4ims3pF1MuW
         HIoK7iqDapf8IohIQM6oVzdw13D37BCVTVRJ9F8fssCvksyuts2CHZe738ZW7pCVZJOn
         GpCnX1HjuPp0q9ETKhMHq1W6rSbSIZGxfhFsPHqkJO5ZL859yhVv9OSlEmrm6R24N17r
         tNiQ==
X-Gm-Message-State: AOAM533c5kb73IxJb3GuyOgAGCcm1yeAkNOrFTljCwWHX2O7QjOxFhRw
        HTw0kK7//IIkv6wy8H57Jy8=
X-Google-Smtp-Source: ABdhPJxIT3pVPkUJBKwt2vLPHA/mQIEX3SeaURWPlnE6NZN65FOpPr0QvA3dho8mTrR+U2DWxd8yBQ==
X-Received: by 2002:a17:906:8688:: with SMTP id g8mr1571972ejx.505.1592739980512;
        Sun, 21 Jun 2020 04:46:20 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id k23sm9155508ejg.89.2020.06.21.04.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 04:46:20 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com
Subject: [PATCH net-next 2/5] net: mscc: ocelot: make the NPI port a proper target for FDB and MDB
Date:   Sun, 21 Jun 2020 14:46:00 +0300
Message-Id: <20200621114603.119608-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200621114603.119608-1-olteanv@gmail.com>
References: <20200621114603.119608-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When used in DSA mode (as seen in Felix), the DEST_IDX in the MAC table
should point to the PGID for the CPU port (PGID_CPU) and not for the
Ethernet port where the CPU queues are redirected to (also known as Node
Processor Interface - NPI).

Because for Felix this distinction shouldn't really matter (from DSA
perspective, the NPI port _is_ the CPU port), make the ocelot library
act upon the CPU port when NPI mode is enabled. This has no effect for
the mscc_ocelot driver for VSC7514, because that does not use NPI (and
ocelot->npi is -1).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 922c3e855c3a..4aadb65a6af8 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -535,6 +535,10 @@ int ocelot_fdb_add(struct ocelot *ocelot, int port,
 		   const unsigned char *addr, u16 vid)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	int pgid = port;
+
+	if (port == ocelot->npi)
+		pgid = PGID_CPU;
 
 	if (!vid) {
 		if (!ocelot_port->vlan_aware)
@@ -550,7 +554,7 @@ int ocelot_fdb_add(struct ocelot *ocelot, int port,
 			return -EINVAL;
 	}
 
-	return ocelot_mact_learn(ocelot, port, addr, vid, ENTRYTYPE_LOCKED);
+	return ocelot_mact_learn(ocelot, pgid, addr, vid, ENTRYTYPE_LOCKED);
 }
 EXPORT_SYMBOL(ocelot_fdb_add);
 
@@ -953,6 +957,9 @@ int ocelot_port_obj_add_mdb(struct net_device *dev,
 	u16 vid = mdb->vid;
 	bool new = false;
 
+	if (port == ocelot->npi)
+		port = ocelot->num_phys_ports;
+
 	if (!vid)
 		vid = ocelot_port->pvid;
 
@@ -997,6 +1004,9 @@ int ocelot_port_obj_del_mdb(struct net_device *dev,
 	int port = priv->chip_port;
 	u16 vid = mdb->vid;
 
+	if (port == ocelot->npi)
+		port = ocelot->num_phys_ports;
+
 	if (!vid)
 		vid = ocelot_port->pvid;
 
-- 
2.25.1

