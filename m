Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D5F6BCBA2
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjCPJ41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 05:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbjCPJ4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:56:22 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2105.outbound.protection.outlook.com [40.107.94.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C5775A66;
        Thu, 16 Mar 2023 02:56:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ApJD5+YLF7+7u3tNuiPfSFJNeHqAkBdlARcTQ5fwV1+7a0JuajuGB8WD/uTQKfCXL3GxN1p3g/xE3VHOiw8GefGz77fow6hQ9B2pU8iqm6i5owhBUoahGqEqQ0H1UqoTgyTZqESlJIJ1YhMIRDNVyipIft0NepJPBwfld8+WI2NYGQOY0eTYGPe6QQtNkyscOFND8P+QVsojQlVklH5O1JIMfiIHQC//hsbugYbDj83PBBSX01DUOvjLLty0EfUEmxIwNvfcad1M/tcNMTyMwcxeYkHSVs8QMxbbP43j8v3u7y1/R0ePnEk/d2vpVzbNenZtGaUnOqJUcc2mjPq+Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2qExtDMMqazEDVj85niN7djWSnLZUjbgXSWsqS+FvdY=;
 b=GLAp3VONhfDKCyvirvZEZs+jIQ8r4bDkBwhYietWgfYFQjBAcWRmqsg+3I2uR7hPblauSiUp7EWWt66eJziL+Ar4Tj1v3QIsVffZzGjYwzqnovtJsNMUMZavUiViH50Hd+NPr4Mao6jK9VJtw80oucTWYSAvgGRlIKQOn1LwmGfzbH7XkbWfozZRhZ9U9Ff9aB2iTBIx1jkFoPEDOY/8kda7V2GUTMp2X/GCxa7X/+Yey8SLgTlZywG/iA06ashe7NJIaC5XxtY1KBWC6AIAzVg9cKbwO5BRAhiMrOfOSgfqym5ah5p2jwwDEVJCfQhprtFoOC3uZqaOCFiDYi0MSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2qExtDMMqazEDVj85niN7djWSnLZUjbgXSWsqS+FvdY=;
 b=qwnaas9+UNg0955X0Yv1F62MZ3lAX0aqXbJuVuBW+Rt92mZHFnQt42PDU4aGv4eQ2DmZzUrPXiHTatCvlUI/+icL/fJfrR4UeybO5QrDNKDrzkxtPwD2FPMYHkPcEKbILaeWN3tzSBh/A31mW/cogwBpj6pvSldoAnmtxS7A5YA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB4521.namprd13.prod.outlook.com (2603:10b6:610:63::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Thu, 16 Mar
 2023 09:55:09 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.033; Thu, 16 Mar 2023
 09:55:08 +0000
Date:   Thu, 16 Mar 2023 10:55:00 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 11/16] can: m_can: Cache tx putidx
Message-ID: <ZBLndFdGKYApfBv4@corigine.com>
References: <20230315110546.2518305-1-msp@baylibre.com>
 <20230315110546.2518305-12-msp@baylibre.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315110546.2518305-12-msp@baylibre.com>
X-ClientProxiedBy: AS4PR10CA0016.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB4521:EE_
X-MS-Office365-Filtering-Correlation-Id: 77c9502f-d562-441f-2d21-08db2604866b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NbuxS4ts13gIGJvT8vuMd2ZARVytOXLaarebGACk2wv/W83oYs9sweoL69hiAkBuWoaneEjZyX0my04TKqc3J4hvs9Wc68HWDFZIedFkX73CWQVe6CbrED2Sn/OY3a3bYWBx/Bx4P6splvmxkIOJqkD+XjHa2ieE7M60gG6jn9lQut9mQRjhIkEP+F/S4FHdrMPbDVKvvEOVsnylimq8NFenycMibgtC3EKYekr62td9GW3Xupr2ZkdE7cs8XdighWEivrWDtxD92yhJHtvZtYCFwDcaCEILXAUobWQLHDczje9MxzS6GphWc9dsTsVNWA4xbjvxuz9K1/YjuX2MiS74Of8Vzm+FV1kOKRU9XUS2Krn2AELkUVoYWBYjx64T4kcJCTkBjLFkfr3z9FH8J1iuy51PBfUJYA46H2omgiLR+BBwGqH/NCzlUancKHrJLN6orEuHwLM9XptpI03F4w8YCKTGPTks4C0n904tbow0Bt5PfIcEf7G0TDyFBUFR2k7xtlPTzoc2NH61c1YyAxRa8aTWZbp1Wn9rnnJHXl/8617q4i9dMrF027BI+DGQeA/jnVSSVd0k5ykwlx/UklG6veu3efJX9CpKxyrChhvNXi3l3Ekw757ewqpkVXNeX2/fttnmbBE6aCmCcnaWhqI6GK/uc7byax/c7rHfOUOC7J7y2JvomsdiRiZgMqte
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(136003)(396003)(346002)(39840400004)(451199018)(2906002)(83380400001)(36756003)(5660300002)(66556008)(41300700001)(6916009)(186003)(8936002)(4326008)(66946007)(8676002)(54906003)(66476007)(38100700002)(86362001)(316002)(6666004)(2616005)(6486002)(44832011)(6512007)(478600001)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I/OV+NkdNYrO9DsNUWStILFRbg4mIfMbzbnEJNBIe0cXKkg+NUznXIeIqMZw?=
 =?us-ascii?Q?iwcoQk6QVpJDwCRr5hOJcwsPDg0nmDzoWppcCVPLQdYW3ReNGwYLdoPgbVHc?=
 =?us-ascii?Q?pPxYjbPlrl3D5ClaHFP3JS4+3+iEp1YXv5Q8iXrY5JxHcguGJebRXHSnU3cR?=
 =?us-ascii?Q?ImY/UiLMU5PQUjmGvhGTpJjm7aDEp9kNTSgP+v6rdxmI+2rJxF2L8hwGlV08?=
 =?us-ascii?Q?7ol6GYEIweugy41k44IiFRHRHvasApee+zRYv4FKmYgs2fOB9lsx2tXybhbp?=
 =?us-ascii?Q?k3F/cWeZ+SzTFpAEH2Cue49VAw5Ut+RsIFjgKvqf2ZQOwcn1uuF08BkZ75dR?=
 =?us-ascii?Q?4xDuQ3rakkdwo4NA/rrVnTgKruQCm0boj3za0CM+yZyGvGqajBReSnaYhNdW?=
 =?us-ascii?Q?KSZSmM+g7JyvB/Gdto4Ac7oKmIDFQ2DHD3Mhd930JNfpSikmRsS8Z0JQYKuX?=
 =?us-ascii?Q?g1UjH8kGcGWEdsDebiCMGav2lpD8NkGlIu2C3DuqXASmECjiYltpbEmfiCx7?=
 =?us-ascii?Q?gMQfXnRtudH9Wg6E1bsOdtwihgMWRzQ8DhOqTejUhCtWOX6R+MuhDmZnQJhQ?=
 =?us-ascii?Q?X6hrqp5QsIkBTEi4S2hflctb6ZWhIwYLd0XjbqRWoFkexllhCeLv9shcvmLb?=
 =?us-ascii?Q?3dm1UcyL2I1VZZuqpWK6HOzq8aCurUqhXWAMMUy/+RMmii/eAUYC97aUpHk/?=
 =?us-ascii?Q?fdysBLUGpyyxMLZ3skehJxA0c//ItybM78iqUa1lE/ZXC62bvtLbZZTw4ZqT?=
 =?us-ascii?Q?8Mu5ogCxVPDqsattUtvR6wxtrdlmiH1WyTkUdx+qKFcTb/EKbE4S7Qen5Q1B?=
 =?us-ascii?Q?uUaG2riRZ/xI6vQ0CB72fLsdF0fqhd4H9y8b7oci2l/S05amn0ig6HPae62E?=
 =?us-ascii?Q?Y5BQRJcwFofKnH75LpxKkBwImSM8HQHS66TCMpm942taalK6nph2P93NzQJx?=
 =?us-ascii?Q?o50q3EFHvS3BGdclRX440Rdz/BtRm+kfaNZZn3/pZt/kI4DwHMN7349BZbgn?=
 =?us-ascii?Q?pDycm9iwByo4GWjpv7y1oH2qqxpHsZpdH327aUkMVFoqj+JyrvuZOfczs1bc?=
 =?us-ascii?Q?fHG+mBUI1hEa4u/ToC90jrKZyr2abIiT3Dd+phYwGk6w0/ypnc9PETZa6xiC?=
 =?us-ascii?Q?xVtgAH+8nIMHwLO2pm2X04zMEcf9BnOxo/NSVo8QZJ+MstxkemduHdK9EAjl?=
 =?us-ascii?Q?iflGhmZxxNJuYIOFa7IJ6ViAuwu2NttHtsgtr8U3eePqIpITSMk1CN2d4EA/?=
 =?us-ascii?Q?bFIFKmralIvCT8rAnfFNhurOIPge3SIF+TsCVldExurfjjAZGxR+0jA0EmIn?=
 =?us-ascii?Q?G+8qDF3VLw/U5uBOfL4S8l9O/hOyObcVQZ90Pwhp06U5NlB1lR+/wJFBJgJU?=
 =?us-ascii?Q?rjhD/sdhA5fqqVBC04yI3QTYyrgQPicjbYEZO1rHGhO/LSAhTvEzkqg3jHKg?=
 =?us-ascii?Q?zmbsKIbDPkZVV80G4d305PPYPlHU7OmBFsUbkfheKl257zuzxUeyaEnktZs4?=
 =?us-ascii?Q?94oPDGV32AJOQHjlZAa+5xCW4+dP/0dXdIUzK4APFSnMalyYYPMvJdOXDTRx?=
 =?us-ascii?Q?SRb33T+6aoE3MEy4ZZvrRFlhGb5JArM10RZzFXjFfu8KfJ9s91klMDuFcv5e?=
 =?us-ascii?Q?HbFn/Jai2xGUZRMdhI6p7QNNNEpdKZXmlRV/bzPgg9KUw5M7BzCboFgt+p/H?=
 =?us-ascii?Q?BtIRvg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77c9502f-d562-441f-2d21-08db2604866b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 09:55:08.1514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IfPrtNtZ4avCmlWom9+nWdjC/MDM6nhFY4+tGfruOkm1E2fDi2eq2OvbHZCPskiKkwd+Kc96c3rlxh3dXb05RJv+8Q0UMoqJp1fixzXR/jE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4521
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 12:05:41PM +0100, Markus Schneider-Pargmann wrote:
> m_can_tx_handler is the only place where data is written to the tx fifo.
> We can calculate the putidx in the driver code here to avoid the
> dependency on the txfqs register.
> 
> Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
> ---
>  drivers/net/can/m_can/m_can.c | 8 +++++++-
>  drivers/net/can/m_can/m_can.h | 3 +++
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index 4e794166664a..d5bcce948d2c 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -1475,6 +1475,10 @@ static int m_can_start(struct net_device *dev)
>  
>  	m_can_enable_all_interrupts(cdev);
>  
> +	if (cdev->version > 30)
> +		cdev->tx_fifo_putidx = FIELD_GET(TXFQS_TFQPI_MASK,
> +						 m_can_read(cdev, M_CAN_TXFQS));
> +
>  	return 0;
>  }
>  
> @@ -1765,7 +1769,7 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
>  		}
>  
>  		/* get put index for frame */
> -		putidx = FIELD_GET(TXFQS_TFQPI_MASK, txfqs);
> +		putidx = cdev->tx_fifo_putidx;
>  
>  		/* Construct DLC Field, with CAN-FD configuration.
>  		 * Use the put index of the fifo as the message marker,
> @@ -1798,6 +1802,8 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
>  
>  		/* Enable TX FIFO element to start transfer  */
>  		m_can_write(cdev, M_CAN_TXBAR, (1 << putidx));
> +		cdev->tx_fifo_putidx = (++cdev->tx_fifo_putidx >= cdev->can.echo_skb_max ?
> +					0 : cdev->tx_fifo_putidx);
>  
>  		/* stop network queue if fifo full */
>  		if (m_can_tx_fifo_full(cdev) ||
> diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
> index d0c21eddb6ec..548ae908ac4e 100644
> --- a/drivers/net/can/m_can/m_can.h
> +++ b/drivers/net/can/m_can/m_can.h
> @@ -102,6 +102,9 @@ struct m_can_classdev {
>  	u32 tx_max_coalesced_frames_irq;
>  	u32 tx_coalesce_usecs_irq;
>  
> +	// Store this internally to avoid fetch delays on peripheral chips
> +	int tx_fifo_putidx;

nit: it might be slightly nicer to do a pass over the code
     and make putidx unsigned - assuming it is an unsigned value.

> +
>  	struct mram_cfg mcfg[MRAM_CFG_NUM];
>  };
>  
> -- 
> 2.39.2
> 
