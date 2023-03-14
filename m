Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A98CB6B9B3F
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbjCNQX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbjCNQXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:23:16 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2126.outbound.protection.outlook.com [40.107.243.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E400B3728;
        Tue, 14 Mar 2023 09:22:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BgjrnXs3INLRFQmwtfMbjRLCvue5SBopqZddHpFxgBP0Oph37Er7VbMx3T4jvAprqfIveJppsImTOZmVWf0VeZatu2ws9rDDLv2bp/R9Ih7+sSmV3uyda/otHlaqdWmSjn1zLx0OvJS8nAvJRMqhFrIrX691+VCJYNYeoMtQ85sof/5gyPgRwNHls7qkGohXUTbE8VQ8iRHdgMiiyQUChlsUawJP9cAdVI4xWJQtAXZEer1JoxdOMkbywUZSLtsTbOv6OU8V8Uyu+ApSHso1WB/RVXbk+dZN9YnAUzxwAQ7kD2p6wTSeIXILlLpJ09srViCzDYvORaVSZ1/V2cbBOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Is7zNI4Aswa6XomO7soX2/GDpFvELdx93MBBhcHbkz4=;
 b=SlKWFkco1rTMLLTt1v+aqSmW43fEi9x0eAAsFgXmtV5zGoO3BHLsaP3kxymaijoQNqJxqmDuy3izQOTIWwMA/xjvL50oIz6DKKD1GUUNXAdLhAFOfDlrkgi+xBQk99PtWuIpr1r2JoBIN/yk/IKLkkn89uYFw4mvqSu/OGNgjUxmBd9ABqs4Lb5jCO7I5mhWH315M7d/j/oYWMIgrMcE1UjitX2a9bOwKbsTFo326aAe0db7p9/9Pdflq9hlQQTjXqeLQDUpzZmCjJsLLTnwDWQpQBmasWV5jrP0tlkjqyrPh4UCBL9rEr2n2Z+oVhbjJiwTeQFZ73Rt2JqSuK0M8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Is7zNI4Aswa6XomO7soX2/GDpFvELdx93MBBhcHbkz4=;
 b=udleYIFXR7XzPTCba2ch7cOwCYweBHREk+/Ze6XsLFFYUCs4xNPEpPBBWXy0gemOZGnqIe1GAqwYxtowHN7ndVEBuMgqtTNy43L2KntKFC11Je5kRV/UKGzZeYrJ0UU+S9VqwcvQd87pNIJ7XXGTg5gEMciPKfx0x3ViwtfXiVQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB6122.namprd13.prod.outlook.com (2603:10b6:a03:4eb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 16:22:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 16:22:08 +0000
Date:   Tue, 14 Mar 2023 17:22:02 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] can: tcan4x5x: Add support for tcan4552/4553
Message-ID: <ZBCfKhPZrIMqvmbO@corigine.com>
References: <20230314151201.2317134-1-msp@baylibre.com>
 <20230314151201.2317134-6-msp@baylibre.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314151201.2317134-6-msp@baylibre.com>
X-ClientProxiedBy: AS4PR10CA0025.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB6122:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a6b4624-6dd8-40f6-a039-08db24a841d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ik/A1Edp0egbkPvhW9/tqwRpEwAJVmzp8c/2BWCaUJferP9gHrSHDux9Go2eOGsUaO1uhdqhwVKUm8EffVyBCWOHX6ILk21VnnDK8mdqvG1j6Gp+eyH3/9Frei2hZuA6EFJhIizXzPU8oY9HhavPJYlBWd6FIfTPRMgUZ1b8SXAQazoCVD3Bt36L0tYjIP0maZW6v6QPnZTv23QzvBWqfeoEg4YKuzCClgEJbYz8CbiBehT1ctZvZwZFm2fS9aC0Lswm025QUkwNJ9vAvJPI6anqouppz0Md4njgJOvWaTqP4nG5FFE7lxII4e/nji4bYFBuVfIrf/O8eZie69o6+ntlA8BUXRcF1dEfqGG3x1bmcO9i088fZb4HXfiCJnaTVWxlCTn5bkabsbdHZPDaEZD4kf3r4ljdDb0QzT7glgo9ffRBAL5Br9ujxIrOLYZwyaXCOAkvVjxfHNNy5D4r4M4dfBeZXohKEctwTOPFtRsNx20PHzjO4gPLijIUOt1EUX1ytmDBrBqjcXDvlUXBYBcOjlz+DWPwVSB8fh/RoPek1TcoRNoUzaePQcw+fw/F6Bn9rmRGncil/23OuTnWEa3cHM6WO0iuil3SULND8Dbeeew1YNZPw491gN7kAPhZcx5d+Wcf7z9zCh4C/nyeIWN5gxLx/gJeW2BIWpZZ9KXhzZTD+0BXOf3fU0/+iHoq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(366004)(346002)(39840400004)(136003)(451199018)(6512007)(6506007)(2616005)(186003)(6666004)(44832011)(2906002)(6486002)(83380400001)(7416002)(316002)(54906003)(5660300002)(66556008)(66476007)(6916009)(66946007)(41300700001)(38100700002)(36756003)(4326008)(8676002)(478600001)(8936002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?053tMdapkSLor23vzhGwFV7N4TTmjtmqAwr7MzTNHCRbYnqUDOwUFyQN4L06?=
 =?us-ascii?Q?USXXQvlF26ONFuufP9ip347hgoFRMAsaVTCHU8F1Y5WXIqTJT2eFCNgxIy85?=
 =?us-ascii?Q?K5jD4nQdg28XnP6FknuJtHNklyNMpKKkVEUQJ0BXe2h4ZjHdcl1BhUWpEfcE?=
 =?us-ascii?Q?UGQaijNfBNTo1cNglBBGP9qB+xUcMoIDcC2i9fpkidF0pZ6vTxGgUpxpgdxN?=
 =?us-ascii?Q?PVlXbg1/hDTPmzCcxY2ICouNJtCrkp5qnkMeQtiopWFck4p+emMALCCX3Hea?=
 =?us-ascii?Q?yI3GRlvzYht2LMLWki1JXpDGldmby2X5GNM7HOvk5gskp76iawBGfVkbd3/c?=
 =?us-ascii?Q?EbQO2Oa28kV0fZLnNAOMp8gNsaV3vrRASWbA0tbGyiM7WajqZBpT7ngCjQ8u?=
 =?us-ascii?Q?io/0xEKDJ+Z07W/DoUi9ysytzWj5AHNWB1nCE1Vjx9+BeaTrJRd1b3eDJkCn?=
 =?us-ascii?Q?TkZ4R5O5HACDr/TvZAClta4FteV2HEvBjTaqi38wJ34BVh3Nnb0VkBLs8B+/?=
 =?us-ascii?Q?y5Ox95Qb6LRljTz9YTl+99FZbGuTY4SWc2CFn221JW0wOV/QjWkM5+ByGmlm?=
 =?us-ascii?Q?flQYjjBsb4JY41XRstbanVxv9Cw+MwEzWyyymPAvglzUHn4qNClImyv1jvw6?=
 =?us-ascii?Q?Ps1zasBx3HuwyYzug03etlW8EoeMwmDjDtIbkZPjtJMyjj5LKv0euM1VikCY?=
 =?us-ascii?Q?hzFB0FSGJ4Wj+KiB5EgoucXh9CP4qNDn9Rg6uGlcuGcyWJFfl+sdq0+SF9nj?=
 =?us-ascii?Q?QqT9FpfKMwDyp8bCEumWv0ztsGqnY7nvo8Abt/L3aaPspEismSeKykcsTX5z?=
 =?us-ascii?Q?f2nRjT9UB6g+CD3o7fhqmwmDsbJFYl7xwiplTVYXlh7HbbcDmnA88dOM8SIm?=
 =?us-ascii?Q?nfl5w9U/hYtNFA03O3FsXurKTpllimCK2y+fp+unU+frrsoU5fMaTOwayhUH?=
 =?us-ascii?Q?8qjrEAGmQYdavXjZ76+lmUJcUVPGhkRV5Ul07v9zNaRui7i+PdVXzyAkbI97?=
 =?us-ascii?Q?07oD3Ixgiy82opanFx4fO6Y0aGFXPkw0NHOzusPf2Ed6xp4awtjlCS03LvHw?=
 =?us-ascii?Q?bf26Q5W4hVZp3ZSsCGioTtGwecPqw/ZtZqDzSPUH36zsN4zj+gWRRD+Y6434?=
 =?us-ascii?Q?0ONMCSBEREjgwKMqP83hW7y7ZOaFC2gX4KKVZq/AtU0TJ6YTL+GhkA56Im6K?=
 =?us-ascii?Q?ZmS2adm8c4uLtFtSTw7lbNcUAAauoMyegFXdssuEeWlBio6nEgefm/HH34Wh?=
 =?us-ascii?Q?0cClU87HlpfX/TUJHDuCVVfUT9gkGR5eOQXBLRCgoxRhJI5Ee4yZitWGEWNF?=
 =?us-ascii?Q?qlp/LsvboNa0TUY73ABg026bnmPg3fsvRjdc9hxxW7Ba6/EXIZgubkF50sLu?=
 =?us-ascii?Q?gC/dWeBkHP4y8EKfM8sI2rle8GOw79uf6OqVCeGpeKf/WZBZYD+3gkudnBod?=
 =?us-ascii?Q?6QjY8/WvGwZ8Y2lt1txp5vY8lAw+bSzxKBhTrLcnilz8Kdea+xF1zCoehbbM?=
 =?us-ascii?Q?NbqTZQnaHI8RAMuP52TVAvBPOCcZMIhPoVIJnAAdmeG9g279owDJHffeWZdZ?=
 =?us-ascii?Q?Mx9SlUDDit6YVKu2FFgvttQiv3xwDA+1VJhmNwo+vC5IdzIRWJYOi4MpIVId?=
 =?us-ascii?Q?GjOHWagZhucHewIjjn0aLEjDxAKVUmlY9wHg7+Udegk7F5ysVEj//CbtVjk5?=
 =?us-ascii?Q?lNiUQQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a6b4624-6dd8-40f6-a039-08db24a841d9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 16:22:08.2193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dv/gZ22lV5wYJoIr6s9VXsA3U0JHItS2ZasUm8IetnZfuwERBEXKEwoJh3Ax3gfpXtGyGUCFoHufiNwO7rUMwq6mSP/mjgpmrUJole8wtH4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB6122
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 04:12:01PM +0100, Markus Schneider-Pargmann wrote:
> tcan4552 and tcan4553 do not have wake or state pins, so they are
> currently not compatible with the generic driver. The generic driver
> uses tcan4x5x_disable_state() and tcan4x5x_disable_wake() if the gpios
> are not defined. These functions use register bits that are not
> available in tcan4552/4553.
> 
> This patch adds support by introducing version information to reflect if
> the chip has wake and state pins. Also the version is now checked.
> 
> Signed-off-by: Markus Schneider-Pargmann

Hi Markus,

you forgot your email address in the signed-off-by line.

> ---
>  drivers/net/can/m_can/tcan4x5x-core.c | 113 ++++++++++++++++++++------
>  1 file changed, 89 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/net/can/m_can/tcan4x5x-core.c b/drivers/net/can/m_can/tcan4x5x-core.c
> index fb9375fa20ec..e7fa509dacc9 100644
> --- a/drivers/net/can/m_can/tcan4x5x-core.c
> +++ b/drivers/net/can/m_can/tcan4x5x-core.c

...

> @@ -254,18 +262,53 @@ static int tcan4x5x_disable_state(struct m_can_classdev *cdev)
>  				  TCAN4X5X_DISABLE_INH_MSK, 0x01);
>  }
>  
> -static int tcan4x5x_get_gpios(struct m_can_classdev *cdev)
> +static int tcan4x5x_verify_version(
> +		struct tcan4x5x_priv *priv,
> +		const struct tcan4x5x_version_info *version_info)

