Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6F25BB475
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 00:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiIPWm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 18:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiIPWm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 18:42:56 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2107.outbound.protection.outlook.com [40.107.237.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8F9BC118;
        Fri, 16 Sep 2022 15:42:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RFErL1QNl6EabKyNphdm2T6Psz/trbS97up5EZdoI6iyxPi7dME5ciz1HptK3wamtMKAtimmshkRYBfkbgXJat7ZTCFyVGi8pEJg3XSwit6q18cAHmDy3WB+xXYsReDP57oUEsAr6I0x6tKBY0sgsjsogFb8qSAisWUT/X84CAmYuIKmLb/PIuT8raOvbx6ykHIHPGijKx62I7QxcwxnrLPj/bcfFL03zx3QgnZVG+nc5cSbTMQ7n+sULPcm1+lEjeUfLgsRaoNt4kb8U/P5dz2aO9mEWxSbM0+m6YtaSmOTuuiUJ/plSdoAOoBCI79MILhWHpjt/sE2ecHQ1jAIOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OgnSUaxBbZPjh6th6nzkVIAPtDODBT+JolFEeJ47TKw=;
 b=a22s29spWx/0N6dlaZB80lTWl1Ur2b1opAo1y9SgxAknXjNnjN2aLZiuZwBaUhqq3zjbFszrSCnRjiBDy4XQXMz8LFFqbmvg12x98e+i7UefhKYtbYRur/u+5/uj3j2F35j2EEp+zdgZbxPDHaA6EdO/bubFGRJMGs2kV+rZsjOwYq1TV6JCnnyxYnodvlARXFUB2ogOjsXZIg4NnDzstvkflI2gwZg7mkrnWmyuHkE80GW0kU+uE/iXYPGlu5Rqv3f9Wst7Kp1iogGz9emVOpjbBt1ArBnfTZcXJinj7yhNllDPbNBmabj274/ZdaE1UIBBPccYrQ3BQypAEzxOgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OgnSUaxBbZPjh6th6nzkVIAPtDODBT+JolFEeJ47TKw=;
 b=UAUKX9Mliu2Kh1jKf9tQIqmcuOpMlMB5RzzFH6VAWye0ht2+by8hJi2S1bDkubODrlLiX3ldVKa57F5alndlW0NLaaXLjnKNuDUXwf8JSK6B9tadHCgjJQqrbuc3IlMzYRghB3vC3DbuCVELH1oQ8Vf36ma3CbwvapT9irLrC/w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB4282.namprd10.prod.outlook.com
 (2603:10b6:5:222::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.16; Fri, 16 Sep
 2022 22:42:52 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::dcf2:ddbd:b18d:bb49]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::dcf2:ddbd:b18d:bb49%3]) with mapi id 15.20.5632.015; Fri, 16 Sep 2022
 22:42:52 +0000
Date:   Fri, 16 Sep 2022 15:42:48 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v1 net-next 1/2] net: mscc: ocelot: utilize
 readx_poll_timeout() for chip reset
Message-ID: <YyT76OIgNiJBH1Dm@euler>
References: <20220916191349.1659269-1-colin.foster@in-advantage.com>
 <20220916191349.1659269-2-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916191349.1659269-2-colin.foster@in-advantage.com>
