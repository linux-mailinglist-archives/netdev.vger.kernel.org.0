Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9221F9C1F
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 17:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730447AbgFOPmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 11:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbgFOPmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 11:42:07 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D4BC061A0E;
        Mon, 15 Jun 2020 08:42:06 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id b82so48819wmb.1;
        Mon, 15 Jun 2020 08:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pAh7hXPGRHBjo/PFoe0HlRkn4NDf5lJ5Fqfadp23JQo=;
        b=p/CG2HSHM2Vxe4vLz6JvWu6mEtKmKXkCq0B/x44m6da1I5ZrtRakC7zNayfsgGYJ/h
         J9K9RIVonQf8JOUye3BZnWM/upjEOjsCSyqOXL3shw+IS+PA+F4lgT8W2di/wMeCfdPR
         6kD1XbdFuhEGPJStP0FpwxNzl0s4RyRrL1WC+HW8Bj3czn4ylJbX4bSd6qY9M6+gM2kw
         lUNFacrFoHUG2dyOU+mKPFy5sLWYGLMWuwRChR7i15D1FHfFjGbR8a09MOQVLtttCR50
         boup2IRiyzVOX1fBVxonOW06uVJxvKp5Fuv7OozW3vRZnpqy6/hWor009cSJ6Xdw6NNw
         K1ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pAh7hXPGRHBjo/PFoe0HlRkn4NDf5lJ5Fqfadp23JQo=;
        b=p6oTCIZ+C1sS6dRawb8dL8p9hqyBSsmdfpsqbueg/NoR0Wewl3M+Pk1ss1Y3aFuuPp
         GSGK2/ifagn27bEurmoNq5+uhyzHrWg1lvIfiXIa+PpdI2di2h/rvkE9K9SSS+aVG0hH
         wM2loJhfqEs9OwIJ/MsqntcDe8/Qa2R7uHV9MTNQ/FMj7kjoXBlwPfvKzNMCHEB25bac
         wdrbehnUCQnSH2E/q1HDJfUq15/Y8iFKFpwjcM8ZXOTjQAw/Zs8y4N/SEnTqu844/1Gn
         83ZaZDTVkR0E32C8Z1D7K8imFiYd86VtVmX0Q56NFbTLahY+y2x2FDw+xAch7lFVRBfJ
         AIwg==
X-Gm-Message-State: AOAM533LQiEqZ4QEOs/mpZgjxkkUxuiBUeZbc8ASxk+pcM1qgIDqcymW
        w/kM/OvbB7VUcAbIgX+imew=
X-Google-Smtp-Source: ABdhPJzdrmN0ipGP+6b4MmwTothhPefBA8JJKwdk/Nlz51fDYgqjXmyqB/K/wK7SJHUOMShdfkoRag==
X-Received: by 2002:a1c:dd44:: with SMTP id u65mr14738029wmg.180.1592235725422;
        Mon, 15 Jun 2020 08:42:05 -0700 (PDT)
Received: from unassigned-hostname.unassigned-domain (lputeaux-656-1-137-224.w193-252.abo.wanadoo.fr. [193.252.198.224])
        by smtp.gmail.com with ESMTPSA id r5sm25301554wrq.0.2020.06.15.08.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 08:42:04 -0700 (PDT)
From:   Era Mayflower <mayflowerera@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Era Mayflower <mayflowerera@gmail.com>
Subject: [PATCH] macsec: Support 32bit PN netlink attribute for XPN links
Date:   Tue, 16 Jun 2020 00:41:14 +0900
Message-Id: <20200615154114.13184-1-mayflowerera@gmail.com>
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

