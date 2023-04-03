Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6216D518C
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 21:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbjDCTuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 15:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbjDCTuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 15:50:07 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2116.outbound.protection.outlook.com [40.107.243.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBA72D7D
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 12:50:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kH9L6CFmwKRw1jInJv4MSuq4ffyGpKkhfQdaTNIb+f96vQyfj91v/dD32kTklp8xJvkfAIIADXtOqEn0Nrkxcr98R5pV6T01kkYW1GD0irMLBBR5tq7pIgg18lOnlRXK31f67ah05brShI0qaBeahGo+hLv+8Zhu4DJ5tf/STAjAcPfUQ+drvysXECof4JbLVbZjJJScDSWWJlcL6o/PyPXNDTmc/3j4RriSPIah1ERKSRSuMZYYSJwvRVVYBo6XGMUbhOxDc3wyH9+xA3TOr9Ikzof1PfkbjaFcUczW0IZxKLNvWgl7Tq1X80LPrk5ELZME5N2QFVSdVaV9mubvYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eJBgXUNISmoTjoAMMXRTTHAeyrhLH1Dq9OPdxpZ6ugQ=;
 b=VcDPV+foVz6W35s2QLwC5DKi6+uqoNTfLtKCQVOOwBCIk2HJB+8MF4+k0KsQuElcHzHcaC1e61WGNq+8yxw4eh9EoNDi/B72a2U8jGXkNdpemFRu3hf/uxnOE+xUYbQB8sggwC0ToYhT2+qQCRvEH6OVQkGcGJVgnaRwSGGl0Kjtv/5lR3nS6wQ7fVG/uwjCt0vzzEmUXrWYRxaS8cnO1lsWlYblVLVNa/FVGAr3Yw3rkcTJmtG9EzRMzUJs9DBJYnqGoD3viTIzMnMA5wHXghRA7frSbDyYNR6Shqgmys4lbEfn/imMEvJ+q8/5eU0j1QWozreehxiqPfyAogVKsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eJBgXUNISmoTjoAMMXRTTHAeyrhLH1Dq9OPdxpZ6ugQ=;
 b=aFGlkRSn8ZUNkRglD89yri1T+OTuDvCWoRxHg1HoiyJJ8hcjsWpXVdYdYYpayFNt/p5i5vaAhs+qn9orOTY3bvGfl4SaBhJ09s8cGylzTRHwXcTcRvOzEpGTPJi6vG6InN/nm00LyzDwo7a7EhSH5V2yDsEjZhoGbqpsptW4RFY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH8PR13MB6272.namprd13.prod.outlook.com (2603:10b6:510:253::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 19:50:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.030; Mon, 3 Apr 2023
 19:50:04 +0000
Date:   Mon, 3 Apr 2023 21:49:52 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Wong Vee Khee <veekhee@apple.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        Jochen Henneberg <jh@henneberg-systemdesign.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, imx@lists.linux.dev
Subject: Re: [PATCH v5 1/2] net: stmmac: add support for platform specific
 reset
Message-ID: <ZCst4PvQ+dlZEbgl@corigine.com>
References: <20230403152408.238530-1-shenwei.wang@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403152408.238530-1-shenwei.wang@nxp.com>
X-ClientProxiedBy: AS4PR09CA0010.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH8PR13MB6272:EE_
X-MS-Office365-Filtering-Correlation-Id: 7992b889-6d7f-41eb-45c1-08db347c9e14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ToD1Re32PZcNquGA+5d80yWqtsZ5CMeL12zj7rq/YvUDuEJ7n1P0I8heh5bgAac5KBDmKdCIRF+82HZzrzMEuJ1TDBAkyDHQqmVyfW3MBxVgeje5uZbtfmiyrP1Bkj1eaCvEGpR6zORYOipIvU+3GXzO2a+Db4WFxFiWPaeDAoECsMtMaE5io/qB2gT2gKEzINlWaAtrljpNxMmSHOvFPk7dA3biEyLLiyE39VuOaMNw+IufEtE7DTCcjc0h4IQ4qvRtg3DKKBEwaIZinDq1pbbwV8Elb7ECQX/1CyKUvt3TxmezKwuzN12/Xc/my71SOwUTFL3a2+1mq6GIMyF3EtvF/xilSQ88fxz2Ld1/7S7SAoyR4y6pWZIY7fJBYAJD9tYpCpBmxmr6qK/5RPpVcID0lY8R2HIdIiDd+T5zaM9miq1MEELTTrOtL+Ve3TSevC9IL73MPKe9I8ONgv4qu4xclSNetdRxXYhxNwG3jNwn5GGr2wiIUaipbm/LF7e7Tm47+hkUt4mStweJK/SS6/qGeLrMwayqaI2JhFH32zavEU/uDHgN48lpemmgTEb8xIgML/b0Ob/jxscuiWsoRJpoD6Sx+sQQwwSmWtBD14jnFtRWh+iGsFK9tsnRrdYebY/tHP52ZOmE3V925XOLYyoV+Tn8AqLz/FpJfOoxb2o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(396003)(136003)(366004)(376002)(451199021)(2906002)(44832011)(86362001)(5660300002)(7416002)(66476007)(8936002)(8676002)(66946007)(66556008)(41300700001)(36756003)(6916009)(4326008)(316002)(54906003)(478600001)(6486002)(186003)(6506007)(6512007)(83380400001)(2616005)(6666004)(38100700002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mGrD69g5GAQH5f8HSDG71QRtovx4Vl+ehSSFb1f61EJiLqaV5OQepOMBEb6X?=
 =?us-ascii?Q?o0re8509ZeYBFqRSJNiLV8MGbu2TziI3hakFPEjsiScPxZNN7zq2dTs3v/31?=
 =?us-ascii?Q?bbZj9ESfpBvOccq7u7whYpmFqrFSxqsf1Jus1wH4xDeyXok0yr1MeNGGz+4O?=
 =?us-ascii?Q?vlJecDQ4gMzq+Ksybb8WjCeObAJeTEuAt4PWp7+PTl7ybUGKZvZ1blDy7bhy?=
 =?us-ascii?Q?hJg5VIiHCR7fSoQNQX3l5UFrOwcINvC3UIc5xFIoxRDCyZkKlTQs4EPhBp+3?=
 =?us-ascii?Q?8/AvHRvlboTUwZW3ZXBL0aSWMwFvJLxrW49Dhfg8G6TD2QsbmnZFb31EqOkM?=
 =?us-ascii?Q?eAJ+3cpGe5HLFdhvWalGgutFdIe3FRItkrIgx1zO8tMiYCMFtv7hr1PUm8Vm?=
 =?us-ascii?Q?BFLKKIiDaTgttl+4VW5AGby4mcnV6nFIUBM0dDrM1B7moiy2xWKsvVi0xdfi?=
 =?us-ascii?Q?kLrLVW/6Y5EQDPjkmJTyCfYazsUUv3Xj5l/iAEt1KVvVKl7Aot350Qa1uK8N?=
 =?us-ascii?Q?FZSR6eD3YncgFtrSlJpB0K3sD50HgSAMvbxnfNLPpLDPyB6cCI8k/Sb+fgP8?=
 =?us-ascii?Q?StOuLZK1qWJMNQjlXdouBYg6o7y/UBKprVgbNOmm0qWt1R2AdY+bRpvWOsLy?=
 =?us-ascii?Q?vaPRX3+nmyWJi+SpxfF8qaKa+jnLaaMIGwrWhgVi7OTksLtgQcQqHLDAAtIj?=
 =?us-ascii?Q?fBYsL4ghDhlK0Y1iyvum4UF4CtLFa77Pr/EYXaRxfhtU7chJl+kmlpU07UHX?=
 =?us-ascii?Q?F3JSCGKCg0Nwxuz0WZ7W/QWS+ouALz88w+5SkLJHl2tTpmE2ShhGjP40FdTY?=
 =?us-ascii?Q?pWsEgFQeim9e8+s4XraX31niDVBIovW8wI7nCD1EvSoOHcs27kgzIeAO77pe?=
 =?us-ascii?Q?rvzYXunjh+aFIv5KGTcLr8OJ+MaR16+isRs7EShaD3AgEms7LshKbWhDcpv/?=
 =?us-ascii?Q?VoKgc0wjdk0MPme9B2ZEj65hmIrOaEIQHP6OC8z6H/skA5D1Hg6CxYfFsGU7?=
 =?us-ascii?Q?Kfq9++nuqD+WlvjHcZ4UmP4RwKpKre/3YZVp6MuEneSJEdo/N2gOujo3d/TN?=
 =?us-ascii?Q?6TCbwTk/4/NVC1kdOsJW+Gmxg2wXAna+aPlAYg65WrkwCeTz/zPWqhtke+FD?=
 =?us-ascii?Q?bLVhAfhPS7hmOlPQYOWmxGeWHW9XBgfyNtaOUOH2luPgxkMSD6hBkAt+PE0q?=
 =?us-ascii?Q?0Vwaa7Af1GZiW34kATh/onKguvt9/J2gdqiIRLXmHPn/e50V+pu8lrwLmM4v?=
 =?us-ascii?Q?Bk/n1GF9xpt9EdZ0iDW40SrMfX4dpS6GB7UEVHIcU1vaOBriiF3E3X8GysBp?=
 =?us-ascii?Q?eWcoCdx1AtYO6GG8w8oNZxVlInJ4I94P1HrEcDk6QqBu9Qd6xDUsNtv60reB?=
 =?us-ascii?Q?obWlX50lc8GmpiK0GwfqUnmQbf4NiaQjLBrY0kv3PIDM6NCyCY5/V/XlzZrd?=
 =?us-ascii?Q?1F9vDSr8GA2UogNymKHYVRIpj9/S4AFd6itl3/NsjVOK0od5X4/3FRYBhE1u?=
 =?us-ascii?Q?bkXRW90lC19ACcEqjvcZ99mi6gaTXETjmxW0Lpkk28ugfmjPGfi6gjYsZ+q+?=
 =?us-ascii?Q?UUvmLtuWiQJv5/DD4PdlSz1Z0N8A4UW0WTSeR0knfR8q+jWyNWRKr+QKHnZF?=
 =?us-ascii?Q?9lL06MDTmbRInh9SnswBbu/gv2O5gBHLZuLgdijrzJp/7X6ZjxySQ3ap0s+j?=
 =?us-ascii?Q?nKB1vQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7992b889-6d7f-41eb-45c1-08db347c9e14
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 19:50:04.0569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yq9SPOvEQzW1o48YJSMXAgPZIMd6zOuHaoyScUoBtjOU2ZD25U5jbLThqQO68VqQ+Sdrazcvhe2CqVOu084DQguwF3kIHUZy6XaECO1ncTU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR13MB6272
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 10:24:07AM -0500, Shenwei Wang wrote:
> This patch adds support for platform-specific reset logic in the
> stmmac driver. Some SoCs require a different reset mechanism than
> the standard dwmac IP reset. To support these platforms, a new function
> pointer 'fix_soc_reset' is added to the plat_stmmacenet_data structure.
> The stmmac_reset in hwif.h is modified to call the 'fix_soc_reset'
> function if it exists. This enables the driver to use the platform-specific
> reset logic when necessary.
> 
> Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
> ---
>  v5:
>   - add the missing __iomem tag in the stmmac_reset definition.
> 
>  drivers/net/ethernet/stmicro/stmmac/hwif.c | 10 ++++++++++
>  drivers/net/ethernet/stmicro/stmmac/hwif.h |  3 +--
>  include/linux/stmmac.h                     |  1 +
>  3 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.c b/drivers/net/ethernet/stmicro/stmmac/hwif.c
> index bb7114f970f8..0eefa697ffe8 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/hwif.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/hwif.c
> @@ -87,6 +87,16 @@ static int stmmac_dwxlgmac_quirks(struct stmmac_priv *priv)
>  	return 0;
>  }
> 
> +int stmmac_reset(struct stmmac_priv *priv, void __iomem *ioaddr)
> +{
> +	struct plat_stmmacenet_data *plat = priv ? priv->plat : NULL;

Here the case where priv is NULL is handled.

> +
> +	if (plat && plat->fix_soc_reset)
> +		return plat->fix_soc_reset(plat, ioaddr);
> +
> +	return stmmac_do_callback(priv, dma, reset, ioaddr);

But this will dereference priv unconditionally.

I think perhaps this is code that I suggested.
If so, sorry about not noticing this then.

> +}
> +
>  static const struct stmmac_hwif_entry {
>  	bool gmac;
>  	bool gmac4;

...
