Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B649A8B59
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387450AbfIDQCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 12:02:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732345AbfIDQCh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 12:02:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2283323400;
        Wed,  4 Sep 2019 16:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612956;
        bh=/8h4w5nhnaGMZpvxL/ubUdla9HWv3VMjKfYOeJcLnj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nxPogHUER0gVhbJ7OP4JRwf6ZCrTDQa306skHdFD9QvfkJD0ytfzctbarzAPpJ5Fc
         qLrOrT+6AMBzjdlok2mRcDTo1qYTy/P05VlIkzp7fGxars2bGI3U2zUr22yczUiE9O
         3E48zN3zthC6yxqvPxUgFPgKAruazH5D+iLx7zUs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 12/27] batman-adv: Only read OGM2 tvlv_len after buffer len check
Date:   Wed,  4 Sep 2019 12:02:05 -0400
Message-Id: <20190904160220.4545-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160220.4545-1-sashal@kernel.org>
References: <20190904160220.4545-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit 0ff0f15a32c093381ad1abc06abe85afb561ab28 ]

Multiple batadv_ogm2_packet can be stored in an skbuff. The functions
batadv_v_ogm_send_to_if() uses batadv_v_ogm_aggr_packet() to check if there
is another additional batadv_ogm2_packet in the skb or not before they
continue processing the packet.

The length for such an OGM2 is BATADV_OGM2_HLEN +
batadv_ogm2_packet->tvlv_len. The check must first check that at least
BATADV_OGM2_HLEN bytes are available before it accesses tvlv_len (which is
part of the header. Otherwise it might try read outside of the currently
available skbuff to get the content of tvlv_len.

Fixes: 9323158ef9f4 ("batman-adv: OGMv2 - implement originators logic")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bat_v_ogm.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/batman-adv/bat_v_ogm.c b/net/batman-adv/bat_v_ogm.c
index 1aeeadca620cd..f435435b447e0 100644
--- a/net/batman-adv/bat_v_ogm.c
+++ b/net/batman-adv/bat_v_ogm.c
@@ -618,17 +618,23 @@ batadv_v_ogm_process_per_outif(struct batadv_priv *bat_priv,
  * batadv_v_ogm_aggr_packet - checks if there is another OGM aggregated
  * @buff_pos: current position in the skb
  * @packet_len: total length of the skb
- * @tvlv_len: tvlv length of the previously considered OGM
+ * @ogm2_packet: potential OGM2 in buffer
  *
  * Return: true if there is enough space for another OGM, false otherwise.
  */
-static bool batadv_v_ogm_aggr_packet(int buff_pos, int packet_len,
-				     __be16 tvlv_len)
+static bool
+batadv_v_ogm_aggr_packet(int buff_pos, int packet_len,
+			 const struct batadv_ogm2_packet *ogm2_packet)
 {
 	int next_buff_pos = 0;
 
-	next_buff_pos += buff_pos + BATADV_OGM2_HLEN;
-	next_buff_pos += ntohs(tvlv_len);
+	/* check if there is enough space for the header */
+	next_buff_pos += buff_pos + sizeof(*ogm2_packet);
+	if (next_buff_pos > packet_len)
+		return false;
+
+	/* check if there is enough space for the optional TVLV */
+	next_buff_pos += ntohs(ogm2_packet->tvlv_len);
 
 	return (next_buff_pos <= packet_len) &&
 	       (next_buff_pos <= BATADV_MAX_AGGREGATION_BYTES);
@@ -775,7 +781,7 @@ int batadv_v_ogm_packet_recv(struct sk_buff *skb,
 	ogm_packet = (struct batadv_ogm2_packet *)skb->data;
 
 	while (batadv_v_ogm_aggr_packet(ogm_offset, skb_headlen(skb),
-					ogm_packet->tvlv_len)) {
+					ogm_packet)) {
 		batadv_v_ogm_process(skb, ogm_offset, if_incoming);
 
 		ogm_offset += BATADV_OGM2_HLEN;
-- 
2.20.1

