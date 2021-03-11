Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B56C337EF3
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbhCKUTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:19:05 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:35663 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230162AbhCKUSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 15:18:53 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12BKBoQS029473;
        Thu, 11 Mar 2021 15:18:39 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2055.outbound.protection.outlook.com [104.47.61.55])
        by mx0c-0054df01.pphosted.com with ESMTP id 376bes9j08-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 15:18:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QB0UTHWjSQlpnq6M8P3Tlo/VNFEvfptAlB/yISQOnu8QU3i/zZh6SIT05nopfrKB9eS/ltGgOWcjE/y+UKNJVCzd3g9tzIzyqhZHAkWtQ46Dg1wsVynJTsvg9FKxkF/4VE5uUFUH2XfRYNRB1C/JMTXpbFH2M1qgFi3cknXD8Wcrhv3Cpfiz4wsaB+X1JgGOXwN5L3dQ2ui5qoO/OosKh3KEqbWa9Yu18Wfp/a8SMdJEXw822c81mtSzlVusOqxcxWzgzrtdQ+i4UMiJCijePsV5Wzsp+3M9FPv1fIsQKYqysQJIM3kJFLx+tusXYT8qxHcECl0H89goSfW7T+L0/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RKpPP4HLlhMN5q81MXsZJ0CmYcarp3U6ZFAwVVGkziw=;
 b=bCRHuuuVW2lJIpdV7JDBuNuHoUHhDa4YAZMIiFnf4cBJHZGpQnO5KKLqXaMGK41CjxJQarl2L4Z4VDX484ahPangkHu2bu0f8X+whFyBqOQR6NB4Kh39LwFFMBkjvBOXpAvFj9Z2oYuRDhQopx//x8zoc4NCk8ZTYSjmEC9psV7CbfAXe4GeFM7pZaQByAyv+F6Jt7bh0iRQeNdKD/h5xX7jkVZtf4RarVsn6MgPz51xkAc9C9aeg0C13vihLRn2vp7FSQScvKT5ecdps8PKQNWt8D/4WkMLeHIaHD90XgwevHDgzZB8uQM8Vgf65xMvoMQyn39ZwJQ/EcW54pTIng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RKpPP4HLlhMN5q81MXsZJ0CmYcarp3U6ZFAwVVGkziw=;
 b=f9qra5Yb/+dASOFdRVM0Lw7V2LiblSE1rqWryVNTzsMDxoi1T2yyhi5rMv/ya3HRuuJynmb5M25ZsY9Qa3XarPZCR4hv6N2YTebVnII1cBbgnpfB7B51RQc3sTwrLfO09mROsyMDO5Fkj4CzI5Gt0qwLvJO/j4V63fSEyAf7jKI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTBPR01MB3872.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.25; Thu, 11 Mar
 2021 20:18:38 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb%7]) with mapi id 15.20.3912.027; Thu, 11 Mar 2021
 20:18:38 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 1/2] net: macb: poll for fixed link state in SGMII mode
