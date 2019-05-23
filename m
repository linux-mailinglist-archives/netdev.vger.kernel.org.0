Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00F93289F3
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 21:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389998AbfEWTna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 15:43:30 -0400
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:34020 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389505AbfEWTn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 15:43:29 -0400
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 May 2019 15:43:29 EDT
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 23 May 2019 12:37:26 -0700
X-IronPort-AV: E=McAfee;i="5900,7806,9266"; a="337549333"
Received: from stranche-lnx.qualcomm.com ([129.46.14.77])
  by ironmsg01-sd.qualcomm.com with ESMTP; 23 May 2019 12:37:25 -0700
Received: by stranche-lnx.qualcomm.com (Postfix, from userid 383980)
        id 415364368; Thu, 23 May 2019 13:37:25 -0600 (MDT)
From:   Sean Tranchetti <stranche@codeaurora.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Sean Tranchetti <stranche@codeaurora.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH net-next] udp: Avoid post-GRO UDP checksum recalculation
Date:   Thu, 23 May 2019 13:36:17 -0600
Message-Id: <1558640177-10984-1-git-send-email-stranche@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when resegmenting an unexpected UDP GRO packet, the full UDP
checksum will be calculated for every new SKB created by skb_segment()
because the netdev features passed in by udp_rcv_segment() lack any
information about checksum offload capabilities.

We have no need to perform this calculation again, as
  1) The GRO implementation guarantees that any packets making it to the
     udp_rcv_segment() function had correct checksums, and, more
     importantly,
  2) Upon the successful return of udp_rcv_segment(), we immediately pull
     the UDP header off and either queue the segment to the socket or
     hand it off to a new protocol handler. In either case, the checksum
     is not needed.

Fixes: cf329aa42b66 ("udp: cope with UDP GRO packet misdirection")
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
---
 include/net/udp.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/net/udp.h b/include/net/udp.h
index d8ce937..6164d5c 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -472,11 +472,15 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
 					      struct sk_buff *skb, bool ipv4)
 {
 	struct sk_buff *segs;
+	netdev_features_t features = NETIF_F_SG;
+
+	/* Avoid csum recalculation in skb_segment() */
+	features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
 
 	/* the GSO CB lays after the UDP one, no need to save and restore any
 	 * CB fragment
 	 */
-	segs = __skb_gso_segment(skb, NETIF_F_SG, false);
+	segs = __skb_gso_segment(skb, features, false);
 	if (unlikely(IS_ERR_OR_NULL(segs))) {
 		int segs_nr = skb_shinfo(skb)->gso_segs;
 
-- 
1.9.1

