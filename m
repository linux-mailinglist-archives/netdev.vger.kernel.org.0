Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F432A8A32
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732056AbfIDP6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 11:58:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732038AbfIDP6g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 11:58:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE0CA233FF;
        Wed,  4 Sep 2019 15:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612715;
        bh=Ce03TRONCo+jPJ4+G/qwwYAa7wCQSNf9hkEJ485RqsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mw3VkpxX0OcB98k9MaCtv5lyB8+ZN5bvW9b4/wUzmV4sc0qyFzMOajjd4Qc+DFpRr
         gk0kCvxL+Ef950UBbsk3UnA2rqJhk6qBUyk1WsoQFiIvdzgRLlUkhwpGJGPSQyBJ8+
         JlXHIT+u/jVkj13m261x+v61rp4RdLvyZ2qY3TtI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        syzbot+355cab184197dbbfa384@syzkaller.appspotmail.com,
        Antonio Quartulli <a@unstable.cc>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 38/94] batman-adv: Only read OGM tvlv_len after buffer len check
Date:   Wed,  4 Sep 2019 11:56:43 -0400
Message-Id: <20190904155739.2816-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit a15d56a60760aa9dbe26343b9a0ac5228f35d445 ]

Multiple batadv_ogm_packet can be stored in an skbuff. The functions
batadv_iv_ogm_send_to_if()/batadv_iv_ogm_receive() use
batadv_iv_ogm_aggr_packet() to check if there is another additional
batadv_ogm_packet in the skb or not before they continue processing the
packet.

The length for such an OGM is BATADV_OGM_HLEN +
batadv_ogm_packet->tvlv_len. The check must first check that at least
BATADV_OGM_HLEN bytes are available before it accesses tvlv_len (which is
part of the header. Otherwise it might try read outside of the currently
available skbuff to get the content of tvlv_len.

Fixes: ef26157747d4 ("batman-adv: tvlv - basic infrastructure")
Reported-by: syzbot+355cab184197dbbfa384@syzkaller.appspotmail.com
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Acked-by: Antonio Quartulli <a@unstable.cc>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bat_iv_ogm.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index 240ed70912d6a..d78938e3e0085 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -277,17 +277,23 @@ static u8 batadv_hop_penalty(u8 tq, const struct batadv_priv *bat_priv)
  * batadv_iv_ogm_aggr_packet() - checks if there is another OGM attached
  * @buff_pos: current position in the skb
  * @packet_len: total length of the skb
- * @tvlv_len: tvlv length of the previously considered OGM
+ * @ogm_packet: potential OGM in buffer
  *
  * Return: true if there is enough space for another OGM, false otherwise.
  */
-static bool batadv_iv_ogm_aggr_packet(int buff_pos, int packet_len,
-				      __be16 tvlv_len)
+static bool
+batadv_iv_ogm_aggr_packet(int buff_pos, int packet_len,
+			  const struct batadv_ogm_packet *ogm_packet)
 {
 	int next_buff_pos = 0;
 
-	next_buff_pos += buff_pos + BATADV_OGM_HLEN;
-	next_buff_pos += ntohs(tvlv_len);
+	/* check if there is enough space for the header */
+	next_buff_pos += buff_pos + sizeof(*ogm_packet);
+	if (next_buff_pos > packet_len)
+		return false;
+
+	/* check if there is enough space for the optional TVLV */
+	next_buff_pos += ntohs(ogm_packet->tvlv_len);
 
 	return (next_buff_pos <= packet_len) &&
 	       (next_buff_pos <= BATADV_MAX_AGGREGATION_BYTES);
@@ -315,7 +321,7 @@ static void batadv_iv_ogm_send_to_if(struct batadv_forw_packet *forw_packet,
 
 	/* adjust all flags and log packets */
 	while (batadv_iv_ogm_aggr_packet(buff_pos, forw_packet->packet_len,
-					 batadv_ogm_packet->tvlv_len)) {
+					 batadv_ogm_packet)) {
 		/* we might have aggregated direct link packets with an
 		 * ordinary base packet
 		 */
@@ -1704,7 +1710,7 @@ static int batadv_iv_ogm_receive(struct sk_buff *skb,
 
 	/* unpack the aggregated packets and process them one by one */
 	while (batadv_iv_ogm_aggr_packet(ogm_offset, skb_headlen(skb),
-					 ogm_packet->tvlv_len)) {
+					 ogm_packet)) {
 		batadv_iv_ogm_process(skb, ogm_offset, if_incoming);
 
 		ogm_offset += BATADV_OGM_HLEN;
-- 
2.20.1

