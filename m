Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75F52FA873
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 19:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436771AbhARSOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 13:14:36 -0500
Received: from mail-eopbgr40107.outbound.protection.outlook.com ([40.107.4.107]:8652
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2407462AbhARSOZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 13:14:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XJ/UBNLHUqNk0MZ00hk6yrayZrkoAPhrKIu73/ZCFRlUjRDVVzOpDgKbZjYoJSka9LkI3bGwnYrzUSl0f6rHA8Xx/e5xlaYptFI99W649tazEm6SX77UUrBuIlTTA0rc4KuAhY4OpR/zt3vDt+ZCaVJdqsSDab1bgtAIauUcA5By2UxBIeYyfriyZEoRjPgpr/VeYiZoVAmqbFRby6FybmaSEIvnoIqwfDa8EwBQkvTRpTkgf9ynyJ10qcexVVSpo0FE2a3KIvi9kjTD6k+Xwm5nfG86HphehXwpuAir03ZKqMALpE5cFkF/dwrQoCync7xvl3cAJaEgNCWTVFygog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zpkkFwXLIHzY8BlZXKg3oBEANHhM8BBvDNZNHRVaxXY=;
 b=JEzR20RthaGVeZL2QfjRT+dBLF68JZ/+H8dMzfFF8gqKSsX8soVEsU1EOzAlSLHKG0f3+SSJL8mLS+2l2rnpThiAI8sY5ogpZpPQOxcBnkX6WGdOd+U+hKs7PeIjl0JaoRIu7IS9ldtgWEDM4OZ0thXCeTD9gFtuNFDMIU2tWP3MuAf3c7ae7/RRG6N/FQe8G+osJYZ1vnnu9HCnq1PbmCtgLF6UPuA0C2zRLYiMBUnmIcoXVRihU+OCQp0Pd7wEgHrYoz9GSqCIMWbFIuigCs/Visd0VRegizwOa1Gxf4lM1k8MRenxKYPPQNERvnGajqTxJM9BfLC/4kfFv3bxbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zpkkFwXLIHzY8BlZXKg3oBEANHhM8BBvDNZNHRVaxXY=;
 b=jQZqn3Pc242n/taN0tkL7gv9y/rmMRAa+phNukEx8mJfK58Gwm0I/DZPWZsPf/c+wERmjZNELSYu4M9l3NdGq33LI7c6M1AsKTJ0tGeNSWXfq7v62VUdWtZPubRw6OFmRS7avmTgIIrfLx/CDLBJApMfsLQAHGYOBSQMlP7szg0=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM8PR10MB4771.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:360::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Mon, 18 Jan
 2021 18:13:33 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 18:13:33 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: mrp: use stp state as substitute for unimplemented mrp state
Date:   Mon, 18 Jan 2021 19:13:19 +0100
Message-Id: <20210118181319.25419-1-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: BEXP281CA0010.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::20)
 To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by BEXP281CA0010.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.6 via Frontend Transport; Mon, 18 Jan 2021 18:13:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7b2a03e-5a13-4d11-bdde-08d8bbdcc464