X-ClientProxiedBy: SJ0PR13CA0042.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::17) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DM6PR10MB4282:EE_
X-MS-Office365-Filtering-Correlation-Id: 2515b2ad-710f-406f-971e-08da9834ca1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nOarKcveWNsF6kU4Roo+4WrRfox0hvDQ3EP4sT9i9Esjwx3ltWKWHaecQcTt5+GAT6YRUQb6jPAbAEFVBiq/B+ioJO9ivWjPdOtpTakqk1GWuut44h+2FgNUcux2tlHK4fazHyAUQjI5CjHnxFrhUt1zoq/wzQTLJ4IRLAI5e/gXZ0QiAjgxxx6nSETJXf0gFuJhMz4CWLhccEyPwCRVIsORjlCpC8il/wqlyraF53oKKrvhMhSZ3XZn+hP84NJWN5Xf94LlE0ku8ZcSPw87mdckq7P9LyZQqjvORGM1Bn8j1wAM2PhXIEN90y06Hz6nC7EQlQdFUe5z8hRAaXgrHXN+miAf2/x46+Btet3ytEsXifZ2TrXraNeItQz/Zy0XshVPVytVftQlXO15opwvJukInbSSH9lXCWBOuwIiI3ARjkJFUwo5wlVvOCf0QZeaUN9/EAXgN9bWVA2tHUOJxeBoOiNWJfj6THULI0iUrJulMv+gXhLklhKeaAEhvAsVxNUqSeDq+2yKSMNCi2dQlbJ2f0Q5Xju120wGkbmC7uBQOHk19wbouspfKDhWxMK/hR/EqHOKmvNcLM8/PpppOihMSPdvhndmm0vuxinaf7SAztxJ4HkzO2flv8JO5rqv/w4wWtg5A9zcXip3SAQvUIbLT03tcKWRFqSjfXoZhrOLL8kgU+Tzo2GjI/mZUcC1Fvto/5vPfv+XJTmxyPQd5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(376002)(396003)(136003)(39830400003)(346002)(451199015)(186003)(44832011)(6506007)(6486002)(33716001)(316002)(2906002)(6512007)(41300700001)(6666004)(26005)(9686003)(54906003)(478600001)(83380400001)(86362001)(38100700002)(8936002)(7416002)(66556008)(5660300002)(8676002)(66476007)(66946007)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?075j3uzUqf1i6kS5r1clpir/UrN5bQj4LqLjDSn82aSAkwi/Q2z4eyK1cViU?=
 =?us-ascii?Q?IfVP9yKAjVCciQ78Ii8hKMAVQmtWgkrZMidtkx3SoQE/LV95rUGbp2kC+mUu?=
 =?us-ascii?Q?7WdZQJzZXET9wg/ParxiCzmrr6k5vx+xphpsp/4ZgpgYn0vh1WANqnJV3h9y?=
 =?us-ascii?Q?d4+AGaXcBtq2X6deRA+AKaKpmlbapJ6E0VjzCqnxBizazZZ7yWInF2zbDnb6?=
 =?us-ascii?Q?2i83BeAXvK3v5VxfuHWqozHmOAJXPRc09KNGk+4fcexBiWQYFFvPn3aDQ1o7?=
 =?us-ascii?Q?fSy3wtC8SmovUR0P41lz91sQEWeW84M+Rs85hrP2d57vrFlGUw+dhAdcpy/3?=
 =?us-ascii?Q?CcCz/CFmbCDSp8rjXv95Mj8jATly3HsWL7jRlAgvKQZelN7ejjM9d+p3p6I3?=
 =?us-ascii?Q?KogcoO6bPDqPhC/AxOtxZHzL3nn+WCcWgjBg7J1YecsYBEai76uauvmGoilZ?=
 =?us-ascii?Q?f5WPovCCiWyh8NTsJnC0/w/88BKVUJYFSw+NQg8LUqmfxY63TB5oHf3ue2Wv?=
 =?us-ascii?Q?juPrqTtmU0YxX58LN56oM4TomQ8QeB1xp6xPPcRJTSruJAxiJmflYIwb1t5s?=
 =?us-ascii?Q?kDZboMbuqbL+8DOqVRUq5CCPw+7LorsQEtxdhWWG5V9LEupPxMOV24eS4erq?=
 =?us-ascii?Q?DQWgSCLtHR9XlX+i1wNxrh7/H/PA4ojuPqJmeQ//P2uv9/vCRlaiFmaLO7yU?=
 =?us-ascii?Q?yGB0D2kcJrbC1iDm9vrh3vVz64yekBrwuZ5XWxQzo8l+e9UMHhuykPd4bL0I?=
 =?us-ascii?Q?iihVTWDVr3n5fmC4Ld5bXfomXBoRaoDSIS2AZzzvrEJR5BeET5tmM8Bju2TV?=
 =?us-ascii?Q?R0qWO35PlI9DT85FSxcZTyLNlNt3mGuq3eEtI3EEgRBKxSTVU9t8OWot5I59?=
 =?us-ascii?Q?yba8gqhdIqLLn53CBm0PnPIs0iv15+ob2FtOUwmbLsP3zlUBFKP64v0WDC6g?=
 =?us-ascii?Q?AYqySBZGF6FEnDGAyCx1960Jw9A2ic4FVvOXBNmpR2Dr80ntQDvuQdNtsgQ7?=
 =?us-ascii?Q?8tgaxho/rd60hOhj+85OSnjQMYQRwSF6BqGsphjqs4UMyw8MHv8fTt6NmJme?=
 =?us-ascii?Q?QI6K+H7i579lb9MShFhkkZe0GmL1axD+nRObXAhwX/T19Pl5uqrAvRiPGOl5?=
 =?us-ascii?Q?5Bg15eov7Vp+d2jnWsnNTHY/Zv/MQCmIEfi39XOZV/Qf86RDYwnbyHpxkjwH?=
 =?us-ascii?Q?QSX0fOeIdzb5N/aXBlESF58UYvuu4kmtBnm1ISES0pLbubfTB70pzrxj4Jtr?=
 =?us-ascii?Q?rzT95tD36NuT6gZSEJoGRAD8P6ncj/zI4YzhJDVdQkl4adkB1eIPn8YdZ+oj?=
 =?us-ascii?Q?CoBvnG0gPyFWThgiqm+xOJWfz+d3iSE3y9yqQ6Zh+WzaA46eBwJ5N9lWEKLU?=
 =?us-ascii?Q?zcMfVwiAiD56gfSajPj7MTMkzYwqd7YoiOAX0aIUprUaqkcgAOXjbrD9bLlr?=
 =?us-ascii?Q?TEp4RKOiohTSJoEdwDLujBSbuuJOtjxudgo4Ga2CTzOVMnQvM39NUPWt4gqo?=
 =?us-ascii?Q?7KpDUv087x+aEI9BNCHZKg6Rw7QAzamjY7FzMBR/iMQiIrAUPHjab6meIApY?=
 =?us-ascii?Q?SxOWM039Tdx3NI1XYnvUovwlRvVgryJj8JWRCPBg80q4FTFEhjUHf5mM6o9O?=
 =?us-ascii?Q?0Q=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2515b2ad-710f-406f-971e-08da9834ca1e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2022 22:42:52.7444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xeJBx73dhCvl4NVdoD4HvX6FsR0obLNcPKY1Atm1eXoablIgNFlHx0nQnGM2fPT5d6jcWZBuRZM215Muge2Y3icgHqoDLWljjnNRr04pRmM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4282
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 12:13:48PM -0700, Colin Foster wrote:
> Clean up the reset code by utilizing readx_poll_timeout instead of a custom
> loop.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  drivers/net/ethernet/mscc/ocelot_vsc7514.c | 32 ++++++++++++++++------
>  1 file changed, 23 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> index ae42bbba5747..79b7af36b4f4 100644
> --- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> +++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> @@ -6,6 +6,7 @@
>   */
>  #include <linux/dsa/ocelot.h>
>  #include <linux/interrupt.h>
> +#include <linux/iopoll.h>
>  #include <linux/module.h>
>  #include <linux/of_net.h>
>  #include <linux/netdevice.h>
> @@ -25,6 +26,9 @@
>  #define VSC7514_VCAP_POLICER_BASE			128
>  #define VSC7514_VCAP_POLICER_MAX			191
>  
> +#define MEM_INIT_SLEEP_US				1000
> +#define MEM_INIT_TIMEOUT_US				100000
> +
>  static const u32 *ocelot_regmap[TARGET_MAX] = {
>  	[ANA] = vsc7514_ana_regmap,
>  	[QS] = vsc7514_qs_regmap,
> @@ -191,22 +195,32 @@ static const struct of_device_id mscc_ocelot_match[] = {
>  };
>  MODULE_DEVICE_TABLE(of, mscc_ocelot_match);
>  
> +static int ocelot_mem_init_status(struct ocelot *ocelot)
> +{
> +	unsigned int val;
> +	int err;
> +
> +	err = regmap_field_read(ocelot->regfields[SYS_RESET_CFG_MEM_INIT],
> +				&val);
> +
> +	return err ?: val;
> +}
> +
>  static int ocelot_reset(struct ocelot *ocelot)
>  {
> -	int retries = 100;
> +	int err;
>  	u32 val;
>  
>  	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_INIT], 1);
>  	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
>  
> -	do {
> -		msleep(1);
> -		regmap_field_read(ocelot->regfields[SYS_RESET_CFG_MEM_INIT],
> -				  &val);
> -	} while (val && --retries);
> -
> -	if (!retries)
> -		return -ETIMEDOUT;
> +	/* MEM_INIT is a self-clearing bit. Wait for it to be cleared (should be
> +	 * 100us) before enabling the switch core.
> +	 */
> +	err = readx_poll_timeout(ocelot_mem_init_status, ocelot, val, !val,
> +				 MEM_INIT_SLEEP_US, MEM_INIT_TIMEOUT_US);
> +	if (IS_ERR_VALUE(err))

I see patchwork is complaining about IS_ERR_VALUE. I think it should
just be if (err). I'll test before sending v2 after the weekend.

> +		return err;
>  
>  	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
>  	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
> -- 
> 2.25.1
> 
