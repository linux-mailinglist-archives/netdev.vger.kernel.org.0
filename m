Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8BA68A9D1
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 13:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbjBDMxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 07:53:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbjBDMxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 07:53:36 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2134.outbound.protection.outlook.com [40.107.212.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AEF824128;
        Sat,  4 Feb 2023 04:53:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JVWET/mJrfhxB6hD9XQ1EhgRAyHePZgeabhV8Fkxe/2kchXQliIRB/icf2fUIHSpbVUXJBgfrw7ReGL4fbB4OXYLUxhSIriQiL1falfcufDGD51uvdawyxKYrmC4K9aBHilfgdQo+gJvB6iQJHvqPGSfYoyGyX8I4juczrGXbZyMiL7JyHDZ04Kmqd+GI+3NA4gOOKvLrOAJmbGnqZgGak1XagDKLZ9LwTFZRWg6FU0kgQ/eZj3rAaxuswHMXqiUtaFuO2MgEAwdxwVUbsSlX0XFE5L5Cp26t2+FptoV488bp0YfwUyep2rOIbsFIEAK0vDd78+00BcS9XZTVCI6Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+0XJbwNikvdjc7fRb+ctINhGj0e9qxWK5xSmNj/KDRM=;
 b=GQUvC3nBayVAU3LsuhD/5XLnCeBVhuoHDlMpKN5UZ7I+uOsMp0/Kg1pshSLTLjojpSYVfeTKp7JXfGD2n21fBWfHbNNbLuCoF2Rw8hcoo64l9pwGzTK4YVZj8rCu6w1Ee5JcODZsesATZ3ihyZUl+Y0Nl0sE6Jv+bAeact/Dzac28F4s3sTEKvR8sKjGwshpspREvapnthPybTW83jQojPxff6XmwCOz1548eyrar9UABNtMLGnxyhsIH/F6znJsvTtvwdlQpUjtJucx7zvRCeBtFTsNV/RNZl/8jKwJ4/E7W6FCXXTylVac/3XJPnaRgGYvuTxT3QoMeVoI+SsgRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+0XJbwNikvdjc7fRb+ctINhGj0e9qxWK5xSmNj/KDRM=;
 b=FdOSe9v4FssG6dwtvzZQXAEJH8MguksMyHwYe7rwvI3UpxNwSEns5Hp75YcIv47Unugm2CWeTvQ+fkNbXPmyIILVD/DLeKH39h07KGji66BSuzoZ65pJeS0GkGMT6Td8kDGAZKscfqwGNCz+5lN/aubeO0xJcukk1c8SohB6BYc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB5140.namprd13.prod.outlook.com (2603:10b6:610:f3::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Sat, 4 Feb
 2023 12:53:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 12:53:31 +0000
Date:   Sat, 4 Feb 2023 13:53:24 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Daniel Machon <daniel.machon@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        joe@perches.com, richardcochran@gmail.com, casper.casan@gmail.com,
        horatiu.vultur@microchip.com, shangxiaojing@huawei.com,
        rmk+kernel@armlinux.org.uk, nhuck@google.com, error27@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 03/10] net: microchip: sparx5: add support for
 Service Dual Leacky Buckets
Message-ID: <Y95VRJWV4NfSDYUR@corigine.com>
References: <20230202104355.1612823-1-daniel.machon@microchip.com>
 <20230202104355.1612823-4-daniel.machon@microchip.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202104355.1612823-4-daniel.machon@microchip.com>
X-ClientProxiedBy: AM9P195CA0011.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB5140:EE_
X-MS-Office365-Filtering-Correlation-Id: e93276fd-8cdd-41a9-128e-08db06aed17d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: caeNUyv4aLmxRmep8bD3Dmk9c24+JsgxVHlpRF7QZI+ZIUPF89i/2NmamjR3zGTg/zdJCsgsD0DBUIw77EJzpishLjbl7p60ijjdlaw8pvLiFxXvdfAQdgpIPkCtp9BmPxSEGsDlCkgiJjj7sel8KWjvSFi4r0b5qp+/K3h2M5J6XZt1cw2xGQ6PnPCuU3YbuVqzSFCI6jXERtIfHFv48+hI4LXof5OX1KNrdMK9qA/J8s361FtfkWlmzAe+PrkefbiWvqlxrsgQUEZ+SgQLq3D71vZNWUSNquwEKQMe0lLauTNcTHpik7DzChEZFhm7N0i+aSyCU23pDYXwDObN3dwogPztwVggIgjCp4PzQA0cIQes2br5YrLmq+MDMNwfJSIprDphBf6ok3ZVEA1sVQmHT5UAl6jVfOFk5l6OFYh3X4ZZNXi+GR5IGB+hlHuyFkfjBCfBJ4BnsFwby/tMh+IVOe+BRPVH3vNvkv0YH3Xow32N5i5VwoQet6VlsQt45ScZj+jH9ufO8oHWkIsZaO0vep75UXkIxwesuKieQ9HtKsLzAtwf2NeaLZSBG8bUUYZ2fngRgPJtVf4wnU/4OVPESr7Xv1+TwLrnXv/rqmpsPVUl4IKu7HTzQShFQ7FCoxvWTaPnU/6zc91Y0OYTRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(39840400004)(396003)(376002)(366004)(451199018)(36756003)(86362001)(66476007)(38100700002)(316002)(4326008)(5660300002)(8936002)(41300700001)(66556008)(66946007)(6916009)(8676002)(2906002)(44832011)(7416002)(2616005)(6486002)(478600001)(186003)(6512007)(6666004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cFxo0ZnIUP8Y6WjDTVGw9mXSfSWzmVgSYp0EyzloIbZcgna1lN1E5T+4AIcg?=
 =?us-ascii?Q?KyCNFUo/V52GulCilz5JSlroTKwxYXHrAA/9qDP7ueQcQi9W6A85w0UBU7q0?=
 =?us-ascii?Q?Hqd2O+i8nHmAS/wHsS6V4wdV+571evGBCqRjYEFsqzC/vBh0XaquZiMy2Sto?=
 =?us-ascii?Q?jp1nH8TxNkXMULRYp2FnjOJavKq8XaF+km/6kTi7PmoDrv165jOINslkwE00?=
 =?us-ascii?Q?efDj4pC0waM8TKAytPhLV2iF4/DcE9892O0Tq7s9wV8gSO7Rx7JRp4/hv1+2?=
 =?us-ascii?Q?OWVzXopEgBYHqDx5D6X4Eb46pzLAYEphaf9zEIv3qqIpydUrHw+aypHXRrlk?=
 =?us-ascii?Q?xYqGO6b3Jrf0NyKkqTJpZnlmwnu3eEOUwgQUnd6sZH7SnqJRa9qrfDA9Lif6?=
 =?us-ascii?Q?gB2Mkfn6a2LcUAYzBuT9Dos19UwZXvzbOEuBkzvGllEwYVDmy1Rzem7Kv86l?=
 =?us-ascii?Q?/+DyeWkUAFy4Up2zIntEo5oAAiYiulRo92ci+khfyb22r+c2zEXOur3I9RX9?=
 =?us-ascii?Q?B6vNDPewDOvk9kQaZo2sEV31ZyN6HUC6iZLuwBCq+HI72yu9y7puxGWcw61A?=
 =?us-ascii?Q?VGDcG9J0YXpEpT1ipyAd2yhOaxdt1K53y7q5XrNdV4KGancQHwiduToe44Yw?=
 =?us-ascii?Q?EPpj7ej1jSHWtG6YXz0j4QK4wOyYfz5fdn/Fj6da4srsP0Oiz9XLUN/Xy6MS?=
 =?us-ascii?Q?1NKNKeyhksxumr37OTF+il+aaZ/N1A8XjHFmb3AVwAHfskCQlKHWk7OTIJ22?=
 =?us-ascii?Q?coT65vrVOlf7zr1QqzcRay0nQ1NMMTDWYDcKtWETK3SviXpMUUXII4FVhdBM?=
 =?us-ascii?Q?yzqAcR9t5c6nxp5Tkg/qPip2J5e5d6ifSkty1ik8kfDshe3g9fUAXphKH8fV?=
 =?us-ascii?Q?0SYC1lGFCM5b4so2UWz3MKW8djpMsYWtFgZoO0CFqKwmkzQHVZdDQG1Z9tO3?=
 =?us-ascii?Q?V9HCLhla946/7P1xWwikJcARl3wFQ8M6H+wvGWs4I9TTO3ME9hOz8Brv4MSu?=
 =?us-ascii?Q?hJnwDXLW2VOgu87bNwgPeitH8VzBbZJnTZMTgK9OhzWUX6G4VVArJYCtTfgn?=
 =?us-ascii?Q?RS3vGAdVfmlUokCDdWLhjxjYwvA9XWThqoCGLD4NoW//nfHamgmcOzeg5Uf4?=
 =?us-ascii?Q?Uwc/J+APc5q+Vn3mJ0JznWBlwQwz/XnztlS3CY+NkBesEEcvKsUIGQEzidpo?=
 =?us-ascii?Q?EdA3eMgTwJ3kaB0F07cX3e2fukmME7WjbxgRU4pT+WAxc3Jwt1m/LIEKikne?=
 =?us-ascii?Q?zExzarhTEEmw7IlHfAmyhC6RRFq215cCHD/oI9xgdZ6c2em3bUP1zMKY3JJQ?=
 =?us-ascii?Q?hCdnCEnjvwT/hK1lpiHFgsmySOhlEJTIJNtgL4xMFE4RRIeDDSjc0dm4RnKe?=
 =?us-ascii?Q?rtVZ/zsiM5RQ6ffPC7rW1t0EqTId73hcZ3pI7Af11FA0IS38cIEmlSoqq6ES?=
 =?us-ascii?Q?zfVZLuWiZ55ioLqCeoiu995Ty6YHshGtydyYTu5JFdXXDXCOcSgYteWw7LTm?=
 =?us-ascii?Q?Es09pVJZJKLO9p+/TLLjsqyl9GWXEWG+/zM84qiEMjdS0hjrQRnJ7F8ffBPn?=
 =?us-ascii?Q?SXnZciAaiF2z8aurxXKfWgky5Lzxzz1dJAzd1ZTvTeKIX6RvxK9NAeogs1Ga?=
 =?us-ascii?Q?VYL54ZZQzCLB/Ob6V2vwcBhnnYb5fuaRgrN0Gz9lRGVw9jOFB+yhUna4fmKZ?=
 =?us-ascii?Q?P+whFA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e93276fd-8cdd-41a9-128e-08db06aed17d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 12:53:31.5673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TRVmdNg1s+J7rZbFhvySJv96cWPzcGfz/wNrHvCLFpYVw0x2LUzXqVuia+GY/zTk66NP9dUto/BBUCa4mkTDUxYh53fz0/hwiGWPfEUz64k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5140
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 11:43:48AM +0100, Daniel Machon wrote:
> Add support for Service Dual Leacky Buckets (SDLB), used to implement
> PSFP flow-meters. Buckets are linked together in a leak chain of a leak
> group. Leak groups a preconfigured to serve buckets within a certain
> rate interval.
> 
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

...

> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_sdlb.c b/drivers/net/ethernet/microchip/sparx5/sparx5_sdlb.c
> new file mode 100644
> index 000000000000..f5267218caeb
> --- /dev/null
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_sdlb.c

...

> +static u32 sparx5_sdlb_group_get_next(struct sparx5 *sparx5, u32 group,
> +				      u32 lb)
> +{
> +	u32 val;
> +
> +	val = spx5_rd(sparx5, ANA_AC_SDLB_XLB_NEXT(lb));
> +
> +	return ANA_AC_SDLB_XLB_NEXT_LBSET_NEXT_GET(val);
> +}

...

> +static u32 sparx5_sdlb_group_get_last(struct sparx5 *sparx5, u32 group)
> +{
> +	u32 itr, next;
> +
> +	itr = sparx5_sdlb_group_get_first(sparx5, group);
> +
> +	for (;;) {

Unbounded loops like this give me some apprehension.
Will they always terminate?

> +		next = sparx5_sdlb_group_get_next(sparx5, group, itr);
> +		if (itr == next)
> +			return itr;
> +
> +		itr = next;
> +	}
> +}

...

> +static int sparx5_sdlb_group_get_adjacent(struct sparx5 *sparx5, u32 group,
> +					  u32 idx, u32 *prev, u32 *next,
> +					  u32 *first)
> +{
> +	u32 itr;
> +
> +	*first = sparx5_sdlb_group_get_first(sparx5, group);
> +	*prev = *first;
> +	*next = *first;
> +	itr = *first;
> +
> +	for (;;) {
> +		*next = sparx5_sdlb_group_get_next(sparx5, group, itr);
> +
> +		if (itr == idx)
> +			return 0; /* Found it */
> +
> +		if (itr == *next)
> +			return -EINVAL; /* Was not found */
> +
> +		*prev = itr;
> +		itr = *next;
> +	}
> +}
> +
> +static int sparx5_sdlb_group_get_count(struct sparx5 *sparx5, u32 group)
> +{
> +	u32 itr, next;
> +	int count = 0;
> +
> +	itr = sparx5_sdlb_group_get_first(sparx5, group);
> +
> +	for (;;) {
> +		next = sparx5_sdlb_group_get_next(sparx5, group, itr);
> +		if (itr == next)
> +			return count;
> +
> +		itr = next;
> +		count++;
> +	}
> +}

...

> +int sparx5_sdlb_group_get_by_index(struct sparx5 *sparx5, u32 idx, u32 *group)
> +{
> +	u32 itr, next;
> +	int i;
> +
> +	for (i = 0; i < SPX5_SDLB_GROUP_CNT; i++) {
> +		if (sparx5_sdlb_group_is_empty(sparx5, i))
> +			continue;
> +
> +		itr = sparx5_sdlb_group_get_first(sparx5, i);
> +
> +		for (;;) {
> +			next = sparx5_sdlb_group_get_next(sparx5, i, itr);
> +
> +			if (itr == idx) {
> +				*group = i;
> +				return 0; /* Found it */
> +			}
> +			if (itr == next)
> +				break; /* Was not found */
> +
> +			itr = next;
> +		}
> +	}
> +
> +	return -EINVAL;
> +}

...
