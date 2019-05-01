Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F14F10435
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 05:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfEAD1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 23:27:55 -0400
Received: from gateway24.websitewelcome.com ([192.185.51.61]:37122 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726022AbfEAD1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 23:27:55 -0400
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 211028B48
        for <netdev@vger.kernel.org>; Tue, 30 Apr 2019 22:27:54 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id LfuUhLeMh2qH7LfuUheoxV; Tue, 30 Apr 2019 22:27:54 -0500
X-Authority-Reason: nr=8
Received: from [189.250.119.203] (port=55538 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hLfuA-003iPM-R4; Tue, 30 Apr 2019 22:27:53 -0500
Date:   Tue, 30 Apr 2019 22:27:32 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com, "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH net-next] wimax/i2400m: use struct_size() helper
Message-ID: <20190501032732.GA17956@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.250.119.203
X-Source-L: No
X-Exim-ID: 1hLfuA-003iPM-R4
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.119.203]:55538
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 4
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes, in particular in the
context in which this code is being used.

So, replace code of the following form:

sizeof(*tx_msg) + le16_to_cpu(tx_msg->num_pls) * sizeof(tx_msg->pld[0]);

with:

struct_size(tx_msg, pld, le16_to_cpu(tx_msg->num_pls));

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wimax/i2400m/tx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wimax/i2400m/tx.c b/drivers/net/wimax/i2400m/tx.c
index f20886ade1cc..ebd64e083726 100644
--- a/drivers/net/wimax/i2400m/tx.c
+++ b/drivers/net/wimax/i2400m/tx.c
@@ -640,8 +640,7 @@ void i2400m_tx_close(struct i2400m *i2400m)
 	 * figure out where the next TX message starts (and where the
 	 * offset to the moved header is).
 	 */
-	hdr_size = sizeof(*tx_msg)
-		+ le16_to_cpu(tx_msg->num_pls) * sizeof(tx_msg->pld[0]);
+	hdr_size = struct_size(tx_msg, pld, le16_to_cpu(tx_msg->num_pls));
 	hdr_size = ALIGN(hdr_size, I2400M_PL_ALIGN);
 	tx_msg->offset = I2400M_TX_PLD_SIZE - hdr_size;
 	tx_msg_moved = (void *) tx_msg + tx_msg->offset;
-- 
2.21.0

