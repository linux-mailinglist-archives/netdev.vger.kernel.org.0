Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69DD16BF129
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 19:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbjCQSzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 14:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjCQSy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 14:54:59 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2108.outbound.protection.outlook.com [40.107.243.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB1831BF2;
        Fri, 17 Mar 2023 11:54:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJLHl/y/ooe+fbMvW5U1G2Okcb+kKuHYZ4E9rMWqCdFupjKGdxAX/JDGufmcY465v4MM4fEbL/NVitykpJd1/3VzuAmevb+t5tvGmg8uXQl+kyO5PuMLCwe2w5ct5YNlXgPo3fZcbDFlDlQNVoGLjcz410l6Zq6ok7Iv8A+4fFMox2mTYeri3KJKzHNOntbTKCugoJMdsRgJf27vFYtBQsdXcH2kqhiNOjciCUgtMjvGEJnJsd3QtdoAK6lTd1dDKL031kF4/qmDgDk3uSYYIBjlddfUClmjIUZ1c8UIvDIjSyRsepSrxvMRqekjgjIfgqo9oRjE64V5ouYzp4BdIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xfnS5P3qdu7uR1iM6c8Tsq5jTS46ptug4GqRB2JXMtw=;
 b=XU8WsjdZmvaznYrq8TXCrExx/j4xF1drxISzdDB2BcxyKDmpT7quWccoqGhglwMweUWMpiwtpb2pxTzXCKHnMjOmYHDMscNxOPapW0z5n0hvdPCrK9A4NTgHfSqzKWFBAetizrmVQB0FOEw/Lan+m6qLP+3Vj+N+OyfbCvi2KX5r7nPKsrACzMXf4uB/B05bg1P4dcs4zkoiPHkZzqkQ5rx5Bm2poOb7OGL9oSaahELpCGptJdh8Nf5ygVmmylYIzIJ5pxM1nB/kfD14rAzCNZeeUc3saqFn6gTKFtU2/+dZx9fwFT4Iz3jeBZxkPJNbzKdm+vve3m6SQkvakMVqSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xfnS5P3qdu7uR1iM6c8Tsq5jTS46ptug4GqRB2JXMtw=;
 b=zxTbIabgv4tqUotK8gzpmiAJyGvE9kgYmoXJmRsf+hZFQT0WfNVDFgnB5ITCAquOLNzibwjCx3qFKbiEBl8ixCxnUtdpui6uaPfxW40gGUXHR1+83NUhTjyz3rHFTzZWH+1+eNY4QyiCzWjEpaWL28CBtdfjvSllSD1IJKR2m+Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MN0PR10MB5959.namprd10.prod.outlook.com
 (2603:10b6:208:3cd::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Fri, 17 Mar
 2023 18:54:31 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 18:54:31 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: [PATCH v2 net-next 2/9] mfd: ocelot: add ocelot-serdes capability
Date:   Fri, 17 Mar 2023 11:54:08 -0700
Message-Id: <20230317185415.2000564-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230317185415.2000564-1-colin.foster@in-advantage.com>
References: <20230317185415.2000564-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::38) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|MN0PR10MB5959:EE_
X-MS-Office365-Filtering-Correlation-Id: fea970c1-b617-4293-472e-08db27190af3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8x72/k+HHdlXB1flU/zt4ZZNL2YkRZWuYGwa74L2nGWisw1tglbeOtFDg7mG/SHMzJpV9IlvMp/vBsU3K1ETeRzbznWQpChdXCi+RH2HzW5KZ/okDQeY6Ag0HOnefK03aZ6FAugTig9wpOWZAT0m8zHBAALc8grkFCn8Nc1NB52nUeo310pQU5qOqwt5WyHn+DUyhhzed+g+c269DkuLHoLyqCjJrEa0wJo8pZI7v/7ZoxY4xSMelauS7Oz7P34ZMf0HWNDvSb53DWne9wjXP7B3SrcHyQDHe2fCpUJNp+5V9HHEl4GOAlLXR4kxLOcSJy9sk2wrNQvodW+DMiZ6+rVHifQi7NQyHatqWJNK7s88rzGRqnYBPSjicKpD/1GNer53d0Rin0dy+JHGJd9rl6zs0rfiP1QX2bbYnB8f8fgbmzqs9/eoFHwPFtMnCP4WoR40S1d4usfuQjzrkz6JOyb8wbP4LF3YVZkzM3Gdo4mVNZ83ObzviRjH95yC8AKuJmUuxbQ65wt8h+EXWgKyevlN2wgkunLVSuJEHOQ8IggQiqqMkkybpFk7Rsc6dxJVARUF9z9XihuAuDrHrG6SS783qCzp/dKq3g1V0NFh6MdMN71u+vYS684WLvIlnCthP6kIRNtpLQtn8u2TNZRNuIPFHQn1BAdLHN6Vebs9RdekP4R3i4Xna6AMgPAjvAWDXf57ZLK3KvXc/WQ30S2RZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(376002)(39830400003)(136003)(366004)(451199018)(8676002)(86362001)(5660300002)(44832011)(7416002)(478600001)(66946007)(66556008)(2616005)(52116002)(186003)(38350700002)(6486002)(6666004)(2906002)(6512007)(1076003)(6506007)(26005)(36756003)(66476007)(38100700002)(316002)(41300700001)(54906003)(8936002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+iROkzIQtIduCc2fXbwocyTVEwUVjaZwlqClhpH3x1rIwaZlckGDqKiLjQWf?=
 =?us-ascii?Q?bu1+eh7d06QVp1mmVHq6EA01kTzqWy49fWU0ogTpkyoGhuOp1WT+01V86hHp?=
 =?us-ascii?Q?Gf0e4EfolnPNWAWkISXN5c0vhY7RBnzaHuvg2Cbsuyp01PFrxQS+m4hBNXjX?=
 =?us-ascii?Q?JIyYv/cq7y/8/EnDGDKe5S1fl9aR65I8uJ5Mq5BDs8TpnGS4i9IMysi/1hUN?=
 =?us-ascii?Q?5cKurztEIYYf9gVVYYUbR33B4hB9InuofyKCbzN1Cecl+b0XeShCLU0P5f35?=
 =?us-ascii?Q?pJFk0UKEkudtwvCZHkhx5rcp7FLnVHraRv6Z54d1Z+VLBCg7mmAaGYtcxCxb?=
 =?us-ascii?Q?Djm2dqBzPOVXd+y0B8ne3V6g9a40wWvRp+obimWBxFgcb5npIX8RvTRqPyNf?=
 =?us-ascii?Q?MBW28PIn0MIoIVsHWUhG5hUyRhcwiZn2bDdI4eWP333z13mmhgqyYJOUxIg/?=
 =?us-ascii?Q?Ut95pEwOxKbuaktUU+/FV5ZfMPLi6ODykXU9KVETWllHgP0UO0FJ34MafT8f?=
 =?us-ascii?Q?BEijXwzfxVU/QlfXtC/8SfJGEI98ECRh+iSrDA8Q1BwU7ncoj9PcwwFU1vot?=
 =?us-ascii?Q?6a5dFboEmA+pQRPbhZ8elKt1nLEGM/0zMY+XQ1W13aSpePpqngUsVpfr29JO?=
 =?us-ascii?Q?mQglQ3dLo4Mmv6Uuob/0tTk06rNhWKZuqHe4pLdsVdhkLU6S43PXtCLaMU3x?=
 =?us-ascii?Q?GY2MJlsYChm9PQErKfnYi/MivD9dlSf5CE5yx0GTdm4uFNUTuoMs2M12ZxRq?=
 =?us-ascii?Q?MC9Zoez963svxmQf8nPmXQzcZnyFxD0+cM9QMU5KzVBOlu6wrM4ozlZI049d?=
 =?us-ascii?Q?tdobnCqCy/vktgjTMr0zjx2eaG+tEE9KpoVrvOVkpQE3/WxRHMl72SEthTUD?=
 =?us-ascii?Q?XnL2YOqCFllNl9E9DNAa7QzcLlNjulytuDaWvLwaxOOmUDTrci3ws/FURNkd?=
 =?us-ascii?Q?KU+HjMBp+YO5IQQDFsnn9J2yk2RaP9bS6v/dFncr08Ays3bkE1G98eKJejdK?=
 =?us-ascii?Q?mB3kicXgcGlePnuvsztA0kA+RvVAgK7XkPkB+Kqx93Oxr8qtkExGmwiWExLz?=
 =?us-ascii?Q?6fbCY0r2WsY3ogYbtGzbXrbVPT0k4c9KEYGeDnrP6fMGj9FY0S3LW6chXDfO?=
 =?us-ascii?Q?ssjti4Beu3qjf5NKGNp/o+n8vF6+qYaqovMPIz/aZTt0fHSFNSMVeZcMlAjP?=
 =?us-ascii?Q?Vna7wOPGhqo00RLobOvX+DGa50YP+2DizFqc0788403NwJmEzEO3jdoivFVb?=
 =?us-ascii?Q?pMx5eIq+9Ed40LJnzQNZo4WOmaukQEecIumditvfyEvSSPKMNrKczq1azJcz?=
 =?us-ascii?Q?ZuNznmyGticfuNGrr2w5fZb+Yt5TGmi3JojzcHJdsiJyCQd9ziG/H/ydolEr?=
 =?us-ascii?Q?N6qinUbt76L+f5x0lrwIUM/y7VbP3zYJrqb2Gg0J5F5b3TsY4IUjUBNJnKQW?=
 =?us-ascii?Q?vzAZNgyYyuuZCBBjfpZ1tN6wmXqzgs0e6gMH5qBVgWZglSuXifdmHXN67aqR?=
 =?us-ascii?Q?XKIh3vK7fAIAQYsuI99Owm+uLIUYhIYMu7bczx2P3536S42+y+fnzdrWZnwq?=
 =?us-ascii?Q?Pk43hS3TeTRjF1g3tySSMIvYCukmeXBDyB4Upg9ipcFDydrrJuOLyKyjhdCW?=
 =?us-ascii?Q?NDNPqF/XDCAF8fh2kkui5nE=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fea970c1-b617-4293-472e-08db27190af3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 18:54:31.6157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2mmKN9qBWZ1fATCiW8xv3+VhlHIyWRn5EOenkAMK5Y0iY1Ru4p8L90T0KMMUca4ZCvDqbL78vMlvmJQ5g/g6m/jkQ3sYU1NrR5vSC+DiUNU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5959
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the Ocelot SERDES module to support functionality of all
non-internal phy ports.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v1 -> v2
    * No change

---
 drivers/mfd/ocelot-core.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
index e1772ff00cad..9cccf54fc9c8 100644
--- a/drivers/mfd/ocelot-core.c
+++ b/drivers/mfd/ocelot-core.c
@@ -45,6 +45,9 @@
 #define VSC7512_SIO_CTRL_RES_START	0x710700f8
 #define VSC7512_SIO_CTRL_RES_SIZE	0x00000100
 
+#define VSC7512_HSIO_RES_START		0x710d0000
+#define VSC7512_HSIO_RES_SIZE		0x00000128
+
 #define VSC7512_ANA_RES_START		0x71880000
 #define VSC7512_ANA_RES_SIZE		0x00010000
 
@@ -129,8 +132,13 @@ static const struct resource vsc7512_sgpio_resources[] = {
 	DEFINE_RES_REG_NAMED(VSC7512_SIO_CTRL_RES_START, VSC7512_SIO_CTRL_RES_SIZE, "gcb_sio"),
 };
 
+static const struct resource vsc7512_serdes_resources[] = {
+	DEFINE_RES_REG_NAMED(VSC7512_HSIO_RES_START, VSC7512_HSIO_RES_SIZE, "hsio"),
+};
+
 static const struct resource vsc7512_switch_resources[] = {
 	DEFINE_RES_REG_NAMED(VSC7512_ANA_RES_START, VSC7512_ANA_RES_SIZE, "ana"),
+	DEFINE_RES_REG_NAMED(VSC7512_HSIO_RES_START, VSC7512_HSIO_RES_SIZE, "hsio"),
 	DEFINE_RES_REG_NAMED(VSC7512_QS_RES_START, VSC7512_QS_RES_SIZE, "qs"),
 	DEFINE_RES_REG_NAMED(VSC7512_QSYS_RES_START, VSC7512_QSYS_RES_SIZE, "qsys"),
 	DEFINE_RES_REG_NAMED(VSC7512_REW_RES_START, VSC7512_REW_RES_SIZE, "rew"),
@@ -176,6 +184,11 @@ static const struct mfd_cell vsc7512_devs[] = {
 		.use_of_reg = true,
 		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
 		.resources = vsc7512_miim1_resources,
+	}, {
+		.name = "ocelot-serdes",
+		.of_compatible = "mscc,vsc7514-serdes",
+		.num_resources = ARRAY_SIZE(vsc7512_serdes_resources),
+		.resources = vsc7512_serdes_resources,
 	}, {
 		.name = "ocelot-ext-switch",
 		.of_compatible = "mscc,vsc7512-switch",
-- 
2.25.1

