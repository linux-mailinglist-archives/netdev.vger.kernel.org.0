Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789EE3723C5
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 02:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbhEDAEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 20:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhEDAEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 20:04:10 -0400
X-Greylist: delayed 1007 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 03 May 2021 17:03:16 PDT
Received: from warlock.wand.net.nz (warlock.cms.waikato.ac.nz [IPv6:2001:df0:4:4000::250:15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CE6C061574
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 17:03:16 -0700 (PDT)
Received: from [2001:df0:4:4000:c095:9afc:9c4c:6607] (helo=mantra.wand.net.nz)
        by warlock.wand.net.nz with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA256:128)
        (Exim 4.80)
        (envelope-from <rsanger@wand.net.nz>)
        id 1ldiGh-00015f-LZ; Tue, 04 May 2021 11:46:28 +1200
From:   Richard Sanger <rsanger@wand.net.nz>
To:     netdev@vger.kernel.org
Cc:     Richard Sanger <rsanger@wand.net.nz>
Subject: [PATCH] net: packetmmap: fix only tx timestamp on request
Date:   Tue,  4 May 2021 11:46:19 +1200
Message-Id: <1620085579-5646-1-git-send-email-rsanger@wand.net.nz>
X-Mailer: git-send-email 2.7.4
Received-SPF: pass client-ip=2001:df0:4:4000:c095:9afc:9c4c:6607; envelope-from=rsanger@wand.net.nz; helo=mantra.wand.net.nz
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The packetmmap tx ring should only return timestamps if requested,
as documented. This allows compatibility with non-timestamp aware
user-space code which checks tp_status == TP_STATUS_AVAILABLE;
not expecting additional timestamp flags to be set.

Signed-off-by: Richard Sanger <rsanger@wand.net.nz>
---
 net/packet/af_packet.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index ba96db1..b69805e 100644
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
@@ -2340,7 +2341,10 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 
 	skb_copy_bits(skb, 0, h.raw + macoff, snaplen);
 
-	if (!(ts_status = tpacket_get_timestamp(skb, &ts, po->tp_tstamp)))
+	/* always timestamp; prefer an existing software timestamp */
+	ts_status = tpacket_get_timestamp(skb, &ts,
+					  po->tp_tstamp | SOF_TIMESTAMPING_SOFTWARE);
+	if (!ts_status)
 		ktime_get_real_ts64(&ts);
 
 	status |= ts_status;
-- 
2.7.4

