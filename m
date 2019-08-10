Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4ED88A87
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 12:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbfHJKNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 06:13:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbfHJKNU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 06:13:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B843F20B7C;
        Sat, 10 Aug 2019 10:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565431999;
        bh=xxIhXdXrNYgZy+a1g/JRW7MbrkKrZsW0bGELVlqKFBw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ctNhXmpSiavk41/UgdlWjh3DR1JDGpe5VWInUhTHszrusWwCkZaAmxC6jIUdY2FHV
         WOR9mLzjaFF7r1+VZHaHZ09n8gH+N129bspBw9zh8UeR3rEg+hamoROySGQMbpy+uU
         TY6AqrvLV+JiYnGsRTGCsiaRfmDNOW2q7ucmvdHo=
Date:   Sat, 10 Aug 2019 12:13:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hui Peng <benquike@gmail.com>
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Fix a NULL-ptr-deref bug in
 ath6kl_usb_alloc_urb_from_pipe
Message-ID: <20190810101316.GA25650@kroah.com>
References: <20190804002905.11292-1-benquike@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190804002905.11292-1-benquike@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 03, 2019 at 08:29:04PM -0400, Hui Peng wrote:
> The `ar_usb` field of `ath6kl_usb_pipe_usb_pipe` objects
> are initialized to point to the containing `ath6kl_usb` object
> according to endpoint descriptors read from the device side, as shown
> below in `ath6kl_usb_setup_pipe_resources`:
> 
> for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
> 	endpoint = &iface_desc->endpoint[i].desc;
> 
> 	// get the address from endpoint descriptor
> 	pipe_num = ath6kl_usb_get_logical_pipe_num(ar_usb,
> 						endpoint->bEndpointAddress,
> 						&urbcount);
> 	......
> 	// select the pipe object
> 	pipe = &ar_usb->pipes[pipe_num];
> 
> 	// initialize the ar_usb field
> 	pipe->ar_usb = ar_usb;
> }
> 
> The driver assumes that the addresses reported in endpoint
> descriptors from device side  to be complete. If a device is
> malicious and does not report complete addresses, it may trigger
> NULL-ptr-deref `ath6kl_usb_alloc_urb_from_pipe` and
> `ath6kl_usb_free_urb_to_pipe`.
> 
> This patch fixes the bug by preventing potential NULL-ptr-deref.
> 
> Signed-off-by: Hui Peng <benquike@gmail.com>
> Reported-by: Hui Peng <benquike@gmail.com>
> Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
