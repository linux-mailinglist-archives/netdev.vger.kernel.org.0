Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6DF363D412
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 12:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233754AbiK3LMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 06:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233774AbiK3LMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 06:12:39 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2087.outbound.protection.outlook.com [40.107.7.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0DDBE082;
        Wed, 30 Nov 2022 03:12:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SbEEPn0TF1QuiZdMjCDDu53FTIE3OQORphwxr4lvKe9/vlfoKU5OGRg9/4EP6CeFxUt/dz6/T9oeEeZBcJfhNunduAdqaWhb1gRBOxnIhBlhwqPdqr04qTpbRsFc3itcVGkQJXUAhgsEtwHGh+Igu63k/KSp8Yqn8QDVOLrmNufIfaak0whz+puaknJAXpzy7NEIa7FXmFCeIdVpbEUNm6wLzxtRr/OTrLJ2mL2c2iqpvlA9dh5CXve3+Mu817PXQQDh8uyXSAfX/KumC9CElF5GyV6EOH7qT4dvrVN3P1pjVLztWQY4bMn4sjkDw9smvu92yGqB1XnqsA3y+jcdaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pcGcUItpjeww0tGMOp8wBKaG3cQ0i4UcshYGUsVqJpI=;
 b=bCmqHuwkPgW45CYZyphmqT7kbWP86X3UqA4vM0DdV8iE9BQu+4cztKsgMBztfFDI/uoaZUhpCHATWMu7mNgfrISlxFrlUhE9aqwgD5ImxvFTd8M46DZWEoAOSr5yVFabTxKDYafFHYMVlK28YEEOc9HWZXIEmshp5THq7pTqEaktBFqA1HZ39NYGLincFsCCacq4vonc0aQI1pY5voYtnA535UafKvSJ/Ltn0gfb5Ne+gLOU8B7HfvjYxWr3v6DE9DRgnkiPHlGY74RmSKslP1sGcmaqZ/Fy4OEORenTdFNpf3xgZ3vyU9yRB+MfmxrT+FOkouN1K+zu6omivJIuow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pcGcUItpjeww0tGMOp8wBKaG3cQ0i4UcshYGUsVqJpI=;
 b=I5SJ24OZSb1oqW3ShPcp1+/qE0rUBLHhrNezYxOdkm4i7hRqa8hfbqIAkm5nmOWOqbZgYiFDoL4FPHrbKeIFVhQdeZfuCOu1/9aXHdYi3FcHc3PB2mYhMQSum4aZqV1/AFReyy4hC7fRzt/D4D5s46hHtMY4MISPyJK9aXQhPI0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com (2603:10a6:3:db::18)
 by VI1PR04MB6783.eurprd04.prod.outlook.com (2603:10a6:803:130::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Wed, 30 Nov
 2022 11:12:35 +0000
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::7682:a2e6:b891:2f4d]) by HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::7682:a2e6:b891:2f4d%10]) with mapi id 15.20.5857.023; Wed, 30 Nov
 2022 11:12:34 +0000
