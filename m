Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1346A402773
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 12:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343672AbhIGK6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 06:58:13 -0400
Received: from mail-db8eur05on2055.outbound.protection.outlook.com ([40.107.20.55]:10592
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240533AbhIGK6M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 06:58:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bEgzrthW9qGtjwmRFU3XuDgyil/JL4Z+3d/5DK5131KMa+88JdYzDd63qGCz6A8t+HDxTFrgwDEeALJ4TeuJma85WmaX5pd/EEp+mcQnPygx2g+W7pBF1BL+nsMTLMhasmqUWkNtcKwGGc0IujhMTbDHjVP/eHD+RzFrTeOWtuIUE2HJoM5SFq10gSBTBa8q/l8KibKxZJBOZUHRdHoS9QLafYtvLyYXRyMzSRU6bqsBz8gh9CepGaPs1WhaXV14NlPVXQ1WZpOWBo56sED8Y04bhSMyr4+W4t0vVKo/MW7Zxw9UzPZigq6HeJrHM/AxX+nsA6koRV8VzzmA17A18Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ihMEpTgPfqNJ/QiSV4Ax3ZDpZaQadTYWuu1b1Llkt48=;
 b=C1W+YoKs5kGwqAZIMK6PnhSUTAIkvenRcUvJVW4N8c2VASKVPVDxMnDVC2h9zmVjkyI43SPVIF2jojubgzyLt+S+eCzNU+uQC6RLSh6RKi27zF80+ZL/rHAUvN7X7bXpdFiS5Zs4wm03DEMmTyPGO2I1J4Kr2BTjL2mzniZ13OM6kbG8kuZhzYduEHcqy6+h46nKeHqFcm/n+/BXnxQsJLhLg+NHGtlUkr4Au2dOVEYa5J1r6Mh2N88VBBoU5wydixrAZ67+fFt/wIUHZc+if3HmS4cfuehfg2GcdcVZlMNOpPKv/Sk9QAtSgwvb3KMj3Brawy6sjLAViYBg4/FWjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ihMEpTgPfqNJ/QiSV4Ax3ZDpZaQadTYWuu1b1Llkt48=;
 b=kzdwyQOP2UgKhNMOPoDZ1MkRkYgfC2m/rikvaeJOzFrWqSxzY9c+hOTRu7Joc9gvzad3KTAWwHC6N+DNWlbPkA4LCOeMm94px9dBF5zmuGlhsHgVOrS8End9QAo3E960HJ6aJqNfoWfI7cq1hgd3zbrqcRNNtdXTxYTgoEtS9T8=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7382.eurprd04.prod.outlook.com (2603:10a6:10:1ab::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22; Tue, 7 Sep
 2021 10:57:04 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::5d5a:30b0:2bc2:312f]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::5d5a:30b0:2bc2:312f%9]) with mapi id 15.20.4500.014; Tue, 7 Sep 2021
 10:57:04 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, linux@armlinux.org.uk, andrew@lunn.ch,
        hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH net 0/2] net: stmmac: fix WoL issue
