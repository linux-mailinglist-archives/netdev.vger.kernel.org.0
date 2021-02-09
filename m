Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6718C3156ED
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 20:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbhBIThW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 14:37:22 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4331 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233643AbhBITY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 14:24:58 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6022dfbc0001>; Tue, 09 Feb 2021 11:17:16 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 9 Feb
 2021 19:17:16 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.145.6) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Tue, 9 Feb 2021 19:17:14 +0000
References: <20210206050240.48410-1-saeed@kernel.org>
 <20210206050240.48410-2-saeed@kernel.org>
 <20210206181335.GA2959@horizon.localdomain> <ygnhtuqngebi.fsf@nvidia.com>
 <20210208122213.338a673e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ygnho8gtgw2l.fsf@nvidia.com>
 <20210209100504.119925c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [net-next V2 01/17] net/mlx5: E-Switch, Refactor setting source
 port
In-Reply-To: <20210209100504.119925c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Tue, 9 Feb 2021 21:17:11 +0200
Message-ID: <ygnhlfbxgifc.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612898236; bh=CjWgoIRLXnYGy9r3D6PCtEs4db81i3CNO1cv6SwPfuE=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=Pg7Of4Zsonw4/6QMwknva6Z/qHoP+6UeVCRCLuJlS0ZpspoGiHDPr6HM6RQ95PRVs
         b/UiLK9Q+JEpb/SQTpInx+WS4r2Mry/7Zuj/m1Gd8URtjh9bwMUAPJUagDsx+fj8df
         +o5BH8+lRqJQMIYBxFkFTApH99VaEFR5Ycza455wNqMrEaNv8Mo3IUZN/Oc8DqVR56
         hosZ1rWJ7uOIAm2Z6fTsAE3k5Tg9vnao2FkCEel9V7wPOWq0hfOUtq64mjjDU/WGDP
         egKMosy3s5KVcqbkmoyxR8mTz3Rq5lQyFtSqxOAl+yTGEwbsuhas5utjPbXUa1bmbM
         QxF9rojTKmm+w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 09 Feb 2021 at 20:05, Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 9 Feb 2021 16:22:26 +0200 Vlad Buslov wrote:
