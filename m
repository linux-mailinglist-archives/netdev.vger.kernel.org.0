Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB66D36F893
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 12:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhD3KkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 06:40:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:41296 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229543AbhD3KkW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 06:40:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619779173; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WfpaOe4d0bMzy825G2nFjAwJXQmQpnXp8V7P/s3gFwY=;
        b=WFSYTo1zXRLtAZetE91RzdY82mBnB+4GvPTYExSdMAlA/ka0VQOS9zlPx6qIf+jLIJZBc0
        gDW+SU8PRiTAgDK8kMb5iDd+M1VYeQAt5qZ4YDbAinAgdmwjrK1RdHS0ftGCo07gPpZpfc
        wEKgWxka2tP4wKnxUAC2px0BeqgXsfk=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CDF21B20E;
        Fri, 30 Apr 2021 10:39:33 +0000 (UTC)
Message-ID: <bf02f5ecf84b7eaaa05768edd933a321f701e79f.camel@suse.com>
Subject: Re: [RFC net-next 2/2] usb: class: cdc-wdm: WWAN framework
 integration
From:   Oliver Neukum <oneukum@suse.com>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org, kuba@kernel.org,
        bjorn@mork.no
Date:   Fri, 30 Apr 2021 12:39:29 +0200
In-Reply-To: <1619777783-24116-2-git-send-email-loic.poulain@linaro.org>
References: <1619777783-24116-1-git-send-email-loic.poulain@linaro.org>
         <1619777783-24116-2-git-send-email-loic.poulain@linaro.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Freitag, den 30.04.2021, 12:16 +0200 schrieb Loic Poulain:

> It would then make sense to migrate cdc-wdm to this unified framework
> and register the USB modem control endpoints as standard WWAN control
> ports.

This absolutely makes sense, but I have questions about the
implementation. I am putting comments inline.

	Regards
		Oliver

 
