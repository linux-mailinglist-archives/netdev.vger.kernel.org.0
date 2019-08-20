Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 391EC96C36
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731033AbfHTW2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:28:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730638AbfHTW2L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 18:28:11 -0400
Received: from localhost (li1825-44.members.linode.com [172.104.248.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BD1E22DA7;
        Tue, 20 Aug 2019 22:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566340091;
        bh=yjV+99lCgsz4QxTJVtoV1wZiTnNI5b0nk4QnO2S7X34=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r1H0O6aR3jggX0rVkU/AnvbNyHtfqnSyzrKrZyt871pAVYjnvl/LfcaEJP3COOCFC
         fLNvPUzb6bZ5Rv5KLWxrjjzYiF67zMAwTWjd50KTE5yaLqr4plgv1iE3cwpUy7CTsC
         bmJWc2qY+EK9PHIyouiuzNW76kjUnjFcGfHpPwRM=
Date:   Tue, 20 Aug 2019 15:28:05 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Charles.Hyde@dellteam.com
Cc:     linux-usb@vger.kernel.org, linux-acpi@vger.kernel.org,
        Mario.Limonciello@dell.com, oliver@neukum.org,
        netdev@vger.kernel.org, nic_swsd@realtek.com
Subject: Re: [RFC 1/4] Add usb_get_address and usb_set_address support
Message-ID: <20190820222805.GD8120@kroah.com>
References: <1566339522507.45056@Dellteam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566339522507.45056@Dellteam.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 10:18:42PM +0000, Charles.Hyde@dellteam.com wrote:
> +int usb_get_address(struct usb_device *dev, unsigned char * mac)
> +{
> +	int ret = -ENOMEM;
> +	unsigned char *tbuf = kmalloc(256, GFP_NOIO);

On a technical level, why are you asking for 256 bytes here, and in the
control message, yet assuming you will only get 6 back for a correct
message?  Shouldn't you be only asking for 6 bytes?

> +
> +	if (!tbuf)
> +		return -ENOMEM;
> +
> +	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
> +			USB_CDC_GET_NET_ADDRESS,
> +			USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
> +			0, USB_REQ_SET_ADDRESS, tbuf, 256,
> +			USB_CTRL_GET_TIMEOUT);
> +	if (ret == 6)
> +		memcpy(mac, tbuf, 6);
> +
> +	kfree(tbuf);
> +	return ret;

So if 100 is returned by the device (not likely, but let's say 7), then
you return 7 bytes, yet you did not copy the data into the pointer given
to you.

SHouldn't you report a real error for when this happens (hint, it will.)

thanks,

greg k-h
