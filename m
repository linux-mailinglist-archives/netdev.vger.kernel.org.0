Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4866F1A7717
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 11:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437476AbgDNJME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 05:12:04 -0400
Received: from mail-db8eur05on2051.outbound.protection.outlook.com ([40.107.20.51]:13120
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2437468AbgDNJLv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 05:11:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mbB6sWOr2tBsrQR0B1XnAYrQqjLzlAod0fOY+b+9ahIaRh9gJdg7ytVrykGJAtQ2WItl9Dnw9Zknl3a80uSS2dlRtN9Qy/Q4sTFmC0CYXhY118/sdsWgbwpv46rocyQSqbTLxkJBaHLA50ILsilgJdivaS+VPMel/ZT1f6NiI0QfuTN/a3zYTNQBcf1VK7UIptVF2Tk7HJDJ+KkPvhW5yqkrmJJzyEm3kvn0s+IveyXzGrLsbr1j4uKSedZUAVPf5p/Orl89/vk5EzyFlXYQmI1+cYOfDQFdHM+yHjRPzcQeLiHFFD3JUGIqdspdnP1wColA7V1zAw85Coc1A8m2sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R/Q+etm80ix8gTdo7DeWt1KNabGAUSedcWWApijw7Rk=;
 b=J/A3AZnDnDOx1XucziTnr2ICZx0mj4O4G/UoaOm/9HsF4moU+mUDFHanOA/LUcoq/EWWeOeq2WOJUWYaa633FruugYhZtr3OBJoLoBKaIubz0/3W2/3u92bL57nYTTvYTToGue64y1mruboF+E46qwlhNy1sTvCt1Du5XDLQiSSdsPXmI0J66RwXEu27Mk091pf7YCxQOAZoE/8bopoDMISgSch06i80khfSIQcQXNa0uggPfRGxJJx+JdaBy5FrF/BhAse2KsFBipNgzHvjoFooIuMr92ehYKUDu3lMBfzz+TgQhqaTgT9nueLB6LZ9IuX2uHm+GaxHtOtDGTmloA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=orolia.com; dmarc=pass action=none header.from=orolia.com;
 dkim=pass header.d=orolia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orolia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R/Q+etm80ix8gTdo7DeWt1KNabGAUSedcWWApijw7Rk=;
 b=FC0Y15NEaJbAFjUXdoF6FDBWXT8Ij14Yp+oJbOC7EGNxmsg0BqXxC1bWX79hnPaWlFdeyHn9XscSYfrsrmdF3srd9+ByXGmR54Idlm6G+9cK9ZS6umspZQBbgPxjy4wQKhKKqfWKIocVSXTxISmuHbpLj+rHit/Kf4guZO7vqh8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=julien.beraud@orolia.com; 
Received: from AM5PR06MB3043.eurprd06.prod.outlook.com (2603:10a6:206:3::26)
 by AM5PR06MB3057.eurprd06.prod.outlook.com (2603:10a6:206:f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.28; Tue, 14 Apr
 2020 09:11:47 +0000
Received: from AM5PR06MB3043.eurprd06.prod.outlook.com
 ([fe80::7893:2451:4039:f36b]) by AM5PR06MB3043.eurprd06.prod.outlook.com
 ([fe80::7893:2451:4039:f36b%7]) with mapi id 15.20.2900.026; Tue, 14 Apr 2020
 09:11:47 +0000
From:   Julien Beraud <julien.beraud@orolia.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Julien Beraud <julien.beraud@orolia.com>
Subject: [PATCH 2/2] net: stmmac: Fix sub-second increment
Date:   Tue, 14 Apr 2020 11:10:03 +0200
Message-Id: <20200414091003.7629-2-julien.beraud@orolia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200414091003.7629-1-julien.beraud@orolia.com>
References: <20200414091003.7629-1-julien.beraud@orolia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0318.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::18) To AM5PR06MB3043.eurprd06.prod.outlook.com
 (2603:10a6:206:3::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from julien.spectracom.local (2a01:cb00:87a9:7d00:9d00:f9d3:1f5a:64cc) by LO2P265CA0318.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Tue, 14 Apr 2020 09:11:46 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:cb00:87a9:7d00:9d00:f9d3:1f5a:64cc]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0441c4ad-b3aa-4a67-88ef-08d7e053dbe6
X-MS-TrafficTypeDiagnostic: AM5PR06MB3057:|AM5PR06MB3057:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM5PR06MB3057F5A298DD2E4B76F870CD99DA0@AM5PR06MB3057.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0373D94D15
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR06MB3043.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(396003)(366004)(39850400004)(346002)(136003)(4326008)(6506007)(81156014)(110136005)(6486002)(2906002)(316002)(5660300002)(8936002)(186003)(8676002)(16526019)(478600001)(66946007)(86362001)(6666004)(52116002)(36756003)(1076003)(107886003)(66476007)(44832011)(6512007)(2616005)(66556008);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: orolia.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /fk+81g1J6g4KibzDvrmUKx92NIrbiNS+ZFuaG6ydvYabiMDZRxkYh2BZUx1kO9qvl0uwYtKotMuCyngy2GiTxiuNo4XdFDM7M/dCfwaixmITNb3Xy1EzBObmwb3b4GM6MM6DL6vblYOhBYI/0T5MFjG5WSszf0mkqGSzbWYYB3aOh1yV7mnMCMghOnHiJR6LEoWbz+lq4us9BxeLObstocczYFdqRDuyWzbE2ozAVZnYHir+TVSMSOdLgfd3WbWStgOVE2uzPOQOUL32MactaOEKdgHZhwGQai5mIY6IRJE8CcK8UcfKYf21rJyL7qaR3HiJjwNBF40HpsK5OB1t9O9U/N71M8JhPiwrs3k/IVGhSY0DbFz3+DdNhs/49RHzyxVit48c3uwXJwqbyZLm2dR1H8XKc6vyV7QB8j6sF/Ia9VcpS8BTu4cgtNHW+h3
X-MS-Exchange-AntiSpam-MessageData: WiAsJwe2eD2SuBlq+KPdJsSPXFt1hzWPTtHB+ljMMfzwQzJ6fHBD4RUNV3NiQH9Grf+tHz7TJ4+kxsdfB9nwr29k8s7QvKTrnhQ/DOzf7QPBENKYHf/3PQr5k+paptMzgGlf+0zdsOY8PD9Sm/iYh6oYHFVJ939alxtVYt2zyoVAl0WdhBXGGP41h0iXcnz6ecNewxCYBHCe4/a8Om6R8w==
X-OriginatorOrg: orolia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0441c4ad-b3aa-4a67-88ef-08d7e053dbe6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2020 09:11:47.4349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a263030c-9c1b-421f-9471-1dec0b29c664
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YmHfEWPGLDJurgu+kszIJGLtAMx6wJtCdcYG31uzh34FK0/ujcIOVxpj6PLqrWQXFdBx8g2PHKpM7KuECe7zoSK6hf7eMVt5JeNsz0ynjBA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR06MB3057
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In fine adjustement mode, which is the current default, the sub-second
increment register is the number of nanoseconds that wil be added to the
clock when the accumulator overflows. At each clock cycle, the value of
the addend register is added to the accumulator.
Currently, we use 20ns = 1e09ns / 50MHz as this value whatever the
frequency of the ptp clock actually is.
The adjustment is then done on the addend register, only incrementing
every X clock cycles X being the ratio between 50MHz and ptp_clock_rate
(addend = 2^31 * 50MHz/ptp_clock_rate).
First of all there is a bug that was already solved in the past in that
it should be 40ns = 2e09ns / 50MHz - (the accumulator can only overflow
once every 2 additions)
Even with this issue fixed, this has following consequences :
- The resolution of the timestamping clock is limited to 40ns while it
  is not needed, thus limiting the accuracy of the timestamping to 40ns.
- In case the frequency of the ptp clock is inferior to 50MHz, the
  addend value will be set to 0 and the clock will simply not work.

Fix this by setting sub-second increment to 2e09ns / ptp_clock_rate and
setting the default value of addend to mid-range = 2^31. By doing this
we can reach the best possible resolution in the timestamps, only
incrementing the clock by the minimum possible value. This will also
work for frequencies below 50MHz (for instance using the internal osc1
clock at 25MHz for socfpga platforms).

Signed-off-by: Julien Beraud <julien.beraud@orolia.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c | 10 ++++++----
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c     | 11 ++---------
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
index fcf080243a0f..2438c7bbc7c9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -27,12 +27,14 @@ static void config_sub_second_increment(void __iomem *ioaddr,
 	unsigned long data;
 	u32 reg_value;
 
-	/* For GMAC3.x, 4.x versions, convert the ptp_clock to nano second
-	 *	formula = (1/ptp_clock) * 1000000000
-	 * where ptp_clock is 50MHz if fine method is used to update system
+	/* For GMAC3.x, 4.x versions, in "fine adjustement mode" set sub-second
+	 * increment to twice the number of nanoseconds of a clock cycle.
+	 * Setting the default addend value to mid range will make the
+	 * accumulator overflow once every 2 clock cycles, thus adding twice
+	 * the length of a clock cycle to the clock time.
 	 */
 	if (value & PTP_TCR_TSCFUPDT)
-		data = (1000000000ULL / 50000000);
+		data = (2000000000ULL / ptp_clock);
 	else
 		data = (1000000000ULL / ptp_clock);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e6898fd5223f..4ceddfa64b1d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -511,7 +511,6 @@ static int stmmac_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	struct hwtstamp_config config;
 	struct timespec64 now;
-	u64 temp = 0;
 	u32 ptp_v2 = 0;
 	u32 tstamp_all = 0;
 	u32 ptp_over_ipv4_udp = 0;
@@ -698,19 +697,13 @@ static int stmmac_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
 		stmmac_config_sub_second_increment(priv,
 				priv->ptpaddr, priv->plat->clk_ptp_rate,
 				xmac, &sec_inc);
-		temp = div_u64(1000000000ULL, sec_inc);
 
 		/* Store sub second increment and flags for later use */
 		priv->sub_second_inc = sec_inc;
 		priv->systime_flags = value;
 
-		/* calculate default added value:
-		 * formula is :
-		 * addend = (2^32)/freq_div_ratio;
-		 * where, freq_div_ratio = 1e9ns/sec_inc
-		 */
-		temp = (u64)(temp << 32);
-		priv->default_addend = div_u64(temp, priv->plat->clk_ptp_rate);
+		/* set default addend to mid-range */
+		priv->default_addend = (1 << 31);
 		stmmac_config_addend(priv, priv->ptpaddr, priv->default_addend);
 
 		/* initialize system time */
-- 
2.25.1