Date:   Tue,  7 Sep 2021 18:56:45 +0800
Message-Id: <20210907105647.16068-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0001.APCP153.PROD.OUTLOOK.COM (2603:1096:4:140::7)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SI2P153CA0001.APCP153.PROD.OUTLOOK.COM (2603:1096:4:140::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.1 via Frontend Transport; Tue, 7 Sep 2021 10:57:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d361e2d7-05c5-4b37-dc7d-08d971ee3a34
X-MS-TrafficTypeDiagnostic: DBAPR04MB7382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7382E6EF7A7BBAEF01102182E6D39@DBAPR04MB7382.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ge3K/Q73RQyDMFrmXF2cCGDpyc9L+NbYgv0LZIfAZ/88A4B2xkizxU/bzqiXVzG2zz0QH1s7gHZnq8uwkErkh2ytz54FIpHTelx0icalFpXS3VJKCiSElPgyZUXk9Ex55+HCFHixPpw3vWJ6wTYFvQwILfTzR+QBSFMtm0BK/YbtVqp0z9BHjo9FpQ2JEy1/8XDrRgLJyC02G+ilLQRbkzNZbCCkqGbgvvzEX/ERuNB8/Zf8G/zUAoStMIIQPmARKcj0CZtoqeNBs5IVFcM1Q1UPX8ECnEKPyDYqlwyUfDGyt83jqFbjDGYEKDP14A6FAnQlvwqoMMLZezP720WVH2ZOVpU1ILC4Xfy+koc1VUw9jJXppvx4pLOVBGzM5/5VEpnrHiL5fSWobY6753goxG0YiAqMgdYM4GFKUES45q9VUz/DJ21P4Ql3+HzERXsjkmB9ifJ8nJg/SNQ92tr+WZtrMYJPQo1y+p+xu7+qqVpKnj5WF0iSB8yhVPVDTV1nsz0cYgXi3sX3sVfr1S62W7Tt4l6OE7Rm/nvpzQEqJ4l49eb1Dj53q9xDtkP5aJMj5Qydd0cCQuvIwgQ4Nd3cmsVVOWlIaiZHTz/1ocNeeCU325gVfBlZm67ZQd0o1cyiGwVmIJtFOae9YMVAt5YJNXeu61JGuZBYcRsZbIl68+Q75YOb2O7V2s/c8p6RlLm27XcsYyA9t07AxV8kZD6vSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(366004)(396003)(136003)(1076003)(316002)(186003)(52116002)(4744005)(8936002)(38100700002)(5660300002)(36756003)(38350700002)(26005)(66946007)(86362001)(4326008)(2616005)(956004)(2906002)(6512007)(6486002)(7416002)(6666004)(83380400001)(6506007)(66476007)(478600001)(66556008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ufENGGpAQVqEBkaTC8PtUo5FU1jvESP3ndIEETlSEb+XZ51Cavk0dpEKrSXZ?=
 =?us-ascii?Q?4lFSQNc9IfNenUw6/Sig3vLR1v3hXh+26BY4ZRQg28uTRYNN83lTT2g8oQF3?=
 =?us-ascii?Q?e+7Jqxblou1XIG02hEBf5xzWrRRuAU32oODxKDT6b0QxzCwmsjUKfT73fjJL?=
 =?us-ascii?Q?zt9OxmOlzuaB/xB5f+agB4ML2arL7gkQMGk3coZHyi905f+dZ0KhBqC6qOHR?=
 =?us-ascii?Q?OyHcLgEwiwIckRaBij5Wbe7fJIJP8RTYPmhs/7oLSDTg1HsG7Ic0nr1CJD6t?=
 =?us-ascii?Q?nTRt68Ruu9N+1jaympB2ZkxVhrfZTiHqSXTWpAtdO2h9IqHKc1MlBNUq9cw+?=
 =?us-ascii?Q?yMKyDEH5WRHxpyOoovcJ4kcnrF59L49dgHLljRSCxyGJr8SFQVi8nnzsvMlW?=
 =?us-ascii?Q?CHsTAtWDQ1i7ZTWUss+z5S6mDvGSKmnilM26ZPY/OQPv9UAv/dowAbf0UTEQ?=
 =?us-ascii?Q?hRtPVfaMgiGUQHm7ZrqpEkQwuJZWh5tPaT3Yt4/zJ4AeQpmCHgAP1firGqiz?=
 =?us-ascii?Q?EemTmUAcRNd+TI+SB3hXcOdzU/ozaihPEJWeacC0XWNN4zqm1MX4zSVvhfiU?=
 =?us-ascii?Q?Jjcu006o1x3MiLw4jjJp5TmC8Fu1aZLaQzDtFcJ0BCzYUmUDIsV1FJ+3aJpO?=
 =?us-ascii?Q?vHNdHp8Dbpagy5Pz3pcy5fUIrY5jf/CXF0kyhWEfsrH4Oj3zV1oUECZHgR5L?=
 =?us-ascii?Q?9rpiya7qtBilSShya86n7nMq6Z0y5wp3dUJXuBiIZJdNFkOtu8EqbMo1MFEh?=
 =?us-ascii?Q?6o2jbt65YDmUCZllmIR2V9XLNxYrFWJ8Vo4Xfh7SJKGl/oZLepZsRSaqs0Tt?=
 =?us-ascii?Q?n9LV9fB5/kiMt4CbL+/MhbBxepAbk77XqTmYX2wpu4wY/rfagmkzTmg5Xv+V?=
 =?us-ascii?Q?dKc6LCMjCIiDChkH9TPyOkEa7GdznJXcc6ZFViVeNMbuN/jQESlWVT3HwoSE?=
 =?us-ascii?Q?j/Je9r50Sh86X8hdpIH4kl3HQewHYNCgy9eNngd3kQrMqXqsfqeLObjoOdBI?=
 =?us-ascii?Q?xZs6S8RtaLZdXePJW/fYMeYc4iayFKCXv+DzvSDyKdFgtCw5q1JwO+yzkVed?=
 =?us-ascii?Q?f/FdlB3rt/f74QiMp1VJW81Ji/BQuIHUvqh25X2i5+RpJixSSfWzfkiWdt2L?=
 =?us-ascii?Q?1VAwvSo9JiOJQWH1BvQEI7DHKuvcBxl3WnzwDiKmhlsITRMlYDMM+NTQ4291?=
 =?us-ascii?Q?6rUTpWbNPJlJCHED9Iwol7Sol01Qt5gLj+J+0fL/19bvtVWeDJEPZuu8TBtA?=
 =?us-ascii?Q?uT1BCcIAyVALtnkA/eBBatYaastTcqfkC7V389OXVtwzJ3ZdYb7NBNdJZ7Wy?=
 =?us-ascii?Q?OAjZxEVjv1bCZ4a5sVC/s7nm?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d361e2d7-05c5-4b37-dc7d-08d971ee3a34
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 10:57:04.5967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3EMk4IlWGU0uCzW79ElALhJZ9nnT9ZPGgAm6SZeJkjywZiaFwqfCsKoEU0ScXTKY9kxKtn5VK3tDGZsvT2LQ/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7382
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set fixes stmmac not working after system resume back with WoL
active. Thanks a lot for Russell King keeps looking into this issue.

Joakim Zhang (1):
  net: stmmac: fix MAC not working when system resume back with WoL
    active

Russell King (Oracle) (1):
  net: phylink: add suspend/resume support

 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 36 ++++----
 drivers/net/phy/phylink.c                     | 82 +++++++++++++++++++
 include/linux/phylink.h                       |  3 +
 3 files changed, 103 insertions(+), 18 deletions(-)

-- 
2.17.1

