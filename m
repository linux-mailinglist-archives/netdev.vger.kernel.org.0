Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35D343DBDE
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 09:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhJ1HXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 03:23:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229656AbhJ1HXf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 03:23:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 686F560E54;
        Thu, 28 Oct 2021 07:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635405668;
        bh=e/wyzVfkTV0dR6YteYW1jvF1J3q6I2+0CEvxKq0nxCE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JBkj/hcGqPxgoS4c4hfbNCE/wp/WzptPZxH+uLq1JsS0EkK8xuq2B+BFYT/M9kMdW
         B4lilA5IPudFk9zJtUWeypRWHZ7ScqjZP4NOuaM9yorU8jk9wi/hIqpxA9d23HhHwP
         C7RH/AcL97uMfN+5WAwkKf2+85pUtwc5Bcp05lYaO1hCYYYwnk0Q3u9p4ytVX0Kvef
         mz7WaNfGSLj5r54b82U5boDP+OLa6+8TS2VerEyuxRIwCX5V07bCEvtvTPMSuBTaTY
         D+D/jKbWRdviY1Qme+7BkNA36znep6njYk5ZeGs1LkQOkpyxmcXDRx0lAn4ZF71B34
         0ujB0wUI0dsSA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mfziT-00023a-77; Thu, 28 Oct 2021 09:20:49 +0200
Date:   Thu, 28 Oct 2021 09:20:49 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Amitkumar Karwar <akarwar@marvell.com>
Subject: Re: [PATCH v2 3/3] mwifiex: fix division by zero in fw download path
Message-ID: <YXpPUdj0wJG2L5ra@hovoldconsulting.com>
References: <20211027080819.6675-1-johan@kernel.org>
 <20211027080819.6675-4-johan@kernel.org>
 <CA+ASDXMYbP3jQPeOpDDktHgp4X81AH41cgiLFgz-YHVPyZO1sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+ASDXMYbP3jQPeOpDDktHgp4X81AH41cgiLFgz-YHVPyZO1sw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 11:22:39AM -0700, Brian Norris wrote:
> On Wed, Oct 27, 2021 at 1:12 AM Johan Hovold <johan@kernel.org> wrote:
> > --- a/drivers/net/wireless/marvell/mwifiex/usb.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/usb.c
> > @@ -505,6 +505,22 @@ static int mwifiex_usb_probe(struct usb_interface *intf,
> >                 }
> >         }
> >
> > +       switch (card->usb_boot_state) {
> > +       case USB8XXX_FW_DNLD:
> > +               /* Reject broken descriptors. */
> > +               if (!card->rx_cmd_ep || !card->tx_cmd_ep)
> > +                       return -ENODEV;
> 
> ^^ These two conditions are applicable to USB8XXX_FW_READY too, right?

Right, but I didn't want to add an incomplete set of constraints.

I couldn't find any documentation (e.g. lsusb -v) for what the
descriptors are supposed to look like, but judging from the code,
something like

	if (!card->rx_cmd_ep || !card->tx_cmd_ep)
		return -ENODEV;
	if (!card->rx_data_ep || !card->port[0].tx_data_ep)
		return -ENODEV;

should do. But I'm not sure about the second tx endpoint,
card->port[1].tx_data_ep, for which support was added later and which
the driver appears to be able to manage without.

Either way it has nothing to do with the division-by-zero and should be
added separately.

> > +               if (card->bulk_out_maxpktsize == 0)
> > +                       return -ENODEV;
> > +               break;
> > +       case USB8XXX_FW_READY:
> > +               /* Assume the driver can handle missing endpoints for now. */
> > +               break;
> > +       default:
> > +               WARN_ON(1);
> > +               return -ENODEV;
> > +       }

Johan
