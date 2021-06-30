Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886253B7D03
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 07:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbhF3Fhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 01:37:36 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:39550 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbhF3Fhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 01:37:35 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id D9206800051;
        Wed, 30 Jun 2021 07:34:56 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 30 Jun 2021 07:34:56 +0200
Received: from moon.secunet.de (172.18.26.121) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 30 Jun
 2021 07:34:56 +0200
Date:   Wed, 30 Jun 2021 07:34:48 +0200
From:   Antony Antony <antony.antony@secunet.com>
To:     David Ahern <dsahern@gmail.com>
CC:     Eyal Birger <eyal.birger@gmail.com>, <antony.antony@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Hideaki YOSHIFUJI" <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, <netdev@vger.kernel.org>,
        Christian Perle <christian.perle@secunet.com>
Subject: Re: [PATCH net-next] ipv6: Add sysctl for RA default route table
 number
Message-ID: <20210630053448.GA24708@moon.secunet.de>
Reply-To: <antony.antony@secunet.com>
References: <cover.1619775297.git.antony.antony@secunet.com>
 <32de887afdc7d6851e7c53d27a21f1389bb0bd0f.1624604535.git.antony.antony@secunet.com>
 <95b096f7-8ece-46be-cedb-5ee4fc011477@gmail.com>
 <20210629125316.GA18078@moon.secunet.de>
 <69e7e4e5-4219-5149-e7aa-fd26aa62260e@gmail.com>
 <b7e41f4b-04d6-2cff-038b-ccb250c2eb84@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b7e41f4b-04d6-2cff-038b-ccb250c2eb84@gmail.com>
Organization: secunet
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 09:34:22 -0600, David Ahern wrote:
> On 6/29/21 8:05 AM, Eyal Birger wrote:
> > Hi Antony,
> > 
> > On 29/06/2021 15:53, Antony Antony wrote:
> >> Hi David,
> >>
> >> On Fri, Jun 25, 2021 at 22:47:41 -0600, David Ahern wrote:
> >>> On 6/25/21 1:04 AM, Antony Antony wrote:
> >>>> From: Christian Perle <christian.perle@secunet.com>
> >>>>
> >>>> Default routes learned from router advertisements(RA) are always placed
> >>>> in main routing table. For policy based routing setups one may
> >>>> want a different table for default routes. This commit adds a sysctl
> >>>> to make table number for RA default routes configurable.
> >>>>
> >>>> examples:
> >>>> sysctl net.ipv6.route.defrtr_table
> >>>> sysctl -w net.ipv6.route.defrtr_table=42
> >>>> ip -6 route show table 42
> >>>
> >>> How are the routing tables managed? If the netdevs are connected to a
> >>> VRF this just works.

Ah! I figured it out what you were hinting at! Sorry, I didn't know about
IFLA_VRF_TABLE attribute of link type vrf.

I also found the Documentation/networking/vrf.rst and red the commits
including the iproute2 commits. Thanks for the hint.

It looks like the vrf->tb_id is used for both v4 and v6 routing?
We are only looking at V6 routing, because the table only have v6 routes.

> >>
> >> The main routing table has no default route. Our scripts add routing
> >> rules
> >> based on interfaces. These rules use the specific routing table where
> 
> That's the VRF use case -- routing rules based on interfaces. Connect
> those devices to VRFs and the RA does the right thing.
> 
> >> the RA
> >> (when using SLAAC) installs the default route. The rest just works.
> > 
> > Could this be a devconf property instead of a global property? seems

yes adding to ipv6_devconf.cnf.ra_defrtr_tble is interesting.

I may propose a general solution that can replaces 
vrf_fib_table(retrun vrf->tb_id).
Do we need two? one for v6(in ipv6_devconf) and one for v4(bit map entry
in ipv4_devconf.cnf.data)?

there will be two ways to configure the defrtr_table option.
Frst using current ip link vrf table, when creating the devince, and
sysctl options.

e.g
ip link add vrf-blue type vrf table 10
would set set both
	ipv4_devconf.cnf.data[IPV4_DEVCONF_DEFRTR_TABLE] 
	ipv6_devconf.cnf.ra_defrtr_tble

sysctl will add additional 4 options
 net.ipv4.conf.all.defrtr_table
 net.ipv4.conf.eth0.defrtr_table
 net.ipv6.conf.all.defrtr_tabe
 net.ipv6.conf.eth0.defrtr_table

I guess replacing l3mdev_fib_table_rcu() would be complicated. 
I will think about a generic l3mdev_fib_table(). Any tips how to add
defrtr_table support for various link types?

> > like the difference would be minor to your patch but the benefit is that
> > setups using different routing tables for different policies could
> > benefit (as mentioned when not using vrfs).
> 
> exactly. This is definitely not a global setting, but a per device
> setting if at all.

A per device setting would work for our use case.

thanks,
-antony
