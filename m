Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01A059698A
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 08:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238383AbiHQG0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 02:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbiHQG0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 02:26:10 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2128.outbound.protection.outlook.com [40.107.243.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7ED7B29A
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 23:26:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WlJgJG5G8tIOEmUc2w3UZKvzvCBN7C9O64UzFgAUnKnFDMTZuNzBfeNZ8kcmfNEXbEpxNL3VZd/WdtWN+VFVdTk9eeFd6zCOQaP/uKDB+sU+/ZnidUXiNI+sqVyEbgkiXiKxXZrPL+I3RnQM+MtyBYM8MfF2n9A+6MYkG6wBWgCb9xFuOuypzhsuLo12Es59VPUPV0LydeG9QpQ7v8PT2YmttyGYD217gnOHrNP0O5h2sHQgpEFUBkvmzxI4MmyDskMtrbVF9oKZzLLpmAqVaHauiR6Y5KfcHltrsi9LcV8cz5Tw1DYYJqsketgtvOfO8TGGXjsvFnxh7nVsBnzZvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cjHJf0CBGEvuFiiHY3L0zSwErmytZrEVqJaan/EQQFo=;
 b=OeirYrL3eXrroug6YpnugkUmjGaDJDT97oygQ18K1KecqEEBXGhvX2woSaMzbBvo/kjUeIJewI9mzy9Amgy/1Y6uSqNyoHQjcjCZxSo1y45xy8Etvih9i7QXQ4zaaNcDz/+2xBC3BhZPd9rUhauIETVf+3JtU9eac4MxVMXFBn+t9ILBzhoZkWGuMYdtmdGYCHRPbaH0Q249HIZ80Km6S/VKJucZhenpWyO5uNRD0uVdlbke8WvdVajDOPo8XN4YSS7EvljTEQBnftk2IuWNaHY2ClxCXMvwXbWlxBO53Vs7aEsjd60N6iQpV3IWq8nHwJsrljU2HZXFG2Ux4R8auA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cjHJf0CBGEvuFiiHY3L0zSwErmytZrEVqJaan/EQQFo=;
 b=EUNQ5A5kIh+fhSxE1nbPk1wpY6/XSROHcudA5jEUv0f7iqBVXDZNKrZ65Brlcq8hMT9zkUMpWmr6HZnseREYaGK4/JACiTuuKc2blLV451BUFDDHfLrsmKdEGHI04h6UmMtPX9iF6oa1/3bX9epP6nFUDd9d8lpoqG/269aMpIA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4786.namprd10.prod.outlook.com
 (2603:10b6:303:6d::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Wed, 17 Aug
 2022 06:26:04 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5504.027; Wed, 17 Aug 2022
 06:26:04 +0000
Date:   Tue, 16 Aug 2022 23:26:00 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: Re: [PATCH net 2/8] net: mscc: ocelot: fix incorrect ndo_get_stats64
 packet counters
Message-ID: <YvyJ+FNELJsfxCWX@euler>
References: <20220816135352.1431497-1-vladimir.oltean@nxp.com>
 <20220816135352.1431497-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816135352.1431497-3-vladimir.oltean@nxp.com>
X-ClientProxiedBy: BYAPR07CA0069.namprd07.prod.outlook.com
 (2603:10b6:a03:60::46) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5930ed23-4145-4166-cb49-08da80195c79
X-MS-TrafficTypeDiagnostic: CO1PR10MB4786:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ff2o+vUawa5wITdF34AHEQbemULkDT6v80REI+2BievbLKChfdCk+rGAV/gO+Hf5Qyi0niaFzp/uEp0Ety0S/muAo4L0Y/v+G5Wt8NzRiWtD3LOZx2PaNHIY2UjEFk+wB+ZKwxzOYEwv5HMTV/0nQr8M2/MCiYuHKR/gEQnVJ2WjldLMO2jFhQySVDCazkhSgcAu1/AXi4oTxURgNNmF3TKJPPLzVCJ36N876e5u/I1buH2QMlScG6sdxZQdlvPklxEtZPxZx69Yg+Xx0MO4PZNY2oPddBQVJSIst8zr5gja+EtFqXnlUGI3giYufBV5+L+YtLbPYO3DCRsPQIFU4VuaB7UdgVcCsAu7tNChnG/DmYJ8L6d1f+a1uAcNu641VDoRqpJBGGqiZxtUzO7UAXpFcS8yGvoZp0PL4opx5wMkc4GbQywclAkCo9DpysQGkkPcEFNrLCsf4VY1ZiDKq5tMo3Oi37T9hOIUNTMudl9THAlgW0ryx+F0s1xzA+ygEpoul32aq2nRacKWm9jVOhci/cB0cHE9JjoMQo2BN8MhXJJN7w7GRMfDN3EKvkO7v1d+9Y02B6GnigyRMMxBPzcLele4Q3ztWVNqLXKlLb5BGjCRrqEzdOEvGNZPXB4PkyjheK0zC3sivPNbvgl0yQdnVRGJLvPy5H5B5eXvcRCb5gyMzTDE6rbB19dpFMFBvp5506zXInFZS88vYpPheP5a8lR67Wa3h0t7PBEke7L1yp88IbOchrW1mViDw4IfMlpbutFWUd7SU7vAvaUBbxoLv68qjNzCYWkQ61in3f4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(39830400003)(136003)(376002)(346002)(366004)(66946007)(38100700002)(8676002)(66476007)(66556008)(4326008)(5660300002)(186003)(478600001)(26005)(41300700001)(6666004)(9686003)(316002)(6916009)(44832011)(33716001)(7416002)(6506007)(8936002)(86362001)(2906002)(6486002)(6512007)(54906003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?31mGkMd5T7DbGTACh/QyXQB/kSOXIcr1HhOs85bnfcSUgxZ7eryh8SIOA9SG?=
 =?us-ascii?Q?UkzPOcj4cBr14U3xpvmDOaXeUFL4299TUMOy0wDEuATa2vS3FXp5X94+cJEJ?=
 =?us-ascii?Q?IbafwCd68Vm8a84TnGPrisyo6OR4C30g1SgNZqKIcnG+wCN71Uqvp+2r/9aW?=
 =?us-ascii?Q?UmKRC4yE2UfypJksVMDslZwmE446me55v9gf5jxtLA5Ns6pkqjphaVxvp5Rx?=
 =?us-ascii?Q?ZIvs7EuVHvMCmSdbd96ANGb6VtPZdkFYtCIc4DvLzAkNLsbbEEeBDn8CjMc3?=
 =?us-ascii?Q?jUWnp2zqxvLgPVGjfZUdcR9B5Ts/JBH8yYht6tJ9xLRf14bGj+YuXJt4FB+3?=
 =?us-ascii?Q?3lEZOcCMs5S7argIMV4HYKwexRbsiauOlP8dpi6Xsped4Zw6Ek8pAFGkHQOi?=
 =?us-ascii?Q?FJv7rGf02t7r/VHPJfRCPAl/FeXcavc2PNbH0UthPC5Ds5AUVYQQfS9IeRfP?=
 =?us-ascii?Q?zhPIWfkN1CxJTW3Ix9i7/PcE4+aEDC9G800nNEOZEMqNFsKliNswobjI1ou4?=
 =?us-ascii?Q?gFQ2ig/prhkdOB78oBXHlf0UuNneL1ir4dAEg346btijNVeJBBhdUm3IjLY6?=
 =?us-ascii?Q?Nns7EY84caXuQjj6BkuAY7iJgjYKxB3ZSabw/PBiGmZQDNnM0gOe68mD8+R8?=
 =?us-ascii?Q?1tHtRlBFwsPRonClJb+azYEwtMamdWGggvEpylJzvgpUSdRj5b3yacrW6Xu5?=
 =?us-ascii?Q?exW4raXOSJaxAgeo8ZFclFNUyR+F6qY844dK4hMQqxWHWr6eRZGNsd1takZV?=
 =?us-ascii?Q?5o+NPJe7lq9oYSIE7RS2XZW+x0krRZuxvZlGZ3NPKcDKnOxX6vR5gC01o/Rz?=
 =?us-ascii?Q?pgmcrI1TCbWbFe5WwykrHxQ1d+HtEWpV8Qq+7xdzckSUcwuttZT53I3+oXxj?=
 =?us-ascii?Q?tdGVEXw54TuMeiyyHOu/ii7uvT7UhXfdY+wxuI3CF3I8TFQlwoIlbjm55Fw4?=
 =?us-ascii?Q?WF1a3+AgFXodCLTSShdqC/GJn2DGHnBSY7g1BWcUj/X5+arKvPs0PU1jilB8?=
 =?us-ascii?Q?NJI9TS9yAhIqmzWZlbjeU+oX/b4WMe9xntR1/vY2AvLiYtp2RLvmn1xMxoQ5?=
 =?us-ascii?Q?0JHx62d1rJt53UqilO04ikGFEqRtCZkqQkKs1KOV+VvR8ggRO2uq8E8OOqOw?=
 =?us-ascii?Q?IIaloj4sfPTZTDApgKM4KkoWQPAIXf9YT9LHziIurrO8j3HLZvTLnKiJzNbe?=
 =?us-ascii?Q?NToEXnCupiFFC0KDIPwSarMzXu+8dp5PmbOkXsjO5/XrsqEfQvgCNnMP8cUC?=
 =?us-ascii?Q?RblcApE5k5LWuOkSkHf4dP8VY0AS7pHBoo+pjUKzpsjKhCiyA6U4ELh8sIhI?=
 =?us-ascii?Q?785yggvLiC4AWTaq9mc4WHLbma2EURKwglYI0Qhk4RvVfTiTaztnJX/DZAtl?=
 =?us-ascii?Q?a8lVfj8uzaoLPhqR0PCZV83CHNjJixeyIkE8OtDTEs/M6PUlTvZ7daWeRsgA?=
 =?us-ascii?Q?fJjHNG3QNwK4kc7RTeaVpu1QM8pJyWZA1vEBnrBem7x4DkF6r5JMJ7waIGXi?=
 =?us-ascii?Q?wJA815V+mVWEsm43gMM/yVYHXhDquNBSiqUFYq2MC3uwXXKmMN0mQl4dfz5m?=
 =?us-ascii?Q?uQPDzJrmNch/zQuiuQbV3cSVSM3O+F0qQSFYMWv3qJaBpitRwR+RjrF6qvLQ?=
 =?us-ascii?Q?QkQ+uPTkD8MO2Rbf3pnZH0g=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5930ed23-4145-4166-cb49-08da80195c79
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 06:26:04.2088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 20Qd7NeVaWinU1/2racoSVx+i4FQ5yj4wqQFHrjFo3jEHCYU5LKeRc09tmeV04yO8pmU73AYZZYzu6VrB6mqL3eC7z/kSu9FBrZAQdysixI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4786
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> --- a/drivers/net/ethernet/mscc/vsc7514_regs.c
> +++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
> @@ -180,13 +180,14 @@ const u32 vsc7514_sys_regmap[] = {
>  	REG(SYS_COUNT_RX_64,				0x000024),
>  	REG(SYS_COUNT_RX_65_127,			0x000028),
>  	REG(SYS_COUNT_RX_128_255,			0x00002c),
> -	REG(SYS_COUNT_RX_256_1023,			0x000030),
> -	REG(SYS_COUNT_RX_1024_1526,			0x000034),
> -	REG(SYS_COUNT_RX_1527_MAX,			0x000038),
> -	REG(SYS_COUNT_RX_PAUSE,				0x00003c),
> -	REG(SYS_COUNT_RX_CONTROL,			0x000040),
> -	REG(SYS_COUNT_RX_LONGS,				0x000044),
> -	REG(SYS_COUNT_RX_CLASSIFIED_DROPS,		0x000048),
> +	REG(SYS_COUNT_RX_256_511,			0x000030),
> +	REG(SYS_COUNT_RX_512_1023,			0x000034),
> +	REG(SYS_COUNT_RX_1024_1526,			0x000038),
> +	REG(SYS_COUNT_RX_1527_MAX,			0x00003c),
> +	REG(SYS_COUNT_RX_PAUSE,				0x000040),
> +	REG(SYS_COUNT_RX_CONTROL,			0x000044),
> +	REG(SYS_COUNT_RX_LONGS,				0x000048),
> +	REG(SYS_COUNT_RX_CLASSIFIED_DROPS,		0x00004c),

Hi Vladimir,

Good catch! From a 7512/7514 point, these all look good. There's a
couple conflicts I'll have to deal with to test the whole series.

>  	REG(SYS_COUNT_TX_OCTETS,			0x000100),
>  	REG(SYS_COUNT_TX_UNICAST,			0x000104),
>  	REG(SYS_COUNT_TX_MULTICAST,			0x000108),
> @@ -196,10 +197,11 @@ const u32 vsc7514_sys_regmap[] = {
>  	REG(SYS_COUNT_TX_PAUSE,				0x000118),
>  	REG(SYS_COUNT_TX_64,				0x00011c),
>  	REG(SYS_COUNT_TX_65_127,			0x000120),
> -	REG(SYS_COUNT_TX_128_511,			0x000124),
> -	REG(SYS_COUNT_TX_512_1023,			0x000128),
> -	REG(SYS_COUNT_TX_1024_1526,			0x00012c),
> -	REG(SYS_COUNT_TX_1527_MAX,			0x000130),
> +	REG(SYS_COUNT_TX_128_255,			0x000124),
> +	REG(SYS_COUNT_TX_256_511,			0x000128),
> +	REG(SYS_COUNT_TX_512_1023,			0x00012c),
> +	REG(SYS_COUNT_TX_1024_1526,			0x000130),
> +	REG(SYS_COUNT_TX_1527_MAX,			0x000134),
>  	REG(SYS_COUNT_TX_AGING,				0x000170),
>  	REG(SYS_RESET_CFG,				0x000508),
>  	REG(SYS_CMID,					0x00050c),
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index ac151ecc7f19..e7e5b06deb2d 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -335,7 +335,8 @@ enum ocelot_reg {
>  	SYS_COUNT_RX_64,
>  	SYS_COUNT_RX_65_127,
>  	SYS_COUNT_RX_128_255,
> -	SYS_COUNT_RX_256_1023,
> +	SYS_COUNT_RX_256_511,
> +	SYS_COUNT_RX_512_1023,
>  	SYS_COUNT_RX_1024_1526,
>  	SYS_COUNT_RX_1527_MAX,
>  	SYS_COUNT_RX_PAUSE,
> @@ -351,7 +352,8 @@ enum ocelot_reg {
>  	SYS_COUNT_TX_PAUSE,
>  	SYS_COUNT_TX_64,
>  	SYS_COUNT_TX_65_127,
> -	SYS_COUNT_TX_128_511,
> +	SYS_COUNT_TX_128_255,
> +	SYS_COUNT_TX_256_511,
>  	SYS_COUNT_TX_512_1023,
>  	SYS_COUNT_TX_1024_1526,
>  	SYS_COUNT_TX_1527_MAX,
> -- 
> 2.34.1
> 
