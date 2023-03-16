Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A996BCA85
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjCPJPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 05:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjCPJPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:15:52 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2122.outbound.protection.outlook.com [40.107.93.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E255F5BDAB;
        Thu, 16 Mar 2023 02:15:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Er8HR3TdiRoF5ETlmYq/LxkPE7WnzFDyaOhBlCAutwDaYbAiaCjTHWN0Heaf9IY/6ptL/+vLPYKs5KyS4btyFH2hW7r+MrEm/SYqSV8TP0XuHTnfJ0VXMoJQdErth1oFKnXQVKwtIQTUJq6qInDdhx343S3QJlwRIgOiUAD+SkCeD0zZ3WNRA5bHSmO/eZ/0fj4PkLdmoCwFQgFfuCAdsLTJpoefRQSsakCQozrbCO1Y2ixzUzxr2GTjQy9NWYi1bIA/C5PufZNs3MCluCHsm6aGRBXy7QyWDjp4RYX5RLxq98Ku99OmZ2oGsQUrgkxvUrBuy0vo/+mRtDT8dDTo0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q2/w/bJzTNdY6rIIA0W5NcW1RM6R8UYfaf1fnXWWoBY=;
 b=VQtnO7j8NXnYBFXIJVkRgXDc3p8Jo4TFnoR9+WS7TzyKD9cSujqHvcXuyaiUc8dwjUbhKomgFH+8hurkg7EszQHlczHAhTQKIfkeev+cXO5tWUNkoKgSWsKl59vDND53D2KhTnTL4+iRbyIn6HBHn3Y+122Ku+9Ln3xHXvsggdNwTrXit2IPwR3W9lUsnAuY1qf09fmeHhuHeEQBSs+ckqHULlM08nNTP6116exyTtJLkn7HgV94Wk1l4G7bWwxhHsYuLxNaLoxvV6byjkcZoDJsyKWj4dhBPjYk5MVHSBPGPk6OZsy2enYyrYEAFrkDP1qCXLMiCxpPAdmIgqT/kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q2/w/bJzTNdY6rIIA0W5NcW1RM6R8UYfaf1fnXWWoBY=;
 b=DLUU5HKhGAx8ldXasSmx9sqHBnbB7DPqDfOpzAzi7TBHMBN1ZIua4i8tlKizfV50LzFES+U3x7UaAsNOcLdChBMuP39MUYJnnZgPrK5B4d1vdmSg5Mm5xbCO9uKzIoFjXxUfzNHJfUO+Unb0pWB+XU6Is042UH8CVWGGlUEvqEw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5112.namprd13.prod.outlook.com (2603:10b6:8:11::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 16 Mar
 2023 09:15:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.033; Thu, 16 Mar 2023
 09:15:32 +0000
Date:   Thu, 16 Mar 2023 10:15:26 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/16] can: m_can: Disable unused interrupts
Message-ID: <ZBLeLq/JSE8wLeUC@corigine.com>
References: <20230315110546.2518305-1-msp@baylibre.com>
 <20230315110546.2518305-5-msp@baylibre.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315110546.2518305-5-msp@baylibre.com>
X-ClientProxiedBy: AM3PR07CA0100.eurprd07.prod.outlook.com
 (2603:10a6:207:6::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5112:EE_
X-MS-Office365-Filtering-Correlation-Id: f56664f3-6404-4a30-828d-08db25fefe1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UwbEEBtAlsoKVvmcq6jPrP9JEvMrMkxG4/WSy3u+EAdVTNeghYyDBSjUuuS47uGAicqGGZ+F/LCk4JoNdirw0gjBVvuO9FDVDmm4kOAhfZoF+n1A85i0zFNZb9I7QUIQjX3LsCiS77IWtvJtakoK1fKpSpvXjP9QfGuuMUMgacPbJa4IpR607FEj2HvU4uXO9yhgcQSEukrQnJOxm2KTdP/6YOddr5YqTLevYh32G1WHYXWk8Y2QoIKtVaotJqEVDAPZuoytqTgvn6RTOcWymb3uZUJ0FoTbuORC1MpyZ3Gf4O6RNVLsXvJN1zPFSm3PSHLnf+COLmYc5E31eWJ3yfoLHNfXIlzF1I1Gsn9mMCx4QQ3iuqHmvE2Q1Zy8h/HX8ZJTskAAcoJb1h1SKa/eCns7vj5d7VGi16e5UGmsXWUsgd981g3g3yBZEBw7TdlxIKeoeDEzaEd7Pmi1ULRUBXheTyFajei74k72nNhegmnr8nEooaTeKf4XJbfqSIBeIouvjiS15jD5fiTEtLOr6tSy2Ei886wukvRqL431QtEjN5hupiXoGyRQDotxcrJWVT6ygOx0x2BpeVbmltS4W/7r/CMQvZd726ZJnpwfQJq2tdYlh9ECyqMafksOA5ptlTTTCjR8aTsG4shz3WN7Rg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39840400004)(366004)(396003)(376002)(136003)(451199018)(41300700001)(5660300002)(2906002)(44832011)(36756003)(38100700002)(86362001)(8936002)(478600001)(66476007)(66946007)(8676002)(6916009)(66556008)(6486002)(6666004)(54906003)(4326008)(2616005)(83380400001)(316002)(186003)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B7DJUaZuZAvumyzYLRqb+ZzddNajqoUQcBndfFrN88x/RuiBAeH+PVtAk90T?=
 =?us-ascii?Q?iQgdaHBvvfLqxQr/hPOLUUT3WWvvLmBAv5MdTwBeDhYY6kki3lOo7bWHL7AC?=
 =?us-ascii?Q?eANEWLovUp3Gnw1JSWotyRa4pqXNQZv4TSSOdcjKoOs/Pz/rhUXo7XrdNl5w?=
 =?us-ascii?Q?BJvVnOcJiaQlSbgINXJkE4YNNT9u323LCQZ/jba9Sjga+eRhyndzv417ilTu?=
 =?us-ascii?Q?ZGg6j7WtI0yZ2pPt4g7YFrK5BZJ1dZwVY8eUYbvilktk2Zp0v+mhnwknWuUD?=
 =?us-ascii?Q?/kfXeKEdQzKZvsSEVnLL54BeZEWbSGgpt1rEMmgaqTG5qFEydLIWdKBAAcCK?=
 =?us-ascii?Q?BaMAbVPFgFlLg+XidZ4qkDspKFkSv6unsdjqf72kXS2T19nxC3bosZ8SjorT?=
 =?us-ascii?Q?yJN882vLcYgWlOA+CT4IoFdmFZh0zoCa6sIlQnuJI5lb77SuRZ9KAwCPmXaI?=
 =?us-ascii?Q?S3OA+L2HKcQPMV5cFIvxOKsQniEusGuBhbg6epIArI+q/RdPvQVOST4+Tfyb?=
 =?us-ascii?Q?AJXwha/TOY/oxly9ctBipuLSlcirLoWDjQrcnh5Lv3W5cmch49qJ1NGmU2SG?=
 =?us-ascii?Q?W0FR6KL+IdywYr1vxWNB98bQHujzgv3P8xXkLrtWHPxQwq2cljvlRO7qJVCX?=
 =?us-ascii?Q?A9JcAfWWb6UsYqbypx3oluH5U8/PYBUd5u4MYGiTrJr2LkLBA92wJEX5u4Qj?=
 =?us-ascii?Q?6G1j9BqfOqjKDvb7Q9smEYBatDmE5gUP+J2mAdozjsqmUylA3PfkfXUDHBlW?=
 =?us-ascii?Q?aWyCdhIfCqCwoOiypAmD5e4rwgeRSU5PVimQyRz2WORzgk6N+OAj3Tz9FBPS?=
 =?us-ascii?Q?2dkyEF5UbjOoFxXuJ/H9EnDr+0ihS2zogJePl/Gr7K51Um61ULiMpXx7EfgO?=
 =?us-ascii?Q?Z+ZEBaADsDE4F0DoN9vwmJwaMAQo2Gp7p7PyXVqBuCkJDm1SC4ENcoq6AO5i?=
 =?us-ascii?Q?9GBi45RDssHHjM7p8KRB67ETmE3aM2HPtoZJsy8ybmacd//l2u1vI665bZ70?=
 =?us-ascii?Q?smLgJX68dQoRORTa1tgTyj56GT7rQqFJlEdJKcyiqth85OrLKI8kKMNxUdlP?=
 =?us-ascii?Q?HJm5zsDXtW2UjXK6K6PkLToeDdvTwTdVBxRJZzq/yf9DBHG7PcGEqDXg/N/o?=
 =?us-ascii?Q?g1xMZ8R8pE4MhNpeCoQNBIpSbAW9Ki3RUvvbvCtRiFF59uABPHeNIPKkiwQm?=
 =?us-ascii?Q?vc+g8B3T1ukO9yM8jtMacbFJsz5in6DaLCzhruRRcmyE6EV9/rtjhhQdbMJr?=
 =?us-ascii?Q?tgo2jLRzZL79Ucnzp2vzLYkHDruMAA5Us8Aaz4MmGcCiqr3qGA8ZWU4lMlXW?=
 =?us-ascii?Q?aYr6JmJwLShoakn8RIKFl5qqRyf5uxFaQ+bA3SFmJ2nSo7+wK007bzA2i8F7?=
 =?us-ascii?Q?xNumFRqSQ6skrrdiMnl7jbT9WRCzEE0VTWBUX1ehyXWpwu3ceZStBVQw5ayi?=
 =?us-ascii?Q?qz02KkvRjLqXRZ15jeAmYCcDCdZeAwnqOv6aY6MeYSSJUQeMWDEWmG0hqwek?=
 =?us-ascii?Q?6zyw8sMef5yhVEl2PGXNv9h8CFCsA7qSiL1t8YJQq8Z2darHQJ4wXFGj15zO?=
 =?us-ascii?Q?tQAMBlt6mhdnqib5RqRC4ranjjMEIOUlCWvCfXGOY5q6EgYyP5n3k9KinqvL?=
 =?us-ascii?Q?DveUDHgeUonwXNlJtEeE26XpMJGCd9aaLYN+qFx0qzribIeE49OnOMbR7taM?=
 =?us-ascii?Q?sYtdAA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f56664f3-6404-4a30-828d-08db25fefe1a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 09:15:31.9378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x4rrjYyiloPlny6Eq0NF5kOfvpNv7hZMcI6elPuDbey+ybsUvA4Wd/Ao1hOVDl+F5KNRfO40H8uUrkjpks7Faiy8ZK/dIU1lrm/4Ca1HGb8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5112
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 12:05:34PM +0100, Markus Schneider-Pargmann wrote:
> There are a number of interrupts that are not used by the driver at the
> moment. Disable all of these.
> 
> Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>



> ---
>  drivers/net/can/m_can/m_can.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index 5274d9642566..e7aceeba3759 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -1261,6 +1261,7 @@ static int m_can_set_bittiming(struct net_device *dev)
>  static int m_can_chip_config(struct net_device *dev)
>  {
>  	struct m_can_classdev *cdev = netdev_priv(dev);
> +	u32 interrupts = IR_ALL_INT;
>  	u32 cccr, test;
>  	int err;
>  
> @@ -1270,6 +1271,11 @@ static int m_can_chip_config(struct net_device *dev)
>  		return err;
>  	}
>  
> +	/* Disable unused interrupts */
> +	interrupts &= ~(IR_ARA | IR_ELO | IR_DRX | IR_TEFF | IR_TEFW | IR_TFE |
> +			IR_TCF | IR_HPM | IR_RF1F | IR_RF1W | IR_RF1N |
> +			IR_RF0F | IR_RF0W);
> +
>  	m_can_config_endisable(cdev, true);
>  
>  	/* RX Buffer/FIFO Element Size 64 bytes data field */
> @@ -1364,15 +1370,13 @@ static int m_can_chip_config(struct net_device *dev)
>  	m_can_write(cdev, M_CAN_TEST, test);
>  
>  	/* Enable interrupts */
> -	if (!(cdev->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING))
> +	if (!(cdev->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING)) {
>  		if (cdev->version == 30)
> -			m_can_write(cdev, M_CAN_IE, IR_ALL_INT &
> -				    ~(IR_ERR_LEC_30X));
> +			interrupts &= ~(IR_ERR_LEC_30X);
>  		else
> -			m_can_write(cdev, M_CAN_IE, IR_ALL_INT &
> -				    ~(IR_ERR_LEC_31X));
> -	else
> -		m_can_write(cdev, M_CAN_IE, IR_ALL_INT);
> +			interrupts &= ~(IR_ERR_LEC_31X);
> +	}
> +	m_can_write(cdev, M_CAN_IE, interrupts);

This now enables interrupts outside the if condition.
Which was also the case prior to patch 3/16.
Perhaps it makes sense to merge patches 3/16 and 4/16?

Perhaps not :)

Regardless,

Reviewed-by: Simon Horman <simon.horman@corigine.com>