Date:   Thu, 11 Mar 2021 14:18:12 -0600
Message-Id: <20210311201813.3804249-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210311201813.3804249-1-robert.hancock@calian.com>
References: <20210311201813.3804249-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: DM5PR17CA0071.namprd17.prod.outlook.com
 (2603:10b6:3:13f::33) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by DM5PR17CA0071.namprd17.prod.outlook.com (2603:10b6:3:13f::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 11 Mar 2021 20:18:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 768a56c8-1ff9-44d1-3e51-08d8e4cadafb
X-MS-TrafficTypeDiagnostic: YTBPR01MB3872:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YTBPR01MB3872EF9E20F76E5112D9E4C3EC909@YTBPR01MB3872.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mNgtNWssoCrEF+9NOeXcyOsRkRXQqaJHMwUHDVcRhcbj1vtlrJ5qyNwOGCMMvumBSkoWXKq8OvGGHLU5Kk5YjIJRbW6VyJ4mat+nV/MJBoT4N1wcFYh7PXBQWV0CSUdLvVW4uyKnQXBaBWU1s07HgF7WkZkBp//EhTz/dyD8rsq6w6bjEkSnu1GSSKsZyNGj+4841CVTuoAISrrVJdJmORaA2mWIyJXvwT6E/JK76w7iJcd3RQhnv5ybganMsK4fHnFieaEkrY+Br4gyiGPMl/tKbiwQLvFxQMqWLJd8cv1PcDvGgFwsb2UVhO2KlBM+ZL6IQ6jfAGx7D6WFZuj6WhVswf77iu/UyyFDW7QFmwIDjCssGv8rP66VWDNtTJ8X9Y7DYlgIUjkzuAJwSU9JE9FAS9gWnAm9kOxHmQKlUtHWhsb/kEIUUiy4WuRsxbT6yBwe0ZlRP+UK6RIDgWufEFv/cVmk0+ci7AEk13vyjoE8gl/ppUmAFhBI2tadbaIMs9A9ZctW9h12FU79jzB0v0vSmPcinmRls/ENPxQ5rXRjScVHfKPzwkqEokmmBdgHv/ggWSvN2hUBPsODDV+xfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(366004)(39850400004)(396003)(66946007)(36756003)(6486002)(478600001)(52116002)(69590400012)(66476007)(2906002)(66556008)(316002)(44832011)(86362001)(6506007)(186003)(16526019)(2616005)(8676002)(956004)(8936002)(26005)(6512007)(107886003)(5660300002)(1076003)(6666004)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+diGX+k9Hn2kp/y58doM6d61Je5nlTmYQlQUR8pb+0F84LP3yxKZPGmTxc7T?=
 =?us-ascii?Q?4QDx2zin62NOCLAphWwfiOfupZGZJb1KiAJ+IxpUM9EncxHhFQhDKyNbuDJu?=
 =?us-ascii?Q?LgoY4uRtCG1vxH3t5Fkr4bI8rvN4JjUCWKdbtlMwwIMNSxYe0MqNOwfaeyU7?=
 =?us-ascii?Q?sStdOz66YScDi6jglJekSXwcGPRADVs2RhO+9TbbeNMxgtpuqqcJgQ1fOHjr?=
 =?us-ascii?Q?BXlSKyhyLKWmfDYS9PIhwWqvTpOXwj3twYUc7RTRimTeXCzasz/BcGu5a7PB?=
 =?us-ascii?Q?cbLf0zHok/cv8qUmqRzudjWWHmyXeH5vjK2oV1XLFOAMTOQYzwWFriMzc+Ts?=
 =?us-ascii?Q?ZtexaqAMLyJ1xoW7wn8RVUc8GRUJar6n7et+eBttoDzXCoYe6JI9wE37nnwC?=
 =?us-ascii?Q?HUqLpc902JWGXxMFrDv3Db7YdfxjOoXfWAsXovNdJSIFsCp74G8noGEJ8V5Q?=
 =?us-ascii?Q?UyCOP6cLWdV4C6tsssY9jD45WLGAgRNPxlohYmLZptAs265oyMcTzqZBJH2U?=
 =?us-ascii?Q?Ne5IGRVPRnOfGd0U/Ynv6thX7ObVT+Lbc/XAQ6XyK65W+ZSDV3R2mN3R3I4u?=
 =?us-ascii?Q?KCWW1HxoqRlpWkyczpIFOhG+/cG9Vdxc51PpAWSTwSGLonoZ1kBTLCyOiHvt?=
 =?us-ascii?Q?3Myrb+lOCEyy65AA2gzBrINswJmWssWs2bC6Xk5cYe9lDpQtA7h9LfP3u0B0?=
 =?us-ascii?Q?5X4tQHETjGeZUKZ7zVYMGw34wjfUN5BJFVXYJnQq8QVrPryhSHeP2c0LpfdA?=
 =?us-ascii?Q?9EhYIyXmXpzNUEGtL90xy0BfCYbv1+kd+z6mWuZa0ra2DiHxfyKi5fSC1f3d?=
 =?us-ascii?Q?3ZMKf8vSQWBv5Z0mCIpsAtUJ1fvqSX5Oa2JcRcRND7yk9VrxXQV6BONhV0hD?=
 =?us-ascii?Q?JJYwQi8dU/4msffy5NvxhfY69CVi3O4o8d/HnGtnRSER9/rqECcfpY0BzBw4?=
 =?us-ascii?Q?UegoUMXFhbZDRtduNCbVTpFi5EJEHBE9ScQpfeQqqIZc2RCXuAHWWOu/xrBx?=
 =?us-ascii?Q?crJQ98xNXJJeZg0sfgBFUJitHIwnscngKMNyVcXIs/OQhrrM2+WRG5pZBRXR?=
 =?us-ascii?Q?WaxM8ujTWwBCHES6Z521eN5dDrmdGsMrRnlikDURR6KmVvUHejaO4CmmYS9O?=
 =?us-ascii?Q?l6V2AQSMv+x1MoaGsUynD31CgpXN/Fa8Ksyk5vtFvlMKq55bitvngxr9jC0a?=
 =?us-ascii?Q?jnpsKKGUftTj2RiJLBy24FNdtaXu7jRzseU9hJ03tYCN14SO77ClqN9a0X4j?=
 =?us-ascii?Q?SSOSCOvUuXp9pgvw6gQOkOVVKmdX1JqmMvRPQSvMNWVqCcNCmWuWkK//mVcB?=
 =?us-ascii?Q?3iDwJhk7emW9o3Qg4kOzyw7m?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 768a56c8-1ff9-44d1-3e51-08d8e4cadafb
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 20:18:38.3889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9NinHvSHZ/RRvhGcWKmxGZvv/OcuYC7f4X+dPwrmDTosC9NH8JHYG44NFVsU5BQDj4A2TPIA1S/ozFg9t2mEkiwN/7PMbggdV6xbWosNUu0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB3872
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-11_08:2021-03-10,2021-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 priorityscore=1501 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103110104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using a fixed-link configuration with GEM in SGMII mode, such as
for a chip-to-chip interconnect, the link state was always showing as
established regardless of the actual connectivity state. We can monitor
the pcs_link_state bit in the Network Status register to determine
whether the PCS link state is actually up.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 15362d016a87..ca72a16c8da3 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -847,6 +847,15 @@ static int macb_phylink_connect(struct macb *bp)
 	return 0;
 }
 
+static void macb_get_pcs_fixed_state(struct phylink_config *config,
+				     struct phylink_link_state *state)
+{
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct macb *bp = netdev_priv(ndev);
+
+	state->link = (macb_readl(bp, NSR) & MACB_BIT(NSR_LINK)) != 0;
+}
+
 /* based on au1000_eth. c*/
 static int macb_mii_probe(struct net_device *dev)
 {
@@ -855,6 +864,11 @@ static int macb_mii_probe(struct net_device *dev)
 	bp->phylink_config.dev = &dev->dev;
 	bp->phylink_config.type = PHYLINK_NETDEV;
 
+	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII) {
+		bp->phylink_config.poll_fixed_state = true;
+		bp->phylink_config.get_fixed_state = macb_get_pcs_fixed_state;
+	}
+
 	bp->phylink = phylink_create(&bp->phylink_config, bp->pdev->dev.fwnode,
 				     bp->phy_interface, &macb_phylink_ops);
 	if (IS_ERR(bp->phylink)) {
-- 
2.27.0

