Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B0F2FFE54
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 09:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbhAVIiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 03:38:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55622 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726024AbhAVIcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 03:32:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611304239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qvMwVVlFXQYGVqb6WRJLk0ECV6lsevaioKw5/v7v+OI=;
        b=DE1rl1i6q/2sgHV97/1hgOr/tXJiOl3sRM3WfjCSArImvyZ8lB7vFpTrDzWzyRjFwq0EK8
        mlRQM9pats8WV8YbEUD5c+VSy1WqSmRDhdHfck06801BcE2++nbjfiYZxT80+DFyQW9lJN
        T07xYYBdJZT1hoeo/lajH+/n6E8GTQM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-578-ZIfmriKlNU2ppM3d1DREEg-1; Fri, 22 Jan 2021 03:30:37 -0500
X-MC-Unique: ZIfmriKlNU2ppM3d1DREEg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6F9518C89CF;
        Fri, 22 Jan 2021 08:30:32 +0000 (UTC)
Received: from ceranb (unknown [10.40.194.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F0C460C13;
        Fri, 22 Jan 2021 08:30:28 +0000 (UTC)
Date:   Fri, 22 Jan 2021 09:30:27 +0100
From:   Ivan Vecera <ivecera@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        saeed@kernel.org, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net] team: postpone features update to avoid deadlock
Message-ID: <20210122093027.33b2e8e7@ceranb>
In-Reply-To: <20210121183452.47f0cffa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210120122354.3687556-1-ivecera@redhat.com>
        <CAM_iQpUqdm-mpSUdsxEtLnq6GwhN=YL+ub--8N0aGxtM+PRfAQ@mail.gmail.com>
        <20210121112937.11b72ea6@ceranb>
        <20210121183452.47f0cffa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jan 2021 18:34:52 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> On Thu, 21 Jan 2021 11:29:37 +0100 Ivan Vecera wrote:
> > On Wed, 20 Jan 2021 15:18:20 -0800
> > Cong Wang <xiyou.wangcong@gmail.com> wrote:  
> > > On Wed, Jan 20, 2021 at 4:56 AM Ivan Vecera <ivecera@redhat.com> wrote:    
> > > > Team driver protects port list traversal by its team->lock mutex
> > > > in functions like team_change_mtu(), team_set_rx_mode(),  
> 
> The set_rx_mode part can't be true, set_rx_mode can't sleep and
> team->lock is a mutex.
> 
> > > > To fix the problem __team_compute_features() needs to be postponed
> > > > for these cases.      
> > > 
> > > Is there any user-visible effect after deferring this feature change?  
> >
> > An user should not notice this change.  
> 
> I think Cong is right, can you expand a little on your assertion?
> User should be able to assume that the moment syscall returns the
> features had settled.
> 
> What does team->mutex actually protect in team_compute_features()?
> All callers seem to hold RTNL at a quick glance. This is a bit of 
> a long shot but isn't it just tryin to protect the iteration over 
> ports which could be under RCU?

In fact the mutex could be removed at all because all port-list
writers are running under rtnl_lock, some readers like team_change_mtu()
or team_device_event() [notifier] as well and hot path readers are
protected by RCU.
I have discussed this with Jiri but he don't want to introduce any dependency
on RTNL to team as it was designed as RTNL-independent from beginning.

Anyway your idea to run team_compute_features under RCU could be fine
as subsequent __team_compute_features() cannot sleep...

Do you mean something like this?

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index c19dac21c468..dd7917cab2b1 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -992,7 +992,8 @@ static void __team_compute_features(struct team *team)
        unsigned int dst_release_flag = IFF_XMIT_DST_RELEASE |
                                        IFF_XMIT_DST_RELEASE_PERM;
 
-       list_for_each_entry(port, &team->port_list, list) {
+       rcu_read_lock();
+       list_for_each_entry_rcu(port, &team->port_list, list) {
                vlan_features = netdev_increment_features(vlan_features,
                                        port->dev->vlan_features,
                                        TEAM_VLAN_FEATURES);
@@ -1006,6 +1007,7 @@ static void __team_compute_features(struct team *team)
                if (port->dev->hard_header_len > max_hard_header_len)
                        max_hard_header_len = port->dev->hard_header_len;
        }
+       rcu_read_unlock();
 
        team->dev->vlan_features = vlan_features;
        team->dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL |
@@ -1020,9 +1022,7 @@ static void __team_compute_features(struct team *team)
 
 static void team_compute_features(struct team *team)
 {
-       mutex_lock(&team->lock);
        __team_compute_features(team);
-       mutex_unlock(&team->lock);
        netdev_change_features(team->dev);
 }

Thanks for comments,

Ivan

