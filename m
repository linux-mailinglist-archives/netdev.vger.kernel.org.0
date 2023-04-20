Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D7C6E9F76
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 00:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbjDTW4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 18:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbjDTW4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 18:56:18 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2063.outbound.protection.outlook.com [40.107.21.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E7F3C06;
        Thu, 20 Apr 2023 15:56:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZmUgpYLuQaBnoYtTAdiRGaCI/sqBojfhuk6At3vfWTHLjAQnqu7bnVpUKtoY/27fYg/EkMbJRATlHzV9pzABRYGM1RVAVRrCRvRfsb5EvA42xHjVvXQF+souaT6wezjKpfk6/lkJsPJDEihZwjBOMwRYQaC4ihC3mLMzkT6N4yYy1IOzu+DqcaaIB5GRp3PbGcu6gCYZ8tVTtxgf2/Rhp6o3PVLrGBhJvjyzBpFdghvofeoiJsn/R5l5U3QnQBf6XEd06+an6lPeW8noIRuX4Jlk+6okuSemENaid4z0Kn6wawFMsb4PCIA5xneGSfBQw0tTx2Y03+dPLqEOYBtotg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BbCd/MGRniqdetASdFqizhW2CBDY8IEYUP3mWHYLPXU=;
 b=hxbJTyXT39TrWSTyltH7YYTabRDJGvbbz5nW5jRgQIxTXbaPEGtAxxM3yRcwtW8Ziva40bgyM5nGSFH6kN2bB+83w5xkb9ksgh3a5z3fdjRmPw/2kgCLL6rogouDf5Sykc3crsVlUCIZAwaPT+djHoDGQfhNUL1hl9ZR6dprK3nf2AZNGBOHHZKBmRTEKFx+acVEYR1TYGvx4SYULnW1dmKQPMun02JcQ9v4u+IZOV4Y6KeSPhtPkevqtVM3KrkQgy+FbbQrotM40d4V+fMffpZ49KSZ81gWJHsnsje/LdethqxrJ1umg+lW9qUqDCWhAtQvwqE0vs9YXi0MuVWUdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BbCd/MGRniqdetASdFqizhW2CBDY8IEYUP3mWHYLPXU=;
 b=B2wkNpSY2GvtHM5mAfB33IaHOVh55S9eOMALLWY9UmBD+aH+Tj4A+htJj6vcDR8YDyNHSkB2Jdj8aeM+1YoZUSLIPmpVpfIK6FS/OLrxxvmen/CKzT6jz1J+VThaCLhwmgTvC18ZjN7WTZRPZnKOZJ4Lispm3BtYDMDH+4GPKng=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by GV1PR04MB9213.eurprd04.prod.outlook.com (2603:10a6:150:28::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 22:56:13 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 22:56:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v2 net-next 1/9] net: vlan: don't adjust MAC header in __vlan_insert_inner_tag() unless set
Date:   Fri, 21 Apr 2023 01:55:53 +0300
Message-Id: <20230420225601.2358327-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230420225601.2358327-1-vladimir.oltean@nxp.com>
References: <20230420225601.2358327-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0088.eurprd03.prod.outlook.com
 (2603:10a6:208:69::29) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|GV1PR04MB9213:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b0d48ca-7637-4674-a67d-08db41f27081
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bculxy5lMfUnY0R7xr/cV4xx3aNh/jgTwasYVsdKgdpkQuvqlZx1GlaqdSpLVLYOSnq4jUoh8yICi3PtUn6n+/8W2TbgtWuBBVKfMJp4TB9OVLFMnF/tLHkhn3f7S2LOk3QNMqS0xRB8uz8en8yyEOPcou5E9bXQMWTrIQRoym+NHaed/IhsD7tHapl+5ZEkpL1qt2SHRkJNk72z5G3aAm+c94qzKN/srocVikz2tLSGZmUqopuELfsscw+kHyu0HffAGR1gZXCx76mAEflzeTRNuiyTo1Iy2fQB8uMEzOHlSWcE9nlLWvAC7BVSClQGkFwM4rPRX+nzITv9Wgo6aWv9teJH0aqeBDIeR0uLPoP1d8U0+l9E9AW1sYto5MiH7Q+2nMN/tnkwkbbes/7WSzBKdeImH4eABVIBF3vIeSNm+x5DAUR7vwUnjzD9Uiu1yLg5URFvjzOv27bNMet5opDM12sAPRKr53uggoYOmwyl0FiFaZXCb9KJSrKiT6yx+7UGUjjDMmRe0GB9VPtq//HmTk+rrmPmN1ugGUn3eeJfsILI0s/5dHxm3YRgFjQJHmgi3qB12LXmez+gjpwiGbIULqbgH/TP71wXBwLJcxzDOjMWVQFrI+/10HQUhKdv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(451199021)(2906002)(38350700002)(38100700002)(86362001)(478600001)(54906003)(316002)(41300700001)(66476007)(66946007)(66556008)(6916009)(4326008)(26005)(1076003)(6506007)(6512007)(6666004)(6486002)(52116002)(186003)(36756003)(8936002)(8676002)(83380400001)(5660300002)(2616005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T46/nrInAgsV9YpHhwlNybpGThHwEPTOVWgGkIBwK6b9mEiQpbNHEgiqiYxp?=
 =?us-ascii?Q?bSlJuPor7qqwLE0YU2diZM9LDsamfDqn+Sl9rE50LZLbuhVPDs1r7XVM1r4G?=
 =?us-ascii?Q?JXGIYyh2wrtuFm2sbJxG2f7B7iSxfFPjeuHVOZt0bKOnbwrlxPvhEbr1pmS3?=
 =?us-ascii?Q?1t30JdgQv9CzYZZAspT7FaGj/MTQOrKBPEDyK6Ydc4cvQgOhjGZDom9H2C0n?=
 =?us-ascii?Q?GRH0Mkc3nEQFPHeOxEzQI+aZ51myG92QaeS3FUOub2ZTA918MeyJETmOTZfn?=
 =?us-ascii?Q?pStcNZ1QDofEEUrfad8BrdvU21RavTBoHR7Oru/b66DvTJ1YFuW1nfwmwmW+?=
 =?us-ascii?Q?eR8u8xF3t53Jr8hOGLAkuUMnNHnvbdQxujD98PwLmvP2JpZLQ6kKWLRGYWOI?=
 =?us-ascii?Q?XLjiXy2BQf5n/ulj8q11poF0WjaobrjywodDTtNJGSfCX1RZ2bsgVXuWHGuS?=
 =?us-ascii?Q?U6MZG32UFCmjR0ph7/ESjQAodKfIbBa4ib9Y6aZeQ00NU6Q1XQHJHnXvZdVw?=
 =?us-ascii?Q?FLjNkVpV6b47htJlkkhe1hv3eN7c8M7mwSnp5c7pX53excnafKZv5ofhR1Ad?=
 =?us-ascii?Q?UDE/lK+B/N15b2Jlf4BRdi6D8K129l20cGa01v4O00vODFR1anWyQkPCwYkz?=
 =?us-ascii?Q?snn23KxdEDpR9AKSzA3I/ypzCwIxnpgbBZ0gCRVfpvQ7BSe4Hb+BOqNHXZD4?=
 =?us-ascii?Q?m+6pECLeCxUJbSb77OfKfFoka1W9GQGEF2VuOagsAMpRBbRU91VelReH923x?=
 =?us-ascii?Q?ii8nOuKvkkWA2XDByk8V/SlvrvGYNvbkOwk21XXrr3wQJxa0OBFkN97vsDuK?=
 =?us-ascii?Q?Sr6hrHvTjAIOhO+s23BjCHmEkygZ6w4QV16HNGBTQKK4ail7pfzGNzrlGDi+?=
 =?us-ascii?Q?gkpUhIo+qdNV/y6AZp6AdPf0bsLZhVHPOu/5aTZe3rNZ/5bX3YJWUJBO7sKf?=
 =?us-ascii?Q?0gvMnh2D4rknXNkNwf9eHooyFDXkokH4z8Ym7tsCYADTt1+LHxGTilSY1Zr+?=
 =?us-ascii?Q?7BjmvLWCzLw5OlffBDOJh526wiLHjvXoNgbckpl+Hm3LFbfH9SEh2WxnG90h?=
 =?us-ascii?Q?TSZjm8zP0lqRUhtJu7VFISCYyh037bfGv3k/nb8U5pbLKA3PrD62p869qhWD?=
 =?us-ascii?Q?Bi+Tl1AXPHP1wwgnLWwMo0LYNbxjHMyqR0LN1sYUZJA0XEAdHKd9x72aQ6wX?=
 =?us-ascii?Q?4/L7SzzZdrgn0aTvgGP9VtFVhxS60fDY58jMmYYZPmw6Cf+BzeamdAk+vekm?=
 =?us-ascii?Q?Xy5XxO1kPeQ3bO2MOVQ3Fm00lk7kIh2NkWoL+pDoYLiDyYPITwrp788sUBaM?=
 =?us-ascii?Q?s65lFu9BvreNulxiHYFa5PtqFUmOLYV4td4h8cmnr05JpdNzh5ER/eYkqJfr?=
 =?us-ascii?Q?O59LIHMhU6w3tgu0jpzve1J/XLH8Q08plpnBkzxtpj9h3y4regCTw0dolQoX?=
 =?us-ascii?Q?QXFdCzREngxTXhFJHkWvaGEAy5JR4rfSoapGG8XL/oYi4tVvme6PaIlokZmr?=
 =?us-ascii?Q?lIjenTk6LGIN3mYGcqvlMJkEYI9GqJq84nLiqThYztZSOYHHvYB8rGPxt1vJ?=
 =?us-ascii?Q?2i3XiKDXEMnuWJNSWBihQSnWARBiq48FyvC/Aq+SqLISL4mUQ9tKicj9FS+y?=
 =?us-ascii?Q?ig=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b0d48ca-7637-4674-a67d-08db41f27081
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 22:56:13.0029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9fZiXbFr3hdJJ4wveZgW25U0pL4/ZSffIaxi4GPHC92FyW9dJEHebr2eBG4YPZgG0tl08lWh6dHLmk1lhvCwww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9213
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a preparatory change for the deletion of skb_reset_mac_header(skb)
from __dev_queue_xmit(). After that deletion, skb_mac_header(skb) will
no longer be set in TX paths, from which __vlan_insert_inner_tag() can
still be called (perhaps indirectly).

If we don't make this change, then an unset MAC header (equal to ~0U)
will become set after the adjustment with VLAN_HLEN.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/linux/if_vlan.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 6864b89ef868..90b76d63c11c 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -351,7 +351,8 @@ static inline int __vlan_insert_inner_tag(struct sk_buff *skb,
 	/* Move the mac header sans proto to the beginning of the new header. */
 	if (likely(mac_len > ETH_TLEN))
 		memmove(skb->data, skb->data + VLAN_HLEN, mac_len - ETH_TLEN);
-	skb->mac_header -= VLAN_HLEN;
+	if (skb_mac_header_was_set(skb))
+		skb->mac_header -= VLAN_HLEN;
 
 	veth = (struct vlan_ethhdr *)(skb->data + mac_len - ETH_HLEN);
 
-- 
2.34.1

