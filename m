Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9895317DDE0
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 11:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgCIKrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 06:47:18 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35958 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgCIKrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 06:47:18 -0400
Received: by mail-wr1-f68.google.com with SMTP id s5so6504724wrg.3;
        Mon, 09 Mar 2020 03:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8Q5hLP6VCCRTSBbHs5v5bw6AJTAj4qvpYTw598TDaPk=;
        b=VKsgax4iWthP3woIu586uVQrk/tjJamkL/ku+1bkafArdJlaDcxwZLZsaBCalaHzod
         KEodXDdSiCR4QV11oTYtxPRexoXIb+AgDipsHw2VWP2yFtDLW6lIebi31oH/V86QODV9
         0rKpJMrzUiOV8oR+gfA6/52Yr5xKHG97Mh6yqjx26KzryVv9oTN9lWKPVJxP3wF3SOqu
         EgowmNC/wavPzNfJ/ZokfYcjSDTV0qI9Ag51Tm016/NVr9r4UXXpDRNcaPS9huKeU1uy
         0E9aRtqyHp9ZhoOacf/hjSx3yidxw6HgjBr/D29/BgpvnUkbD+E2h0LUGhZTgEGkP8VO
         nYig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8Q5hLP6VCCRTSBbHs5v5bw6AJTAj4qvpYTw598TDaPk=;
        b=TAF1PWCDQyQmZhu3GoInbj0s9A2iWTXl0gq0FS+mFw9AEQ4VtgO+GI5onvCp8bfH9g
         JwS0Aa/+oXywccRk5GCSO3JJzgvgcypyd00jZh61l06/Onn/V8u+Eq/Qd/Wf7Mxdm5nj
         eifeqZWUCOrc9Emu142hnNb6uaD7RNCdsJbB2XUmd3S/ptLjRBTruQkPDzyK1c3zjA8R
         hHFE473saKqMennLvqCTGdebteJQwR8DyPm+TNblUWlnqykoe74A6ePfsOnq2aEZ3rqC
         FIuK9jbAL2kP0fhiL9loNHADgx6dSmltZnZWrwW+G+QPAHPnrLFmRwFpNNTWAA517HQM
         XYKw==
X-Gm-Message-State: ANhLgQ1Myj2FSO2yOLOw73sJlPC3t5frhuzEDPdxf0dkEKsUyoIdR4iN
        iL+ClikNUm8KHLCE7pW5QkO84OOxhPPNIw==
X-Google-Smtp-Source: ADFU+vs1DeZRsLneSJ1que7sFDLkTRqY/YfPMLhT/+R6DEfdYiV1PILobF/74G7n0Sbg3VrMFNt1hQ==
X-Received: by 2002:adf:f002:: with SMTP id j2mr21186795wro.296.1583750834782;
        Mon, 09 Mar 2020 03:47:14 -0700 (PDT)
Received: from localhost (hosting85.skyberate.net. [185.87.248.81])
        by smtp.gmail.com with ESMTPSA id c72sm19167752wme.35.2020.03.09.03.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 03:47:14 -0700 (PDT)
From:   Era Mayflower <mayflowerera@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Era Mayflower <mayflowerera@gmail.com>
Subject: [PATCH v3 1/2] macsec: Support XPN frame handling - IEEE 802.1AEbw
Date:   Mon,  9 Mar 2020 19:47:01 +0000
Message-Id: <20200309194702.117050-1-mayflowerera@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support extended packet number cipher suites (802.1AEbw) frames handling.
This does not include the needed netlink patches.

    * Added xpn boolean field to `struct macsec_secy`.
    * Added ssci field to `struct_macsec_tx_sa` (802.1AE figure 10-5).
    * Added ssci field to `struct_macsec_rx_sa` (802.1AE figure 10-5).
    * Added salt field to `struct macsec_key` (802.1AE 10.7 NOTE 1).
    * Created pn_t type for easy access to lower and upper halves.
    * Created salt_t type for easy access to the "ssci" and "pn" parts.
    * Created `macsec_fill_iv_xpn` function to create IV in XPN mode.
    * Support in PN recovery and preliminary replay check in XPN mode.

