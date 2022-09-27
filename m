Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66EC05EBFB4
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 12:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbiI0K1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 06:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbiI0K1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 06:27:33 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2093.outbound.protection.outlook.com [40.107.243.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3267EA720C
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 03:27:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cPF3a6maludV5d8yMVfvrWdo1MH7Ut2V2Efb0EMGMWdK4mGQlzU/dpUZllu4RV9Q5cjADmY3O+N93FJqqHF/SYbvYSbnbD0Y1T0APV0eqd216226ds0ZLo/5ywW+yaboiMQF82oI4Tg6X+UHThTFk0Ymo79NOGW97TQf1uglKworhtgzUVrPr0ndtY6MDAYUaSJezf+YS4/vDV9041gf2Wdb8Wx50ekhWix5CeJ3a8bYtlCK15+U/sob8m1RLslXnl5HCkq44zAdgOwNEI1VPAdHRYPONbKloGkSJCgjuy/+vDnJ+KWKGgLJKoVnKu0JGh/nQ2hhkdavrWgJdgsbEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K0kPpHuVCJUV4i2xY0J4zeS+ay+dGBUDu66M36/i33s=;
 b=l1sLUOnQQe0WY/Lj2IEtPFGdleMxXn8idELY5VFQ7J/8uFnF7/fmL3TeIAZfjtkyWq9oop/9SepXoW+owMcfY/d+Kn46CUv6VQlR5o+2FDvbRHaPCVtXeaI1Zp4ui1oRE2rUcRwZxKERP4TnlPJyXM2eO1xkNkLXLq98UB1l7uNZpvUEZQgnNfkMu5NlhZRwCqutBKlVZSmlpxZXGd++LKI9anqAPtzP7PFRNzeWXStlQ7nE5N76lo6jcAIjZXCU4ZvmZC+MNcCnEEN51kjiZYacTuo3NS3kOtcZoqPv2m9BWt9zX1Kt4Df+Lf4XK6BgRVmD6CPyGXp1iksyPLvFRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K0kPpHuVCJUV4i2xY0J4zeS+ay+dGBUDu66M36/i33s=;
 b=dxgNT6wcPRKbAmtz09jgB5QO7TujowgsKa7EWw7CHipHDwaEQfsJacwRSBFtp8/m0FGCSH1Gwkrz56bnKXm92iwy4/9O01Bb0L2Jw4PNA/8keOgHgpyFRf0bU6eEK9qOaC3H3vrlNp4vj7bb+xyBzsLZ7uny3jhoEyM7BiCD0Ho=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB4150.namprd13.prod.outlook.com (2603:10b6:208:262::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.14; Tue, 27 Sep
 2022 10:27:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%5]) with mapi id 15.20.5676.011; Tue, 27 Sep 2022
 10:27:29 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Leon Romanovsky <leon@kernel.org>,
        Huanhuan Wang <huanhuan.wang@corigine.com>
