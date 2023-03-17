Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0246BED96
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbjCQQC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjCQQC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:02:56 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2111.outbound.protection.outlook.com [40.107.237.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B380E5025;
        Fri, 17 Mar 2023 09:02:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FwtQbDJrw2BFJcN+NSkEEtriM/dAZ1/S6wrlk25LhIYZAGvtLwJPyAUCQe4znkZpHxYVxm9y4J+0Ak3ubL9h4STgdo8m8ai1ykSLHsmissHSXnHMAyWIRDbwawqUZFD1FfvEoANcgD4u1Lqu0dENnJS5NMwPAn/DTdGy1hIpuz4SIWPEVU/Xc/hkMaqwPTzbx3xqfXSD2v96sCP325sZtvK/2Z2u9MDA1d3PhYalLzmTeyQTmDLiu1fzzfwVqNhUZ5eHY2qtSAMU4BsSG20uKQbuPxSK0IeLWoTTG9UNj+L0RJqpfYm009nqPx6iFD3/cXp2XoKGN3FhSEoFyf0XXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7i8/Zq3EDooXfQpKuiIsmKUow4BuzD7u09p/LE+xrjQ=;
 b=B9LzOAMF/i2iqNEv25Qv5yQdtm6iwPLW2nPwky7KWlx8PyMLzUonfl5wKTAjvy5zZhyhiJyGFxGG3gBDzSUdDSnHv0V+i2gYwIWy/CSGkvYr2GPMLCLnuVo7akcegghYZto/FQ4KJfYces/7sc4lnPiLEVvJd25sOyBaurvZVcOzR3jsUSnQW2cH2qLoH9DSL9oXK5tRPDcEVB0WYcoqYVjkGuPQPhdjdGxFmVGsOKNvRFbJfYYH35uRkTiIXbzG+PIBYwwCDS9xICT/Som5QpHoOz4oeP/c524DHuOd7aLvWzGPwr8lGV6p+77XhGquZEtoipLwpaxNA3hfElrL9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7i8/Zq3EDooXfQpKuiIsmKUow4BuzD7u09p/LE+xrjQ=;
 b=c6XVYC1O7WAN1re2QR3VPbzL3jYk4UIHBty7yBMqmBKKkuMZ0mj4IrPvscecpIY2s7Pi8cxNFtWCc0w12+HQbKN46BL7es+v+v2fDPIWeDkzASECeLzt42Itdc1A2jecjfqMFXMDyf6uz8+oKh7bJkG7f+8QWWE6WGXyTcRg8D0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4573.namprd13.prod.outlook.com (2603:10b6:5:3a5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.33; Fri, 17 Mar
 2023 16:02:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 16:02:51 +0000
Date:   Fri, 17 Mar 2023 17:02:44 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 13/16] can: m_can: Introduce a tx_fifo_in_flight
 counter
Message-ID: <ZBSPJHkcLG7gkZ7I@corigine.com>
References: <20230315110546.2518305-1-msp@baylibre.com>
 <20230315110546.2518305-14-msp@baylibre.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315110546.2518305-14-msp@baylibre.com>
X-ClientProxiedBy: AS4P189CA0015.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d7::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4573:EE_
X-MS-Office365-Filtering-Correlation-Id: b1b9de8e-fe7b-4d4d-3548-08db27010f79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sjx5iFpXQtAD+bi3sXIa0c+Zzz7KDMgJwDAIj/Yb5gYquBkEF4nTcYMQbuod1dRrCR6OivlQNcqnI0cjqhNnO4LW/IbNbagkzZrV5kjV+6IJPJ1XHvNYDUkil3CV/b/ERz+hE3iB+C+2jGcCg2jg0uYcKhhdv/1yXk7WJNOB71/IGVLCzbMzq8tNCLjcBEN4RcljbuNKVFN6KgtGI0iJ4IrOm9iMB6bAtLNMFVHJIKE0g08NDoAqhRM9TCUmbMikATkWqQSFDKcKPkOqCxb4xmWd+2wZutqaZ2v81DgbTx7dmxTrKApwp7iCJ4ecvBWYJUFn1HjoEVL/TRICJBuUaFMaYLJ+paNmPSffPkFpGK1ljON6VTEyX461tmJaDt7jyV0Ri8+RwqCdMmPL48wlLBb/QGm+7OsL5aN7HKyrsTqYU+IAv3WX9FBYtwbR7mzra0xq4ZgoUpAA8VxiN6JXJd2lH4Vl6qFThfFr9Obpd1bjVIWMT8WtIyCRD+ohDgbNJDi+7NxaBzy/U3q48B8GiSDngtOum5wKVXsURAjx7+1Yj9Do4eiTcstuQg3HZH6Brm+0C7++qo0YRwB1s/lZ2IFDF2AQcyCIXVQvF9WcqGUtjKU6eq9p1gh1VrgFXHggK+pA8bP9lwcRjdmf7s06vGUW1s8UEy6ag6OmqHKiqKXTxZ6tITH02/MvoIXD3ODo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(346002)(39830400003)(376002)(366004)(451199018)(36756003)(8936002)(41300700001)(44832011)(2906002)(86362001)(5660300002)(38100700002)(66946007)(478600001)(6486002)(8676002)(6666004)(66556008)(66476007)(6916009)(83380400001)(4326008)(54906003)(316002)(6512007)(2616005)(186003)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LplUbEQkExxOhRjZKRgdN4Hytoa5/fK8mGOA9rmMtXi6vXPM3xQsmp9nrC1P?=
 =?us-ascii?Q?dMEUvNr6VR+h2w5TE5yrrc2uczh9/PbIV4zaIZ8aMC2i3vzXJ14T8L9gBV6J?=
 =?us-ascii?Q?ckj8dDOzIrwiYxOVxcFsxmVnZvB+zXBshahXUBlm62HXmdOT7BM7e8ajM+hb?=
 =?us-ascii?Q?XRFBRr+9al1yehJrB+tw1hYmH5xOZBbq+0XzCzCj+fV+4EmikjrmAw3ak0xt?=
 =?us-ascii?Q?BxkoH9Oo3meYPAUDxaOBY4hpFUxrUYVKjxDtgkMo5DxxR3NdhIx0xx8lZNHD?=
 =?us-ascii?Q?uCJCpwcLVpy9DnRFu5G2hSvvsUSwMxEFEGiFcxesJZTdKSMMh/SGNcB8TPMc?=
 =?us-ascii?Q?jw3n34vnzKITlusn37aUDQZDM4Vhjn07693ZA04lsGfVfV91pjLdohdi5cm5?=
 =?us-ascii?Q?kkUxa2P4u8RzbLVE6Pt/jk2ZY/vdfoDZF4tLp56IFZzw1xI3/Sj0kad7EY5R?=
 =?us-ascii?Q?D5OKfvCQCmnxuwKZm5eKqqfB7L7cWURboQB+Vj3TyvZwjLLtn1m8WKxu3PRZ?=
 =?us-ascii?Q?M+5N82EZnzdIn9z64qqqw/sR8+/E3DRkoDP3vf/8R692Y8K4WmxS2w587HJM?=
 =?us-ascii?Q?YaHQq56qgSKteljM5N4GxrvGRkgWVi/f61oZjX8cFCYnGPrJ8YF28B9M99wO?=
 =?us-ascii?Q?bKXn3y7NGGB69IY6WzB2jmW0A+qLhbcn8tm5kmxzlXVipIaWjXE/Kf+LkYk/?=
 =?us-ascii?Q?GX1N2sLHDK6qdwMSKR1DxIXDheB/NOImRLzOjtE8eK3mH8r71sm10Aa0eFLP?=
 =?us-ascii?Q?XNcV96t2soeAoXCyv4+mgPpFdJwDqYoF7p8q+xgq3zx5xlIA7TqZ8iZULsYm?=
 =?us-ascii?Q?JOt3F1suRKmGAVZBGwxpPpWs6KuApkyyHpKI8jrKuxz74fqBKVPeVsszLR9Q?=
 =?us-ascii?Q?bTgCzvEtm8fxqQhqmc4I26YNkV5KBn4AZRLkiQGmg71n0g2Dv968pNNjDLwJ?=
 =?us-ascii?Q?zWHeXOGY/V5q088OQK6+CtNoSU62UwQx4U6iZD2ttVWSb8LZ4r2EeX/C8ta1?=
 =?us-ascii?Q?KBKEoDI+vleQAFeqVtImcfsrxrqynh8FdHtGDuBbXObh2lRDYMqLRAtAWUKM?=
 =?us-ascii?Q?DTTDFu115fo8SppBGrTMe+9/rTTWOJ0cFDIh6anKy/2gcCXE80B19BMpVIfT?=
 =?us-ascii?Q?O7ArTXJ5XWRVWnT5GG0br/SaBMw0oQ9ScMk1aKALD2JtRAUtudG1EyTUXn7p?=
 =?us-ascii?Q?p0ETwXzg10XifdWl9DLxDA6ajjSXavxurRUYqt9Kbwf1Agc/pJW0e9y3a+Cc?=
 =?us-ascii?Q?I+I/FbGzPvTnjKZPmj0RuOx0Hxuft4YNlYdCWMK+AaT27x9hDzonKSN5FXab?=
 =?us-ascii?Q?4RVl/claLcxzhHeq513eetcbuL0lf/oE18KWk+EaUUUFpwe7X6LAOS0gW6NR?=
 =?us-ascii?Q?I1p2fKEzXG3Iu15ip36YTXRJjxLbLMLWWjD5VsIp8grNA9UyfqEWYiq8g3py?=
 =?us-ascii?Q?tYsq8F7Gd36fNO9aAUSFjWkWR99u/OLxurs3ZtwtfkISPWBMVOJxXoaN492h?=
 =?us-ascii?Q?E8a+oT9swbWaAjdTuFRbYoQJAhUq359j1efTHjZGLKRH2Gvwy9NJ2vPgqFet?=
 =?us-ascii?Q?CA7wSc95VD/Az2rnTQfPzPuiFTvDEh2xFE79mhUvyWPqEJaeYI4K7pP6TrM7?=
 =?us-ascii?Q?bX9ifu75jK33RPGsbFZdxR4zyp+ovvYlO9K8D52Wlj+lQ7Y59se0U0qm/Afo?=
 =?us-ascii?Q?VemYmQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1b9de8e-fe7b-4d4d-3548-08db27010f79
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 16:02:51.3140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0UjDo+94a1IW6RM1ynM/VXBvMeKfXzte/a9c08T2mNYAm/WJPCepod29S1ic482mNYQE4SoKdyWrG9VX9jI1Gv9LQ4Xa4hwB5lfQkAb2FJ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4573
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 12:05:43PM +0100, Markus Schneider-Pargmann wrote:
> Keep track of the number of transmits in flight.
> 
> This patch prepares the driver to control the network interface queue
> based on this counter. By itself this counter be
> implemented with an atomic, but as we need to do other things in the
> critical sections later I am using a spinlock instead.
> 
> Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>

Nit, assuming the values are always positive, I think
that unsigned might be a more appropriate type than int
for the tx_fifo_in_flight field, and associated function
parameters and local variables.

That notwithstanding,

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  drivers/net/can/m_can/m_can.c | 41 ++++++++++++++++++++++++++++++++++-
>  drivers/net/can/m_can/m_can.h |  4 ++++
>  2 files changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index 27d36bcc094c..4ad8f08f8284 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -442,6 +442,7 @@ static u32 m_can_get_timestamp(struct m_can_classdev *cdev)
>  static void m_can_clean(struct net_device *net)
>  {
>  	struct m_can_classdev *cdev = netdev_priv(net);
> +	unsigned long irqflags;
>  
>  	for (int i = 0; i != cdev->tx_fifo_size; ++i) {
>  		if (!cdev->tx_ops[i].skb)
> @@ -453,6 +454,10 @@ static void m_can_clean(struct net_device *net)
>  
>  	for (int i = 0; i != cdev->can.echo_skb_max; ++i)
>  		can_free_echo_skb(cdev->net, i, NULL);
> +
> +	spin_lock_irqsave(&cdev->tx_handling_spinlock, irqflags);
> +	cdev->tx_fifo_in_flight = 0;
> +	spin_unlock_irqrestore(&cdev->tx_handling_spinlock, irqflags);
>  }
>  
>  /* For peripherals, pass skb to rx-offload, which will push skb from
> @@ -1023,6 +1028,24 @@ static void m_can_tx_update_stats(struct m_can_classdev *cdev,
>  	stats->tx_packets++;
>  }
>  
> +static void m_can_finish_tx(struct m_can_classdev *cdev, int transmitted)
> +{
> +	unsigned long irqflags;
> +
> +	spin_lock_irqsave(&cdev->tx_handling_spinlock, irqflags);
> +	cdev->tx_fifo_in_flight -= transmitted;
> +	spin_unlock_irqrestore(&cdev->tx_handling_spinlock, irqflags);
> +}
> +
> +static void m_can_start_tx(struct m_can_classdev *cdev)
> +{
> +	unsigned long irqflags;
> +
> +	spin_lock_irqsave(&cdev->tx_handling_spinlock, irqflags);
> +	++cdev->tx_fifo_in_flight;
> +	spin_unlock_irqrestore(&cdev->tx_handling_spinlock, irqflags);
> +}
> +
>  static int m_can_echo_tx_event(struct net_device *dev)
>  {
>  	u32 txe_count = 0;
> @@ -1032,6 +1055,7 @@ static int m_can_echo_tx_event(struct net_device *dev)
>  	int i = 0;
>  	int err = 0;
>  	unsigned int msg_mark;
> +	int processed = 0;
>  
>  	struct m_can_classdev *cdev = netdev_priv(dev);
>  
> @@ -1061,12 +1085,15 @@ static int m_can_echo_tx_event(struct net_device *dev)
>  
>  		/* update stats */
>  		m_can_tx_update_stats(cdev, msg_mark, timestamp);
> +		++processed;
>  	}
>  
>  	if (ack_fgi != -1)
>  		m_can_write(cdev, M_CAN_TXEFA, FIELD_PREP(TXEFA_EFAI_MASK,
>  							  ack_fgi));
>  
> +	m_can_finish_tx(cdev, processed);
> +
>  	return err;
>  }
>  
> @@ -1161,6 +1188,7 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
>  				timestamp = m_can_get_timestamp(cdev);
>  			m_can_tx_update_stats(cdev, 0, timestamp);
>  			netif_wake_queue(dev);
> +			m_can_finish_tx(cdev, 1);
>  		}
>  	} else  {
>  		if (ir & (IR_TEFN | IR_TEFW)) {
> @@ -1846,11 +1874,22 @@ static netdev_tx_t m_can_start_peripheral_xmit(struct m_can_classdev *cdev,
>  	}
>  
>  	netif_stop_queue(cdev->net);
> +
> +	m_can_start_tx(cdev);
> +
>  	m_can_tx_queue_skb(cdev, skb);
>  
>  	return NETDEV_TX_OK;
>  }
>  
> +static netdev_tx_t m_can_start_fast_xmit(struct m_can_classdev *cdev,
> +					 struct sk_buff *skb)
> +{
> +	m_can_start_tx(cdev);
> +
> +	return m_can_tx_handler(cdev, skb);
> +}
> +
>  static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
>  				    struct net_device *dev)
>  {
> @@ -1862,7 +1901,7 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
>  	if (cdev->is_peripheral)
>  		return m_can_start_peripheral_xmit(cdev, skb);
>  	else
> -		return m_can_tx_handler(cdev, skb);
> +		return m_can_start_fast_xmit(cdev, skb);
>  }
>  
>  static int m_can_open(struct net_device *dev)
> diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
> index 2e1a52980a18..e230cf320a6c 100644
> --- a/drivers/net/can/m_can/m_can.h
> +++ b/drivers/net/can/m_can/m_can.h
> @@ -109,6 +109,10 @@ struct m_can_classdev {
>  	// Store this internally to avoid fetch delays on peripheral chips
>  	int tx_fifo_putidx;
>  
> +	/* Protects shared state between start_xmit and m_can_isr */
> +	spinlock_t tx_handling_spinlock;
> +	int tx_fifo_in_flight;
> +
>  	struct m_can_tx_op *tx_ops;
>  	int tx_fifo_size;
>  	int next_tx_op;
> -- 
> 2.39.2
> 
