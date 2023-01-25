Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2DA367B4DB
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 15:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235746AbjAYOiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 09:38:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235722AbjAYOik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 09:38:40 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2122.outbound.protection.outlook.com [40.107.93.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2D327D4A;
        Wed, 25 Jan 2023 06:38:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kAzpLS0tzWGZHdpG16SfUS5Gfo1Lb/P9zv4tg4Uh7YsctRbgYb2K8LJ8HnfojtH26QZ3zW3Y75i7T9xYuxOcfIotO1EOH2nGgak6C1JnILsCuAVL7twtGcnwjFoV2FdzjBKk9vaQ/nBs+LjLL80E4o4Z9iChwAi1RdDkKBLgrQs3K9vzCYMv6nhl8Qprjx7r0rOTfVJHJNk2Pgc746uoJheovR8JynTCPWlKvcFIk0i1XEj/ok8ghl+LPP3YFJaqTTU4h7PFujYvQGeggqeFxEuMdZRECNswyy2LnGk75T6HDKlmF4ln+SLIaW59XT5nYVnFwP7x6Kv1pWPaICvrEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9x6g+kUuawV9ExhkT2ST7ySy3ZXJzAKp3Z5OLulAAZQ=;
 b=JpDa+KTk06dvzndTdst9EQMfaDWlbYVX5g4UohlwdWyWvdq83YxBCO2ry7YOUeXRGmoW6ZM/dvDBOLa0ZbVEEg6ufmRjfHlboQXM8wTafMJz1XqmVVu34rMAOAW3jVMNP/VXCO7kKsXxayTUzstPZD02pG0G9SstlmyZ8T+9VnYG6BAugyTAP+NyMf7TNbW46AswDxpBIJa3m0MkSgtkQKjskdueYD2z1+okiCvhFQcrm5fjsd1/5LZHxTwaXjzNUVMiRx5EPsIf3elSzZ4IRFZffOUhWmMa2uzUY8ousy95hoyji/fZev2AN+pVf16STDUFCm4NCNYm1F+uoBthbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9x6g+kUuawV9ExhkT2ST7ySy3ZXJzAKp3Z5OLulAAZQ=;
 b=p8gUBo0EMEO38xGQKzxwLbrob8pMxm5IgAGikIII4Xv2ngGYIeJCL8VI1eYiT5Ywwj2ohstv28IoiiddD49ooZ+3wm6Q/+PS5r9ZKRRhymxGNfH36sG4oihPkhY3CrM5CXGnfOKaulYrH7KgdXxPKJR6uF9uiivFyqtbn91h5+U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5634.namprd13.prod.outlook.com (2603:10b6:806:231::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.20; Wed, 25 Jan
 2023 14:37:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6043.021; Wed, 25 Jan 2023
 14:37:07 +0000
Date:   Wed, 25 Jan 2023 15:36:57 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Min Li <lnimi@hotmail.com>
Cc:     richardcochran@gmail.com, lee@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: Re: [PATCH net RFC 1/1] mfd/ptp: clockmatrix: support 32-bit address
 space
Message-ID: <Y9E+iXjve8JP6be4@corigine.com>
References: <MW5PR03MB69325F46D3E3B6473A228D1FA0C99@MW5PR03MB6932.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW5PR03MB69325F46D3E3B6473A228D1FA0C99@MW5PR03MB6932.namprd03.prod.outlook.com>
X-ClientProxiedBy: AS4PR10CA0025.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5634:EE_
X-MS-Office365-Filtering-Correlation-Id: 386801cb-d520-43db-2359-08dafee1a29b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jhcp5422YCZ8ZTSA/+f7GHyJlbXL6Rqz9LnU/R+AViNdnye8jRD8N6Dmvedhqv0Q/Qui6kDEVbZnGmG8W/MQBQ3dCVyajd4K8fodgxoJs9r8Bv/zk8OAE35p/qRdNAmDs8fADw4eobMct82YHE55kI0hpwQ76J0/2CVC19uD90RlAsIcUPIAzEe8oT+Olui2WjyywFwmF8gwNVZlwEu3hLiXDz9AmMeotV6HleFyB+TGljxppEoUaM3YEDDp3xQ4uq+YUxLoURTswqQi//dlibhZi9aaDEVAAiA9Boj0jmaQ4ugRDSqL5HNpHa0aZXJMRsxWWdY8UIFWQCbLcup58iBZ8tp+78fBQRwN0DrIFiIcz/7EgI3oW1Jkc6kMsalrazRo9FMrp20ZnbJ64algeJp01P4Z8unF+Lw1/e+VxMiDK27532iFSl9MHwsXoC1aUBu61LQ9ze4U0P2ENBCPx2911qWJtYZhvCtDuOXeWc7PixMY8AsoSump1Cum0V0myKrTLJH4JhQpCq3Dd4JlCztT2BNBVCiG8FcM9hYDDySmdVxkarys8M1veEO54rJeMlvMQ4p9D+UNgoNH9WiCfjhC8DD4CLoCh9O3h4vAmUTTUPRxnnnrSYwfcJICvmwoO2jG9L2HcAtlnQJQLUh2Fkcy9fIc9KMoofHkqRiL3TaeP9vYD2bA6UpGlfzirYhRAKluIIrClnQ4MdVbc8OScolVV/XYQt1AVpGuv1sS6PUPFSSNxC7OIIL0N3njbw5QBJPGE9OUvffFkdYlcx/uXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39830400003)(366004)(376002)(396003)(346002)(451199018)(86362001)(36756003)(316002)(66946007)(66476007)(66556008)(478600001)(6666004)(6486002)(2906002)(44832011)(8676002)(41300700001)(4326008)(6916009)(8936002)(6506007)(5660300002)(2616005)(38100700002)(186003)(6512007)(83380400001)(87944009)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nCJe6ZoyANSLyq+4+HiWiVhkmOkMCQEDjEuIPRBjZPUxb51CphJhUZfPsC36?=
 =?us-ascii?Q?+autsAnKfPRlCLZIA6EkzIKz9jKHx1HMx4zF8A3BZgrfVdurqIPaVog+rrl4?=
 =?us-ascii?Q?vivIFP1cToFZmmDXg4qCCbkaZv8mYpsXSIXz+aOqAhBNnhKQu6ssIM9VWKVV?=
 =?us-ascii?Q?w+EwimmnFRBU9fO0NWlvXlDG3I5dXumCXZQKTKP6uaEYTMfSuyBKXnc/9v5X?=
 =?us-ascii?Q?q7GXRBz3QPjv/ESw0bvzgsP0Q5O1u88eoPLkEvp/1N+oRbfHPeRa8T0m/ra1?=
 =?us-ascii?Q?7R714kLjm5MK0pvlBgsP749Che7wFN8cVKhJdog4b3D/bayzXZwliSctglWz?=
 =?us-ascii?Q?i9PDb47lfswH/hdtn12dzek27dIjYQUelPES9ZZHl0er9XXHe2V69ptj2zjg?=
 =?us-ascii?Q?FMAu5U1534NdT9sEi0XU/T3xyuZaXoPGMmZkaYEgHAhJlKZYIoil+Nww5Qnt?=
 =?us-ascii?Q?0jmZ7qmIWSdd1TwLl+ObjE4FdUfrhycXph2wBRPJEtiHLAYegZ6ZCG/JODVF?=
 =?us-ascii?Q?UJrVP9Yu/xh79VZg0wPo1veM5G3rTLrFDxkyHZA0yVrVjgGf0QAmL0/jtpP1?=
 =?us-ascii?Q?BpVGAqnRHrBnTADWq5BZUwwNYTqngCQaIMAOLXLMdeiyDI2wXm0H2LwSmTqT?=
 =?us-ascii?Q?dXbcmkg3iHgFJQohgq+b2CQe7JITcfxGcow5g6pEKfYFYYHwHtAuYEGJxFoV?=
 =?us-ascii?Q?jHpv+41o4Rbgena0/1hnObSxA5PHuRi5VbPiXuGm7T/kNAVYS6QoFtcWCVsw?=
 =?us-ascii?Q?AExT3HK1JWwy2qdTgj+iQyKh4A2djjvnI6JYbHSfBVQLvzh3x6TMOblPqPYd?=
 =?us-ascii?Q?gqjUFpbxBYcbBBW5e48XgHKZIpR+eS1cR9Ac5fCKwCFZ80s4tD/rxshLRpE+?=
 =?us-ascii?Q?6hcc/nxxn4u4tLbQh0h+qeedZwShq3OkfGP4rwJ4ws6Mxo5f8PY8RXcnuqTY?=
 =?us-ascii?Q?5z3Px7qM0sK0KpMgK5wYhXXKRi6j+6gHQPDn5BlITExQ7MKh3mM9vgquBHNq?=
 =?us-ascii?Q?+pFOhUyhEvcOe6oQQW9uIIEog/ljYXLe1+ewEgMm+tZbFHfJmY6oUhEtW5KY?=
 =?us-ascii?Q?L/f7J5TuMsY0iW34HnsHiwRJ4ANqNrZYc6G/4XJbD4yMPeCP57zwC3JUlWi4?=
 =?us-ascii?Q?JPVp6KzDArV46KWebjywuI38gerOOg8jxSf9KBjf0hIvxM7MJKdsmjtIVLR6?=
 =?us-ascii?Q?raXhKo9KZJGAn570qJ2qB44wtXMYxReFsfhFjzn9xhyTJyODKb+rZVWd8KgK?=
 =?us-ascii?Q?QThjv7gTDrPD6HL96b80QxCFIqfll8knzGDDAEWn9/y1H/HM6JKnH80kqoRh?=
 =?us-ascii?Q?KQp79OyIyBFk+AgANSDXTtD1doR5cr/+WvLAOYF2/PbT2gRw23iFmlJzp6ux?=
 =?us-ascii?Q?dbzGwPNFMJCtfo5GEOgDxs791DeompYnrsDAOuyjvddn6oF+Fq3NP6lzK+Zy?=
 =?us-ascii?Q?NpvGJrR6WD1fB3CJtf1tEuKB2o/MOwfSv6s7TWNy+bdW4CSOl9LGPM7wpfvE?=
 =?us-ascii?Q?TAAfF1uK30wlPo3X56GNIcO2eP0T3RmrkOayadxx8EEFKDyPBDHbxl+i8YKA?=
 =?us-ascii?Q?DOXyyUdGL1UVMzJrokvcICWcKsL758LsOV+oX7oviaYf3C6FofOV/+b10k10?=
 =?us-ascii?Q?ZFWlP2ZeHLeTaJ5GbpNLA/2wvsa1+kQLyRTkFjR3bYW2qTA/kYIQbWthSZ/v?=
 =?us-ascii?Q?cf0ycA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 386801cb-d520-43db-2359-08dafee1a29b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 14:37:07.8018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wG4v9z/uakPJI1G13p16jCDkD56zN0aFMEzDbdtYg32Y/c1blvsFTatJuAdagZScYB1TrKSXcZPSh9fJKDLeOMi819wB2OZzuzooDc1FBdE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5634
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 10:41:09AM -0500, Min Li wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> We used to assume 0x2010xxxx address. Now that we
> need to access 0x2011xxxx address, we need to
> support read/write the whole 32-bit address space.
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>
> ---
> This is a fix that involves both drivers/ptp and drivers/mfd. I made the
> patch right off the net tree but I am not sure if that is OK with everyone.
> Please suggest what to do if you think otherwise. Thanks 
> 
> 
>  drivers/mfd/rsmu.h               |   2 +
>  drivers/mfd/rsmu_i2c.c           | 166 ++++++++--
>  drivers/mfd/rsmu_spi.c           |  52 +--
>  drivers/ptp/ptp_clockmatrix.c    |  51 ++-
>  drivers/ptp/ptp_clockmatrix.h    |  32 +-
>  include/linux/mfd/idt82p33_reg.h |  11 +-
>  include/linux/mfd/idt8a340_reg.h | 546 ++++++++++++++++---------------
>  include/linux/mfd/rsmu.h         |   5 +-
>  8 files changed, 504 insertions(+), 361 deletions(-)

Hi Min Li,

In the same vein as Jakub's comment, this patch is doing a lot of things,
it is large, and it's not clear from the patch description what
it is fixing.

My general feeling is that it seems to be disambiguating support
for two different devices. And correcting support
for at least one of them. If the latter is true, it may well
be a fix. But IMHO it is far to large to be considerd for stable kernels.

My suggestion, FWIIW, would be to:

1. Break the patch into separate patches.
   F.e. 1. for 32bit address support, another to shift #defines around,
   another to add/fix device support.

2. Target this change as an enhancement, i.e. for net-next if it takes
   the networking path. Although I'd also consider if it's more appropriate
   for different portions to be taken into different subsystems.

> --- a/drivers/mfd/rsmu_i2c.c
> +++ b/drivers/mfd/rsmu_i2c.c
> @@ -18,11 +18,12 @@
>  #include "rsmu.h"
>  
>  /*
> - * 16-bit register address: the lower 8 bits of the register address come
> - * from the offset addr byte and the upper 8 bits come from the page register.
> + * 32-bit register address: the lower 8 bits of the register address come
> + * from the offset addr byte and the upper 24 bits come from the page register.
>   */
> -#define	RSMU_CM_PAGE_ADDR		0xFD
> -#define	RSMU_CM_PAGE_WINDOW		256
> +#define	RSMU_CM_PAGE_ADDR		0xFC
> +#define RSMU_CM_PAGE_MASK		0xFFFFFF00
> +#define RSMU_CM_ADDRESS_MASK		0x000000FF

nit: maybe using GENMASK is appropriate here.

...

> +static int rsmu_write_device(struct rsmu_ddata *rsmu, u8 reg, u8 *buf, u16 bytes)
> +{
> +	struct i2c_client *client = to_i2c_client(rsmu->dev);
> +	/* we add 1 byte for device register */
> +	u8 msg[RSMU_MAX_WRITE_COUNT + 1];
> +	int cnt;
> +
> +	if (bytes > RSMU_MAX_WRITE_COUNT)
> +		return -EINVAL;
> +
> +	msg[0] = reg;
> +	memcpy(&msg[1], buf, bytes);

nit: This is easier on my eyes.
     Especially in relation to the other '+ 1' in this function.
     But perhaps it's just me.
     (*untested!*)

	*msg = reg;
	memcpy(msg + 1, buf, bytes);

> +
> +	cnt = i2c_master_send(client, msg, bytes + 1);
> +
> +	if (cnt < 0) {
> +		dev_err(&client->dev,
> +			"i2c_master_send failed at addr: %04x!", reg);
> +		return cnt;
>  	}
> +
> +	return 0;
> +}
> +
> +static int rsmu_write_page_register(struct rsmu_ddata *rsmu, u32 reg)
> +{
> +	u32 page = reg & RSMU_CM_PAGE_MASK;
> +	u8 buf[4];
> +	int err;
> +
> +	/* Do not modify offset register for none-scsr registers */
> +	if (reg < RSMU_CM_SCSR_BASE)
> +		return 0;
> +
> +	/* Simply return if we are on the same page */
> +	if (rsmu->page == page)
> +		return 0;
> +
> +	buf[0] = 0x0;
> +	buf[1] = (u8)((page >> 8) & 0xFF);
> +	buf[2] = (u8)((page >> 16) & 0xFF);
> +	buf[3] = (u8)((page >> 24) & 0xFF);

nit: maybe this is simpler (*untested!*)

	le32 data;

	...

	data = cpu_to_le32(page);
	err = rsmu_write_device(rsmu, RSMU_CM_PAGE_ADDR,
			        (u8 *)&data, sizeof(data));

nit2: I also notice this pattern is repeated.
      Perhaps a helper would be nice.

> +
> +	err = rsmu_write_device(rsmu, RSMU_CM_PAGE_ADDR, buf, sizeof(buf));
> +	if (err)
> +		dev_err(rsmu->dev, "Failed to set page offset 0x%x\n", page);
> +	else
> +		/* Remember the last page */
> +		rsmu->page = page;
> +
> +	return err;
> +}
> +
> +static int rsmu_reg_read(void *context, unsigned int reg, unsigned int *val)
> +{
> +	struct rsmu_ddata *rsmu = i2c_get_clientdata((struct i2c_client *)context);
> +	u8 addr = (u8)(reg & RSMU_CM_ADDRESS_MASK);

nit: open coding this twice seems like it could be improved on.
Perhaps a helper (macro) would be a good option?

...

> @@ -136,7 +232,11 @@ static int rsmu_i2c_probe(struct i2c_client *client)
>  		dev_err(rsmu->dev, "Unsupported RSMU device type: %d\n", rsmu->type);
>  		return -ENODEV;
>  	}
> -	rsmu->regmap = devm_regmap_init_i2c(client, cfg);
> +
> +	if (rsmu->type == RSMU_CM)
> +		rsmu->regmap = devm_regmap_init(&client->dev, NULL, client, cfg);

Why?

> +	else
> +		rsmu->regmap = devm_regmap_init_i2c(client, cfg);
>  	if (IS_ERR(rsmu->regmap)) {
>  		ret = PTR_ERR(rsmu->regmap);
>  		dev_err(rsmu->dev, "Failed to allocate register map: %d\n", ret);
> diff --git a/drivers/mfd/rsmu_spi.c b/drivers/mfd/rsmu_spi.c
> index d2f3d8f1e05a..efece6f764a9 100644
> --- a/drivers/mfd/rsmu_spi.c
> +++ b/drivers/mfd/rsmu_spi.c
> @@ -19,19 +19,21 @@
>  
>  #define	RSMU_CM_PAGE_ADDR		0x7C
>  #define	RSMU_SABRE_PAGE_ADDR		0x7F
> -#define	RSMU_HIGHER_ADDR_MASK		0xFF80
> -#define	RSMU_HIGHER_ADDR_SHIFT		7
> -#define	RSMU_LOWER_ADDR_MASK		0x7F
> +#define	RSMU_PAGE_MASK			0xFFFFFF80
> +#define	RSMU_ADDR_MASK			0x7F

nit: GENMASK

...

> diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
> index c9d451bf89e2..f626efd034e6 100644
> --- a/drivers/ptp/ptp_clockmatrix.c
> +++ b/drivers/ptp/ptp_clockmatrix.c

...

> @@ -576,21 +577,21 @@ static int _sync_pll_output(struct idtcm *idtcm,
>  
>  	/* PLL5 can have OUT8 as second additional output. */
>  	if (pll == 5 && qn_plus_1 != 0) {
> -		err = idtcm_read(idtcm, 0, HW_Q8_CTRL_SPARE,
> +		err = idtcm_read(idtcm, HW_Q8_CTRL_SPARE, 0,

Is this correct. The type of the module parameter (2nd argument)
of idtcm_read has changed from u16 to u32. And likewise,
HW_Q8_CTRL_SPARE now has more bits. But the order idtcm_read's
parameters hasn't changed. Why are the arguments changing
order here (and elsewhere)?

I see that idtcm_read is a think wrapper that adds together it's 2nd and
3rd parameters, so I guess this has no runtime effect. But still, is this
change correct?

> @@ -1395,6 +1396,20 @@ static int idtcm_set_pll_mode(struct idtcm_channel *channel,
>  	struct idtcm *idtcm = channel->idtcm;
>  	int err;
>  	u8 dpll_mode;
> +	u8 timeout = 0;
> +
> +	/* Setup WF/WP timer for phase pull-in to work correctly */
> +	err = idtcm_write(idtcm, channel->dpll_n, DPLL_WF_TIMER,
> +			  &timeout, sizeof(timeout));
> +	if (err)
> +		return err;
> +
> +	if (mode == PLL_MODE_WRITE_PHASE)
> +		timeout = 160;
> +	err = idtcm_write(idtcm, channel->dpll_n, DPLL_WP_TIMER,
> +			  &timeout, sizeof(timeout));
> +	if (err)
> +		return err;
>  
>  	err = idtcm_read(idtcm, channel->dpll_n,
>  			 IDTCM_FW_REG(idtcm->fw_ver, V520, DPLL_MODE),

I think this change warrants an explanation.

> diff --git a/drivers/ptp/ptp_clockmatrix.h b/drivers/ptp/ptp_clockmatrix.h
> index bf1e49409844..2dc7f3c1edf2 100644
> --- a/drivers/ptp/ptp_clockmatrix.h
> +++ b/drivers/ptp/ptp_clockmatrix.h
> @@ -54,21 +54,9 @@
>  #define LOCK_TIMEOUT_MS			(2000)
>  #define LOCK_POLL_INTERVAL_MS		(10)
>  
> -#define IDTCM_MAX_WRITE_COUNT		(512)
> -
>  #define PHASE_PULL_IN_MAX_PPB		(144000)
>  #define PHASE_PULL_IN_MIN_THRESHOLD_NS	(2)
>  
> -/*
> - * Return register address based on passed in firmware version
> - */
> -#define IDTCM_FW_REG(FW, VER, REG)	(((FW) < (VER)) ? (REG) : (REG##_##VER))
> -enum fw_version {
> -	V_DEFAULT = 0,
> -	V487 = 1,
> -	V520 = 2,
> -};
> -

There seems to be a lot of churn going on around #defines for much of the
remainder of the patch. I think motivation needs to be given for that.

...
