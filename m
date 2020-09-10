Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF43326431C
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 12:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730294AbgIJKAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 06:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730560AbgIJKAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 06:00:09 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1ECCC061573;
        Thu, 10 Sep 2020 03:00:08 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id s13so5015769wmh.4;
        Thu, 10 Sep 2020 03:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pAh7hXPGRHBjo/PFoe0HlRkn4NDf5lJ5Fqfadp23JQo=;
        b=XkPaw/Bf2ZxPsXS0G3PAgfhAF2zYa/Z0822udedqbRSAt5+TsgEN7bpgFl8cugEIws
         gcqgd40aF6cB1PvDV7dJvgAnJ4QpkOcYuZQxaavlP8XcIxsfudNrnMfcJXiyn8sRR1Xt
         jN17ZW3MVjyLqRLaRxWC1g1a+IGXew+dphACe8szgXVSfLl9oIJeCLRSonTYqYmvAKnA
         bzkItSBDuT+z5hgkDyFlg4IXTon9hLvlqUIrKWhbxxoemf1MzBhMKlGlQntnbiON6mgQ
         minX3OX0oPv2P/s0mrzq63llnMrXoSZ0xb7+Te6NRzxxe8lo7HDt/UTzzUUF7mAJ/7+e
         V7qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pAh7hXPGRHBjo/PFoe0HlRkn4NDf5lJ5Fqfadp23JQo=;
        b=bAZWnI8kKgvuvAuDDS2TdQFcJEWlFLcusaOXYYRm3y42H8R/Df8syDbY3SGpSQIAbV
         jVqQuDV2XKsdcypUXVg6n7nm3AQo44F+RQtuFyHleO8KXMCMXrndHy5B/njMBdCbmnHT
         AD5LP9L1vvh6lNpQShADHNEOEQz/16q9j6NxI0xNE7+udQL4ZT+7KG4K3A3UzFsI75Hv
         WwKbRMxx3eZj9bZfBcEoVYBqETE4F5H+YQuekXM9ZNd065wDYaPaBLr7O03YRB6S3KEQ
         bCJ40yd5iBM5Mf2wrkF2I8sPrZE91VsBa7o7x5rQ2GlK3lLJd5n080HrXEfihpJ7yUJs
         DpBw==
X-Gm-Message-State: AOAM533WPCO1xKQcr3HM6Dudvg0yPjtGztczZWkfqAkURjVsIyKHnFvX
        GF0GKhWbsiSiVsEItNY5LJh7KREG3p4=
X-Google-Smtp-Source: ABdhPJw/Oq0Me8hNHlZrBHLTOH04QA6Ldk15PpFJKErIMLiqbOg+X8LkFaexnffoQFPh5M27G1UPEQ==
X-Received: by 2002:a05:600c:2183:: with SMTP id e3mr8187778wme.49.1599732006529;
        Thu, 10 Sep 2020 03:00:06 -0700 (PDT)
Received: from localhost.localdomain ([178.60.199.158])
        by smtp.gmail.com with ESMTPSA id v128sm2872960wme.2.2020.09.10.03.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 03:00:06 -0700 (PDT)
From:   Era Mayflower <mayflowerera@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mayflowerera@gmail.com
Subject: [PATCH v2] macsec: Support 32bit PN netlink attribute for XPN links
Date:   Thu, 10 Sep 2020 09:56:09 +0000
Message-Id: <20200910095609.17999-1-mayflowerera@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow using 32bit netlink attribute for packet number when creating or
updating SA in an XPN link.
Now utilities like iproute2's `ip` do not have to know the link type
(XPN or not) when setting the packet number field of an SA.

Signed-off-by: Era Mayflower <mayflowerera@gmail.com>
---
 drivers/net/macsec.c | 95 ++++++++++++++++++++++++++++++++------------
 1 file changed, 69 insertions(+), 26 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index e56547bfdac9..7d3c3a38ea81 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1691,8 +1691,7 @@ static bool validate_add_rxsa(struct nlattr **attrs)
 	if (nla_get_u8(attrs[MACSEC_SA_ATTR_AN]) >= MACSEC_NUM_AN)
 		return false;
 
