Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE25942D8E7
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 14:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbhJNMMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 08:12:48 -0400
Received: from mail-dm6nam12on2121.outbound.protection.outlook.com ([40.107.243.121]:37960
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230026AbhJNMMs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 08:12:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KFOhurstfDWiSBuNDy9yv5ZDTfs5wej7mXXceZL26NxCpc18o9ixQem/x/9M9FiDoCCv9HAK6QqWyCrE2+8FBL0noQrtYP9dxZFgDvuJq6O0iplj817znwqoF2xuewMrBoqDhOxGKF2wDS07AjMiRPcCQaxFcPISOuCjTFmCTcYAP1uoLiaHUQ6ru11eodK6XGijBPsoth4kevcfoO5fueM4OV74iAWWHyoInLmob1iAX1mz7K8yCAFKI8MUpPitxXUp+PceBKvXZlQ2UgoAMX8XS40+elJzxPNdjcYNXDHP4EosUTVjI2OM6xhESHdq35ka8PzerEZWP8aQtElPtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mq1OFMkBRIsVY39Crc46xAqd8yDbI+jrOdTOFEs2p2U=;
 b=ZQg/Z4UolFrWckFjvbJJKV9rBtNHryNlnO6UCIL3PftDHRiCWmyHukdhdTql8ni4rtkzcN5kpsIpbj2wEsuH62chGrK/BlOzyHmladGnSQRkUuqjYWMfvUojgKzxU3WcEAaIOBeDjqgNLeDUuc6TxyQ8pF6gmzd8KSv2Ihw0UkC04H+VM0mHdm3T/cEJMVturX4LdEXDeaFvM5sUx7+FyNK1EG6pZhHruoZ9DPei5TOgZ5UigCAYqm3n2EQApW2sQQviP4NivC49U/fvyozeJSRzAjuvYG5Z/W4k8WeE09B5KEr7ImHfqTdclD2f57taPXO6xTsRN8OWWrVdd66vZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mq1OFMkBRIsVY39Crc46xAqd8yDbI+jrOdTOFEs2p2U=;
 b=dBBXwlbjBI7Q1bW+cTvCaESRcqaU1bfyJ7XOjPj7QjLX7EglJngnBHDAKpgA35RoexM9ZzbA52JtDKckflDeBktKkHSoXsMx1Vepjzq0jQ7zoRBs29MhQcibW2MkUk5nOc19CTxVcR53pJPThsv9OfsunhKpOwPETa3R58Va4Rc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5432.namprd13.prod.outlook.com (2603:10b6:510:131::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4; Thu, 14 Oct
 2021 12:10:41 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%7]) with mapi id 15.20.4608.017; Thu, 14 Oct 2021
 12:10:39 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yu Xiao <yu.xiao@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Niklas Soderlund <niklas.soderlund@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net] nfp: bpf: relax prog rejection for mtu check through max_pkt_offset
