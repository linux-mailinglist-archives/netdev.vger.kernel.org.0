Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F29C37A0AF
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 09:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhEKHUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 03:20:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37451 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229736AbhEKHUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 03:20:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620717585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=/Q3neiC04csk317WqDxjFNYrEG2KcUer6fxzvQaObPw=;
        b=HeC130k16efAKzwD37NZ0X6Sc7NiX7yQlhgiHQIcGKMs0tpEZM31qw4lOP8sfigIcz6lu5
        QFF0Gb7dYJzi22YzdW9EmS7XUSOv32d7V6oOMoz3VXfEbSYey+xpnBcIh6/eFajEmbdNNU
        gqqMwtR+cPIivk6dMEXIoAYkKRwsc08=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-dt3jF4LsMPeUNFywv1W3WA-1; Tue, 11 May 2021 03:19:44 -0400
X-MC-Unique: dt3jF4LsMPeUNFywv1W3WA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D93BC6D4E6;
        Tue, 11 May 2021 07:19:42 +0000 (UTC)
Received: from localhost.localdomain (ovpn-112-191.ams2.redhat.com [10.36.112.191])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 17F8E6E6F5;
        Tue, 11 May 2021 07:19:40 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     Jes.Sorensen@gmail.com, kvalo@codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        ihuguet@redhat.com
Subject: [PATCH] rtl8xxxu: avoid parsing short RX packet
Date:   Tue, 11 May 2021 09:19:27 +0200
Message-Id: <20210511071926.8951-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One USB data buffer can contain multiple received network
packets. If that's the case, they're processed this way:
1. Original buffer is cloned
2. Original buffer is trimmed to contain only the first
   network packet
3. This first network packet is passed to network stack
4. Cloned buffer is trimmed to eliminate the first network
   packet
5. Repeat with the cloned buffer until there are no more
   network packets inside

However, if the space remaining in original buffer after
the first network packet is not enough to contain at least
another network packet descriptor, it is not cloned.

The loop parsing this packets ended if remaining space == 0.
But if the remaining space was > 0 but < packet descriptor
size, another iteration of the loop was done, processing again
the previous packet because cloning didn't happen. Moreover,
the ownership of this packet had been passed to network
stack in the previous iteration.

This patch ensures that no extra iteration is done if the
remaining size is not enough for one packet, and also avoid
the first iteration for the same reason.

Probably this doesn't happen in practice, but can happen
theoretically.

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 9ff09cf7eb62..673961a82c40 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5554,6 +5554,11 @@ int rtl8xxxu_parse_rxdesc16(struct rtl8xxxu_priv *priv, struct sk_buff *skb)
 	urb_len = skb->len;
 	pkt_cnt = 0;
 
+	if (urb_len < sizeof(struct rtl8xxxu_rxdesc16)) {
+		kfree_skb(skb);
+		return RX_TYPE_ERROR;
+	}
+
 	do {
 		rx_desc = (struct rtl8xxxu_rxdesc16 *)skb->data;
 		_rx_desc_le = (__le32 *)skb->data;
@@ -5581,7 +5586,7 @@ int rtl8xxxu_parse_rxdesc16(struct rtl8xxxu_priv *priv, struct sk_buff *skb)
 		 * at least cover the rx descriptor
 		 */
 		if (pkt_cnt > 1 &&
-		    urb_len > (pkt_offset + sizeof(struct rtl8xxxu_rxdesc16)))
+		    urb_len >= (pkt_offset + sizeof(struct rtl8xxxu_rxdesc16)))
 			next_skb = skb_clone(skb, GFP_ATOMIC);
 
 		rx_status = IEEE80211_SKB_RXCB(skb);
@@ -5627,7 +5632,9 @@ int rtl8xxxu_parse_rxdesc16(struct rtl8xxxu_priv *priv, struct sk_buff *skb)
 
 		pkt_cnt--;
 		urb_len -= pkt_offset;
-	} while (skb && urb_len > 0 && pkt_cnt > 0);
+		next_skb = NULL;
+	} while (skb && pkt_cnt > 0 &&
+		 urb_len >= sizeof(struct rtl8xxxu_rxdesc16));
 
 	return RX_TYPE_DATA_PKT;
 }
-- 
2.31.1

