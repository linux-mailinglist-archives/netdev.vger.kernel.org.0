Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F83617DDE2
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 11:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgCIKrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 06:47:23 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52168 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgCIKrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 06:47:22 -0400
Received: by mail-wm1-f65.google.com with SMTP id a132so9262166wme.1;
        Mon, 09 Mar 2020 03:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XtqwjtmIf5AMvyLCxCN/pVItL3RVcnj/RQC1FQSPa4I=;
        b=q2v4uwUjs1KUcXxjpJxtH/Gb/uTzZsD2ZyeOAwxnefn5v6d0qPuAqSfU/VRW+jp5/t
         vtn5a7KAX+SFdRiSuRuV47liWdVzNfVsVgKrRoxrmvv1cTKkq4S7h5UqlcHVUX1+DSp5
         hsNY7HhuAix+JMcjjppwccTIGFzattUptQxTyKj7cUDzXwXh/Wj+bLinQaScxk62rEDy
         n3bBY5zdTKAxj47i1Fev3vGB8gpdH8QJn7hWGuUDZc790iYBmXxDEHdjkLtOmbAXGSSC
         YyRG4JVn1LGSiU3eZnrxalOvPFcR6MKsQE96XyYXDN+Gff1VG49M2l3tuBci+ENN4mWv
         x5mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XtqwjtmIf5AMvyLCxCN/pVItL3RVcnj/RQC1FQSPa4I=;
        b=H3Lp+/ZsZP69xXhgeXu3/NqzHulnu/OtEE8QufQHgKPo7dMzmGzunn6OTCB6cUdjWv
         C1ZToA9x0b4M/teKtYcUC7ubZQ7GDsGe2XbbhZARUk3Eh9BoDWtjVC1SGGkmZqLELNFH
         4gkh7EPC8cLPmIeGB5fhTPXQgl/K3rHxJmu7T0FO/p5bwuKE0/HAOl49/VbdZcuXzYzw
         gGpCYCJA8IKC1aw2ov5mfQ5/QUzOuolkgyWfrCVriBK2Is3/H1tor+puqfFvDt8ikjh2
         v5HAWEfvEkA7fytkBcXq0MhopyxmNQ+XFkdD8Az+WcUKKuowPZ9luXun7CLk3DRl2KDN
         nJXg==
X-Gm-Message-State: ANhLgQ09y2zqsej7H5SCDCfDwYToTx3/M2TPn9U9CAAOVlkpJqhE/EmJ
        CfDUftlK+v0It8A+aSDpHTM=
X-Google-Smtp-Source: ADFU+vusYsZ9wyob6B6waM55bwKBKG06WPWL9J+O+skvBUPXpXHhO+gR+HAbfNNU6YQMVIQWYLR8hA==
X-Received: by 2002:a1c:6605:: with SMTP id a5mr14740484wmc.32.1583750838843;
        Mon, 09 Mar 2020 03:47:18 -0700 (PDT)
Received: from localhost (hosting85.skyberate.net. [185.87.248.81])
        by smtp.gmail.com with ESMTPSA id t1sm14412099wrq.36.2020.03.09.03.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 03:47:18 -0700 (PDT)
From:   Era Mayflower <mayflowerera@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Era Mayflower <mayflowerera@gmail.com>
Subject: [PATCH v3 2/2] macsec: Netlink support of XPN cipher suites (IEEE 802.1AEbw)
Date:   Mon,  9 Mar 2020 19:47:02 +0000
Message-Id: <20200309194702.117050-2-mayflowerera@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200309194702.117050-1-mayflowerera@gmail.com>
References: <20200309194702.117050-1-mayflowerera@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Netlink support of extended packet number cipher suites,
allows adding and updating XPN macsec interfaces.

Added support in:
    * Creating interfaces with GCM-AES-XPN-128 and GCM-AES-XPN-256 suites.
    * Setting and getting 64bit packet numbers with of SAs.
    * Setting (only on SA creation) and getting ssci of SAs.
    * Setting salt when installing a SAK.

