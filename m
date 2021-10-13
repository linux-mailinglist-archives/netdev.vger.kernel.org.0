Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0EA42CDCF
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbhJMW0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:26:32 -0400
Received: from mail-db8eur05on2069.outbound.protection.outlook.com ([40.107.20.69]:19889
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231233AbhJMW01 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 18:26:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LO5cQbqtVSIE54oJNe+/4fupfqH8Vmjz9qxFSaeyCPpyu0niBnTIyFAZdVLZlU8AFAs9k+Lr4qaXS4XShT9ogx1tjaqs411rLdHXiWrdrfK+L5X/2h/xMPVrYHU5sE5vasaln/KRI8x25mhPY+Q5XzR/+1vpCT2bmSP1O+jPtFTpH/miO1bLGkOpBAGbODANV0+oV/VQIawZOOwPA3c4bwfM6UF3WeU18rWRPNq6YjT1kiWHWXm3YUxyANRYBcIWB3t9kgaiXYGtI3UKyI3ncJHbaLU0uSIQ9T+80UQy3rv+mkjU2sc+CJLy30viGkOg7XynYUmtvNa7mROoBhru6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kv6GUC7Bu+h+nrbx44u37bzvSSfiN5LhFjqLrR4GIwA=;
 b=d68QKPram1qcp8hK9eLaFrdHM6VwfPp1Mg37H1kBjCXSAW4U7JSAeVNCrHDC/guMa/FAneZhGKZFLEOuAOicwgYCjGwC4LPj1n0dOKqyO4VGB1+mWk+GBcOZdd2IoVQexNnkv5nDvjhdLcE+ba3LPWtZHh7R9IaF2MDmR/w56do8mr4OSXPKhdwXk/NZlxZQB6oLYybCA16P5GCR6Rqp50MMayTpWTsCeEK9Cu/ctd1c82a3KpB7Mrom8M4M8DNLdcqXC1VmwzTnIeiiuT52h8qaPJybAZS2RaZwpC82IfetSs2f7DS9ttcTZcOwRNux9JtS19OUSLlAtgBZ/eheoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kv6GUC7Bu+h+nrbx44u37bzvSSfiN5LhFjqLrR4GIwA=;
 b=jVoakJHJIf8Y8jIlc44oX7ESPmn6b+tb9aH3yz1cuzsRyuh26Y6u6ycjYEejikaxhUROVIEhTnaKj9SliiFfUJcXv+jbPYaU8N/XtZZQT5P9+amRfFMr3Gkf3qZsYo6klrMQAdjWYzKlkF5ia/NdQJF0MwGRwRqNqfZCXblKvnU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4816.eurprd04.prod.outlook.com (2603:10a6:803:5b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Wed, 13 Oct
 2021 22:24:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 22:24:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next 3/6] dt-bindings: net: dsa: sja1105: fix example so all ports have a phy-handle of fixed-link
Date:   Thu, 14 Oct 2021 01:23:10 +0300
Message-Id: <20211013222313.3767605-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211013222313.3767605-1-vladimir.oltean@nxp.com>
References: <20211013222313.3767605-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0154.eurprd05.prod.outlook.com
 (2603:10a6:207:3::32) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM3PR05CA0154.eurprd05.prod.outlook.com (2603:10a6:207:3::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Wed, 13 Oct 2021 22:24:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e94dcae0-012b-4d63-6683-08d98e983481
X-MS-TrafficTypeDiagnostic: VI1PR04MB4816:
X-Microsoft-Antispam-PRVS: <VI1PR04MB48166B12BC0A869F0AB1F483E0B79@VI1PR04MB4816.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IAI4J6W29mSelUWODsBZeYUDzgMmfLmrUdelrQweZzJ2Kyz80asY/siZmIuSFRfx/37UCHYjbvhhi3QSVzNDILR14h9PCCN1rCosHa5SjxXaHr5+C8wg4MfXVHQ1onnp2xb04Fh+BEyB7LmiwLib5jN8r22rLTX7PknzWNXBhWMjZZyqYIRhzMO3lSvr9Zn/RaQo5IGvtMcKKvLRX0mxUc/hh3HG+PBB5+ZfAIe9H33gVD3T8lkrRwEnswY+OnSOIa8dWsGx3mZH43p6BfYnyG4WKd4pIadgITpGkpukRLqRj2NDJnqQG80d83QePLoP1USy8SAJbzyjTeQmq6dDlpTaxfDyTCIwCfLhjf+kCqZnSoMhqnjq/lGdr6ReaFVwuzhMQ+SBO1GACeNHOsHBKJtC+sIpJttTlbx3ccLx4Hc7uMZ3sf+TnpC/y2eMmMwIRWFdyutESas4xq+KMHNnx6LkCepWkv2mXheMRSPHpnOXSLi3VHUbBk6V25eTF27iCGzyTlz6I3FhngL+hG7zKIpJOH0O31NW2kVu3/upADQCsrfd2LpK5IM4ltRFbQIvQbBjyV6iHaYK/5h5aqKh1HBNWK71YG05lw/x09OYbJVMp5rQHfWqI9bX8oT7hQWAeleCUKkm1dTKeh+TBFCKC5VEieOH2vMoM465ObsAkgrh51pFDknQS8ZiTvnKMJtpEkP4b1x9KRXf7PJMmr1CRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(956004)(38350700002)(1076003)(38100700002)(6666004)(2616005)(6486002)(26005)(316002)(54906003)(110136005)(2906002)(8676002)(6506007)(36756003)(4744005)(66946007)(6512007)(66556008)(66476007)(8936002)(186003)(4326008)(86362001)(508600001)(44832011)(5660300002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4dPYJM1NTQaLu4Bfv1svWk1UHS5zvGBDh8Z2NHdksAI9Kkr7s+b/XNkQmk9/?=
 =?us-ascii?Q?TcCGb+luDSCkkTciXK+IxDbNpy2CAaJsXNStqUaHj2dmCtk5T2iqzTsQFCHl?=
 =?us-ascii?Q?dBkA3ragpEVkkdhTUDXM6ptKACCfRCaIT3Cq6FFRSh1kg8NkRZtwaTNbe6N1?=
 =?us-ascii?Q?RYlRLihNVvns2+7DobPqxkEH6BXezh74ebeZvRWGRcodn6NIwu/OAvxo8F9j?=
 =?us-ascii?Q?KSOTKa0GmdF69UhmsMWtjhCuwPU5gSrC4YT9MQx9AmewVRq6HHD0em2ibeCz?=
 =?us-ascii?Q?WutI9rnJSGx4M5SNaIechEr6W9JOhd7bK2WEX4k1ees7qXOZsA/V820IgODu?=
 =?us-ascii?Q?JLLHIeaZQ8GDjZSMFS33Gr/1/mvbbi0SZSf43nL48FqGm4k7dBA2M2qHulwq?=
 =?us-ascii?Q?6K3QU0QdsxBf912+qZgwRnGS+JejPyxV8WgtAmOc1QWFQm2wbG+8v6G7uXpo?=
 =?us-ascii?Q?to9pcdMlPWJ3Wh4ll4vpM+Rz2tO4jzHfhH2qLsVHtFFpLbh9ULEGTe/bz0f5?=
 =?us-ascii?Q?efUmgfiuUJl32gWqU35Gx9S2CxoIZaMoaV7VIYckxNnsXiULw+dGL/4ZzlYn?=
 =?us-ascii?Q?uW2fILPMpkCHdn5EKA50jeV4Nj6jU2eSbsbbiT044Sp3o2V8hZkpiC//hs/Z?=
 =?us-ascii?Q?DkJQU+Ul4m7mPEA262b+I1q9uisJa8cpZavs+dkccJlMaZp4lFro9UwZi/rz?=
 =?us-ascii?Q?DTeF5SY/80ve2WBcEuMbB+NefU+oHOM0fkXioHPR083NPE1EqhSLoLSRBUM5?=
 =?us-ascii?Q?zwDvb6kW91fq8u9GGCZnl3O3ZuKmciNcdL8Pf+9xXTr+Fvuf+K23rM38t0P6?=
 =?us-ascii?Q?XjI6VyLLb26ZOG8Q9KwN2EWvSgJ3qG8sooG0pE3dpSeMxDYCxidqslRLPdCa?=
 =?us-ascii?Q?yzr/ZXgLNM1ymqLZKjznaVV6zG4vjW5C8XctQOBCKq1PcLdrrs4/31EXURkQ?=
 =?us-ascii?Q?GTEci96ljUoHsIA2mWZRrhQjoakpm+qV9c3c+E3yaKp4ITXOLCaQTfdV28/u?=
 =?us-ascii?Q?jFye2OLxTu3sXnU1ER9ohCdWT8C+aVd14IiLS05v5cfHIIAyjXIqhf3E5XVW?=
 =?us-ascii?Q?70I2HPOOee9rZI5QLJLT6x6EbdoEI6D2OrX5MelHSZzE+wAHVG+9m+iTog49?=
 =?us-ascii?Q?ABJWnSQmrbh08rnkMaLYEZVkwer+VTySdGwvDlHWfoXEk3oj5AKYXc2s+Jwj?=
 =?us-ascii?Q?Zh9G/ni3w7Zf2ZrpIc0WDQ1Mo2cGg2v36lmj+17qr1iO16PNFA17HKMU9qoQ?=
 =?us-ascii?Q?jgtkm87WZd6o4kRYKgHOqWFMf3/9+PVN48myzlNs5PHOORQholg8pFCO03ew?=
 =?us-ascii?Q?MB3dKo4CNPvZfAg0zD0Z205e?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e94dcae0-012b-4d63-6683-08d98e983481
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 22:24:21.8783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: haf7lE2GqI/+ZzIOcvCmYD1yFy1hoKw3YavJB4mNXGKO9k9iz+HWX1jHLVY2BPwNfCRcllyXJpX8poannxz72w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4816
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All ports require either a phy-handle or a fixed-link, and port 3 in the
example didn't have one. Add it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
index f978f8719d8e..f97a22772e6f 100644
--- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
@@ -113,6 +113,7 @@ examples:
                             };
 
                             port@3 {
+                                    phy-handle = <&rgmii_phy4>;
                                     phy-mode = "rgmii-id";
                                     reg = <3>;
                             };
-- 
2.25.1

