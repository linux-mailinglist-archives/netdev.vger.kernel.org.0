Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4CFC5183F0
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 14:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235108AbiECMMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 08:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235099AbiECML5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 08:11:57 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50073.outbound.protection.outlook.com [40.107.5.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487C137A1A
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 05:08:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GTTnWvuW2XVo2H5O+NKEe4QFPoPJPvExZDZzMvMdSXERf7unhauqMTMXaJOo5dz/+rTOBHjw81NCNztQFLG98og11paSoFdQvquFJtGYpYpX6b3WXe0pV1x5P1XYRaj4zpSnByLVuc+KVxxbQ5GF2ZIGQmpAWQS3pN0w0UuHUtEGP6SfgPYwopLiHvu6Oo6HX0WT8FzjQGOnCy3dxk75S4GcH0T2A97abixpZ3HwikUEA1oyM6kJiJ+bKtYROV/xG+GtrOWdCKq79QDpHVelAtzV5oob4vRuMS+WdEqgk9GLzzvkOumeZrizy5SWlQ6dkktYPPZoWcMV+Ly9PW9AGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2CmntwOqWWVy0WbP5I6tND1NP/eqHcBJUkTj+UruJXM=;
 b=ehLIF8TOyDRp3mSlFZP75t4mmjrNAqYNxpMH1mw/UjgUG0Q2ypcT2VxlsSMczTa066ycfX0fB6KpV+qyGJrrjQ2dGDBJ5oXT493AxWAgXHV/e/UIywrLMMMpLNseS0TMyEP3JK53QjzbRIHYltGjZHcDwDLLl4Kivk9Ov1kD3Ohtn8LPTAY+gXpMzZZrjmhIM37M65TGpd0ctF0bI3fSgbF7vVi3ddqHzRxq6eyk7hyIDcPVSP+VsSiZzj0NcA631qG0iEtlE3sl44gkYzNegrTaO6SAYXDBpLLGcXYz/26xQ7ZiZPeitrJ17QXG5ooDoD/Ajs1XZ+cwYi5JGa1Qow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2CmntwOqWWVy0WbP5I6tND1NP/eqHcBJUkTj+UruJXM=;
 b=Q9kocL7GQ29zJ2v3IwyzuV6OqOiRZ70x8iKPjrzZ4OFHboXaEPbyyx+CvtzD9pSdjafrTxjddin1P++CUR4i4J5J9eIBLpyBg1CF2wqJ0YDQGe3Wg9sdOW7bYPgfDZt4SRj/+KwUkYWao8+NcnJf3CEl6fQUDmBX5Qb4gNNVTNE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DB6PR0402MB2743.eurprd04.prod.outlook.com (2603:10a6:4:95::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14; Tue, 3 May
 2022 12:08:24 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 12:08:24 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net-next 2/3] selftests: forwarding: tc_actions: allow mirred egress test to run on non-offloaded h2
Date:   Tue,  3 May 2022 15:08:03 +0300
Message-Id: <20220503120804.840463-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220503120804.840463-1-vladimir.oltean@nxp.com>
References: <20220503120804.840463-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0080.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::33) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 629cf556-e7bf-4b27-ac3e-08da2cfd9f50
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2743:EE_
X-Microsoft-Antispam-PRVS: <DB6PR0402MB2743ACAE40440AEC159DA1CEE0C09@DB6PR0402MB2743.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4pOyCDu4Ml8vgEt/ygaMVPTpfMXrSHVMuUK72JQ9qkeWf+zpHlr9ue3ndMQSyZdtQOrgf0dtxo5rvx+mW0oezS+WjO1484xSh+oU+ZniZe1q96vDiN0FxTQsyhhpE/zaWBjaH/TIjJ/AdxVWPO/kE8hQz8sOZcIxIs2fpGiv4d+jYFEJcEaKKH7qdDp97HOUnPBLQbDPI7h8FMdwTgq7VSYNOXsWWCDqy8kZS20fUeaE+XiA5+b5Efoh72rULR4eU+tBRlG0QqG/cOMvr1XRV8ngF/DeKiFPxalRza0mBnT8W2vh4ihPhwVV/f4Ig6ng7xy9FcOq/NHRxSoinwAF020uQQpzpw9tmOFR54rj21Gktks/AdM9jj0cXMMEY6sv+cfyxODfUNPLdxfVe0yC4deo2k6K/XrSoMbu+EdmdM4d5Y9iChWoD93yVkJijTmEEA6oTgdEfjba2ZaktJJiuegiSw7C02zeli1CpoatzoaLOiwOiGPqs9tvnqJAl+Y39sQsMn+86ik+SzCREmau1p7X7qHTqN1Amdc6ZBkQe0qN66tqbkiK/rzEx3EPHHXriVpWE+Ed9iZvbmC6EuMXvdo9NMHG5rMp3bFVXJ2ND+cz2UHN0rhO14DsTUOtxbqUycb0m1KSiahImxdLm5Yab82r6JtJe5V5PrTFxzVYeIUegYK4pAsDZ1wcPSgbw3xd9mMu/g9TGJk09yqAddvIvbSUVUrmdc9kAQj4OscK7HM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(4326008)(36756003)(52116002)(6506007)(66476007)(8676002)(66946007)(66556008)(2906002)(83380400001)(186003)(1076003)(6512007)(26005)(2616005)(44832011)(86362001)(316002)(38350700002)(38100700002)(8936002)(54906003)(7416002)(6486002)(508600001)(6916009)(5660300002)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u5t2fF2zXU6Ygx3nwe66lIMx2TNsPoFTkNyd78pvqVpx4iJSR3txu+IEKmh3?=
 =?us-ascii?Q?O5NU3LFfztFtU5D2m7bxZ6PcM8XpBkPNDOSIX5+ciflPqMNLNHtpZh6B6hoO?=
 =?us-ascii?Q?J2lskYkvA7KZipaMtk4BwzQfjP5xEk0o0pqGCP81CZCCsKgyR8t7TgFFxafk?=
 =?us-ascii?Q?MnHXAesvZpacU/2gsFxG040RObwkMNsCUtFx7CLH6uCq/ohqTH1f2Sam0aF7?=
 =?us-ascii?Q?1/DHxfNH5wSe1zehODudiUeluDaw8LNnRiJATlDs2DcFH2zUICgE9dmofLXk?=
 =?us-ascii?Q?lwT3J3/OmLw7YcqpBDCt1McEBm8m0yUbsKLDjFRdnGyfeUWup8twDNKcMxDD?=
 =?us-ascii?Q?I8UKfGsh6lkGqt5jbBU4ztuJrHI8ZwE/VRJDiOi+Rv1s1NN7Fksamqk7L7lZ?=
 =?us-ascii?Q?W/d/JnlOkq3Qwa/9/obpR4CZGmBDr9Ws7uwU0J4nMvTdLcx1PJDqhjw8jI/0?=
 =?us-ascii?Q?43/ygB4KPdO1ZzxhaZUkaKjm/jBbQcyIPu96qB+u+Mxu0aReQSac/EZ+RtAJ?=
 =?us-ascii?Q?WkyXU1KHEPNGfKiY9vf2LuyGxo9KNFcFB9olJzj/C9sTJQ7WEvBDcihFt87S?=
 =?us-ascii?Q?qrShTviCAtHdDqW8nO3WSZAWVT74JHCenaHn/WRC0IWKJuCbQFZe2cEUicp0?=
 =?us-ascii?Q?F4F2TTh5qL6ECmEp/RuJ6+bgW5bGJDv6Mk2hSil44STVuActxxEYCB8FLT7j?=
 =?us-ascii?Q?WvseBtQ2vH3RH2lReQqswAx3G2WYbofsi47wzBMMzI3eHL2xg8YxNwbD5RH0?=
 =?us-ascii?Q?lpgQHZASyx/rLseNGDiYq7P9evpXEw/H5PHDkq/ppaHGlHarxhJCKXD1WMqe?=
 =?us-ascii?Q?e+zVw3LVJwDHvcKwM1/qNrvaXE4N3HJt4gbT8jiFQJb4gH1UjKEkDTQE53xh?=
 =?us-ascii?Q?qyPneg6Me9HLcPocE90XNNlSL/khdH2CRBM6bphlJ4TbNMedu80MVvPD1xxK?=
 =?us-ascii?Q?qKAnMr/oveSmpVKkXjJWWfUKo+44h/9fd7TO5d5MSXnxYndNPIQEoGW3KiWM?=
 =?us-ascii?Q?lNoOK++i2nfyVSFVScRg/pCGP8Q9q404Ijj8Ix7l+/gwE+kLGJZp7Dqdewx2?=
 =?us-ascii?Q?lVcFnDky4JMY7TL0r6mOdWaqr6SCqTbviFdxOekXSvjcaB8iAe9ty8b3dtlO?=
 =?us-ascii?Q?jpgsxzGX30OuCXT5G38W+xhkmS8nxlZNU+HOHZ6+oIaLiFFVcgPfxBY5hUqL?=
 =?us-ascii?Q?VYZysKxMlOHP/87Wb+UHUEszQtHRP9efE6lw6AY9cm2z5Q5G0pdk0Mx/NbRR?=
 =?us-ascii?Q?ezf5bG37Uh+wQPRuBsxdEjp5GILSM6j5d5d+d/2gDx9HmI1TT1nUvwsYZFx8?=
 =?us-ascii?Q?Yz8p1fkR6WhDmx6FghuIh/QrhWmwLzsRQDryPTWxoDrAaG44AVWsvxZlbY72?=
 =?us-ascii?Q?ju1l3pR5oMNYCdBmCyPqTJ4XZXp3rYRHfoE601owceCc/8bIZSCA/RvkEQhb?=
 =?us-ascii?Q?eVN+agaKSY16OqlAlePohgP+NBuWNPkDS8ho/JaOm/qQw0RdrI/gcYjFgvGZ?=
 =?us-ascii?Q?WUG9pH9W3SxQuCqE35pzTLCaL3oeX39FL5+IgZN6UpdYBSRDdZ1lfAcDxCP9?=
 =?us-ascii?Q?L5CGwV3YkB2JeEaiZLMeN5SIuuy1QzvqX6qcKIHW8RrVdDsQZf168lJkHo5V?=
 =?us-ascii?Q?YdPH03XJxh8e4/YljGQQjphzUYbhlPwdbK45stsO2ThbFzEQXfa2rxZOnRz9?=
 =?us-ascii?Q?LQNkj0oFei3lFlD/8fK1RjdqV7umLwk+jzYWEz8iRoGM6M15VfWX5a6yBCJo?=
 =?us-ascii?Q?fXHpI3KEivzTeAlPuY/8PZwVYcQTPwA=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 629cf556-e7bf-4b27-ac3e-08da2cfd9f50
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 12:08:24.0683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4iWaa/gIoicGfV6SKnIyQjVkfuQr9DHnAts3jRNeobP+4m3EuZjK1ZVYSTItY/tBRfxfMTxGcUtpwkIx8L0yhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2743
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The host interfaces $h1 and $h2 don't have to be switchdev interfaces,
but due to the fact that we pass $tcflags which may have the value of
"skip_sw", we force $h2 to offload a drop rule for dst_ip, something
which it may not be able to do.

The selftest only wants to verify the hit count of this rule as a means
of figuring out whether the packet was received, so remove the $tcflags
for it and let it be done in software.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 tools/testing/selftests/net/forwarding/tc_actions.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/tc_actions.sh b/tools/testing/selftests/net/forwarding/tc_actions.sh
index de19eb6c38f0..1e0a62f638fe 100755
--- a/tools/testing/selftests/net/forwarding/tc_actions.sh
+++ b/tools/testing/selftests/net/forwarding/tc_actions.sh
@@ -60,7 +60,7 @@ mirred_egress_test()
 	RET=0
 
 	tc filter add dev $h2 ingress protocol ip pref 1 handle 101 flower \
-		$tcflags dst_ip 192.0.2.2 action drop
+		dst_ip 192.0.2.2 action drop
 
 	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac -A 192.0.2.1 -B 192.0.2.2 \
 		-t ip -q
-- 
2.25.1