-	if (attrs[MACSEC_SA_ATTR_PN] &&
-	    *(u64 *)nla_data(attrs[MACSEC_SA_ATTR_PN]) == 0)
+	if (attrs[MACSEC_SA_ATTR_PN] && nla_get_u64(attrs[MACSEC_SA_ATTR_PN]) == 0)
 		return false;
 
 	if (attrs[MACSEC_SA_ATTR_ACTIVE]) {
@@ -1714,7 +1713,6 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 	struct macsec_rx_sc *rx_sc;
 	struct macsec_rx_sa *rx_sa;
 	unsigned char assoc_num;
-	int pn_len;
 	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
 	struct nlattr *tb_sa[MACSEC_SA_ATTR_MAX + 1];
 	int err;
@@ -1747,12 +1745,26 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 	}
 
-	pn_len = secy->xpn ? MACSEC_XPN_PN_LEN : MACSEC_DEFAULT_PN_LEN;
-	if (nla_len(tb_sa[MACSEC_SA_ATTR_PN]) != pn_len) {
-		pr_notice("macsec: nl: add_rxsa: bad pn length: %d != %d\n",
-			  nla_len(tb_sa[MACSEC_SA_ATTR_PN]), pn_len);
-		rtnl_unlock();
-		return -EINVAL;
+	if (tb_sa[MACSEC_SA_ATTR_PN]) {
+		switch (nla_len(tb_sa[MACSEC_SA_ATTR_PN])) {
+		case MACSEC_DEFAULT_PN_LEN:
+			break;
+
+		case MACSEC_XPN_PN_LEN:
+			if (secy->xpn)
+				break;
+
+			pr_notice("macsec: nl: add_rxsa: pn length on non-xpn links must be %d\n",
+				  MACSEC_DEFAULT_PN_LEN);
+			rtnl_unlock();
+			return -EINVAL;
+
+		default:
+			pr_notice("macsec: nl: add_rxsa: pn length must be %d or %d\n",
+				  MACSEC_DEFAULT_PN_LEN, MACSEC_XPN_PN_LEN);
+			rtnl_unlock();
+			return -EINVAL;
+		}
 	}
 
 	if (secy->xpn) {
@@ -1934,7 +1946,7 @@ static bool validate_add_txsa(struct nlattr **attrs)
 	if (nla_get_u8(attrs[MACSEC_SA_ATTR_AN]) >= MACSEC_NUM_AN)
 		return false;
 
-	if (nla_get_u32(attrs[MACSEC_SA_ATTR_PN]) == 0)
+	if (nla_get_u64(attrs[MACSEC_SA_ATTR_PN]) == 0)
 		return false;
 
 	if (attrs[MACSEC_SA_ATTR_ACTIVE]) {
@@ -1956,7 +1968,6 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 	struct macsec_tx_sc *tx_sc;
 	struct macsec_tx_sa *tx_sa;
 	unsigned char assoc_num;
-	int pn_len;
 	struct nlattr *tb_sa[MACSEC_SA_ATTR_MAX + 1];
 	bool was_operational;
 	int err;
@@ -1989,10 +2000,22 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 	}
 
-	pn_len = secy->xpn ? MACSEC_XPN_PN_LEN : MACSEC_DEFAULT_PN_LEN;
-	if (nla_len(tb_sa[MACSEC_SA_ATTR_PN]) != pn_len) {
-		pr_notice("macsec: nl: add_txsa: bad pn length: %d != %d\n",
-			  nla_len(tb_sa[MACSEC_SA_ATTR_PN]), pn_len);
+	switch (nla_len(tb_sa[MACSEC_SA_ATTR_PN])) {
+	case MACSEC_DEFAULT_PN_LEN:
+		break;
+
+	case MACSEC_XPN_PN_LEN:
+		if (secy->xpn)
+			break;
+
+		pr_notice("macsec: nl: add_txsa: pn length on non-xpn links must be %d\n",
+			  MACSEC_DEFAULT_PN_LEN);
+		rtnl_unlock();
+		return -EINVAL;
+
+	default:
+		pr_notice("macsec: nl: add_txsa: pn length must be %d or %d\n",
+			  MACSEC_DEFAULT_PN_LEN, MACSEC_XPN_PN_LEN);
 		rtnl_unlock();
 		return -EINVAL;
 	}
@@ -2288,7 +2311,7 @@ static bool validate_upd_sa(struct nlattr **attrs)
 	if (nla_get_u8(attrs[MACSEC_SA_ATTR_AN]) >= MACSEC_NUM_AN)
 		return false;
 
-	if (attrs[MACSEC_SA_ATTR_PN] && nla_get_u32(attrs[MACSEC_SA_ATTR_PN]) == 0)
+	if (attrs[MACSEC_SA_ATTR_PN] && nla_get_u64(attrs[MACSEC_SA_ATTR_PN]) == 0)
 		return false;
 
 	if (attrs[MACSEC_SA_ATTR_ACTIVE]) {
@@ -2332,12 +2355,22 @@ static int macsec_upd_txsa(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (tb_sa[MACSEC_SA_ATTR_PN]) {
-		int pn_len;
+		switch (nla_len(tb_sa[MACSEC_SA_ATTR_PN])) {
+		case MACSEC_DEFAULT_PN_LEN:
+			break;
+
+		case MACSEC_XPN_PN_LEN:
+			if (secy->xpn)
+				break;
+
+			pr_notice("macsec: nl: upd_txsa: pn length on non-xpn links must be %d\n",
+				  MACSEC_DEFAULT_PN_LEN);
+			rtnl_unlock();
+			return -EINVAL;
 
-		pn_len = secy->xpn ? MACSEC_XPN_PN_LEN : MACSEC_DEFAULT_PN_LEN;
-		if (nla_len(tb_sa[MACSEC_SA_ATTR_PN]) != pn_len) {
-			pr_notice("macsec: nl: upd_txsa: bad pn length: %d != %d\n",
-				  nla_len(tb_sa[MACSEC_SA_ATTR_PN]), pn_len);
+		default:
+			pr_notice("macsec: nl: upd_txsa: pn length must be %d or %d\n",
+				  MACSEC_DEFAULT_PN_LEN, MACSEC_XPN_PN_LEN);
 			rtnl_unlock();
 			return -EINVAL;
 		}
@@ -2429,12 +2462,22 @@ static int macsec_upd_rxsa(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (tb_sa[MACSEC_SA_ATTR_PN]) {
-		int pn_len;
+		switch (nla_len(tb_sa[MACSEC_SA_ATTR_PN])) {
+		case MACSEC_DEFAULT_PN_LEN:
+			break;
+
+		case MACSEC_XPN_PN_LEN:
+			if (secy->xpn)
+				break;
 
-		pn_len = secy->xpn ? MACSEC_XPN_PN_LEN : MACSEC_DEFAULT_PN_LEN;
-		if (nla_len(tb_sa[MACSEC_SA_ATTR_PN]) != pn_len) {
-			pr_notice("macsec: nl: upd_rxsa: bad pn length: %d != %d\n",
-				  nla_len(tb_sa[MACSEC_SA_ATTR_PN]), pn_len);
+			pr_notice("macsec: nl: upd_rxsa: pn length on non-xpn links must be %d\n",
+				  MACSEC_DEFAULT_PN_LEN);
+			rtnl_unlock();
+			return -EINVAL;
+
+		default:
+			pr_notice("macsec: nl: upd_rxsa: pn length must be %d or %d\n",
+				  MACSEC_DEFAULT_PN_LEN, MACSEC_XPN_PN_LEN);
 			rtnl_unlock();
 			return -EINVAL;
 		}

base-commit: bc7d17d55762421b98089f5f7496e48cab89de50
-- 
2.20.1

