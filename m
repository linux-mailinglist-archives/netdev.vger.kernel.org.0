Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27AD06149F1
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 12:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbiKALvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 07:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbiKALvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 07:51:04 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130082.outbound.protection.outlook.com [40.107.13.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E141B9CC
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 04:48:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rc3k7WvGw5D1KBBSSQ7z/QFATnuhV+fC6A3IsY4hGHN3Rkzgbzqhkaoo9LokGzOglD2NUSBzMG6Izk7wPxbsYKsUfNOV6i8RgA4SiYoUu0dHE1Rd/DZyIwUrvB65zRBKpnjlABpW4HWd2h3f0BAMRhwvLo9SAi8tC0R9ChxzP6y8XVDxfLTORLyUBExUj5Uv6c6L30xfrEL8e++QHzAA/9okKQw1BrvNqaJv9Bc8fcYak5s931JdIJ26DS7PKFJjHA2cFQk5Q0cvMWfuoaiK3FQ7B1fzai0ep5nIujdA6Cru8kqI67DUDqL4IiEm0PsR7NXW+y8Xb2DZg5FVCpJakw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rNhvbVwU6af5rnV/8FJsmYtjyp3oCpSE+Gx4HOmZVO4=;
 b=HUj/pAb7/Inux66707EPJKyJ9Eq1f5V/dFkq7ioA/Y1fcUe5oSqiCJFPDdyVdBlVXP3w8/u7Ip9UfLlEYfmsl17ZACS2mubAdMHVR9sHJiWJRniia/0Qg+m9x8mgSbE5+gmxJGoR8OqysDKgYqhtxgwQqZvdecd/d04UFiprcJb2W5izPBwZXenewW0Spq7n1mqwUvZ3Q0C8hvjV01EayLaqoYhH6n0PLoVS9AEG7LdzqeyrsOrkkhWR7kYLs25FnzOAjrEcJGxm9DFs2qYBGWpTit6+zG6yCyo7yaYztTkW84gPrHt0uof7zjdN379h8z6banL5y/BnQnh/vUZLng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNhvbVwU6af5rnV/8FJsmYtjyp3oCpSE+Gx4HOmZVO4=;
 b=B6MNsrYkpO5wwhQ/6LVFbb/lG0VnJbjnoIq6gMb47kvGaZ0HLOglepEbo3jyCfmuIshkjUc8UD0dW4vQJ9mtKut5MX2eG5MMkwsrxzhn4qcF9iQJ0tk9cNCnCGhxit1OtbJ8JiM1uZeMnZErjaI0tuqTbDtwqfte+yP16xZ+FWE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8453.eurprd04.prod.outlook.com (2603:10a6:20b:410::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Tue, 1 Nov
 2022 11:48:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336%7]) with mapi id 15.20.5769.018; Tue, 1 Nov 2022
 11:48:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 4/4] net: dsa: remove phylink_validate() method