Date:   Thu, 14 Oct 2021 14:09:48 +0200
Message-Id: <20211014120948.31278-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0096.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::37) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM0PR01CA0096.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Thu, 14 Oct 2021 12:10:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e93d142b-6efa-4486-2dda-08d98f0b9618
X-MS-TrafficTypeDiagnostic: PH7PR13MB5432:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH7PR13MB5432C0982E111E5DF046F4A9E8B89@PH7PR13MB5432.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZzI37aaCNVA+UUzQLJGMOhiznUMsFQNXNJ2qsPWkkhh63Gq+ptK3SqFMezorZHlv+5N9R0+MiOG2fytjXgXV7AlU4JUz3T29CgSJ1lmHpoChTspa6NfR0DsC7ZvAy0Z4fTBtjnk6VGspOLpoAUr8wqmspcJR/Raz2kyodV05wIvo/Rv3/x2Hxrm1a5i7dYFcT3+GjRHQXiyjFICMzi4vKJtwwJfTM+Rxq33YNOGdM0z/X572wD835wSndPDSDhDHIxShiKrSoTVzanSu0aSPnimpmXngj/RLsPLm50/KM3BGyU7qcAQJ/PrPDmwHxGjVd11T3ZfX0OnaupgbAxPrK/jDmaGpc18n3j/BsSsx2WzxMhiSiUrSGqjGBpR477zfbWwLa6fqOHPHKDekeigUjE2K+E3gOI6rLwI2/W0psU6J+Wl/bmk8yRpigypnKRlOzegopg1OIzTz3iG1vnr3uAt2oHHRZuaU78bqH18oIUDpULznd4rBwbfGCDSRf7l/CmqBKCG58XoVQB8yHCF3ErpKcPhLAHrzbZTdQqSYOUnNps1hQLOiirJA8iQqUnQN2Q3Ky8drIWUiWifbNV2zLSBTZyvujgbNwexsk5/HY0tjXh0W5UvU8CaB/eIo3ZV/wZBD364MJYoxH4pXPC6uAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(396003)(346002)(366004)(136003)(376002)(8676002)(66946007)(2616005)(6506007)(83380400001)(52116002)(2906002)(86362001)(508600001)(66556008)(316002)(38100700002)(186003)(6666004)(66476007)(110136005)(4326008)(1076003)(107886003)(5660300002)(54906003)(44832011)(36756003)(6486002)(8936002)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zCp5R0jXXZCC6ZShNxU5EFsxmTAA6HLrxDxxyU/AvBwJ//XiDCzxDCsk1B69?=
 =?us-ascii?Q?tWQcbxMULi9pqLfZUJPlA+Cn7csKXlbzl6t9erZU2q4Hm2agMH/BCfAWsoCm?=
 =?us-ascii?Q?S+WIKrTiuATNP5s94FBBPcECnY+7rxE+pIQ5YeiaHBzUZJeV5E0UyjTr8K1S?=
 =?us-ascii?Q?OYFCSFaj5SYswx5cssLa4/au/2bmchRFBaRm8+ECIMmEu2i1Iu//TBR/eJaS?=
 =?us-ascii?Q?z8TCAecmThNahWeQSH5e/NkyenVO4ahXVh4NJP7hXSk6zlivRTJ0UZYDL/fX?=
 =?us-ascii?Q?6/JIA3nPXjwZUDK4T/GRXgy1w5ObK2atiAQc5//pb1Z1WD9UkTX3//E/DApg?=
 =?us-ascii?Q?BVvc5L5+EFxwjyqlxGpUlT3wRCDFVFuCr4vjfhs8Uxmemnj+tjn1Y6ggtZap?=
 =?us-ascii?Q?XgpZWeG7XqoVE4qKgdkMkrBpeBU/oWTF/SL+Lqe+fB2UpMpbf0NnqaQDQl5T?=
 =?us-ascii?Q?xRRP5J42hPHKy0+TKWaNQAcnIOu38oB5+vRzlkkiVyDuzzprcCTTCNvza2m0?=
 =?us-ascii?Q?FH9X2+/lycSaaQUK7e56OL3RzVaSCntJ1onnUkWz17NNqEXRyC4NspzZUyjE?=
 =?us-ascii?Q?KBa76DZR29MMH86YPzvylUa+jeHboAjpNS3DsK3ZozcJlUgWQbyLPNscjlG3?=
 =?us-ascii?Q?hbPIF4HL4IxZKmIWWaBI0Nbmt3dR6b9j6aZR/Vu7M3P6R5egXA/1n5n+n4sJ?=
 =?us-ascii?Q?VJlewbBqj98+/vDC/3Zrv2ZGzwCNk3uXKH5TTwENj5sTFos8F8zcDv47b/jx?=
 =?us-ascii?Q?KgLJMOljNgskjrtYMvICKFLomrUlnquQP19gHzDrkpki04+7dwSTt+CByfDL?=
 =?us-ascii?Q?BEkvqX4NGJdUtnhDgUgf5TVG54CwmMNH4Wcy4I9dBnVq9eKgt6pbo3FkIDlh?=
 =?us-ascii?Q?gzvZt4hBtSd0bYAFq8E23DjYVUpDz31eQ51N8if6WW+eM2AOIkWLE2x7cn/n?=
 =?us-ascii?Q?2RaESJd8X+ZYXiTEb9mUxJ4cAWaDv5x2flzUxvq8S1Af/4aHTw+Nm8V6a7bH?=
 =?us-ascii?Q?d5YCVQBoZSTVtFjEU84EtUKWrIaNxcGE65kPwSCoLL82S+Qr/YQpyYeWfgbl?=
 =?us-ascii?Q?FZJ16YGkmnWe2h3zW53kuIEG8kEcevH8BtSKwHfdigiavbL+kvKxCeTPaeAm?=
 =?us-ascii?Q?s8y5E+hzt5DSU+C9tZqgsDtghgEOy/FQkMGVYbJnntQFIbCkpRDEf8zwI97v?=
 =?us-ascii?Q?cT8InQQtbEG4cshsrYcKKgXbYYjGgGVQXSQD7T302/SQvbPkFVW3gE8EyMlg?=
 =?us-ascii?Q?sIxp9HTjjLxvbAVFYgl8zvVgei4NOAXEQtnG7/anIc6RV4QODq1y1ua6h5ub?=
 =?us-ascii?Q?Leex9lnd80+IMYEkZKLuJUIOoeXCeFfKz6ruGFc/++pDC6/VxqCc0RcKUbt0?=
 =?us-ascii?Q?JaubQr0AEqqy+xrRftseeXKFxaXV?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e93d142b-6efa-4486-2dda-08d98f0b9618
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 12:10:39.0151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4+6MfldYxDUaA/mTX0xJZOnoxJ3OKMvF8x2L5BGXSN8MkfjoF538NJIRPLkuiClBnIzwAag/8JxXtndi9NQNYDCHM5bhQK9/ZfmFkYPouco=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5432
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yu Xiao <yu.xiao@corigine.com>

