Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 180555A479B
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 12:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiH2Kws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 06:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiH2Kwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 06:52:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ECD85D113;
        Mon, 29 Aug 2022 03:52:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 414D4B80EB7;
        Mon, 29 Aug 2022 10:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615A6C433C1;
        Mon, 29 Aug 2022 10:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661770364;
        bh=/qIsYw7pC3OIg+O4ZZaXLIShhig52gT7JK1V5dIC2aQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bW5qBkU/BjWLkoMTqUDhSWImKCsyGqCJ7COVb5SVLcYf+AJvg5pmWK72NW2LED9H8
         aB+Bbi2Ynuaeyr3Iog1aOr1Z+5+6VrHtFfV1/zYYwNz7YuOopg8eAKufS6BRNYsLtb
         1Qur/6PmQyPO0Lm4KtTEdnfKZkfACECueXrCokcw=
Date:   Mon, 29 Aug 2022 12:52:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mazin Al Haddad <mazinalhaddad05@gmail.com>
Cc:     pontus.fuchs@gmail.com, netdev@vger.kernel.org, kvalo@kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        edumazet@google.com,
        syzbot+1bc2c2afd44f820a669f@syzkaller.appspotmail.com,
        kuba@kernel.org, pabeni@redhat.com,
        linux-kernel-mentees@lists.linuxfoundation.org, davem@davemloft.net
Subject: Re: [PATCH v3] ar5523: check endpoints type and direction in probe()
Message-ID: <YwyaeNX2vYcHttfU@kroah.com>
References: <20220827110148.203104-1-mazinalhaddad05@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220827110148.203104-1-mazinalhaddad05@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 27, 2022 at 02:01:49PM +0300, Mazin Al Haddad wrote:
> Fixes a bug reported by syzbot, where a warning occurs in usb_submit_urb()
> due to the wrong endpoint type. There is no check for both the number
> of endpoints and the type.
> 
> Fix it by adding a check for the number of endpoints and the
> direction/type of the endpoints. If the endpoints do not match -ENODEV is
> returned.
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
> Link: https://syzkaller.appspot.com/bug?extid=1bc2c2afd44f820a669f
> Reported-and-tested-by: syzbot+1bc2c2afd44f820a669f@syzkaller.appspotmail.com
> Signed-off-by: Mazin Al Haddad <mazinalhaddad05@gmail.com>
> ---
> v2->v3 changes:
>  - Make use of helper functions instead of checking for direction
> 	 and type manually. 
> 
>  drivers/net/wireless/ath/ar5523/ar5523.c | 38 ++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
> index 6f937d2cc126..69979e8f99fd 100644
> --- a/drivers/net/wireless/ath/ar5523/ar5523.c
> +++ b/drivers/net/wireless/ath/ar5523/ar5523.c
> @@ -1581,8 +1581,46 @@ static int ar5523_probe(struct usb_interface *intf,
>  	struct usb_device *dev = interface_to_usbdev(intf);
>  	struct ieee80211_hw *hw;
>  	struct ar5523 *ar;
> +	struct usb_host_interface *host = intf->cur_altsetting;
> +	struct usb_endpoint_descriptor *cmd_tx, *cmd_rx, *data_tx, *data_rx;
>  	int error = -ENOMEM;
>  
> +	if (host->desc.bNumEndpoints != 4) {
> +		dev_err(&dev->dev, "Wrong number of endpoints\n");
> +		return -ENODEV;
> +	}
> +
> +	for (int i = 0; i < host->desc.bNumEndpoints; ++i) {
> +		struct usb_endpoint_descriptor *ep = &host->endpoint[i].desc;
> +
> +		if (usb_endpoint_is_bulk_out(ep)) {
> +			if (!cmd_tx) {
> +				if (ep->bEndpointAddress == AR5523_CMD_TX_PIPE)
> +					cmd_tx = ep;
> +			}
> +			if (!data_tx) {
> +				if (ep->bEndpointAddress == AR5523_DATA_TX_PIPE)
> +					data_tx = ep;
> +				}
> +		}
> +
> +		if (usb_endpoint_is_bulk_in(ep)) {
> +			if (!cmd_rx) {
> +				if (ep->bEndpointAddress == AR5523_CMD_RX_PIPE)
> +					cmd_rx = ep;
> +			}
> +			if (!data_rx) {
> +				if (ep->bEndpointAddress == AR5523_DATA_RX_PIPE)
> +					data_rx = ep;
> +			}
> +		}
> +	}
> +
> +	if (!cmd_tx || !data_tx || !cmd_rx || !data_rx) {
> +		dev_warn("wrong number of endpoints\n");
> +		return -ENODEV;
> +	}

So you save off all of these values, and then do not use them anywhere?
Why not properly save them to the device structure and then you can get
rid of the odd ar5523_cmd_tx_pipe() macros?

Also, I don't see why you can't use the USB core function for finding
endpoints, all you want is the first 2 bulk in and 2 bulk out, that
should be much simpler to use than the above long codebase.

thanks,

greg k-h