Added 2 cipher suite identifiers according to 802.1AE-2018 table 14-1:
    * MACSEC_CIPHER_ID_GCM_AES_XPN_128
    * MACSEC_CIPHER_ID_GCM_AES_XPN_256

In addition, added 2 new netlink attribute types:
    * MACSEC_SA_ATTR_SSCI
    * MACSEC_SA_ATTR_SALT

Depends on: macsec: Support XPN frame handling - IEEE 802.1AEbw.

Signed-off-by: Era Mayflower <mayflowerera@gmail.com>
---
 drivers/net/macsec.c           | 161 ++++++++++++++++++++++++++++++---
 include/net/macsec.h           |   3 +
 include/uapi/linux/if_macsec.h |   8 +-
 3 files changed, 157 insertions(+), 15 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index de9578daa..7083ee157 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -240,11 +240,13 @@ static struct macsec_cb *macsec_skb_cb(struct sk_buff *skb)
 #define MACSEC_PORT_ES (htons(0x0001))
 #define MACSEC_PORT_SCB (0x0000)
 #define MACSEC_UNDEF_SCI ((__force sci_t)0xffffffffffffffffULL)
+#define MACSEC_UNDEF_SSCI ((__force ssci_t)0xffffffff)
 
 #define MACSEC_GCM_AES_128_SAK_LEN 16
 #define MACSEC_GCM_AES_256_SAK_LEN 32
 
 #define DEFAULT_SAK_LEN MACSEC_GCM_AES_128_SAK_LEN
+#define DEFAULT_XPN false
 #define DEFAULT_SEND_SCI true
 #define DEFAULT_ENCRYPT false
 #define DEFAULT_ENCODING_SA 0
@@ -1306,6 +1308,7 @@ static int init_rx_sa(struct macsec_rx_sa *rx_sa, char *sak, int key_len,
 		return PTR_ERR(rx_sa->key.tfm);
 	}
 
+	rx_sa->ssci = MACSEC_UNDEF_SSCI;
 	rx_sa->active = false;
 	rx_sa->next_pn = 1;
 	refcount_set(&rx_sa->refcnt, 1);
@@ -1404,6 +1407,7 @@ static int init_tx_sa(struct macsec_tx_sa *tx_sa, char *sak, int key_len,
 		return PTR_ERR(tx_sa->key.tfm);
 	}
 
+	tx_sa->ssci = MACSEC_UNDEF_SSCI;
 	tx_sa->active = false;
 	refcount_set(&tx_sa->refcnt, 1);
 	spin_lock_init(&tx_sa->lock);
@@ -1447,6 +1451,16 @@ static int nla_put_sci(struct sk_buff *skb, int attrtype, sci_t value,
 	return nla_put_u64_64bit(skb, attrtype, (__force u64)value, padattr);
 }
 
