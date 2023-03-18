Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48B106BF91E
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 09:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjCRI6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 04:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjCRI6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 04:58:44 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2118.outbound.protection.outlook.com [40.107.244.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA1F34033;
        Sat, 18 Mar 2023 01:58:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VLYpuCTDIk2ATMOf+GRjAY1wwVV4qwYWLigz6c81gTEcNKpGK5E/iqG4H8m2LOzRAZcOC+XVc8wsN23+/AIJjVdsqibuIp3gFSyEiFtLhWrFRHbvQj7GVw5n2NgJAvFv2tRex6vWc5+MR5AzYqU9SYQGhvfOpitvRNdwn30aN5eO26izW1RcHIiO3jFVdO94SiHehXBvmYlqvqaODiXwjyc/mJFH9xNL6ugXrLRvzP/WAvjOV1pndYBtZAhBkbna3jZjsS+Vl4Jd288mBfp9Q5M0B+iMN4cxy/boYZ87YaTcwdyE12WpIpNY85yYQEb4Zrq9W7WptyOH98INCfBTjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JiND5gPrxpyYr8EEr1ldxK84N/Q3JRJsn1zXC3drx+E=;
 b=jh/z7kovHz1bp0CVlPR8BExqUKfDpcSUGxPeU9nZddsxJI/EeMTezjva3ynDBwzC890IlhoF0zfR23TrH8aXSJZ94b59f6ovBjSysATsHM62jW7+536Bavn+D1ukJGY8KHMFTRxBIxnmCWxs8ouuTQMQjXH4ydbkH10afz1q6V2JFZsWcj/uXwK/Qsy5jyzp2uh8jnZnZL456F1V8lSyOoBRi1JufLVXJj7xxJ/5Facap2qDpS5G+Eq/d+Rs3uChTdNjN87g1ZfTOue+3dp5PDQcXYtBw6ww285Ev7ztd6oxZVk/qGCzewIdQd225OJggPl3DUc9jB+tiEtCGcrNIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JiND5gPrxpyYr8EEr1ldxK84N/Q3JRJsn1zXC3drx+E=;
 b=aIawd3X9Gl1NZQUkiDbohkKu6APSsvkisJwig/t7fmkArEqhEXrVlc1/chVR9yrkZe1hYUwkqolo8wpiG5tc+lTp44ISN44rThmW6Qr5rOKrl+VoaNYVmE7BftIpfU6QsSbc+PmzKeDaC+Um/ex94MbxLFg4FOAYT3veTl8l1YM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4985.namprd13.prod.outlook.com (2603:10b6:510:96::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Sat, 18 Mar
 2023 08:58:35 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.036; Sat, 18 Mar 2023
 08:58:35 +0000
Date:   Sat, 18 Mar 2023 09:58:27 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 6/9] net: sunhme: Consolidate mac address
 initialization
Message-ID: <ZBV9M28EhKFYrHnc@corigine.com>
References: <20230314003613.3874089-1-seanga2@gmail.com>
 <20230314003613.3874089-7-seanga2@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314003613.3874089-7-seanga2@gmail.com>
X-ClientProxiedBy: AM0PR06CA0105.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::46) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4985:EE_
X-MS-Office365-Filtering-Correlation-Id: 12dc2513-6ade-4509-e17a-08db278ef4d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6flwsbEjNZPSjQ5VOQ0ZxkgwEjjs/h/fuH82X6L6/Knm2+bsNfibIGoNMPRsfYdNGqpvVNv6R0M6+BUCp4+b4uHa81vfPRTDeTraukJlZti/muuOSur9R65L5S3GAAPv3z2wW1rnCCjmRbzNFSmGitlBesucwX1ihfL8wmDWCMdypNbfpWRzO7YVnonb1n4cuylHVXu3+xNzkXG/6K+ZcjkRLCuNp69+jLdq6W87syDe9W3kOclaOluuxGDixRmYrDdopqtHQf+A8us25WFkgeT6WxQgWDxxQVxRXTj63XGGRpsjS8mgwGQXyO6GWTk6QgGvnkV+/zJJ9Sm9FooUgtlIsa6Nr1UsKekOZV0Nb8Q7GxyF6iRY+Vv66NYAgO+ubvhFqrnFZDkRT2iiZ/JiYc9zlNXZwzKenQMD6qIWb47IF/7R/A7UYoSf/2Jh1m87RvNDqVrw6Nihp1wIz7nCjauWyUrLXKYVP1Jv49nDhmQGybkhWBOCUlfLRtSXd66lgl4CUvXluSo5Mn1gzDHoYuoUjEETBEI96WxgF2r2jBGUr17i/HiUqOwkHQVUa6pcsQRmZ7l6RhWpMHY6No+W4oNN7jF3RM9B+l3EWmI2GPdhKQ6ZlI5fRxaGtBLqmiThAKISyNSXzzRBU5lXtYIb15T9y5FxuVlHOU+tNeECOcNwEzWDlxUJ/E4hxOaUbluk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39840400004)(366004)(376002)(396003)(346002)(451199018)(8936002)(44832011)(2616005)(5660300002)(6486002)(316002)(54906003)(83380400001)(6512007)(6506007)(86362001)(478600001)(38100700002)(2906002)(36756003)(6666004)(66556008)(66946007)(66476007)(6916009)(41300700001)(8676002)(4326008)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TwPDNPZdW1j+ZySczMCeSVagwG+Gw+KWt98eexUbfdf8w/usoI9dFpYy2lez?=
 =?us-ascii?Q?JQm5j/Up1qRY5BDTLizGHdeoc+ayLzUMYe61y0x/MZ6Lab4pe6RXWEhdd2PO?=
 =?us-ascii?Q?H4e0Wh3IQQaj0h76D9g0mTJQTVTt2wRnCtG6Nozt9Sni3FR8NE0C/OzwfTTI?=
 =?us-ascii?Q?8rFkHagmoM9KcE0tk2TwCS7UzdF4JDYHW9LHqpqpAEnavn5yOtUybMQq2eZb?=
 =?us-ascii?Q?Edvy4m8Wowl9mwPqF1k0HplGR98yKTdcIj5LpIshHaB5c93gIsXU3pNGHKDS?=
 =?us-ascii?Q?8Ym78X94zs2NAUzkPuRbra+hVtZA6ctwBftgaKk/usDf00NXHv3BBtKvL0dt?=
 =?us-ascii?Q?dkc84jiGVXzsFXNcC3nfmK7fHbgSlsBJnFkDzk2d9sq7M/jV7qGbgkCWl3gv?=
 =?us-ascii?Q?qA5E9qvip2BMen6BEYFJTD4Sg9QBqoGUoezkjgJyzOTp7moBhaab6X7F0G/e?=
 =?us-ascii?Q?iM7aH10c7l5F0JK5kH6FTzaLbn6BNDovaze+k9rn43+5mD92dbZI0DoLrjF6?=
 =?us-ascii?Q?pCzuzNOTgGPoL7NMvPBM/kIbqC+5Vxusits8HBpvLKukeRTmc9MQ464P/IKn?=
 =?us-ascii?Q?nJ02nRpzWG7Px2wauUupgEpQJs3ooSvrgJp+q1LhCfg8cHPc8La6vC7I+2t7?=
 =?us-ascii?Q?VdE3NDQqzCaDUkFu404fWT5PqzR0SzK7XE4Qm52FczFwQX5N1lFzvxppB07t?=
 =?us-ascii?Q?WO4SfAOc7Qva841XzZzMYmFTtXUdujjqamRezuGpesEsTBZAZcxRNHEvUtt5?=
 =?us-ascii?Q?Zm0BFqXRwkQVsHWxg34xZzc4o2wYlWVPFL2GQOpD0BpDTL6OG/2MTT+3DPW/?=
 =?us-ascii?Q?rpAnnqGd0rSKokfJoU//URuXslWTPzZsJeKKDZHu7poTu9N2iwVd1L8csqFp?=
 =?us-ascii?Q?XOjUAs3mB4qdKuhXWip0K/DOHjzrtpqSMfGz3R8M1ArxGy+HtSGEL6gBuGtl?=
 =?us-ascii?Q?d48lpRejqIN5OFKEGa2aiC7qEoWy7zHxFEbYdxtm/RikX6hFa7bD73YuGq9y?=
 =?us-ascii?Q?0PMVipKPw2H6bGsI+y+XqaDSHGndHKq6B3JU3hhFHKf+sSNlykXU89xVV/vq?=
 =?us-ascii?Q?o1ssa3XKFvI/X4Gz236tIYGYsd28R2/CmBxxMd1sFWpJszquEsD68EunPfjU?=
 =?us-ascii?Q?x2b9+pqJnxT+L3Jq+NMHYvYYQpWcLejM+s5p3xflMaR8vJJjhLM8in07985P?=
 =?us-ascii?Q?q0MZD3URH2nrMPlB4WP+qLqRjPSP0WMLPkbo8I4oe5Psenf4GTtMY+3uN+qD?=
 =?us-ascii?Q?HgsX1+NBUFqHm9iejpj95Y4xsWXPChMTqavQ5f4i7frbXbE/7RPXEjLzGai4?=
 =?us-ascii?Q?+r2a9/T3jvr2APrYrt/a7NaEa35hhuNsCLrGblKj8D/52c/GeU8PS81S+e2i?=
 =?us-ascii?Q?BDZQcX6+Pov1pRW5u7ByEgOzW+cmwFV4I5MmBGYYEoL7uG6+tQTUjnBCd8WG?=
 =?us-ascii?Q?OODhbAe0IFaAbkzShTxBvta+rKh9jIppbgxcL/JBCJ5suQADyrfzcv9nPU6S?=
 =?us-ascii?Q?M+3Nmta6AG8zIyWJUtePYyTgxpPkR6EV5y3vmVpRI4+CU0YcTBRJi5koEISp?=
 =?us-ascii?Q?ysJ3LrA1h8L1AHvievYQ11okGvr5dAPiV62n0oq67y2Y+eEH423ikP8t+7bP?=
 =?us-ascii?Q?syl4T9XJZWdMp5pH3Uqje3MStEIUlDcJFi/pIu3XTzSgwlxuppLxWC/1GuHo?=
 =?us-ascii?Q?lrHTlA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12dc2513-6ade-4509-e17a-08db278ef4d7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2023 08:58:35.2028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DKWD+qcTrSfmKlT11VdDqAPRJtF15ErSY5RPJQEYco7dIW/iShejGnFtfnvBKH72BVmiJcXMXDrtzEHMPLvlwpBr+WUUEt7YuzSXRsUfx84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4985
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 08:36:10PM -0400, Sean Anderson wrote:
> The mac address initialization is braodly the same between PCI and SBUS,
> and one was clearly copied from the other. Consolidate them. We still have
> to have some ifdefs because pci_(un)map_rom is only implemented for PCI,
> and idprom is only implemented for SPARC.
> 
> Signed-off-by: Sean Anderson <seanga2@gmail.com>

