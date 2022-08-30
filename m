Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F1D5A62E3
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 14:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiH3MJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 08:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiH3MJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 08:09:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1607D7CCD;
        Tue, 30 Aug 2022 05:09:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A897611AF;
        Tue, 30 Aug 2022 12:09:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAEFC433C1;
        Tue, 30 Aug 2022 12:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661861353;
        bh=5SJoOLlqoi3wA7Tl35RDJpwiROFY/iHL4dfRvU6AjnM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gK/iqDo4C0Zmh3B/Nc+4CrNwNlp8phAoKQBEDV7U6eONb46Joz5lH14kH/W7okd4C
         z1/xe/VtSl+JhaXC5uMOa8EA3y0s3LfoUGzwklvFeUT74PRSuTWvBuLCnLJs608KOV
         rFmxIqtIm/n5DlS3PtzYHeWrVCeQrpFhCYQIdgOQ=
Date:   Tue, 30 Aug 2022 14:09:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mazin Al Haddad <mazinalhaddad05@gmail.com>
Cc:     pontus.fuchs@gmail.com, netdev@vger.kernel.org, kvalo@kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+1bc2c2afd44f820a669f@syzkaller.appspotmail.com,
        edumazet@google.com, paskripkin@gmail.com, kuba@kernel.org,
        pabeni@redhat.com, linux-kernel-mentees@lists.linuxfoundation.org,
        davem@davemloft.net
Subject: Re: [PATCH] ar5523: check endpoints type and direction in probe()
Message-ID: <Yw395qJF+eDYaY4Z@kroah.com>
References: <20220823222436.514204-1-mazinalhaddad05@gmail.com>
 <YwW/cw2cXLEd5xFo@kroah.com>
 <CMGQTZ9XBSTJ.5QY7JQCNULBN@Arch-Desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CMGQTZ9XBSTJ.5QY7JQCNULBN@Arch-Desktop>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 27, 2022 at 01:36:29PM +0300, Mazin Al Haddad wrote:
> On Wed Aug 24, 2022 at 9:04 AM +03, Greg KH wrote:
> > On Wed, Aug 24, 2022 at 01:24:38AM +0300, Mazin Al Haddad wrote:
> > > Fixes a bug reported by syzbot, where a warning occurs in usb_submit_urb()
> > > due to the wrong endpoint type. There is no check for both the number
> > > of endpoints and the type which causes an error as the code tries to
> > > send a URB to the wrong endpoint.
> > > 
> > > Fix it by adding a check for the number of endpoints and the
> > > direction/type of the endpoints. If the endpoints do not match the 
> > > expected configuration -ENODEV is returned.
> > > 
> > > Syzkaller report:
> > > 
> > > usb 1-1: BOGUS urb xfer, pipe 3 != type 1
> > > WARNING: CPU: 1 PID: 71 at drivers/usb/core/urb.c:502 usb_submit_urb+0xed2/0x18a0 drivers/usb/core/urb.c:502
> > > Modules linked in:
> > > CPU: 1 PID: 71 Comm: kworker/1:2 Not tainted 5.19.0-rc7-syzkaller-00150-g32f02a211b0a #0
> > > Hardware name: Google Compute Engine/Google Compute Engine, BIOS Google 06/29/2022
> > > Workqueue: usb_hub_wq hub_event
> > > Call Trace:
> > >  <TASK>
> > >  ar5523_cmd+0x420/0x790 drivers/net/wireless/ath/ar5523/ar5523.c:275
> > >  ar5523_cmd_read drivers/net/wireless/ath/ar5523/ar5523.c:302 [inline]
> > >  ar5523_host_available drivers/net/wireless/ath/ar5523/ar5523.c:1376 [inline]
> > >  ar5523_probe+0xc66/0x1da0 drivers/net/wireless/ath/ar5523/ar5523.c:1655
> > > 
> > > 
> > > Link: https://syzkaller.appspot.com/bug?extid=1bc2c2afd44f820a669f
> > > Reported-and-tested-by: syzbot+1bc2c2afd44f820a669f@syzkaller.appspotmail.com
> > > Signed-off-by: Mazin Al Haddad <mazinalhaddad05@gmail.com>
> > > ---
> > >  drivers/net/wireless/ath/ar5523/ar5523.c | 31 ++++++++++++++++++++++++
> > >  1 file changed, 31 insertions(+)
> > > 
> > > diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
> > > index 6f937d2cc126..5451bf9ab9fb 100644
> > > --- a/drivers/net/wireless/ath/ar5523/ar5523.c
> > > +++ b/drivers/net/wireless/ath/ar5523/ar5523.c
> > > @@ -1581,8 +1581,39 @@ static int ar5523_probe(struct usb_interface *intf,
> > >  	struct usb_device *dev = interface_to_usbdev(intf);
> > >  	struct ieee80211_hw *hw;
> > >  	struct ar5523 *ar;
> > > +	struct usb_host_interface *host = intf->cur_altsetting;
> > >  	int error = -ENOMEM;
> > >  
> > > +	if (host->desc.bNumEndpoints != 4) {
> > > +		dev_err(&dev->dev, "Wrong number of endpoints\n");
> > > +		return -ENODEV;
> > > +	}
> > > +
> > > +	for (int i = 0; i < host->desc.bNumEndpoints; ++i) {
> > > +		struct usb_endpoint_descriptor *ep = &host->endpoint[i].desc;
> > > +		// Check for type of endpoint and direction.
> > > +		switch (i) {
> > > +		case 0:
> > > +		case 1:
> > > +			if ((ep->bEndpointAddress & USB_DIR_OUT) &&
> > > +			    ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> > > +			     == USB_ENDPOINT_XFER_BULK)){
> >
> > Did you run your change through checkpatch?
> 
> Yes.
> 
> > We have usb helper functions for all of this, why not use them instead
> > of attempting to roll your own?
> 
> Using the helpers is indeed a lot better. I wasn't aware of all of them.
> Since find_common_endpoints() won't work here, I used the helpers for 
> checking direction/type. 

I don't understand why usb_find_common_endpoints() will not work here.
It seems to be very generic and should work just fine.

thanks,

greg k-h
