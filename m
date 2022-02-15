Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA6B4B6206
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 05:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbiBOEW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 23:22:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbiBOEW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 23:22:28 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D19FA88B8;
        Mon, 14 Feb 2022 20:22:17 -0800 (PST)
Received: from [192.168.12.102] (unknown [159.196.94.94])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id B2E712015A;
        Tue, 15 Feb 2022 12:22:14 +0800 (AWST)
Message-ID: <b857c3087443f86746d81c1d686eaf5044db98a7.camel@codeconstruct.com.au>
Subject: Re: [PATCH net-next v5 2/2] mctp i2c: MCTP I2C binding driver
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     Jakub Kicinski <kuba@kernel.org>, Wolfram Sang <wsa@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
        Zev Weiss <zev@bewilderbeest.net>
Date:   Tue, 15 Feb 2022 12:22:14 +0800
In-Reply-To: <20220211143815.55fb29e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220210063651.798007-1-matt@codeconstruct.com.au>
         <20220210063651.798007-3-matt@codeconstruct.com.au>
         <20220211143815.55fb29e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-02-11 at 14:38 -0800, Jakub Kicinski wrote:
> 
> > +// Removes and unregisters a mctp-i2c netdev
> > +static void mctp_i2c_free_netdev(struct mctp_i2c_dev *midev)
> > 
> You're doing a lot before the unregister call, this is likely racy.
> The usual flow is to unregister the netdev, then do uninit, then free.
> For instance you purge the queue but someone may Tx afterwards.
> needs_free_netdev is a footgun.

Thanks Jakub. I've reworked it here to do the work before register/after
unregister, without needs_free_netdev.

One question, the tx thread calls netif_wake_queue() - is it safe to call
that after unregister_netdev()? (before free_netdev)
I've moved the kthread_stop() to the post-unregister cleanup.

static int mctp_i2c_tx_thread(void *data)
{
	struct mctp_i2c_dev *midev = data;
	struct sk_buff *skb;
	unsigned long flags;

	for (;;) {
		if (kthread_should_stop())
			break;

		spin_lock_irqsave(&midev->tx_queue.lock, flags);
		skb = __skb_dequeue(&midev->tx_queue);
		if (netif_queue_stopped(midev->ndev))
			netif_wake_queue(midev->ndev);      // <-------
		spin_unlock_irqrestore(&midev->tx_queue.lock, flags);


> > +	INIT_LIST_HEAD(&mi_driver_state.clients);
> > +	mutex_init(&mi_driver_state.lock);
> 
> I think there are static initializers for these.
*nod*


Thanks,
Matt


