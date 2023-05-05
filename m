Return-Path: <netdev+bounces-566-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 246136F836C
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 15:02:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A020F280FBC
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 13:02:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7612BA935;
	Fri,  5 May 2023 13:02:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E656FBE
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 13:02:38 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F5846B9
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 06:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=if6jBNx0TnA3067zHwSDSRmQBzqrtpjXvSP6SUmWnxo=; b=m7Ex3IOL/sBwjg3BRacBHuftfn
	3kv+T3N5yCAVfO5GMKqvQcrgoGfBFDUQbCU9IOoF774tI2w2IVvZrH4+quPZApNAJ9Fa9HQw31qw+
	INEw2HY5SuCe514qMloWareU3ZQyd1yXJcMJk5vEKDiKUoEj5D6jRSbi2iLfeCGox9e4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1puv4v-00Bzxn-FR; Fri, 05 May 2023 15:02:29 +0200
Date: Fri, 5 May 2023 15:02:29 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Fabio Estevam <festevam@gmail.com>
Cc: Vladimir Oltean <olteanv@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Steffen =?iso-8859-1?Q?B=E4tz?= <steffen@innosonix.de>,
	netdev <netdev@vger.kernel.org>
Subject: Re: mv88e6320: Failed to forward PTP multicast
Message-ID: <5e21a8da-b31f-4ec8-8b46-099af5a8b8af@lunn.ch>
References: <CAOMZO5AMOVAZe+w3FiRO-9U98Foba5Oy4f_C0K7bGNxHA1qz_w@mail.gmail.com>
 <7b8243a3-9976-484c-a0d0-d4f3debbe979@lunn.ch>
 <CAOMZO5DXH1wS9YYPWXYr-TvM+9Tj8F0bY0_kd_EAjrcCpEJJ7A@mail.gmail.com>
 <CAOMZO5Dk44QSTg2rh_HPHXg=H7BJ+x1h95M+t8nr2CLW+8pABw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5Dk44QSTg2rh_HPHXg=H7BJ+x1h95M+t8nr2CLW+8pABw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> I gave you incorrect information, sorry about that.
> 
> Let me restart and share the test results.
> 
> We have made 2 tests. The only difference is the absence of "ip link
> set dev vswitch0 type bridge vlan_filtering 1" in test 2

O.K, so we are back to the switch hardware.

I notice you have an extra, unneeded, down/up in you script. Is that
required to produce the problem?

> 
> Test 1.) No PTP traffic on ETH1 can be sniffed after config
> ----------------------------------------------------------------------------
> ip addr del 172.16.42.199/22 dev eth1
> # Add bridge
> ip link add name vswitch0 type bridge
> sleep 1
> ip link set dev vswitch0 type bridge vlan_filtering 1
> sleep 1
> ip link set eth1 master vswitch0
> ip link set eth2 master vswitch0
> 
> sleep 1
> ip link set eth1 down
> ip link set eth2 down
> 
> sleep 1
> ip link set vswitch0 up
> ip link set eth1 up
> ip link set eth2 up
> 
> sleep 1
> ip addr add 172.16.42.199/22 dev eth1
> 
> sleep 1
> tcpdump -i eth1 dst port 319 or dst port 320
> ----------- ------------------------------
> 
> Test 2.) PTP traffic on ETH1 can be sniffed after config
> ------------------------------------------------------------------------
> ip addr del 172.16.42.199/22 dev eth1
> 
> # Add bridge
> ip link add name vswitch0 type bridge
> 
> sleep 1
> ip link set eth1 master vswitch0
> ip link set eth2 master vswitch0
> 
> sleep 1
> ip link set eth1 down
> ip link set eth2 down
> 
> sleep 1
> ip link set vswitch0 up
> ip link set eth1 up
> ip link set eth2 up
> 
> sleep 1
> ip addr add 172.16.42.199/22 dev eth1
> 
> sleep 1
> tcpdump -i eth1 dst port 319 or dst port 320
> ----------- ------------------------------
> 
> Please find attached the log of PTP sniffing on eth1 from test 2.
> 
> There is no such MAC address as 01-80-C2-00-00-0E.

> 08:21:25.544600 00:1d:c1:18:73:fe (oui Unknown) > 01:00:5e:00:01:81 (oui Unknown), ethertype IPv4 (0x0800), length 94: (tos 0xb8, ttl 1, id 0, offset 0, flags [DF], proto UDP (17), length 80)
>     172.16.41.45.3187 > 224.0.1.129.ptp-general: [udp sum ok] PTPv1 (not implemented)

So some background....

I mention 01-80-C2-00-00-0E because the switch looks for specific
types of frames and forwards them to the CPU, independent of the
status of the port. So for example, BPDUs used for spanning tree, use
a MAC address in the range 01-80-C2-00-00-XX, so the switch forwards
them to the CPU. PTP using 01-80-C2-00-00-0E would also match and get
forwarded to the CPU.

You are using 01:00:5e:00:01:81, so that is just general
multicast. The hardware matching for PTP is probably not going to
match on that.

What might also be playing a role here, maybe, is IGMP snooping. Does
your downstream PTP client issue IGMP join requests for the group, and
does the Linux bridge see them? If IGMP snooping is active, and there
is no IGMP signalling, there is no need to actually forward the PTP
frames, since nobody is interested in them. If there is a client
interested in the traffic, you would expect to see a multicast FDB
entry added to the switch in order that it forwards the multicast to
the CPU. However, this does not really fit the vlan_filtering.

When i look at your tcpdump traffic, i don't see a VLAN for your PTP
traffic. So i'm assuming it is untagged. You also don't appear to be
setting a default VLAN PVID. If you define it, untagged traffic gets
tagged on ingress and is then handled like tagged traffic.

So this is probably why your traffic is dropped. Try:

ip link set dev vswitch0 type bridge vlan_filtering 1 vlan_default_pvid 42

So that untagged traffic gets tagged as VLAN 42.

I'm not too familiar with all this VLAN stuff. So i could be telling
your wrong information.... 'self' is also importing in way's i don't
really understand. Vladimir and Tobias are the experts here.

   Andrew

