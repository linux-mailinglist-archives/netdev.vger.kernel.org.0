Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5161C2AB86B
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 13:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729648AbgKIMkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 07:40:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51131 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgKIMkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 07:40:14 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kc6Su-0004zh-OY; Mon, 09 Nov 2020 12:40:08 +0000
From:   Colin King <colin.king@canonical.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: dsa: fix unintended sign extension on a u16 left shift
Date:   Mon,  9 Nov 2020 12:40:08 +0000
Message-Id: <20201109124008.2079873-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The left shift of u16 variable high is promoted to the type int and
then sign extended to a 64 bit u64 value.  If the top bit of high is
set then the upper 32 bits of the result end up being set by the
sign extension. Fix this by explicitly casting the value in high to
a u64 before left shifting by 16 places.

Also, remove the initialisation of variable value to 0 at the start
of each loop iteration as the value is never read and hence the
assignment it is redundant.

Addresses-Coverity: ("Unintended sign extension")
Fixes: e4b27ebc780f ("net: dsa: Add DSA driver for Hirschmann Hellcreek switches")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index dfa66f7260d6..d42f40c76ba5 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -308,7 +308,7 @@ static void hellcreek_get_ethtool_stats(struct dsa_switch *ds, int port,
 		const struct hellcreek_counter *counter = &hellcreek_counter[i];
 		u8 offset = counter->offset + port * 64;
 		u16 high, low;
-		u64 value = 0;
+		u64 value;
 
 		mutex_lock(&hellcreek->reg_lock);
 
@@ -320,7 +320,7 @@ static void hellcreek_get_ethtool_stats(struct dsa_switch *ds, int port,
 		 */
 		high  = hellcreek_read(hellcreek, HR_CRDH);
 		low   = hellcreek_read(hellcreek, HR_CRDL);
-		value = (high << 16) | low;
+		value = ((u64)high << 16) | low;
 
 		hellcreek_port->counter_values[i] += value;
 		data[i] = hellcreek_port->counter_values[i];
-- 
2.28.0

