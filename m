Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFBA170627
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 18:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgBZReK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 12:34:10 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:54686 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726695AbgBZReJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 12:34:09 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 627D0B80084;
        Wed, 26 Feb 2020 17:34:08 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 26 Feb 2020 17:33:22 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net] sfc: fix timestamp reconstruction at 16-bit rollover
 points
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
Message-ID: <ec166593-f68f-7834-e260-cd8ec6533054@solarflare.com>
Date:   Wed, 26 Feb 2020 17:33:19 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25254.003
X-TM-AS-Result: No-8.733100-8.000000-10
X-TMASE-MatchedRID: Nfvp/n5ZPlyczisXkLghgyNHByyOpYYClS5IbQ8u3TpJfyfUaPjAAU+m
        MtGpzwaWBew7/wAwiM0A/Q43xHXqx6H2g9syPs888Kg68su2wyFLXPA26IG0hN9RlPzeVuQQNaR
        gQ20sMyJB/OPnryYt6sq6e77Mgqlnr9KUdnnQCWxo9ddFVIEGi0ewdu9S21aifyjNXlbBvnQF2S
        1V5QxD3TqRrKEz1WT+rkOiPvIbhYI/m3DAGhtJ3rdHEv7sR/OwbaH3VbOE/TlpsnGGIgWMmT0Az
        Z9LNhUviborFBsIQOuuZ3ZhBb1yQ2d4rNn/zJIrndu3heVAxaNMhH/KpYxyu46/j5xrRs7T8P3P
        /jAMQ1MlNmfS6A/uHJsoi2XrUn/JyeMtMD9QOgAYvR9ppOlv1vcUt5lc1lLgRktVxdpRt2LxGmH
        ZNeitJDjf4ThtY9CGiBv7xN8NyK6qmNwUDsmgup6oP1a0mRIj
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.733100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25254.003
X-MDID: 1582738449-9SLgBG6u8RTS
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can't just use the top bits of the last sync event as they could be
off-by-one every 65,536 seconds, giving an error in reconstruction of
65,536 seconds.

This patch uses the difference in the bottom 16 bits (mod 2^16) to
calculate an offset that needs to be applied to the last sync event to
get to the current time.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/ptp.c | 38 +++++++++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index af15a737c675..59b4f16896a8 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -560,13 +560,45 @@ efx_ptp_mac_nic_to_ktime_correction(struct efx_nic *efx,
 				    u32 nic_major, u32 nic_minor,
 				    s32 correction)
 {
+	u32 sync_timestamp;
 	ktime_t kt = { 0 };
+	s16 delta;
 
 	if (!(nic_major & 0x80000000)) {
 		WARN_ON_ONCE(nic_major >> 16);
-		/* Use the top bits from the latest sync event. */
-		nic_major &= 0xffff;
-		nic_major |= (last_sync_timestamp_major(efx) & 0xffff0000);
+
+		/* Medford provides 48 bits of timestamp, so we must get the top
+		 * 16 bits from the timesync event state.
+		 *
+		 * We only have the lower 16 bits of the time now, but we do
+		 * have a full resolution timestamp at some point in past. As
+		 * long as the difference between the (real) now and the sync
+		 * is less than 2^15, then we can reconstruct the difference
+		 * between those two numbers using only the lower 16 bits of
+		 * each.
+		 *
+		 * Put another way
+		 *
+		 * a - b = ((a mod k) - b) mod k
+		 *
+		 * when -k/2 < (a-b) < k/2. In our case k is 2^16. We know
+		 * (a mod k) and b, so can calculate the delta, a - b.
+		 *
+		 */
+		sync_timestamp = last_sync_timestamp_major(efx);
+
+		/* Because delta is s16 this does an implicit mask down to
+		 * 16 bits which is what we need, assuming
+		 * MEDFORD_TX_SECS_EVENT_BITS is 16. delta is signed so that
+		 * we can deal with the (unlikely) case of sync timestamps
+		 * arriving from the future.
+		 */
+		delta = nic_major - sync_timestamp;
+
+		/* Recover the fully specified time now, by applying the offset
+		 * to the (fully specified) sync time.
+		 */
+		nic_major = sync_timestamp + delta;
 
 		kt = ptp->nic_to_kernel_time(nic_major, nic_minor,
 					     correction);
-- 
2.20.1

