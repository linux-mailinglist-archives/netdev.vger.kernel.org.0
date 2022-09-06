Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1395ADEE3
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 07:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbiIFFVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 01:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbiIFFVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 01:21:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FC46D541
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 22:21:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AFCEB81603
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 05:21:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F23C433C1;
        Tue,  6 Sep 2022 05:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662441701;
        bh=o1szHT6iDlmfWYTNM8rwAxR4Bh0XFPSgpt2DxDzMvCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O2I8wuqOyq6kGsq1dDMcitbfTEK7FJ06u8RiOa9Iz23ti8hIAddTQT35qBt70cbG4
         UFzEQq/JALn5bHUzwBj5xwX0GsCVtU54s18plWvSqI55Pm12ECL195HLNm35mqXSG8
         sePV88f5Ih5uJ37LtWEkc4POHVbQUNz+RlifY1TuGLcQpyezs1mm0Dkr6Fqx3lX1/E
         dJvnQ0frLWKKzVxjz88YqjiVMNcautVeDU8p0SuayJaBFlv39A93mM0wkoBBWiqwAn
         b1C0O43nqyIiHL8hqm4mNzqIJd7Y29A6jg6nkJJDlIQt/h7d152XpIoisKu8Vpahzl
         rX3YePsjr/iyw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ben Ben-Ishay <benishay@nvidia.com>
Subject: [PATCH net-next V2 03/17] net/macsec: Move some code for sharing with various drivers that implements offload
Date:   Mon,  5 Sep 2022 22:21:15 -0700
Message-Id: <20220906052129.104507-4-saeed@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220906052129.104507-1-saeed@kernel.org>
References: <20220906052129.104507-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lior Nahmanson <liorna@nvidia.com>

Move some MACsec infrastructure like defines and functions,
in order to avoid code duplication for future drivers which
implements MACsec offload.

Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/macsec.c | 33 ++++++---------------------------
 include/net/macsec.h | 21 +++++++++++++++++++++
 2 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index e781b3e22aac..830fed3914b6 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -25,8 +25,6 @@
 
 #include <uapi/linux/if_macsec.h>
 
-#define MACSEC_SCI_LEN 8
-
 /* SecTAG length = macsec_eth_header without the optional SCI */
 #define MACSEC_TAG_LEN 6
 
@@ -47,20 +45,10 @@ struct macsec_eth_header {
 	u8 secure_channel_id[8]; /* optional */
 } __packed;
 
-#define MACSEC_TCI_VERSION 0x80
-#define MACSEC_TCI_ES      0x40 /* end station */
-#define MACSEC_TCI_SC      0x20 /* SCI present */
-#define MACSEC_TCI_SCB     0x10 /* epon */
-#define MACSEC_TCI_E       0x08 /* encryption */
-#define MACSEC_TCI_C       0x04 /* changed text */
-#define MACSEC_AN_MASK     0x03 /* association number */
-#define MACSEC_TCI_CONFID  (MACSEC_TCI_E | MACSEC_TCI_C)
-
 /* minimum secure data length deemed "not short", see IEEE 802.1AE-2006 9.7 */
 #define MIN_NON_SHORT_LEN 48
 
 #define GCM_AES_IV_LEN 12
-#define DEFAULT_ICV_LEN 16
 
 #define for_each_rxsc(secy, sc)				\
 	for (sc = rcu_dereference_bh(secy->rx_sc);	\
@@ -244,7 +232,6 @@ static struct macsec_cb *macsec_skb_cb(struct sk_buff *skb)
 	return (struct macsec_cb *)skb->cb;
 }
 
-#define MACSEC_PORT_ES (htons(0x0001))
 #define MACSEC_PORT_SCB (0x0000)
 #define MACSEC_UNDEF_SCI ((__force sci_t)0xffffffffffffffffULL)
 #define MACSEC_UNDEF_SSCI ((__force ssci_t)0xffffffff)
@@ -259,14 +246,6 @@ static struct macsec_cb *macsec_skb_cb(struct sk_buff *skb)
 #define DEFAULT_ENCODING_SA 0
 #define MACSEC_XPN_MAX_REPLAY_WINDOW (((1 << 30) - 1))
 
