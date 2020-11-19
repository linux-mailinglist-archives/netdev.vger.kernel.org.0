Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45BA82B8FF2
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 11:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgKSKMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 05:12:37 -0500
Received: from mail-eopbgr150047.outbound.protection.outlook.com ([40.107.15.47]:38467
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726617AbgKSKMh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 05:12:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNGW62VV8lkvdaUq5MQJKp/xqgOaGYAQnICID/SpRoM0Nm5HWLlBrIisJoaUl28H9Omasv5UCINjvvHPlpxiynDUslj0M4pb4Jtn25fh7HnoURdh+rLJwsLXo0WVd2BgSBGZv4LbLtfNp5VEQIPF9PMU2LjEzmS4EWs2vlZBjHffM95jbNt2NCTa8cG5+BW/3jXF5W5WOEdDFJKn1KDQ8D2iaJal0qoShpQZpcZ5c2123oR23GoLk5b0xNctRdtsnqT+MAvefvhZGtnd97uYFqirQxo1rJ7Gf/VmJ8gyvYxFjusYaYfRCaqTl+8NI5KX+MPRYI1u5UckpC0n/1Zp0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yjrxKGmF5/mKYiCuG/rBHcF+WgFSk9rlQozsEAO+QvU=;
 b=IA4199ifIpNWe8L06II7vehWtau45lBYWP9rRXW3c+49VLAsk6F7SqjYi+JPijdUKZBS7VvVH26WPPA1/KLybz1MS/pVgmTZDxdBWFdRmauj5SqqpKzOQGkOVK/jqm9D1NhX6C0+oRu5KDuqAua77cAxk7T09dN6SMFoi+IKMteWDLkRJJbmwJIRpsxIoYV0GnzwIxFOv7sKIfE1NnHb9JH92he1xjWe/V/ZPz366TZ45dDD9LRe5FlZ+YPhZCOmAT5YQVD3X0hpML1HH8UWUXtt7hgZoivsOaQtP4DIvNDr46HaHekfhANTcm1VI4j/aJu/01I6gRMm3S682rmhZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yjrxKGmF5/mKYiCuG/rBHcF+WgFSk9rlQozsEAO+QvU=;
 b=QT003q6jPavf6T4fwnLfmtWnn7iAKTcbhsWn3ANnFk0E3T0BiAbuxKp0clSoLB862nwnBbCvwEZ93fSoiYcpvITELv/gjLQjkFmfNvfuVWnWQ7zO8PXsjlVfem0YvkFYsEI/zL16Z2+LLpYEB+4ASRcnYLtk/gTIXmQgvkAYUOQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6764.eurprd04.prod.outlook.com (2603:10a6:10:10d::31)
 by DB7PR04MB5402.eurprd04.prod.outlook.com (2603:10a6:10:8f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Thu, 19 Nov
 2020 10:12:33 +0000
Received: from DB8PR04MB6764.eurprd04.prod.outlook.com
 ([fe80::a1ea:a638:c568:5a90]) by DB8PR04MB6764.eurprd04.prod.outlook.com
 ([fe80::a1ea:a638:c568:5a90%6]) with mapi id 15.20.3564.028; Thu, 19 Nov 2020
 10:12:33 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net-next resend 1/2] enetc: Fix endianness issues for enetc_ethtool
Date:   Thu, 19 Nov 2020 12:12:14 +0200
Message-Id: <20201119101215.19223-2-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201119101215.19223-1-claudiu.manoil@nxp.com>
References: <20201119101215.19223-1-claudiu.manoil@nxp.com>
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM8P192CA0025.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::30) To DB8PR04MB6764.eurprd04.prod.outlook.com
 (2603:10a6:10:10d::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (83.217.231.2) by AM8P192CA0025.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Thu, 19 Nov 2020 10:12:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5f3e10db-79d7-4492-713e-08d88c73a12e
X-MS-TrafficTypeDiagnostic: DB7PR04MB5402:
X-Microsoft-Antispam-PRVS: <DB7PR04MB540278217FF9964E1DF9277796E00@DB7PR04MB5402.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e/VlyJYlRi1E9i6HJ73zGFrOJZyVyMjrsHmXg/bZNLTu0XiQcMJ0DwnXwB3hm86DLST7I9t6NhcClFytBVZ3QX75ve9gUwwumC/xa+t+SA6Jtna2iZ5xEvgwT5BtLjWM1OQzJcsl3HYxbogSQovkEWiSec4DCqf2eiKgAhzeDkxUITzaMxycvQjMWo4nt8FG2phVko2qtIfizwB1UymSN8TGYRWJl9cMQ3mVLZFOj4YM2wyc0Q17UVLipFP2SlZ4Fqp9EpVL3sN5LjBspOLNSSzILN4zRkJ2xmDHgXvMjdXNwSRPt/a7edZyLfhnZODt6fKle4DWMGWLFBtpqlceDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6764.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(376002)(39860400002)(346002)(6486002)(6916009)(6666004)(66476007)(186003)(66556008)(16526019)(4744005)(26005)(66946007)(478600001)(7696005)(316002)(52116002)(54906003)(83380400001)(5660300002)(86362001)(4326008)(2616005)(2906002)(1076003)(36756003)(8676002)(44832011)(956004)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: opkeXVvtrl9sgtdBVgnX7+fgckXaAfxFvC9qmvZfCASZvvxpGoWXeTbkRUKmTl81mU1GZ/9maCGHDEcNytFiS/12fn8sfVwm2b/axlyhmGippkI/29Pp3L7DGbNDYEGgsVYX1LyDT8uA5k4bMejAHUaMgh1JyvfBui7m7LOT9vmI29zlKK1KdTWlyBv2nOcefH0CgIZ6/8bUwR5bM4pvdBDUk5Zd8hA9PdUF30o+nO4lI03JaBJDhvBArWzBzpyWfaWPB/sltibLbBtBCMW+GTgJ1jozKJ8y8ZrSjFQb8hH0AcCg5/JP9MkrIGptM8igTHy1Jpec0jydWGYiiLsfLlT/yUf0VScdpOVnTdn+6SyHyrHPwQ1qzDBeMTPiceUUbP11dT2xNBXvit3IthX/BkQmWGz4xGvcvOD4JYr7lbmVNoVaVfbpJJhWJjYQaa20xGe6hcs1dg22SKvGPtioBeucrQlpvtcC8TVUy49wJpokRoGIA2I9oLhL9FlWTowpAyoQrvZfIt+3JylGOP7yYa+RXI+WMDXPWEsvtkglHuRHvJmzr6x8iAhwimo7kDFXHMgNLKHZOK5GY1+2M4FFNrNLG3W1GsBABQGeyaBOWREtdJgimGV1jI1t8+Q8Bc2Iq/VrgI8za+DBAhqV/VZFDg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f3e10db-79d7-4492-713e-08d88c73a12e
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6764.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2020 10:12:33.1235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3cOZ+PRYE01N25zbSEfkbizeh6SBi0OWbz7pl7EAEWcZR0Q8dCFEFJP1t2R9GP8NGQWQR/1gVGpV1emw+epH/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5402
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These particular fields are specified in the H/W reference
manual as having network byte order format, so enforce big
endian annotation for them and clear the related sparse
warnings in the process.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_hw.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 68ef4f959982..04efccd11162 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -472,10 +472,10 @@ struct enetc_cmd_rfse {
 	u8 smac_m[6];
 	u8 dmac_h[6];
 	u8 dmac_m[6];
-	u32 sip_h[4];
-	u32 sip_m[4];
-	u32 dip_h[4];
-	u32 dip_m[4];
+	__be32 sip_h[4];
+	__be32 sip_m[4];
+	__be32 dip_h[4];
+	__be32 dip_m[4];
 	u16 ethtype_h;
 	u16 ethtype_m;
 	u16 ethtype4_h;
-- 
2.17.1

