Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7901655381E
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 18:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351919AbiFUQnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 12:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352519AbiFUQnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 12:43:23 -0400
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C90125593;
        Tue, 21 Jun 2022 09:43:20 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id C802A100D585F;
        Tue, 21 Jun 2022 18:43:16 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id A01AE67228C; Tue, 21 Jun 2022 18:43:16 +0200 (CEST)
Date:   Tue, 21 Jun 2022 18:43:16 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Jann Horn <jannh@google.com>
Subject: Re: [PATCH net] sierra_net: Fix use-after-free on unbind
Message-ID: <20220621164316.GA8969@wunner.de>
References: <80e88f61ca68c36ebce5d17dfcaa8e956e19fb2f.1655196227.git.lukas@wunner.de>
 <60a08f2c-6475-4bb2-1cc8-1935a5ddeb79@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60a08f2c-6475-4bb2-1cc8-1935a5ddeb79@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[adding Jann as UAF connoisseur to cc]

On Tue, Jun 14, 2022 at 12:48:23PM +0200, Oliver Neukum wrote:
> On 14.06.22 10:50, Lukas Wunner wrote:
> > @@ -758,6 +758,8 @@ static void sierra_net_unbind(struct usbnet *dev, struct usb_interface *intf)
> >  
> >  	dev_dbg(&dev->udev->dev, "%s", __func__);
> >  
> > +	usbnet_status_stop(dev);
> > +
> >  	/* kill the timer and work */
> >  	del_timer_sync(&priv->sync_timer);
> >  	cancel_work_sync(&priv->sierra_net_kevent);
> 
> as far as I can see the following race condition exists:
> 
> CPU A:
> intr_complete() -> static void sierra_net_status() -> defer_kevent()
> 
> CPU B:
> usbnet_stop_status()  ---- kills the URB but only the URB, kevent scheduled
> 
> CPU A:
> sierra_net_kevent -> sierra_net_dosync() ->
> 
> CPU B:
> -> del_timer_sync(&priv->sync_timer);  ---- NOP, too early
> 
> CPU A:
> add_timer(&priv->sync_timer);
> 
> CPU B:
> cancel_work_sync(&priv->sierra_net_kevent);  ---- NOP, too late

I see your point, but what's the solution?

I could call netif_device_detach() on ->disconnect(), then avoid
scheduling sierra_net_kevent in the timer if !netif_device_present(),
and also avoid arming the timer in sierra_net_kevent under the same
condition.

Still, I think I'd need 3 calls to make this bulletproof, either

	del_timer_sync(&priv->sync_timer);
	cancel_work_sync(&priv->sierra_net_kevent);
	del_timer_sync(&priv->sync_timer);

or

	cancel_work_sync(&priv->sierra_net_kevent);
	del_timer_sync(&priv->sync_timer);
	cancel_work_sync(&priv->sierra_net_kevent);

Doesn't really matter which of these two.  Am I right?
Is there a better (simpler) approach?

FWIW, the logic in usbnet.c looks similarly flawed:
There's a timer, a tasklet and a work.
(Sounds like one of those "... walk into a bar" jokes.)

The timer is armed by the tx/rx URB completion callbacks.
Those URBs are terminated in usbnet_stop() and the timer is
deleted.  So far so good.  But:

The tasklet schedules the work.
The work schedules the tasklet.
The tasklet also schedules itself.

We kill the tasklet in usbnet_stop() and afterwards cancel the
work in usbnet_disconnect().  What happens if the work schedules
the tasklet again?  Another UAF.  That may happen in the EVENT_RX_HALT,
EVENT_RX_MEMORY, EVENT_LINK_RESET and EVENT_LINK_CHANGE code paths.
A few netif_device_present() safeguards may help to prevent
rescheduling the killed tasklet, but I suspect we may again need
3 calls here (tasklet_kill() / cancel_work_sync() / tasklet_kill())
to make it bulletproof.  What do you think?

As a heads-up, I'm going to move the cancel_work_sync() to usbnet_stop()
in an upcoming patch.  That seems to be Jakub's preferred approach to
tackle the linkwatch UAF.  I fear it may increase the risk of encountering
the issues outlined above as the time between tasklet_kill() and
cancel_work_sync() is reduced:

https://github.com/l1k/linux/commit/89988b499ab9

Thanks,

Lukas
