Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6DAB37BC2
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 20:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730364AbfFFSCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 14:02:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55052 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbfFFSCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 14:02:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2BC4314DDE290;
        Thu,  6 Jun 2019 11:02:36 -0700 (PDT)
Date:   Thu, 06 Jun 2019 11:02:33 -0700 (PDT)
Message-Id: <20190606.110233.2117483278297401420.davem@davemloft.net>
To:     ruxandra.radulescu@nxp.com
Cc:     netdev@vger.kernel.org, ioana.ciornei@nxp.com
Subject: Re: [PATCH net-next v2 2/3] dpaa2-eth: Support multiple traffic
 classes on Tx
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559811029-28002-3-git-send-email-ruxandra.radulescu@nxp.com>
References: <1559811029-28002-1-git-send-email-ruxandra.radulescu@nxp.com>
        <1559811029-28002-3-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Jun 2019 11:02:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Date: Thu,  6 Jun 2019 11:50:28 +0300

> DPNI objects can have multiple traffic classes, as reflected by
> the num_tc attribute. Until now we ignored its value and only
> used traffic class 0.
> 
> This patch adds support for multiple Tx traffic classes; the skb
> priority information received from the stack is used to select the
> hardware Tx queue on which to enqueue the frame.
> 
> Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
> ---
> v2: Extra processing on the fast path happens only when TC is used
> 
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 47 ++++++++++++++++--------
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h |  9 ++++-
>  2 files changed, 40 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> index a12fc45..98de092 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> @@ -757,6 +757,7 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device *net_dev)
>  	u16 queue_mapping;
>  	unsigned int needed_headroom;
>  	u32 fd_len;
> +	u8 prio = 0;
>  	int err, i;
>  
>  	percpu_stats = this_cpu_ptr(priv->percpu_stats);
> @@ -814,6 +815,18 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device *net_dev)
>  	 * a queue affined to the same core that processed the Rx frame
>  	 */
>  	queue_mapping = skb_get_queue_mapping(skb);
> +
> +	if (net_dev->num_tc) {
> +		prio = netdev_txq_to_tc(net_dev, queue_mapping);
> +		/* Hardware interprets priority level 0 as being the highest,
> +		 * so we need to do a reverse mapping to the netdev tc index
> +		 */
> +		prio = net_dev->num_tc - prio - 1;
> +		/* We have only one FQ array entry for all Tx hardware queues
> +		 * with the same flow id (but different priority levels)
> +		 */
> +		queue_mapping %= dpaa2_eth_queue_count(priv);

This doesn't make any sense.

queue_mapping came from skb_get_queue_mapping().

The core limits the queue mapping value to whatever you told the
generic networking layer was the maximum number of queues.

And you set that to dpaa2_eth_queue_count():

	/* Set actual number of queues in the net device */
	num_queues = dpaa2_eth_queue_count(priv);
	err = netif_set_real_num_tx_queues(net_dev, num_queues);

Therfore the modulus cannot be needed.