X-MS-TrafficTypeDiagnostic: AM8PR10MB4771:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR10MB477168758ADC68C35101744693A40@AM8PR10MB4771.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g/aRrHUKjrLsUaM2UOwoZsUc1f6Vvxrsf01aH+NGsEmeSpgsu/4PNW0HjC3loeZ9uW8khwk29xwibrD0lChL3Ly2Y3nDtVMAm/9c2cLyTA+022PbIbx396mXlDl8WP2nHnphPNlRxDEoyOM+bjdzcwl/FgbXkhgxB40Oc9Ej5waHRAbEaCdIcUtGYrGvR1z4FCQv5n3M5Cf04l+McepzBEcOZ9xj7n6mRhzPCIbvZvD6cmmN9303XfpK+tfwRUXGb8yckZbbxABNTFAueP+QTKyStJ6IQ3jx7qsiqUEQH7mbWFMfpUyCj0Cs2EKOQsBVSEGFwBlxSly4T2jjwLlhO73wRTNR+y16Ib4YAhzhp4xolNUDtgto7uD1wRvhqat9sIQGffC3BD2UL07bz67+cQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(376002)(396003)(39840400004)(366004)(346002)(6506007)(2906002)(86362001)(4326008)(66946007)(52116002)(478600001)(66476007)(8676002)(5660300002)(36756003)(6512007)(54906003)(316002)(66556008)(956004)(1076003)(83380400001)(6666004)(26005)(8976002)(8936002)(16526019)(186003)(7416002)(6486002)(2616005)(44832011)(110136005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?VF1utG8N2cvubkVvNSunpl2plwdRqzSd5EqEysT7O0ruCmBRZ9llAcIr/ar8?=
 =?us-ascii?Q?dPi69NEC3/SJlgPfcOhlkhU7MPU1TgoPdxBSfYvXRoYYAMj9pl0xvqdxo5At?=
 =?us-ascii?Q?XpEaO4lkWr37UIe37i7ytWUim9xiK/HBvgXbr+RZ834F1bjs4Oe1ztOdz76a?=
 =?us-ascii?Q?8qiwoDXDKyMFt82ElJFyMLTJFiG32Fag0RkKHtzENMNPdSvSxs6tvO3i2v2a?=
 =?us-ascii?Q?wxW3w5AaMA5LmwlP7tX7qx5dJ/LHFKgliFuJDxVyGOZFgJDn5q8aGWJXPCBQ?=
 =?us-ascii?Q?ZDdRKiFd6p+tVd0VimVH1JdyOrarmEGrpxC8kYE2SOptN9yMkuTqyP4fe51t?=
 =?us-ascii?Q?TyoSE0YrIfqVGOBP7/2HQOnczAihB6P5RYAt/jEfwNXUJLcaLGuDYQNME5KX?=
 =?us-ascii?Q?4CLsN92Daj/sRWHBzF/aBKb+c25/xMM/ZshhkM4AZXmipOV3TP24dxJF+doE?=
 =?us-ascii?Q?ohZHEfIn1IyBCQ+3wI3htQQ9vGkzicJqzwJsI7UddpVOUCJ0Inl9VCaEWy8v?=
 =?us-ascii?Q?X55vEO/60Iy2ToZ51I56x4NnLT4blKYhlpVInOskYAuEeYoJMHTNMwXgBBUC?=
 =?us-ascii?Q?0xYqAIT533DGzwKLf5lmv+ToUhsn/JG+FfHP4GmqpfumwXwBpkRhu8MvYLmJ?=
 =?us-ascii?Q?NivdIodoqxHgtLzy9+G52M/6oe/xDIKVNiE58kcCvroIz5Q/EpD6mklJ6TuJ?=
 =?us-ascii?Q?a4KhX1BEqp6sPoZLEcblTLiHVSjxeuFockxzSWGXdpvyfbf78vIFhhiKrtv7?=
 =?us-ascii?Q?4D1/mwimwMRgp4b/o6zIg7n9azmIGNH8d4AwnUgAz0B9f4jPwkUhpHptKku7?=
 =?us-ascii?Q?PEzPRlqTC42nwA8uW4Mpx6CEsvX/WcRN3H3bshUUhePA+RDUEJs6uUm6j7lp?=
 =?us-ascii?Q?0GcqSC2d4fdy9dbBOifyo5D82IQk7es8SV/kneUBvScvOEiL/a5QtvvaIk2w?=
 =?us-ascii?Q?5fHuMr8l6C/K0d020QpmD8CQfq0B9Am5eTDWiu79dk9nyUM5AsAjadZB2pH8?=
 =?us-ascii?Q?pfqW?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: d7b2a03e-5a13-4d11-bdde-08d8bbdcc464
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2021 18:13:33.6550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mnb4nWRo58Ey5lhZA+f82/mmQeEkomFWShx47CHcgWzt8sQQDVfmduTg2d80znUJg0u99nJ6uzL59D0G0SyWJzX2IPkQsG2alJZprfQFgks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR10MB4771
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using MRP with hardware that does understand the concept of
blocked or forwarding ports, but not the full MRP offload, we
currently fail to tell the hardware what state it should put the port
in when the ring is closed - resulting in a ring of forwarding ports
and all the trouble that comes with that.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---

I don't really understand why SWITCHDEV_ATTR_ID_MRP_PORT_STATE even
has to exist seperately from SWITCHDEV_ATTR_ID_PORT_STP_STATE, and
it's hard to tell what the difference might be since no kernel code
implements the former.

 net/bridge/br_mrp_switchdev.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/net/bridge/br_mrp_switchdev.c b/net/bridge/br_mrp_switchdev.c
index ed547e03ace1..8a1c7953e57a 100644
--- a/net/bridge/br_mrp_switchdev.c
+++ b/net/bridge/br_mrp_switchdev.c
@@ -180,6 +180,24 @@ int br_mrp_port_switchdev_set_state(struct net_bridge_port *p,
 	int err;
 
 	err = switchdev_port_attr_set(p->dev, &attr);
+	if (err == -EOPNOTSUPP) {
+		attr.id = SWITCHDEV_ATTR_ID_PORT_STP_STATE;
+		switch (state) {
+		case BR_MRP_PORT_STATE_DISABLED:
+		case BR_MRP_PORT_STATE_NOT_CONNECTED:
+			attr.u.stp_state = BR_STATE_DISABLED;
+			break;
+		case BR_MRP_PORT_STATE_BLOCKED:
+			attr.u.stp_state = BR_STATE_BLOCKING;
+			break;
+		case BR_MRP_PORT_STATE_FORWARDING:
+			attr.u.stp_state = BR_STATE_FORWARDING;
+			break;
+		default:
+			return err;
+		};
+		err = switchdev_port_attr_set(p->dev, &attr);
+	}
 	if (err && err != -EOPNOTSUPP)
 		br_warn(p->br, "error setting offload MRP state on port %u(%s)\n",
 			(unsigned int)p->port_no, p->dev->name);
-- 
2.23.0

