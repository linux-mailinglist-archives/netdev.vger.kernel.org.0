Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 097B34351FF
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbhJTRwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 13:52:41 -0400
Received: from mail-eopbgr60051.outbound.protection.outlook.com ([40.107.6.51]:48103
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230527AbhJTRwg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 13:52:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DtboZJjHeimcTHOVhJ4Z68jDY4kVmQWhuXPs7DXLTG8neVlYVNa5zZRV2U3B/BRFcARRONjWdy+JqI8MtxBSQ4XGB9tXV25e2hrOAGmBwQGqQG32LVPvB5EFl35XsjMdlKJsKwHyUyB9eHh8YI+rkPOFYLa5IHdvpYLtBT6DU85VKjBPnqTSklRHHUSqbohHdNz68D4pzOj3i9s0ZP12i7iDOLY80xumuy/r+nA90OMKH9BwO23ZQFivJRo4dnk44GY1MWVHfO22TfncVZFwq9UDmUR2DInqfJCEdv4lL/aar3i3dRTTxq8B4eUoQKExhDc2JbMCx6SLXOhal4RQ/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VNvwJfTmE6gGbL2cgO/LVCNohn4sHWF+l2Bx/AZImgE=;
 b=Mb+OzbmUJOFri7T+64k4zqNdQ8GyonOBP7m2nzS/WLun/Hs7BEje67WIqWLnGn2Sn0EczJP7H89jlDdLnkrKt1EHoSfHA7r5HPxYK7OEEyyh4zBbtGYXz+cRFbBe2CBq905bPeAQFVds5bRPmrbhNAAfcuf6YgQrNxIXVZK/YDUaqqZkmUcQCPgFkPJp2N35HB1yxyYZk7aVf5/o+gcJLB0zA90q4ZiUlzaNYQj8dShSqKBka96zCoYBhslMkQ1e2TQkaW8itbDOvn4ZErmFZosuSIyI5N0Cf+0K4oHka91Wl8PMWAgfX6UhJIkAvKhh6g+SjrbSDsJaN8+cCxX8vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VNvwJfTmE6gGbL2cgO/LVCNohn4sHWF+l2Bx/AZImgE=;
 b=jQ254hczuNPwvWXKy5q0Fr4sqV/XA/0UHdc9ZLMPh2THRyuSYyVS4fYbqisDLrX1ZQGXia/LmNYTWOrZl23OjeMM4ASQvUyKSs/rGVKifJD0KKs722f1A/b70UkDbsCmQbOVjBocJ43iWo6f+Fx9ujHwZ2jUSrQHLNOG/kkyE/U=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2861.eurprd04.prod.outlook.com (2603:10a6:800:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Wed, 20 Oct
 2021 17:50:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 17:50:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH RESEND v3 net-next 4/7] net: dsa: remove gratuitous use of dsa_is_{user,dsa,cpu}_port
Date:   Wed, 20 Oct 2021 20:49:52 +0300
Message-Id: <20211020174955.1102089-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211020174955.1102089-1-vladimir.oltean@nxp.com>
References: <20211020174955.1102089-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0034.eurprd03.prod.outlook.com
 (2603:10a6:208:14::47) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR03CA0034.eurprd03.prod.outlook.com (2603:10a6:208:14::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 17:50:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4346e03d-cbff-444b-77c0-08d993f212fb
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2861:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB28618086D3C13E56AA33A226E0BE9@VI1PR0402MB2861.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KXEpqSuwEfJvwsXjgEvmSRry0YNJVI1UFBLVwNF3oyBphXC1iRxT0bnBGREx5R/DySfeDVl85dOZunTSlr3t94CwUqeIGxmx6dCJg6IBW4yXludzMsEOg8hVD+4QVxr/2RSCUJvVkMYgQAvNKYjQM7SJMzWwbnCv17JReTnj+XIVVZXgWbiBMryUw3Ty5jpyqIqzlYwBfG0W8fwb2oT8wbFRuA9c0kmk1LIJ8eHDuHa+RRFVo+kmDfzjKz8Bifc+nXQ4uEm6KaSMpkFQ3bcwyBEORKOHAmJZiiOkPCc4XFXlIWzaJHS2YJDxVARi6bLzEbCFavwl5o/plBCT24gx6PNUb2x/gcb2YVx3gyBDZgxfkrvMY+6raDgwucJEH1R+fwGXL/uAKIQg6qO2OWja8q/nCm4U3pvqoqfIK4d81OjHLHuPNqqZlSkJFFJ76dtC3Qhb2gTHqTmKA38wMiVFPMqfXcGI8EInBFzVgGHoLbo9cTLea8g8mnhBjABTGQf6EnOEoZUstyJKWSCo2qkP8lwV1cZn9Bz4o0M88/cExKTIjvr7JOeFQ4eor/xCi7ryNzCKVzmMVFVgh88SVU/UdPEuH0y0b9AR/WdViAexYcGx1bdypyFjnbru43UfS7fLV39Mx1SipjRliYimGi+fZipj5NoDd35R4nIh320rIo8x8LaTrJblEh/cUijVjV+uLKcd1ONherpiQ9XeSwI69g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(6506007)(8936002)(316002)(110136005)(54906003)(2906002)(6666004)(5660300002)(38350700002)(38100700002)(86362001)(1076003)(6486002)(956004)(44832011)(2616005)(66476007)(83380400001)(6512007)(36756003)(66556008)(66946007)(8676002)(508600001)(52116002)(26005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xYHsutQU1PtFjo99qM3gvhiUCSMa2xrzXPH9n7OirX39Ta0zVUkoGr7V3dvY?=
 =?us-ascii?Q?rgawjTPc/xM06Ow6Sg4qBiuVqFb5KxQBdYUIuOMzRecrVRvvXtgWWEEAhurj?=
 =?us-ascii?Q?g9f+vmGxXCyVFW47/M37YTdi9K5qnBJGqYW2ZBo3GrkbxnB4lU5A+8nsDupx?=
 =?us-ascii?Q?FrHL46t0tSggxK+50+f+bFFIFVCe7ace6Pc5izHMtgYESfQ5XN+PjVhX78Yj?=
 =?us-ascii?Q?2wvl0D+bSlCrXY3M3q49ncHqHWxQX5bfbShXMPbuF90WgOWmzCAub1Sv+NeE?=
 =?us-ascii?Q?YqsB8h+hwhtPglWB793Gk3ASgMbqpEASIkE43zs7/QSTCbtjk9oMo3UmX5+p?=
 =?us-ascii?Q?Gf54zarZSEgM898fpJX+pW7A9ebCu0ltBiCX/3LTPkYHfxtexeVFiD8SjgrB?=
 =?us-ascii?Q?Kb/PxcZGcCqzomWfZVVY9VuWiQ6s9crhXLur2Fw/ubhxm8uPBDmPP8aJmfx7?=
 =?us-ascii?Q?OpQTWw68A4gsjeiVm3IJXwsBseonYlwUWlVSe+pdUp1u9nT+ZmTdRyJ6lr4U?=
 =?us-ascii?Q?cq0YKSpW1etXdedjgGaorjcnGRNieMDRdFp3rA3X56klm7SuGE38WcfC46cf?=
 =?us-ascii?Q?60Z+D/DLGz6uqo7+SgJQKqSPyrvtEywlKhI6v0yUvHge0k8wJgohR3KaXNb1?=
 =?us-ascii?Q?+rWnmmpwAHy2HMJxQvix/9o+WFnYDDyuaNKnOpVJcCaUkJ2Kld1rvb77bob5?=
 =?us-ascii?Q?WUo2w6HQusA1TxpjFbkj8Od+tT2f/fQ4Al8t6WYc+sQc63nR04/Dg9IeyvoD?=
 =?us-ascii?Q?/dGW7sUmKxA/jH5MspbiWx0ItRioqhgQqb2klJju5fNgnmEfIbo1P3XLG8pW?=
 =?us-ascii?Q?ouOR3k9lLrycIC8EnCBgP+r6yGozCnMD5ZNBAHBKrZKt1kTrqv9zDsszW0l+?=
 =?us-ascii?Q?tH58z2pRs9LftGvaZ3BUJcBUMtXvvLUqQecZKClJfU/PmVY4gnsOnLl8uCFw?=
 =?us-ascii?Q?de2vuzXnzxRBUm1l9o7Y8Ga9DsSZlnRVBbMKbYLr97XS72mpADGti6iwVRvV?=
 =?us-ascii?Q?sL6vVQg2hMTtwuTsBrDo6QC0WNUKJh4U5UgRp3vFXJsBaTnXw5nlvuyLdERK?=
 =?us-ascii?Q?Bq01DDPLYmqdOjHzZ+zSr7kad4wM+1MLBk9IGkkvqmfH8AJUrOeS3MDRWwUl?=
 =?us-ascii?Q?vHgMEKCgpNLf3fTZ19AQot/5RlTIlQUxKg5GwpbPQSXpbEm4Bgw7bhmeeUsb?=
 =?us-ascii?Q?Cf2qi1fJc2YTWRbueEqHkkgbycWxGhZisT+lMj9WaxqOvGWkPfyI1SrXPZAm?=
 =?us-ascii?Q?IJ2KZBMmAO5vBGaHmAg6v5bprRminu1cqoIj3kVLI4uG/S5mcii2NOA34pCN?=
 =?us-ascii?Q?tULR2BO4/LGsYh2H/kLoM+ap?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4346e03d-cbff-444b-77c0-08d993f212fb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:50:16.1333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GhD7Y4XSg8L24V38LXzfNlGp+7z/2cXWOmSxGRVSty6pcBzy4nbyOtfxNEdbtDjwd0CelRfxva4Eo5HpHcZl1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2861
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Find the occurrences of dsa_is_{user,dsa,cpu}_port where a struct
dsa_port *dp was already available in the function scope, and replace
them with the dsa_port_is_{user,dsa,cpu} equivalent function which uses
that dp directly and does not perform another hidden dsa_to_port().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/port.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 3b14c9b6a922..bf671306b560 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -523,7 +523,7 @@ static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp,
 	 * enter an inconsistent state: deny changing the VLAN awareness state
 	 * as long as we have 8021q uppers.
 	 */
-	if (vlan_filtering && dsa_is_user_port(ds, dp->index)) {
+	if (vlan_filtering && dsa_port_is_user(dp)) {
 		struct net_device *upper_dev, *slave = dp->slave;
 		struct net_device *br = dp->bridge_dev;
 		struct list_head *iter;
@@ -1038,7 +1038,7 @@ static void dsa_port_phylink_mac_link_down(struct phylink_config *config,
 	struct phy_device *phydev = NULL;
 	struct dsa_switch *ds = dp->ds;
 
-	if (dsa_is_user_port(ds, dp->index))
+	if (dsa_port_is_user(dp))
 		phydev = dp->slave->phydev;
 
 	if (!ds->ops->phylink_mac_link_down) {
-- 
2.25.1

