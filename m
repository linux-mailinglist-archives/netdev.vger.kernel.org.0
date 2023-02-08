Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7772568ECB7
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 11:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjBHKXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 05:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBHKXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 05:23:36 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2129.outbound.protection.outlook.com [40.107.220.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5693B3F7
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 02:23:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CzgDoEItGjkmIPU7MpEuoFb31V0TvvOR9esBnrJwUdYu80L1FTW3EgP/CjyZeI/8BHZNxY7s5DIBqnnWRbh1u9Yr8SSgpd/thNispUCFlwDeAzDH7O+AncUAmXAW83+xVaYi5Ay8fzy8l7Te1pq/5jIdk1vw2NFJfNq9CkHDKl4ioIGlFwcyWGIYGaswrhnewtr1mBUfYXUcKbfsczJrFiqDAP6lq8OKmwc4t3kGgW338ZZTbznyN1Ci2czDsC03FdnSdXrI39frgvmA80MnvljtEiUhbfl7R6iry0+drMMxTa118HL1HFmuM43DRYy+TROWSmOi50p0y0xPvcvbTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a2Lub7fpcsTZXY8lbbzH1zglVh5eOBHIFHoyDow+Euw=;
 b=m/IHQM61mtCxk0+hb34MtzQL+3KuavrB2pB6mm+Mz/GRsZ/vhk0GzLqsNEFRsqqN7awRvOFlE2zWW1kWiVQJ8T7qpkAPBT7obs4yOf1MJslJbjhxirnWqw8jlpxCI47QnQbY5hrxapG1K5y63uez81BUX/kJVw/Ffjs9K+HUi6FoXVWytPtcweJ3FZxs0JewFeT1yP/GpOmNeHoTZVT9ffckj6rnK89Yf9p2kCTMkNwDD6HU6A41F7dHz2AMy6qONXGjOLKx4VHBu4MpX4hchQz34Rkd8VSa/dexQj8eRm/G0tnjt/sWjWPZRaeee19E2uXSBNNN6sEq8iCYLHv9/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a2Lub7fpcsTZXY8lbbzH1zglVh5eOBHIFHoyDow+Euw=;
 b=Qci4WcICmm3HoI47ipom8+Q2rykbZ9vt4WFzfjSrP6tibZDtOA3ToUq9UoMSfiDAps0grhhmHzNMc4LNPlEbyfg6u1UCsxOYASrL1pJUhRrydk+3d/ocS8qtjP8uBOdhPtT/zr55a12RXOzskFZCpGCWx0X1ZoANc3uU5mQWKCs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5761.namprd13.prod.outlook.com (2603:10b6:510:118::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Wed, 8 Feb
 2023 10:23:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 10:23:30 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Leon Romanovsky <leon@kernel.org>,
        Chentian Liu <chengtian.liu@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net 1/2] nfp: fix incorrect use of mbox in IPsec code
Date:   Wed,  8 Feb 2023 11:22:57 +0100
Message-Id: <20230208102258.29639-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230208102258.29639-1-simon.horman@corigine.com>
References: <20230208102258.29639-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P251CA0008.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5761:EE_
X-MS-Office365-Filtering-Correlation-Id: 996e8f9f-77a5-47dc-44fa-08db09be8641
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wHLqHSoIWD+fvggZ6nMFS3dBlc58b+SYJyvQuKdIR3HYu6h5dhg2ShToMPCA4kuWjPw1wTh9L4QJCfRI514ftEki7NMeRb50MkX1MjJhy6L6BcDNj/emarh7Bcp8BhYO1XEl4V2YP15j6GFimzWkzeR/YxxnoxMTB//5ViMFgqgBwkevxPlFZdEVIksiRF7okFy474cb5vl00DAk7McrprxFTL/UspNyWeyuhZB5rZGB6pPrRjcGm29gglSpku9Yuj5IoUfQtyPhZY055nZT4zCSMWtfF6cRJ9i48cEGDWyg+K/1enbH6ftHV7a7Q6i9EJ36vpcYF6Vp0Yv5oBa3CqA9KQmko8d/CJrV5DcAyM1/CDtZi1IRc2gzjBIAl1MdbK6kPY75BJ2MGMPg+fhPaeC2wfg/axZQi0aTtpnXm30SAAdNoJ1+GhvifZyMZo/Xr9yH4gw2i3RA+BbxdQvsswLLBTD7Ci5aqFaTxTZ+iWIARR3QmWMLFHTx5n2cc8t9CE7ATg2+IEF7r1r7K2PVf4KaO7soOvyhaYgIxNifIYrLaASvqqDD7LAoJIveYXmGzBxfh7fTghf9xfj7r+l4Xi8DSFw0uzqOYO+pQQ+Z2eE9p6cfiE5WjkighPjgsrCX0OwVWAi8kRuIg8qzu83N9+78x4W+wxOZKI5hXCTvmMvcReLpdyR9ybeZXP+PJQPF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(396003)(346002)(39840400004)(376002)(451199018)(86362001)(66476007)(66556008)(66946007)(186003)(2906002)(2616005)(52116002)(107886003)(54906003)(316002)(36756003)(6666004)(6486002)(110136005)(6512007)(41300700001)(44832011)(4326008)(478600001)(8676002)(38100700002)(8936002)(83380400001)(5660300002)(1076003)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M4SK9+0QmOKRZJjN0iN9HjMYPBUq3UQ9k+UN9DcXmXuPsFwz2oamme+6idK3?=
 =?us-ascii?Q?Fbpjf9ewdLUI1lHu+6ViNALUmgGh1u34XSde9CwHlVAXSLsneUgBa+kLgQsv?=
 =?us-ascii?Q?4DEvcoJE68Mz7eq9dmF2eBGlFMihlVGG/X5/rND5KFaDacYDUgke2rS7ldcn?=
 =?us-ascii?Q?rHGjwXDMqSivNU9oZOoc6RimLtVMpSXeLLnleilkMlMS2g+uY78KkrSlDCd9?=
 =?us-ascii?Q?ivGwdQNW7rTiZbZjk3vcpwmW329oJIbvwvncn6pNaUk6THKAxjnLdaccfKVz?=
 =?us-ascii?Q?8rOQUHTto6wci5nNgTSE8wDayVAZvKdIJbWvtN1ytzK0p4JkJQYq+vayoWVo?=
 =?us-ascii?Q?H0AoiZFXbEjLN5x2okzcE7bjt/wUrx6TvoGbAOdKJoJi/DCzEx2dFgJLc819?=
 =?us-ascii?Q?HCObfteyklxDe0TTPYjwUqri4z7aT2OkyOQi1qIAS7Qp4KlU+oHXKMLm11+d?=
 =?us-ascii?Q?Y1nfe2IKQ1l5OEUXmUKZIfWhFzvs13r73MRSb7Rk4a1/hFXmaxhWpiGXnY4x?=
 =?us-ascii?Q?sCnMMpuYXOig7z0p7zcPwmbL5hOyUjeIljhvyI1zlPbKzh83vriv03g9NCzG?=
 =?us-ascii?Q?w9XL8Si9niSGNrejcVGp93gkQm/C3K72rWEScUNL/+s+/JwMNvMVoKCA6bTN?=
 =?us-ascii?Q?3frH64cSExscRq5pMG9ZXagieTLNvBROFDLyti5Yyevxgpm/H9D3qb5PUPnr?=
 =?us-ascii?Q?DlaUH/pIy3NzbYb64nhx+ROag9MQiaT1uQSW3DEfemQ1TdjA0Ta6C+N4dx+V?=
 =?us-ascii?Q?M8ehhx3XziF1DLldAl564EH08H5CpI53KZF2ARXul+rRcfQfBsjXmLygTBDv?=
 =?us-ascii?Q?QEY5WX8z5nKseUe+VZQUDLBuz1p3Acn1dR1ZmWAZ0AJ5hdABBtEp9yRslioo?=
 =?us-ascii?Q?1PraQ0gZ7cQsS/IuGIgROziPud2dAdwwKWeGxwNqqy/0dks7zd0tQJcz8Ahd?=
 =?us-ascii?Q?81QstnQeVlW0WeAM1yT/AlTsvd9gWcF5dA/INEK7A9HsKa8Co1lxCvU8s7kS?=
 =?us-ascii?Q?KaehY2QjbXvxQ6P758cQBZ9iGGFyWkLXK0TCcDxPGCFr+pfzSgUlZ9AKXeO2?=
 =?us-ascii?Q?nksSsF4o8vxcrv0tOxeDqge/X24uBz0NjWuIoGc4aDxELLqDMIHkaH5yh5R7?=
 =?us-ascii?Q?1ITevbUJz9sX1K1xh5Ka1uBqgNl2Zif2T+KJqNdpd1Ho0kYZ4Mv9OF+wgUx1?=
 =?us-ascii?Q?ETK0auMZhO7M9WvHiRH7YJeOc0Idg7AZxlGmBip9mluWarsB/Ti/N3m2BQTp?=
 =?us-ascii?Q?Eg0fQ3cG2ZLNpXhG1fDcmBXW3S4Dvnl8CR9GG1t0g7iHjKe6JXCHD3ljXuOR?=
 =?us-ascii?Q?UooN0z/M4ArOLX84y4EbFH3H+DIOHGdxSJdUO0orUDP618fjcpj789Y9ssks?=
 =?us-ascii?Q?Rra/3x7YmzuhahazuqmmFSVo71sCftgARvAlGjegbt3O4+yC3B23j75Ltu68?=
 =?us-ascii?Q?U3RKi8Nw+v1Qm2Hj5Fbc68IUYyi5zDctEy08EW2bMmscVwVwgG4VXmzotx+f?=
 =?us-ascii?Q?O6llhSCOobtuRHsx4QxBikEM5oPPWIwa/gkVwj2dgIPoHtMrj3u8bDijixOn?=
 =?us-ascii?Q?5H/4tmvXb5xCP43lBIy9H/AwN2PM0KKM9XOVFaGxJqGAx53gLl3FXdjnKmFy?=
 =?us-ascii?Q?Mv8evnr3tI3EVEpxPkHwrNSVmOiSIS1u5/RzTyBSvkcBP59lyHTW7Uj+qdNX?=
 =?us-ascii?Q?Y2OcUQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 996e8f9f-77a5-47dc-44fa-08db09be8641
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 10:23:30.5792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /imxdfTsZH3J+FSgQ/+qJj9slC04JwDl8kMZ9a5/WHHoq18qpUP4lRjeHlgF+wbsqWJJPZ3LpU7l6vDHZn5p7JAUxJeKy3ZchIm4kXhtrYc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5761
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

The mailbox configuration mechanism requires writing several registers,
which shouldn't be interrupted, so need lock to avoid race condition.

The base offset of mailbox configuration registers is not fixed, it
depends on TLV caps read from application firmware.

Fixes: 859a497fe80c ("nfp: implement xfrm callbacks and expose ipsec offload feature to upper layer")
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/crypto/ipsec.c | 15 ++++++++++++---
 drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h |  1 -
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
index 4632268695cb..6d9d1c89ae6a 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
@@ -132,23 +132,32 @@ struct nfp_ipsec_cfg_mssg {
 static int nfp_ipsec_cfg_cmd_issue(struct nfp_net *nn, int type, int saidx,
 				   struct nfp_ipsec_cfg_mssg *msg)
 {
+	unsigned int offset = nn->tlv_caps.mbox_off + NFP_NET_CFG_MBOX_SIMPLE_VAL;
 	int i, msg_size, ret;
 
+	ret = nfp_net_mbox_lock(nn, sizeof(*msg));
+	if (ret)
+		return ret;
+
 	msg->cmd = type;
 	msg->sa_idx = saidx;
 	msg->rsp = 0;
 	msg_size = ARRAY_SIZE(msg->raw);
 
 	for (i = 0; i < msg_size; i++)
-		nn_writel(nn, NFP_NET_CFG_MBOX_VAL + 4 * i, msg->raw[i]);
+		nn_writel(nn, offset + 4 * i, msg->raw[i]);
 
 	ret = nfp_net_mbox_reconfig(nn, NFP_NET_CFG_MBOX_CMD_IPSEC);
-	if (ret < 0)
+	if (ret < 0) {
+		nn_ctrl_bar_unlock(nn);
 		return ret;
+	}
 
 	/* For now we always read the whole message response back */
 	for (i = 0; i < msg_size; i++)
-		msg->raw[i] = nn_readl(nn, NFP_NET_CFG_MBOX_VAL + 4 * i);
+		msg->raw[i] = nn_readl(nn, offset + 4 * i);
+
+	nn_ctrl_bar_unlock(nn);
 
 	switch (msg->rsp) {
 	case NFP_IPSEC_CFG_MSSG_OK:
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index 51124309ae1f..f03dcadff738 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -403,7 +403,6 @@
  */
 #define NFP_NET_CFG_MBOX_BASE		0x1800
 #define NFP_NET_CFG_MBOX_VAL_MAX_SZ	0x1F8
-#define NFP_NET_CFG_MBOX_VAL		0x1808
 #define NFP_NET_CFG_MBOX_SIMPLE_CMD	0x0
 #define NFP_NET_CFG_MBOX_SIMPLE_RET	0x4
 #define NFP_NET_CFG_MBOX_SIMPLE_VAL	0x8
-- 
2.30.2

