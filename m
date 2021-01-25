Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1AD302EA2
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 23:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733037AbhAYWF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 17:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733144AbhAYWFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 17:05:08 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6191C061574
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 14:04:25 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id d22so17427025edy.1
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 14:04:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TBSx4XIJtMGHAQY0/1r1qqjVrggCv03U4scN9BHN/Sg=;
        b=A7Gclv56ePABg8JE7w2AxfsSFCHWG4e2gfjj8XXyro2xPy/9Dut7NJU45CcB00Tp5x
         bq7w2sgUT1JGKncMEjJERyWpoXQ2bBWhFtkodtX2CMtY19SBZMMS5u3dYz8AUM7VJ9y9
         3RyOjevHcVbGRoKZDndFBa6W768ar2lIG9KkG+uMMMAWK9k1jHwgU/kK+msly8omYQYr
         G2pcOR4cj/h3bBKMcqq56IqlMCDqj9Q/dmEW853bvfZ6w24VDSgGE1tFViFEP68Yx7Yu
         LLH0onFhWau/xvLp3YPqsi276OrTpISDzr27EpwD1aVoa3HmwrwJHKPeDHhoWfW3HIEH
         GprQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TBSx4XIJtMGHAQY0/1r1qqjVrggCv03U4scN9BHN/Sg=;
        b=I9J346HQR5Yat5hVh+owXMI5LfK0fSEP1zf2or0lKKw6qIpUsFCw8ARaCx6vwlyFBN
         G6KWPkVuFxXmYDpxZo4ODA3LAEddGBhFXsIGLMgPa/eLnj0le2NjBYuCxWO9Qca9wkT1
         KW58qHM63GLZhYWhojksQQlnkjrn+rrETk44b+ijsG6/js2Mv3wT3ECkWIsjwG4yc8Eo
         LtBqX0Nab5RUy5K25GlVJJ5jSA3bMSpqldVmDcInpEB2d4xYUNh06DpzNtk891cpOxA3
         47cilJ7KglnFRSe3Wptg7RdZ8brtd3o53ciZcFvfsy5/kl3RpgIGl9uKY81Gn/PvkiRY
         hk0g==
X-Gm-Message-State: AOAM5311oYyWELdVnRR7o3hx1UWrUi63lz4ZfaX+Q3J3cIHp0Dn0lxxa
        HY0yZr5IZ9sKpjxpk+zbW+dwqHB2RmQ=
X-Google-Smtp-Source: ABdhPJxSx9Vp+p8KZvIZFb85sicPHbApqItm0996uaNE0ttjlsJEet/hlFyD2Y5QTmzccA7tsroq0g==
X-Received: by 2002:a05:6402:1249:: with SMTP id l9mr2052198edw.375.1611612264538;
        Mon, 25 Jan 2021 14:04:24 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id s13sm1760555edi.92.2021.01.25.14.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 14:04:23 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v7 net-next 01/11] net: dsa: tag_8021q: add helpers to deduce whether a VLAN ID is RX or TX VLAN
Date:   Tue, 26 Jan 2021 00:03:23 +0200
Message-Id: <20210125220333.1004365-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210125220333.1004365-1-olteanv@gmail.com>
References: <20210125220333.1004365-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The sja1105 implementation can be blind about this, but the felix driver
doesn't do exactly what it's being told, so it needs to know whether it
is a TX or an RX VLAN, so it can install the appropriate type of TCAM
rule.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v7:
None.

Changes in v6:
None.

Changes in v5:
None.

Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
None.

 include/linux/dsa/8021q.h | 14 ++++++++++++++
 net/dsa/tag_8021q.c       | 15 +++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 88cd72dfa4e0..b12b05f1c8b4 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -64,6 +64,10 @@ int dsa_8021q_rx_source_port(u16 vid);
 
 u16 dsa_8021q_rx_subvlan(u16 vid);
 
+bool vid_is_dsa_8021q_rxvlan(u16 vid);
+
+bool vid_is_dsa_8021q_txvlan(u16 vid);
+
 bool vid_is_dsa_8021q(u16 vid);
 
 #else
@@ -123,6 +127,16 @@ u16 dsa_8021q_rx_subvlan(u16 vid)
 	return 0;
 }
 
+bool vid_is_dsa_8021q_rxvlan(u16 vid)
+{
+	return false;
+}
+
+bool vid_is_dsa_8021q_txvlan(u16 vid)
+{
+	return false;
+}
+
 bool vid_is_dsa_8021q(u16 vid)
 {
 	return false;
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 8e3e8a5b8559..008c1ec6e20c 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -133,10 +133,21 @@ u16 dsa_8021q_rx_subvlan(u16 vid)
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_rx_subvlan);
 
+bool vid_is_dsa_8021q_rxvlan(u16 vid)
+{
+	return (vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_RX;
+}
+EXPORT_SYMBOL_GPL(vid_is_dsa_8021q_rxvlan);
+
+bool vid_is_dsa_8021q_txvlan(u16 vid)
+{
+	return (vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_TX;
+}
+EXPORT_SYMBOL_GPL(vid_is_dsa_8021q_txvlan);
+
 bool vid_is_dsa_8021q(u16 vid)
 {
-	return ((vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_RX ||
-		(vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_TX);
+	return vid_is_dsa_8021q_rxvlan(vid) || vid_is_dsa_8021q_txvlan(vid);
 }
 EXPORT_SYMBOL_GPL(vid_is_dsa_8021q);
 
-- 
2.25.1