+static ssci_t nla_get_ssci(const struct nlattr *nla)
+{
+	return (__force ssci_t)nla_get_u32(nla);
+}
+
+static int nla_put_ssci(struct sk_buff *skb, int attrtype, ssci_t value)
+{
+	return nla_put_u32(skb, attrtype, (__force u64)value);
+}
+
 static struct macsec_tx_sa *get_txsa_from_nl(struct net *net,
 					     struct nlattr **attrs,
 					     struct nlattr **tb_sa,
@@ -1562,11 +1576,14 @@ static const struct nla_policy macsec_genl_rxsc_policy[NUM_MACSEC_RXSC_ATTR] = {
 static const struct nla_policy macsec_genl_sa_policy[NUM_MACSEC_SA_ATTR] = {
 	[MACSEC_SA_ATTR_AN] = { .type = NLA_U8 },
 	[MACSEC_SA_ATTR_ACTIVE] = { .type = NLA_U8 },
-	[MACSEC_SA_ATTR_PN] = { .type = NLA_U32 },
+	[MACSEC_SA_ATTR_PN] = { .type = NLA_MIN_LEN, .len = 4 },
 	[MACSEC_SA_ATTR_KEYID] = { .type = NLA_BINARY,
 				   .len = MACSEC_KEYID_LEN, },
 	[MACSEC_SA_ATTR_KEY] = { .type = NLA_BINARY,
 				 .len = MACSEC_MAX_KEY_LEN, },
+	[MACSEC_SA_ATTR_SSCI] = { .type = NLA_U32 },
+	[MACSEC_SA_ATTR_SALT] = { .type = NLA_BINARY,
+				  .len = MACSEC_SALT_LEN, },
 };
 
 static const struct nla_policy macsec_genl_offload_policy[NUM_MACSEC_OFFLOAD_ATTR] = {
@@ -1639,7 +1656,8 @@ static bool validate_add_rxsa(struct nlattr **attrs)
 	if (nla_get_u8(attrs[MACSEC_SA_ATTR_AN]) >= MACSEC_NUM_AN)
 		return false;
 
-	if (attrs[MACSEC_SA_ATTR_PN] && nla_get_u32(attrs[MACSEC_SA_ATTR_PN]) == 0)
+	if (attrs[MACSEC_SA_ATTR_PN] &&
+	    *(u64 *)nla_data(attrs[MACSEC_SA_ATTR_PN]) == 0)
 		return false;
 
 	if (attrs[MACSEC_SA_ATTR_ACTIVE]) {
@@ -1661,6 +1679,7 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 	struct macsec_rx_sc *rx_sc;
 	struct macsec_rx_sa *rx_sa;
 	unsigned char assoc_num;
+	int pn_len;
 	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
 	struct nlattr *tb_sa[MACSEC_SA_ATTR_MAX + 1];
 	int err;
@@ -1693,6 +1712,29 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 	}
 
+	pn_len = secy->xpn ? MACSEC_XPN_PN_LEN : MACSEC_DEFAULT_PN_LEN;
+	if (nla_len(tb_sa[MACSEC_SA_ATTR_PN]) != pn_len) {
+		pr_notice("macsec: nl: add_rxsa: bad pn length: %d != %d\n",
+			  nla_len(tb_sa[MACSEC_SA_ATTR_PN]), pn_len);
+		rtnl_unlock();
+		return -EINVAL;
+	}
+
+	if (secy->xpn) {
+		if (!tb_sa[MACSEC_SA_ATTR_SSCI] || !tb_sa[MACSEC_SA_ATTR_SALT]) {
+			rtnl_unlock();
+			return -EINVAL;
+		}
+
+		if (nla_len(tb_sa[MACSEC_SA_ATTR_SALT]) != MACSEC_SALT_LEN) {
+			pr_notice("macsec: nl: add_rxsa: bad salt length: %d != %d\n",
+				  nla_len(tb_sa[MACSEC_SA_ATTR_SALT]),
+				  MACSEC_SA_ATTR_SALT);
+			rtnl_unlock();
+			return -EINVAL;
+		}
+	}
+
 	rx_sa = rtnl_dereference(rx_sc->sa[assoc_num]);
 	if (rx_sa) {
 		rtnl_unlock();
@@ -1715,7 +1757,7 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 
 	if (tb_sa[MACSEC_SA_ATTR_PN]) {
 		spin_lock_bh(&rx_sa->lock);
-		rx_sa->next_pn_halves.lower = nla_get_u32(tb_sa[MACSEC_SA_ATTR_PN]);
+		rx_sa->next_pn = nla_get_u64(tb_sa[MACSEC_SA_ATTR_PN]);
 		spin_unlock_bh(&rx_sa->lock);
 	}
 
@@ -1745,6 +1787,12 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 			goto cleanup;
 	}
 
+	if (secy->xpn) {
+		rx_sa->ssci = nla_get_ssci(tb_sa[MACSEC_SA_ATTR_SSCI]);
+		nla_memcpy(rx_sa->key.salt.bytes, tb_sa[MACSEC_SA_ATTR_SALT],
+			   MACSEC_SALT_LEN);
+	}
+
 	nla_memcpy(rx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEYID_LEN);
 	rcu_assign_pointer(rx_sc->sa[assoc_num], rx_sa);
 
@@ -1869,6 +1917,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 	struct macsec_tx_sc *tx_sc;
 	struct macsec_tx_sa *tx_sa;
 	unsigned char assoc_num;
+	int pn_len;
 	struct nlattr *tb_sa[MACSEC_SA_ATTR_MAX + 1];
 	bool was_operational;
 	int err;
@@ -1901,6 +1950,29 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 	}
 
+	pn_len = secy->xpn ? MACSEC_XPN_PN_LEN : MACSEC_DEFAULT_PN_LEN;
+	if (nla_len(tb_sa[MACSEC_SA_ATTR_PN]) != pn_len) {
+		pr_notice("macsec: nl: add_txsa: bad pn length: %d != %d\n",
+			  nla_len(tb_sa[MACSEC_SA_ATTR_PN]), pn_len);
+		rtnl_unlock();
+		return -EINVAL;
+	}
+
+	if (secy->xpn) {
+		if (!tb_sa[MACSEC_SA_ATTR_SSCI] || !tb_sa[MACSEC_SA_ATTR_SALT]) {
+			rtnl_unlock();
+			return -EINVAL;
+		}
+
+		if (nla_len(tb_sa[MACSEC_SA_ATTR_SALT]) != MACSEC_SALT_LEN) {
+			pr_notice("macsec: nl: add_txsa: bad salt length: %d != %d\n",
+				  nla_len(tb_sa[MACSEC_SA_ATTR_SALT]),
+				  MACSEC_SA_ATTR_SALT);
+			rtnl_unlock();
+			return -EINVAL;
+		}
+	}
+
 	tx_sa = rtnl_dereference(tx_sc->sa[assoc_num]);
 	if (tx_sa) {
 		rtnl_unlock();
@@ -1922,7 +1994,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	spin_lock_bh(&tx_sa->lock);
-	tx_sa->next_pn_halves.lower = nla_get_u32(tb_sa[MACSEC_SA_ATTR_PN]);
+	tx_sa->next_pn = nla_get_u64(tb_sa[MACSEC_SA_ATTR_PN]);
 	spin_unlock_bh(&tx_sa->lock);
 
 	if (tb_sa[MACSEC_SA_ATTR_ACTIVE])
@@ -1953,6 +2025,12 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 			goto cleanup;
 	}
 
+	if (secy->xpn) {
+		tx_sa->ssci = nla_get_ssci(tb_sa[MACSEC_SA_ATTR_SSCI]);
+		nla_memcpy(tx_sa->key.salt.bytes, tb_sa[MACSEC_SA_ATTR_SALT],
+			   MACSEC_SALT_LEN);
+	}
+
 	nla_memcpy(tx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEYID_LEN);
 	rcu_assign_pointer(tx_sc->sa[assoc_num], tx_sa);
 
@@ -2159,7 +2237,9 @@ static bool validate_upd_sa(struct nlattr **attrs)
 {
 	if (!attrs[MACSEC_SA_ATTR_AN] ||
 	    attrs[MACSEC_SA_ATTR_KEY] ||
-	    attrs[MACSEC_SA_ATTR_KEYID])
+	    attrs[MACSEC_SA_ATTR_KEYID] ||
+	    attrs[MACSEC_SA_ATTR_SSCI] ||
+	    attrs[MACSEC_SA_ATTR_SALT])
 		return false;
 
 	if (nla_get_u8(attrs[MACSEC_SA_ATTR_AN]) >= MACSEC_NUM_AN)
@@ -2209,9 +2289,19 @@ static int macsec_upd_txsa(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (tb_sa[MACSEC_SA_ATTR_PN]) {
+		int pn_len;
+
+		pn_len = secy->xpn ? MACSEC_XPN_PN_LEN : MACSEC_DEFAULT_PN_LEN;
+		if (nla_len(tb_sa[MACSEC_SA_ATTR_PN]) != pn_len) {
+			pr_notice("macsec: nl: upd_txsa: bad pn length: %d != %d\n",
+				  nla_len(tb_sa[MACSEC_SA_ATTR_PN]), pn_len);
+			rtnl_unlock();
+			return -EINVAL;
+		}
+
 		spin_lock_bh(&tx_sa->lock);
 		prev_pn = tx_sa->next_pn_halves;
-		tx_sa->next_pn_halves.lower = nla_get_u32(tb_sa[MACSEC_SA_ATTR_PN]);
+		tx_sa->next_pn = nla_get_u64(tb_sa[MACSEC_SA_ATTR_PN]);
 		spin_unlock_bh(&tx_sa->lock);
 	}
 
@@ -2295,9 +2385,19 @@ static int macsec_upd_rxsa(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (tb_sa[MACSEC_SA_ATTR_PN]) {
+		int pn_len;
+
+		pn_len = secy->xpn ? MACSEC_XPN_PN_LEN : MACSEC_DEFAULT_PN_LEN;
+		if (nla_len(tb_sa[MACSEC_SA_ATTR_PN]) != pn_len) {
+			pr_notice("macsec: nl: upd_rxsa: bad pn length: %d != %d\n",
+				  nla_len(tb_sa[MACSEC_SA_ATTR_PN]), pn_len);
+			rtnl_unlock();
+			return -EINVAL;
+		}
+
 		spin_lock_bh(&rx_sa->lock);
 		prev_pn = rx_sa->next_pn_halves;
-		rx_sa->next_pn_halves.lower = nla_get_u32(tb_sa[MACSEC_SA_ATTR_PN]);
+		rx_sa->next_pn = nla_get_u64(tb_sa[MACSEC_SA_ATTR_PN]);
 		spin_unlock_bh(&rx_sa->lock);
 	}
 
@@ -2744,10 +2844,10 @@ static int nla_put_secy(struct macsec_secy *secy, struct sk_buff *skb)
 
 	switch (secy->key_len) {
 	case MACSEC_GCM_AES_128_SAK_LEN:
-		csid = MACSEC_DEFAULT_CIPHER_ID;
+		csid = secy->xpn ? MACSEC_CIPHER_ID_GCM_AES_XPN_128 : MACSEC_DEFAULT_CIPHER_ID;
 		break;
 	case MACSEC_GCM_AES_256_SAK_LEN:
-		csid = MACSEC_CIPHER_ID_GCM_AES_256;
+		csid = secy->xpn ? MACSEC_CIPHER_ID_GCM_AES_XPN_256 : MACSEC_CIPHER_ID_GCM_AES_256;
 		break;
 	default:
 		goto cancel;
@@ -2838,6 +2938,8 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 	for (i = 0, j = 1; i < MACSEC_NUM_AN; i++) {
 		struct macsec_tx_sa *tx_sa = rtnl_dereference(tx_sc->sa[i]);
 		struct nlattr *txsa_nest;
+		u64 pn;
+		int pn_len;
 
 		if (!tx_sa)
 			continue;
@@ -2848,9 +2950,18 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 			goto nla_put_failure;
 		}
 
+		if (secy->xpn) {
+			pn = tx_sa->next_pn;
+			pn_len = MACSEC_XPN_PN_LEN;
+		} else {
+			pn = tx_sa->next_pn_halves.lower;
+			pn_len = MACSEC_DEFAULT_PN_LEN;
+		}
+
 		if (nla_put_u8(skb, MACSEC_SA_ATTR_AN, i) ||
-		    nla_put_u32(skb, MACSEC_SA_ATTR_PN, tx_sa->next_pn_halves.lower) ||
+		    nla_put(skb, MACSEC_SA_ATTR_PN, pn_len, &pn) ||
 		    nla_put(skb, MACSEC_SA_ATTR_KEYID, MACSEC_KEYID_LEN, tx_sa->key.id) ||
+		    (secy->xpn && nla_put_ssci(skb, MACSEC_SA_ATTR_SSCI, tx_sa->ssci)) ||
 		    nla_put_u8(skb, MACSEC_SA_ATTR_ACTIVE, tx_sa->active)) {
 			nla_nest_cancel(skb, txsa_nest);
 			nla_nest_cancel(skb, txsa_list);
@@ -2923,6 +3034,8 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 		for (i = 0, k = 1; i < MACSEC_NUM_AN; i++) {
 			struct macsec_rx_sa *rx_sa = rtnl_dereference(rx_sc->sa[i]);
 			struct nlattr *rxsa_nest;
+			u64 pn;
+			int pn_len;
 
 			if (!rx_sa)
 				continue;
@@ -2952,9 +3065,18 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 			}
 			nla_nest_end(skb, attr);
 
+			if (secy->xpn) {
+				pn = rx_sa->next_pn;
+				pn_len = MACSEC_XPN_PN_LEN;
+			} else {
+				pn = rx_sa->next_pn_halves.lower;
+				pn_len = MACSEC_DEFAULT_PN_LEN;
+			}
+
 			if (nla_put_u8(skb, MACSEC_SA_ATTR_AN, i) ||
-			    nla_put_u32(skb, MACSEC_SA_ATTR_PN, rx_sa->next_pn_halves.lower) ||
+			    nla_put(skb, MACSEC_SA_ATTR_PN, pn_len, &pn) ||
 			    nla_put(skb, MACSEC_SA_ATTR_KEYID, MACSEC_KEYID_LEN, rx_sa->key.id) ||
+			    (secy->xpn && nla_put_ssci(skb, MACSEC_SA_ATTR_SSCI, rx_sa->ssci)) ||
 			    nla_put_u8(skb, MACSEC_SA_ATTR_ACTIVE, rx_sa->active)) {
 				nla_nest_cancel(skb, rxsa_nest);
 				nla_nest_cancel(skb, rxsc_nest);
@@ -3483,9 +3605,19 @@ static int macsec_changelink_common(struct net_device *dev,
 		case MACSEC_CIPHER_ID_GCM_AES_128:
 		case MACSEC_DEFAULT_CIPHER_ID:
 			secy->key_len = MACSEC_GCM_AES_128_SAK_LEN;
+			secy->xpn = false;
 			break;
 		case MACSEC_CIPHER_ID_GCM_AES_256:
 			secy->key_len = MACSEC_GCM_AES_256_SAK_LEN;
+			secy->xpn = false;
+			break;
+		case MACSEC_CIPHER_ID_GCM_AES_XPN_128:
+			secy->key_len = MACSEC_GCM_AES_128_SAK_LEN;
+			secy->xpn = true;
+			break;
+		case MACSEC_CIPHER_ID_GCM_AES_XPN_256:
+			secy->key_len = MACSEC_GCM_AES_256_SAK_LEN;
+			secy->xpn = true;
 			break;
 		default:
 			return -EINVAL;
@@ -3680,6 +3812,7 @@ static int macsec_add_dev(struct net_device *dev, sci_t sci, u8 icv_len)
 	secy->validate_frames = MACSEC_VALIDATE_DEFAULT;
 	secy->protect_frames = true;
 	secy->replay_protect = false;
+	secy->xpn = DEFAULT_XPN;
 
 	secy->sci = sci;
 	secy->tx_sc.active = true;
@@ -3809,6 +3942,8 @@ static int macsec_validate_attr(struct nlattr *tb[], struct nlattr *data[],
 	switch (csid) {
 	case MACSEC_CIPHER_ID_GCM_AES_128:
 	case MACSEC_CIPHER_ID_GCM_AES_256:
+	case MACSEC_CIPHER_ID_GCM_AES_XPN_128:
+	case MACSEC_CIPHER_ID_GCM_AES_XPN_256:
 	case MACSEC_DEFAULT_CIPHER_ID:
 		if (icv_len < MACSEC_MIN_ICV_LEN ||
 		    icv_len > MACSEC_STD_ICV_LEN)
@@ -3882,10 +4017,10 @@ static int macsec_fill_info(struct sk_buff *skb,
 
 	switch (secy->key_len) {
 	case MACSEC_GCM_AES_128_SAK_LEN:
-		csid = MACSEC_DEFAULT_CIPHER_ID;
+		csid = secy->xpn ? MACSEC_CIPHER_ID_GCM_AES_XPN_128 : MACSEC_DEFAULT_CIPHER_ID;
 		break;
 	case MACSEC_GCM_AES_256_SAK_LEN:
-		csid = MACSEC_CIPHER_ID_GCM_AES_256;
+		csid = secy->xpn ? MACSEC_CIPHER_ID_GCM_AES_XPN_256 : MACSEC_CIPHER_ID_GCM_AES_256;
 		break;
 	default:
 		goto nla_put_failure;
diff --git a/include/net/macsec.h b/include/net/macsec.h
index 43cd54e17..2e4780dbf 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -11,6 +11,9 @@
 #include <uapi/linux/if_link.h>
 #include <uapi/linux/if_macsec.h>
 
+#define MACSEC_DEFAULT_PN_LEN 4
+#define MACSEC_XPN_PN_LEN 8
+
 #define MACSEC_SALT_LEN 12
 #define MACSEC_NUM_AN 4 /* 2 bits for the association number */
 
diff --git a/include/uapi/linux/if_macsec.h b/include/uapi/linux/if_macsec.h
index 1d63c43c3..3af2aa069 100644
--- a/include/uapi/linux/if_macsec.h
+++ b/include/uapi/linux/if_macsec.h
@@ -22,9 +22,11 @@
 
 #define MACSEC_KEYID_LEN 16
 
-/* cipher IDs as per IEEE802.1AEbn-2011 */
+/* cipher IDs as per IEEE802.1AE-2018 (Table 14-1) */
 #define MACSEC_CIPHER_ID_GCM_AES_128 0x0080C20001000001ULL
 #define MACSEC_CIPHER_ID_GCM_AES_256 0x0080C20001000002ULL
+#define MACSEC_CIPHER_ID_GCM_AES_XPN_128 0x0080C20001000003ULL
+#define MACSEC_CIPHER_ID_GCM_AES_XPN_256 0x0080C20001000004ULL
 
 /* deprecated cipher ID for GCM-AES-128 */
 #define MACSEC_DEFAULT_CIPHER_ID     0x0080020001000001ULL
@@ -88,11 +90,13 @@ enum macsec_sa_attrs {
 	MACSEC_SA_ATTR_UNSPEC,
 	MACSEC_SA_ATTR_AN,     /* config/dump, u8 0..3 */
 	MACSEC_SA_ATTR_ACTIVE, /* config/dump, u8 0..1 */
-	MACSEC_SA_ATTR_PN,     /* config/dump, u32 */
+	MACSEC_SA_ATTR_PN,     /* config/dump, u32/u64 (u64 if XPN) */
 	MACSEC_SA_ATTR_KEY,    /* config, data */
 	MACSEC_SA_ATTR_KEYID,  /* config/dump, 128-bit */
 	MACSEC_SA_ATTR_STATS,  /* dump, nested, macsec_sa_stats_attr */
 	MACSEC_SA_ATTR_PAD,
+	MACSEC_SA_ATTR_SSCI,   /* config/dump, u32 - XPN only */
+	MACSEC_SA_ATTR_SALT,   /* config, 96-bit - XPN only */
 	__MACSEC_SA_ATTR_END,
 	NUM_MACSEC_SA_ATTR = __MACSEC_SA_ATTR_END,
 	MACSEC_SA_ATTR_MAX = __MACSEC_SA_ATTR_END - 1,
-- 
2.20.1

