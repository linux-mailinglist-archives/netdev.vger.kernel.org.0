Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F2637B38D
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 03:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhELBde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 21:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbhELBdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 21:33:33 -0400
Received: from warlock.wand.net.nz (warlock.cms.waikato.ac.nz [IPv6:2001:df0:4:4000::250:15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61AFC061574
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 18:32:24 -0700 (PDT)
Received: from [2001:df0:4:4000:4db9:d736:1d15:94f4] (helo=mantra.wand.net.nz)
        by warlock.wand.net.nz with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <rsanger@wand.net.nz>)
        id 1lgdja-0002Sb-76; Wed, 12 May 2021 13:32:22 +1200
From:   Richard Sanger <rsanger@wand.net.nz>
To:     netdev@vger.kernel.org
Cc:     Richard Sanger <rsanger@wand.net.nz>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH v2] net: packetmmap: fix only tx timestamp on request
Date:   Wed, 12 May 2021 13:31:22 +1200
Message-Id: <1620783082-28906-1-git-send-email-rsanger@wand.net.nz>
X-Mailer: git-send-email 2.7.4
Received-SPF: pass client-ip=2001:df0:4:4000:4db9:d736:1d15:94f4; envelope-from=rsanger@wand.net.nz; helo=mantra.wand.net.nz
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The packetmmap tx ring should only return timestamps if requested via
setsockopt PACKET_TIMESTAMP, as documented. This allows compatibility
with non-timestamp aware user-space code which checks
tp_status == TP_STATUS_AVAILABLE; not expecting additional timestamp
flags to be set in tp_status.

Fixes: b9c32fb27170 ("packet: if hw/sw ts enabled in rx/tx ring, report which ts we got")
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Signed-off-by: Richard Sanger <rsanger@wand.net.nz>
---
 net/packet/af_packet.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index ba96db1..ae906eb 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -422,7 +422,8 @@ static __u32 tpacket_get_timestamp(struct sk_buff *skb, struct timespec64 *ts,
 	    ktime_to_timespec64_cond(shhwtstamps->hwtstamp, ts))
 		return TP_STATUS_TS_RAW_HARDWARE;
 
-	if (ktime_to_timespec64_cond(skb->tstamp, ts))
+	if ((flags & SOF_TIMESTAMPING_SOFTWARE) &&
+	    ktime_to_timespec64_cond(skb->tstamp, ts))
 		return TP_STATUS_TS_SOFTWARE;
 
 	return 0;
@@ -2340,7 +2341,12 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 
 	skb_copy_bits(skb, 0, h.raw + macoff, snaplen);
 
-	if (!(ts_status = tpacket_get_timestamp(skb, &ts, po->tp_tstamp)))
+	/* Always timestamp; prefer an existing software timestamp taken
+	 * closer to the time of capture.
+	 */
+	ts_status = tpacket_get_timestamp(skb, &ts,
+					  po->tp_tstamp | SOF_TIMESTAMPING_SOFTWARE);
+	if (!ts_status)
 		ktime_get_real_ts64(&ts);
 
 	status |= ts_status;
-- 
2.7.4

