Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18483316BD2
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 17:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbhBJQzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 11:55:01 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13219 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233284AbhBJQwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 11:52:40 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60240f2d0003>; Wed, 10 Feb 2021 08:51:57 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 16:51:57 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.145.6) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Wed, 10 Feb 2021 16:51:55 +0000
References: <20210206050240.48410-1-saeed@kernel.org>
 <CAJ3xEMhPU=hr-wNN+g8Yq4rMqFQQGybQnn86mmbXrTTN6Xb8xw@mail.gmail.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Or Gerlitz <gerlitz.or@gmail.com>
CC:     Saeed Mahameed <saeed@kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [pull request][net-next V2 00/17] mlx5 updates 2021-02-04
In-Reply-To: <CAJ3xEMhPU=hr-wNN+g8Yq4rMqFQQGybQnn86mmbXrTTN6Xb8xw@mail.gmail.com>
Date:   Wed, 10 Feb 2021 18:51:53 +0200
Message-ID: <ygnhy2fvg91y.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612975917; bh=X3akhWrU5noARCF7Lt4aeKRl+xjPBPu13DgRt/Ls0hY=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=E6xJA1CXdPLarbXHuk+EYZM6bPmCw3OLVVkdMAq//bupggt6SKdG5gsKWPwJ/ml96
         WYfrSVBol87SxhvquO4fkmf87OQAbqQIBH0I4JJ7srcrQ0K5SKGj1d79J6beHIDQNp
         DsZUyR44cMrNn6CUq/DGSS8uz/OwIS8OODMbU5ek8vjPaLz93MER/yo/Pl53Rl2vnW
         i6KZ1sAjidTH00gEPM+N/GGS2uoyhQ1fQ8zAPI2Fb38dxcbuSSrs424UEVznnAynTO
         RqIjte1SGxfrmMloVIcPj0F24v2dfUEA+SEgZ7zVv4T7DRN7hGghYMy7LRSxrf4ccj
         6JjCGtUIapnRQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 09 Feb 2021 at 10:42, Or Gerlitz <gerlitz.or@gmail.com> wrote:
> On Sat, Feb 6, 2021 at 7:10 AM Saeed Mahameed <saeed@kernel.org> wrote:
>
>> Vlad Buslov says:
>
>> Implement support for VF tunneling
>
>> Currently, mlx5 only supports configuration with tunnel endpoint IP address on
>> uplink representor. Remove implicit and explicit assumptions of tunnel always
>> being terminated on uplink and implement necessary infrastructure for
>> configuring tunnels on VF representors and updating rules on such tunnels
>> according to routing changes.
>
>> SW TC model
>
> maybe before SW TC model, you can explain the vswitch SW model (TC is
> a vehicle to implement the SW model).
>
> SW model for VST and "classic" v-switch tunnel setup:
>
> For example, in VST model, each virtio/vf/sf vport has a vlan
> such that the v-switch tags packets going out "south" of the
> vport towards the uplink, untags packets going "north" from
> the uplink, matches on the vport tag and forwards them to
> the vport (and does nothing for east-west traffic).
>
> In a similar manner, in "classic" v-switch tunnel setup, each
> virtio/vf/sf vport is somehow associated with VNI/s marking the
> tenant/s it belongs to. Same tenant east-west traffic on the
> host doesn't go through any encap/decap. The v-switch adds the
> relevant tunnel MD to packets/skbs sent "southward" by the end-point
> and forwards it to the VTEP which applies encap based on the MD (LWT
> scheme) and sends the packets to the wire. On RX, the VTEP decaps
> the tunnel info from the packet, adds it as MD to the skb and
> forwards the packet up into the stack where the vsw hooks it, matches
> on the MD + inner tuple and then forwards it to the relevant endpoint.

Moving tunnel endpoint to VF doesn't change anything in this
high-level description.

>
> HW offloads for VST and "classic" v-switch tunnel setup:
>
> more or less straight forward based on the above
>
>> From TC perspective VF tunnel configuration requires two rules in both
>> directions:
>
>> TX rules
>> 1. Rule that redirects packets from UL to VF rep that has the tunnel
>> endpoint IP address:
>> 2. Rule that decapsulates the tunneled flow and redirects to destination VF
>> representor:
>
>> RX rules
>> 1. Rule that encapsulates the tunneled flow and redirects packets from
>> source VF rep to tunnel device:
>> 2. Rule that redirects from tunnel device to UL rep:
>
> mmm it's kinda hard managing to follow and catch up a SW model from TC rules..
>
> I think we need these two to begin with (in whatever order that works
> better for you)
>
> [1] Motivation for enhanced v-switch tunnel setup:
>
> [2] SW model for enhanced v-switch tunnel setup:
>
>> HW offloads model
>
> a clear SW model before HW offloads model..

Hope my replies to Jakub and Marcelo also address these.

>
>>  25 files changed, 3812 insertions(+), 1057 deletions(-)
>
> for adding almost 4K LOCs

