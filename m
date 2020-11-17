Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCD62B6D2C
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 19:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730845AbgKQSU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 13:20:27 -0500
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:10111
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730443AbgKQSUZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 13:20:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EKGwjNdxFtU9cWgfy9+i4u+XF/ytHBXJFTd5Opc7k0FMFaIWlOYid85XYrXkT9fb603SAldYPKa8IqmShtpvCrUVFAG5lFYY8IydtSyLdDBixf/xkhvmF1qqJnihRHAfnjyKuayLT4UMmRFi5BloRvlAKV/42ARO30MfBSSkeRapEmmDV7CiQ1Hc4dnppF+iebIPAisFG9OCmEctTJ3oQ0Xf3/+vkZfudyIuYWBavFuKKxYsJAUerOPeMivV+KDM27M7Xucy2AzTq2PtJDWyjlBUXWiWdtSdbSH5P9Haycp/nIqylEx7IVcb4h30kdh1Qe0YHRQf6H0Ax6gJU5Ln5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yjrxKGmF5/mKYiCuG/rBHcF+WgFSk9rlQozsEAO+QvU=;
 b=Ev0d/RVaUAkIKKuS6RTjDnzzCuu7e/2hZjvApyOX3IIKd4IeCH0i/YcRhXyTLc42k1pDfOklDXAZsAJDvVoYKohykelnmyBQXojVITb3Nk5fg6ccoH48CAeVCmFf2VAQcjyk03qtzg+2V7eYfQPRqXnulI8eq5kGDHl2uuEScbZFXDiQGDjwFepTXTwCrzerc5uIHfC5Yg3M6CNPlwbOemgmBMVQ2eAciEVuZG/j+uZK/mOwI/uXpvD4GRfJ4VGuicYIa4rMQn+DYoav1PiC3ZuyK5B7S7Jh8oOZ2dINSFUw/Gfgp1NZh/kIOIFhKIJN6l4+zKrUr31rVxbLJfd/Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yjrxKGmF5/mKYiCuG/rBHcF+WgFSk9rlQozsEAO+QvU=;
 b=nLlx7/Wdb2b1jmmOQhnwjSbYzNEjFb+OxEaZer46RIiGI0mNNGxbUR+2VXE8KRVsrJMS7F4nGG+/nZ9cPvzzxof+9OXwKFjM3XyrpJNcv/YsjhdElIcmvuH7uTr3nVIJVbXel7yUoj46GASHfy97X+ioQgdh5tnfb6itJC+DNCk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM8PR04MB7473.eurprd04.prod.outlook.com (2603:10a6:20b:1d0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Tue, 17 Nov
 2020 18:20:20 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b%3]) with mapi id 15.20.3564.030; Tue, 17 Nov 2020
 18:20:20 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net-next 1/2] enetc: Fix endianness issues for enetc_ethtool
Date:   Tue, 17 Nov 2020 20:20:03 +0200
Message-Id: <20201117182004.27389-2-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201117182004.27389-1-claudiu.manoil@nxp.com>
References: <20201117182004.27389-1-claudiu.manoil@nxp.com>
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM4PR07CA0022.eurprd07.prod.outlook.com
 (2603:10a6:205:1::35) To AM0PR04MB6754.eurprd04.prod.outlook.com
 (2603:10a6:208:170::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (83.217.231.2) by AM4PR07CA0022.eurprd07.prod.outlook.com (2603:10a6:205:1::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.15 via Frontend Transport; Tue, 17 Nov 2020 18:20:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 255729b5-b631-4fcf-d0ea-08d88b25716f
X-MS-TrafficTypeDiagnostic: AM8PR04MB7473:
X-Microsoft-Antispam-PRVS: <AM8PR04MB7473D16F62442FD7DD353BE196E20@AM8PR04MB7473.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rYz/Fly0SBBRE0m4M7l00/yIkmUzaweej6N+6svbKNR1AC1D743ibX+AYa6xssLR/3k5nNon2P8CK8ivEPB5EMLEYUep7XzYR8hujseKjYGIo8Y0qqTMauj1hPQTZH0RgQxhfcOjEX7O00iBdVN3fl+AaQf2b3zAlFpDILLsH4w5lo9PDWkQlohzFrF/bscZOE81BQ1g4EHGZHTm7dnxBs9Uk6BSUZIIBWRVwvotQdVT/Lb8Y2x84Hz+YQYhd6PQrTsh1GDGfZK6KvfrNP4KmVTdVo12ZNXZB58AD80lSK2IzzAM/96q2tNEPndnlB18ZWx5rHwnbqmn5yeyV7Ajjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(39850400004)(136003)(366004)(54906003)(478600001)(66946007)(66556008)(66476007)(44832011)(2616005)(26005)(956004)(7696005)(52116002)(4744005)(6916009)(36756003)(2906002)(6666004)(86362001)(16526019)(4326008)(83380400001)(316002)(8936002)(1076003)(5660300002)(186003)(8676002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: M3Jz/VQOhuf82izdeBkrdHE2vaGF+AuFZzzIGwk3w671ustvUqPozqJzS7vt+AJ2HzLkRJ6n8L38eHbtprJgMCxKfMuJ4z8ecGxSAPVAD0n4WA4cRL+lpKUltiV6pEQWG5MhCQo48+bWUVyXNvKBkMlMgRvk2ALGwzFQZPdQuCqvp7ASppMwXnZOarrbyGNhX0nokkpnvqHk3P0hlwrHhaPVY+rs8q274batJLqX57MM6LlznZOTeanFy94XcNg8PtbuAycyqS2YZS9qsa8q9jQZAT4NUMTT/e1iOHejv49vPvOAxiLtQ9fGFsGshAKCqStX5gsnq0MVHGJ6hP8F2V7o/ZCiKZ70Q9LwBR571nU6NLZITrzBXc3t0ozUIBJUE3q4w1sNy44i1SxjRz9bbycNkEAKlHoYjKlPBz/hECF9mGX6KOU3WyCylAUBgqa51yF2MnCTANoRaCIcYFm36MeK6wO8dyq2KdiY6l4ohsm0yv3cq0MR7yxLzH9N1UOhutQB8I4zwrxWpPb6XyrcBzo15qhKxtCjLyrqpvwRJuBaAXSBlvH0Kkc/nUvCmJ2o/UtUpkPfbgeW87sVcQ1Sum8yloxD/C5SyTn+lmbYCcSg2isiKrYDZfnPsfoy2Tnc5EUEnzKlLPPeoSvnRfHVUg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 255729b5-b631-4fcf-d0ea-08d88b25716f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 18:20:20.7868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w69Ap+tQS5AqSydNuTBbmQPhCtWrk1iDtmeXQSF7m+JL2ueEvox/gUFyeY/eYMsk12YwJi7MpPL9SjWB+hejsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7473
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

