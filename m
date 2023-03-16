Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A022E6BCACB
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjCPJ1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 05:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbjCPJ1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:27:53 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2095.outbound.protection.outlook.com [40.107.93.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286BAB7DB2;
        Thu, 16 Mar 2023 02:27:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oW4qFjktfw9bUf53Fw7xs+5INu1CTFk0kFlCVYNbSMoxaEPDhfpvxgMntmBu46tDOINI07IpLSBVkjFzrb6G/rvMEungE0zTLdQ62a5qNq1UD2FwiFrmjBm1Vo8JXicmCCfSgAwWcezRb34gONkt0X/TxyQx6Ii3TnAq0tB5MJ16Dgc7nQjj07Flv9Flj3VfOJC0LL2uRM+RODuUJFF/cc+UDLpvtco9e0PyI0tOTxjWGLsuHx847oj4MFLIo2r55ump19XlDNxX0V3boOy/EVxkG28X86noUHJGHdrAqUkc2olZZVPN2Z8pTWgg0BUW5NoJVo5hlbfCt0xj9mzpWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QeVAfvnXlfdispH3wED06cd6Djc49sk04Stq9s1yz94=;
 b=dJtpIn4pP3qH+qHyPofWq66VfL2KrS4ypYeNz/ZAce1HD410nEzLGjfa/Md4nVJ/Iq610VvwH1ivd/hxkZANE+fnFv8t7jKuydmX28f1TsGdE3ZCN/3bTMm0WUYPLJHrln8SGS8XK3JQ2WUNzHVbcwAGP159N/QDZ/nKb7SiqNxz9Pl/RfqyBFuT1/CtgmarVWWg+2sgcpPTvjSfvCyhWfpFFSxgs4BGKUgHvNurTp/y8fvGAzaxPzHLjarX6EtJb13EsSMQ2MuSbpLtHaDC7uFAxJUHcR2lklA81xsJs2WAbiEr2VgGxO+a4T97hEa8j9jgSfMFrmiyP/GzeKYTkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QeVAfvnXlfdispH3wED06cd6Djc49sk04Stq9s1yz94=;
 b=toesXrpQHz+s4yZ7T3V63Hum8uY3S+MchYbD3L0Ic8r9E+X8rl8uOgeW2bQxDex0f/Qeth27gfOR8d1W4EHGGYYztvDw3hrBwnOltmyw45HXSiwQcQH8dn0r23M4hlc6CpoH2Ow6UNoR+n7I5Ig6C/8U9WjvkJukwKV0g+9cti8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4463.namprd13.prod.outlook.com (2603:10b6:5:20a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 16 Mar
 2023 09:27:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.033; Thu, 16 Mar 2023
 09:27:47 +0000
Date:   Thu, 16 Mar 2023 10:27:41 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 06/16] can: m_can: Write transmit header and data in
 one transaction
Message-ID: <ZBLhDSl4a7AuCgNy@corigine.com>
References: <20230315110546.2518305-1-msp@baylibre.com>
 <20230315110546.2518305-7-msp@baylibre.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315110546.2518305-7-msp@baylibre.com>
X-ClientProxiedBy: AM0PR03CA0001.eurprd03.prod.outlook.com
 (2603:10a6:208:14::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4463:EE_
X-MS-Office365-Filtering-Correlation-Id: db3a270f-edf3-4df9-70b7-08db2600b48a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1UJ8Qsew8GQbo2FAlU8rhhhbdGzfV36jdnbyLmI6XXBIugiXOoZsHyMMSKjrUCDqttKv4UaMhiFZcRje8mWmBYbOUSrDTQvh4D9a2XLxDtc4uVFYonrTW5wtm0zKkhZKSE8Y0x+uKjREai3bXYP+WnHhTdVp8/Qu9groDL6QR1We5sdcKGnbzxRTOVFb/vWZO1ETVv8yOfX1w1T4SZnPy8FSjGa5P92ym10ZoT9y2yh9ooXxWExsJlPaZ2on9jh+8RP6zZo+qV+4jpi2u+TNbZmrXzzx3R+ryFTBozvF9gc54Kl7XC7FNIR5xi2Dwd9UTvtYu95GIOgbfUZUcGLWjaKvjilHko/VqKx2Ps5EthfLS6s3lBXyQEqQSrjXwnoerK9PtWRrqN8bkrI0G1FKgBQ19NI5kOsBL1c7dHenHa8AGgim0uJq5VzXS1LxejAT6z83m1moUy4WTjERpEeOywTxcukUg5JKq2vSRCP7kLNCQrjufOvgAxtJUuDbxGI01XOjZPIzsqFy0w6I/uQjevd3OiqoqV18WwBM6Y1GOxerowZTBeFMWFJ7h0AekUbjWrP++ce5KNTqSU+sL/4HXZmQbdBgrR3a5RNNJEqyWM4KbCEIlXJfGmgDR54uCxIMezQ2gMwlS2VrxIW3xsi8ZVgZwlCm94O6gnvcBKbSRywhSmDkvmtKYjqVwKhin77l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(376002)(39840400004)(346002)(396003)(451199018)(83380400001)(6486002)(36756003)(86362001)(6512007)(6506007)(38100700002)(186003)(2616005)(6666004)(478600001)(4326008)(54906003)(316002)(8676002)(66946007)(66476007)(6916009)(44832011)(41300700001)(8936002)(2906002)(66556008)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oNa6jUwPEoiX+Hg5uHpsLrImoCicQ8CxpqmWEhb3icuEioQKiu96fdk6Z0EA?=
 =?us-ascii?Q?ilYo/WejawrsDvMWvd48SIUCKHzvONciW7JHXLcpAw1cBeNcQjWN4oqAn9JJ?=
 =?us-ascii?Q?4/WKovPk6Ii9QEPCR6tN0p8JfLDat7AWruNvirde7Wni52BvizLy9O+EVxoi?=
 =?us-ascii?Q?Ub47uwOmAP+2h3NyWrQHEM4dbmSuBY/PD9xP4N7GjG69+ftfXNtcwAfNmnrc?=
 =?us-ascii?Q?ohmuHfBVZV0p2sjBSdaFu3fehyJoJV9ZPAN2IwaG7uQP+TgojxXpcww6QwRw?=
 =?us-ascii?Q?8RK+EgAvZKeV9ppro/bYmmlKD2cTHhbxDSXsUmFUzU/u4eeCjA57ZAoLeUVa?=
 =?us-ascii?Q?0KOZ3iylWTcOmTSOqj1xWCYh1BoIhnunQR1FoPlzi5FQSSNceuSL/dkMmUtD?=
 =?us-ascii?Q?HpaU9jDHI5bQleglRt2cci2i1qS4j2RN73HtPGGolmYcL9aPAh6uD7FLEJCX?=
 =?us-ascii?Q?Zdwy0KlbgqjeQZwnbI8ex0kv14EJrV/fT6reqa0tA2NOy4Er2KxC0qVwdeyX?=
 =?us-ascii?Q?3fXrecf3JXjSNTzPKOYy5ek4WKkbnXBb9OqpioghLyS/0/FhBDrdi00hp79P?=
 =?us-ascii?Q?/djYXEWesYsjPOkCVMg5hgnQFOJsrGmGRkC2+blo6x9rS0uobMqoUqbDdLCO?=
 =?us-ascii?Q?qNCStmdpwkcaSjWSX5dnMCoaAoHvhb+3I6kpkIb/o2H9NvMGya7fH2tQidmk?=
 =?us-ascii?Q?GIl0BoaupfSPLLEVKr0jzESHJGndmchhlpzkm1kCDrpZ8CnjA9uB2AHBSoLr?=
 =?us-ascii?Q?zfn/4/ZLIRNoPdQ2vShwXCjbAcHYs3K6+jNsZ24eRnOhcSUnzazU4w3DgTl5?=
 =?us-ascii?Q?Qje7dqA4AJQJSMOApEHxKg+L8dVKLeQNRFRarrcqED5+wcAmo6063YS04O5G?=
 =?us-ascii?Q?y+vtpYVqxU7rqkg/Umz1bfnje0JLB04/DB/0lcO9a+8JrLYK7SsMe/kcNaSs?=
 =?us-ascii?Q?u92X0Yzpk8D9ZqLXyF56nPLTrrlyhFzXhZU72crkHpOF+uCKpTTxsreP+MZL?=
 =?us-ascii?Q?QCNMIYPbtafCluBhZS0FisBPpkMPZ1a1K8Qb1KSnGt++TzZeZvA8eEERljoq?=
 =?us-ascii?Q?xFa8Tlzhh4r+y7m/5jK2Gs0vugWczcC78fyjlYwf56uj3o9R56XEJD5EutrX?=
 =?us-ascii?Q?OLziq0rUUy0fA+Z4A2NiL/naFF955ifN3vK41V1w9DoTZoeTGt+6CSxO6z2e?=
 =?us-ascii?Q?GsBoIA+pH9cCdXnJYxZAqTVaWTjB1qxxm5rqdubaWOi+eIXpYEEa+jGMzByH?=
 =?us-ascii?Q?Ct9DGviXJdvhJjfQE8/quZmgmOyg92NA6EVsCn882ATvB/IZcmDTb99lKaLW?=
 =?us-ascii?Q?38l6QX5jkZRr0bXeWz78/3GDp506PZMoz69bKNGb6D5GmMzPzvGL/sp3xzWF?=
 =?us-ascii?Q?Qe/mUA0CtGSntnsRjcSnMNfBwJMAza0D0Iv7bCDxSfI/APITQxYc/pQ5h2U0?=
 =?us-ascii?Q?ZKsWAug6Mv7Y3eA7KPnEy8+7vTuEnN3gIH/xw6GFySwOGiX+qSefmQ4ad+Or?=
 =?us-ascii?Q?CFUSzg1SeXsXZ/XDtWi+5xoofqvKsJf/1xgf7MtUBhY6vAcrHWbU0ro8RvYy?=
 =?us-ascii?Q?dy/+KBAsd+CacjPCah1LPT3MnZWXp7clvL8rdSXTMootzo8IIqltXVnDpGMe?=
 =?us-ascii?Q?lcKp2/0wVLXzZqTJJ+Sh1DNrCezY2SpXQcH6WmdCygH0T3ZWswLp5Jtm4M2G?=
 =?us-ascii?Q?N0Z7Og=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db3a270f-edf3-4df9-70b7-08db2600b48a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 09:27:47.5134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6N3KIRjtT3O8YLqpn4kjFAxzfwM+zBOE32RdLIZttkJkOX0VBiALr64SuVEcup6x0zhyv1QGVTLqXWwHRA8QO4YSaaTrQsUQcoCbXEYgtiY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4463
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 12:05:36PM +0100, Markus Schneider-Pargmann wrote:
> Combine header and data before writing to the transmit fifo to reduce
> the overhead for peripheral chips.
> 
> Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>

Thanks for addressing my comments on v2.

> ---
>  drivers/net/can/m_can/m_can.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index a5003435802b..35a2332464e5 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -1681,6 +1681,8 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
>  		m_can_write(cdev, M_CAN_TXBAR, 0x1);
>  		/* End of xmit function for version 3.0.x */
>  	} else {
> +		char buf[TXB_ELEMENT_SIZE];
> +		u8 len_padded = DIV_ROUND_UP(cf->len, 4);
>  		/* Transmit routine for version >= v3.1.x */
>  
>  		txfqs = m_can_read(cdev, M_CAN_TXFQS);
> @@ -1720,12 +1722,11 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
>  		fifo_header.dlc = FIELD_PREP(TX_BUF_MM_MASK, putidx) |
>  			FIELD_PREP(TX_BUF_DLC_MASK, can_fd_len2dlc(cf->len)) |
>  			fdflags | TX_BUF_EFC;
> -		err = m_can_fifo_write(cdev, putidx, M_CAN_FIFO_ID, &fifo_header, 2);
> -		if (err)
> -			goto out_fail;
> +		memcpy(buf, &fifo_header, 8);
> +		memcpy_and_pad(&buf[8], len_padded, &cf->data, cf->len, 0);

I'm probably missing something obvious here but I'm seeing:

* len_padded is the number of 4-byte words
* but the 2nd argument to memcpy_and_pad should be a length in bytes
* so perhaps it should be: len_padded * 4

>  
> -		err = m_can_fifo_write(cdev, putidx, M_CAN_FIFO_DATA,
> -				       cf->data, DIV_ROUND_UP(cf->len, 4));
> +		err = m_can_fifo_write(cdev, putidx, M_CAN_FIFO_ID,
> +				       buf, 2 + len_padded);

This part looks good to me :)

>  		if (err)
>  			goto out_fail;
>  
> -- 
> 2.39.2
> 
