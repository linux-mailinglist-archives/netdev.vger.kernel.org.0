Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B034F59F367
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 08:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbiHXGEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 02:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234405AbiHXGEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 02:04:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358E091D35;
        Tue, 23 Aug 2022 23:04:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF2C4B822DF;
        Wed, 24 Aug 2022 06:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10050C433C1;
        Wed, 24 Aug 2022 06:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661321078;
        bh=Vg8rTF4/cdtBoLL5ouYQ0cWuabQoYYlJa7ce+p3Xejs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VjcVhUpolXkOJk2e7Xbrrmm38DHGKJUqEQ00X9L5/ERNz4hgHNGGcDmsoZztq5NVl
         b7FlUW3xjkdUD6WyiHQxb5qoxbKQvrsY+cqOOr5MJiRYI0DnevOFXDAPh0EybbK7nv
         XlxhPjuGxasFT70mMeEtHy3TuazFglf1unjI9UCU=
Date:   Wed, 24 Aug 2022 08:04:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mazin Al Haddad <mazinalhaddad05@gmail.com>
Cc:     pontus.fuchs@gmail.com, netdev@vger.kernel.org, kvalo@kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+1bc2c2afd44f820a669f@syzkaller.appspotmail.com,
        edumazet@google.com, paskripkin@gmail.com, kuba@kernel.org,
        pabeni@redhat.com, linux-kernel-mentees@lists.linuxfoundation.org,
        davem@davemloft.net
Subject: Re: [PATCH] ar5523: check endpoints type and direction in probe()
Message-ID: <YwW/cw2cXLEd5xFo@kroah.com>
References: <20220823222436.514204-1-mazinalhaddad05@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823222436.514204-1-mazinalhaddad05@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 24, 2022 at 01:24:38AM +0300, Mazin Al Haddad wrote:
> Fixes a bug reported by syzbot, where a warning occurs in usb_submit_urb()
> due to the wrong endpoint type. There is no check for both the number
> of endpoints and the type which causes an error as the code tries to
> send a URB to the wrong endpoint.
> 
> Fix it by adding a check for the number of endpoints and the
> direction/type of the endpoints. If the endpoints do not match the 
> expected configuration -ENODEV is returned.
> 
> Syzkaller report:
> 
> usb 1-1: BOGUS urb xfer, pipe 3 != type 1
> WARNING: CPU: 1 PID: 71 at drivers/usb/core/urb.c:502 usb_submit_urb+0xed2/0x18a0 drivers/usb/core/urb.c:502
> Modules linked in:
> CPU: 1 PID: 71 Comm: kworker/1:2 Not tainted 5.19.0-rc7-syzkaller-00150-g32f02a211b0a #0
> Hardware name: Google Compute Engine/Google Compute Engine, BIOS Google 06/29/2022
> Workqueue: usb_hub_wq hub_event
> Call Trace:
>  <TASK>
>  ar5523_cmd+0x420/0x790 drivers/net/wireless/ath/ar5523/ar5523.c:275
>  ar5523_cmd_read drivers/net/wireless/ath/ar5523/ar5523.c:302 [inline]
>  ar5523_host_available drivers/net/wireless/ath/ar5523/ar5523.c:1376 [inline]
>  ar5523_probe+0xc66/0x1da0 drivers/net/wireless/ath/ar5523/ar5523.c:1655
> 
> 
> Link: https://syzkaller.appspot.com/bug?extid=1bc2c2afd44f820a669f
> Reported-and-tested-by: syzbot+1bc2c2afd44f820a669f@syzkaller.appspotmail.com
> Signed-off-by: Mazin Al Haddad <mazinalhaddad05@gmail.com>
> ---
>  drivers/net/wireless/ath/ar5523/ar5523.c | 31 ++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
> index 6f937d2cc126..5451bf9ab9fb 100644
> --- a/drivers/net/wireless/ath/ar5523/ar5523.c
> +++ b/drivers/net/wireless/ath/ar5523/ar5523.c
> @@ -1581,8 +1581,39 @@ static int ar5523_probe(struct usb_interface *intf,
>  	struct usb_device *dev = interface_to_usbdev(intf);
>  	struct ieee80211_hw *hw;
>  	struct ar5523 *ar;
> +	struct usb_host_interface *host = intf->cur_altsetting;
>  	int error = -ENOMEM;
>  
> +	if (host->desc.bNumEndpoints != 4) {
> +		dev_err(&dev->dev, "Wrong number of endpoints\n");
> +		return -ENODEV;
> +	}
> +
> +	for (int i = 0; i < host->desc.bNumEndpoints; ++i) {
> +		struct usb_endpoint_descriptor *ep = &host->endpoint[i].desc;
> +		// Check for type of endpoint and direction.
> +		switch (i) {
> +		case 0:
> +		case 1:
> +			if ((ep->bEndpointAddress & USB_DIR_OUT) &&
> +			    ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> +			     == USB_ENDPOINT_XFER_BULK)){

Did you run your change through checkpatch?

> +				dev_err(&dev->dev, "Wrong type of endpoints\n");
> +				return -ENODEV;
> +			}
> +			break;
> +		case 2:
> +		case 3:
> +			if ((ep->bEndpointAddress & USB_DIR_IN) &&
> +			    ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> +			     == USB_ENDPOINT_XFER_BULK)){
> +				dev_err(&dev->dev, "Wrong type of endpoints\n");
> +				return -ENODEV;
> +			}
> +			break;
> +		}

We have usb helper functions for all of this, why not use them instead
of attempting to roll your own?

thanks,

greg k-h
