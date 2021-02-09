Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECAD31517B
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 15:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbhBIOX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 09:23:26 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:16060 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbhBIOXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 09:23:15 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60229aa60001>; Tue, 09 Feb 2021 06:22:30 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 9 Feb
 2021 14:22:30 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.145.6) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Tue, 9 Feb 2021 14:22:28 +0000
References: <20210206050240.48410-1-saeed@kernel.org>
 <20210206050240.48410-2-saeed@kernel.org>
 <20210206181335.GA2959@horizon.localdomain> <ygnhtuqngebi.fsf@nvidia.com>
 <20210208122213.338a673e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next V2 01/17] net/mlx5: E-Switch, Refactor setting source
 port
In-Reply-To: <20210208122213.338a673e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Tue, 9 Feb 2021 16:22:26 +0200
Message-ID: <ygnho8gtgw2l.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612880551; bh=pjD5JQF9yem3UTH1AqTJHjNopPuV/EfsNkR6018jkcw=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=rUVumTRqv394JfBjmCgApBgF7NFVHKKxubNMVU9Qc/G37ns+Z8lUIyYZ8njpN0PAo
         p28GWj5p6jRQtjB2VRuT1IZ4lEKaqeUP+Mbd9IKivauR4bg3Th2dO49Puq+eFsHdcM
         Gc9NP1SxOCzRdjXVJtF9arW5/H5JEvk0rqU+AsT8ZSgn1MP66RzjKYJIF7d2ND5bwC
         3nO2KnkzZFyT56auspx8iaR4zmKMmoFRJksUXt/zwlIuFoCz7uVJAR0NvqnvMv9qdL
         m8+Qqkurr7/IBF6wmPsV9LJWyy3V31GaUTCtdUGWHOYbPzNs5T0npl33PRDE0dhMHt
         0LKH+ut+8ggng==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 08 Feb 2021 at 22:22, Jakub Kicinski <kuba@kernel.org> wrote:
> On Mon, 8 Feb 2021 10:21:21 +0200 Vlad Buslov wrote:
>> > These operations imply that 7.7.7.5 is configured on some interface on
>> > the host. Most likely the VF representor itself, as that aids with ARP
>> > resolution. Is that so?
>> 
>> Hi Marcelo,
>> 
>> The tunnel endpoint IP address is configured on VF that is represented
>> by enp8s0f0_0 representor in example rules. The VF is on host.
>
> This is very confusing, are you saying that the 7.7.7.5 is configured
> both on VF and VFrep? Could you provide a full picture of the config
> with IP addresses and routing? 

Hi Jakub,

No, tunnel IP is configured on VF. That particular VF is in host
namespace. When mlx5 resolves tunneling the code checks if tunnel
endpoint IP address is on such mlx5 VF, since the VF is in same
namespace as eswitch manager (e.g. on host) and route returned by
ip_route_output_key() is resolved through rt->dst.dev==tunVF device.
After establishing that tunnel is on VF the goal is to process two
resulting TC rules (in both directions) fully in hardware without
exposing the packet on tunneling device or tunnel VF in sw, which is
implemented with all the infrastructure from this series.

So, to summarize with IP addresses from TC examples presented in cover letter,
we have underlay network 7.7.7.0/24 in host namespace with tunnel endpoint IP
address on VF:

$ ip a show dev enp8s0f0v0
1537: enp8s0f0v0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 52:e5:6d:f2:00:69 brd ff:ff:ff:ff:ff:ff
    altname enp8s0f0np0v0
    inet 7.7.7.5/24 scope global enp8s0f0v0
       valid_lft forever preferred_lft forever
    inet6 fe80::50e5:6dff:fef2:69/64 scope link
       valid_lft forever preferred_lft forever


Like all VFs in switchdev model the tunnel VF is controlled through representor
that doesn't have any IP address assigned:

$ ip a show dev enp8s0f0_0
1534: enp8s0f0_0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master ovs-system state UP group default qlen 1000
    link/ether 96:98:b1:59:aa:5e brd ff:ff:ff:ff:ff:ff
    altname enp8s0f0npf0vf0
    inet6 fe80::9498:b1ff:fe59:aa5e/64 scope link
       valid_lft forever preferred_lft forever


User VFs have IP addresses from overlay network (5.5.5.0/24 in my tests) and are
in namespaces/VMs, while only their representors are on host attached to same
v-switch bridge with tunnel VF represetor:

$ sudo ip netns exec ns0 ip a show dev enp8s0f0v1
1538: enp8s0f0v1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 9e:cf:b5:69:84:d1 brd ff:ff:ff:ff:ff:ff
    altname enp8s0f0np0v1
    inet 5.5.5.5/24 scope global enp8s0f0v1
       valid_lft forever preferred_lft forever
    inet6 fe80::9ccf:b5ff:fe69:84d1/64 scope link
       valid_lft forever preferred_lft forever

$ ip a show dev enp8s0f0_1
1535: enp8s0f0_1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master ovs-system state UP group default qlen 1000
    link/ether 06:96:1e:23:df:a4 brd ff:ff:ff:ff:ff:ff
    altname enp8s0f0npf0vf1


OVS bridge ports:

$ sudo ovs-vsctl list-ports ovs-br
enp8s0f0
enp8s0f0_0
enp8s0f0_1
enp8s0f0_2
vxlan0


The TC rules from cover letter are installed by OVS configured according to
description above when running iperf traffic from namespaced VF enp8s0f0v1 to
another machine connected over uplink port:

$ sudo ip  netns exec ns0 iperf3 -c 5.5.5.1 -t 10000
Connecting to host 5.5.5.1, port 5201
[  5] local 5.5.5.5 port 34486 connected to 5.5.5.1 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   158 MBytes  1.32 Gbits/sec   41    771 KBytes


Hope this clarifies things and sorry for confusion!

Regards,
Vlad
