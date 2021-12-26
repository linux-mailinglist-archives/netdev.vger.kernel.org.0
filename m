Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C7947F93A
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 23:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbhLZWNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 17:13:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbhLZWNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 17:13:06 -0500
Received: from mirix.in-vpn.de (mirix.in-vpn.de [IPv6:2001:67c:1407:a0::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61DCC06173E;
        Sun, 26 Dec 2021 14:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mirix.org;
        s=43974b1a7d21b2cf; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
        Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tgHGPu1ikQudG7nsJV4X7OT8YW5c+BIQSOLKgW7XdCU=; b=lASxZIVI4ur23ykWb/n/H3r1Gd
        +iGHsiLSDM3+4FI8ZBEyqixkPNbkvHUaQ/gB9lVUiXjhwc2Q/B514TdyajfLIgSHK0Z8E5AUH5FlV
        3ZDok+H556RQKX8aHnzi0s7yajXklNNzOpJ0WFJCUxcVUB5zB4+uNWhPTtrj5IKr7imtjSm4iQlSN
        mLYcRkd5tSHIr1KVlM/kGLeQudtIRIvxXVUM1Sp8h4Cq5Fs2+qne7eoUSSHIjnPkZImg7OqnsSGaR
        m+DyiIFwSdDE3VMoW4B9NIK5J4zpfKHuipAeIs70D4TT6puij5ZBwkENJcSt6XKAXchgc4QIZDhVk
        RjLRdwXg==;
Received: from [::1] (helo=localhost.localdomain)
        by mirix.in-vpn.de with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim)
        id 1n1blG-00064h-RU; Sun, 26 Dec 2021 22:13:02 +0000
From:   Matthias-Christian Ott <ott@mirix.org>
To:     Petko Manolov <petkan@nucleusys.com>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        Matthias-Christian Ott <ott@mirix.org>
Subject: [PATCH net v2] net: usb: pegasus: Do not drop long Ethernet frames
Date:   Sun, 26 Dec 2021 23:12:08 +0100
Message-Id: <20211226221208.2583-1-ott@mirix.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The D-Link DSB-650TX (2001:4002) is unable to receive Ethernet frames
that are longer than 1518 octets, for example, Ethernet frames that
contain 802.1Q VLAN tags.

The frames are sent to the pegasus driver via USB but the driver
discards them because they have the Long_pkt field set to 1 in the
received status report. The function read_bulk_callback of the pegasus
driver treats such received "packets" (in the terminology of the
hardware) as errors but the field simply does just indicate that the
Ethernet frame (MAC destination to FCS) is longer than 1518 octets.

It seems that in the 1990s there was a distinction between
"giant" (> 1518) and "runt" (< 64) frames and the hardware includes
flags to indicate this distinction. It seems that the purpose of the
distinction "giant" frames was to not allow infinitely long frames due
to transmission errors and to allow hardware to have an upper limit of
the frame size. However, the hardware already has such limit with its
2048 octet receive buffer and, therefore, Long_pkt is merely a
convention and should not be treated as a receive error.

Actually, the hardware is even able to receive Ethernet frames with 2048
octets which exceeds the claimed limit frame size limit of the driver of
1536 octets (PEGASUS_MTU).

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Matthias-Christian Ott <ott@mirix.org>
---
V1 -> V2: Included "Fixes:" tag

 drivers/net/usb/pegasus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 140d11ae6688..2582daf23015 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -499,11 +499,11 @@ static void read_bulk_callback(struct urb *urb)
 		goto goon;
 
 	rx_status = buf[count - 2];
-	if (rx_status & 0x1e) {
+	if (rx_status & 0x1c) {
 		netif_dbg(pegasus, rx_err, net,
 			  "RX packet error %x\n", rx_status);
 		net->stats.rx_errors++;
-		if (rx_status & 0x06)	/* long or runt	*/
+		if (rx_status & 0x04)	/* runt	*/
 			net->stats.rx_length_errors++;
 		if (rx_status & 0x08)
 			net->stats.rx_crc_errors++;
-- 
2.30.2

