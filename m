Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C96B2FE97E
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 13:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730895AbhAUL67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 06:58:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:43128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729203AbhAULUo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 06:20:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F504238E1;
        Thu, 21 Jan 2021 11:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611227999;
        bh=RO3jXDhYC5Xzm11NKqv8LyETJIIZzaeJUKlPdDffSok=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MmH/PpnhhkyQkC2vHMKt6FDhWPnfUBWkWC5MT4VrpH0dNFiHyu4T4CiEIE8EkWFVK
         fBaksPJW1O1NVQmwB3m3zNfAS4T0vshjjdMZPQUh4Csxt5iTcqfkjxCh4aUYP3fYZY
         H0NKg4YDRqDEHoBnJMsWtBnmm37U+xHBn34uGzhU=
Date:   Thu, 21 Jan 2021 12:19:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     davem@davemloft.net, helmut.schaa@googlemail.com,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        sgruszka@redhat.com
Subject: Re: [PATCH] rt2x00: reset reg earlier in rt2500usb_register_read
Message-ID: <YAljW67SPdCvSfSl@kroah.com>
References: <20210121105246.3262768-1-mudongliangabcd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121105246.3262768-1-mudongliangabcd@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 06:52:46PM +0800, Dongliang Mu wrote:
> In the function rt2500usb_register_read(_lock), reg is uninitialized
> in some situation. Then KMSAN reports uninit-value at its first memory
> access. To fix this issue, initialize reg with zero in the function
> rt2500usb_register_read and rt2500usb_register_read_lock
> 
> BUG: KMSAN: uninit-value in rt2500usb_init_eeprom rt2500usb.c:1443 [inline]
> BUG: KMSAN: uninit-value in rt2500usb_probe_hw+0xb5e/0x22a0 rt2500usb.c:1757
> CPU: 0 PID: 3369 Comm: kworker/0:2 Not tainted 5.3.0-rc7+ #0
> Hardware name: Google Compute Engine
> Workqueue: usb_hub_wq hub_event
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
>  kmsan_report+0x162/0x2d0 mm/kmsan/kmsan_report.c:109
>  __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:294
>  rt2500usb_init_eeprom wireless/ralink/rt2x00/rt2500usb.c:1443 [inline]
>  rt2500usb_probe_hw+0xb5e/0x22a0 wireless/ralink/rt2x00/rt2500usb.c:1757
>  rt2x00lib_probe_dev+0xba9/0x3260 wireless/ralink/rt2x00/rt2x00dev.c:1427
>  rt2x00usb_probe+0x7ae/0xf60 wireless/ralink/rt2x00/rt2x00usb.c:842
>  rt2500usb_probe+0x50/0x60 wireless/ralink/rt2x00/rt2500usb.c:1966
>  ......
> 
> Local variable description: ----reg.i.i@rt2500usb_probe_hw
> Variable was created at:
>  rt2500usb_register_read wireless/ralink/rt2x00/rt2500usb.c:51 [inline]
>  rt2500usb_init_eeprom wireless/ralink/rt2x00/rt2500usb.c:1440 [inline]
>  rt2500usb_probe_hw+0x774/0x22a0 wireless/ralink/rt2x00/rt2500usb.c:1757
>  rt2x00lib_probe_dev+0xba9/0x3260 wireless/ralink/rt2x00/rt2x00dev.c:1427
> 
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> ---
>  drivers/net/wireless/ralink/rt2x00/rt2500usb.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> index fce05fc88aaf..98567dc96415 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> @@ -47,7 +47,7 @@ MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
>  static u16 rt2500usb_register_read(struct rt2x00_dev *rt2x00dev,
>  				   const unsigned int offset)
>  {
> -	__le16 reg;
> +	__le16 reg = 0;
>  	rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_READ,
>  				      USB_VENDOR_REQUEST_IN, offset,
>  				      &reg, sizeof(reg));
> @@ -57,7 +57,7 @@ static u16 rt2500usb_register_read(struct rt2x00_dev *rt2x00dev,
>  static u16 rt2500usb_register_read_lock(struct rt2x00_dev *rt2x00dev,
>  					const unsigned int offset)
>  {
> -	__le16 reg;
> +	__le16 reg = 0;
>  	rt2x00usb_vendor_req_buff_lock(rt2x00dev, USB_MULTI_READ,
>  				       USB_VENDOR_REQUEST_IN, offset,
>  				       &reg, sizeof(reg), REGISTER_TIMEOUT);
> -- 
> 2.25.1
> 


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

- This looks like a new version of a previously submitted patch, but you
  did not list below the --- line any changes from the previous version.
  Please read the section entitled "The canonical patch format" in the
  kernel file, Documentation/SubmittingPatches for what needs to be done
  here to properly describe this.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
