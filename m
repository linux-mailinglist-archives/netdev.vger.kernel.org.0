Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385D842173F
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239048AbhJDTT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:19:26 -0400
Received: from mail-am6eur05on2057.outbound.protection.outlook.com ([40.107.22.57]:12353
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235428AbhJDTSt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 15:18:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NuvbJ7hXMa0Ma7nYmWzRmdNA0r3W9fjzgWSRvE1OjY/lV9fKC29jjoXHpC13mffoyQ0KDkPrdb1MxLzPISZjIjQxZJNPW8W56VFAakiWMuDrGao92Eow1yKtjnEIQVQUZ/HsP4/7WQINEdaoDWmCnaJ1aqgkxDRW+AB1Pi3+eozqg8V4DS1rGSyBi1d9dyj9idvFFMDCgw5VKx52u7fsXmnlqb2WbV7vFmYyAIZFZkP4APdZcPYT0QHCJ9YOocVvGgmaZ2BpXcwbsJnd1Dw2/GMtP/0jZhwGsbR3jaltKcBmYJTW0iB6/m3eqmt1nc2kdwYSRvxvG8yhxdoZFDzffQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z4bBuZ/vP65aPiqKv60GuXTqaKsZnUjlk6Au5WgResk=;
 b=OefMocCrTpW4zSS1gzjmpUy0Z996i4E4kuyn2Eqz/AKzkx2RoDvo/osErZwrnkqSY45dRWsPD9uoll0xwn/gjWIca5sTUonrpCg16/wmnHott5M5xuGdYoQin0fKojTXP+436y3g1TPHc3611vtQPmos2d3pEv8tPSiTicMuHmRjPgc11zlFLhZZo3/9PxmBPoveC8bC+5ME5Zgns07a5+S1FCN3sf3ko6aqLeZSWtrS6wFeNqWqLkRer8HWCeV79w7sFTXXFcoFT4h68mb6AcEeOPvviFkjjPL1XdyNVMNPSOzylN/Zn+RYSUG67x8AIsQPJdApb3S618ZVNGjpXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z4bBuZ/vP65aPiqKv60GuXTqaKsZnUjlk6Au5WgResk=;
 b=iiXOF3XI2FWh6HhZBvoTcety7kSDt2lIcr7O0Ik5ABndDJJby6hUL90mQP/Q0LSNlgtMFJ/VMkkgq5owMj3iJvuL4TlEk7bfrrl0+27uS+jcvLYVWsqaH7XuDw440lK8uzsfauY7atPhBg3QlgDcLGobG2tESwGzEm2+T/91f4E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB6PR0301MB2183.eurprd03.prod.outlook.com (2603:10a6:4:47::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Mon, 4 Oct
 2021 19:16:13 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 19:16:13 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [RFC net-next PATCH 16/16] net: sfp: Add quirk to ignore PHYs
Date:   Mon,  4 Oct 2021 15:15:27 -0400
Message-Id: <20211004191527.1610759-17-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211004191527.1610759-1-sean.anderson@seco.com>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:208:239::28) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR08CA0023.namprd08.prod.outlook.com (2603:10b6:208:239::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Mon, 4 Oct 2021 19:16:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b36caed-e8df-4475-6fcd-08d9876b6e4d
X-MS-TrafficTypeDiagnostic: DB6PR0301MB2183:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0301MB21836351B2C44B1F7F71C26496AE9@DB6PR0301MB2183.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WfyMG1Y+HZHXAsKXQ/ejFlIQxp3hmR2XACxvR1wyxpeMH5qX7D4Y5jiE0SEvt1swq1L7cD4ol4hDayPFhkTduEKb1UAQaeJa5UTuG+Fh/Q3ifL7SpqwcppcgzG8EN8a4X7QSbaJU4UapYN8t0Nziy5b7D95tr24gIdgufdUDdwaDqbfeqIVljrrdqmm87ymH/zd94nH7R/102woMIaqUkoNoP/WOv6K56pNDhh54wvnjp3M0Q8ZyCg5HFzPReoZalRKdxuGYVVTb6tTDMxNmoXxTteav+WpfXxadpBw6jgy4K66Zlj7sSig5cC9/Y1WXaSxiufX7rKsQMvHNUSaVprppsxaCNCVIjaYqNJepUzfjskureLO2QtNGqIpBtCarYDQoUY+GLuHAbuIiJM14a11sZSoakP6pwxBqct0MD9FfBwquys06LoI6ItWDpBpqP3PuMvJg7cuBTBdPPPKlLV4PGuiMTZoQc4hi4x6pQhh2vzQKL2/45kjmVpBDDHpkLpegxmYXXUzK18dB0LFGt6ONxxjKsF4T366TWmiY+f7K45aBr8JFz0f2HE2+mR2zjImLEnHLwPpqA4omFeoOa1KUwQqHctWkNd6eU8iT4iTTQjC3Jk1Vqz8HhP2HTx2wRSuhuYhV8mPkBTl7eMQJARU97tyW9Gm2gs78wqp+eCc1bF4G0XxYGzkvAcXFNjwzM2zh/cHmNIfEonD8EWTxYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(186003)(83380400001)(2906002)(54906003)(5660300002)(1076003)(52116002)(26005)(66946007)(66476007)(66556008)(44832011)(8936002)(110136005)(6506007)(2616005)(107886003)(316002)(6486002)(6666004)(36756003)(8676002)(4326008)(956004)(38350700002)(6512007)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KPa9KC6fOXkGQ66Foa87shBA6BfiCv4ATnlCc6txsD0SavuXgHvR41AwOrXw?=
 =?us-ascii?Q?KTfwwCCx+9Y5ozDi6HUL65j1X1lRu1rzB7hrGKA45VEnKbyKkvFKcc3u2+cu?=
 =?us-ascii?Q?Y707AAp0mVrvMUPezJDxWJKug5dm8u+cOIlgLxhfWR0ooaV5D4MT39pksY80?=
 =?us-ascii?Q?GGRAwN1Z43K+LpdoTnptQDJdMoUcevmFHCS4ygfr05XwYBanR6INTsOYD4/0?=
 =?us-ascii?Q?8Z4oKRDYyhmfSVqgW8cbz+IXZ/b0SnJ81TTq22QcFc/ofr0eyw6cc+DynZVO?=
 =?us-ascii?Q?rZdqpNz0hFpfuRLvbLFH7VhyxMWpKgR/TzFB/EgbNRUxTVW1kZ51PJ9OUXyt?=
 =?us-ascii?Q?2M/KQ+l/AiFEck/F5fRTXJqDMwfH4F5iu6MiHDiKNvl44s1B9yhOBypkr4cg?=
 =?us-ascii?Q?nd43fi3AGmRSWMO5QCan0C/pBPriVs7cQ33+n+P7feJyhc29NCkzgQlDc9Bl?=
 =?us-ascii?Q?dbVk9qGQyZrpSdU0bsx42L6rYy8gaEhvndF8zJ20Ei3H31intZrr887TCoRY?=
 =?us-ascii?Q?jukiHZgm4V1QB/F7o8QT+klpFRL/cA/H2tMLiLazfHIhSBRpRVyxZT1Xfvve?=
 =?us-ascii?Q?kiLp6akA+OOIRLGd8seuwm+BLSwG5IBQyLm6b6ysQ0p1Xdsm7DNb09pQ5UF8?=
 =?us-ascii?Q?InX6gu5VAKHUCKo0wXMytsoDPuAQZe5HqvQB1ltBJ2zHR0lezn/z979vdUE4?=
 =?us-ascii?Q?PRCZZuP49L5V+gqil1RZZ0NyulVw+enG4UXC8m7jCh1yG5muo9SwFpsCBdsX?=
 =?us-ascii?Q?epwE8uXhzBoKyrds/LVon+y6/p6HhDZMcrsqtQGN9Lj5ydOw4gdFt7FNM8W1?=
 =?us-ascii?Q?NCszcsc1rAsEU2lLnxgxe44bAELOwKeelqIZsbvNIveMhAOrvrJb7xyQaCqR?=
 =?us-ascii?Q?3S2/AAUKA5ZXGWAJBMBxe6xECEutgLGvhclUprK/xOIy96qMBUxPTNHVGCV2?=
 =?us-ascii?Q?oSR7H7XoeWXFdn9SN+KVq8M32LM+2X/phe91IQkolUfJG0+8IDhuHSP0wXet?=
 =?us-ascii?Q?0JELw/LAVGozfAd2AQd2b0lJ8fOFYt3WWv0hAm4WEMhVqakMymE70aRwNLiF?=
 =?us-ascii?Q?BU7PvHOnB0vKF6lPJqzESKDFRGDalyW3vT4LtiLZZcDYI/wPqEwgrwTFRUnK?=
 =?us-ascii?Q?ebfSmmCAMjRXgIC2LTJuelonjti5Dfa7gpymhY4JiX6DoOteAKUQ99swlks/?=
 =?us-ascii?Q?YtjhJ/DYDv8Iel3UlIKY7+bh78IuX68zBi1pn6Gx+hmw14Ei3OIIZqW3TofX?=
 =?us-ascii?Q?ERJm0ItKESEGnzZN3li56YVs6e+JD0zlcmdHJZuFji/MT3b1m6cL+TnsrtrZ?=
 =?us-ascii?Q?nw67qNjht4a+91c5L18AlK/A?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b36caed-e8df-4475-6fcd-08d9876b6e4d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 19:16:13.2997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X9K6uMdKSguVsyfueiBmWwhOiVfox713ty+kKEypJtx4TZZabygYAxx4ZheIGcZaeIPgPGF38GRBmzdmXPW+kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0301MB2183
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some modules have something at SFP_PHY_ADDR which isn't a PHY. If we try to
probe it, we might attach genphy anyway if addresses 2 and 3 return
something other than all 1s. To avoid this, add a quirk for these modules
so that we do not probe their PHY.

The particular module in this case is a Finisar SFP-GB-GE-T. This module is
also worked around in xgbe_phy_finisar_phy_quirks() by setting the support
manually. However, I do not believe that it has a PHY in the first place:

$ i2cdump -y -r 0-31 $BUS 0x56 w
     0,8  1,9  2,a  3,b  4,c  5,d  6,e  7,f
00: ff01 ff01 ff01 c20c 010c 01c0 0f00 0120
08: fc48 000e ff78 0000 0000 0000 0000 00f0
10: 7800 00bc 0000 401c 680c 0300 0000 0000
18: ff41 0000 0a00 8890 0000 0000 0000 0000

The first several addresses contain the same value, which should almost
never be the case for a proper phy. In addition, the "OUI" 00-7F-C3 does
not match Finisar's OUI of 00-90-65 (or any other OUI for that matter).

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/net/phy/sfp-bus.c | 12 +++++++++++-
 drivers/net/phy/sfp.c     |  3 +++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 7362f8c3271c..0b79893a79ea 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -14,6 +14,7 @@ struct sfp_quirk {
 	const char *vendor;
 	const char *part;
 	void (*modes)(const struct sfp_eeprom_id *id, unsigned long *modes);
+	bool ignore_phy;
 };
 
 /**
@@ -68,6 +69,12 @@ static const struct sfp_quirk sfp_quirks[] = {
 		.vendor = "ALCATELLUCENT",
 		.part = "3FE46541AA",
 		.modes = sfp_quirk_2500basex,
+	}, {
+		// Finisar SFP-GB-GE-T has something on its I2C bus at
+		// SFP_PHY_ADDR, but it is not a (c22-compliant) phy
+		.vendor = "FS",
+		.part = "SFP-GB-GE-T",
+		.ignore_phy = true,
 	}, {
 		// Huawei MA5671A can operate at 2500base-X, but report 1.2GBd
 		// NRZ in their EEPROM
@@ -204,6 +211,9 @@ EXPORT_SYMBOL_GPL(sfp_parse_port);
  */
 bool sfp_may_have_phy(struct sfp_bus *bus, const struct sfp_eeprom_id *id)
 {
+	if (bus->sfp_quirk && bus->sfp_quirk->ignore_phy)
+		return false;
+
 	if (id->base.e1000_base_t)
 		return true;
 
@@ -370,7 +380,7 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 			phylink_set(modes, 2500baseX_Full);
 	}
 
-	if (bus->sfp_quirk)
+	if (bus->sfp_quirk && bus->sfp_quirk->modes)
 		bus->sfp_quirk->modes(id, modes);
 
 	bitmap_or(support, support, modes, __ETHTOOL_LINK_MODE_MASK_NBITS);
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index ab77a9f439ef..35c414eb1ecb 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1512,6 +1512,9 @@ static int sfp_sm_probe_phy(struct sfp *sfp, bool is_c45)
 	struct phy_device *phy;
 	int err;
 
+	if (!sfp_may_have_phy(sfp->sfp_bus, &sfp->id))
+		return 0;
+
 	phy = get_phy_device(sfp->i2c_mii, SFP_PHY_ADDR, is_c45);
 	if (phy == ERR_PTR(-ENODEV))
 		return PTR_ERR(phy);
-- 
2.25.1