Subject: [PATCH net-next v2 1/3] nfp: extend capability and control words
Date:   Tue, 27 Sep 2022 12:27:05 +0200
Message-Id: <20220927102707.479199-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220927102707.479199-1-simon.horman@corigine.com>
References: <20220927102707.479199-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P192CA0017.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB4150:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d5a633b-dae3-4d43-33da-08daa072e174
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5ga9QKLIk/bO1s/hT21OvpNdqdFZJg0uUAHn2xymzdCPEBFQ0thM6gRiVxh2Z1IySQbERO1Dqq9Ir8gIxYY+XxfIoghbJjQHg3v4icqRzRsDpvrdNPNcrS+oKxFfolomDThHPJ1VWIP8hrAe9/f42bSPfW6vrT8zLJFGiYx54+fyZFl6/dLsT9uka0Ln2Md9wa0BZmAcQRSigLg8aus1/gVxIj8Sq7kofDXV4AHZbkgDuu/nNt23lYA4iCvvMtOZDxs5crRlzOawk+k2uuiOjaS6/N8kV7Y7vWTWRHR3AJF52z6lzIsTuoUNjIMBM8cDzyZgYt9aNoNr90nKzWZqAhovPf1uLbrNqo3wfZCCqrsd6TCfncuVvRlg32/osKgg7lhPBPgYa0WIqTNmNtPIjWvalAVY9fVrOMbEZEXWOyTPF17r4bZ0gTSrjk0QgL08dl9KRBqzMVp0lhMEhYfMaO50U0WaUxOrCZWpJ6g0FdNAB0kW7cgVO2u2ppSWp2f0fD2FNgD8QcBeu6hn31ymYB3EEo3UwGhiJAi3i98X6hf3gnqFoX8uNenPPFgRT0HBcG1V4t0+/TlZx3NcL5jy6YqfuCO5tWLFMp8BwVUeDJFHz8cmnDl+1xMQppaHQ+HAA+/+PY3GV9K202QFniq193k128ZxrseYtgGbucjR9ViWmpffDzHecv6elQ9cgHrR/tJgDoGr3kqqJ3PbHeoUPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(366004)(39840400004)(451199015)(186003)(2906002)(36756003)(41300700001)(6666004)(44832011)(5660300002)(1076003)(6512007)(107886003)(8936002)(2616005)(6506007)(52116002)(38100700002)(83380400001)(86362001)(54906003)(6486002)(110136005)(478600001)(316002)(4326008)(8676002)(66556008)(66946007)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+vze/roZ8cN/Sk9OG3tAkhQI2CCuZRKEP4Dj9K826fd7MO537pZ1GkhC2atJ?=
 =?us-ascii?Q?fRADWko88GvgyoRZ+H/X2nPhn13VqdRd4/GGioOfn9jZKqOWr2QE4nHeMmMq?=
 =?us-ascii?Q?aPC1rTEZ62yozYtILoGy4tA8QBale379LYBpAC1YfrNvXrpCzXP7c7CcxOKt?=
 =?us-ascii?Q?SNpi1sCwZjq/+67/O7AkYM1faW1p60kU6B4/hh+IxqSa5fd0NPLonKPhjJAF?=
 =?us-ascii?Q?69AWJQZCOAlDieeg2O+bGPwOO3RP/IY1qkVhnvx0ZzUa2f62F1bv/On6179B?=
 =?us-ascii?Q?I+lPHunh7JRDywmHgCpfgmP2JlSp37M6ECSNJZQ6q2Ubl/waKv+jTWr0m3GX?=
 =?us-ascii?Q?rFbdCnRVfpMUiyl0VBQNcY/Efc+Oh9k4bGUfr2qpoWzTQx10V3UnLWQEuSJ3?=
 =?us-ascii?Q?tci+QHAwzCGBr8E5DkMBIa6JBt/2Rz6vwkMkzWkrjGxNlTekSto2l+cwheDm?=
 =?us-ascii?Q?2YxJgg3zPGrDbML57LbXrmVu109ZJbmxJFjfwdEKljg+mvBZ7wPHW6Ny45ee?=
 =?us-ascii?Q?CEgdJZ9KTCN/lwC3jSElLz7+bRSZZLwTb5KwBfPc/B9FJtbJssnbCRQZda4z?=
 =?us-ascii?Q?zQVOo8NwKOTpke/r9PBd5Y+VJ1PmI6quDwLqhaa9kOt8b5DF+JAZh/bpCF5Z?=
 =?us-ascii?Q?lIdFuXvzrzy0bNVpEz8XtBxk0xFDxIJSpbFmiBGYezMmY8kUbJKnuoGOIddR?=
 =?us-ascii?Q?SBsLSVo2rPURoQvyEf9yXgD3aCtnCvR8tZ+Z0lgtiMT8fbDHN/p7Fw/Q375W?=
 =?us-ascii?Q?bhGEBJ9+GpI3gPWh/Im53y1W1sfxeK8Ta671XffWHk8tDBW+jYwNQCz/iwYh?=
 =?us-ascii?Q?7DLx6gpJFgIV3LVpbI6f/ZySPZuM+IhZYvwWU0JdSo9bxmFnkFE6UylMSaOJ?=
 =?us-ascii?Q?+tefTY45MvjXtJb0UeKJD+dnkwRNcxmFCT4mt/NFMelekV2CMllLu0BJuO6N?=
 =?us-ascii?Q?iXEzfLtOxN9Avtvp0LGLigKReZKvW3TmGKNujm9YIQBfj+h7gbRPR4UczrdG?=
 =?us-ascii?Q?OjmRQUKCJLpXXjwconrwhp2U35fJ1jMxaA5xNkaPiWyrZaKTwLdcePWOgjc2?=
 =?us-ascii?Q?ZK2aQ6odj5hTmZTzzEPDXL5/tsCWxvqKShmEFN26nwaAyHCGlk4chs276AHi?=
 =?us-ascii?Q?TcY77LasqSQSK3Ma0DAeszlYd9k4n/d+Y0Bv5bLUHoAJtCJyqWr0mt+HznSE?=
 =?us-ascii?Q?dI8EB8zuKeyc0lSWknr017fd8a79oVxttegAGPPGVuPrzLBgfspzrRyMvPU4?=
 =?us-ascii?Q?mf8wbGhf0r/8bDRkNnrRQSIWnbYuf+kA05FhvNtgUEJ5hy5D2c7EWuK2NEIC?=
 =?us-ascii?Q?+LXdoUgFM045XQY6mhJn+gaycm/b5sekIOBn+yN1/udgT8DSkh+TMYXVhO4G?=
 =?us-ascii?Q?+OmWobjkI/arVxVp3isWvYuGKW6BVecQp1O5MkphcvSPYoZ34jYog4dRvakC?=
 =?us-ascii?Q?80NfxnKSwRbWEt16C5Oa/UG8NydEiU3KPryP8viLe6aqV2D6Sr3wfsycP0jl?=
 =?us-ascii?Q?GXi++GtT8Cri5BAvMKh02ck9TYoJhsD/n+jhR9dMiFqGEMHtZrBleZFUSMbZ?=
 =?us-ascii?Q?gz5E4/tHigSYcqHjpTeUWFygAuhtGN+sCdXztlDwIRpT4LDZ4IDu2Z6Hoao3?=
 =?us-ascii?Q?4NhpdOBRxIlqfM2YnA/BHwn6f4diy83MZpwqyGNU+JHcTnBvVwbUOxSbcVOg?=
 =?us-ascii?Q?nJQokw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d5a633b-dae3-4d43-33da-08daa072e174
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 10:27:29.6644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B3yWGB6Pd81PzhmJjOsXKWMwCpLsUnoUeSl+ZcT8zA/XK73fBHGaift4R1njZu7OuoEerUHJibFtzxEyszkJts/2bDzvGYRiHd6R7MFfACE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4150
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

