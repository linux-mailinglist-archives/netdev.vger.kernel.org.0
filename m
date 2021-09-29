Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B037541C84C
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345210AbhI2P0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:26:36 -0400
Received: from mail-mw2nam12on2135.outbound.protection.outlook.com ([40.107.244.135]:2634
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345204AbhI2P0f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 11:26:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ki3O7q7UeZDluzmTmgooMDpDu8E5TmDupoKl3lz92WxBLIfJvdHEp3aWz+1sT7wZ9lSjUGcHO5Kgwsw4s0GP6+DwWoqskCtbXl/DyMHvbHA6Qwko0N68euFt2ceMBBGojBpI2FloYSCWdpZ/qKEnZgyI7PsmWxIz6Q2wm8k4iIcVpmCkPVDVsiVf4wL2NGZ3ADjR+jE5Y0thy9NLjyazukx8T0NIIxak2O8wKSnkO6od9RyjSoIOXwtnebZay+dZZ/yiTi1etytTyizbqovVXzwWcV9k6njAxzdVEly3IDh2E5Y97DHuJWfo8M/7YPwKT/v8wSuIervv0oa9Sx0mnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GkOVaddLKc1JDVyp6y50e4VLTDjUIBLuUbCrXBc9DYY=;
 b=VRgmq4de+gYsGHK8WBPFAVX9dRX27+39ufyRjc45sPAQLIqqrCKlX+Gjn4UxfssTB8gpL6qV3t/HF+1bf0/PJ4O+2rycomRrhqERmm4H1zXSE/KkMprXz1Z+nSGMBl72VNYbuOnhhQbRtti9/WVkfw1Z2iiDatgTYqde8tZTJXwgpIwPY1KyP3AUu8qFPXU18cc9nWwVlM43vSafZ0SZkKHtKXpe2qW7uH/LF/oK0jGTP9pNly19M2Q5Suo3K3cwGtbLRss6Ksva1wn+JST3RMR6cF6tD+RYTkow45HWqd1qUrQbHmpJAPiKNBcFGxH9U5uIIchK5MfPEkYsIQfTDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GkOVaddLKc1JDVyp6y50e4VLTDjUIBLuUbCrXBc9DYY=;
 b=sBmZUPFkgIfwC7yIPMu4dsCkU8gvSrqZUzv5jdDOR7JbiZ/RixxpPKQ9B30rbU9jKN7VaRTxaQG2K8v8eVAHYrCuC2Cp+0nZJBZLGfxBEWgM/WjerCCSIiAOmcREnLJ52MFCNc0a/QlyL4E8fBpaj53EsOobKoLVoN/4zzUzYXM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5456.namprd13.prod.outlook.com (2603:10b6:510:131::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.7; Wed, 29 Sep
 2021 15:24:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%9]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 15:24:52 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yu Xiao <yu.xiao@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net] nfp: bpf: Add an MTU check before offloading BPF
