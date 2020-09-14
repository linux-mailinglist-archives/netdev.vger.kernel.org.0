Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214072697B8
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbgINVbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:31:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbgINVbD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 17:31:03 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8FE120715;
        Mon, 14 Sep 2020 21:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600119063;
        bh=3rkZ7CdRjA/a6sBAPu8azs7PpRx/PIItk/odvnzR4Lg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1XMZ4k3PkXzdo83RypURrov6El8Lv/9IadYO3elfz2vWmH4qh5XzNycExEvgb08ie
         nyN/qb2rXSPj5DVSLTeMNqtaoca6LBhFJg9OsTpsn8VyXixZ2F6BNuRVP0iaFFmtJ6
         rtzaUq2nXYOlytOcKqB4EjLTmhCnxodV91WI23YY=
Date:   Mon, 14 Sep 2020 14:31:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next RFC v4 01/15] devlink: Add reload action option
 to devlink reload command
Message-ID: <20200914143100.06a4641d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200914112829.GC2236@nanopsycho.orion>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
        <1600063682-17313-2-git-send-email-moshe@mellanox.com>
        <CAACQVJochmfmUgKSvSTe4McFvG6=ffBbkfXsrOJjiCDwQVvaRw@mail.gmail.com>
        <20200914093234.GB2236@nanopsycho.orion>
        <CAACQVJqVV_YLfV002wxU2s1WJUa3_AvqwMMVr8KLAtTa0d9iOw@mail.gmail.com>
        <20200914112829.GC2236@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020 13:28:29 +0200 Jiri Pirko wrote:
> Mon, Sep 14, 2020 at 11:54:55AM CEST, vasundhara-v.volam@broadcom.com wrote:
> >On Mon, Sep 14, 2020 at 3:02 PM Jiri Pirko <jiri@resnulli.us> wrote:  
> >> >> +mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink, enum devlink_reload_action action,
> >> >> +                                       struct netlink_ext_ack *extack,
> >> >> +                                       unsigned long *actions_performed)  
> >> >Sorry for repeating again, for fw_activate action on our device, all
> >> >the driver entities undergo reset asynchronously once user initiates
> >> >"devlink dev reload action fw_activate" and reload_up does not have
> >> >much to do except reporting actions that will be/being performed.
> >> >
> >> >Once reset is complete, the health reporter will be notified using  
> >>
> >> Hmm, how is the fw reset related to health reporter recovery? Recovery
> >> happens after some error event. I don't believe it is wise to mix it.  
> >Our device has a fw_reset health reporter, which is updated on reset
> >events and firmware activation is one among them. All non-fatal
> >firmware reset events are reported on fw_reset health reporter.  
> 
> Hmm, interesting. In that case, assuming this is fine, should we have
> some standard in this. I mean, if the driver supports reset, should it
> also define the "fw_reset" reporter to report such events?
> 
> Jakub, what is your take here?

Sounds doubly wrong to me.

As you say health reporters should trigger on error events,
communicating completion of an action requested by the user
seems very wrong. IIUC operators should monitor and collect
health failures. In this case looks like all events from fw_reset 
would need to be discarded, since they are not meaningful
without the context of what triggered them.

And secondly, reporting the completion via some async mechanism
that user has to monitor is just plain lazy. That's pushing out
the work that has to be done out to user space. Wait for the 
completion in the driver.

> >> Instead, why don't you block in reload_up() until the reset is complete?  
> >
> >Though user initiate "devlink dev reload" event on a single interface,
> >all driver entities undergo reset and all entities recover
> >independently. I don't think we can block the reload_up() on the
> >interface(that user initiated the command), until whole reset is
> >complete.  
> 
> Why not? mlxsw reset takes up to like 10 seconds for example.

+1, why?