Date:   Tue,  1 Nov 2022 13:48:06 +0200
Message-Id: <20221101114806.1186516-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221101114806.1186516-1-vladimir.oltean@nxp.com>
References: <20221101114806.1186516-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0057.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8453:EE_
X-MS-Office365-Filtering-Correlation-Id: bd2c6337-5079-43c6-4f16-08dabbfeff32
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fKk0fNlll6kqW0jj2i/VmCYB77D+HjhmX/uljHWZqb0m9sg4lbv8eicnZXCBP0e4zyo20KX7luQK+MDSO5nscjFanckE+Dh7G8sZoVHDBW9266hb+EJVULVC0rlmk+tCJxvTt2AYjKj8YCcYiAp9KkpLFJOMAv1Q8WeGramrcheXAMr+SGQq6SbhHn2P4w2RnBbW2uFxFjTfmHpRqTSje5tCQ0YPNkcc1Yxa7aa5MeJB3cMSfWQedLrebnN0meFrMuuac95Ce1DkAIpzIuX1jMVIVjj1hSSQbWO1R2S8mGM+pRJJyDSDU0yLLonA83f1ixHPFAdXFU1WAmHM5fstA3TMYZUH5jg91fMnQpzamm5i17dQe1gwAFARHroCTt8cFEgFBAdcrqhChv6H3oQXYLXuzJh+JyEPSA9TmtqO+fN7ivqzN0fZ2MJJQnz7g7EZXid2xYWXJtLCnZoePldFENxXAljoNY5OFISsx/xKUmYj/VLz8TBvBN3JZaSfTJaCrK7e6l7jB12WAnHZnvFGmqC/0OCw4+xA6HF631+ybDZFyBfFoYLUfWItAFgePz2dpgD0LwmU8eU7rATGHLI7VO5H10Zu1LUI652ZOaVNYdUbGJoR8QhWv4I+1WC7e0BI1N78hImUOkxYGQVG2z2Ut4MzQ/dnJBPKXRZoK/4xmWrGKjcWylW6aNp1DJlb9v934pp1H5CISFCX4rIleQw4Kwv6DOSfcdwY6hrEO9tcw8YvK5G2Kd/bYwATBsiog9+EafX84VdmYz5GFtcIUNijYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(396003)(366004)(136003)(451199015)(6486002)(41300700001)(26005)(478600001)(44832011)(7416002)(5660300002)(2616005)(2906002)(6512007)(83380400001)(6666004)(36756003)(54906003)(6916009)(8936002)(66946007)(52116002)(8676002)(4326008)(66476007)(66556008)(186003)(1076003)(86362001)(38100700002)(38350700002)(316002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HAqkoQx0Bl+eRaDtkPLGqMoeU647F2eJs4PIS7tNjL2FGh7ulsCP5a3mtM9P?=
 =?us-ascii?Q?ZytgjJN1hWFvV9HkUzDt62/RheSn5X5HnCcPMEAJSnUaLqndEftplLyFMImJ?=
 =?us-ascii?Q?NM7KHQU2cEVq/UHragBl3PKHt5em8Fn6AWll/0IV+T+9t6EA9s0IWhqER2fO?=
 =?us-ascii?Q?19KZZyXBOqe5CBiGnnLA/Ww5MqRvFKP/8jYTD/ODGFbJ4dPsBGj9RgBBGovT?=
 =?us-ascii?Q?QQAj41Cc+8myaDe1QCbPUWLrL+w64FyQAB2ZcjiL/DsuuZQcJ4aNUeVcz7bu?=
 =?us-ascii?Q?oHT3z9ECZrJnDzsfFONm+VPJSOTqC/3N4ZUsItIOsyuvTfL0cvSACHAdK85C?=
 =?us-ascii?Q?jcdjeMkQKNTs6BS9oQMqvN8IwcNr0I71xA+pqkrFMlKqEa8XV1dYN90kXW2u?=
 =?us-ascii?Q?XkDykdI1UEaKtqMsSq8zftvRr9VWQm66RdRIbZftKwBSlVJsvABpofTZtqdK?=
 =?us-ascii?Q?ncskSUKa3bgMJE92WqsFXMZLDYXL//6y3Jb08pfmDgMpU0TUTEW/ucPVmwL3?=
 =?us-ascii?Q?upnhgv0avkLRCSpf/AtNIhR8oWiQdQid2hj7JN2umi4grqHOI2vGBR9iG+1d?=
 =?us-ascii?Q?DicGXykHjP6hd061xCl2vZ3EIHn+bHMkYqyuzlSCz3XDP6ofBqiE0jCv2Ooz?=
 =?us-ascii?Q?LTWYtHa97EANFEJyGR6yhOv0SBRjQJXqAV40vRN7blJH0NWTUiYbL7bXpUky?=
 =?us-ascii?Q?KnjRsa9X20eDm5+eA/lat7ncWqwVWPKLp7RKph25beKHoHbDY6UPiSAuJMgx?=
 =?us-ascii?Q?fKmpCwfwShcN0iAUdrONHQd2IZW/bf87lw91tzjVZNxNJL/RemKmocu/Eqzq?=
 =?us-ascii?Q?3Z8yJKmYI1W5R+b7iXXKDbbsi0c7SOwRgOh6gFUH5mof/jFClxUJZB9KX/tt?=
 =?us-ascii?Q?tXZZb5hPCS3OLuCdvgTv7Bg4BXY9IQhPSG7HeVhIAVQ4iZp3VE/1JaLEBrQJ?=
 =?us-ascii?Q?LNrfUAWpRWsU3x2LanNfdFs27SNbKfLm8eLkZBj0RaJ0jFLTp2OmjoAEADqO?=
 =?us-ascii?Q?cqfILg9XHdqw7MegfUKs3LCdznLgfYv7b/a1GEy3jaKzIDyZjaBmiHmc1FhN?=
 =?us-ascii?Q?CFfhEg9Ji+ap2aDU41Jil79G4uHscMZqkLt9n9V71tgQZQ0ViUzGxuMhurex?=
 =?us-ascii?Q?6SQuzCzKr8W0gl6eeyiEIl02cPg0YN6Z8tHFXOebSf8bOGjgmqEH2ud1fCou?=
 =?us-ascii?Q?3gaILimpuMGqOCr+5t0N7+lkKnq+cVR9dpZlf75rr9QrP5SbLqhHmYBkSBXR?=
 =?us-ascii?Q?CW8gBaqAHA8kYv5yhfnP+rwxv532lwsMmorjq37GLidk0Ep4o6BryFV5L4ON?=
 =?us-ascii?Q?91gNrAHP5EeTNiSIyGNYK1GjMfZl2XO1dL03U2JADrpQGYdDypg1DHjq+ESf?=
 =?us-ascii?Q?eQeZ0nc7wDEZqzk12z92aBGi9EfnIt6EF3YeVy96dYQi+cBZ4U3P1eo+0fR+?=
 =?us-ascii?Q?h/QE7+ymMkzj4s4cwvfQRU59y13NAwcljRda+HBAl8Mt5WgjMjJpWBkK+9Tq?=
 =?us-ascii?Q?tx2S6Ch2w6W7JsbNYOu8nFc08xNknDOOfr+V6GNM3nsi3M7SsmD3/PZsH2N/?=
 =?us-ascii?Q?xu0Z8uAGNqoEOLRPTijB2vxLcX31rPcTa33rbESHaOSZTbu9c+V0TvhyFm+g?=
 =?us-ascii?Q?eg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd2c6337-5079-43c6-4f16-08dabbfeff32
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 11:48:30.5639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PmejZL++pi/zGa/bKY/zonhfZ24lONwh/et0q4ZKOt3TOO1yadKzCbMT4wEZjqogran/Isulksq8M/P/U6bdoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8453
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As of now, all DSA drivers use phylink_generic_validate() and there is
no known use case remaining for a driver-specific link mode validation
procedure. As such, remove this DSA operation and let phylink determine
what is supported based on config->mac_capabilities, which all drivers
provide.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Not all DSA drivers provide config->mac_capabilities, for example
mv88e6060, lan9303 and vsc73xx don't. However, there have been users of
those drivers on recent kernels and no one reported that they fail to
establish a link, so I'm guessing that they work (somehow). But I must
admit I don't understand why phylink_generic_validate() works when
mac_capabilities=0. Anyway, these drivers did not provide a
phylink_validate() method before and do not provide one now, so nothing
changes for them.

 include/net/dsa.h |  3 ---
 net/dsa/port.c    | 18 +-----------------
 2 files changed, 1 insertion(+), 20 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index ee369670e20e..dde364688739 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -880,9 +880,6 @@ struct dsa_switch_ops {
 	 */
 	void	(*phylink_get_caps)(struct dsa_switch *ds, int port,
 				    struct phylink_config *config);
-	void	(*phylink_validate)(struct dsa_switch *ds, int port,
-				    unsigned long *supported,
-				    struct phylink_link_state *state);
 	struct phylink_pcs *(*phylink_mac_select_pcs)(struct dsa_switch *ds,
 						      int port,
 						      phy_interface_t iface);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 208168276995..6e417cdcdb7b 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1532,22 +1532,6 @@ static struct phy_device *dsa_port_get_phy_device(struct dsa_port *dp)
 	return phydev;
 }
 
-static void dsa_port_phylink_validate(struct phylink_config *config,
-				      unsigned long *supported,
-				      struct phylink_link_state *state)
-{
-	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
-	struct dsa_switch *ds = dp->ds;
-
-	if (!ds->ops->phylink_validate) {
-		if (config->mac_capabilities)
-			phylink_generic_validate(config, supported, state);
-		return;
-	}
-
-	ds->ops->phylink_validate(ds, dp->index, supported, state);
-}
-
 static void dsa_port_phylink_mac_pcs_get_state(struct phylink_config *config,
 					       struct phylink_link_state *state)
 {
@@ -1648,7 +1632,7 @@ static void dsa_port_phylink_mac_link_up(struct phylink_config *config,
 }
 
 static const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
-	.validate = dsa_port_phylink_validate,
+	.validate = phylink_generic_validate,
 	.mac_select_pcs = dsa_port_phylink_mac_select_pcs,
 	.mac_pcs_get_state = dsa_port_phylink_mac_pcs_get_state,
 	.mac_config = dsa_port_phylink_mac_config,
-- 
2.34.1

