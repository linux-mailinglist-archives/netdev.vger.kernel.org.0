Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46E1A15CF09
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 01:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbgBNAcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 19:32:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:33960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727594AbgBNAcY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 19:32:24 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [199.201.64.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 809312187F;
        Fri, 14 Feb 2020 00:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581640343;
        bh=AbfmmWqIcUHv0PBw02IxfkQ/1LzoyrHb9KWAABRycjg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mNWHy+MIrujS/FOuFjEJA0fNE0pLMHp58c3mQ5TkCLZpzpAtoIiB0t3PPOC7Ej1nq
         xahF81WxlgD1ugU6sEjGfIE3677HQT86HYySjKHmdaQH/lN2+lwgPeH6NXEP7oR14b
         a4buGZ6ZQNZF4jMA0WBf2B9lsuJjeJxrWu5Iiln4=
Date:   Thu, 13 Feb 2020 16:32:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Or Gerlitz <ogerlitz@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net/tls: Act on going down event
Message-ID: <20200213163221.26bd882f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <CAJ3xEMjs0viZ6X5mkouSjcZrLNWwxVfxfffN=c1FuGK8MH8kDA@mail.gmail.com>
References: <20200213165407.60140-1-ogerlitz@mellanox.com>
        <20200213103228.2123025f@kicinski-fedora-PC1C0HJN>
        <CAJ3xEMjs0viZ6X5mkouSjcZrLNWwxVfxfffN=c1FuGK8MH8kDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Feb 2020 22:07:19 +0200 Or Gerlitz wrote:
> On Thu, Feb 13, 2020 at 8:34 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu, 13 Feb 2020 16:54:07 +0000 Or Gerlitz wrote:  
> > > By the time of the down event, the netdevice stop ndo was
> > > already called and the nic driver is likely to destroy the HW
> > > objects/constructs which are used for the tls_dev_resync op.  
> 
> >> @@ -1246,7 +1246,7 @@ static int tls_dev_event(struct notifier_block *this, unsigned long event,
> > > -     case NETDEV_DOWN:
> > > +     case NETDEV_GOING_DOWN:  
> 
> > Now we'll have two race conditions. 1. Traffic is still running while
> > we remove the connection state. 2. We clean out the state and then
> > close the device. Between the two new connections may be installed.
> >
> > I think it's an inherently racy to only be able to perform clean up
> > while the device is still up.  
> 
> good points, I have to think on both of them and re/sync (..) with
> the actual design details here, I came across this while working
> on something else which is still more of a research so just throwing
> a patch here was moving too fast.
> 
> Repeating myself -- by the time of the down event, the netdevice
> stop ndo was already called and the nic driver is likely to destroy
> HW objects/constructs which are used for the tls_dev_resync op.
> 
> For example suppose a NIC driver uses some QP/ring to post resync
> request to the HW and these rings are part of the driver's channels and
> the channels are destroyed when the stop ndo is called - the tls code
> here uses RW synchronization between invoking the resync driver op
> to the down event handling. But the down event comes only after these
> resources were destroyed, too late. If we will safely/stop the offload
> at the going down stage, we can avoid a much more complex and per nic
> driver locking which I guess would be needed to protect against that race.
> 
> thoughts?

I'm not sure what happens on the device side, so take this with
a pinch of salt.

The device flushing some state automatically on down sounds like 
a pretty error prone design, I don't think you'd do that :)

So I think you're just using datapath components associated with a
vNIC/function to speed up communication with the device? That does 
get painful quite quickly if the device does not have a idea of 
control QPs/functions/vNICs with independent state :S

We could slice the downing in the stack into one more stage where 
device is considered down but resources (mem, irq, qps) are not freed,
but I think that's not a complete fix, because one day you may want 
to do BPF offloads or use QPs for devlink and those are independent of
vNIC/function state, anyway.. 

> - so here's
> the point -- the driver resync op may use some HW
