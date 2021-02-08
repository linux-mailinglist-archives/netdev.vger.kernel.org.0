Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD04131335C
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 14:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhBHNcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 08:32:53 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:19854 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbhBHNcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 08:32:36 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60213d4b0001>; Mon, 08 Feb 2021 05:31:55 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb
 2021 13:31:55 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.145.6) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Mon, 8 Feb 2021 13:31:53 +0000
References: <20210206050240.48410-1-saeed@kernel.org>
 <20210206050240.48410-2-saeed@kernel.org>
 <20210206181335.GA2959@horizon.localdomain> <ygnhtuqngebi.fsf@nvidia.com>
 <20210208132557.GB2959@horizon.localdomain>
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
In-Reply-To: <20210208132557.GB2959@horizon.localdomain>
Date:   Mon, 8 Feb 2021 15:31:50 +0200
Message-ID: <ygnhr1lqheih.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612791115; bh=OSNO/yf6WcrNTd3J2D+RFd0zQq7WDaykRmnL5MNouN0=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=KeAq47FxcWDBaEoTQPBDWvlGk8wnXau2mHv/I4hT8Ilt3V/WP9Py9v44s7wxrfSy2
         ouGPwZSz7jq1/GxL64BKTpXOBD52CGQhMPFvchEVa9MQ7C/spxd6kVNfKXozxIPsNl
         3ed8dXekNxuDfWlVZtTl8xjzTSUEjEru3YI+Cv7+cIOC9+GGmwKPSTk8/oEV0/QBA0
         haHZGGPTR12tyZ1WxSYuwPgcQjlpIH9x+jbGAUyUnrG88Ih+2SicE3tPRnUkFSjyqQ
         TIxZ5aMCbbRH0z1rVrm4HR5yce1srEzP8C57PYci0oLwV2IvJQemDrwQ2eTb+EbFv0
         pV/9H2mvR+Tww==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon 08 Feb 2021 at 15:25, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> On Mon, Feb 08, 2021 at 10:21:21AM +0200, Vlad Buslov wrote:
>> 
>> On Sat 06 Feb 2021 at 20:13, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
>> > Hi,
>> >
>> > I didn't receive the cover letter, so I'm replying on this one. :-)
>> >
>> > This is nice. One thing is not clear to me yet. From the samples on
>> > the cover letter:
>> >
>> > $ tc -s filter show dev enp8s0f0_1 ingress
>> > filter protocol ip pref 4 flower chain 0
>> > filter protocol ip pref 4 flower chain 0 handle 0x1
>> >   dst_mac 0a:40:bd:30:89:99
>> >   src_mac ca:2e:a7:3f:f5:0f
>> >   eth_type ipv4
>> >   ip_tos 0/0x3
>> >   ip_flags nofrag
>> >   in_hw in_hw_count 1
>> >         action order 1: tunnel_key  set
>> >         src_ip 7.7.7.5
>> >         dst_ip 7.7.7.1
>> >         ...
>> >
>> > $ tc -s filter show dev vxlan_sys_4789 ingress
>> > filter protocol ip pref 4 flower chain 0
>> > filter protocol ip pref 4 flower chain 0 handle 0x1
>> >   dst_mac ca:2e:a7:3f:f5:0f
>> >   src_mac 0a:40:bd:30:89:99
>> >   eth_type ipv4
>> >   enc_dst_ip 7.7.7.5
>> >   enc_src_ip 7.7.7.1
>> >   enc_key_id 98
>> >   enc_dst_port 4789
>> >   enc_tos 0
>> >   ...
>> >
>> > These operations imply that 7.7.7.5 is configured on some interface on
>> > the host. Most likely the VF representor itself, as that aids with ARP
>> > resolution. Is that so?
>> >
>> > Thanks,
>> > Marcelo
>> 
>> Hi Marcelo,
>> 
>> The tunnel endpoint IP address is configured on VF that is represented
>> by enp8s0f0_0 representor in example rules. The VF is on host.
>
> That's interesting and odd. The VF would be isolated by a netns and
> not be visible by whoever is administrating the VF representor. Some
> cooperation between the two entities (host and container, say) is
> needed then, right? Because the host needs to know the endpoint IP
> address that the container will be using, and vice-versa. If so, why
> not offload the tunnel actions via the VF itself and avoid this need
> for cooperation? Container privileges maybe?
>
> Thx,
> Marcelo

As I wrote in previous email, tunnel endpoint VF is on host (not in
namespace/container, VM, etc.).

