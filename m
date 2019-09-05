Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA54AA54F
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 16:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387759AbfIEOBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 10:01:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35577 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726968AbfIEOBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 10:01:39 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1i5sKO-00010M-1m; Thu, 05 Sep 2019 14:01:36 +0000
From:   Colin King <colin.king@canonical.com>
To:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] lan743x: remove redundant assignment to variable rx_process_result
Date:   Thu,  5 Sep 2019 15:01:35 +0100
Message-Id: <20190905140135.26951-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable rx_process_result is being initialized with a value that
is never read and is being re-assigned immediately afterwards. The
assignment is redundant, so replace it with the return from function
lan743x_rx_process_packet.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 15a8be6bad27..a43140f7b5eb 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -2172,9 +2172,8 @@ static int lan743x_rx_napi_poll(struct napi_struct *napi, int weight)
 	}
 	count = 0;
 	while (count < weight) {
-		int rx_process_result = -1;
+		int rx_process_result = lan743x_rx_process_packet(rx);
 
-		rx_process_result = lan743x_rx_process_packet(rx);
 		if (rx_process_result == RX_PROCESS_RESULT_PACKET_RECEIVED) {
 			count++;
 		} else if (rx_process_result ==
-- 
2.20.1

