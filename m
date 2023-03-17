Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0555C6BEDB1
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbjCQQGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbjCQQGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:06:35 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2094.outbound.protection.outlook.com [40.107.220.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96BD2529E;
        Fri, 17 Mar 2023 09:05:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hyO/tkHtZ56b0IujOEML55R5xbvqlYoHTOsMgi4UxrvIyKmfnlCdFMp3+Tis6sUITrTzjKQkYtu7x5gEGVd088UBFukEkG9hIFeOxkjGVjRU+nutBGwSgE4GPBNs+OFo/wNYMsQFGZTNcXZGGex5HCQRq73KtbZ2CuKMloX6ZZotXD2vZSWmFKXPWaacMF2uv1IMl5LLnlPR2rxSLSXhOt8OgTNDbiOSIC64qMNue2qFD2fIlAptx4EmonWCA77oRlPYl8DguKfInfw9uaY7+nVR6lp8FYWf8ByeVIoNav7z+Vh2KgduGZOMJ/+bxEm5790bbv5VacdDZ9ok5RDomA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wvOMPCNQwHYjNPc1EQkmSlJT83JRE0dndA0XQvYeHho=;
 b=CfVaxHDWCB72P4IexqfANx0WumLEFu8aLtbAZzZFIrxjVAV3ZBwUbvXTgKKBdErU7qA0U4ITbxXzbs2ikjnMbQsNtf9EfLr6P43U1CezVRS6BYXQn/AAJUjYtRzk6HCdvTGHOYKDjvZcdhVBsIc+DBCghK3NQV+c+jvQ1PxWtT54SUR7RuRlGlQHMCmH+CRbtnRZMEBd6pcVrHSVc44FVoEs3bsCj14wI7LT7Hcrymq+IcOaKXSpbwoi14UwYRnc3VH28iMutQYH2kenyuFeS9RH6mzIL8NzGpp8kv9umS1LAOwk+z+/Vb5jEx63nZDKT+ttMSYzTTTtmBNQMcIgXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wvOMPCNQwHYjNPc1EQkmSlJT83JRE0dndA0XQvYeHho=;
 b=oWb8ieUNL0IYHfh2yRj++tIluTbsV2cU/Wic0H/sStVymvGkM9i7BO+pVj3t62q2dPVkNtyCTBoOH24i7vVxgNJgRtGJFLGgf19tx9kur5ikB16G7xHtKazsDjP61wiWfEV7DpQHUh4MqIN3oMxacymZz1QUKbixHYcvQQdAup0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4462.namprd13.prod.outlook.com (2603:10b6:5:1ba::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 16:05:41 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 16:05:41 +0000
Date:   Fri, 17 Mar 2023 17:05:35 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 15/16] can: m_can: Implement BQL
Message-ID: <ZBSPz1qH1G3FPnVK@corigine.com>
References: <20230315110546.2518305-1-msp@baylibre.com>
 <20230315110546.2518305-16-msp@baylibre.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315110546.2518305-16-msp@baylibre.com>
X-ClientProxiedBy: AM0PR08CA0015.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4462:EE_
X-MS-Office365-Filtering-Correlation-Id: 742ede39-7145-46d5-755f-08db2701749d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qmOpyFSZGwoEMzPW92pqGMXlAinb3T1KIffKNreWXMKOLQjCxbQO6yELrFrXmFOvcY74HQcbY+1MKcmrqxBjlNu6EwbWQoQrVmNTn5qOxgyvyo1LPC9E/Marw94KjLVSaliWhvAUOoTkALPoF+7OwhtTwfrloxuJ5F4MYAWTYqOC91+svUKp8KpbHjXYrETZUDSjk0XAuQ5Qe4asoU0C5q1BFif7gOi+qh6So8yUAFm0+fqya0gTiapmQ2oBIHZqex6IqVD2c1S3eymmEsIhaIfGAuQpdKpk7g7vxVfVubB+GoTASmnKknQbdPu7bQl/uLXkoLjphiD0mpuBAAhArGlHRlt0EF7VIIY3unJjTaysoMbg7a6Cd2bmU/19Ej4DcC8bHfjQksXHXoqoOzt0cJs+DrTPGnehOTFfZ8JtJ1Huhi5cy6bD522cK8lXa7WxOaxdd253Z5ux9vqnxGbqBhXrXtywVeWO+DI3Z6vGcccSqrOqJMhwZ/nNUItyyIyy5vo1Ghj5rG1EsKZPtfiTW8wiBziT6O7JaHj9Sjs6M8FM3He+yce0h94iX5U1hMuPM2LV2FHcsfv08uqcnI/SKlR0jeF3RKaGBdWY1Uq5xonJZ2nY3dQ8c47q+bbn09MzxGjC+PMSAFB4MNBKtUA1Zg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39840400004)(376002)(396003)(366004)(136003)(451199018)(186003)(2616005)(6486002)(6666004)(2906002)(83380400001)(478600001)(6506007)(6512007)(54906003)(316002)(8676002)(66476007)(66556008)(66946007)(4326008)(6916009)(8936002)(41300700001)(5660300002)(44832011)(86362001)(38100700002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dpw4D13SW7gb9DgpDDMJJ2H4IHTVnM364tak0gVqIoEpNhYhmfCIKmnd3fRz?=
 =?us-ascii?Q?9/rgGTorrU+qmqc+JsSgy2Ib1U+IHyVoXf914303ZdSSjAhjkQVJPnfdFpaA?=
 =?us-ascii?Q?ngtTDDddrCftVXQbT4LzS3voHPvpgxhY+hmJr7Nz3Vu24IbKPCex7F6KKZ+7?=
 =?us-ascii?Q?0r6++8DzuRfGwRz40BOO9rU77oVYv7CW2O5UtDEffOPEPSLGNlWW7TotX4VE?=
 =?us-ascii?Q?Tutht5yT8W1Hi5UVa1hCd0g4oKG1Vqn747CayFcjmW1NcYrChymQHMA8LLLE?=
 =?us-ascii?Q?t/xr12YorMW0wwek8eo1xfjDn5FmSh8XgXAudu/UqAzggZY+yKhop4MAu8c6?=
 =?us-ascii?Q?gAfOXcqb67fi6sVb0XqFRU37NnpSG8vBpxq/Y84qNB/o2A91xFbWD4Ztk+xu?=
 =?us-ascii?Q?cz51fK/ggaaiXCbBO6+tFt6lDYUkxI5Bft1BL9aTxfV1WlOAttHOApZ9h3Bh?=
 =?us-ascii?Q?aj2MxRu2tsaD0MSCCJLJsyWF+ZgHCTxofROAewOnutZNIuBex1FqB14tePkE?=
 =?us-ascii?Q?Cay7mW1VdbHXcsOX7o1KxH1bOP7pud/tiNJUCuJhydy7vcx4BLq+5axXClZE?=
 =?us-ascii?Q?tzFVyPkBCgjfehPeOxCXstFlKbqJrwovYFw/nKTDZOGevnzGC9Mzm6ysBpqG?=
 =?us-ascii?Q?/H/AsvsXWiEpEc6b63DavjsTCIfVbg6b8AQrEyHJ4U6kl6zv3CWEX9HkLjBh?=
 =?us-ascii?Q?b4Yo1CIjDq+ypILq04jF0UNihNggY7ZMfbVsuf4ldY/Gg7wBVHCn4qixNQHu?=
 =?us-ascii?Q?ePZOwV9v1O7VZzZ7esCwRm2gTpe2AXh4f7KsU3dPtLP7kQ8k0NwC+J54VeT7?=
 =?us-ascii?Q?6NnWPVm3qWywyPyz+xqAw9lH5A455woEOHSsCyNXiyS5w0Q5Gbw2gyeWjvhF?=
 =?us-ascii?Q?ZUUe/WZ0cBsJ2XAPngsfw5FTYMs/BNNGz3WiulFXo95CxYz+m2W8UjIcnjea?=
 =?us-ascii?Q?rofuv+0YFDkSTKuOk5A0GjY0CB6rUlBqFaW88Iidoy5yUjGPLf6VWDw9P+5B?=
 =?us-ascii?Q?NMJOcWFwMo/92WgEo8MhJbxTek0U9C0jiu+N/uYMRSU++mEInMs3ucCfhwIL?=
 =?us-ascii?Q?AYqk+kNwbRW8JqUTGGoLJEBee+grV0agWwP47qXj4OfVUdoCKduv3R82VmiG?=
 =?us-ascii?Q?2a0ZTTt74wPprrxrDnCzFeaevdrY3wdptGh9tOIk45NUGuWB7ldxLXIQoW9L?=
 =?us-ascii?Q?gHmx2GRsdQmrYFLMLf/DClxzNcDTCvXOtvlOMl+Kwq9Uipe2gfsVHOqprgzl?=
 =?us-ascii?Q?fDcKnBx52K5zMydf7cJiuU+aqyc26ZU6+AK6vF/3fCNO3ChQuPwk5C44qL+c?=
 =?us-ascii?Q?+5aFKDx4ColaEk1ALUL0oCwDJ0nG5NbAInbXEZ2CWKPam6q7LKshkOpNRVFr?=
 =?us-ascii?Q?AMrIE0JbaFWq6OwhFV09vfFblYg7HmpvJBJwmU4Xwq7PhDnbHgQHAVJ71iMC?=
 =?us-ascii?Q?0d6ojGW/ZD1BKtVlAzeDinnF9r4oawLmCWtPenbBLzNje4ruHpYCq++Sb/KI?=
 =?us-ascii?Q?Efq89R6gLDdjJ60WCoV9qvv+5ewDLRzlJMmWSFRkJ7Rh7fF/2ItmwxMFXCWS?=
 =?us-ascii?Q?ouxB9koT2rr5JGlc/bkmfT1OS/tRhYxbswqFGVLFt7ZXOUWkHx7rht5RCSVh?=
 =?us-ascii?Q?8D+y5n5P/0eNwNTd5rIzlEUK89dTvpk2HhTqSCbBCCkTw5qb3Ot6is9Cl9Er?=
 =?us-ascii?Q?+c3X/w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 742ede39-7145-46d5-755f-08db2701749d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 16:05:40.9702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SPG5g343PjHa4WezTbCNOODetJ2H0uKi0W8S02kFne9nYszjanRQ4vN+X3eKyxup9aE+HPlchUGflcvQBv9VQzYFNoIVGh/MGRB4TWRoCB0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4462
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 12:05:45PM +0100, Markus Schneider-Pargmann wrote:
> Implement byte queue limiting in preparation for the use of xmit_more().
> 
> Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>

Nits below aside, this looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  drivers/net/can/m_can/m_can.c | 49 +++++++++++++++++++++++++----------
>  1 file changed, 35 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index 3cb3d01e1a61..63d6e95717e3 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c

...

> @@ -999,29 +1001,34 @@ static int m_can_poll(struct napi_struct *napi, int quota)
>   * echo. timestamp is used for peripherals to ensure correct ordering
>   * by rx-offload, and is ignored for non-peripherals.
>   */
> -static void m_can_tx_update_stats(struct m_can_classdev *cdev,
> -				  unsigned int msg_mark,
> -				  u32 timestamp)
> +static unsigned int m_can_tx_update_stats(struct m_can_classdev *cdev,
> +					  unsigned int msg_mark, u32 timestamp)
>  {
>  	struct net_device *dev = cdev->net;
>  	struct net_device_stats *stats = &dev->stats;
> +	unsigned int frame_len;
>  
>  	if (cdev->is_peripheral)
>  		stats->tx_bytes +=
>  			can_rx_offload_get_echo_skb(&cdev->offload,
>  						    msg_mark,
>  						    timestamp,
> -						    NULL);
> +						    &frame_len);
>  	else
> -		stats->tx_bytes += can_get_echo_skb(dev, msg_mark, NULL);
> +		stats->tx_bytes += can_get_echo_skb(dev, msg_mark, &frame_len);
>  
>  	stats->tx_packets++;
> +
> +	return frame_len;
>  }
>  
> -static void m_can_finish_tx(struct m_can_classdev *cdev, int transmitted)
> +static void m_can_finish_tx(struct m_can_classdev *cdev, int transmitted,
> +			    int transmitted_frame_len)