nit:

static int
tcan4x5x_verify_version(struct tcan4x5x_priv *priv,                                                     const struct tcan4x5x_version_info *version_info)

or:

static int tcan4x5x_verify_version(struct tcan4x5x_priv *priv,                                                     const struct tcan4x5x_version_info *version_info)

Your could make the line shorter by renaming the 'version_info' parameter,
say to 'info'.

...

> @@ -394,21 +448,32 @@ static void tcan4x5x_can_remove(struct spi_device *spi)
>  	m_can_class_free_dev(priv->cdev.net);
>  }
>  
> +static const struct tcan4x5x_version_info tcan4x5x_generic = {
> +	.has_state_pin = true,
> +	.has_wake_pin = true,
> +};
> +
> +static const struct tcan4x5x_version_info tcan4x5x_tcan4552 = {
> +	.id2_register = 0x32353534, /* ASCII = 4552 */
> +};
> +
> +static const struct tcan4x5x_version_info tcan4x5x_tcan4553 = {
> +	.id2_register = 0x33353534, /* ASCII = 4553 */
> +};
> +
>  static const struct of_device_id tcan4x5x_of_match[] = {
> -	{
> -		.compatible = "ti,tcan4x5x",
> -	}, {
> -		/* sentinel */
> -	},
> +	{ .compatible = "ti,tcan4x5x", .data = &tcan4x5x_generic },
> +	{ .compatible = "ti,tcan4552", .data = &tcan4x5x_tcan4552 },
> +	{ .compatible = "ti,tcan4553", .data = &tcan4x5x_tcan4553 },
> +	{ /* sentinel */ }
>  };
>  MODULE_DEVICE_TABLE(of, tcan4x5x_of_match);
>  
>  static const struct spi_device_id tcan4x5x_id_table[] = {
> -	{
> -		.name = "tcan4x5x",
> -	}, {
> -		/* sentinel */
> -	},
> +	{ .name = "tcan4x5x", .driver_data = (unsigned long) &tcan4x5x_generic, },
> +	{ .name = "tcan4552", .driver_data = (unsigned long) &tcan4x5x_tcan4552, },
> +	{ .name = "tcan4553", .driver_data = (unsigned long) &tcan4x5x_tcan4553, },

nit: checkpatch tells me that no space is necessary after a cast.

> +	{ /* sentinel */ }
>  };
>  MODULE_DEVICE_TABLE(spi, tcan4x5x_id_table);
>  
> -- 
> 2.39.2
> 
