Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B82367D24E
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 18:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjAZRAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 12:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjAZRAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 12:00:10 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::70d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F1B233DF
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 09:00:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FjCS1PQqxA71x1SP70PnoWlSBycgLadLb6d189RvaoTOcET6EqIkaKCOt3rCjJFSXa2fu4gYLyco0brNB0qaYpm7zePZIvkHOYS0hH63pqh46CiGMmXFAj9D5sqiheHZzojUQPGx7bz8GaQBgMwwpWLo8yKK9usTBpplD0WVNpDDk78SUTW+pFmfCSWwMZWLmGzCKwzgIvzPKcXktBBIg8/EX+VRlD1StJIeJ+sZo30SaQjxE9uOMXJ5/onZf3RcoUNIuGhTqiXrqt/Lc1cAjAC56hydQHum5trSpNGUcMkx11e1QM3e1+Lb7PtPxjIMDVMtBNFLQzzSEXWT5h/3MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TdFBxcmStWOGcOb5POnmOGVPyB9IgM5+bl4pQoeXkeU=;
 b=LvtA8SNn2bS3774+XG/AptB2lPxiIGkPw3dP9Iu9xY4J5Al6c6EK4DZk6ut2et2J0AiCg9M6YleHORRxXwf9pKkCQAZmoZp6YmPgw59Ascy756zbSM69gb4wvBPXgdxX5waQ/byLr1idNRlU4saotJTs/KZtL3D0lTOUSG+2mmNNRd0ZyumkQUcVcFbwVIpfTWKNXXXxakA8uHWM5T4QJuABzHV9gqNguJcQKnlQM2Hod3qA+e7rmN5O3qhG2Zb+IGRWe35bp/f/7IHk8ugNGxNsRbECb34y5wgA1C4APH4IoEYVzkGOSBwMBSO0uqXr2BEXfKk/lxa+imptUmBk7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TdFBxcmStWOGcOb5POnmOGVPyB9IgM5+bl4pQoeXkeU=;
 b=vH0PgL2YHqIcxpoJhp8ltO5BVpVTLCiyfo9EdpSQb1rTOJb459PgjYPdaRimtsc1Gz262jh4Xw/+85XBBLjGRWmR/7qDn87WvfSC0LRgPoDF/gD/PZd/hoOyRYFiA563uqz33O8qOZ/kHvZoyt43cPBLPsZ49hjJFr0GtF+aQtQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4492.namprd10.prod.outlook.com
 (2603:10b6:806:11f::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 17:00:04 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd%5]) with mapi id 15.20.6043.020; Thu, 26 Jan 2023
 17:00:04 +0000
Date:   Thu, 26 Jan 2023 09:00:03 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH net-next] net: dsa: ocelot: build felix.c into a
 dedicated kernel module
Message-ID: <Y9Kxk8xP/hEVgRdK@COLIN-DESKTOP1.localdomain>
References: <20230125145716.271355-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125145716.271355-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: MW4PR04CA0101.namprd04.prod.outlook.com
 (2603:10b6:303:83::16) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA2PR10MB4492:EE_
