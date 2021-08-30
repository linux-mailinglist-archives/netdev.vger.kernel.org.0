Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F603FB952
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 17:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237711AbhH3PyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 11:54:13 -0400
Received: from mail-am6eur05on2057.outbound.protection.outlook.com ([40.107.22.57]:46753
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237543AbhH3PyH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 11:54:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XwxKQCYoGhc/IDRYhRmtsR9HpnqBUuU8myUYYccnn6P8QkQNIBb5EKD1jknJCEozEcagNhoM2xwyBfjxWjbuky/KsX2mN9iacPo3co0s9pl7k3YUc+vb1EEvxYsF8DxLVgfA5yDtksd9Z/WFiRyPj0ofzIBsCQYG5ECOrYFfg+KYbhLRgH9TP0ww/MDnKGBAwV478gEi0IIDMRFX9BLujSOrsJS/ijAxVfCcyr4hrDh2LNP58SaAdWGzbLdhtzu7AqPt07FCq2pT0vlT1PnhHK1l2LW2dxPLpPR94iAMa2HV3qrfAdDZXaftFq9Jx4OHi7/uGi6gLvz/w3DbLI+FZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JW6+Fh6iuOZLDW33vQZPSijRAPq6yZY4LkCAWdWMRNw=;
 b=DG5nHwTg1lyIt5MgHubOV2bSag+hTdiL6jyF9VORiyCS8QtqQQVnh/7YdPvOBv/mgyQENOVGip6icAb+nsFpU+UOy9uV+adNwDyAS+aW8GgkP398mo0zlOFOsXdAqhfh6166dmzrzhP62vADSqVzkkV1BqnUxt580jBuIxksr08V3wOdcofEyduViTFm2985qe/ZZa52xnMnYoiAjuYcFaosqLty+kcFtUeDvJiyiBeOF9fPYvdSo8SP9prEOdtHMFX6zXjiZKOlg+pYnsQ5Jflq8mUH4SlhpxGksn52iazxA6uRXXL/M86GCtf0v2fqIJ940YzYgwLupdxizc55/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JW6+Fh6iuOZLDW33vQZPSijRAPq6yZY4LkCAWdWMRNw=;
 b=LuBeAlkQAkLFgWl7BsGbf/bHnzEBQnvvNtCuu9zIo3sQE9/7Ot283yUPE1UNJuzcXbTKpv0o0TJTdg8TeU4F++wH1l4iX0s0hL+QjQzJ+E6fpNzX+ZSJzVW+SscOGndoS6HpwF7Vwcxw54LAxZ58RKBDH475YJr08ty1VtrY08g=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4910.eurprd04.prod.outlook.com (2603:10a6:803:5c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19; Mon, 30 Aug
 2021 15:53:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4457.024; Mon, 30 Aug 2021
 15:53:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, bcm-kernel-feedback-list@broadcom.com
Subject: [RFC PATCH v2 net-next 3/5] net: phy: bcm84881: move the in-band capability check where it belongs
Date:   Mon, 30 Aug 2021 18:52:48 +0300
Message-Id: <20210830155250.4029923-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210830155250.4029923-1-vladimir.oltean@nxp.com>
References: <20210830155250.4029923-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR1P264CA0024.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:19f::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by PR1P264CA0024.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:19f::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Mon, 30 Aug 2021 15:53:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2a5c93a-e126-4e19-4a99-08d96bce448d
X-MS-TrafficTypeDiagnostic: VI1PR04MB4910:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB491064A4C9A789BF387DFDA1E0CB9@VI1PR04MB4910.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JnOjYr1irbvAH38uuCY2vY8HnZ0bw+EEL8+8IX6hNxY6uZfyq/OFDC4HVscLDx/V1201JRU+TXi3yfsSHD1fmexIELyTA3o15LoJIxcOg4F+Yl1p4AZMuDDYfkA+4fWxZLshO75Nzb7zMZphgEIKArphCWsBZ8kfh3zOFvUgVD9fD0vFVXDZgzN7BfMXUwGYbmahvVc5a6kHHJsNGRpt3q/H8rGkYjEYIt2k7Hag1VLt6wcnryvELz4qnshDoiU5g/TjYnwZ9dSU1PcnGftp6vX/vE8Vu61flFpfhOuuqMo/GJ/eLT4+oUTCDm9vLhWuZqiLkOjF9j1GwI2GTgObJSUz93n8gXFDbvqpfQsJPA3XD4FJEcfzZ5Rlg+Www4A0M8/n0TUAQCNw0hVIXfnbQpTZj41C0mx6Wr5sEZ8fH15TTQbVjYzOKef7l/owltE6nH3VB40HzjnqpiX1B+U7sAogVz3Aur+SRKuwHu5CDGFPfD8p/hQet4hupcU56uK7/RWMy9t6k9FsgBxJWwg7SpFo648UdWkZyZo1vlwC1oUDAxWY0WsA/YhcWKYXcJxMTL5rejhrMPilodZhfpyDSUbdMqCYpJHXwM7srdqXCm/iIjEk2aM6PWTcRstruTxBKYIACehT2qe3CTqUKR0fkMXpwTjjoXunSafMjKltT0tbWGdC44fEa2pRk8qWAfut
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(396003)(136003)(376002)(5660300002)(186003)(6512007)(86362001)(36756003)(7416002)(2616005)(956004)(1076003)(6916009)(66946007)(8936002)(6506007)(2906002)(6486002)(8676002)(66476007)(66556008)(6666004)(38100700002)(54906003)(38350700002)(4326008)(83380400001)(26005)(44832011)(316002)(52116002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NqALochk4380YfKw5AyzIwdttGaBOuwA0+Cl4Bg8wIMZZf9smm+4/2WC3ckO?=
 =?us-ascii?Q?b+XkuxbWzyBv2OeLi1VX9k83ZPlMwFxNUjkrq9t4etjcOZGsh53dH89duhB1?=
 =?us-ascii?Q?/tq4CFwidWufNPoZvIhxDtFV3shcIv4QZVytUmlgGFWzuCYy2nRvnqxWOTM7?=
 =?us-ascii?Q?4PpQ/V+HgBeG/rz1qAAHWWz+wmMeyoJzZM38my2IAca8os3vowHuUmYEj8mn?=
 =?us-ascii?Q?A2npnZZR3yyGWSPHg0DeE7bALkX0fMYKaJhz27ndN13fcNWDUcKfNNwEeGEh?=
 =?us-ascii?Q?QXxv2IubDI3YD5+bed7Pi2ZSMXe3I0rLj52FQ/Sy4HRpWN/WQg2rcYv+q8Uc?=
 =?us-ascii?Q?tst+FSft6orrh91Z6A3jYTpRsvpgitnu/xmklN0eJBqtcC+YL+Uja2dp8907?=
 =?us-ascii?Q?pb7VZ+gfkS3AGuWIOnUu78XXjH+YvGLcPpSDchhZ0QEhPAXuwuwZAD5QDCjc?=
 =?us-ascii?Q?0ULJep+JufzHuC2inJt0MwVmV9E568mlNoie2pG9bLyFzj8efY+EbHe/G151?=
 =?us-ascii?Q?n/h75Bgdb4X2Sc4eC0EgPrnyWtLBa8svB3toUDTZYQ8W+l1KRGUjDWtEFUsy?=
 =?us-ascii?Q?D8IuavVDT7sjS0nBqpA3sHPyF0mWL0mPd2uwUayGHI65xgKoBehAjoHQmSOz?=
 =?us-ascii?Q?IWerSI86g5GYVLIwht2DNhzkAZ9I8lCDDM76yNAeeF3H5HEnOHOtcK2MD+qG?=
 =?us-ascii?Q?klMUSaqf1KtaA/mr2CVJRgyDWDkqW5yr7ab+acjiEpMgU9EvGkTxXHWuuBz6?=
 =?us-ascii?Q?VTiY8fjOkftCMnB977/Br92VOLVF1fB9LySUY4cxqmZ+FOkg7AfAnkNlAgbl?=
 =?us-ascii?Q?BgiKyqnPhIgE0AwC5Qps0AX6XL1CLxGOKgOB9WksQp50C1fPudXKK1/+GQ7p?=
 =?us-ascii?Q?l603NqHAdzSwI/ONuW24h/hLkcR9iELR77Ux/GDn6LebzHQhfXqDRUf7IlA8?=
 =?us-ascii?Q?jt2Oool8+ARpqHDx8+fgcUaqkwHz2YGhHcYObsUk48mQ8RXFJaAe2A2kBWpU?=
 =?us-ascii?Q?vDn73e6IgkfVFXgniRkVDma3MzrFcL0mI/3DEELH8jDkRu9jwTNxHn3YfgKm?=
 =?us-ascii?Q?ZfFn8IylYNIQNU28whTSYKByBOsw92Gazn5lKCSGzp2/9qZOGkfWDKbPs92B?=
 =?us-ascii?Q?dEFQbItcsrjAJmsJ+DiVuM6GPs+I+tCYwXyBGBqQPFA6/dcIzQSpWOyn9jUp?=
 =?us-ascii?Q?gSMKCfnNbK/o39n0uKmU/2cVCBglFPo7gUokYtVITL3P1u5OKLNTySF0DZPp?=
 =?us-ascii?Q?FFiafWOpRwHh7euNla4AnbrFGWMuC6RLgPM6xCoV+mGO6JviIlYvDcnW5dQi?=
 =?us-ascii?Q?FamYIoEmDRZk4IBi1uYs4+zc?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2a5c93a-e126-4e19-4a99-08d96bce448d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2021 15:53:10.9030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cUH80Utb71uVrovv7ALSYzamGhUM82rCcRJzJUbj/dAOpd8wEhb8RuzOTr78+CyOnoLG6DnmcYX851Xr1PI9VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4910
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that there is a generic interface through which phylink can query
PHY drivers whether they support various forms of in-band autoneg, use
that and delete the special case from phylink.c.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/bcm84881.c | 10 ++++++++++
 drivers/net/phy/phylink.c  | 17 ++---------------
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/net/phy/bcm84881.c b/drivers/net/phy/bcm84881.c
index 9717a1626f3f..5c0e4f85fc4e 100644
--- a/drivers/net/phy/bcm84881.c
+++ b/drivers/net/phy/bcm84881.c
@@ -223,6 +223,15 @@ static int bcm84881_read_status(struct phy_device *phydev)
 	return genphy_c45_read_mdix(phydev);
 }
 
+/* The Broadcom BCM84881 in the Methode DM7052 is unable to provide a SGMII
+ * or 802.3z control word, so inband will not work.
+ */
+static int bcm84881_validate_inband_aneg(struct phy_device *phydev,
+					 phy_interface_t interface)
+{
+	return PHY_INBAND_ANEG_OFF;
+}
+
 static struct phy_driver bcm84881_drivers[] = {
 	{
 		.phy_id		= 0xae025150,
@@ -234,6 +243,7 @@ static struct phy_driver bcm84881_drivers[] = {
 		.config_aneg	= bcm84881_config_aneg,
 		.aneg_done	= bcm84881_aneg_done,
 		.read_status	= bcm84881_read_status,
+		.validate_inband_aneg = bcm84881_validate_inband_aneg,
 	},
 };
 
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 6bded664ad86..7f4455b74569 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2074,15 +2074,6 @@ int phylink_speed_up(struct phylink *pl)
 }
 EXPORT_SYMBOL_GPL(phylink_speed_up);
 
-/* The Broadcom BCM84881 in the Methode DM7052 is unable to provide a SGMII
- * or 802.3z control word, so inband will not work.
- */
-static bool phylink_phy_no_inband(struct phy_device *phy)
-{
-	return phy->is_c45 &&
-		(phy->c45_ids.device_ids[1] & 0xfffffff0) == 0xae025150;
-}
-
 static void phylink_sfp_attach(void *upstream, struct sfp_bus *bus)
 {
 	struct phylink *pl = upstream;
@@ -2141,14 +2132,10 @@ static int phylink_sfp_config(struct phylink *pl, struct phy_device *phy,
 	if (phy) {
 		ret = phy_validate_inband_aneg(phy, iface);
 		if (ret == PHY_INBAND_ANEG_UNKNOWN) {
-			if (phylink_phy_no_inband(phy))
-				mode = MLO_AN_PHY;
-			else
-				mode = MLO_AN_INBAND;
+			mode = MLO_AN_INBAND;
 
 			phylink_dbg(pl,
-				    "PHY driver does not report in-band autoneg capability, assuming %s\n",
-				    phylink_autoneg_inband(mode) ? "true" : "false");
+				    "PHY driver does not report in-band autoneg capability, assuming true\n");
 		} else if (ret & PHY_INBAND_ANEG_ON) {
 			mode = MLO_AN_INBAND;
 		} else {
-- 
2.25.1