>  static struct usb_driver wdm_driver;
> @@ -203,7 +206,23 @@ static void wdm_in_callback(struct urb *urb)
>  	if (desc->rerr == 0 && status != -EPIPE)
>  		desc->rerr = status;
>  
> -	if (length + desc->length > desc->wMaxCommand) {
> +	if (test_bit(WDM_WWAN_IN_USE, &desc->flags)) {
> +		struct wwan_port *port = desc->wwanp;
> +		struct sk_buff *skb;
> +
> +		/* Forward data to WWAN port */
> +		skb = alloc_skb(length, GFP_ATOMIC);

You want to allocate an skb in the callback? Is that really necessary?

> +		if (skb) {
> +			memcpy(skb_put(skb, length), desc->inbuf, length);
> +			wwan_port_rx(port, skb);
> +		} else {
> +			dev_err(&desc->intf->dev,
> +				"Unable to alloc skb, response discarded\n");
> +		}
> +
> +		/* inbuf has been copied, it is safe to check for outstanding data */
> +		schedule_work(&desc->service_outs_intr);
> +	} else if (length + desc->length > desc->wMaxCommand) {
>  		/* The buffer would overflow */
>  		set_bit(WDM_OVERFLOW, &desc->flags);
>  	} else {
> @@ -699,6 +718,11 @@ static int wdm_open(struct inode *inode, struct file *file)
>  		goto out;
>  	file->private_data = desc;
>  
> +	if (test_bit(WDM_WWAN_IN_USE, &desc->flags)) {
> +		rv = -EBUSY;
> +		goto out;
> +	}
> +
>  	rv = usb_autopm_get_interface(desc->intf);
>  	if (rv < 0) {
>  		dev_err(&desc->intf->dev, "Error autopm - %d\n", rv);
> @@ -794,6 +818,146 @@ static struct usb_class_driver wdm_class = {
>  	.minor_base =	WDM_MINOR_BASE,
>  };
>  
> +/* --- WWAN framework integration --- */
> +#ifdef CONFIG_WWAN
> +static int wdm_wwan_port_start(struct wwan_port *port)
> +{
> +	struct wdm_device *desc = wwan_port_get_drvdata(port);
> +
> +	/* The interface is both exposed via the WWAN framework and as a
> +	 * legacy usbmisc chardev. If chardev is already open, just fail
> +	 * to prevent concurrent usage. Otherwise, switch to WWAN mode.
> +	 */
> +	mutex_lock(&wdm_mutex);
> +	if (desc->count) {
> +		mutex_unlock(&wdm_mutex);
> +		return -EBUSY;
> +	}
> +	set_bit(WDM_WWAN_IN_USE, &desc->flags);
> +	mutex_unlock(&wdm_mutex);
> +
> +	desc->manage_power(desc->intf, 1);
> +
> +	/* Start getting events */
> +	usb_submit_urb(desc->validity, GFP_KERNEL);
> +
> +	/* tx is allowed */
> +	wwan_port_txon(port);

Is the order here correct? This looks like you could get an
event you cannot yet respond to. And you have no error handling.
> +
> +	return 0;
> +}
> +
> +static void wdm_wwan_port_stop(struct wwan_port *port)
> +{
> +	struct wdm_device *desc = wwan_port_get_drvdata(port);
> +
> +	/* Stop all transfers and disable WWAN mode */
> +	kill_urbs(desc);
> +	desc->manage_power(desc->intf, 0);
> +	clear_bit(WDM_READ, &desc->flags);
> +	clear_bit(WDM_WWAN_IN_USE, &desc->flags);
> +}
> +
> +static void wdm_wwan_port_tx_complete(struct urb *urb)
> +{
> +	struct sk_buff *skb = urb->context;
> +	struct wwan_port *port = skb_shinfo(skb)->destructor_arg;
> +
> +	/* Allow new command transfer */
> +	wwan_port_txon(port);
> +	kfree_skb(skb);
> +}
> +
> +static int wdm_wwan_port_tx(struct wwan_port *port, struct sk_buff *skb)
> +{
> +	struct wdm_device *desc = wwan_port_get_drvdata(port);
> +	struct usb_interface *intf = desc->intf;
> +	struct usb_ctrlrequest *req = desc->orq;
> +	int rv;
> +
> +	rv = usb_autopm_get_interface(intf);
> +	if (rv)
> +		return rv;
> +
> +	usb_fill_control_urb(
> +		desc->command,
> +		interface_to_usbdev(intf),
> +		usb_sndctrlpipe(interface_to_usbdev(intf), 0),
> +		(unsigned char *)req,
> +		skb->data,
> +		skb->len,
> +		wdm_wwan_port_tx_complete,
> +		skb
> +	);
> +
> +	req->bRequestType = (USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE);
> +	req->bRequest = USB_CDC_SEND_ENCAPSULATED_COMMAND;
> +	req->wValue = 0;
> +	req->wIndex = desc->inum;
> +	req->wLength = cpu_to_le16(skb->len);
> +
> +	skb_shinfo(skb)->destructor_arg = port;
> +
> +	rv = usb_submit_urb(desc->command, GFP_KERNEL);
> +	if (!rv) /* One transfer at a time, stop TX until URB completion */
> +		wwan_port_txoff(port);
> +
> +	usb_autopm_put_interface(intf);

No, that runtime PM is broken. You have a running transmission.

> +
> +	return rv;
> +}
> +
> +static struct wwan_port_ops wdm_wwan_port_ops = {
> +	.start = wdm_wwan_port_start,
> +	.stop = wdm_wwan_port_stop,
> +	.tx = wdm_wwan_port_tx,
> +};
> +
> +static void wdm_wwan_init(struct wdm_device *desc)
> +{
> +	struct usb_interface *intf = desc->intf;
> +	struct wwan_port *port;
> +
> +	switch (desc->type) {
> +	case USB_CDC_WDM_MBIM:
> +		port = wwan_create_port(&intf->dev, WWAN_PORT_MBIM,
> +					&wdm_wwan_port_ops, desc);
> +		break;
> +	case USB_CDC_WDM_QMI:
> +		port = wwan_create_port(&intf->dev, WWAN_PORT_QMI,
> +					&wdm_wwan_port_ops, desc);
> +		break;
> +	case USB_CDC_WDM_AT:
> +		port = wwan_create_port(&intf->dev, WWAN_PORT_AT,
> +					&wdm_wwan_port_ops, desc);

Just use the common types. This is redundant.

> +		break;
> +	default:
> +		dev_info(&intf->dev, "Unknown control protocol\n");
> +		return;
> +	}
> +
> +	if (IS_ERR(port)) {
> +		dev_err(&intf->dev, "%s: Unable to create WWAN port\n",
> +			dev_name(intf->usb_dev));
> +		return;
> +	}
> +
> +	desc->wwanp = port;
> +}
> +
> +static void wdm_wwan_deinit(struct wdm_device *desc)
> +{
> +	if (!desc->wwanp)
> +		return;
> +
> +	wwan_remove_port(desc->wwanp);
> +	desc->wwanp = NULL;
> +}
> +#else /* CONFIG_WWAN */
> +static void wdm_wwan_init(struct wdm_device *desc) {}
> +static void wdm_wwan_deinit(struct wdm_device *desc) {}
> +#endif /* CONFIG_WWAN */
> +
>  /* --- error handling --- */
>  static void wdm_rxwork(struct work_struct *work)
>  {
> @@ -937,6 +1101,9 @@ static int wdm_create(struct usb_interface *intf, struct usb_endpoint_descriptor
>  		goto err;
>  	else
>  		dev_info(&intf->dev, "%s: USB WDM device\n", dev_name(intf->usb_dev));
> +
> +	wdm_wwan_init(desc);
> +
>  out:
>  	return rv;
>  err:
> @@ -1034,6 +1201,8 @@ static void wdm_disconnect(struct usb_interface *intf)
>  	desc = wdm_find_device(intf);
>  	mutex_lock(&wdm_mutex);
>  
> +	wdm_wwan_deinit(desc);
> +
>  	/* the spinlock makes sure no new urbs are generated in the callbacks */
>  	spin_lock_irqsave(&desc->iuspin, flags);
>  	set_bit(WDM_DISCONNECTING, &desc->flags);


