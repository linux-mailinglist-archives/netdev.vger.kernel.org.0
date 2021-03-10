Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8526633400C
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 15:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhCJONY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 09:13:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:35204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232739AbhCJONA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 09:13:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8ABFB64F9D;
        Wed, 10 Mar 2021 14:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615385580;
        bh=wLxkkLgny2zLL1a6/+eRP3XB9VLuPKSyg0tW+rWT1p4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ybwACsyGgNPsDTX0Z+KvTCeZjVAIy6AfbOjM4rtgfdOPF6EQtSX6Ik4w5S7A7obMX
         8sGTwOW5I8polHkP5yBMWTxNQtCX53nTwwgxtdEu69jWPkztYo36JsHAuvljhGmvCI
         S2/OTXRp4A+C2dv8eSE4p3seIwrPegKRKGfFxJjM=
Date:   Wed, 10 Mar 2021 15:12:57 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, olteanv@gmail.com, jiri@resnulli.us,
        ruxandra.radulescu@nxp.com, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next 00/15] dpaa2-switch: CPU terminated traffic and
 move out of staging
Message-ID: <YEjT6WL9jp3HCf+w@kroah.com>
References: <20210310121452.552070-1-ciorneiioana@gmail.com>
 <YEi/PlZLus2Ul63I@kroah.com>
 <20210310134744.cjong4pnrfxld4hf@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310134744.cjong4pnrfxld4hf@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 03:47:44PM +0200, Ioana Ciornei wrote:
> On Wed, Mar 10, 2021 at 01:44:46PM +0100, Greg KH wrote:
> > On Wed, Mar 10, 2021 at 02:14:37PM +0200, Ioana Ciornei wrote:
> > > From: Ioana Ciornei <ioana.ciornei@nxp.com>
> > > 
> > > This patch set adds support for Rx/Tx capabilities on DPAA2 switch port
> > > interfaces as well as fixing up some major blunders in how we take care
> > > of the switching domains. The last patch actually moves the driver out
> > > of staging now that the minimum requirements are met.
> > > 
> > > I am sending this directly towards the net-next tree so that I can use
> > > the rest of the development cycle adding new features on top of the
> > > current driver without worrying about merge conflicts between the
> > > staging and net-next tree.
> > > 
> > > The control interface is comprised of 3 queues in total: Rx, Rx error
> > > and Tx confirmation. In this patch set we only enable Rx and Tx conf.
> > > All switch ports share the same queues when frames are redirected to the
> > > CPU.  Information regarding the ingress switch port is passed through
> > > frame metadata - the flow context field of the descriptor.
> > > 
> > > NAPI instances are also shared between switch net_devices and are
> > > enabled when at least on one of the switch ports .dev_open() was called
> > > and disabled when no switch port is still up.
> > > 
> > > Since the last version of this feature was submitted to the list, I
> > > reworked how the switching and flooding domains are taken care of by the
> > > driver, thus the switch is now able to also add the control port (the
> > > queues that the CPU can dequeue from) into the flooding domains of a
> > > port (broadcast, unknown unicast etc). With this, we are able to receive
> > > and sent traffic from the switch interfaces.
> > > 
> > > Also, the capability to properly partition the DPSW object into multiple
> > > switching domains was added so that when not under a bridge, the ports
> > > are not actually capable to switch between them. This is possible by
> > > adding a private FDB table per switch interface.  When multiple switch
> > > interfaces are under the same bridge, they will all use the same FDB
> > > table.
> > > 
> > > Another thing that is fixed in this patch set is how the driver handles
> > > VLAN awareness. The DPAA2 switch is not capable to run as VLAN unaware
> > > but this was not reflected in how the driver responded to requests to
> > > change the VLAN awareness. In the last patch, this is fixed by
> > > describing the switch interfaces as Rx VLAN filtering on [fixed] and
> > > declining any request to join a VLAN unaware bridge.
> > 
> > I'll take the first 14 patches now, and then you will have a "clean"
> > place to ask for the movement of this out of staging.
> > 
> 
> I was about to respond but it seems that you already applied them into
> the staging tree. By the way, I was expecting a bit of review from the
> netdev community since these changes are mainly to get the driver in a
> proper state for the move.

They are only in my "testing" branch, I can easily drop them right now
if you want me to.

> Ok, I am mainly interested in getting all these patches into net-next as
> well so that other general switchdev changes do not generate conflicts.

What other general switchdev changes?

> I assume that the next step would be to get acks from the netdev
> maintainers especially on the last patch, merge the move in the staging
> tree and then get all these changes into net-next through some kind of
> cross-tree merge?

Yes, either I can provide a stable tag to pull from for the netdev
maintainers, or they can just add the whole driver to the "proper" place
in the network tree and I can drop the one in staging entirely.  Or
people can wait until 5.13-rc1 when this all shows up in Linus's tree,
whatever works best for the networking maintainers, after reviewing it.

thanks,

greg k-h
