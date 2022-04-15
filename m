Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11963502B17
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 15:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354081AbiDONkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 09:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354050AbiDONkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 09:40:09 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2096.outbound.protection.outlook.com [40.107.215.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CB9BD2E0;
        Fri, 15 Apr 2022 06:36:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tf4bC5g+s8eYZR+CM2QydHlY5NuY94ZMpQ9p/cz3oA5hZZHA8nfrSkW6/4Y40yNZsn0r6M41QJMu19Jp+2xyvMxJe8/2pkc5H7tGcwJLPTzbpJd4PsSZ8gfAXsImN/N697ZzLndGFMiHfADBf8OTLxc3y3sgdgCvKAZgUplWOjIRndl14vPxMKux9rYMZsV9+XAjBUxdFuCU9MWHD8vkmZsTT1Hy/wykQBrWLM3i5f75empl9N3KDwUUfV/G/AREROxI5gC1wQt10SP4H+Swx/3x0U9+E/iBhtzj0ibv7nl9tMCUPsuXijxgRSve+pnADN080YAMLeIXtBUD/wLMjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mo1rKHODXTT0LgWmCINey619TOJMbfokRijK5zxeSmw=;
 b=NmlljZjswq2Ltt3UnsYy6IKP+Jnhd42CPGS94t1siB0nPLOOBMHIXSLBka6L9CzZVL5qen1fB/xLUDle0lwGXi2b8Jve+4yj5M+kTK6GfP3Tmyx5ce9coeVtrd2UWqCoHnHlxMGggt4N8+tPva9SASC4F/Jckxc3POZHsMJ9kWEHDp7VkTUoViOJ2gukfLp6rEyTY9tuRGNL5pmnXx6h1FnrkhOyI8mdLsHJHLC7sRYXrjCBwEDNbIZMYajKHCLJsl51c9yfn8rdxs11PGncKUGnodmw9H12UepGiSPqRzW1jNfIG6iZRntF4EKkYpW+yaZDCQmJqJejeVvSsfsyEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mo1rKHODXTT0LgWmCINey619TOJMbfokRijK5zxeSmw=;
 b=TnxDK9Mf3BnPxu0ltH+UOWawbEiT/Efp4H0yOKQ59Whq6gnSWpJUHF9j1cKRYi9ZNvB+CoLlB6ehHn6ANodCLa7o/0AlyqXrWu/GJEmQ28N2yKi1p9k/uUf9baxy97z+q4fzeF86ej0fa5QJzcJ/wn4fMITJq0IThRxN9Zzpqgw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com (2603:1096:400:26::14)
 by SG2PR06MB2329.apcprd06.prod.outlook.com (2603:1096:4:5::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.30; Fri, 15 Apr 2022 13:36:51 +0000
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::d4bd:64f4:e1c0:25cb]) by TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::d4bd:64f4:e1c0:25cb%4]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 13:36:51 +0000
From:   Yihao Han <hanyihao@vivo.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com, Yihao Han <hanyihao@vivo.com>
Subject: [PATCH] net: ethernet: enetc: Add missing put_device() call
Date:   Fri, 15 Apr 2022 06:36:33 -0700
Message-Id: <20220415133633.87127-1-hanyihao@vivo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0020.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::7)
 To TYZPR06MB4173.apcprd06.prod.outlook.com (2603:1096:400:26::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49cab372-572a-4d7c-225f-08da1ee4ff41
X-MS-TrafficTypeDiagnostic: SG2PR06MB2329:EE_
X-Microsoft-Antispam-PRVS: <SG2PR06MB23292C69269660EFD0537C81A2EE9@SG2PR06MB2329.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kl5SgK6J5MFe1+K327auUeIIYBft+ofpzp5+GIsuPqEBmWz3lUyCwUY0c3fMpc/yF48YH+N2AWyyD+5YfR5BFBGafBMk+NJONuqTTL0rdTEfIUD8NjN76+jVuY+OFua4qdgRQwJtDR/izjUnLQ8XGCeAOPLSC2E+TCGdK34uK/N4lLxQlkDX0oLvVUt8kVQpBMJzl1TOnOMUFRHHrSJ/VjGNZRJbny8j6KUO6rANrjFXmc4qFVF+c1Fzl20fXvNoTcXnP/WY5e18ZEkD4ZZR9kMBJtub+ozw+1mo6++s/aylWFgaR2sAx664lpwqtzfrvr1s8VawVBfc2tIJcRdj2fjwbe1TV7Quu7M9K7KreGsMpU4ntDCIjIJzLve7GykjokQEQg8rt8cBtYsFhPGN0H8Ty0xVKm5kQpHt/skROaAUO3iKaPmlnUFYQZqWQD6HtT82Eqfa6iSmXXb94A/k/HB4SdNAruQb4rfvF7Fwjehx+3N2J6nGvGVMgys87Buos5x74bBlJsTebbTC32PBEagQDnyaMkc71RWMjOYfIOYtmh4FLOaUFsk1/WY2D1DcfCBEvnFU5Di+PT4iJVLUR24sLb05zfmjFcvPwtSlamdC/xC4QjzAvibN8OQX4s+RVqa+9atJMASHJopq2LbatwOscK0oGeFywbSZX0yx2iU2iR1db50ATZz/F+6oCVLptygHw9GYk6fKohQ538OV4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB4173.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(2906002)(38350700002)(6512007)(508600001)(66946007)(52116002)(8676002)(86362001)(2616005)(6486002)(107886003)(4744005)(186003)(26005)(6506007)(4326008)(66476007)(66556008)(316002)(36756003)(5660300002)(6666004)(8936002)(110136005)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JltwIAmYaIQhS8eU8TH+WCSU9jr4bBRgLOuZOA/hvOy7rGTLHCBCLp1suzeo?=
 =?us-ascii?Q?R/T627xSGWtJoMMGpAGMrEquQNl4Ti//k+e/rwAhyeSjIGQNopdShkSEXXDG?=
 =?us-ascii?Q?0c01tF1B7smllDxe5B77SkwbAfBNAtlAfksf6Itnp3a+IXmFDAGzGzMxwCgN?=
 =?us-ascii?Q?s0BixCF3DGYewtNCvl3aN0kINnkzVqjO+mzCvSbLHbKySkNYD/auxerBlJGv?=
 =?us-ascii?Q?qnSMWdUax85/2LAes5QDmbtZC8ZTfI4hiyYXa1qhebQZo3m3S8j7X3Gb2Ewb?=
 =?us-ascii?Q?iBxOx41o9XMT2NMP9dlbYirvNGHzMjLK7IVX/01RkwH9SiuHHuaCjrHELkGl?=
 =?us-ascii?Q?AY4dzVf7FE8xahS0TsNcJ9PvC4bNLyD6NSYfvgWlKiC9zHW8MrmOAWkoSapz?=
 =?us-ascii?Q?uq7oZf7zjI189/yb0SU0xUF++FQZ8Mzh5FZgbWXFJQGvxJ7e/b2eFXpnMTha?=
 =?us-ascii?Q?10zFsHWBm4wQx9IlG2Ahp63/oL2kXh1nylIUY3wtAawDbRS5rDce9fXuyEaO?=
 =?us-ascii?Q?YO1Gi0tgr1sX4fzFtvRJrHIWagja+y6OzhFHsSDMfNwvDPbYRMNbkoCmbSxd?=
 =?us-ascii?Q?gOKkkNxaBpgyEhxb/1avCZFhZKJu3Vz+nq6gq+GVS1URAM6gA9LLjeJkR8Ra?=
 =?us-ascii?Q?4YkMIabXuoctiWVDlreFbc0sKQlyRjJD1j4hH7aFOP5V56tW0zX28cEZNXWS?=
 =?us-ascii?Q?HfuExV/woa/gw5nEuzrdH8AEL7VUHpmdeNvIcfUCJnfzbXLkAC8Dce2bzlTt?=
 =?us-ascii?Q?6r5Jqlrs92egWUQ0uHgDgQUbulWUHXAD+hnPIZbIgPMZUeyTD2/vAEjscDKm?=
 =?us-ascii?Q?rZZjGL8wG9Yf6vyAsJXaHPRQ+WT+YbZKx8AgW2EXY8iM6JKC/vjXL8Gjk82G?=
 =?us-ascii?Q?XcEq0Gkhk1YK39yIujxsCCVQaWoJd6FhqqdF8/8P2OkZeW55bxPoIzIXSAjG?=
 =?us-ascii?Q?FqlKaLAZIaddJ0hW9EfVyJIWE5xTsX3lgMRd7V8ngUO1AGBTJOb+1JCUDV82?=
 =?us-ascii?Q?Ev2mIu2Mke8rQMhzoxKw7zXd0grbsfjCPDk2k4FJJx+/6C/g5RoVAje8q2J/?=
 =?us-ascii?Q?AByLD1RqT6F6e84zZvB7UMEp1Heme4J4ehtd/AHjF66o5MV2qbijkHq0w2p5?=
 =?us-ascii?Q?XR8nIDh0eAnjl+o6zaX8YmGcbWR45CssZcj3CDepCJQkfFdjdLItIwVjHAiC?=
 =?us-ascii?Q?h7Y3LuHD8AhUGfLsaF7PqLDrBbjzh3F7kDbvUcddPKkpsj5Xfg6QHf1RePhh?=
 =?us-ascii?Q?TUkueD73GWIAJFqSdX3tTK1G4BjY3/SAMvZteQrwxYWZv6SLFJPsQxRLAbYZ?=
 =?us-ascii?Q?G6dDI5n8InXNzVHpyNbUDbIC6CxgMHciGCX+9t9OZm6hftHbRf7UMfU5y8lC?=
 =?us-ascii?Q?sjk5IjCH24HXEzWx5M4CS52PiY8wfy4KK9kMV+S+mfkX5S5Flf45PBmhUkrS?=
 =?us-ascii?Q?/XmRT54FXx6Wh4y9pvlZyi1l/ZLGsFabo02RXhxJE/PoL4pF2fTAQCYU3ilQ?=
 =?us-ascii?Q?E69ARnnYLR45VZB2X01+7onXkNJ5RPF68rY2o/xVwnB0P/lUxfeNDrBWLfly?=
 =?us-ascii?Q?mPjDhTf8RNQRy0CEakukc1//PHZezWeZCMslYbTc/5qhkFw2FvXkv3l0xjjl?=
 =?us-ascii?Q?n79Fy5l9yWKVrbo52ajkpzCRZy1J8uAfyGJhI20vnEl8tUsFDiqYf8Jk1876?=
 =?us-ascii?Q?RdX8DzoRtC/UDDeMdMemEjrwwCKnnQrVmjKmTTo6ZEX5EGLN/f/fAtCsnV7C?=
 =?us-ascii?Q?APnSHtGhsw=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49cab372-572a-4d7c-225f-08da1ee4ff41
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB4173.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 13:36:51.1900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eMzUuIPHxnQCHLkZuYO9gHdqcMes5qJilkgQi2DPvxeyZZhBnCqL0VI+nfzsC2kXeee3FJOhsGYcMJGHOKAa3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR06MB2329
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A coccicheck run provided information like the following.

drivers/net/ethernet/freescale/enetc/enetc_pf.c:1180:1-7:
ERROR: missing put_device; call of_find_device_by_node
on line 1174, but without a corresponding object release
within this function.

Generated by: scripts/coccinelle/free/put_device.cocci

Signed-off-by: Yihao Han <hanyihao@vivo.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index a0c75c717073..d6e18afda69a 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1177,6 +1177,7 @@ static int enetc_pf_register_with_ierb(struct pci_dev *pdev)
 	if (!ierb_pdev)
 		return -EPROBE_DEFER;
 
+	put_device(ierb_pdev);
 	return enetc_ierb_register_pf(ierb_pdev, pdev);
 }
 
-- 
2.17.1