>> No, tunnel IP is configured on VF. That particular VF is in host
>> namespace. When mlx5 resolves tunneling the code checks if tunnel
>> endpoint IP address is on such mlx5 VF, since the VF is in same
>> namespace as eswitch manager (e.g. on host) and route returned by
>> ip_route_output_key() is resolved through rt->dst.dev==tunVF device.
>> After establishing that tunnel is on VF the goal is to process two
>> resulting TC rules (in both directions) fully in hardware without
>> exposing the packet on tunneling device or tunnel VF in sw, which is
>> implemented with all the infrastructure from this series.
>> 
>> So, to summarize with IP addresses from TC examples presented in cover letter,
>> we have underlay network 7.7.7.0/24 in host namespace with tunnel endpoint IP
>> address on VF:
>> 
>> $ ip a show dev enp8s0f0v0
>> 1537: enp8s0f0v0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
>>     link/ether 52:e5:6d:f2:00:69 brd ff:ff:ff:ff:ff:ff
>>     altname enp8s0f0np0v0
>>     inet 7.7.7.5/24 scope global enp8s0f0v0
>>        valid_lft forever preferred_lft forever
>>     inet6 fe80::50e5:6dff:fef2:69/64 scope link
>>        valid_lft forever preferred_lft forever
>
> Isn't this 100% the wrong way around. Disable the offloads. Does the
> traffic hit the VF encapsulated?
>
> IIUC SW will do this:
>
>         PHY port
>            |
> device     |             ,-----.
> -----------|------------|-------|----------
> kernel     |            |       |
>         (UL/PF)       (VFr)    (VF)
>            |            |       |
>         [TC ing]>redir -`       V
>
> And the packet never hits encap.

We can look at dumps on every stage (produced by running exactly the
same test with OVS option other_config:tc-policy=skip_hw):

1. Traffic arrives at UL with vxlan encapsulation

$ sudo tcpdump -ni enp8s0f0 -vvv -c 3
dropped privs to tcpdump
tcpdump: listening on enp8s0f0, link-type EN10MB (Ethernet), capture size 262144 bytes
21:01:28.619346 IP (tos 0x0, ttl 64, id 65187, offset 0, flags [none], proto UDP (17), length 102)
    7.7.7.1.52277 > 7.7.7.5.vxlan: [udp sum ok] VXLAN, flags [I] (0x08), vni 98
IP (tos 0x0, ttl 64, id 43919, offset 0, flags [DF], proto TCP (6), length 52)
    5.5.5.1.targus-getdata1 > 5.5.5.5.34538: Flags [.], cksum 0x467b (correct), seq 2194968387, ack 2680742983, win 24576, options [nop,nop,TS val 1092282319 ecr 348802330], length 0
21:01:28.619505 IP (tos 0x0, ttl 64, id 888, offset 0, flags [none], proto UDP (17), length 1500)
    7.7.7.5.40092 > 7.7.7.1.vxlan: [no cksum] VXLAN, flags [I] (0x08), vni 98
IP (tos 0x0, ttl 64, id 6662, offset 0, flags [DF], proto TCP (6), length 1450)
    5.5.5.5.34538 > 5.5.5.1.targus-getdata1: Flags [.], cksum 0x8025 (correct), seq 673837:675235, ack 0, win 502, options [nop,nop,TS val 348802333 ecr 1092282319], length 1398
21:01:28.619506 IP (tos 0x0, ttl 64, id 889, offset 0, flags [none], proto UDP (17), length 1500)
    7.7.7.5.40092 > 7.7.7.1.vxlan: [no cksum] VXLAN, flags [I] (0x08), vni 98
IP (tos 0x0, ttl 64, id 6663, offset 0, flags [DF], proto TCP (6), length 1450)
    5.5.5.5.34538 > 5.5.5.1.targus-getdata1: Flags [.], cksum 0x19d1 (correct), seq 675235:676633, ack 0, win 502, options [nop,nop,TS val 348802333 ecr 1092282319], length 1398


2. By TC rule traffic is redirected to tunnel VF that has IP address
7.7.7.5 (still encapsulated as there is no decap action attached to
filter on enp8s0f0):

$ sudo tcpdump -ni enp8s0f0v0 -vvv -c 3
dropped privs to tcpdump
tcpdump: listening on enp8s0f0v0, link-type EN10MB (Ethernet), capture size 262144 bytes
21:03:41.524244 IP (tos 0x0, ttl 64, id 48184, offset 0, flags [none], proto UDP (17), length 1500)
    7.7.7.5.40092 > 7.7.7.1.vxlan: [no cksum] VXLAN, flags [I] (0x08), vni 98
IP (tos 0x0, ttl 64, id 52619, offset 0, flags [DF], proto TCP (6), length 1450)
    5.5.5.5.34538 > 5.5.5.1.targus-getdata1: Flags [.], cksum 0xaddb (correct), seq 279895999:279897397, ack 2194968387, win 502, options [nop,nop,TS val 348935238 ecr 1092415214], length 1398
21:03:41.568055 IP (tos 0x0, ttl 64, id 701, offset 0, flags [none], proto UDP (17), length 102)
    7.7.7.1.52277 > 7.7.7.5.vxlan: [udp sum ok] VXLAN, flags [I] (0x08), vni 98
IP (tos 0x0, ttl 64, id 44938, offset 0, flags [DF], proto TCP (6), length 52)
    5.5.5.1.targus-getdata1 > 5.5.5.5.34538: Flags [.], cksum 0xc623 (correct), seq 1, ack 1398, win 24576, options [nop,nop,TS val 1092415267 ecr 348935238], length 0
21:03:41.568384 IP (tos 0x0, ttl 64, id 48191, offset 0, flags [none], proto UDP (17), length 1500)
    7.7.7.5.40092 > 7.7.7.1.vxlan: [no cksum] VXLAN, flags [I] (0x08), vni 98
IP (tos 0x0, ttl 64, id 52620, offset 0, flags [DF], proto TCP (6), length 1450)
    5.5.5.5.34538 > 5.5.5.1.targus-getdata1: Flags [.], cksum 0xe1b9 (correct), seq 1398:2796, ack 1, win 502, options [nop,nop,TS val 348935282 ecr 1092415267], length 1398


3. Traffic gets to tunnel device, where it gets decapsulated and
redirected to destination VF by TC rule on vxlan_sys_4789:

$ sudo tcpdump -ni vxlan_sys_4789 -vvv -c 3
dropped privs to tcpdump
tcpdump: listening on vxlan_sys_4789, link-type EN10MB (Ethernet), capture size 262144 bytes
21:07:39.836141 IP (tos 0x0, ttl 64, id 15565, offset 0, flags [DF], proto TCP (6), length 52)
    5.5.5.1.targus-getdata1 > 5.5.5.5.34538: Flags [.], cksum 0xbe91 (correct), seq 2194968387, ack 4279285947, win 24576, options [nop,nop,TS val 1092653536 ecr 349173547], length 0
21:07:39.836202 IP (tos 0x0, ttl 64, id 50774, offset 0, flags [DF], proto TCP (6), length 64360)
    5.5.5.5.34538 > 5.5.5.1.targus-getdata1: Flags [P.], cksum 0x0f6b (incorrect -> 0x1d69), seq 746533:810841, ack 0, win 502, options [nop,nop,TS val 349173550 ecr 1092653536], length 64308
21:07:39.836449 IP (tos 0x0, ttl 64, id 15566, offset 0, flags [DF], proto TCP (6), length 52)
    5.5.5.1.targus-getdata1 > 5.5.5.5.34538: Flags [.], cksum 0x610f (correct), seq 0, ack 89473, win 24576, options [nop,nop,TS val 1092653536 ecr 349173548], length 0


4. Decapsulated payload appears on namespaced VF with IP address
5.5.5.5:

$ sudo ip  netns exec ns0 tcpdump -ni enp8s0f0v1 -vvv -c 3
yp_bind_client_create_v3: RPC: Unable to send
dropped privs to tcpdump
tcpdump: listening on enp8s0f0v1, link-type EN10MB (Ethernet), capture size 262144 bytes
21:09:06.758107 IP (tos 0x0, ttl 64, id 27527, offset 0, flags [DF], proto TCP (6), length 32206)
    5.5.5.5.34538 > 5.5.5.1.targus-getdata1: Flags [P.], cksum 0x91d0 (incorrect -> 0x2a2a), seq 1198920825:1198952979, ack 2194968387, win 502, options [nop,nop,TS val 349260472 ecr 1092740448], length 32154
21:09:06.758697 IP (tos 0x0, ttl 64, id 3008, offset 0, flags [DF], proto TCP (6), length 64)
    5.5.5.1.targus-getdata1 > 5.5.5.5.34538: Flags [.], cksum 0x6a1a (correct), seq 1, ack 4294942132, win 24576, options [nop,nop,TS val 1092740458 ecr 349260463,nop,nop,sack 1 {0:32154}], length 0
21:09:06.758748 IP (tos 0x0, ttl 64, id 27550, offset 0, flags [DF], proto TCP (6), length 25216)
    5.5.5.5.34538 > 5.5.5.1.targus-getdata1: Flags [P.], cksum 0x7682 (incorrect -> 0x7627), seq 4294942132:0, ack 1, win 502, options [nop,nop,TS val 349260473 ecr 1092740458], length 25164


As you can see from the dump Tx is symmetrical. And that is exactly the
behavior we are reproducing with offloads. So I guess correct diagram
would be:

        PHY port
           |
device     |             ,(vxlan)
-----------|------------|-------|----------
kernel     |            |       |
        (UL/PF)       (VFr)    (VF)
           |            |       |
        [TC ing]>redir -`       V

Regards,
Vlad
