Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC02936D6E6
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 14:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbhD1MBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 08:01:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46756 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbhD1MBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 08:01:03 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lbirS-00083n-E7; Wed, 28 Apr 2021 12:00:10 +0000
From:   Colin King <colin.king@canonical.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: dsa: ksz: Make reg_mib_cnt a u8 as it never exceeds 255
Date:   Wed, 28 Apr 2021 13:00:10 +0100
Message-Id: <20210428120010.337959-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the for-loop in ksz8_port_init_cnt is causing a static
analysis infinite loop warning with the comparison of
mib->cnt_ptr < dev->reg_mib_cnt. This occurs because mib->cnt_ptr
is a u8 and dev->reg_mib_cnt is an int and the analyzer determines
that mib->cnt_ptr potentially can wrap around to zero if the value
in dev->reg_mib_cnt is > 255. However, this value is never this
large, it is always less than 256 so make reg_mib_cnt a u8.

Addresses-Coverity: ("Infinite loop")
Fixes: e66f840c08a2 ("net: dsa: ksz: Add Microchip KSZ8795 DSA driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/dsa/microchip/ksz_common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index e0bbdca64375..2e6bfd333f50 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -69,7 +69,7 @@ struct ksz_device {
 	int cpu_ports;			/* port bitmap can be cpu port */
 	int phy_port_cnt;
 	int port_cnt;
-	int reg_mib_cnt;
+	u8 reg_mib_cnt;
 	int mib_cnt;
 	const struct mib_names *mib_names;
 	phy_interface_t compat_interface;
-- 
2.30.2

