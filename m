Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB5042AD71
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 21:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbhJLTuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 15:50:10 -0400
Received: from mail-vi1eur05on2087.outbound.protection.outlook.com ([40.107.21.87]:55521
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232145AbhJLTuJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 15:50:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eYoDbN7ON5+YIE9Tktc/WeFq1Y51WS25P0UgIoHRbnpXR1E1/IuRg2Yw70UGPEYjTfog9mPw8dfG/7R2Mus4tQLyKHSVwzAugjrbn+JkZAVGYoi6EnxkJ0Hy/n4/rNa8+Cqqqhdyema6hf4aDaNuY5iVvye6t1AVuARYCPFVwwZe4SnWqXRamVXEOoEL7cHCdTOXnK4M4vf1OvYYO4EnrLzKKOKqcSdNiG29WvZkWeKnoYwJsVRXauQl/yrhZdFybn43QQqhQ/+/mog45e1Ejsn/I1kSVWWGULpethqEsBEauR5/PdzXWijF73NASRzksyNo9Lcb5jj2gghfUqHzGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=38tFKZKxE/lndsWX5QV1DW4NOSCtd9vlmeTTyLRutbU=;
 b=L9yohJNNAbq72jMGmTF8EyxJEO3hZ1+HENZHiDiVF2R2rCPjzHN3ypcfqVR3quPLNUXVx9/0xiGsczeY7QLGUa4IiyVZg9Y0h2f0BSJ79kGDaMe/jItFGE2SVL9E+1cATlkyo+TxJVSCbmX1iY+YagNnz9dQQkPf04PM0VbD6eUIl+87dmwHE+ZuOBVe9Q6hemffONCEAflLABOINDcsBbKeAp+UFAFMvzbF2pZW09Gb0Wne3kFZewhENrjyveLWOSZYzLLtmlZLK9P0UFI76pZ3hMzGDpk8crTAibIjChCw9/MDMR9ygoIlBvHlBsLkx5EF/6ZhlDFoaFx2JMsPIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=38tFKZKxE/lndsWX5QV1DW4NOSCtd9vlmeTTyLRutbU=;
 b=AIRzq7xUfs7xUUMBXvaR1F6qi+56GmgxsClt6yp3MvyEaLC3cx1arg2w0of3BK07cTPP+xqoZ4vIFyAjFOhfUD2E5zlxnrFWR1uu9shurOMcAqhxl61ixFrVOZ7O1u1mgqn1gK6cvv0BKxjvyhUH4ENj6Lr2sxIn+6bnoSVuAZ8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB9PR03MB7513.eurprd03.prod.outlook.com (2603:10a6:10:22a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 19:48:05 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 19:48:05 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Antoine Tenart <atenart@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v3 1/2] net: macb: Allow SGMII only if we are a GEM in mac_validate
Date:   Tue, 12 Oct 2021 15:46:43 -0400
Message-Id: <20211012194644.3182475-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0021.namprd19.prod.outlook.com
 (2603:10b6:208:178::34) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR19CA0021.namprd19.prod.outlook.com (2603:10b6:208:178::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.24 via Frontend Transport; Tue, 12 Oct 2021 19:48:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b992d5fb-6baa-4c05-fb6f-08d98db93573
X-MS-TrafficTypeDiagnostic: DB9PR03MB7513:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB9PR03MB7513B1D8E9F65F4E040972A196B69@DB9PR03MB7513.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H8IWpxPFRdv4pLsoeLvmEPwDKiq8PiLQXgccyVTV5FQefKba/0lUrzmMZYu7fcETCJlR+/sSU8aPAAuKj+4I9aVtyu5oyRQAaLgkXiJVt7OjejP4vr/uGPYJ7G89yhX+ldavqlWUfYjjrV6IFSFiF0MrJVZJUzbbfI+u99orqkofHN0VI6PDrKegGvCTHPMaI7ME46UdEUzIATf52a97E6oQuiQzd86j8I5L6DPxPcyN/lYhHsP4nI7JL4XLJgKl7LIWlu77h6WkJ+Y3oV4LuJ9ZFhQsNSx/lY9zuiVWl0cUkRQzJLwQpCn+tH0EUkQsqetULSJ+8esqdhuJIeLCfR4QAtHsOF+uq2Vw8FIuxHC9BrQ9TUDMjObThBHqHvSJ5nWcKuGpYXvgE07vJ1ZbllXDog6hg+/wZWIXhiXJHv0mq4vKGh2dR8n9CBli85BIfMSexymwXiE7coBcfPUfH8tTp805jlCxsEl1dLzuWePZz4RHjblG79fAtoonZwhWm5xNgUnl8FD3NtxK8YGrVhLrilSmLLywj3GoqNX7FqjHLGlUOCxXFxM28U5o9UxMs8RNuPDqJaT2bXZSJ3Q+jqlEWd/EE6XeupUKv6FSuGrJT8A5Q9JiT1ANy40IGXhdZ0Y+uAPO2e7tlUg2vzHnxEFpXH2XBjEaKLJpDY5CScsgQKk6y7fzmP8Kz2NpTJv67MO9sWyJWfQaiBZffvxkKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4744005)(44832011)(2906002)(2616005)(5660300002)(107886003)(83380400001)(38100700002)(38350700002)(86362001)(956004)(508600001)(4326008)(6486002)(66946007)(6506007)(6512007)(110136005)(36756003)(26005)(8936002)(8676002)(186003)(52116002)(316002)(6666004)(1076003)(66556008)(66476007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LrMz+ETweoDKe3nlQhrU12ItqbnhBr8ymIGMoVZC90n7t8iX609PCKW648dO?=
 =?us-ascii?Q?EdoLIvHwlSfRRkgH0kA0rOlWs/d7Vf1mK19ofvBUaRwCXAMOPEU4mlrfm1vB?=
 =?us-ascii?Q?3piqsOGLxWEqqI75scBa3sw5Se+8Jr9fS1FvbwcDUtlhsHCpCs/+2QmLPq8z?=
 =?us-ascii?Q?K682HpXVOMGQLqQXpawjMQbNtcCC/2CS6p8XNf/YkohXuQKXW8q+dZdPI9Rt?=
 =?us-ascii?Q?/UEVB3QsHvEETngQo0OdyQUpS5jASxBv7pXbo9BmWZVeLj1kxXClO/q4uUo/?=
 =?us-ascii?Q?QfDqzX90P2V0t7ECeUJV1kCaSFQ20iDTcgSrl0i2Ix1OCUoEerl6+XjnqBfs?=
 =?us-ascii?Q?FLJE304Cs8jmVagN5r54UiaSUGRGHaao4LiBk0/QJHWO+6ICpSD1ZPjhfh2M?=
 =?us-ascii?Q?IJ3DoG728B8BPmdEIXXnNHTwInTSmhwh7vU2AoOAzMoHBvmxfXmHP8SGi/B+?=
 =?us-ascii?Q?KAKa1HcgVT4uRZ6FPK6ileQ1eAPDf3+OF5XT+aQ9lp8nBG2mh0zCy/t3rs5n?=
 =?us-ascii?Q?TBbTzhwfuz9aJt7qjnGeieHhTvrqhZAgHc9+7H4uWav5ypH8ox4oE54TbOUj?=
 =?us-ascii?Q?HR+D1thjPz0OBDbF/YdTpXs+VipPsu9QcYLwx8wnlQgwBRvjeQ9LlQI5xezh?=
 =?us-ascii?Q?im3UXfJqMR/3lGqO1fu86qTnAhZPYisGspKyijVw3wjzpFhx6tq4ca9yxt/y?=
 =?us-ascii?Q?OjGSwXhfOKuRwG8JsX3iz4QtOrojo2cgwW3reo5IkAfn8npnwdXrK3GWkN/t?=
 =?us-ascii?Q?qaMpCljadWdg0p/dj9c2vIZln0RhNV93jAeRnUP0H0g0GMwJMHv7D28yN4UE?=
 =?us-ascii?Q?8Is79j7/Xc4yRv+lScCNNyPYdhxgXh7z92qJtt4E0QtMbYM1z0EQaWAci5az?=
 =?us-ascii?Q?sxFvHxD+TeZqoVsWPZ1JmrKqZCWlfDeu67xi1O+VnxVfc46SUSCvfo7GC3KR?=
 =?us-ascii?Q?P7B1DbFvvoAgXTDAJ/xFw5/GKDnDVYG6jBZKDi9a1eUOscWdLY/cNd/uQxPD?=
 =?us-ascii?Q?odSytczsMMOYXQmOf26YAL/bZfQXcawJpyILqK6uEd/UMFY8xd5RAqtgZTe0?=
 =?us-ascii?Q?7SnR1qIsGBNBCCUi8uXr56dvk5yRmCLuEEc9M43ktzp5cT591FFdWbvMiqZ6?=
 =?us-ascii?Q?RoGMWM5hqhUf1LUDVF+1Al1lU5Ppty93UXJ5gH+Vmltj+mRnQNRzk2FrF3Qx?=
 =?us-ascii?Q?LxGeWsS/tDiLuWTtZcE7/tSlelmRRU4/5HkX6RBK7TzpQSFLmmR5UPwlMJbU?=
 =?us-ascii?Q?+cFt6QEJ40ofqxSohqNQ2FFwY1CAdderWWpcYckkH7DHx5jiBOnbJn9aW+7w?=
 =?us-ascii?Q?HY9pdAE/VL2YjpwlB9dtIYaR?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b992d5fb-6baa-4c05-fb6f-08d98db93573
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 19:48:05.6944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sftPyiV7xuh3l8OoWTE46Jr5UZrcjmdexHQFzD9IlMM/AKTtY69o1ylabgDnSbOoj9Nd4hH3Q/EgTPugulT8UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7513
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This aligns mac_validate with mac_config. In mac_config, SGMII is only
enabled if macb_is_gem. Validate should care if the mac is a gem as
well.

Fixes: 7897b071ac3b ("net: macb: convert to phylink")
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v3:
- Order bugfix patch first

Changes in v2:
- New

 drivers/net/ethernet/cadence/macb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 683f14665c2c..cb0f86544955 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -528,6 +528,7 @@ static void macb_validate(struct phylink_config *config,
 
 	if (!macb_is_gem(bp) &&
 	    (state->interface == PHY_INTERFACE_MODE_GMII ||
+	     state->interface == PHY_INTERFACE_MODE_SGMII ||
 	     phy_interface_mode_is_rgmii(state->interface))) {
 		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
 		return;
-- 
2.25.1

