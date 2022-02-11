Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89EF84B30CC
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 23:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349202AbiBKWiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 17:38:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348124AbiBKWiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 17:38:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB6FD5D;
        Fri, 11 Feb 2022 14:38:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A2F2616A3;
        Fri, 11 Feb 2022 22:38:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB89C340E9;
        Fri, 11 Feb 2022 22:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644619097;
        bh=NTbz/5bCQa7uPxPadJcsQCUFt6hzv0vK4pjKcw/rKYk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C4YLb9PJPQf1Dn3aiWF0Ge5FPu4xB2bQjKSN/58DOBoiRT53Q35ySmeyGVph4SzT+
         ls6OMwQmhk0XRqY0vT5eVFA0hym+Q+kruJytOJ6tHAnWH53HrVZhp3JPUVAUAwwXtL
         G6EJUZYM0b2nCGBKZmEfpl9iXu5+GmSVhNV2eitHlf3GoL043KS9Tn/1x9i4cEc74y
         T5XBSQSZ+38jBy3Pp5OvoiUj2cWlsTAboZBVGKmbMkDt0PAx7SfbavYY9kaiES8rXH
         L3jkUTO7AHGxQ3XWhBYwRcS6jc6/IYInfT7F8EH+0ECJ4dQh5h3zWtx2j/fvflTKvM
         ARSQo/kTL+0tg==
Date:   Fri, 11 Feb 2022 14:38:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matt Johnston <matt@codeconstruct.com.au>,
        Wolfram Sang <wsa@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
        Zev Weiss <zev@bewilderbeest.net>
Subject: Re: [PATCH net-next v5 2/2] mctp i2c: MCTP I2C binding driver
Message-ID: <20220211143815.55fb29e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220210063651.798007-3-matt@codeconstruct.com.au>
References: <20220210063651.798007-1-matt@codeconstruct.com.au>
        <20220210063651.798007-3-matt@codeconstruct.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Feb 2022 14:36:51 +0800 Matt Johnston wrote:
> Provides MCTP network transport over an I2C bus, as specified in
> DMTF DSP0237. All messages between nodes are sent as SMBus Block Writes.
> 
> Each I2C bus to be used for MCTP is flagged in devicetree by a
> 'mctp-controller' property on the bus node. Each flagged bus gets a
> mctpi2cX net device created based on the bus number. A
> 'mctp-i2c-controller' I2C client needs to be added under the adapter. In
> an I2C mux situation the mctp-i2c-controller node must be attached only
> to the root I2C bus. The I2C client will handle incoming I2C slave block
> write data for subordinate busses as well as its own bus.
> 
> In configurations without devicetree a driver instance can be attached
> to a bus using the I2C slave new_device mechanism.
> 
> The MCTP core will hold/release the MCTP I2C device while responses
> are pending (a 6 second timeout or once a socket is closed, response
> received etc). While held the MCTP I2C driver will lock the I2C bus so
> that the correct I2C mux remains selected while responses are received.
> 
> (Ideally we would just lock the mux to keep the current bus selected for
> the response rather than a full I2C bus lock, but that isn't exposed in
> the I2C mux API)
> 
> Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
> Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>

The i2c stuff looks quite unfamiliar, can we can an ack for that?
Does it look sane to you, Wolfram?

>  menu "MCTP Device Drivers"
>  
> +

spurious

>  config MCTP_SERIAL
>  	tristate "MCTP serial transport"
>  	depends on TTY