Hi Sean,

Nits aside, this looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
> index 3072578c334a..c2737f26afbe 100644
> --- a/drivers/net/ethernet/sun/sunhme.c
> +++ b/drivers/net/ethernet/sun/sunhme.c

...

> +static void __maybe_unused get_hme_mac_nonsparc(struct pci_dev *pdev,
> +						unsigned char *dev_addr)
> +{
> +	size_t size;
> +	void __iomem *p = pci_map_rom(pdev, &size);

nit: reverse xmas tree - longest line to shortest - would be nice here.

	void __iomem *p;
	size_t size;

	p = pci_map_rom(pdev, &size);

> +
> +	if (p) {
> +		int index = 0;
> +		int found;
> +
> +		if (is_quattro_p(pdev))
> +			index = PCI_SLOT(pdev->devfn);
> +
> +		found = readb(p) == 0x55 &&
> +			readb(p + 1) == 0xaa &&
> +			find_eth_addr_in_vpd(p, (64 * 1024), index, dev_addr);
> +		pci_unmap_rom(pdev, p);
> +		if (found)
> +			return;
> +	}
> +
> +	/* Sun MAC prefix then 3 random bytes. */
> +	dev_addr[0] = 0x08;
> +	dev_addr[1] = 0x00;
> +	dev_addr[2] = 0x20;
> +	get_random_bytes(&dev_addr[3], 3);

nit: Maybe as a follow-up using eth_hw_addr_random() could be considered here.

> +}
> +#endif /* !(CONFIG_SPARC) */

...

>  static int happy_meal_pci_probe(struct pci_dev *pdev,
>  				const struct pci_device_id *ent)
>  {
>  	struct quattro *qp = NULL;
> -#ifdef CONFIG_SPARC
> -	struct device_node *dp;
> -#endif
> +	struct device_node *dp = NULL;

nit: if dp was added above qp then then
     things would move closer to reverse xmas tree.

>  	struct happy_meal *hp;
>  	struct net_device *dev;
>  	void __iomem *hpreg_base;
>  	struct resource *hpreg_res;
> -	int i, qfe_slot = -1;
> +	int qfe_slot = -1;

nit: if qfe_slot was added below prom_name[64] then then
     things would move closer to reverse xmas tree.

>  	char prom_name[64];
> -	u8 addr[ETH_ALEN];
>  	int err;
>  
>  	/* Now make sure pci_dev cookie is there. */

...
