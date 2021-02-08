Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3DE312B95
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 09:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbhBHIWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 03:22:08 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:15680 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhBHIWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 03:22:07 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6020f4860000>; Mon, 08 Feb 2021 00:21:26 -0800
Received: from reg-r-vrt-018-180.nvidia.com (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Mon, 8 Feb 2021 08:21:24 +0000
References: <20210206050240.48410-1-saeed@kernel.org>
 <20210206050240.48410-2-saeed@kernel.org>
 <20210206181335.GA2959@horizon.localdomain>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Saeed Mahameed <saeed@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Mark Bloch" <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next V2 01/17] net/mlx5: E-Switch, Refactor setting source
 port
In-Reply-To: <20210206181335.GA2959@horizon.localdomain>
Date:   Mon, 8 Feb 2021 10:21:21 +0200
Message-ID: <ygnhtuqngebi.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612772486; bh=EOpHsumEErWGX2HEoZxLj3kocUmdX7pbA96L+FoucXk=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=GD/3/mIw1Fm906ZiE6/tNl1gbac/puXSSkTCzEtlhMRjxFJ27DAhyFvTMj6M7iT5I
         SGRqlncxtUEbbiAPw0kDfu9em0Yi5IqHMqwytSX4i/ZIyY2GyBnVVyAWGOptTkALuT
         /SRwnOztypqOLm3hbdfmlw/lr8wSGzeKgWmH0RPw96c0MJzrMrpT8VnZ7Oo7asTsuL
         emJlvWI6ntsF/a1vnca28RaP1kt98fclwwbA8sTaaz/o3609VvGRUjmqBULyYRSl9u
         DhHK4tlLNSFubua2f3G+ZLowd1m3dUtyqNgqOWpJMF8QbtDoJhltc89Sy940jY96H3
         z5FK5jTgBKXJg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Sat 06 Feb 2021 at 20:13, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> Hi,
>
> I didn't receive the cover letter, so I'm replying on this one. :-)
>
> This is nice. One thing is not clear to me yet. From the samples on
> the cover letter:
>
> $ tc -s filter show dev enp8s0f0_1 ingress
> filter protocol ip pref 4 flower chain 0
> filter protocol ip pref 4 flower chain 0 handle 0x1
>   dst_mac 0a:40:bd:30:89:99
>   src_mac ca:2e:a7:3f:f5:0f
>   eth_type ipv4
>   ip_tos 0/0x3
>   ip_flags nofrag
>   in_hw in_hw_count 1
>         action order 1: tunnel_key  set
>         src_ip 7.7.7.5
>         dst_ip 7.7.7.1
>         ...
>
> $ tc -s filter show dev vxlan_sys_4789 ingress
> filter protocol ip pref 4 flower chain 0
> filter protocol ip pref 4 flower chain 0 handle 0x1
>   dst_mac ca:2e:a7:3f:f5:0f
>   src_mac 0a:40:bd:30:89:99
>   eth_type ipv4
>   enc_dst_ip 7.7.7.5
>   enc_src_ip 7.7.7.1
>   enc_key_id 98
>   enc_dst_port 4789
>   enc_tos 0
>   ...
>
> These operations imply that 7.7.7.5 is configured on some interface on
> the host. Most likely the VF representor itself, as that aids with ARP
> resolution. Is that so?
>
> Thanks,
> Marcelo

Hi Marcelo,

The tunnel endpoint IP address is configured on VF that is represented
by enp8s0f0_0 representor in example rules. The VF is on host.

Regards,
Vlad