In addition, according to IEEE 802.1AEbw figure 10-5, the PN of incoming
frame can be 0 when XPN cipher suite is used, so fixed the function
`macsec_validate_skb` to fail on PN=0 only if XPN is off.

Signed-off-by: Era Mayflower <mayflowerera@gmail.com>
---
 drivers/net/macsec.c | 130 +++++++++++++++++++++++++++++++------------
 include/net/macsec.h |  45 ++++++++++++++-
 2 files changed, 136 insertions(+), 39 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 45bfd99f1..de9578daa 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -19,6 +19,7 @@
 #include <net/gro_cells.h>
 #include <net/macsec.h>
 #include <linux/phy.h>
+#include <linux/byteorder/generic.h>
 
 #include <uapi/linux/if_macsec.h>
 
@@ -68,6 +69,16 @@ struct macsec_eth_header {
 	     sc;					\
 	     sc = rtnl_dereference(sc->next))
 
+#define pn_same_half(pn1, pn2) (!(((pn1) >> 31) ^ ((pn2) >> 31)))
+
+struct gcm_iv_xpn {
+	union {
+		u8 short_secure_channel_id[4];
+		ssci_t ssci;
+	};
+	__be64 pn;
+} __packed;
+
 struct gcm_iv {
 	union {
 		u8 secure_channel_id[8];
@@ -372,8 +383,8 @@ static const struct macsec_ops *macsec_get_ops(struct macsec_dev *macsec,
 	return __macsec_get_ops(macsec->offload, macsec, ctx);
 }
 
-/* validate MACsec packet according to IEEE 802.1AE-2006 9.12 */
-static bool macsec_validate_skb(struct sk_buff *skb, u16 icv_len)
+/* validate MACsec packet according to IEEE 802.1AE-2018 9.12 */
+static bool macsec_validate_skb(struct sk_buff *skb, u16 icv_len, bool xpn)
 {
 	struct macsec_eth_header *h = (struct macsec_eth_header *)skb->data;
 	int len = skb->len - 2 * ETH_ALEN;
@@ -398,8 +409,8 @@ static bool macsec_validate_skb(struct sk_buff *skb, u16 icv_len)
 	if (h->unused)
 		return false;
 
-	/* rx.pn != 0 (figure 10-5) */
-	if (!h->packet_number)
+	/* rx.pn != 0 if not XPN (figure 10-5 with 802.11AEbw-2013 amendment) */
+	if (!h->packet_number && !xpn)
 		return false;
 
 	/* length check, f) g) h) i) */
@@ -411,6 +422,15 @@ static bool macsec_validate_skb(struct sk_buff *skb, u16 icv_len)
 #define MACSEC_NEEDED_HEADROOM (macsec_extra_len(true))
 #define MACSEC_NEEDED_TAILROOM MACSEC_STD_ICV_LEN
 
+static void macsec_fill_iv_xpn(unsigned char *iv, ssci_t ssci, u64 pn,
+			       salt_t salt)
+{
+	struct gcm_iv_xpn *gcm_iv = (struct gcm_iv_xpn *)iv;
+
+	gcm_iv->ssci = ssci ^ salt.ssci;
+	gcm_iv->pn = cpu_to_be64(pn) ^ salt.pn;
+}
+
 static void macsec_fill_iv(unsigned char *iv, sci_t sci, u32 pn)
 {
 	struct gcm_iv *gcm_iv = (struct gcm_iv *)iv;
@@ -441,14 +461,19 @@ void macsec_pn_wrapped(struct macsec_secy *secy, struct macsec_tx_sa *tx_sa)
 }
 EXPORT_SYMBOL_GPL(macsec_pn_wrapped);
 
-static u32 tx_sa_update_pn(struct macsec_tx_sa *tx_sa, struct macsec_secy *secy)
+static pn_t tx_sa_update_pn(struct macsec_tx_sa *tx_sa,
+			    struct macsec_secy *secy)
 {
-	u32 pn;
+	pn_t pn;
 
 	spin_lock_bh(&tx_sa->lock);
-	pn = tx_sa->next_pn;
 
-	tx_sa->next_pn++;
+	pn = tx_sa->next_pn_halves;
+	if (secy->xpn)
+		tx_sa->next_pn++;
+	else
+		tx_sa->next_pn_halves.lower++;
+
 	if (tx_sa->next_pn == 0)
 		__macsec_pn_wrapped(secy, tx_sa);
 	spin_unlock_bh(&tx_sa->lock);
@@ -563,7 +588,7 @@ static struct sk_buff *macsec_encrypt(struct sk_buff *skb,
 	struct macsec_tx_sa *tx_sa;
 	struct macsec_dev *macsec = macsec_priv(dev);
 	bool sci_present;
-	u32 pn;
+	pn_t pn;
 
 	secy = &macsec->secy;
 	tx_sc = &secy->tx_sc;
@@ -605,12 +630,12 @@ static struct sk_buff *macsec_encrypt(struct sk_buff *skb,
 	memmove(hh, eth, 2 * ETH_ALEN);
 
 	pn = tx_sa_update_pn(tx_sa, secy);
-	if (pn == 0) {
+	if (pn.full64 == 0) {
 		macsec_txsa_put(tx_sa);
 		kfree_skb(skb);
 		return ERR_PTR(-ENOLINK);
 	}
-	macsec_fill_sectag(hh, secy, pn, sci_present);
+	macsec_fill_sectag(hh, secy, pn.lower, sci_present);
 	macsec_set_shortlen(hh, unprotected_len - 2 * ETH_ALEN);
 
 	skb_put(skb, secy->icv_len);
@@ -641,7 +666,10 @@ static struct sk_buff *macsec_encrypt(struct sk_buff *skb,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	macsec_fill_iv(iv, secy->sci, pn);
+	if (secy->xpn)
+		macsec_fill_iv_xpn(iv, tx_sa->ssci, pn.full64, tx_sa->key.salt);
+	else
+		macsec_fill_iv(iv, secy->sci, pn.lower);
 
 	sg_init_table(sg, ret);
 	ret = skb_to_sgvec(skb, sg, 0, skb->len);
@@ -693,13 +721,14 @@ static bool macsec_post_decrypt(struct sk_buff *skb, struct macsec_secy *secy, u
 	u32 lowest_pn = 0;
 
 	spin_lock(&rx_sa->lock);
-	if (rx_sa->next_pn >= secy->replay_window)
-		lowest_pn = rx_sa->next_pn - secy->replay_window;
+	if (rx_sa->next_pn_halves.lower >= secy->replay_window)
+		lowest_pn = rx_sa->next_pn_halves.lower - secy->replay_window;
 
 	/* Now perform replay protection check again
 	 * (see IEEE 802.1AE-2006 figure 10-5)
 	 */
-	if (secy->replay_protect && pn < lowest_pn) {
+	if (secy->replay_protect && pn < lowest_pn &&
+	    (!secy->xpn || pn_same_half(pn, lowest_pn))) {
 		spin_unlock(&rx_sa->lock);
 		u64_stats_update_begin(&rxsc_stats->syncp);
 		rxsc_stats->stats.InPktsLate++;
@@ -748,8 +777,15 @@ static bool macsec_post_decrypt(struct sk_buff *skb, struct macsec_secy *secy, u
 		}
 		u64_stats_update_end(&rxsc_stats->syncp);
 
-		if (pn >= rx_sa->next_pn)
-			rx_sa->next_pn = pn + 1;
+		// Instead of "pn >=" - to support pn overflow in xpn
+		if (pn + 1 > rx_sa->next_pn_halves.lower) {
+			rx_sa->next_pn_halves.lower = pn + 1;
+		} else if (secy->xpn &&
+			   !pn_same_half(pn, rx_sa->next_pn_halves.lower)) {
+			rx_sa->next_pn_halves.upper++;
+			rx_sa->next_pn_halves.lower = pn + 1;
+		}
+
 		spin_unlock(&rx_sa->lock);
 	}
 
@@ -836,6 +872,7 @@ static struct sk_buff *macsec_decrypt(struct sk_buff *skb,
 	unsigned char *iv;
 	struct aead_request *req;
 	struct macsec_eth_header *hdr;
+	u32 hdr_pn;
 	u16 icv_len = secy->icv_len;
 
 	macsec_skb_cb(skb)->valid = false;
@@ -855,7 +892,21 @@ static struct sk_buff *macsec_decrypt(struct sk_buff *skb,
 	}
 
 	hdr = (struct macsec_eth_header *)skb->data;
-	macsec_fill_iv(iv, sci, ntohl(hdr->packet_number));
+	hdr_pn = ntohl(hdr->packet_number);
+
+	if (secy->xpn) {
+		pn_t recovered_pn = rx_sa->next_pn_halves;
+
+		recovered_pn.lower = hdr_pn;
+		if (hdr_pn < rx_sa->next_pn_halves.lower &&
+		    !pn_same_half(hdr_pn, rx_sa->next_pn_halves.lower))
+			recovered_pn.upper++;
+
+		macsec_fill_iv_xpn(iv, rx_sa->ssci, recovered_pn.full64,
+				   rx_sa->key.salt);
+	} else {
+		macsec_fill_iv(iv, sci, hdr_pn);
+	}
 
 	sg_init_table(sg, ret);
 	ret = skb_to_sgvec(skb, sg, 0, skb->len);
@@ -996,7 +1047,7 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 	struct macsec_rxh_data *rxd;
 	struct macsec_dev *macsec;
 	sci_t sci;
-	u32 pn;
+	u32 hdr_pn;
 	bool cbit;
 	struct pcpu_rx_sc_stats *rxsc_stats;
 	struct pcpu_secy_stats *secy_stats;
@@ -1067,7 +1118,7 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 	secy_stats = this_cpu_ptr(macsec->stats);
 	rxsc_stats = this_cpu_ptr(rx_sc->stats);
 
-	if (!macsec_validate_skb(skb, secy->icv_len)) {
+	if (!macsec_validate_skb(skb, secy->icv_len, secy->xpn)) {
 		u64_stats_update_begin(&secy_stats->syncp);
 		secy_stats->stats.InPktsBadTag++;
 		u64_stats_update_end(&secy_stats->syncp);
@@ -1099,13 +1150,16 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 	}
 
 	/* First, PN check to avoid decrypting obviously wrong packets */
-	pn = ntohl(hdr->packet_number);
+	hdr_pn = ntohl(hdr->packet_number);
 	if (secy->replay_protect) {
 		bool late;
 
 		spin_lock(&rx_sa->lock);
-		late = rx_sa->next_pn >= secy->replay_window &&
-		       pn < (rx_sa->next_pn - secy->replay_window);
+		late = rx_sa->next_pn_halves.lower >= secy->replay_window &&
+		       hdr_pn < (rx_sa->next_pn_halves.lower - secy->replay_window);
+
+		if (secy->xpn)
+			late = late && pn_same_half(rx_sa->next_pn_halves.lower, hdr_pn);
 		spin_unlock(&rx_sa->lock);
 
 		if (late) {
@@ -1134,7 +1188,7 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 		return RX_HANDLER_CONSUMED;
 	}
 
-	if (!macsec_post_decrypt(skb, secy, pn))
+	if (!macsec_post_decrypt(skb, secy, hdr_pn))
 		goto drop;
 
 deliver:
@@ -1661,7 +1715,7 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 
 	if (tb_sa[MACSEC_SA_ATTR_PN]) {
 		spin_lock_bh(&rx_sa->lock);
-		rx_sa->next_pn = nla_get_u32(tb_sa[MACSEC_SA_ATTR_PN]);
+		rx_sa->next_pn_halves.lower = nla_get_u32(tb_sa[MACSEC_SA_ATTR_PN]);
 		spin_unlock_bh(&rx_sa->lock);
 	}
 
@@ -1868,7 +1922,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	spin_lock_bh(&tx_sa->lock);
-	tx_sa->next_pn = nla_get_u32(tb_sa[MACSEC_SA_ATTR_PN]);
+	tx_sa->next_pn_halves.lower = nla_get_u32(tb_sa[MACSEC_SA_ATTR_PN]);
 	spin_unlock_bh(&tx_sa->lock);
 
 	if (tb_sa[MACSEC_SA_ATTR_ACTIVE])
@@ -2132,9 +2186,11 @@ static int macsec_upd_txsa(struct sk_buff *skb, struct genl_info *info)
 	u8 assoc_num;
 	struct nlattr *tb_sa[MACSEC_SA_ATTR_MAX + 1];
 	bool was_operational, was_active;
-	u32 prev_pn = 0;
+	pn_t prev_pn;
 	int ret = 0;
 
+	prev_pn.full64 = 0;
+
 	if (!attrs[MACSEC_ATTR_IFINDEX])
 		return -EINVAL;
 
@@ -2154,8 +2210,8 @@ static int macsec_upd_txsa(struct sk_buff *skb, struct genl_info *info)
 
 	if (tb_sa[MACSEC_SA_ATTR_PN]) {
 		spin_lock_bh(&tx_sa->lock);
-		prev_pn = tx_sa->next_pn;
-		tx_sa->next_pn = nla_get_u32(tb_sa[MACSEC_SA_ATTR_PN]);
+		prev_pn = tx_sa->next_pn_halves;
+		tx_sa->next_pn_halves.lower = nla_get_u32(tb_sa[MACSEC_SA_ATTR_PN]);
 		spin_unlock_bh(&tx_sa->lock);
 	}
 
@@ -2193,7 +2249,7 @@ static int macsec_upd_txsa(struct sk_buff *skb, struct genl_info *info)
 cleanup:
 	if (tb_sa[MACSEC_SA_ATTR_PN]) {
 		spin_lock_bh(&tx_sa->lock);
-		tx_sa->next_pn = prev_pn;
+		tx_sa->next_pn_halves = prev_pn;
 		spin_unlock_bh(&tx_sa->lock);
 	}
 	tx_sa->active = was_active;
@@ -2213,9 +2269,11 @@ static int macsec_upd_rxsa(struct sk_buff *skb, struct genl_info *info)
 	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
 	struct nlattr *tb_sa[MACSEC_SA_ATTR_MAX + 1];
 	bool was_active;
-	u32 prev_pn = 0;
+	pn_t prev_pn;
 	int ret = 0;
 
+	prev_pn.full64 = 0;
+
 	if (!attrs[MACSEC_ATTR_IFINDEX])
 		return -EINVAL;
 
@@ -2238,8 +2296,8 @@ static int macsec_upd_rxsa(struct sk_buff *skb, struct genl_info *info)
 
 	if (tb_sa[MACSEC_SA_ATTR_PN]) {
 		spin_lock_bh(&rx_sa->lock);
-		prev_pn = rx_sa->next_pn;
-		rx_sa->next_pn = nla_get_u32(tb_sa[MACSEC_SA_ATTR_PN]);
+		prev_pn = rx_sa->next_pn_halves;
+		rx_sa->next_pn_halves.lower = nla_get_u32(tb_sa[MACSEC_SA_ATTR_PN]);
 		spin_unlock_bh(&rx_sa->lock);
 	}
 
@@ -2272,7 +2330,7 @@ static int macsec_upd_rxsa(struct sk_buff *skb, struct genl_info *info)
 cleanup:
 	if (tb_sa[MACSEC_SA_ATTR_PN]) {
 		spin_lock_bh(&rx_sa->lock);
-		rx_sa->next_pn = prev_pn;
+		rx_sa->next_pn_halves = prev_pn;
 		spin_unlock_bh(&rx_sa->lock);
 	}
 	rx_sa->active = was_active;
@@ -2791,7 +2849,7 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 		}
 
 		if (nla_put_u8(skb, MACSEC_SA_ATTR_AN, i) ||
-		    nla_put_u32(skb, MACSEC_SA_ATTR_PN, tx_sa->next_pn) ||
+		    nla_put_u32(skb, MACSEC_SA_ATTR_PN, tx_sa->next_pn_halves.lower) ||
 		    nla_put(skb, MACSEC_SA_ATTR_KEYID, MACSEC_KEYID_LEN, tx_sa->key.id) ||
 		    nla_put_u8(skb, MACSEC_SA_ATTR_ACTIVE, tx_sa->active)) {
 			nla_nest_cancel(skb, txsa_nest);
@@ -2895,7 +2953,7 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 			nla_nest_end(skb, attr);
 
 			if (nla_put_u8(skb, MACSEC_SA_ATTR_AN, i) ||
-			    nla_put_u32(skb, MACSEC_SA_ATTR_PN, rx_sa->next_pn) ||
+			    nla_put_u32(skb, MACSEC_SA_ATTR_PN, rx_sa->next_pn_halves.lower) ||
 			    nla_put(skb, MACSEC_SA_ATTR_KEYID, MACSEC_KEYID_LEN, rx_sa->key.id) ||
 			    nla_put_u8(skb, MACSEC_SA_ATTR_ACTIVE, rx_sa->active)) {
 				nla_nest_cancel(skb, rxsa_nest);
diff --git a/include/net/macsec.h b/include/net/macsec.h
index 92e43db8b..43cd54e17 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -11,18 +11,45 @@
 #include <uapi/linux/if_link.h>
 #include <uapi/linux/if_macsec.h>
 
+#define MACSEC_SALT_LEN 12
+#define MACSEC_NUM_AN 4 /* 2 bits for the association number */
+
 typedef u64 __bitwise sci_t;
+typedef u32 __bitwise ssci_t;
 
-#define MACSEC_NUM_AN 4 /* 2 bits for the association number */
+typedef union salt {
+	struct {
+		u32 ssci;
+		u64 pn;
+	} __packed;
+	u8 bytes[MACSEC_SALT_LEN];
+} __packed salt_t;
+
+typedef union pn {
+	struct {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+		u32 lower;
+		u32 upper;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+		u32 upper;
+		u32 lower;
+#else
+#error	"Please fix <asm/byteorder.h>"
+#endif
+	};
+	u64 full64;
+} pn_t;
 
 /**
  * struct macsec_key - SA key
  * @id: user-provided key identifier
  * @tfm: crypto struct, key storage
+ * @salt: salt used to generate IV in XPN cipher suites
  */
 struct macsec_key {
 	u8 id[MACSEC_KEYID_LEN];
 	struct crypto_aead *tfm;
+	salt_t salt;
 };
 
 struct macsec_rx_sc_stats {
@@ -64,12 +91,17 @@ struct macsec_tx_sc_stats {
  * @next_pn: packet number expected for the next packet
  * @lock: protects next_pn manipulations
  * @key: key structure
+ * @ssci: short secure channel identifier
  * @stats: per-SA stats
  */
 struct macsec_rx_sa {
 	struct macsec_key key;
+	ssci_t ssci;
 	spinlock_t lock;
-	u32 next_pn;
+	union {
+		pn_t next_pn_halves;
+		u64 next_pn;
+	};
 	refcount_t refcnt;
 	bool active;
 	struct macsec_rx_sa_stats __percpu *stats;
@@ -110,12 +142,17 @@ struct macsec_rx_sc {
  * @next_pn: packet number to use for the next packet
  * @lock: protects next_pn manipulations
  * @key: key structure
+ * @ssci: short secure channel identifier
  * @stats: per-SA stats
  */
 struct macsec_tx_sa {
 	struct macsec_key key;
+	ssci_t ssci;
 	spinlock_t lock;
-	u32 next_pn;
+	union {
+		pn_t next_pn_halves;
+		u64 next_pn;
+	};
 	refcount_t refcnt;
 	bool active;
 	struct macsec_tx_sa_stats __percpu *stats;
@@ -152,6 +189,7 @@ struct macsec_tx_sc {
  * @key_len: length of keys used by the cipher suite
  * @icv_len: length of ICV used by the cipher suite
  * @validate_frames: validation mode
+ * @xpn: enable XPN for this SecY
  * @operational: MAC_Operational flag
  * @protect_frames: enable protection for this SecY
  * @replay_protect: enable packet number checks on receive
@@ -166,6 +204,7 @@ struct macsec_secy {
 	u16 key_len;
 	u16 icv_len;
 	enum macsec_validation_type validate_frames;
+	bool xpn;
 	bool operational;
 	bool protect_frames;
 	bool replay_protect;
-- 
2.20.1