-static bool send_sci(const struct macsec_secy *secy)
-{
-	const struct macsec_tx_sc *tx_sc = &secy->tx_sc;
-
-	return tx_sc->send_sci ||
-		(secy->n_rx_sc > 1 && !tx_sc->end_station && !tx_sc->scb);
-}
-
 static sci_t make_sci(const u8 *addr, __be16 port)
 {
 	sci_t sci;
@@ -331,7 +310,7 @@ static void macsec_fill_sectag(struct macsec_eth_header *h,
 	/* with GCM, C/E clear for !encrypt, both set for encrypt */
 	if (tx_sc->encrypt)
 		h->tci_an |= MACSEC_TCI_CONFID;
-	else if (secy->icv_len != DEFAULT_ICV_LEN)
+	else if (secy->icv_len != MACSEC_DEFAULT_ICV_LEN)
 		h->tci_an |= MACSEC_TCI_C;
 
 	h->tci_an |= tx_sc->encoding_sa;
@@ -655,7 +634,7 @@ static struct sk_buff *macsec_encrypt(struct sk_buff *skb,
 
 	unprotected_len = skb->len;
 	eth = eth_hdr(skb);
-	sci_present = send_sci(secy);
+	sci_present = macsec_send_sci(secy);
 	hh = skb_push(skb, macsec_extra_len(sci_present));
 	memmove(hh, eth, 2 * ETH_ALEN);
 
@@ -1303,7 +1282,7 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 	/* 10.6.1 if the SC is not found */
 	cbit = !!(hdr->tci_an & MACSEC_TCI_C);
 	if (!cbit)
-		macsec_finalize_skb(skb, DEFAULT_ICV_LEN,
+		macsec_finalize_skb(skb, MACSEC_DEFAULT_ICV_LEN,
 				    macsec_extra_len(macsec_skb_cb(skb)->has_sci));
 
 	list_for_each_entry_rcu(macsec, &rxd->secys, secys) {
@@ -4067,7 +4046,7 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
 	rx_handler_func_t *rx_handler;
-	u8 icv_len = DEFAULT_ICV_LEN;
+	u8 icv_len = MACSEC_DEFAULT_ICV_LEN;
 	struct net_device *real_dev;
 	int err, mtu;
 	sci_t sci;
@@ -4191,7 +4170,7 @@ static int macsec_validate_attr(struct nlattr *tb[], struct nlattr *data[],
 				struct netlink_ext_ack *extack)
 {
 	u64 csid = MACSEC_DEFAULT_CIPHER_ID;
-	u8 icv_len = DEFAULT_ICV_LEN;
+	u8 icv_len = MACSEC_DEFAULT_ICV_LEN;
 	int flag;
 	bool es, scb, sci;
 
@@ -4203,7 +4182,7 @@ static int macsec_validate_attr(struct nlattr *tb[], struct nlattr *data[],
 
 	if (data[IFLA_MACSEC_ICV_LEN]) {
 		icv_len = nla_get_u8(data[IFLA_MACSEC_ICV_LEN]);
-		if (icv_len != DEFAULT_ICV_LEN) {
+		if (icv_len != MACSEC_DEFAULT_ICV_LEN) {
 			char dummy_key[DEFAULT_SAK_LEN] = { 0 };
 			struct crypto_aead *dummy_tfm;
 
diff --git a/include/net/macsec.h b/include/net/macsec.h
index 8494953fb0de..871599b11707 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -16,6 +16,20 @@
 
 #define MACSEC_NUM_AN 4 /* 2 bits for the association number */
 
+#define MACSEC_SCI_LEN 8
+#define MACSEC_PORT_ES (htons(0x0001))
+
+#define MACSEC_TCI_VERSION 0x80
+#define MACSEC_TCI_ES      0x40 /* end station */
+#define MACSEC_TCI_SC      0x20 /* SCI present */
+#define MACSEC_TCI_SCB     0x10 /* epon */
+#define MACSEC_TCI_E       0x08 /* encryption */
+#define MACSEC_TCI_C       0x04 /* changed text */
+#define MACSEC_AN_MASK     0x03 /* association number */
+#define MACSEC_TCI_CONFID  (MACSEC_TCI_E | MACSEC_TCI_C)
+
+#define MACSEC_DEFAULT_ICV_LEN 16
+
 typedef u64 __bitwise sci_t;
 typedef u32 __bitwise ssci_t;
 
@@ -292,5 +306,12 @@ struct macsec_ops {
 };
 
 void macsec_pn_wrapped(struct macsec_secy *secy, struct macsec_tx_sa *tx_sa);
+static inline bool macsec_send_sci(const struct macsec_secy *secy)
+{
+	const struct macsec_tx_sc *tx_sc = &secy->tx_sc;
+
+	return tx_sc->send_sci ||
+		(secy->n_rx_sc > 1 && !tx_sc->end_station && !tx_sc->scb);
+}
 
 #endif /* _NET_MACSEC_H_ */
-- 
2.37.2