X-MS-Office365-Filtering-Correlation-Id: 1147ebe5-6de9-407a-7b7d-08daffbec52a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yEzJz1IJtP6sXW0h8k9W+J+404rwWO+yrHFcWO+LOXGHWDWuFMREB46I/wS26FGHGI+2e4+SiWpUmHFu7iojgNV9iKjHIVRDY0UW7EwfxpSr/ZuFvzzxswW+jjmf3etr76TfCSKoRCpbqC1FAytqnsbLPwWmYadDX/5nTlecbIJm4ZDrh4lfSWM0twvcQXimZ18H8+sJ9EbbUvdA1SoSZL2+iqQM1nr+5mLao0qInDLh94DQo6/XPvZPAmo9cWfrkGprPDHLPhxkL3mjFysQ5VAb56pdsf5AOLb8uHh4+0MvwPrZJhUyc1x5XsqmToG7ZWFl2fQpM86m0FdUKrywQReRmWI8qfV2rCVU/2+JwdOJWwPLHD3nCmfGSH7d4HOIW+jGFpA7ts+v4d10/3n2dBIT+CB6x4xFXQBssjlG1tgnGb2dtcJrfaMe06nsSChHlcCWPkK4Qs95j1mhu/FzNUudxZkzBcv7g/bP0oWxRYjT3nA42pnwaan1Dm3CECPiiEZie0r6ZcBGNClq02MJpnczULx2v8p1siPEcBlzRn2ttq7E5PzAZvp0h99AUzaDjl+f+uVZrjQCRIUqyTx8NG+Q3FevvVdowOkSeFo4blvweJvRkwGDQS3WASTk7xeMqBwE6PkyrFvb8FIWIo21Fg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39830400003)(376002)(396003)(136003)(366004)(346002)(451199018)(83380400001)(66476007)(66556008)(66946007)(4326008)(6916009)(8676002)(41300700001)(38100700002)(6512007)(9686003)(6506007)(8936002)(26005)(186003)(478600001)(6486002)(316002)(44832011)(5660300002)(2906002)(54906003)(86362001)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5E/yHqsnx0WOrAl97ha5553zG7fYKTzYK8JPECLdmXycjF+dMzJ87L3tiTNb?=
 =?us-ascii?Q?G+DSaz3d/p7PwGYHMJFcid4gpQ5uy4xbBHh93P/zMq2VGU6Lhv2qHZzZafoI?=
 =?us-ascii?Q?tQwFHpPqH/jja/z/ASrM76DZnrZiUBqwPaqJSXeNikTzVvS5uW7a6r4H8kcw?=
 =?us-ascii?Q?ILjpW0/vpo2J0FMVqnUfuiLgTngCRUpAuZ3sy74dtNyOOuJZSM1laqWiqhoi?=
 =?us-ascii?Q?I9Hp8IT9568Ksv8Tcv1uSp+UgT0PsRwWpmAKXJteDXUUkUEkawmmMAj37sYb?=
 =?us-ascii?Q?utAirRX3fRYyhr6aAs+pQpeknpIgPGXaro3X4A6U/K4cj6+HMjVQFfn+YdN2?=
 =?us-ascii?Q?HcghPVDGV/JY90G8hFZIhOu2sJ/v6ls9iE7P5zc9tIY1J9kICkY7L86e1Wab?=
 =?us-ascii?Q?KrJSSilvAji1j81TBK29m1GejqSF7nmPtxSpZnV1O8ccCDsW9UWabGQktS0h?=
 =?us-ascii?Q?AKqLu4u+C/soqeel+PeAW2YbHZz/6a9lCwazutORTbVzi1DqdHV7eUB9kS/E?=
 =?us-ascii?Q?UsgMRXO3TBAMPc/19G3q0Xxkr49+/OalFT0gZFqTlokxyNdCZGGivhR+fxwt?=
 =?us-ascii?Q?p7hMQA/XNrwSPUk28r4JIyBIsV3M/rN16/lHP4mNdrJY0RDtf+h5lDLeeX9k?=
 =?us-ascii?Q?Nh3WMjd9rWfYcl2s3NuvWDHj8xD4jCwc5abD11ygH4k4il3dcNHfcfYVRKbA?=
 =?us-ascii?Q?1kQhObGCFTrN2paDJ7hk6h9pwqLwU/wrX0HHGYMMmqAi1vmrI9SPSbnLb2XF?=
 =?us-ascii?Q?6YtImo7mRlAXGyDJ7rSxuajbjwPPPBzkcNvUFh69l5KipVmt+VSPKXli/AhO?=
 =?us-ascii?Q?1bPiSBcHTs49LVCEGwZn7oS2AhMtY4b9n1RFzIWCYQw0ZdQDyxbHzTWyYTny?=
 =?us-ascii?Q?1Tuz83kodRQJ2sJ4gfMUnkxpVPcL5Td2aGL2FMQhs0vrIV9PR18dnBwIvJMW?=
 =?us-ascii?Q?0ne/NUO/1cCv5+ET5ZvCWHI+VQ7rQ/10C4mSwLV9XwYt0lPqn0zOOngiWbm8?=
 =?us-ascii?Q?kGJWtweenMKwGRdzXvtOp9juj5I0V2ZiMH2nVU+yqB+jeWL/X2HnCNx0bcTz?=
 =?us-ascii?Q?Vibbl+O0yeigxSBNRAYkjKQDXjsqmB0v6OBn3P55meiS7Kw4C4KxcVp5Asdz?=
 =?us-ascii?Q?A4ZfFo5y6Q9L+vX+tHvdJCbJoZp/ecXn40aXtWPuZOAUmydt9RCbJNFa6OPq?=
 =?us-ascii?Q?7CibrefUdK68YlBp81XpJBKi083Lucz1V5Gv96HxXaJO3wsv0xfGuFJLrs3d?=
 =?us-ascii?Q?jv74g4pIKvD3rjUtKkAvXAwKZfzpQVCzN/0E5K9/5cI2X+hs/Y4ZqGV+PoPB?=
 =?us-ascii?Q?Zc+nWnyDJrJIVT3eoCYGxQiOMc4z7oEcepNQ6deyPM2urxt71Ia/MfNbzHWq?=
 =?us-ascii?Q?YDT9QQtkF7vA28D8w4UuFNugxSWexuIzBel2JAEmsG7QGNCJo/OxEMKc1PaB?=
 =?us-ascii?Q?lq3xouwb+1y1bNejObTX1BVHHyrbTL6OkNGadM+3r/Gw3RH9rTj0BFIAYEab?=
 =?us-ascii?Q?EtnF9EJ1kP1mc0BjP+hgwg6PeaBeqQHGLmUMnnG4UpKBOctKPoSmqHGHsMzA?=
 =?us-ascii?Q?O1BtXKIdiT+4YFz2COZ6qF2K7eExIvKy8s6WI2kBV/QCOXS2/8Q+PyGuXpLD?=
 =?us-ascii?Q?p7aTkXlLdPTKpbBz5a8Bv5g=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1147ebe5-6de9-407a-7b7d-08daffbec52a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 17:00:04.5767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XHOYzPDJ2HBWuQpEIVKt4SCr37dcDGc84VHto+rp7iylmGzCGTx5U2/HNDvdcEruiey5RJ/GOweZAU+UtNbD4SqkT/54QX8n73tySLHcWUI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4492
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 04:57:16PM +0200, Vladimir Oltean wrote:
> The build system currently complains:
> 
> scripts/Makefile.build:252: drivers/net/dsa/ocelot/Makefile:
> felix.o is added to multiple modules: mscc_felix mscc_seville
> 
> Since felix.c holds the DSA glue layer, create a mscc_felix_dsa_lib.ko.
> This is similar to how mscc_ocelot_switch_lib.ko holds a library for
> configuring the hardware.
> 