> +static int mctp_i2c_add_netdev(struct mctp_i2c_client *mcli,
> +			       struct i2c_adapter *adap)
> +{
> +	unsigned long flags;
> +	struct mctp_i2c_dev *midev = NULL;
> +	struct net_device *ndev = NULL;
> +	struct i2c_adapter *root;
> +	char namebuf[30];
> +	int rc;
> +
> +	root = mux_root_adapter(adap);
> +	if (root != mcli->client->adapter) {
> +		dev_err(&mcli->client->dev,
> +			"I2C adapter %s is not a child bus of %s",
> +			mcli->client->adapter->name, root->name);
> +		return -EINVAL;
> +	}
> +
> +	WARN_ON(!mutex_is_locked(&mi_driver_state.lock));
> +	snprintf(namebuf, sizeof(namebuf), "mctpi2c%d", adap->nr);
> +	ndev = alloc_netdev(sizeof(*midev), namebuf, NET_NAME_ENUM, mctp_i2c_net_setup);
> +	if (!ndev) {
> +		dev_err(&mcli->client->dev, "%s alloc netdev failed\n", __func__);
> +		rc = -ENOMEM;
> +		goto err;
> +	}
> +	dev_net_set(ndev, current->nsproxy->net_ns);
> +	SET_NETDEV_DEV(ndev, &adap->dev);
> +	dev_addr_set(ndev, &mcli->lladdr);
> +
> +	midev = netdev_priv(ndev);
> +	skb_queue_head_init(&midev->tx_queue);
> +	INIT_LIST_HEAD(&midev->list);
> +	midev->adapter = adap;
> +	midev->client = mcli;
> +	spin_lock_init(&midev->flow_lock);
> +	midev->i2c_lock_count = 0;
> +	midev->release_count = 0;
> +	/* Hold references */
> +	get_device(&midev->adapter->dev);
> +	get_device(&midev->client->client->dev);
> +	midev->ndev = ndev;
> +	init_waitqueue_head(&midev->tx_wq);
> +	midev->tx_thread = kthread_create(mctp_i2c_tx_thread, midev,
> +					  "%s/tx", namebuf);
> +	if (IS_ERR_OR_NULL(midev->tx_thread)) {
> +		rc = -ENOMEM;
> +		goto err_free;
> +	}
> +
> +	rc = mctp_register_netdev(ndev, &mctp_i2c_mctp_ops);
> +	if (rc < 0) {
> +		dev_err(&mcli->client->dev,
> +			"%s register netdev \"%s\" failed %d\n", __func__,
> +			ndev->name, rc);
> +		goto err_stop_kthread;
> +	}
> +	spin_lock_irqsave(&mcli->curr_lock, flags);
> +	list_add(&midev->list, &mcli->devs);
> +	// Select a device by default
> +	if (!mcli->sel)
> +		__mctp_i2c_device_select(mcli, midev);
> +	spin_unlock_irqrestore(&mcli->curr_lock, flags);
> +
> +	wake_up_process(midev->tx_thread);

Simliar but inverse comment as below...

> +	return 0;
> +
> +err_stop_kthread:
> +	kthread_stop(midev->tx_thread);
> +
> +err_free:
> +	free_netdev(ndev);
> +
> +err:
> +	return rc;
> +}
> +
> +// Removes and unregisters a mctp-i2c netdev
> +static void mctp_i2c_free_netdev(struct mctp_i2c_dev *midev)
> +{
> +	struct mctp_i2c_client *mcli = midev->client;
> +	unsigned long flags;
> +
> +	netif_stop_queue(midev->ndev);
> +	kthread_stop(midev->tx_thread);
> +	skb_queue_purge(&midev->tx_queue);
> +
> +	/* Release references, used only for TX which has stopped */
> +	put_device(&midev->adapter->dev);
> +	put_device(&mcli->client->dev);
> +
> +	/* Remove it from the parent mcli */
> +	spin_lock_irqsave(&mcli->curr_lock, flags);
> +	list_del(&midev->list);
> +	if (mcli->sel == midev) {
> +		struct mctp_i2c_dev *first;
> +
> +		first = list_first_entry_or_null(&mcli->devs, struct mctp_i2c_dev, list);
> +		__mctp_i2c_device_select(mcli, first);
> +	}
> +	spin_unlock_irqrestore(&mcli->curr_lock, flags);

You're doing a lot before the unregister call, this is likely racy.
The usual flow is to unregister the netdev, then do uninit, then free.
For instance you purge the queue but someone may Tx afterwards.
needs_free_netdev is a footgun.

> +	/* Remove netdev. mctp_i2c_slave_cb() takes a dev_hold() so removing
> +	 * it now is safe. unregister_netdev() frees ndev and midev.
> +	 */
> +	mctp_unregister_netdev(midev->ndev);
> +}

> +static __init int mctp_i2c_init(void)
> +{
> +	int rc;
> +
> +	INIT_LIST_HEAD(&mi_driver_state.clients);
> +	mutex_init(&mi_driver_state.lock);

I think there are static initializers for these.