From:   Clark Wang <xiaoning.wang@nxp.com>
To:     linux@armlinux.org.uk, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] fix mac not working after system resumed with WoL enabled
Date:   Wed, 30 Nov 2022 19:11:46 +0800
Message-Id: <20221130111148.1064475-1-xiaoning.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0020.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::9) To HE1PR0402MB2939.eurprd04.prod.outlook.com
 (2603:10a6:3:db::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: HE1PR0402MB2939:EE_|VI1PR04MB6783:EE_
X-MS-Office365-Filtering-Correlation-Id: e3b81c8a-6d8d-4678-fc65-08dad2c3c824
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NdGmo/J9GCZ76K28+H7orieByCKQlk4rk67CiJyKawmwi0wDjw2TI3PndBKlK13/BBVzCHsBfVYefQwX4LPynwCcl4ymr4oyc0G+u1OcKq2TUKpxkeL+VIano4kQPPOctrudg1bKaOFciMxHxy55sWXHo9pIY2C0an3n2BcfuIxmaiCmQGwH6Ac5yFiTVc3av4gw9x/BJnihQ0AgggVgEkn4hEfng0SKeLb+eArEdbNNZRLwrOmY1zs2zG7fvY23ZQ9AxJtQZ02J+ieuwXnQwJG9PAdvseVOnFjtE9nZkR1mE7wXDAnxIj6aP6eONjwQmc9pMIgC/QyYnk4JNH/GzXnest4gdxTvDd1izhVm8uZit4s0V6zK3Zfcm0QrgvuYxqefxySf/BTepawWO86V5HNnas2h86W+j6efpsN/pR5BxhUP2lZiuFyX6sWU8a1RBNufMgjP5bbBIk1pmNsD9IFF9FiSeagXRsUxFkgs/F4rl2QIEdcIa1E9GBnKuBijXDybwLhBel6Dj066sZjhleNHEKPt7pwd/H0A0nYaF2V/B8ujs9+xFPm252u7Cnem5fCy3kUEib0+s1rlfw9Qgbltk3wRAtkKXU/mVsNc1wsEkmGmj5hBx8cAT7rZ1RwmNtdAbBw5S/M2vKrti+yJVqobqN8UMnDwvrjIwfyQfWUAZQ2sdwW81W1vk26hVXsFgS8i4BWGX9vPjN6W1zGT+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2939.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199015)(36756003)(921005)(41300700001)(7416002)(2906002)(38350700002)(4744005)(478600001)(38100700002)(86362001)(83380400001)(66556008)(8676002)(6486002)(316002)(2616005)(66946007)(66476007)(8936002)(5660300002)(6666004)(26005)(186003)(1076003)(52116002)(6512007)(4326008)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0amvugjOxO2gBcy5J9b4pSCL+qFdzeu2Nyuy6359f707Rg0VxBwWzTNlo6uL?=
 =?us-ascii?Q?EOyqE5hUP/2g+jaPAIsQjVwRcSkoJ3u8qMiKnpC/27VPtMUY75VGE6J7P/wK?=
 =?us-ascii?Q?tOrylaibVyh9r8Z/wcHxtdkAou4dflAGmh49OXZ/06Pgv/k5lfXJrmMv4/5p?=
 =?us-ascii?Q?6oqvqoU13HrTFvrQKCfCUDEPe/O//kTrTGrDXecCAIvni28OTAq6lga+7aNP?=
 =?us-ascii?Q?9JkxlMroRdhJz+3r+RGJ4/ZPNtDKy2zVqtJ3Z4ks3R1vxjL1ZO0SHZfO7eLL?=
 =?us-ascii?Q?k36QPLa4dyyijnbPPZXR5BjU854OCtJgtRaGthRORb87P2NJiWw5l7XfEfWt?=
 =?us-ascii?Q?aZsWAsRpjyNgsXGSm277L+KpFgTNJ0YNnggSk5GtECOajKzbqpnoH2wAXOaa?=
 =?us-ascii?Q?3SyoJ6ierlgMC8q5Rki1rZDX8nJGP14C0Suij1lsG5c1lWXN4HsQgWCpXtiA?=
 =?us-ascii?Q?h+LQRdERb34NRalOaUaEzfR1zZmkaCoA7PfR35SfNlmNsOFWsmhkbwa0Tv/o?=
 =?us-ascii?Q?eoD8nLjOmSDabD2Krucd1ZsuWM6iVl6+UVNeNkJIt1L4O4lWLZ/h5KeD7K7A?=
 =?us-ascii?Q?Vq2WVWaCl/hbekO23ytv/9mplYIoRDUsXzq30v6Bunzj9dDPTFF2reNus3JD?=
 =?us-ascii?Q?iNb0zGzfeJLStHIBE8u5OwW76bllEbTblLtjFV0KFg9iRjzZ18bovSZx3ZxF?=
 =?us-ascii?Q?vnwAf41tTzsMwta9GWAW0CHsjFTedGUmf+p4UpCliR/zoVQE+lo6DD1gjf8R?=
 =?us-ascii?Q?7HNUZs99Fs9hcKsNdeNhrZu+faNMAPOmxu46+RSe2U4irBLEpNfsZ4Aw6hTn?=
 =?us-ascii?Q?bG0iGdq3tMCg60myRjrmUIeCNrgBbX1yP1IGIbMnRKt4Ra5pANWz1dxe1OR4?=
 =?us-ascii?Q?ndBb4Ta3uFr2UK/Xb9h+SAJJJOX1HMyFH608uAE1NTQtjVkcNxCcxV66ofND?=
 =?us-ascii?Q?rbnO+ikm/jINPRHfxtwkNOFwKJL5L/F78t0qBKa1O3I7+mEtuvHtLBCupG9a?=
 =?us-ascii?Q?lSZR8MxkWpec86XpT0wG1nitW4mWLiMHlH1MGv/Rprf/tLTNmnEfrjf+qqme?=
 =?us-ascii?Q?SlY7kPLOfi50Y8e6FPWo7kegIJkbYxJuxGf3ikIcntpJ0INhPIUG1+DAYJyu?=
 =?us-ascii?Q?wuq2uQ7vfo7AcEbsXxTCMF4Kcd/WiX1gmIyypH4SbDaaM6PH8VbEaOzFwPzK?=
 =?us-ascii?Q?C6tNhsSNMiZ45MHm7W3FjZlJBgDPZTRLB2wgUl90HFEiqoFGS5cJT1vBskJH?=
 =?us-ascii?Q?NuNwbDBeyIJZsRQasaXyQ0XBfKxWJDMwG/4ckKbH7jQ7V+/RQ2uH8UtDrcEZ?=
 =?us-ascii?Q?hVauwB9WJesWDPhDnWxr2wS0k10+9EYPLx67ZBXE2q7usxcQLQuzR5ckAfqM?=
 =?us-ascii?Q?XKBUbXFYp1Q5Suh0qQT+tDYjGmQTjrhR8bS/CfSa9vO13eZlbxCw1jwPIkpm?=
 =?us-ascii?Q?5xixhhfOcMyuF5z+Ph07cuJtm4SewonaQOpTNFF36wqo5alKqH+isN3NCqLo?=
 =?us-ascii?Q?VL5GO5Fz+g1WEvCfEGSoiq3A2cqnxAMCi4CGXuwciIa5dIB/Tex3nL1yhbE2?=
 =?us-ascii?Q?QFC9fZamcmYnugujZ8fAwzOLl+UMCez7zZzr3Hrg?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3b81c8a-6d8d-4678-fc65-08dad2c3c824
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB2939.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 11:12:34.8731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ih/pEyR/JyA7Fl6PcTiGO5ADKk6B16R6pO/CcZJjpSF0s6RhDCUmH57cRfUAYyPlZHkxDGoPQdAlz5+YkTHHbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6783
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
The issue description is in the commit message.
This patchset currently looks more like a workaround.
I haven't found a better way to fix it yet. Any suggestions/solutions would
be appreciated.

Thanks.

Clark Wang (2):
  net: phylink: add sync flag mac_ready to fix resume issue with WoL
    enabled
  net: stmmac: synchronize status with phylink via flag during
    suspend/resume

 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  2 ++
 drivers/net/phy/phylink.c                     | 36 +++++++++++++++++++
 include/linux/phylink.h                       |  2 ++
 3 files changed, 40 insertions(+)

-- 
2.34.1