MTU change is refused whenever the value of new MTU is bigger than
the max packet bytes that fits in NFP Cluster Target Memory (CTM).
However, a eBPF program doesn't always need to access the whole
packet data.

The maximum direct packet access (DPA) offset has always been
calculated by verifier and stored in the max_pkt_offset field of prog
aux data.

Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
Reviewed-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Reviewed-by: Niklas Soderlund <niklas.soderlund@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/bpf/main.c   |  7 ++-----
 drivers/net/ethernet/netronome/nfp/bpf/main.h   |  2 ++
 .../net/ethernet/netronome/nfp/bpf/offload.c    | 17 +++++++++++++----
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.c b/drivers/net/ethernet/netronome/nfp/bpf/main.c
index 11c83a99b014..fd8c3ac2c612 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/main.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/main.c
@@ -182,15 +182,12 @@ static int
 nfp_bpf_check_mtu(struct nfp_app *app, struct net_device *netdev, int new_mtu)
 {
 	struct nfp_net *nn = netdev_priv(netdev);
-	unsigned int max_mtu;
 
 	if (~nn->dp.ctrl & NFP_NET_CFG_CTRL_BPF)
 		return 0;
 
-	max_mtu = nn_readb(nn, NFP_NET_CFG_BPF_INL_MTU) * 64 - 32;
-	if (new_mtu > max_mtu) {
-		nn_info(nn, "BPF offload active, MTU over %u not supported\n",
-			max_mtu);
+	if (nfp_bpf_offload_check_mtu(nn, nn->xdp_hw.prog, new_mtu)) {
+		nn_info(nn, "BPF offload active, potential packet access beyond hardware packet boundary");
 		return -EBUSY;
 	}
 	return 0;
diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.h b/drivers/net/ethernet/netronome/nfp/bpf/main.h
index d0e17eebddd9..16841bb750b7 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/main.h
+++ b/drivers/net/ethernet/netronome/nfp/bpf/main.h
@@ -560,6 +560,8 @@ bool nfp_is_subprog_start(struct nfp_insn_meta *meta);
 void nfp_bpf_jit_prepare(struct nfp_prog *nfp_prog);
 int nfp_bpf_jit(struct nfp_prog *prog);
 bool nfp_bpf_supported_opcode(u8 code);
+bool nfp_bpf_offload_check_mtu(struct nfp_net *nn, struct bpf_prog *prog,
+			       unsigned int mtu);
 
 int nfp_verify_insn(struct bpf_verifier_env *env, int insn_idx,
 		    int prev_insn_idx);
diff --git a/drivers/net/ethernet/netronome/nfp/bpf/offload.c b/drivers/net/ethernet/netronome/nfp/bpf/offload.c
index 53851853562c..9d97cd281f18 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/offload.c
@@ -481,19 +481,28 @@ int nfp_bpf_event_output(struct nfp_app_bpf *bpf, const void *data,
 	return 0;
 }
 
+bool nfp_bpf_offload_check_mtu(struct nfp_net *nn, struct bpf_prog *prog,
+			       unsigned int mtu)
+{
+	unsigned int fw_mtu, pkt_off;
+
+	fw_mtu = nn_readb(nn, NFP_NET_CFG_BPF_INL_MTU) * 64 - 32;
+	pkt_off = min(prog->aux->max_pkt_offset, mtu);
+
+	return fw_mtu < pkt_off;
+}
+
 static int
 nfp_net_bpf_load(struct nfp_net *nn, struct bpf_prog *prog,
 		 struct netlink_ext_ack *extack)
 {
 	struct nfp_prog *nfp_prog = prog->aux->offload->dev_priv;
-	unsigned int fw_mtu, pkt_off, max_stack, max_prog_len;
+	unsigned int max_stack, max_prog_len;
 	dma_addr_t dma_addr;
 	void *img;
 	int err;
 
-	fw_mtu = nn_readb(nn, NFP_NET_CFG_BPF_INL_MTU) * 64 - 32;
-	pkt_off = min(prog->aux->max_pkt_offset, nn->dp.netdev->mtu);
-	if (fw_mtu < pkt_off) {
+	if (nfp_bpf_offload_check_mtu(nn, prog, nn->dp.netdev->mtu)) {
 		NL_SET_ERR_MSG_MOD(extack, "BPF offload not supported with potential packet access beyond HW packet split boundary");
 		return -EOPNOTSUPP;
 	}
-- 
2.20.1

