Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88A030344D
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732263AbhAZFWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:22:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24452 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730464AbhAYPzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 10:55:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611590038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ho5yN2BqcAuQrfjhdWv85S1Zm3Z9U6h5Eo3Y6UxTXxc=;
        b=ONrV58m+tIcNevhYCKUsWlEBqqk9cjhyeZF6fgTcNOjEVHnGckZQgvLhEh5HYETRcH2+vi
        CsxGBnxO/L0oWVLNHbPiumvH/r5dgnQ3Uw1Fc8YOci9XcfRTZ6rg6oU8j8pmkq+xbH5ock
        HoKDCM19zDLgSKsEMHyZrx4WLE0x9qk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-j9efcgliNbG5lNuFeEejzA-1; Mon, 25 Jan 2021 10:53:56 -0500
X-MC-Unique: j9efcgliNbG5lNuFeEejzA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B720107ACE4;
        Mon, 25 Jan 2021 15:53:53 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.10.110.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 113DE19C47;
        Mon, 25 Jan 2021 15:53:50 +0000 (UTC)
Message-ID: <9c4aa5531548bf4a2e8b060b724a341476780b5d.camel@redhat.com>
Subject: Re: [PATCH net-next v2] net: qmi_wwan: Add pass through mode
From:   Dan Williams <dcbw@redhat.com>
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        stranche@codeaurora.org, aleksander@aleksander.es,
        dnlplm@gmail.com, bjorn@mork.no, stephan@gerhold.net,
        ejcaruso@google.com, andrewlassalle@google.com
Date:   Mon, 25 Jan 2021 09:53:50 -0600
In-Reply-To: <1611560015-20034-1-git-send-email-subashab@codeaurora.org>
References: <1611560015-20034-1-git-send-email-subashab@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-01-25 at 00:33 -0700, Subash Abhinov Kasiviswanathan
wrote:
> Pass through mode is to allow packets in MAP format to be passed
> on to the stack. rmnet driver can be used to process and demultiplex
> these packets.
> 
> Pass through mode can be enabled when the device is in raw ip mode
> only.
> Conversely, raw ip mode cannot be disabled when pass through mode is
> enabled.
> 
> Userspace can use pass through mode in conjunction with rmnet driver
> through the following steps-
> 
> 1. Enable raw ip mode on qmi_wwan device
> 2. Enable pass through mode on qmi_wwan device
> 3. Create a rmnet device with qmi_wwan device as real device using
> netlink

This option is module-wide, right?

eg, if there are multiple qmi_wwan-driven devices on the system, *all*
of them must use MAP + passthrough, or none of them can, right?

There are users that run 2+ devices on the same system, and different
cards. I'm not sure I would assume that all can/would run in the same
mode, unfortunately.

Dan

> Signed-off-by: Subash Abhinov Kasiviswanathan <
> subashab@codeaurora.org>
> ---
> v1->v2: Update commit text and fix the following comments from Bjorn-
> Remove locking as no netdev state change is requried since all the
> configuration is already done in raw_ip_store.
> Check the inverse relationship between raw_ip mode and pass_through
> mode.
> pass_through_mode just sets/resets the flag now.
> raw_ip check is not needed when queueing pass_through mode packets as
> that is enforced already during the mode configuration.
> 
>  drivers/net/usb/qmi_wwan.c | 58
> ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 58 insertions(+)
> 
> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index 7ea113f5..e58a80a 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -57,6 +57,7 @@ struct qmi_wwan_state {
>  enum qmi_wwan_flags {
>  	QMI_WWAN_FLAG_RAWIP = 1 << 0,
>  	QMI_WWAN_FLAG_MUX = 1 << 1,
> +	QMI_WWAN_FLAG_PASS_THROUGH = 1 << 2,
>  };
>  
>  enum qmi_wwan_quirks {
> @@ -326,6 +327,13 @@ static ssize_t raw_ip_store(struct device
> *d,  struct device_attribute *attr, co
>  	if (enable == (info->flags & QMI_WWAN_FLAG_RAWIP))
>  		return len;
>  
> +	/* ip mode cannot be cleared when pass through mode is set */
> +	if (!enable && (info->flags & QMI_WWAN_FLAG_PASS_THROUGH)) {
> +		netdev_err(dev->net,
> +			   "Cannot clear ip mode on pass through
> device\n");
> +		return -EINVAL;
> +	}
> +
>  	if (!rtnl_trylock())
>  		return restart_syscall();
>  
> @@ -456,14 +464,59 @@ static ssize_t del_mux_store(struct device
> *d,  struct device_attribute *attr, c
>  	return ret;
>  }
>  
> +static ssize_t pass_through_show(struct device *d,
> +				 struct device_attribute *attr, char
> *buf)
> +{
> +	struct usbnet *dev = netdev_priv(to_net_dev(d));
> +	struct qmi_wwan_state *info;
> +
> +	info = (void *)&dev->data;
> +	return sprintf(buf, "%c\n",
> +		       info->flags & QMI_WWAN_FLAG_PASS_THROUGH ? 'Y' :
> 'N');
> +}
> +
> +static ssize_t pass_through_store(struct device *d,
> +				  struct device_attribute *attr,
> +				  const char *buf, size_t len)
> +{
> +	struct usbnet *dev = netdev_priv(to_net_dev(d));
> +	struct qmi_wwan_state *info;
> +	bool enable;
> +
> +	if (strtobool(buf, &enable))
> +		return -EINVAL;
> +
> +	info = (void *)&dev->data;
> +
> +	/* no change? */
> +	if (enable == (info->flags & QMI_WWAN_FLAG_PASS_THROUGH))
> +		return len;
> +
> +	/* pass through mode can be set for raw ip devices only */
> +	if (!(info->flags & QMI_WWAN_FLAG_RAWIP)) {
> +		netdev_err(dev->net,
> +			   "Cannot set pass through mode on non ip
> device\n");
> +		return -EINVAL;
> +	}
> +
> +	if (enable)
> +		info->flags |= QMI_WWAN_FLAG_PASS_THROUGH;
> +	else
> +		info->flags &= ~QMI_WWAN_FLAG_PASS_THROUGH;
> +
> +	return len;
> +}
> +
>  static DEVICE_ATTR_RW(raw_ip);
>  static DEVICE_ATTR_RW(add_mux);
>  static DEVICE_ATTR_RW(del_mux);
> +static DEVICE_ATTR_RW(pass_through);
>  
>  static struct attribute *qmi_wwan_sysfs_attrs[] = {
>  	&dev_attr_raw_ip.attr,
>  	&dev_attr_add_mux.attr,
>  	&dev_attr_del_mux.attr,
> +	&dev_attr_pass_through.attr,
>  	NULL,
>  };
>  
> @@ -510,6 +563,11 @@ static int qmi_wwan_rx_fixup(struct usbnet *dev,
> struct sk_buff *skb)
>  	if (info->flags & QMI_WWAN_FLAG_MUX)
>  		return qmimux_rx_fixup(dev, skb);
>  
> +	if (info->flags & QMI_WWAN_FLAG_PASS_THROUGH) {
> +		skb->protocol = htons(ETH_P_MAP);
> +		return (netif_rx(skb) == NET_RX_SUCCESS);
> +	}
> +
>  	switch (skb->data[0] & 0xf0) {
>  	case 0x40:
>  		proto = htons(ETH_P_IP);