I remember seeing this at one point. I thought I'd fixed it, but
apparently not. 

Acked-by: Colin Foster <colin.foster@in-advantage.com>

> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/dsa/ocelot/Kconfig  | 11 +++++++++++
>  drivers/net/dsa/ocelot/Makefile | 11 ++++-------
>  drivers/net/dsa/ocelot/felix.c  |  6 ++++++
>  3 files changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
> index 08db9cf76818..60f1f7ada465 100644
> --- a/drivers/net/dsa/ocelot/Kconfig
> +++ b/drivers/net/dsa/ocelot/Kconfig
> @@ -1,4 +1,13 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> +config NET_DSA_MSCC_FELIX_DSA_LIB
> +	tristate
> +	help
> +	  This is an umbrella module for all network switches that are
> +	  register-compatible with Ocelot and that perform I/O to their host
> +	  CPU through an NPI (Node Processor Interface) Ethernet port.
> +	  Its name comes from the first hardware chip to make use of it
> +	  (VSC9959), code named Felix.
> +
>  config NET_DSA_MSCC_FELIX
>  	tristate "Ocelot / Felix Ethernet switch support"
>  	depends on NET_DSA && PCI
> @@ -8,6 +17,7 @@ config NET_DSA_MSCC_FELIX
>  	depends on PTP_1588_CLOCK_OPTIONAL
>  	depends on NET_SCH_TAPRIO || NET_SCH_TAPRIO=n
>  	select MSCC_OCELOT_SWITCH_LIB
> +	select NET_DSA_MSCC_FELIX_DSA_LIB
>  	select NET_DSA_TAG_OCELOT_8021Q
>  	select NET_DSA_TAG_OCELOT
>  	select FSL_ENETC_MDIO
> @@ -24,6 +34,7 @@ config NET_DSA_MSCC_SEVILLE
>  	depends on PTP_1588_CLOCK_OPTIONAL
>  	select MDIO_MSCC_MIIM
>  	select MSCC_OCELOT_SWITCH_LIB
> +	select NET_DSA_MSCC_FELIX_DSA_LIB
>  	select NET_DSA_TAG_OCELOT_8021Q
>  	select NET_DSA_TAG_OCELOT
>  	select PCS_LYNX
> diff --git a/drivers/net/dsa/ocelot/Makefile b/drivers/net/dsa/ocelot/Makefile
> index f6dd131e7491..fd7dde570d4e 100644
> --- a/drivers/net/dsa/ocelot/Makefile
> +++ b/drivers/net/dsa/ocelot/Makefile
> @@ -1,11 +1,8 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> +obj-$(CONFIG_NET_DSA_MSCC_FELIX_DSA_LIB) += mscc_felix_dsa_lib.o
>  obj-$(CONFIG_NET_DSA_MSCC_FELIX) += mscc_felix.o
>  obj-$(CONFIG_NET_DSA_MSCC_SEVILLE) += mscc_seville.o
>  
> -mscc_felix-objs := \
> -	felix.o \
> -	felix_vsc9959.o
> -
> -mscc_seville-objs := \
> -	felix.o \
> -	seville_vsc9953.o
> +mscc_felix_dsa_lib-objs := felix.o
> +mscc_felix-objs := felix_vsc9959.o
> +mscc_seville-objs := seville_vsc9953.o
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> index d21e7be2f8c7..f57b4095b793 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -2131,6 +2131,7 @@ const struct dsa_switch_ops felix_switch_ops = {
>  	.port_set_host_flood		= felix_port_set_host_flood,
>  	.port_change_master		= felix_port_change_master,
>  };
> +EXPORT_SYMBOL_GPL(felix_switch_ops);
>  
>  struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port)
>  {
> @@ -2142,6 +2143,7 @@ struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port)
>  
>  	return dsa_to_port(ds, port)->slave;
>  }
> +EXPORT_SYMBOL_GPL(felix_port_to_netdev);
>  
>  int felix_netdev_to_port(struct net_device *dev)
>  {
> @@ -2153,3 +2155,7 @@ int felix_netdev_to_port(struct net_device *dev)
>  
>  	return dp->index;
>  }
> +EXPORT_SYMBOL_GPL(felix_netdev_to_port);
> +
> +MODULE_DESCRIPTION("Felix DSA library");
> +MODULE_LICENSE("GPL");
> -- 
> 2.34.1
> 