nit: I think unsigned int would be a better type for transmitted_frame_len,
     as that is the type of the 3rd argument to netdev_completed_queue()

>  {
>  	unsigned long irqflags;
>  
> +	netdev_completed_queue(cdev->net, transmitted, transmitted_frame_len);
> +
>  	spin_lock_irqsave(&cdev->tx_handling_spinlock, irqflags);
>  	if (cdev->tx_fifo_in_flight >= cdev->tx_fifo_size && transmitted > 0)
>  		netif_wake_queue(cdev->net);
> @@ -1060,6 +1067,7 @@ static int m_can_echo_tx_event(struct net_device *dev)
>  	int err = 0;
>  	unsigned int msg_mark;
>  	int processed = 0;
> +	int processed_frame_len = 0;

Likewise, here.

>  	struct m_can_classdev *cdev = netdev_priv(dev);
>  
> @@ -1088,7 +1096,9 @@ static int m_can_echo_tx_event(struct net_device *dev)
>  		fgi = (++fgi >= cdev->mcfg[MRAM_TXE].num ? 0 : fgi);
>  
>  		/* update stats */
> -		m_can_tx_update_stats(cdev, msg_mark, timestamp);
> +		processed_frame_len += m_can_tx_update_stats(cdev, msg_mark,
> +							     timestamp);
> +
>  		++processed;
>  	}
>  
> @@ -1096,7 +1106,7 @@ static int m_can_echo_tx_event(struct net_device *dev)
>  		m_can_write(cdev, M_CAN_TXEFA, FIELD_PREP(TXEFA_EFAI_MASK,
>  							  ack_fgi));
>  
> -	m_can_finish_tx(cdev, processed);
> +	m_can_finish_tx(cdev, processed, processed_frame_len);
>  
>  	return err;
>  }

...
