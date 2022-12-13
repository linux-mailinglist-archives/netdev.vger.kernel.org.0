Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADE764BC35
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 19:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236401AbiLMSkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 13:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235529AbiLMSkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 13:40:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9D01097;
        Tue, 13 Dec 2022 10:40:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9123C616DA;
        Tue, 13 Dec 2022 18:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDB3C433D2;
        Tue, 13 Dec 2022 18:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670956840;
        bh=VNLhR2HNLIpNsJL8tOPByX6zJS1xk+en02wwUBFSSGg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W7ISJ+8iOF+4KJ6D3whbyQ5TVmXgvmyBa/CUYnM/T+2OTYuVMa78jvd5loDrvDHnZ
         tV89BHGhjrPd/7gzGP6JLx9daFg5q8mMtNE8DRJp2Z+T12ZL9+VK71KY+qRkra4mh5
         Z0DqStswT8YJtJSFtjjTxSK5STFvPRV8hJL4C19o=
Date:   Tue, 13 Dec 2022 19:40:36 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Seija K." <doremylover123@gmail.com>
Cc:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Fix for packets being rejected in the xHCI
 controller's ring buffer
Message-ID: <Y5jHJJS31+6Smk5L@kroah.com>
References: <CAA42iKz_+MobnyyGi_7vQMwyqmK9=A9w3vWYa8QFVwwUzfrTAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA42iKz_+MobnyyGi_7vQMwyqmK9=A9w3vWYa8QFVwwUzfrTAw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 13, 2022 at 12:14:28PM -0500, Seija K. wrote:
> When a packet larger than MTU arrives in Linux from the modem,
> it is discarded with -EOVERFLOW error (Babble error).
> 
> This is seen on USB3.0 and USB2.0 buses.
> 
> This is because the MRU (Max Receive Size) is not a separate entity
> from the MTU (Max Transmit Size),
> and the received packets can be larger than those transmitted.
> 
> Following the babble error, there was an endless supply of zero-length URBs,
> which are rejected with -EPROTO (increasing the rx input error counter
> each time).
> 
> This is only seen on USB3.0.
> These continue to come ad infinitum until the modem is shut down.
> 
> There appears to be a bug in the core USB handling code in Linux
> that doesn't deal well with network MTUs smaller than 1500 bytes.
> 
> By default, the dev->hard_mtu (the real MTU)
> is in lockstep with dev->rx_urb_size (essentially an MRU),
> and the latter is causing trouble.
> 
> This has nothing to do with the modems,
> as the issue can be reproduced by getting a USB-Ethernet dongle,
> setting the MTU to 1430, and pinging with size greater than 1406.
> 
> Signed-off-by: Seija Kijin <doremylover123@gmail.com>
> Co-Authored-By: TarAldarion <gildeap@tcd.ie>
> 
> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index 554d4e2a84a4..39db53a74b5a 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -842,6 +842,13 @@ static int qmi_wwan_bind(struct usbnet *dev,
> struct usb_interface *intf)
> }
> dev->net->netdev_ops = &qmi_wwan_netdev_ops;
> dev->net->sysfs_groups[0] = &qmi_wwan_sysfs_attr_group;
> + /* LTE Networks don't always respect their own MTU on receive side;
> + * e.g. AT&T pushes 1430 MTU but still allows 1500 byte packets from
> + * far-end network. Make the receive buffer large enough to accommodate
> + * them, and add four bytes so MTU does not equal MRU on network
> + * with 1500 MTU otherwise usbnet_change_mtu() will change both.
> + */
> + dev->rx_urb_size = ETH_DATA_LEN + 4;
> err:
> return status;
> }

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- Your patch is malformed (tabs converted to spaces, linewrapped, etc.)
  and can not be applied.  Please read the file,
  Documentation/process/email-clients.rst in order to fix this.

- It looks like you did not use your "real" name for the patch on either
  the Signed-off-by: line, or the From: line (both of which have to
  match).  Please read the kernel file,
  Documentation/process/submitting-patches.rst for how to do this
  correctly.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
