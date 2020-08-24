Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C67250527
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 19:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728403AbgHXRLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 13:11:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728392AbgHXQhy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 12:37:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 735F022D70;
        Mon, 24 Aug 2020 16:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598287030;
        bh=Y+dzBIhGF+kbEmw58dJ4IZaOWYovq8f4Yu+nhkSCnkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ov6q7qK3VBYSw1I08FHAy5RhExDJDcFUz0SVjqJdKN46zKfS0bDZ3pr9iGXX2x/Uz
         szUYn1aNRK1iVzS4WTsk97pIzopuNOqpUHMOR5Pdh2MjhailubQE+bwyop4CqqoApR
         4S/JTsPkA9dH719zfKcFcBYrsvopDntHVuNtYL1s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 26/54] can: j1939: transport: j1939_xtp_rx_dat_one(): compare own packets to detect corruptions
Date:   Mon, 24 Aug 2020 12:36:05 -0400
Message-Id: <20200824163634.606093-26-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163634.606093-1-sashal@kernel.org>
References: <20200824163634.606093-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit e052d0540298bfe0f6cbbecdc7e2ea9b859575b2 ]

Since the stack relays on receiving own packets, it was overwriting own
transmit buffer from received packets.

At least theoretically, the received echo buffer can be corrupt or
changed and the session partner can request to resend previous data. In
this case we will re-send bad data.

With this patch we will stop to overwrite own TX buffer and use it for
sanity checking.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20200807105200.26441-6-o.rempel@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/j1939/transport.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 9f99af5b0b11e..3e9c377b0dcce 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1769,7 +1769,20 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
 	}
 
 	tpdat = se_skb->data;
-	memcpy(&tpdat[offset], &dat[1], nbytes);
+	if (!session->transmission) {
+		memcpy(&tpdat[offset], &dat[1], nbytes);
+	} else {
+		int err;
+
+		err = memcmp(&tpdat[offset], &dat[1], nbytes);
+		if (err)
+			netdev_err_once(priv->ndev,
+					"%s: 0x%p: Data of RX-looped back packet (%*ph) doesn't match TX data (%*ph)!\n",
+					__func__, session,
+					nbytes, &dat[1],
+					nbytes, &tpdat[offset]);
+	}
+
 	if (packet == session->pkt.rx)
 		session->pkt.rx++;
 
-- 
2.25.1