Currently the 32-bit capability word is almost exhausted, now
allocate some more words to support new features, and control
word is also extended accordingly. Packet-type offloading is
implemented in NIC application firmware, but it's not used in
kernel driver, so reserve this bit here in case it's redefined
for other use.

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net.h       |  2 ++
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |  1 +
 drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h  | 14 +++++++++++---
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index a101ff30a1ae..0c3e7e2f856d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -541,6 +541,7 @@ struct nfp_net_dp {
  * @id:			vNIC id within the PF (0 for VFs)
  * @fw_ver:		Firmware version
  * @cap:                Capabilities advertised by the Firmware
+ * @cap_w1:             Extended capabilities word advertised by the Firmware
  * @max_mtu:            Maximum support MTU advertised by the Firmware
  * @rss_hfunc:		RSS selected hash function
  * @rss_cfg:            RSS configuration
@@ -617,6 +618,7 @@ struct nfp_net {
 	u32 id;
 
 	u32 cap;
+	u32 cap_w1;
 	u32 max_mtu;
 
 	u8 rss_hfunc;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 469c3939c306..7e4424d626a6 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2456,6 +2456,7 @@ static int nfp_net_read_caps(struct nfp_net *nn)
 {
 	/* Get some of the read-only fields from the BAR */
 	nn->cap = nn_readl(nn, NFP_NET_CFG_CAP);
+	nn->cap_w1 = nn_readq(nn, NFP_NET_CFG_CAP_WORD1);
 	nn->max_mtu = nn_readl(nn, NFP_NET_CFG_MAX_MTU);
 
 	/* ABI 4.x and ctrl vNIC always use chained metadata, in other cases
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index 1d53f721a1c8..80346c1c266b 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -254,10 +254,18 @@
 #define   NFP_NET_CFG_BPF_CFG_MASK	7ULL
 #define   NFP_NET_CFG_BPF_ADDR_MASK	(~NFP_NET_CFG_BPF_CFG_MASK)
 
-/* 40B reserved for future use (0x0098 - 0x00c0)
+/* 3 words reserved for extended ctrl words (0x0098 - 0x00a4)
+ * 3 words reserved for extended cap words (0x00a4 - 0x00b0)
+ * Currently only one word is used, can be extended in future.
  */
-#define NFP_NET_CFG_RESERVED		0x0098
-#define NFP_NET_CFG_RESERVED_SZ		0x0028
+#define NFP_NET_CFG_CTRL_WORD1		0x0098
+#define   NFP_NET_CFG_CTRL_PKT_TYPE	  (0x1 << 0) /* Pkttype offload */
+
+#define NFP_NET_CFG_CAP_WORD1		0x00a4
+
+/* 16B reserved for future use (0x00b0 - 0x00c0) */
+#define NFP_NET_CFG_RESERVED		0x00b0
+#define NFP_NET_CFG_RESERVED_SZ		0x0010
 
 /* RSS configuration (0x0100 - 0x01ac):
  * Used only when NFP_NET_CFG_CTRL_RSS is enabled
-- 
2.30.2

