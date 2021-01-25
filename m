Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480103034D0
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732874AbhAZF2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:28:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:33436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730459AbhAYSrC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 13:47:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF53F20E65;
        Mon, 25 Jan 2021 18:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611600373;
        bh=itgxDhcDsOpB0h7ObeC7BQRMoAmjMJDBZDztJMIQKo8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JfeKEhyZDq+ehQS8wKaiEmUNl5kFX0h1qsQ+pEibXO5MqfkNOQEgzi8nTfXGsufQe
         cfGeaxz2jaRVNQvED8OBJ/4SUx4SJA+8mzNIBte59Q6skEKXDeQW/oK/Mpdpleh+K8
         riQxZrzSVb89h53IKQ9LZ6yLqxm0Y+YZ27qCy0sXjdQbr3H8L2+MbK6y5Pnpb13AXE
         3qdv23jbW7SZ1Y4uxuaJ1fFEdJrq1eDlBv14NgPraJBOfTZYtJis/RlIo+FyJX7sNK
         bCCW70PwKEY+nGD+FEMGL1YGa8/epqHw2/yaVoZnd4V4gI1OtiqfJc5L6mSbrj7w7f
         4HRGj2GGZ701Q==
Date:   Mon, 25 Jan 2021 10:46:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v6 net-next 07/10] net: dsa: allow changing the tag
 protocol via the "tagging" device attribute
Message-ID: <20210125104611.35fb8daf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210124082039.gkgxskot7oxseub7@skbuf>
References: <20210121160131.2364236-1-olteanv@gmail.com>
        <20210121160131.2364236-8-olteanv@gmail.com>
        <20210122205216.7f1e05f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210124082039.gkgxskot7oxseub7@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Jan 2021 10:20:39 +0200 Vladimir Oltean wrote:
> On Fri, Jan 22, 2021 at 08:52:16PM -0800, Jakub Kicinski wrote:
> > On Thu, 21 Jan 2021 18:01:28 +0200 Vladimir Oltean wrote:  
> > > +	list_for_each_entry(dp, &dst->ports, list) {  
> >
> > What protects this iteration? All sysfs guarantees you is that
> > struct net_device *master itself will not disappear.
> >
> > Could you explain the locking expectations a bit?  
> 
> The dsa_group sysfs is removed in:
> 
> dsa_unregister_switch
> -> mutex_lock(&dsa2_mutex)
> -> dsa_switch_remove
>    -> dsa_tree_teardown
>       -> dsa_tree_teardown_master
>          -> dsa_master_teardown
>             -> sysfs_remove_group  
> There are 2 points here:
> 1. sysfs_remove_group actually waits for a concurrent tagging_store()
>    call to finish (at least it does when I put an msleep(10000) inside
>    tagging_store).
> 2. After the sysfs_remove_group, dsa_tree_change_tag_proto should never
>    be called again.
> 
> Next comes:
>    -> dsa_tree_teardown
>       -> dsa_tree_teardown_switches
>          -> dsa_port_teardown
>             -> dsa_slave_destroy  
> After this, all DSA net devices are unregistered and freed.
> 
> Next comes:
> -> dsa_switch_remove
>    -> dsa_switch_release_ports
> -> mutex_unlock(&dsa2_mutex)  
> where the dst->ports list is finally freed.
> 
> So there is no chance that the dst->ports list is modified concurrently
> with tagging_store.

Sounds good, thanks!
