Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D2F347547
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 11:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbhCXKE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 06:04:28 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33336 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233339AbhCXKD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 06:03:58 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 74D8862BEA;
        Wed, 24 Mar 2021 11:03:49 +0100 (CET)
Date:   Wed, 24 Mar 2021 11:03:54 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netfilter-devel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next,v2 01/24] net: resolve forwarding path from
 virtual netdevice and HW destination address
Message-ID: <20210324100354.GA8040@salvia>
References: <20210324013055.5619-1-pablo@netfilter.org>
 <20210324013055.5619-2-pablo@netfilter.org>
 <20210324072711.2835969-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210324072711.2835969-1-dqfext@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 03:27:11PM +0800, DENG Qingfang wrote:
> On Wed, Mar 24, 2021 at 02:30:32AM +0100, Pablo Neira Ayuso wrote:
> > This patch adds dev_fill_forward_path() which resolves the path to reach
> > the real netdevice from the IP forwarding side. This function takes as
> > input the netdevice and the destination hardware address and it walks
> > down the devices calling .ndo_fill_forward_path() for each device until
> > the real device is found.
> > 
> > For instance, assuming the following topology:
> > 
> >                IP forwarding
> >               /             \
> >            br0              eth0
> >            / \
> >        eth1  eth2
> >         .
> >         .
> >         .
> >        ethX
> >  ab:cd:ef:ab:cd:ef
> > 
> > where eth1 and eth2 are bridge ports and eth0 provides WAN connectivity.
> > ethX is the interface in another box which is connected to the eth1
> > bridge port.
> > 
> > For packets going through IP forwarding to br0 whose destination MAC
> > address is ab:cd:ef:ab:cd:ef, dev_fill_forward_path() provides the
> > following path:
> > 
> > 	br0 -> eth1
> > 
> > .ndo_fill_forward_path for br0 looks up at the FDB for the bridge port
> > from the destination MAC address to get the bridge port eth1.
> > 
> > This information allows to create a fast path that bypasses the classic
> > bridge and IP forwarding paths, so packets go directly from the bridge
> > port eth1 to eth0 (wan interface) and vice versa.
> > 
> >              fast path
> >       .------------------------.
> >      /                          \
> >     |           IP forwarding   |
> >     |          /             \  \/
> >     |       br0               eth0
> >     .       / \
> >      -> eth1  eth2
> >         .
> >         .
> >         .
> >        ethX
> >  ab:cd:ef:ab:cd:ef
> 
> Have you tested if roaming breaks existing TCP/UDP connections?
> For example, eth1 and eth2 are connected to 2 WiFi APs, and the
> client ab:cd:ef:ab:cd:ef roams between these APs.

For this scenario specifically, it should be possible extend the
existing flowtable netlink API to allow hostapd to flush entries in
the flowtable for the client changing AP.
