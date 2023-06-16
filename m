Return-Path: <netdev+bounces-11353-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2713E732B50
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 11:24:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5770280985
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 09:24:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FB83F9F9;
	Fri, 16 Jun 2023 09:24:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424B06139
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 09:24:19 +0000 (UTC)
Received: from ultron (136.red-2-136-200.staticip.rima-tde.net [2.136.200.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 777852117;
	Fri, 16 Jun 2023 02:24:07 -0700 (PDT)
Received: from localhost.localdomain (localhost [127.0.0.1])
	by ultron (Postfix) with ESMTP id 46BAE1AC5920;
	Fri, 16 Jun 2023 11:24:06 +0200 (CEST)
From: carlos.fernandez@technica-engineering.de
To: carlos.fernandez@technica-engineering.de,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: macsec SCI assignment for ES = 0
Date: Fri, 16 Jun 2023 11:24:04 +0200
Message-Id: <20230616092404.12644-1-carlos.fernandez@technica-engineering.de>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FSL_HELO_NON_FQDN_1,
	HELO_NO_DOMAIN,KHOP_HELO_FCRDNS,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

From: Carlos Fernandez <carlos.fernandez@technica-engineering.de>

According to 802.1AE standard, when ES and SC flags in TCI are zero, used
SCI should be the current active SC_RX. Current kernel does not implement
it and uses the header MAC address.

Without this patch, when ES = 0 (using a bridge or switch), header MAC
will not fit the SCI and MACSec frames will be discarted.

Signed-off-by: Carlos Fernandez <carlos.fernandez@technica-engineering.de>
---
 drivers/net/macsec.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 3427993f94f7..ccecb7eb385c 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -256,16 +256,31 @@ static sci_t make_sci(const u8 *addr, __be16 port)
 	return sci;
 }
 
-static sci_t macsec_frame_sci(struct macsec_eth_header *hdr, bool sci_present)
+static sci_t macsec_frame_sci(struct macsec_eth_header *hdr, bool sci_present,
+		struct macsec_rxh_data *rxd)
 {
+	struct macsec_dev *macsec_device;
 	sci_t sci;
 
-	if (sci_present)
+	if (sci_present) {
 		memcpy(&sci, hdr->secure_channel_id,
-		       sizeof(hdr->secure_channel_id));
-	else
+			sizeof(hdr->secure_channel_id));
+	} else if (0 == (hdr->tci_an & (MACSEC_TCI_ES | MACSEC_TCI_SC))) {
+		list_for_each_entry_rcu(macsec_device, &rxd->secys, secys) {
+			struct macsec_rx_sc *rx_sc;
+			struct macsec_secy *secy = &macsec_device->secy;
+
+			for_each_rxsc(secy, rx_sc) {
+				rx_sc = rx_sc ? macsec_rxsc_get(rx_sc) : NULL;
+				if (rx_sc && rx_sc->active)
+					return rx_sc->sci;
+			}
+			/* If not found, use MAC in hdr as default*/
+			sci = make_sci(hdr->eth.h_source, MACSEC_PORT_ES);
+		}
+	} else {
 		sci = make_sci(hdr->eth.h_source, MACSEC_PORT_ES);
-
+	}
 	return sci;
 }
 
@@ -1150,11 +1165,12 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 
 	macsec_skb_cb(skb)->has_sci = !!(hdr->tci_an & MACSEC_TCI_SC);
 	macsec_skb_cb(skb)->assoc_num = hdr->tci_an & MACSEC_AN_MASK;
-	sci = macsec_frame_sci(hdr, macsec_skb_cb(skb)->has_sci);
 
 	rcu_read_lock();
 	rxd = macsec_data_rcu(skb->dev);
 
+	sci = macsec_frame_sci(hdr, macsec_skb_cb(skb)->has_sci, rxd);
+
 	list_for_each_entry_rcu(macsec, &rxd->secys, secys) {
 		struct macsec_rx_sc *sc = find_rx_sc(&macsec->secy, sci);
 
-- 
2.34.1


