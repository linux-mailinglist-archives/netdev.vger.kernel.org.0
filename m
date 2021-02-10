Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F94316B9C
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 17:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbhBJQrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 11:47:18 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:3654 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233206AbhBJQp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 11:45:59 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60240d950000>; Wed, 10 Feb 2021 08:45:09 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 16:45:08 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.145.6) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Wed, 10 Feb 2021 16:45:06 +0000
References: <20210206050240.48410-1-saeed@kernel.org>
 <20210206050240.48410-2-saeed@kernel.org>
 <20210206181335.GA2959@horizon.localdomain> <ygnhtuqngebi.fsf@nvidia.com>
 <20210208122213.338a673e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ygnho8gtgw2l.fsf@nvidia.com>
 <CAJ3xEMhjo6cYpW-A-0RXKVM52jPCzer_K0WOR64C7HMK8tuRew@mail.gmail.com>
 <20210210135605.GD2859@horizon.localdomain>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Or Gerlitz <gerlitz.or@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Saeed Mahameed" <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Linux Netdev List" <netdev@vger.kernel.org>,
        Mark Bloch <mbloch@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: Re: [net-next V2 01/17] net/mlx5: E-Switch, Refactor setting source
 port
In-Reply-To: <20210210135605.GD2859@horizon.localdomain>
Date:   Wed, 10 Feb 2021 18:44:42 +0200
Message-ID: <ygnh1rdnhnyd.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612975509; bh=67oA51NksjoFtinItwB1KHkZjMqIEx+LKH9fkHLH2SQ=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=Sg5TSog/VqQQ0upN306eVQ+ymIBSoYgVLhd5bfyIDDLlJyR2+YygpuAQCxTAb2bMS
         Prov9Eqy2gNpzypqUgRQCOihhI1VaViaxZA5A4CuY+8OgFqGYH5sa9CpY7m08xdVnz
         wnYs6u/SKQdhidLjHEUWW9DbkfO1j0I8Y9mmEl07C51DG7zJNUme9DTulaiHvWNwWj
         adA51NwRsrS/HetbiVDd+TjISjxcMbyJyOKVSdpMdOb2mrqrpBkODGkI+YJq64ELTU
         MKPlRlaWn4d8Q5b4xcwFvG+9rUdeIN2plIkshh2+1Zc9TzMK/rzKLjYIh9wWRgld1t
         Qv2W4RiK5Fx8w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed 10 Feb 2021 at 15:56, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> On Tue, Feb 09, 2021 at 06:10:59PM +0200, Or Gerlitz wrote:
>> On Tue, Feb 9, 2021 at 4:26 PM Vlad Buslov <vladbu@nvidia.com> wrote:
>> > On Mon 08 Feb 2021 at 22:22, Jakub Kicinski <kuba@kernel.org> wrote:
>> > > On Mon, 8 Feb 2021 10:21:21 +0200 Vlad Buslov wrote:
>> 
>> > >> > These operations imply that 7.7.7.5 is configured on some interface on
>> > >> > the host. Most likely the VF representor itself, as that aids with ARP
>> > >> > resolution. Is that so?
>> 
>> > >> The tunnel endpoint IP address is configured on VF that is represented
>> > >> by enp8s0f0_0 representor in example rules. The VF is on host.
>> 
>> > > This is very confusing, are you saying that the 7.7.7.5 is configured
>> > > both on VF and VFrep? Could you provide a full picture of the config
>> > > with IP addresses and routing?
>> 
>> > No, tunnel IP is configured on VF. That particular VF is in host [..]
>> 
>> What's the motivation for that? isn't that introducing 3x slow down?
>
> Vlad please correct me if I'm wrong.
>
> I think this boils down to not using the uplink representor as a real
> interface. This way, the host can make use of 7.7.7.5 for other stuff
> as well without passing (heavy) traffic through representor ports,
> which are not meant for it.
>
> So the host can have the IP 7.7.7.5 and also decapsulate vxlan traffic
> on it, which wouldn't be possible/recommended otherwise.
>
> Another moment that this gets visible is with VF LAG. When we bond the
> uplink representors, add an IP to it and do vxlan decap, that IP is
> meant only for the decap process and shouldn't be used for heavier
> traffic as its passing through representor ports.
>
> Then, tc config for decap need to be done on VF0rep and not on VF0
> itself because that would be a security problem: one VF (which could
> be on a netns) could steer packets to another VF at will.

While on-host VF (the one with IP 7.7.7.5 in my examples) is intended to
be used for unencapsulated control traffic as well, we don't expect
significant bandwidth of such traffic, so traffic-load on representor
wasn't the main motivation. I didn't want to go into the details in
cover letter because they are mostly OVS-specific and this series is a
groundwork for features to come.

So the main motivation is to be able to apply policy on both on underlay
network (UL) and overlay network (tunnel netdev). As that will allow us
to subject overlay and underlay traffic to different set of OVS rules,
for example underlay traffic may be subject to vlan encap/decap,
security policy or any other flow rule that the user may define.

Hope this also answers some of Or's questions from this thread.
