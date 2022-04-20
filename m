Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82881508577
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 12:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiDTKJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 06:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347063AbiDTKJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 06:09:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 591D918B32;
        Wed, 20 Apr 2022 03:06:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6C24B81E61;
        Wed, 20 Apr 2022 10:06:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93993C385A1;
        Wed, 20 Apr 2022 10:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650449211;
        bh=TkzaIXVfmy/5OEl78ORgSpwgfioQr5mxDuXVgiEkTDg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HKl8FAkCXv6aTwWXIuGURVGJg2g7lNcLWuxBXb9ke5XDyru1he5+zJi0bs+PfbTEY
         E+Tn7JK9xydyiNgTLnlqNP5yBlQVTL1xpDkorka6QINWM0OcmBBbtOshNhwW2UrgIf
         YnwOj5X1jWdCZni/4Fv+8CL4FqJzZixpnYxrccjB+Q5JLL4NQ+kwmw7Qew6hQFaojG
         vCBswZnSYh+xbwWyUU5vUClqWgAGLGrQnWQIC2ukIOgdIz3bHJGJH1g6boUiXaEqXw
         t0rnY0QvKNhhZegP4jDaa0SZbwhMkV46U1k2UHYPpDNhyFRqz99NxxOatUnSUexRbQ
         RG51Zx2mrYuJQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1nh7ER-0007Xi-N9; Wed, 20 Apr 2022 12:06:43 +0200
Date:   Wed, 20 Apr 2022 12:06:43 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Dongliang Mu <dzm91@hust.edu.cn>,
        Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+eabbf2aaa999cc507108@syzkaller.appspotmail.com,
        USB <linux-usb@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver: usb: nullify dangling pointer in cdc_ncm_free
Message-ID: <Yl/bMxXKeNdLI87G@hovoldconsulting.com>
References: <20220409120901.267526-1-dzm91@hust.edu.cn>
 <YlQbqnYP/jcYinvz@hovoldconsulting.com>
 <CAHp75VeTqmdLhavZ+VbBYSFMDHr0FG4iKFGdbzE-wo5MCNikAA@mail.gmail.com>
 <d851497f-7960-b606-2f87-eb9bff89c8ac@suse.com>
 <Yl+utFmKEgILDFr5@hovoldconsulting.com>
 <aef0c568-e088-b897-f8ec-f22cfef124f6@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aef0c568-e088-b897-f8ec-f22cfef124f6@suse.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 11:45:49AM +0200, Oliver Neukum wrote:

> >> -	if (dev->driver_info->unbind)
> >> -		dev->driver_info->unbind(dev, intf);
> >> +	if (dev->driver_info->disable)
> >> +		dev->driver_info->disable(dev, intf);
> >>  
> >>  	net = dev->net;
> >>  	unregister_netdev (net);
> >> @@ -1651,6 +1651,9 @@ void usbnet_disconnect (struct usb_interface *intf)
> >>  
> >>  	usb_scuttle_anchored_urbs(&dev->deferred);
> >>  
> >> +	if (dev->driver_info->unbind)
> >> +		dev->driver_info->unbind (dev, intf);
> >> +
> >>  	usb_kill_urb(dev->interrupt);

> > Don't you need to quiesce all I/O, including stopping the interrupt URB,
> > before unbind?

> If I do that, how do I prevent people from relaunching the URB between
> kill and unbind? Do I need to poison it?

You could, but it would seem you have bigger problems if something can
submit the URB after having deregistered the netdev.

Looks like the URB should already have been stopped by
usbnet_status_stop() so that the usb_kill_urb() above is (or should be)
a noop.

Johan
