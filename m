Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C69864FE42
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 11:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbiLRKCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 05:02:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiLRKCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 05:02:53 -0500
X-Greylist: delayed 60 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 18 Dec 2022 02:02:52 PST
Received: from h1.cmg2.smtp.forpsi.com (h1.cmg2.smtp.forpsi.com [81.2.195.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B60B55B0
        for <netdev@vger.kernel.org>; Sun, 18 Dec 2022 02:02:52 -0800 (PST)
Received: from lenoch ([91.218.190.200])
        by cmgsmtp with ESMTPSA
        id 6qUNpydpiv5uI6qUPpQpbr; Sun, 18 Dec 2022 11:01:50 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triops.cz; s=f2019;
        t=1671357710; bh=Owt8AtGuq4gpGcASBGzAU05B9mtOMW9CXzfxZwQ3ZmI=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=WXYMZBq0fKIL96pjjhqc8NXZxL4/lsd3wmk1unHapJGxE1er+YMwP3521hWYoiofa
         sGVXFo8FwmYw2Vqk0QhqGU0lh+St7X5H2dKrmyAVMXOyNj6jdpwWS2p/GCAOyHiSy7
         lCI1Mu8nHeJulSvJ1aEcN4e5jh9a9T2KihpkQdYVlCzyAMdOfVaZvK6sY+wNUtsd1F
         BWwQb66GF2yUDTdsyS/EjXi9uhLxln+KXZqyyTm/nQOSvw9yeYG7eBTm32DsjtpW68
         JBlOFV6769243NHjs4oNLWd45WKtECRBesOPn7nc8H6A3cGO1b/Yxvgw6b90nFbWl1
         +0kdv62eoqQeQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triops.cz; s=f2019;
        t=1671357710; bh=Owt8AtGuq4gpGcASBGzAU05B9mtOMW9CXzfxZwQ3ZmI=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=WXYMZBq0fKIL96pjjhqc8NXZxL4/lsd3wmk1unHapJGxE1er+YMwP3521hWYoiofa
         sGVXFo8FwmYw2Vqk0QhqGU0lh+St7X5H2dKrmyAVMXOyNj6jdpwWS2p/GCAOyHiSy7
         lCI1Mu8nHeJulSvJ1aEcN4e5jh9a9T2KihpkQdYVlCzyAMdOfVaZvK6sY+wNUtsd1F
         BWwQb66GF2yUDTdsyS/EjXi9uhLxln+KXZqyyTm/nQOSvw9yeYG7eBTm32DsjtpW68
         JBlOFV6769243NHjs4oNLWd45WKtECRBesOPn7nc8H6A3cGO1b/Yxvgw6b90nFbWl1
         +0kdv62eoqQeQ==
Date:   Sun, 18 Dec 2022 11:01:45 +0100
From:   Ladislav Michl <oss-lists@triops.cz>
To:     Greg KH <greg@kroah.com>
Cc:     Leesoo Ahn <lsahn@ooseel.net>, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usbnet: jump to rx_cleanup case instead of calling
 skb_queue_tail
Message-ID: <Y57lCffa61raoiDO@lenoch>
References: <20221217161851.829497-1-lsahn@ooseel.net>
 <Y57VkLKetDsbUUjC@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y57VkLKetDsbUUjC@kroah.com>
X-CMAE-Envelope: MS4wfA1wtMOBCLHBUmJ8JMmP1mv5RZmEbWCjc8er8LlsDy2p0qnO0Fz6jPLSW3pVe98REsVX2ZAOaLWdFFYlwD9rmJjxar6cJ5OF43SrlCPLyUFOR8+3jJfy
 /2ahNH46dDGTP2Iza0T1prqs/PUXGDasGEgUT5AoGSqKrlibHluoHEfO6p1j1+pZyIdvWP6DsPTbGutkkP9H12qGNAmaejdh5Fy+vAH+RgSh67G6w7G7AKOb
 GQilL8215b3I/kjLiySqJxqfcjucDFewDipkSVr7DW9U70zmWbUUIF2Xeqvfh8u/Xp+ujfbAdVHJbhBy71ObOvKlFnQibkKqY77gIGAMMnjU3n1avQoWYZev
 lL8kPJSVEpjaw8B2kKbX2iwubVsvxlRSCQklD0zFG/vX2/qn+KFd2tFAmP1DaLhuOy0Fmzl7XoyhWWy6OSceobOyf0xEZw==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 18, 2022 at 09:55:44AM +0100, Greg KH wrote:
> On Sun, Dec 18, 2022 at 01:18:51AM +0900, Leesoo Ahn wrote:
> > The current source pushes skb into dev->done queue by calling
> > skb_queue_tail() and then, call skb_dequeue() to pop for rx_cleanup state
> > to free urb and skb next in usbnet_bh().
> > It wastes CPU resource with extra instructions. Instead, use return values
> > jumping to rx_cleanup case directly to free them. Therefore calling
> > skb_queue_tail() and skb_dequeue() is not necessary.
> > 
> > The follows are just showing difference between calling skb_queue_tail()
> > and using return values jumping to rx_cleanup state directly in usbnet_bh()
> > in Arm64 instructions with perf tool.
> > 
> > ----------- calling skb_queue_tail() -----------
> >        │     if (!(dev->driver_info->flags & FLAG_RX_ASSEMBLE))
> >   7.58 │248:   ldr     x0, [x20, #16]
> >   2.46 │24c:   ldr     w0, [x0, #8]
> >   1.64 │250: ↑ tbnz    w0, #14, 16c
> >        │     dev->net->stats.rx_errors++;
> >   0.57 │254:   ldr     x1, [x20, #184]
> >   1.64 │258:   ldr     x0, [x1, #336]
> >   2.65 │25c:   add     x0, x0, #0x1
> >        │260:   str     x0, [x1, #336]
> >        │     skb_queue_tail(&dev->done, skb);
> >   0.38 │264:   mov     x1, x19
> >        │268:   mov     x0, x21
> >   2.27 │26c: → bl      skb_queue_tail
> >   0.57 │270: ↑ b       44    // branch to call skb_dequeue()
> > 
> > ----------- jumping to rx_cleanup state -----------
> >        │     if (!(dev->driver_info->flags & FLAG_RX_ASSEMBLE))
> >   1.69 │25c:   ldr     x0, [x21, #16]
> >   4.78 │260:   ldr     w0, [x0, #8]
> >   3.28 │264: ↑ tbnz    w0, #14, e4    // jump to 'rx_cleanup' state
> >        │     dev->net->stats.rx_errors++;
> >   0.09 │268:   ldr     x1, [x21, #184]
> >   2.72 │26c:   ldr     x0, [x1, #336]
> >   3.37 │270:   add     x0, x0, #0x1
> >   0.09 │274:   str     x0, [x1, #336]
> >   0.66 │278: ↑ b       e4    // branch to 'rx_cleanup' state
> 
> Interesting, but does this even really matter given the slow speed of
> the USB hardware?

On the other side, it is pretty nice optimization and a proof someone
read the code really carefully.

> > Signed-off-by: Leesoo Ahn <lsahn@ooseel.net>
> > ---
> >  drivers/net/usb/usbnet.c | 11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> > index 64a9a80b2309..924392a37297 100644
> > --- a/drivers/net/usb/usbnet.c
> > +++ b/drivers/net/usb/usbnet.c
> > @@ -555,7 +555,7 @@ static int rx_submit (struct usbnet *dev, struct urb *urb, gfp_t flags)
> >  
> >  /*-------------------------------------------------------------------------*/
> >  
> > -static inline void rx_process (struct usbnet *dev, struct sk_buff *skb)
> > +static inline int rx_process(struct usbnet *dev, struct sk_buff *skb)
> >  {
> >  	if (dev->driver_info->rx_fixup &&
> >  	    !dev->driver_info->rx_fixup (dev, skb)) {
> > @@ -576,11 +576,11 @@ static inline void rx_process (struct usbnet *dev, struct sk_buff *skb)
> >  		netif_dbg(dev, rx_err, dev->net, "rx length %d\n", skb->len);
> >  	} else {
> >  		usbnet_skb_return(dev, skb);
> > -		return;
> > +		return 0;
> >  	}
> >  
> >  done:
> > -	skb_queue_tail(&dev->done, skb);
> > +	return -1;
> 
> Don't make up error numbers, this makes it look like this failed, not
> succeeded.  And if this failed, give it a real error value.

Note that jumps to 'done' label can be avoided now, so eventual v2 version
of that patch doesn't increase total goto entropy.

	l.

> thanks,
> 
> greg k-h