Date:   Wed, 29 Sep 2021 17:24:21 +0200
Message-Id: <20210929152421.5232-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR04CA0091.eurprd04.prod.outlook.com
 (2603:10a6:208:be::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM0PR04CA0091.eurprd04.prod.outlook.com (2603:10a6:208:be::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 15:24:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b462859-384c-4957-dbc4-08d9835d482c
X-MS-TrafficTypeDiagnostic: PH7PR13MB5456:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH7PR13MB5456C7BEBDABCE45397E1DFAE8A99@PH7PR13MB5456.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 00WNt1w30mZFboBqQgOaBmC0WSRaYscj/3cWqCDZOFjEPRCVcLfHNgFukPjU71gAs/iHnXqgJa2Jqdfn+J9P0tT9569xyictwMoLbJUTWc9/sd7FHvhotmglVMivRPB029InEakFG9UEg0tvbtHpZ8Rom5d4477Bk/Cjc34nt+GFhE4RE/JykSszsqG4zaXe4jPJ0WDqxohMg2VXRymW/CMOAWmpvpVBgvE5C1E9kC5mboVWQh2SpZMjIixTavCqqBeThC00tNl6xwd1Wzg1CD2ExRObpbVWtveLGxH16D/4bc8Bq1EGANT+1/D58YZXI8JqP5iyQ34ow/1xQKchNLlQ9+uIQ5Hj7ajEOEFqYtMeg55nY4NwL8dMnrwhn/RixJten+bqLCTzYShIdai3keHPagDZ3JcnsT9DACb+zO/pyJjIriKw0he3Q6b6tnXvdQCMIB7EnVLMebP86XuLhi8QzNgThpS1To0XkmbCYWJlffwwvLUOjUsZYP+r4e7OQ5c41SbAMHmmSgcIFjNH3lJETnsKx1x8+5zd1JOJhtFHuf9ivMtUGPWoggWzn/VbDYt96TadgIu+xdjiMs6vx7vtDMUp3/dzm+2q3GRHoQU/BZ+a5tpBTyEGJmiAoJ1tay8wkPflFHirTA/c1CBmQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(376002)(346002)(366004)(136003)(396003)(6486002)(1076003)(44832011)(86362001)(6666004)(186003)(508600001)(6512007)(38100700002)(5660300002)(66574015)(8676002)(2616005)(54906003)(36756003)(110136005)(2906002)(6506007)(66556008)(66476007)(52116002)(107886003)(66946007)(83380400001)(316002)(8936002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V1l6blBMMGNoY1B6RFdFczNKb2I2ektYSGJacitFa0FTUENBalBNd3lBdURn?=
 =?utf-8?B?M01BN0FPUHNkazUyb2NQYWc3aUdrbTJJOU42ZTcyN2U3Y1ZOMk9OcEpZamZC?=
 =?utf-8?B?THZWOGRhRlhEWWNhMzZUTnRvUG9tT2lqUnFCUFQzeDBVeTVLVUhwc1NBdHZw?=
 =?utf-8?B?UlZBcDJuV1Bna20zbjFrQ1RwQ000NXJ5MGtwZWJ6K0JiZ3hHUTdGM2ZhR1Y4?=
 =?utf-8?B?T01LVnBiMU0rTFh0a1oraEtNamRTek40VWQxQUVOeWJnaVFlN09LT1dtVlRB?=
 =?utf-8?B?OUpKekhtdjlBMHFkNHFub2NHVm04QTVGZ2gzV2RKQkh0TDNIbC9zZG1BWUtD?=
 =?utf-8?B?bjYyakk0aUp5WkdBSW9pRVlGakxtNHJ0OFAyRmlrSUlweEFXakdwRHdqbEZB?=
 =?utf-8?B?bzQ2bG5ZRGVHeHlqdG5rcnlrUE1WY0lGMlhKN0VNZndMTUVING1vZ25VS3V0?=
 =?utf-8?B?dEs0QjdhNmhSaVMzRXlPL3pnckNidHEwbWpBMnpSZE5hRE85T3BNK1h4ZDNo?=
 =?utf-8?B?eno4TDBmZVNaUms0LzFab2hXS0t2WU9QYmdvT08rZU9xdWt6RXUrOWVHb0l2?=
 =?utf-8?B?S290ZFZYbEpaWU0rY1Y0dTNnSi9DemJlbXFZbnpTeUpGSUFZcjhyekJUNk9O?=
 =?utf-8?B?LzZlYUdSSHZ0K21URjRCN3RGcE41SE4vU2YyU2FFTk1UM3lnWWM5VE5wVG9h?=
 =?utf-8?B?TnhYUG14ZG1VczRWZVVXaXdPS1RheWowclVkdHg4TFlPajFCMVNrdVVIbUhv?=
 =?utf-8?B?NjZ5eFhLeWY2NkZyMnQrZVVkcHhrZ28rUE9PbXg3eWhDUmpSVHh2ZEUyT1NF?=
 =?utf-8?B?NzJxTGpkL2VicWFLZTdkbGdQL1N2MkNpZzBydVpEdHNwZC9QL2VZV2plelNj?=
 =?utf-8?B?UzloaWhFQkExcGRycGxTTVNyQWhtZTI3U0xEVytMTUlISzVPWWRTZWpYTnBE?=
 =?utf-8?B?TWlMMER6Ym1rVmo3anlSTitKb1crd0V2SkhscjlpbkhvSnRVTWxQR0wzV3Nl?=
 =?utf-8?B?MHRESGExVklVMG9kdTMyODNDSXlMQlJGTjJTQUZZUUVjSzFMblprMnFmdk96?=
 =?utf-8?B?WWlKQVZMcWQxeSszREtmaTNyRElrQ2ZkOUp2YXQrMzdQT2MrQTRSb1NIcGY4?=
 =?utf-8?B?WC9LRnBkWUpvMWQyT0NkNDBST3BjTytKb09hY2V2UXZKd1JFdGNBNGZPTW44?=
 =?utf-8?B?SHNFZzBrK3hvWVhOVDhoZmMwenYrMVA3WjJvR25lWTEyVzhYWjNIYnBCQmlO?=
 =?utf-8?B?R2NIR0ZMZmt5bnQ3N2dKaGhnaHJGTXRHRlBPL2h5dk5XZ0V5cGNOclY5OUQ0?=
 =?utf-8?B?Z3MxcENTTTFscXpMMzB6ZDNROEVPdlJhTVRvSm9hVW5CZVVXbVFGa1dnTElR?=
 =?utf-8?B?ZFFybkxuUHBqeWdhckw3UGdnOEdXYVZlV1M0OFZzL0xvelkzU0tuMkFsUFV4?=
 =?utf-8?B?Zi82ZmdOempySTNZQlhoMFBWYkU5WUNpY3JaQnppaGZnZzRESXoxUmp5b1M0?=
 =?utf-8?B?cFltVlZZaWxxSk95bC9KaXR6OFN4eXgreW9NYVhIaFlQcTlnRjFRdWhZZkdF?=
 =?utf-8?B?S1dQcmQ0QWVFTnl5YTBpanpzbkpnZE1BekE0ejl3SmRuN0RheXIrMzJwcTZy?=
 =?utf-8?B?L3N2MCtWTkhIbnZhdCtwRWtlMFhFRm5WUUt5TjdDTGt5My9UeE04REZ4QTBs?=
 =?utf-8?B?akRsdkdtL0kvKzdpNkRBVEkzNVdrb20rTi9Ucy9TSitMcUwrYWIxaVBCeXJk?=
 =?utf-8?B?aXlBMmEzamduRmp2emVnTFovcmZYc3AvRytwM1JpM2c0QzE2WDJMSVdnbWxo?=
 =?utf-8?B?cTIvSlpxTzc3TTg3WXgwa1VaQlp2V205M21pU2ZWbDVzOFd0emRNTmtKeWc5?=
 =?utf-8?Q?OdBp+7wpO6sb0?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b462859-384c-4957-dbc4-08d9835d482c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 15:24:51.6986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E/8YbvndomxN+lhqvXHwSFxQg/53U3PgLPoZltobd6iEKyWYBRjWQ3tSmzUxF+lwJ4d/Phe8b/d7y8NHySNmohEHataCzOflzhBfv3uTwbA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5456
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yu Xiao <yu.xiao@corigine.com>

There is a bug during xdpoffloading. When MTU is bigger than the
max MTU of BFP (1888), it can still be added xdpoffloading.

Therefore, add an MTU check to ensure that xdpoffloading cannot be
loaded when MTU is larger than a max MTU of 1888.

Fixes: 6d6770755f05 ("nfp: add support for offload of XDP programs")
Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/bpf/main.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.c b/drivers/net/ethernet/netronome/nfp/bpf/main.c
index 11c83a99b014..105142437fb4 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/main.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/main.c
@@ -34,11 +34,25 @@ static bool nfp_net_ebpf_capable(struct nfp_net *nn)
 #endif
 }
 
+static inline unsigned int
+nfp_bpf_get_bpf_max_mtu(struct nfp_net *nn)
+{
+	return nn_readb(nn, NFP_NET_CFG_BPF_INL_MTU) * 64 - 32;
+}
+
 static int
 nfp_bpf_xdp_offload(struct nfp_app *app, struct nfp_net *nn,
 		    struct bpf_prog *prog, struct netlink_ext_ack *extack)
 {
 	bool running, xdp_running;
+	unsigned int max_mtu;
+
+	max_mtu = nfp_bpf_get_bpf_max_mtu(nn);
+	if (nn->dp.mtu > max_mtu) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "port MTU over max MTU of BPF offloading not supported");
+		return -EINVAL;
+	}
 
 	if (!nfp_net_ebpf_capable(nn))
 		return -EINVAL;
@@ -187,7 +201,7 @@ nfp_bpf_check_mtu(struct nfp_app *app, struct net_device *netdev, int new_mtu)
 	if (~nn->dp.ctrl & NFP_NET_CFG_CTRL_BPF)
 		return 0;
 
-	max_mtu = nn_readb(nn, NFP_NET_CFG_BPF_INL_MTU) * 64 - 32;
+	max_mtu = nfp_bpf_get_bpf_max_mtu(nn);
 	if (new_mtu > max_mtu) {
 		nn_info(nn, "BPF offload active, MTU over %u not supported\n",
 			max_mtu);
-- 
2.20.1

