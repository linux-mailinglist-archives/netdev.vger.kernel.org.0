Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A3C3EDE7F
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 22:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbhHPUTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 16:19:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232253AbhHPUSt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 16:18:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 575CB60F22;
        Mon, 16 Aug 2021 20:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629145096;
        bh=q+FNT4fcY/WJmYmPs9nviguHJR8JJ98dFHcdG3N0460=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LqTTuk1/KX24/TiRJlbF34ik6GMQ+2Ewu+4ECkijgFJ/nZmEt6Qjf0j8saRRilC4E
         6zIsYCDI54q9UKbCF/WJ+Hb3ANFjHaKH2H9xZivw9k6UL+djBaaaMFInkoyAe0Z1af
         82CFb8GOfIe1l979SVSm087qHArHiN7OAM3kKIMzAY5EYtFln/cHKjrtyMR9Il/zfa
         syMErHWYmsPXbRxAA0/VSB1L2v7YLs4Ua6HtKZCaNg1RyYfrtz5poiPPYZ/mJEh2Q2
         wZdtkea7MCuXcJ3bTKtLGajDSMi7jsVWS5oaNs6nV1ySzp0+xbufKwZNNGsid6Ku7A
         PhzYiSaOUGs/A==
Date:   Mon, 16 Aug 2021 13:18:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petko Manolov <petko.manolov@konsulko.com>
Cc:     netdev@vger.kernel.org, paskripkin@gmail.com,
        stable@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] net: usb: pegasus: ignore the return value from
 set_registers();
Message-ID: <20210816131815.4e4e09de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YRq5JyLbkU8hN/fG@carbon>
References: <20210812082351.37966-1-petko.manolov@konsulko.com>
        <20210813162439.1779bf63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YRjWXzYrQsGZiISc@carbon>
        <20210816070640.2a7a6f5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YRq5JyLbkU8hN/fG@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Aug 2021 22:14:47 +0300 Petko Manolov wrote:
> On 21-08-16 07:06:40, Jakub Kicinski wrote:
> > On Sun, 15 Aug 2021 11:54:55 +0300 Petko Manolov wrote:  
> > > Mostly because for this particular adapter checking the read failure makes much
> > > more sense than write failure.  
> > 
> > This is not an either-or choice.
> >   
> > > Checking the return value of set_register(s) is often usless because device's
> > > default register values are sane enough to get a working ethernet adapter even
> > > without much prodding.  There are exceptions, though, one of them being
> > > set_ethernet_addr().
> > > 
> > > You could read the discussing in the netdev ML, but the essence of it is that
> > > set_ethernet_addr() should not give up if set_register(s) fail.  Instead, the
> > > driver should assign a valid, even if random, MAC address.
> > > 
> > > It is much the same situation with enable_net_traffic() - it should continue
> > > regardless.  There are two options to resolve this: a) remove the error check
> > > altogether; b) do the check and print a debug message.  I prefer a), but i am
> > > also not strongly opposed to b).  Comments?  
> > 
> > c) keep propagating the error like the driver used to.  
> 
> If you carefully read the code, which dates back to at least 2005, you'll see
> that on line 436 (v5.14-rc6) 'ret' is assigned with the return value of
> set_registers(), but 'ret' is never evaluated and thus not acted upon.

It's no longer evaluated because of your commit 8a160e2e9aeb ("net:
usb: pegasus: Check the return value of get_geristers() and friends;")
IOW v5.14-rc6 has your recent patch. Which I quoted earlier in this
thread. That commit was on Aug 3 2021. The error checking (now
accidentally removed) was introduced somewhere in 2.6.x days.

If you disagree with that please show me the code you're referring to,
because I just don't see it.

> > I don't understand why that's not the most obvious option.  
> 
> Which part of "this is not a fatal error" you did not understand?

That's not the point. The error checking was removed accidentally, 
it should be brought back in net to avoid introducing regressions.
If the error checking is not necessary you can remove it in net-next,
no problem.

Perhaps you did not intend commit 8a160e2e9aeb ("net: usb: pegasus:
Check the return value of get_geristers() and friends;") to be applied 
as a fix but it was, and it was backported to stable trees if I'm not
mistaken. 

> > The driver used to propagate the errors from the set_registers() call in
> > enable_net_traffic() since the beginning of the git era. This is _not_ one of
> > the error checking that you recently added.  
> 
> The driver hasn't propagated an error at this particular location in the last 16
> years.  So how exactly removing this assignment will make the driver worse than
> it is now?

This is the relevant code from v5.13:

static int set_registers(pegasus_t *pegasus, __u16 indx, __u16 size,
			 const void *data)
{
	return usb_control_msg_send(pegasus->usb, 0, PEGASUS_REQ_SET_REGS,
				    PEGASUS_REQT_WRITE, 0, indx, data, size,
				    1000, GFP_NOIO);
}

static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
{
	/* [...] */
===>	ret = set_registers(pegasus, EthCtrl0, 3, data);

	if (usb_dev_id[pegasus->dev_index].vendor == VENDOR_LINKSYS ||
	    usb_dev_id[pegasus->dev_index].vendor == VENDOR_LINKSYS2 ||
	    usb_dev_id[pegasus->dev_index].vendor == VENDOR_DLINK) {
		u16 auxmode;
		read_mii_word(pegasus, 0, 0x1b, &auxmode);
		auxmode |= 4;
		write_mii_word(pegasus, 0, 0x1b, &auxmode);
	}

===>	return ret;
}


static int pegasus_open(struct net_device *net)
{
	/* [...] */
===>	res = enable_net_traffic(net, pegasus->usb);
===>	if (res < 0) {
		netif_dbg(pegasus, ifup, net,
			  "can't enable_net_traffic() - %d\n", res);
===>		res = -EIO;
		usb_kill_urb(pegasus->rx_urb);
		usb_kill_urb(pegasus->intr_urb);
===>		goto exit;
	}
	set_carrier(net);
	netif_start_queue(net);
	netif_dbg(pegasus, ifup, net, "open\n");
	res = 0;
exit:
===>	return res;
}

https://elixir.bootlin.com/linux/v5.13/source/drivers/net/usb/pegasus.c
