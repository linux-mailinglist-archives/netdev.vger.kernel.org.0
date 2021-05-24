Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DED38E1E5
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 09:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbhEXHqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 03:46:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232254AbhEXHqB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 03:46:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17C1D610A5;
        Mon, 24 May 2021 07:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621842274;
        bh=z1C+QyseZ45GbVWwYhu5yBGWudxghE44niAVgptWqf4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EEptFrgYnoVewuNRXXBInrpG2Hc9P5zKBh/cdyYLgkVvJR06iivgB9otwT4wdXJ4h
         3wytJWF7qQ9m/llsbpZrM18cufHG5c2Uh8NdzhxLeBbMZheDqnCmH4paXgNPQVD+K6
         YcIwsq29No2qXT+5Bn6CJ+SSkFjZ6Wn9WwHt1jKWKmfN5Bu5GgUl/NizneqYe3QIw3
         fo5krE+3IcmyhQu8XX5cjpKxgAaK9kaJm9DbdSezfsOkpaGnoItrJBeCX2hQ0eDudI
         fGWJK6GycievUMv7eW2ieyAweY6JloW0Myje8hAVVDOOwQv5usivK+lU3MACMFBxrT
         /v6SzM7+xn68w==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1ll5GI-0003yK-2U; Mon, 24 May 2021 09:44:31 +0200
Date:   Mon, 24 May 2021 09:44:30 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "syzbot+95afd23673f5dd295c57@syzkaller.appspotmail.com" 
        <syzbot+95afd23673f5dd295c57@syzkaller.appspotmail.com>
Subject: Re: [PATCH net v2] r8152: check the informaton of the device
Message-ID: <YKtZXsmkNaMJgNYe@hovoldconsulting.com>
References: <1394712342-15778-363-Taiwan-albertk@realtek.com>
 <1394712342-15778-364-Taiwan-albertk@realtek.com>
 <YKizqoNIVFo+weI9@kroah.com>
 <YKi7qEWobOLRyoU8@hovoldconsulting.com>
 <d27f9a1848a546b99e2ab84cb15be06f@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d27f9a1848a546b99e2ab84cb15be06f@realtek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 01:49:33AM +0000, Hayes Wang wrote:
> Johan Hovold <johan@kernel.org>
> > Sent: Saturday, May 22, 2021 4:07 PM
> [...]
> > > > +	if (usb_endpoint_num(in) != 1) {
> > > > +		dev_err(&intf->dev, "Invalid Rx Endpoint\n");
> > >
> > > "Invalid number of Rx endpoints"
> > 
> > Here it is the endpoint number (address) that is being checked so
> > "number of" would be wrong.
> > 
> > That said, perhaps none of these checks are even needed a bit depending
> > on how the driver is implemented. That is, if it hardcodes the endpoint
> > addresses or uses the result from usb_find_common_endpoints() above
> > (which I realise now that it does not so these checks are probably still
> > needed).
> 
> The purpose of the checks is to find out the fake devices. That is, even
> the device supports in, out, and interrupt endpoints, it is treated as
> fake or malicious device, if the addresses of these endpoints are wrong.
> Therefore, I would keep the checks.

Strictly, you need to check for bad input which could cause your driver
to crash or malfunction. Generally you don't need to verify endpoint
addresses unless the driver is hardcoding those. But since that is
precisely what this particular driver is doing, these checks indeed need
to stay.

Johan
