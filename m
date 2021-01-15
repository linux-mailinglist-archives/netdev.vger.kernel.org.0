Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2DB82F7443
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 09:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbhAOIZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 03:25:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42156 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726004AbhAOIZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 03:25:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610699051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tf/TjBbdMbBv6ygfGWl1CKM3iFptcyc6BqOh5S0a6Sg=;
        b=DRL/O+4EReB/fOV8ccjmven9aFKsu5RCccs82FBchNv04IEpzay69gi76UT8X7ivic5u7h
        Ot0+A452yhY75ZE3hdKeMtH6YjblpXgNVJ1bQjyXtT16H1AXfAa4pa5hpz9j5BnohdcheL
        1bconfbSfKGQvGhS5+hN+QWXRWC6LdE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-EgJflOS_N52oXMga3b93Pw-1; Fri, 15 Jan 2021 03:24:09 -0500
X-MC-Unique: EgJflOS_N52oXMga3b93Pw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F23F10082F4;
        Fri, 15 Jan 2021 08:24:08 +0000 (UTC)
Received: from ceranb (unknown [10.40.195.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CBAEB5D752;
        Fri, 15 Jan 2021 08:24:06 +0000 (UTC)
Date:   Fri, 15 Jan 2021 09:24:05 +0100
From:   Ivan Vecera <ivecera@redhat.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net] team: fix deadlock during setting of MTU
Message-ID: <20210115092405.29e8ff8f@ceranb>
In-Reply-To: <174c673c87fea15e832b795140addb70827818ff.camel@kernel.org>
References: <20210114115506.1713330-1-ivecera@redhat.com>
        <174c673c87fea15e832b795140addb70827818ff.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 16:34:24 -0800
Saeed Mahameed <saeed@kernel.org> wrote:

> On Thu, 2021-01-14 at 12:55 +0100, Ivan Vecera wrote:
> > Team driver protects port list traversal in team_change_mtu()
> > by its team->lock mutex. This causes a deadlock with certain
> > devices that calls netdev_update_features() during their
> > .ndo_change_mtu() callback. In this case netdev_update_features()
> > calls team's netdevice notifier team_device_event() that in case
> > of NETDEV_FEAT_CHANGE tries lock team->lock mutex again.
> > 
> > Example (r8169 case):
> > ...
> > [ 6391.348202]  __mutex_lock.isra.6+0x2d0/0x4a0
> > [ 6391.358602]  team_device_event+0x9d/0x160 [team]
> > [ 6391.363756]  notifier_call_chain+0x47/0x70
> > [ 6391.368329]  netdev_update_features+0x56/0x60
> > [ 6391.373207]  rtl8169_change_mtu+0x14/0x50 [r8169]
> > [ 6391.378457]  dev_set_mtu_ext+0xe1/0x1d0
> > [ 6391.387022]  dev_set_mtu+0x52/0x90
> > [ 6391.390820]  team_change_mtu+0x64/0xf0 [team]
> > [ 6391.395683]  dev_set_mtu_ext+0xe1/0x1d0
> > [ 6391.399963]  do_setlink+0x231/0xf50
> > ...
> > 
> > To fix the problem the port list traversal in team_change_mtu() can
> > be protected by RCU read lock. In case of failure the failing port
> > is marked and unwind code-path is done also under RCU read lock
> > protection (but not in reverse order).
> > 
> > Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
> > Cc: Jiri Pirko <jiri@resnulli.us>
> > Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> > ---
> >  drivers/net/team/team.c | 20 ++++++++++----------
> >  1 file changed, 10 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
> > index c19dac21c468..69d4b28beb17 100644
> > --- a/drivers/net/team/team.c
> > +++ b/drivers/net/team/team.c
> > @@ -1802,35 +1802,35 @@ static int team_set_mac_address(struct
> > net_device *dev, void *p)
> >  static int team_change_mtu(struct net_device *dev, int new_mtu)
> >  {
> >  	struct team *team = netdev_priv(dev);
> > -	struct team_port *port;
> > +	struct team_port *port, *fail_port;
> >  	int err;
> >  
> > -	/*
> > -	 * Alhough this is reader, it's guarded by team lock. It's not
> > possible
> > -	 * to traverse list in reverse under rcu_read_lock
> > -	 */
> > -	mutex_lock(&team->lock);
> > +	rcu_read_lock();
> >  	team->port_mtu_change_allowed = true;
> > -	list_for_each_entry(port, &team->port_list, list) {
> > +	list_for_each_entry_rcu(port, &team->port_list, list) {
> >  		err = dev_set_mtu(port->dev, new_mtu);  
> 
> some netdevs will need to sleep in their set_mtu, and you can't sleep
> under rcu!
> 
> according to your explanation in the commit message the team->lock
> mutex will be also taken under this rcu lock, so this is bad even
> if dev_set_mtu does not sleep.
> 
Hmm, you are right... btw do we need to take this mutex at this place?

team_change_mtu() is protected by RTNL, team_device_event() as a netdevice
notifier as well... and team_{add,del}_slave() that modify port list
also.

Thoughts?

Thanks,
Ivan

