Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBA463ACFA
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 16:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbiK1Pum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 10:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbiK1Puk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 10:50:40 -0500
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 4A67321A8
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 07:50:39 -0800 (PST)
Received: (qmail 327280 invoked by uid 1000); 28 Nov 2022 10:50:38 -0500
Date:   Mon, 28 Nov 2022 10:50:38 -0500
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Andrew Lunn <andrew@lunn.ch>, linux-can@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>
Subject: Re: [PATCH v4 2/6] can: etas_es58x: add devlink support
Message-ID: <Y4TYzgOczlegG7OK@rowland.harvard.edu>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-3-mailhol.vincent@wanadoo.fr>
 <Y4JEGYMtIWX9clxo@lunn.ch>
 <CAMZ6RqK6AQVsRufw5Jr5aKpPQcy+05jq3TjrKqbaqk7NVgK+_Q@mail.gmail.com>
 <Y4OD70GD4KnoRk0k@rowland.harvard.edu>
 <CAMZ6Rq+Gi+rcLqSj2-kug7c1G_nNuj6peh5nH1DNoo8B3aSxzw@mail.gmail.com>
 <CAMZ6RqKS0sUFZWQfmRU6q2ivWEUFD06uiQekDr=u94L3uij3yQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZ6RqKS0sUFZWQfmRU6q2ivWEUFD06uiQekDr=u94L3uij3yQ@mail.gmail.com>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 02:32:23PM +0900, Vincent MAILHOL wrote:
> On Mon. 28 Nov. 2022 at 10:34, Vincent MAILHOL
> <mailhol.vincent@wanadoo.fr> wrote:
> > On Mon. 28 Nov. 2022 at 00:41, Alan Stern <stern@rowland.harvard.edu> wrote:
> > > On Sun, Nov 27, 2022 at 02:10:32PM +0900, Vincent MAILHOL wrote:
> > > > > Should devlink_free() be after usb_set_inftdata()?
> > > >
> > > > A look at
> > > >   $ git grep -W "usb_set_intfdata(.*NULL)"
> > > >
> > > > shows that the two patterns (freeing before or after
> > > > usb_set_intfdata()) coexist.
> > > >
> > > > You are raising an important question here. usb_set_intfdata() does
> > > > not have documentation that freeing before it is risky. And the
> > > > documentation of usb_driver::disconnect says that:
> > > >   "@disconnect: Called when the interface is no longer accessible,
> > > >    usually because its device has been (or is being) disconnected
> > > >    or the driver module is being unloaded."
> > > >   Ref: https://elixir.bootlin.com/linux/v6.1-rc6/source/include/linux/usb.h#L1130
> > > >
> > > > So the interface no longer being accessible makes me assume that the
> > > > order does not matter. If it indeed matters, then this is a foot gun
> > > > and there is some clean-up work waiting for us on many drivers.
> > > >
> > > > @Greg, any thoughts on whether or not the order of usb_set_intfdata()
> > > > and resource freeing matters or not?
> > >
> > > In fact, drivers don't have to call usb_set_intfdata(NULL) at all; the
> > > USB core does it for them after the ->disconnect() callback returns.
> >
> > Interesting. This fact is widely unknown, cf:
> >   $ git grep "usb_set_intfdata(.*NULL)" | wc -l
> >   215
> >
> > I will do some clean-up later on, at least for the CAN USB drivers.
> >
> > > But if a driver does make the call, it should be careful to ensure that
> > > the call happens _after_ the driver is finished using the interface-data
> > > pointer.  For example, after all outstanding URBs have completed, if the
> > > completion handlers will need to call usb_get_intfdata().
> >
> > ACK. I understand that it should be called *after* the completion of
> > any ongoing task.
> >
> > My question was more on:
> >
> >         devlink_free(priv_to_devlink(es58x_dev));
> >         usb_set_intfdata(intf, NULL);
> >
> > VS.
> >
> >         usb_set_intfdata(intf, NULL);
> >         devlink_free(priv_to_devlink(es58x_dev));
> >
> > From your comments, I understand that both are fine.
> 
> Do we agree that the usb-skeleton is doing it wrong?
>   https://elixir.bootlin.com/linux/latest/source/drivers/usb/usb-skeleton.c#L567
> usb_set_intfdata(interface, NULL) is called before deregistering the
> interface and terminating the outstanding URBs!

Going through the usb-skeleton.c source code, you will find that 
usb_get_intfdata() is called from only a few routines:

	skel_open()
	skel_disconnect()
	skel_suspend()
	skel_pre_reset()
	skel_post_reset()

Of those, all but the first are called only by the USB core and they are 
mutually exclusive with disconnect processing (except for 
skel_disconnect() itself, of course).  So they don't matter.

The first, skel_open(), can be called as a result of actions by the 
user, so the driver needs to ensure that this can't happen after it 
clears the interface-data pointer.  The user can open the device file at 
any time before the minor number is given back, so it is not proper to 
call usb_set_intfdata(interface, NULL) before usb_deregister_dev() -- 
but the driver does exactly this!

(Well, it's not quite that bad.  skel_open() does check whether the 
interface-data pointer value it gets from usb_get_intfdata() is NULL.  
But it's still a race.)

So yes, the current code is wrong.  And in fact, it will still be wrong 
even after the usb_set_intfdata(interface, NULL) line is removed, 
because there is no synchronization between skel_open() and 
skel_disconnect().  It is possible for skel_disconnect() to run to 
completion and the USB core to clear the interface-data pointer all 
while skel_open() is running.  The driver needs a static private mutex 
to synchronize opens with unregistrations.  (This is a general 
phenomenon, true of all drivers that have a user interface such as a 
device file.)

The driver _does_ have a per-instance mutex, dev->io_mutex, to 
synchronize I/O with disconnects.  But that's separate from 
synchronizing opens with unregistrations, because at open time the 
driver doesn't yet know the address of the private data structure or 
even if the structure is still allocated.  So obviously it can't use a 
mutex that is embedded within the private data structure for this 
purpose.

Alan Stern
