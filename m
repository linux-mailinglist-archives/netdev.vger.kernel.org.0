Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 100534AB8DD
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 11:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235782AbiBGKji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 05:39:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245021AbiBGK1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 05:27:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5B6C043181;
        Mon,  7 Feb 2022 02:27:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6221D612F0;
        Mon,  7 Feb 2022 10:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9849C004E1;
        Mon,  7 Feb 2022 10:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644229649;
        bh=Ea/XgchYNUyDyZnHDIWZphGznZHyvYvoO3mp+EI+3DM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gxp6gjMooNt+0+/sJ9licDOZQh2gXK56cR44iURJCiAjpMcitNE0Aih4wIENC7p9I
         BbflIonrJj5D1ZzJ2gx2qEc/kPc71t9MOMV3BUtqaSyDQsP5XfEALcUifa0EUXJzyK
         PfhC6PqMQEAMbdf/uwsA+Deqy8S4ZPQRJXFUfgu4=
Date:   Mon, 7 Feb 2022 11:27:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        andrew@lunn.ch, oneukum@suse.com, robert.foss@collabora.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+6ca9f7867b77c2d316ac@syzkaller.appspotmail.com,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next] net: asix: add proper error handling of usb
 read errors
Message-ID: <YgD0Dln2R0dPJX/L@kroah.com>
References: <f676e339-5808-2163-2afd-ea254cfb2684@rempel-privat.de>
 <20220206180516.28439-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220206180516.28439-1-paskripkin@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 06, 2022 at 09:05:16PM +0300, Pavel Skripkin wrote:
> Syzbot once again hit uninit value in asix driver. The problem still the
> same -- asix_read_cmd() reads less bytes, than was requested by caller.
> 
> Since all read requests are performed via asix_read_cmd() let's catch
> usb related error there and add __must_check notation to be sure all
> callers actually check return value.
> 
> So, this patch adds sanity check inside asix_read_cmd(), that simply
> checks if bytes read are not less, than was requested and adds missing
> error handling of asix_read_cmd() all across the driver code.
> 
> Fixes: d9fe64e51114 ("net: asix: Add in_pm parameter")
> Reported-and-tested-by: syzbot+6ca9f7867b77c2d316ac@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
> 
> Changes since RFT:
> 	- Added Tested-by: tag
> 
> ---
>  drivers/net/usb/asix.h         |  4 ++--
>  drivers/net/usb/asix_common.c  | 19 +++++++++++++------
>  drivers/net/usb/asix_devices.c | 21 ++++++++++++++++++---
>  3 files changed, 33 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/usb/asix.h b/drivers/net/usb/asix.h
> index 2a1e31def..4334aafab 100644
> --- a/drivers/net/usb/asix.h
> +++ b/drivers/net/usb/asix.h
> @@ -192,8 +192,8 @@ extern const struct driver_info ax88172a_info;
>  /* ASIX specific flags */
>  #define FLAG_EEPROM_MAC		(1UL << 0)  /* init device MAC from eeprom */
>  
> -int asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
> -		  u16 size, void *data, int in_pm);
> +int __must_check asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
> +			       u16 size, void *data, int in_pm);
>  
>  int asix_write_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
>  		   u16 size, void *data, int in_pm);
> diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
> index 71682970b..524805285 100644
> --- a/drivers/net/usb/asix_common.c
> +++ b/drivers/net/usb/asix_common.c
> @@ -11,8 +11,8 @@
>  
>  #define AX_HOST_EN_RETRIES	30
>  
> -int asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
> -		  u16 size, void *data, int in_pm)
> +int __must_check asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
> +			       u16 size, void *data, int in_pm)
>  {
>  	int ret;
>  	int (*fn)(struct usbnet *, u8, u8, u16, u16, void *, u16);
> @@ -27,9 +27,12 @@ int asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
>  	ret = fn(dev, cmd, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
>  		 value, index, data, size);
>  
> -	if (unlikely(ret < 0))
> +	if (unlikely(ret < size)) {
> +		ret = ret < 0 ? ret : -ENODATA;
> +

Didn't I suggest using the proper USB core functions for this instead of
rolling your own functions?  We now have usb_control_msg_read() and
usb_control_msg_send() that prevents this type of thing from happening.

Ah, it's a bit more tangled up than that it seems, the number of layers
of abstractions here is odd and deep.  This change looks fine for now to
keep syzbot happy:

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
