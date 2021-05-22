Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7703638D45E
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 10:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhEVIIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 04:08:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230000AbhEVII3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 May 2021 04:08:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C858D61163;
        Sat, 22 May 2021 08:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621670824;
        bh=e9h3YH6hGEUUkxs9Amz7GAdN45jwweq7ph0QM0vrHII=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vu2u7oxUNchdMCeACgQW37z9BPHA3nkeY+krpkH7p590u+MuNlbEI77wRCGrvsPnB
         FrC06yq7YNqQ0IXzZYUrgrs9Yp+7GzjGBEVH0SlwaJ6Zkgar3WG+NMtgZbOOHrlKlj
         gLIbNTaw8Xr2FwxRBZRwqDMgPNTdhVsJRStUaVUjy/x4RYEqPAbR1l/HFv/6BaryiX
         VJEPm/LMKg3bQA+YMpky1/6xynYb7cQQiEFpxdNF7gHRCULbWNYqQuflNpcN6sTyfc
         lHEKA3eM7zYQRIlvSQ5wQWFfwIngBctT4+AzASjRsDWh7+5g7gyjknq5gKvqXY/EuT
         hwmjIgpzKHrwA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1lkMf2-0007wn-PB; Sat, 22 May 2021 10:07:05 +0200
Date:   Sat, 22 May 2021 10:07:04 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Hayes Wang <hayeswang@realtek.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        syzbot+95afd23673f5dd295c57@syzkaller.appspotmail.com
Subject: Re: [PATCH net v2] r8152: check the informaton of the device
Message-ID: <YKi7qEWobOLRyoU8@hovoldconsulting.com>
References: <1394712342-15778-363-Taiwan-albertk@realtek.com>
 <1394712342-15778-364-Taiwan-albertk@realtek.com>
 <YKizqoNIVFo+weI9@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKizqoNIVFo+weI9@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 22, 2021 at 09:32:58AM +0200, Greg Kroah-Hartman wrote:
> On Sat, May 22, 2021 at 01:24:54PM +0800, Hayes Wang wrote:
> > Verify some fields of the USB descriptor to make sure the driver
> > could be used by the device.
> > 
> > Besides, remove the check of endpoint number in rtl8152_probe().
> > It has been done in rtl_check_vendor_ok().
> > 
> > BugLink: https://syzkaller.appspot.com/bug?id=912c9c373656996801b4de61f1e3cb326fe940aa
> > Reported-by: syzbot+95afd23673f5dd295c57@syzkaller.appspotmail.com
> > Fixes: c2198943e33b ("r8152: search the configuration of vendor mode")
> > Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> > ---
> > v2:
> > Use usb_find_common_endpoints() and usb_endpoint_num() to replace original
> > code.
> 
> Much better, just some tiny grammer changes below:
> 
> > 
> > remove the check of endpoint number in rtl8152_probe(). It has been done
> > in rtl_check_vendor_ok().
> > 
> >  drivers/net/usb/r8152.c | 44 ++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 39 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> > index 136ea06540ff..6e5230d6c721 100644
> > --- a/drivers/net/usb/r8152.c
> > +++ b/drivers/net/usb/r8152.c
> > @@ -8107,6 +8107,39 @@ static void r8156b_init(struct r8152 *tp)
> >  	tp->coalesce = 15000;	/* 15 us */
> >  }
> >  
> > +static bool rtl_check_vendor_ok(struct usb_interface *intf)
> > +{
> > +	struct usb_host_interface *alt = intf->cur_altsetting;
> > +	struct usb_endpoint_descriptor *in, *out, *intr;
> > +
> > +	if (alt->desc.bNumEndpoints < 3) {
> > +		dev_err(&intf->dev, "Unexpected bNumEndpoints %d\n", alt->desc.bNumEndpoints);
> > +		return false;
> > +	}

This check is now redundant and can be removed.

> > +
> > +	if (usb_find_common_endpoints(alt, &in, &out, &intr, NULL) < 0) {
> > +		dev_err(&intf->dev, "Miss Endpoints\n");
> 
> "Miss" feels ackward, how about "Invalid number of endpoints"?

The helper also checks the type and direction so perhaps something like
"expected endpoints not found" (or just "missing endpoints") which is
more precise.

> > +		return false;
> > +	}
> > +
> > +	if (usb_endpoint_num(in) != 1) {
> > +		dev_err(&intf->dev, "Invalid Rx Endpoint\n");
> 
> "Invalid number of Rx endpoints"

Here it is the endpoint number (address) that is being checked so
"number of" would be wrong.

That said, perhaps none of these checks are even needed a bit depending
on how the driver is implemented. That is, if it hardcodes the endpoint
addresses or uses the result from usb_find_common_endpoints() above
(which I realise now that it does not so these checks are probably still
needed).

> > +		return false;
> > +	}

Johan
