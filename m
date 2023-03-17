Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2938B6BEDA6
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbjCQQEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbjCQQEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:04:39 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2135.outbound.protection.outlook.com [40.107.237.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8213E5025;
        Fri, 17 Mar 2023 09:04:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=flX7QZhaLJifSLcVMxyGvGWnhhxjC8SbXG4W/0JL19eFuqcLV5OKEBCTQjaItqK9tbmZIKLhUQhILYWGJwM/+daYNjnxgDrSwDWv9PZlz4WFaghI/1ma02v0DCXlxRs5lBVNQZKe4xgqslQzvHt4L6rpD8J2Xdi2JFk4CpYWQfkRMPg75q6GP6mwGM5VRx54U4R0hkkrSTbMtQJp9avfBEi7bY8uRHBXjbEuXv6DYaNuTTpk2PiNiEd1B/57+tNkC14jhwO71DHVfRUtZvbIAz234jUY7rTcaXNMMAGzRG5nfmFwxMhsTlqADwC+6Nu6DxpCrxb2lY0gDSxOc0qAxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kHKqfwXwWQ1CmdHxAqd/C98brGpQyfonwpafyrDqRBg=;
 b=YhtvrkSZu160QPCemHI2QBhu+uEgwxPxjb+YztgwkAPBQ0wPQe+hDIMWMYymhtUMZyo5D6H/z+YQamgaMelb7yg03JjCanI0336H2DxH4Sl/XFeH9/nRB8xaB0DLO7eaGOY0EacVltCdtD5XTyod76LwEZ7subBAJGLaOfdw+Llr0qHgk5zcmN9wAfuNIkL1XP8F3dILemdT9SiECBu50g3IyqRRaqHAgti8zSN7PvojRNENuv4ICyPEheQcFCwpNAzw2imjEwPsvSlm/wFekp0NtbdnDGgPLC9rjxJxpyslYQAc8FeoCVRIyeN6NILDKCmfaU6m+y1wFde7+yLfyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kHKqfwXwWQ1CmdHxAqd/C98brGpQyfonwpafyrDqRBg=;
 b=XTUU6j8XU5UoMPnBBOt+zIipRPYIk/PHHP3DPURit0qFNDErTIE3c7JlTHIKaAprEJ7dbcK33buEOhsZw7f5HJ1ZZePxY196U00xU8NZTIfCpAwkjsBlWjkc4HyIQVVqPrq/4MdSCxMvKrf+azpvQ7JnkgYaAioMUsjbJ8muFVM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB3979.namprd13.prod.outlook.com (2603:10b6:303:56::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 16:04:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 16:04:20 +0000
Date:   Fri, 17 Mar 2023 17:04:14 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 14/16] can: m_can: Use tx_fifo_in_flight for
 netif_queue control
Message-ID: <ZBSPfmWEvl1eSWBV@corigine.com>
References: <20230315110546.2518305-1-msp@baylibre.com>
 <20230315110546.2518305-15-msp@baylibre.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315110546.2518305-15-msp@baylibre.com>
X-ClientProxiedBy: AS4PR09CA0025.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB3979:EE_
X-MS-Office365-Filtering-Correlation-Id: d0161423-2504-4178-9782-08db27014467
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7ov+z4GQgTyPZbDpVMny/ioV2mjWsHla6Goolv9+RgsC9wyEDC5EZNamDIA3YApM8kn7exSZk1+CGQoU3adFkSW/QV79kPmnf+WGt+CU0mxHLc5Rd2RfF53a1zGsYxGSnJs56c/crGADPWyiflBwCy7Yd+Dek1m/gC5ORyW9n9GVjXdyc+XtHHKF/3T7uYgoyHIEkLAJAvJ3r3QnhUgyxxOh5pHbP+Yu5hMHRODJOFHaOqcDuXMSBxl9y8BXTivgunJyDMHWoD5EglKeGHcvn+YB4KjEgs9kwTd3yADIa+CMuuzupVb+9Y4nSAWaThPXkColFKZTxL/k183bH19qOaExV7HWyfKA9BrWEzP6bWCjwxYmQ3mqbpEG+dTdoWQIKo5fWs4XBtF3S8iS9buTj6zwI1TJOTb4ElHWGTSQ+zlYqIvCvw81xpRxxxXMA50WgFf+0VyrfyYa8gtRdot/OZVFeJZINdOZwu6cqCTCn4oez7I797HiwtMnlcgC3doUSjKp7i61Lyz52qOUIr28/eydJS+X4N7EsgUrCvIdTFZgF96FWslJdr7o49VJpmapC7fbTnrCTxxCPz9Aoa1SFBq5w5oUonejhSP5dquBB3MMyRA7imnDIj03TbIpfBG/NNjNqPJLYkC4IL4v0JtKig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(396003)(136003)(346002)(39840400004)(451199018)(36756003)(44832011)(41300700001)(5660300002)(8936002)(2906002)(86362001)(38100700002)(478600001)(66476007)(66556008)(66946007)(8676002)(6916009)(6666004)(6486002)(4326008)(2616005)(54906003)(316002)(186003)(6506007)(83380400001)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wVnkiC6y5lrfn02PkS0Z6yHXXEGxsUg2JEgKpPivuZwsfFc5iNJ86ScVNs6W?=
 =?us-ascii?Q?6xlKWXw0mL197vvJESKMUJU0Q+uQNEkS+hKUFGgWp2KoepwbdOS5toBVW28c?=
 =?us-ascii?Q?rVSIAk5p6FJ6mVplR1vF+F3X8k4Xf50D3NkUXj2KIGWx2fjsYioVQg7ewUyH?=
 =?us-ascii?Q?9cKmQmEdwxRh6XNKovuFrAFyc57yFsJHBTGvYCdZtJYD6pL07t8l2JN9CJj8?=
 =?us-ascii?Q?mkU20s1luG0S+cfeFqIIW4SuTNSOviHWuw5cmxFcuKJOSlL567rlT0JHb+Mi?=
 =?us-ascii?Q?oQR0XHOuskpH44yLrCPFSOX8n0shOXj1cvOrOxcNhAnDNGhoyMy2aLF53dVu?=
 =?us-ascii?Q?P/Uh0+nODamW9OlG6XXrdPa5AY6Jl/NjqseacPOYmGuv4E4jkWBmaCdQWbSI?=
 =?us-ascii?Q?d0XaXNIP5hNMJPiIdBp21SGFD4/AdfxQY9aF2qoekJRFDdGflGvvLa7cNah4?=
 =?us-ascii?Q?bAaNXwq3FHsuW/5mXDnvf2YjmfQSTz6Hxib99HGGc5nM+Ywd8VF6jeSkGaUa?=
 =?us-ascii?Q?EePGNMYYaGrbJHaC41CeaLTpbQyHBzF9MNmEvq8GMjGoikUJRrX8CCyqXl2x?=
 =?us-ascii?Q?VH3oT1ZEPnUc4Y9NbK8yaUIv0Ku0H6lY5CFz7yUJyNFpBLlu6l/JbWa7G8ev?=
 =?us-ascii?Q?uXGHKTZTA3+czcLbXz7nvCSj3ZyMwET2ENMudN1v/N875f1iXBJcMLxpDxm8?=
 =?us-ascii?Q?xnkv2co4RJlWTY8KGuqhkLbhsOuOF0ZUjWkmyilTgrDxL3hPXsQ3w8cnma+t?=
 =?us-ascii?Q?6DKrZJRmjpsl4RjeMw+hNXb27xI81m7rJ2TmNTNSX8HufLMWhg68tiSYYsjp?=
 =?us-ascii?Q?QK5/Y0HmJVxmw7gYHHEXBYBbWCHfm6kJBasX3B1TGiSWCQ1TOiJoDu2LENW+?=
 =?us-ascii?Q?GQlgPKW3wsWQ6arQZ1gZNw72AGgt138w2jTAbqZtcA4g8wyU80Xj/cGMAnVK?=
 =?us-ascii?Q?1ogezayq8GdheNWAI+j1YSzm50asdqK0Th14NEQ9B0qluVtoDWZgutLsN6K6?=
 =?us-ascii?Q?2Ua4nataod0Z+HSgn+D8GSvzrTC2jFP7Vug9P6rylY3X1bA0iClkzPFqPx8v?=
 =?us-ascii?Q?4CTVDCR4QrCZ4lxxQgrsXKhQVNd+qsq98hMbXULbideRazOOmLH2EEzD4N84?=
 =?us-ascii?Q?dsp2BiQlVSbkCsH6SEHjyRkGFpnZQXbeRKw55h1DlOw2zccsYzuCqYBxr25i?=
 =?us-ascii?Q?X8+ClOHlK3UfAl6yi3tuvY4QFxmINuQ7VzNGHRKrdqNL7/YqOFHRSE404zXM?=
 =?us-ascii?Q?yHZKL0TWffsldy9V0HCoKR0eJXlVk4MIIjkHME5QIUrhnDIBFvT0yPjCJkXa?=
 =?us-ascii?Q?C+me/GWriIy8XTn/CeWsZKAEbv4RR3P1SNs4JNfkey7+71RDZmr/mgL3Im9q?=
 =?us-ascii?Q?hbno3+F1sxNa4UXYDg9EpNM0rM40z+mhv7o4dKzwr6UFJesDE++dF3KNfb4i?=
 =?us-ascii?Q?I45QCwpQJ9WrK0OYd9JYO/Ycp1c7mFVsy7xEXmSX3aYk41c7ignD+6Bw73iA?=
 =?us-ascii?Q?oyxVe81tMtX5mbeQSp/OogsE7fPYQ2dYutjciRQK2RvsP6GMTara0IlP1RuI?=
 =?us-ascii?Q?NunfaT2D1j48L7TYkXpkl5uF/STMsIROF7IAfzcOC7EXoCbqBxu5f69ozcQb?=
 =?us-ascii?Q?cefrsHk4xCkQw6r3Rw2yhgejEScMlnOxIn+dadaW1KQgRseFG0RsmuRaE+a2?=
 =?us-ascii?Q?Spr1Jw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0161423-2504-4178-9782-08db27014467
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 16:04:20.1022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8jS2mWd939Lb8mKco+mP6bk6MizLFvnh1oz1D18pXzfASFf+3aSWgf7CukhKXEB1g+Wvfr2Z1TZH/SJBhjhh9aCVFy52+xHkiibrDmL4Mxg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB3979
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 12:05:44PM +0100, Markus Schneider-Pargmann wrote:
> The network queue is currently always stopped in start_xmit and
> continued in the interrupt handler. This is not possible anymore if we
> want to keep multiple transmits in flight in parallel.
> 
> Use the previously introduced tx_fifo_in_flight counter to control the
> network queue instead. This has the benefit of not needing to ask the
> hardware about fifo status.
> 
> This patch stops the network queue in start_xmit if the number of
> transmits in flight reaches the size of the fifo and wakes up the queue
> from the interrupt handler once the transmits in flight drops below the
> fifo size. This means any skbs over the limit will be rejected
> immediately in start_xmit (it shouldn't be possible at all to reach that
> state anyways).
> 
> The maximum number of transmits in flight is the size of the fifo.
> 
> Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
> ---
>  drivers/net/can/m_can/m_can.c | 71 +++++++++++++----------------------
>  1 file changed, 26 insertions(+), 45 deletions(-)
> 
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index 4ad8f08f8284..3cb3d01e1a61 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c

...

> @@ -1033,17 +1023,31 @@ static void m_can_finish_tx(struct m_can_classdev *cdev, int transmitted)
>  	unsigned long irqflags;
>  
>  	spin_lock_irqsave(&cdev->tx_handling_spinlock, irqflags);
> +	if (cdev->tx_fifo_in_flight >= cdev->tx_fifo_size && transmitted > 0)
> +		netif_wake_queue(cdev->net);
>  	cdev->tx_fifo_in_flight -= transmitted;
>  	spin_unlock_irqrestore(&cdev->tx_handling_spinlock, irqflags);
>  }
>  
> -static void m_can_start_tx(struct m_can_classdev *cdev)
> +static netdev_tx_t m_can_start_tx(struct m_can_classdev *cdev)
>  {
>  	unsigned long irqflags;
> +	int tx_fifo_in_flight;
>  
>  	spin_lock_irqsave(&cdev->tx_handling_spinlock, irqflags);
> -	++cdev->tx_fifo_in_flight;
> +	tx_fifo_in_flight = cdev->tx_fifo_in_flight + 1;
> +	if (tx_fifo_in_flight >= cdev->tx_fifo_size) {
> +		netif_stop_queue(cdev->net);
> +		if (tx_fifo_in_flight > cdev->tx_fifo_size) {
> +			netdev_err(cdev->net, "hard_xmit called while TX FIFO full\n");

Perhaps I misunderstand things.
But it seems that this message is triggered in the datapath.
Thus I think it should be rate limited, or perhaps only logged once.

> +			spin_unlock_irqrestore(&cdev->tx_handling_spinlock, irqflags);
> +			return NETDEV_TX_BUSY;
> +		}
> +	}
> +	cdev->tx_fifo_in_flight = tx_fifo_in_flight;
>  	spin_unlock_irqrestore(&cdev->tx_handling_spinlock, irqflags);
> +
> +	return NETDEV_TX_OK;
>  }
>  
>  static int m_can_echo_tx_event(struct net_device *dev)

...

> @@ -1830,11 +1810,6 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev,
>  		m_can_write(cdev, M_CAN_TXBAR, (1 << putidx));
>  		cdev->tx_fifo_putidx = (++cdev->tx_fifo_putidx >= cdev->can.echo_skb_max ?
>  					0 : cdev->tx_fifo_putidx);
> -
> -		/* stop network queue if fifo full */
> -		if (m_can_tx_fifo_full(cdev) ||
> -		    m_can_next_echo_skb_occupied(dev, putidx))
> -			netif_stop_queue(dev);
>  	}

smatch tells me that m_can_next_echo_skb_occupied is now defined but unused.

>  
>  	return NETDEV_TX_OK;

...
