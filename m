Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682216BD4CC
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 17:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjCPQNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 12:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjCPQNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 12:13:13 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2043.outbound.protection.outlook.com [40.107.105.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B867BAB884;
        Thu, 16 Mar 2023 09:13:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQK6zHCBeUgFF4IcrG2rafGpCHbwpBCCXvgKosboKWU4/jMFGyjyEcHJu/IDKgB8BKDnBY2f2ua89grNSu8VjT4/tscW6vqoYHr+fO13cbZum7318JNQwxgbCtjTBL4KAU7vktglHIIPSHMrprCwdRxdiSjUeiK7UyFhHksPCeSQT/t2RvYswJOsS3wz1tTf4r8FLhRq77vLd5JAbPR6EJL9onDUdqnfx/nlChnl5pFgW1gsA5OlzhuzxW6rxLU7c3Aw9RXjDvRQac19R3NbaE6Polo6lZBfnDPWUe5rjmT3E58jdrrtLPSK2qBqFrIOZSUfKvuMiS3zjsEU73qPww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z5Suh3iWp9L2kA3GuOfF3zdvX8Cn4JiUI5Ut7h7fmSw=;
 b=khKBtHzEPtIYxHMovXFcHdkAp1c5vNQu94/a0owdIkmeD46qWq2xy0qn9w1WVI7rNJ6YhoEOo8vzA/f03Xz7Zy4np7BFPHhzQ/R4ivE8KNPaop919tAzYK68SNj8K3XZxdxl8Gk6d5vaYHdt70PcgHE93h7xNrP4umWCv1i4pMSyaZk8+5zNDykIfp2lDJHXS+aPlhbT/HBB1yvdI0QkBoQ7MbpHVIoFJu2FT1jtLbydOP0vy1YdQMdpYbFV1Z3if3LWRBwKpkvOsR7mdO57yYxLguzzwQ1rJvVLf7PN7UpVG2aeC5bxfhZfhzotdFVWBdVfk7lYnmDQY/+LmYmloQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z5Suh3iWp9L2kA3GuOfF3zdvX8Cn4JiUI5Ut7h7fmSw=;
 b=SjAYp3EMVJk+7NGqyebkca+p1Vbp2ya+kn8Rtw770dyPKrH3uiS6kn/G8jjG2bQexaHiEXPtjIA0uWr+6svJn1vHir70JcC7R3eUAkcuC7wvcj+H8VHFJzD4H1FILAlire1SxfBTvp/J3kChh6wM8JLw6bH7X+XcwePddQzB4G0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB7861.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.30; Thu, 16 Mar
 2023 16:13:08 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 16:13:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek Vasut <marex@denx.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        linux-kernel@vger.kernel.org
Subject: [RFC/RFT PATCH net-next 0/4] KSZ DSA driver: xMII speed adjustment and partial reg_fields conversion
Date:   Thu, 16 Mar 2023 18:12:46 +0200
Message-Id: <20230316161250.3286055-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0088.eurprd05.prod.outlook.com
 (2603:10a6:207:1::14) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB7861:EE_
X-MS-Office365-Filtering-Correlation-Id: 374f949a-2d9d-4d55-ac12-08db263954c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7dGJ2c8vu7DpjNhk8r4JD4Ra3/38IDcG16s01wX4rs8Jvrdw79N6B0D9Lo/2tErCmaNfOEO/ksPi+EneMvvwJRaEfndw5VDwh8mvD/mLsrft2TgzE5BLhFkJza5xp+ttobUTHi2c/2JpZi23YmHFThVTXuFkQixDrSTCt7UB1QoBHpvahaV3fm+HbInoBJvQRciaCtWiBTteC3FEfRh2nuSfRGnMkqbBERhoSnxD4ER8dNSmaQhcNkK00zKy89u7siKeEp9nJ5wBbgQDgtRtsZQzBQi2a0vXqaRq1CwI7wr3noU5XabAW3vyXvciG3LbgSaOoWHTHgBXeGWYQFIs5DchgXpxcX/zz0sKDZwmuVqS3AKG9rm8GmSGIbLKd9ej/Tq8jvaIfix01BU/Mp0hrQLx/hqkE4pHyqVwTh5jepSGfb5H0EKA9PoZFWmMiy+QhWSHXfDqkBtTxAON8WAG/6HGfz8Pvl2npkapncmflC87zppKpcBAlgukpR9+eRYKWFsoIWKyXrGBfAtbfM64e3qg5xd4IFa4k/JNkGXo9ZNxIorCQiQXnD+/hEHct0oxKBqIeyJ71oz7Hpc7+c/O+5UWsDr63S6wLTVrsIHMDiwhWMvlX0KcZdUUkwNFmSRw6+vFUVGubEovfUGBd9VSEa97xBBYkpcoDWoSyTQn/a8waY4cVlocjh7jePGlXKZd/PP8eRFT3MnUgCD5xaOD2HZe1F1hgqKq6QjTKXdq3bA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(39860400002)(366004)(396003)(136003)(451199018)(36756003)(86362001)(38350700002)(38100700002)(2906002)(5660300002)(41300700001)(8936002)(44832011)(7416002)(4326008)(6512007)(66476007)(1076003)(6506007)(26005)(186003)(2616005)(6666004)(83380400001)(316002)(54906003)(6916009)(8676002)(66946007)(6486002)(966005)(52116002)(478600001)(66556008)(66899018);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?coVAqSKaXw0K8aLmWxw7tZ1b4W2ynFNKVY4m/UvqWbdeFkkydDBLQbCaUzJU?=
 =?us-ascii?Q?XPRx826kAwFINsR4ukYCnMjJ0omALzOi143sNOZu/ZUyHmAs2k9kbljvlCdI?=
 =?us-ascii?Q?pqbLgehd80g30sQraDdDVnjBT2XcUgM240GnLrp+7LTUtxVvaQYe5SgCZIHe?=
 =?us-ascii?Q?3NJhfe5Q3ik+sG+K2bF05qqWKpsWCC7350SbmO2SNw7pxhoxqQtxdDVKf+Hi?=
 =?us-ascii?Q?otGPTiotefHDWjbRwpQehp9angJ2R543hGyjYWrBtvEoDUlIFfpIyMfSd6iO?=
 =?us-ascii?Q?7oxL6lQQueEHnwbS4L2xrVA5X51ElKF0oTfv/fukQJ7a6Jr91lsXxN//9UiK?=
 =?us-ascii?Q?5xiR4OU7aYYfmzQD+5N7V/WIdZVRHn5uYPfol8QEsfvsuo74warMeN4oOrHm?=
 =?us-ascii?Q?eqv3J4gdCRYOGA5MI99OqggO4tBzVdKz8aGfftLZxLW2u3bKiVTKLrIGT9WJ?=
 =?us-ascii?Q?XoKxbxUu9uLU3LMyy/xGg8VbmnRPm+/i/WHgmunmUHacmtFCdFyzyW4OpZYL?=
 =?us-ascii?Q?PuIB5GfqpOP3naSa7eAmzbp+HLONPukaZEF8gLQihB7Ibe8Pg+6eOUAZR0Jq?=
 =?us-ascii?Q?TtPNN1vNZG+ZkPBt5m+3RtHTKYqhuYiuk6WMnkdO9Ij/YaXbKR+cOhRxfQR1?=
 =?us-ascii?Q?ppDEDWdjtnoCUqc2oacpX4MstEL0DKYSGh0CYlVkpGVsbjVA/2xYqlusx5m1?=
 =?us-ascii?Q?ed9HuVjxMKbzQjiGhBJVJ1DWNumj/eUmLU4McaDWk7Tf8cJJxczxTTaPe67q?=
 =?us-ascii?Q?FftqEG4fUc+U+su3DhqUGg/Co7Xp1QomxLxCV7Gf2jCsb6Qqf7+GqSsanJUA?=
 =?us-ascii?Q?dvc5G8CVXQBUrFIGpAL1s7ej/5nwSUk1a3Ztm2Ff+2R6lZ+keCJ334OhlKvU?=
 =?us-ascii?Q?QoT8qkVumU1uuMQ21fT7bzpgrcjjTVys3wi2jO8aRRM2W3Pr+zRHgXAUegiI?=
 =?us-ascii?Q?7REUlHKZSVfFjjrUJyhf15m4jmz9CZoKXDUKL4iXbcZ6ywxzPTWU1Dles+M0?=
 =?us-ascii?Q?SPNJI2fCbzhLDTQpao+U+m8vE0sWv7uyi0w69uz//qOFhzNdQKlW/8hl+sB4?=
 =?us-ascii?Q?/MZKCAvEcwQGl+povFvIH+pxbH1FD349Sf9ZS4Z5F3GXVQtiLDZ7wppl44hs?=
 =?us-ascii?Q?GqrZ5dYywnwEnoB2gqUt0gZwVZb/Xsd1hl1GEgmkCkURibt1Y4jZYgw8uEc/?=
 =?us-ascii?Q?2tcdPlwzyFruomPXzKRFuOUliZENI5NLWiJ7kIFV94W5AFtocgW7tTFPdkfw?=
 =?us-ascii?Q?w/8wFhlFCNb11btJ2mXK/BqQSU/rLJnDJbue4hh1A8E98VHj+oQtvIRoy7I+?=
 =?us-ascii?Q?1gX1NCq/zHBaJWIR41ZgaMiDks0Il+2lixH5quFq+PLT/0XMcDEzxF5K3v6q?=
 =?us-ascii?Q?DRe3Ka3bP7r4SndbnZWRhu/+Kffg3Vw9i1hx7SY9xrbR5zZn7mNaOPPbAptf?=
 =?us-ascii?Q?lseRhhwqcvnK5k85H0WbwshL0Zs/qVGrfZPwkjAq5f9xdciKWtec8LtmyFyw?=
 =?us-ascii?Q?xeONUTbRysxwpoCZgotMW+0lF3ThUnRpMPi3ZUbQyNpCn/9Vd8/Z8AbfjqvG?=
 =?us-ascii?Q?X89/vJghJ//f7GhTx/nE1BgtSCOdPYUggYoutcTN0YZhv44M6W+ekleREQqP?=
 =?us-ascii?Q?ow=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 374f949a-2d9d-4d55-ac12-08db263954c6
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 16:13:08.2698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BLmLZ+xySVI0ecUkm4EIHl8l2DsBkiKCF6VA6rKunSztz464YGtENmXf9fVrNl3GBAwoIYmG4gt+uIYTHg/79g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7861
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Yesterday I picked up this patch and resubmitted it:
https://patchwork.kernel.org/project/netdevbpf/patch/20230222031738.189025-1-marex@denx.de/
here:
https://patchwork.kernel.org/project/netdevbpf/patch/20230315231916.2998480-1-vladimir.oltean@nxp.com/

and today I'm trying to address the rest of the points brought up in
that conversation, namely:

- commit c476bede4b0f ("net: dsa: microchip: ksz8795: use common xmii
  function") stopped adjusting the xMII port speed on KSZ8795, does it
  still work? No idea. Patch 3/4 deals with that.

- Mapping P_XMII_CTRL_0 and P_XMII_CTRL_1 to the same value on KSZ8795
  raised some eyebrows, and some reading shows that it is also partially
  incorrect (see patch 2/4). This is also where I propose to convert to
  reg_fields.

As it turns out, patch 2/4 is a dependency for patch 3/4, even if 3/4
may be a fix.

Patch 1/4 is a dependency of 2/4.

Patch 4/4 is something I also noticed during review. I left it at the
end so that it won't conflict with something that could reasonably be
submitted as a bug fix.

ABSOLUTELY NO TESTING WAS DONE. I don't have the hardware.

THIS BREAKS EVERYTHING EXCEPT FOR KSZ8795. Any testers should test on
that if possible (due to both patches 2/4, and 3/4).

Vladimir Oltean (4):
  net: dsa: microchip: add an enum for regmap widths
  net: dsa: microchip: partial conversion to regfields API for KSZ8795
    (WIP)
  net: dsa: microchip: allow setting xMII port speed/duplex on
    KSZ8765/KSZ8794/KSZ8795
  net: dsa: microchip: remove unused dev->dev_ops->phylink_mac_config()

 drivers/net/dsa/microchip/ksz8795.c      |  45 ++--
 drivers/net/dsa/microchip/ksz8863_smi.c  |  11 +-
 drivers/net/dsa/microchip/ksz9477.c      |  24 +--
 drivers/net/dsa/microchip/ksz9477_i2c.c  |  11 +-
 drivers/net/dsa/microchip/ksz_common.c   | 256 +++++++++++++----------
 drivers/net/dsa/microchip/ksz_common.h   | 110 +++++++---
 drivers/net/dsa/microchip/ksz_spi.c      |   6 +-
 drivers/net/dsa/microchip/lan937x_main.c |   8 +-
 8 files changed, 299 insertions(+), 172 deletions(-)

-- 
2.34.1

