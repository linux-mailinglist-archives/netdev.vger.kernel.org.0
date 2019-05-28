Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A537B2CE8E
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbfE1SYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 14:24:01 -0400
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:6354 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726576AbfE1SYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 14:24:01 -0400
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 28 May 2019 11:24:00 -0700
X-IronPort-AV: E=McAfee;i="5900,7806,9271"; a="340031320"
Received: from stranche-lnx.qualcomm.com ([129.46.14.77])
  by ironmsg01-sd.qualcomm.com with ESMTP; 28 May 2019 11:24:00 -0700
Received: by stranche-lnx.qualcomm.com (Postfix, from userid 383980)
        id 29EE84378; Tue, 28 May 2019 12:24:00 -0600 (MDT)
From:   Sean Tranchetti <stranche@codeaurora.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Sean Tranchetti <stranche@codeaurora.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH net-next v2] udp: Avoid post-GRO UDP checksum recalculation
Date:   Tue, 28 May 2019 12:22:54 -0600
Message-Id: <1559067774-613-1-git-send-email-stranche@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when resegmenting an unexpected UDP GRO packet, the full UDP
checksum will be calculated for every new SKB created by skb_segment()
because the netdev features passed in by udp_rcv_segment() lack any
information about checksum offload capabilities.

Usually, we have no need to perform this calculation again, as
  1) The GRO implementation guarantees that any packets making it to the
     udp_rcv_segment() function had correct checksums, and, more
     importantly,
  2) Upon the successful return of udp_rcv_segment(), we immediately pull
     the UDP header off and either queue the segment to the socket or
     hand it off to a new protocol handler.

Unless userspace has set the IP_CHECKSUM sockopt to indicate that they
want the final checksum values, we can pass the needed netdev feature
flags to __skb_gso_segment() to avoid checksumming each segment in
skb_segment().

Fixes: cf329aa42b66 ("udp: cope with UDP GRO packet misdirection")
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
---
 include/net/udp.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/net/udp.h b/include/net/udp.h
index d8ce937..dbe030d 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -471,12 +471,19 @@ struct udp_iter_state {
 static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
 					      struct sk_buff *skb, bool ipv4)
 {
+	netdev_features_t features = NETIF_F_SG;
 	struct sk_buff *segs;
 
+	/* Avoid csum recalculation by skb_segment unless userspace explicitly
+	 * asks for the final checksum values
+	 */
+	if (!inet_get_convert_csum(sk))
+		features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+
 	/* the GSO CB lays after the UDP one, no need to save and restore any
 	 * CB fragment
 	 */
-	segs = __skb_gso_segment(skb, NETIF_F_SG, false);
+	segs = __skb_gso_segment(skb, features, false);
 	if (unlikely(IS_ERR_OR_NULL(segs))) {
 		int segs_nr = skb_shinfo(skb)->gso_segs;
 
-- 
1.9.1

