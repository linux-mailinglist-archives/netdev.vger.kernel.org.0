Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D87F6C50D6
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjCVQdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjCVQdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:33:43 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2132.outbound.protection.outlook.com [40.107.100.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E182211C
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 09:33:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SlDcENoEsdaKxtoA4HiN4lVMeXEizsWPdwMeVFMn+VWYtSXVuhqiOMLXjwEzcYJACXi98MYxQsmY1kvTqqKmnW5o8jlELniD6McM7xAqheU832AfIPPPqFLATAtC7wHTwswKry3jzaA3X7DQVWn4bjg+zjNxxvdAclOkcW2TlfHDCYbxK9p3bZAYRuOTcRVEMwI+BuO9K3kvz30MdGaQoGyyY0k6pG/OUYLNLYpm7hNYFmHFx5O/lKWFwM21h//eT8rpyPoWmO4BbIkko9+ZL18AzEDhR1EAkvPjbeB1J3MmJp+294c7d+zuWbnafNEtwpucptyKVKyb2OjJF2Omfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qr8BPE5Uag167GUjFVPDvixv8cRMoTL15kROh5017Fk=;
 b=RmfQNrBvVCx6wU5dtW7Fv19L6d3+7umhjfXqtb8om4RBTkCVDUaH1PtNPMegPiQ9dGnIrcpE5hyaziqeITLrG2xDuyYsSxSOxvnXur6WT/FA2D1zH1ieJJf0q3yvAyDssl9D2OYDsDJ8nc6nXhyNwURYBvg4Q5DQ3HkxKnacipikqPY21bPBdfndJdXbHe1vrbtUJvkMY6wdaM8OF60bQjcGONcf80cQebdGrFWoGlOfw0pixwXRu/zcol9zFdXqzHPph7OT2d+2PMfwQtLwdjmbVAgGHXpJIj0sUVSeBZ5dVwRyazX3c5oB2ZAfpVSrTTQ4kLljdAmazZQLjc/ysg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qr8BPE5Uag167GUjFVPDvixv8cRMoTL15kROh5017Fk=;
 b=kS6zMECpPT3zzwYKlNHWQDnklePg5ars52TqsSZabMVYB9deZyxZuppiEKmneRP0F8H65tN1ZgXtWkgJtMAQBRGSjBQCsDAKAJovb0wSDYoyj8sCtbikOBbzaiKy+vhHCqh2uNmjFxoLoqMy3gdpXNPGRhILdaYSeLCHtwQQjSE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4740.namprd13.prod.outlook.com (2603:10b6:208:307::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 16:33:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 16:33:34 +0000
Date:   Wed, 22 Mar 2023 17:33:25 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Wong Vee Khee <veekhee@apple.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, imx@lists.linux.dev
Subject: Re: [PATCH 1/1] net: stmmac: add support for platform specific reset
Message-ID: <ZBst1SzcIS4j+t46@corigine.com>
References: <20230321190921.3113971-1-shenwei.wang@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321190921.3113971-1-shenwei.wang@nxp.com>
X-ClientProxiedBy: AM8P191CA0029.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4740:EE_
X-MS-Office365-Filtering-Correlation-Id: 72e3f97f-4aad-4fc9-28ff-08db2af32de2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1WCrEvdXSNuxa9M+O1Gb/SFRdLllyTLOPWXz0/792KTSEscIbKmCi3/qStuMk7KAZvhp14dG8zJ4vUf+fDGgra0bqTrdmqPU7GZgYO7ZWzcmUNmM9WXf0hB+ayXx5Q9Ltwbg3b4+cKO6gyLA+77rjLBHmVPJK9cjkLQPvqCp8hqNYnNNIvsE2kXEsMa0B03ffL8g/U7wSe+bbO7MNF0kEsfNlYFEVfe0ZuzGQc3mS+Xf55u+ZA9qHq9vATG2VzXajEO/n5L66WKSlN8yZdmvSAr4Tkd9t2xThZeGq9rSeE+3ZZbq4piKo1rJbwu9DJGInm6VsuWuauzEjuTKS1zG50Uoh/k7mFEUblTGwwL6+xhGsJ8jekNfUoimQ1+IVGshkBqfT/gOV6nJdihKAnoeUsCvdfCGajL7N9RmD0dc/CkdBhKP0VRaHlT7xkhfmBydfuVri/C+iwEQ2EEIjI+RMn78N2CULQ+bGEFMRPKulvF+8HsnBA87tNIi+AeGb8DHaJfnXuwO4Ac6WmfpWL7xkq613grfrjEsElqrR1lWnUh7ynHemlQVEDC4i4J+WCnDf33Bd/ZOosDlxtx+LRq89zxBNLBNgRZWX3H6FR6qSHTdRcF4WEb3TJZf6TEJq6AItJeButn616tZOwk2kBx09TZaTvjTdvJSnilioOePXe8EXL8tqBlD03eI94J2lZ4u
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(366004)(376002)(396003)(39840400004)(451199018)(7416002)(5660300002)(44832011)(41300700001)(38100700002)(86362001)(8936002)(36756003)(2906002)(6666004)(6486002)(83380400001)(478600001)(2616005)(186003)(6512007)(54906003)(6506007)(8676002)(4326008)(316002)(66946007)(66556008)(66476007)(6916009)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5P/d8pXXHCKuXTbMmUWW9BFoJk6uurwkR47II8PQwvXMbYPz99wvsw7jwuaG?=
 =?us-ascii?Q?2ImHugnBJ4kQglobTutOYFwdfVByOLw5iFYJLc7o9uMOQ5UK2Hkz4P54nNxM?=
 =?us-ascii?Q?8pLBBPuoBejszi2zfhQlkUsbpfG0XTQw7BynJlZZkAWfWDmwsYCi6VmmIxac?=
 =?us-ascii?Q?E8RaJlJ9S7eTeKDj8NJkUOpf5MHWKORUFH1tfyYrwVLXGxF6eE+sQ3DTED31?=
 =?us-ascii?Q?RhxJh0aRR75PK8KhF9j1JfagZlONlmqXP+GJli99y3j9kQ4sMUjbNXnN8cqj?=
 =?us-ascii?Q?xRhVEQqd2mfPmVoLgDnQP4C8mNlG+j3AxL9dzwgkheeXvKPVu2daNtnnfR5I?=
 =?us-ascii?Q?gVgKDxIMowsy+miJmT7g1jjLGNVVydqx6IkSqyK31lu14yv/fwd9koTerMWU?=
 =?us-ascii?Q?lsJ5fuooBhN3+zJ72gYtn/SIT1s9NdVGCVop6CVlNhhKFD52ni8lL4SJxXgT?=
 =?us-ascii?Q?pi9oJ/q/aqCfmgLZFwCVw4GolSkJu+ystIGfUgM+kOrtnPHAr5VloTt2uwOk?=
 =?us-ascii?Q?MhZGCh9SOzxPvCabaT9loqqMo4cnrKf72uN0p/dUv+desPt6VX12/WN7DGMj?=
 =?us-ascii?Q?HaG7aHNbob9wNpZX/lf1HhBSsfKSHzcxk/OmHq+mhmiAiBr3ewUwO3lhFofT?=
 =?us-ascii?Q?94rECVyt5t5xoBQXKVqHctzzKI7/NizfHp8pOskczfW1ClQsg5nfNc9gjdFG?=
 =?us-ascii?Q?AbvK4pJ5PDDLlz8XcLT9FwZ7agsxdvJuGamn64wTx8eRtaS7ITf9KIr2lDCn?=
 =?us-ascii?Q?r5MFbarD2y1Sa80nmAdkXgfDy6Ilro2mt3qV6LCfpMu7DnjlKIh+SaVbF5X0?=
 =?us-ascii?Q?+dOpER+l62LjSP4APThfFyRlLBRARo5WnQxu96CAVjSiBkOXiV5a3sb/LR0i?=
 =?us-ascii?Q?WIFzCxmbYQlczwafnnwB8oxfxYlpUdofBc4t/qe6FbQOU7Mi/Rj+bJWQylfc?=
 =?us-ascii?Q?QjyuuVKR1GewQq++Lw2rmCWWnIMNV2XO+Cf/ZpVNqULlJJfqiYoefDSpqqtk?=
 =?us-ascii?Q?szKvF0gQUHGzmumnHtVEZfNF0Y+A1n5cdNpnIckPs8IVT951uUNydEUCSoYK?=
 =?us-ascii?Q?J//bDLDGm/wqpXaVg1ZKVhOBMQWa/mDdEI/XoU6wSTYKh63KR0yJkm131Wca?=
 =?us-ascii?Q?eZ0T2XHMu+6DpuEUmJSFLsGhIYoz83czawZqZFuTMenlTeP6/3qhhw0yztoR?=
 =?us-ascii?Q?LzvXNYyZxxerk/NbnfwmenP2FLxdzOVnRk1thCzH3GZDbNAoNq11KMQqbl1u?=
 =?us-ascii?Q?IcOvEthduFECltX9ngf1sO21zUqdBm1/i+kkFq5Q88ma4FbtOUHHFrPmUqvw?=
 =?us-ascii?Q?a1FOHxJgB1PA3Z7BAkg7HA217mlqBX82Kteu2qmizqU0V0m/jTAel4cpiORP?=
 =?us-ascii?Q?jrT6lTmGLiNobAQByZVm6Q9CNDmqK0kivKlbQ4GIwnLDS4GpkuQKnhV5r0iZ?=
 =?us-ascii?Q?mGi/dLq3BhwmbCcSJdrgHn2yffjioSjykLwwtdwVJlo93jZuBfiJSjFrtMsz?=
 =?us-ascii?Q?+dORwXlX7Zh/cUIzPJnTPDmoc3/7YZwLM1ojmUijJXPiOhZzQAojx4kRVvbU?=
 =?us-ascii?Q?fgIGkimnv/kLyN7ZPnDiGyMzdJOX9mONuiCSPEQP4nGh6+IAv0QWdG8iPg9B?=
 =?us-ascii?Q?JA2fJczh9RZVuTLnmaDJoq90QQPyLXOuk48Yvqa1RBCXVl7LOJYZtN0Qt35u?=
 =?us-ascii?Q?X81puQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72e3f97f-4aad-4fc9-28ff-08db2af32de2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 16:33:34.0460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lspVJdOJXpIMDLcRFHEiuwraTnIZ91RgPgY7YUq5VuxXzbnSKyN9KHB/GzONUehplnxy4QGYmUjmsQixJvh0GAz7Ul/ADbHAZ7VX5/DsJ1s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4740
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 02:09:20PM -0500, Shenwei Wang wrote:
> This patch adds support for platform-specific reset logic in the
> stmmac driver. Some SoCs require a different reset mechanism than
> the standard dwmac IP reset. To support these platforms, a new function
> pointer 'fix_soc_reset' is added to the plat_stmmacenet_data structure.
> The stmmac_reset macro in hwif.h is modified to call the 'fix_soc_reset'
> function if it exists. This enables the driver to use the platform-specific
> reset logic when necessary.
> 
> Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/hwif.h | 10 +++++++++-
>  include/linux/stmmac.h                     |  1 +
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
> index 16a7421715cb..e24ce870690e 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
> @@ -215,7 +215,15 @@ struct stmmac_dma_ops {
>  };
>  
>  #define stmmac_reset(__priv, __args...) \
> -	stmmac_do_callback(__priv, dma, reset, __args)
> +({ \
> +	int __result = -EINVAL; \
> +	if ((__priv) && (__priv)->plat && (__priv)->plat->fix_soc_reset) { \
> +		__result = (__priv)->plat->fix_soc_reset((__priv)->plat, ##__args); \
> +	} else { \
> +		__result = stmmac_do_callback(__priv, dma, reset, __args); \
> +	} \
> +	__result; \
> +})

Hi Shenwei Wang,

I am wondering if any consideration was given to an approach
that has a bit better type safety.

Something like this (*compile tested only!*):

static inline int stmmac_reset(struct stmmac_priv *priv, void __iomem *ioaddr)
{
       struct plat_stmmacenet_data *plat = priv ? priv->plat : NULL;

       if (plat && plat->fix_soc_reset)
	       return plat->fix_soc_reset(plat, ioaddr);

       return stmmac_do_callback(priv, dma, reset, ioaddr);
}

In which case the first parameter of the fix_soc_reset field
of struct plat_stmmacenet_data can become struct plat_stmmacenet_data *.

diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 9044477fad61..b26ade7e4be8 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -223,6 +223,8 @@ struct plat_stmmacenet_data {
 	struct stmmac_rxq_cfg rx_queues_cfg[MTL_MAX_RX_QUEUES];
 	struct stmmac_txq_cfg tx_queues_cfg[MTL_MAX_TX_QUEUES];
 	void (*fix_mac_speed)(void *priv, unsigned int speed);
+	int (*fix_soc_reset)(struct plat_stmmacenet_data *,
+			     void __iomem *ioaddr);
 	int (*serdes_powerup)(struct net_device *ndev, void *priv);
 	void (*serdes_powerdown)(struct net_device *ndev, void *priv);
 	void (*speed_mode_2500)(struct net_device *ndev, void *priv);

I do see that the approach you have is
in keeping with the existing structure of stmmac_do_callback().
But I guess my question there is: why is that model used?
And could there be a plan to move away from that model?
