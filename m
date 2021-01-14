Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19C02F6D24
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 22:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbhANVX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 16:23:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:47938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726123AbhANVX5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 16:23:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D450622DFA;
        Thu, 14 Jan 2021 21:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610659396;
        bh=J/aHoyoF4gk742GnjC+IHIsC05inBGzfoIzUewtb5eM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nyZv4R5EA0wzueGWWrToa/OKwIFT0kIhhX69EK0mBfnOnL1A/HOUKsfbZnWjQOr2I
         LEW89Re0OXmI/y7MPpVXLD16+fQaqvQ2dGi0wDws2ude3EIjJv8W+tbCFWllgtfNdR
         K/yDWga3yJpCa0s9bmB9OYd6lItvy48ONosMHuEMyy6r5Y1dTnztrcM5Kf23VQI0kN
         D+Svii8ujuZfLioTaVKYafCtvn/f1/GAOBoIxkIwUSjposhlaZrMh/R0lK8s9SqIGF
         LG0DyLhmss6MIoWEYWcyQyjNh1WbdZJvpEGLjwzdgPlGiXDYAMxdaT5TGlmqD/QjQw
         YM0Hrcm0FfYlw==
Date:   Thu, 14 Jan 2021 13:23:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jarod Wilson <jarod@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] bonding: add a vlan+mac tx hashing option
Message-ID: <20210114132314.2c484e9f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210114211141.GH1171031@redhat.com>
References: <20201218193033.6138-1-jarod@redhat.com>
        <20210113223548.1171655-1-jarod@redhat.com>
        <20210113175818.7dce3076@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210114211141.GH1171031@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 16:11:41 -0500 Jarod Wilson wrote:
> In truth, this code started out as a copy of bond_eth_hash(), which also
> only uses the last byte, though of both source and destination macs. In
> the typical use case for the requesting user, the bond is formed from two
> onboard NICs, which typically have adjacent mac addresses, i.e.,
> AA:BB:CC:DD:EE:01 and AA:BB:CC:DD:EE:02, so only the last byte is really
> relevant to hash differently, but in thinking about it, a replacement NIC
> because an onboard one died could have the same last byte, and maybe we
> ought to just go full source mac right off the go here.
> 
> Something like this instead maybe:
> 
> static u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
> {
>         struct ethhdr *mac_hdr = (struct ethhdr *)skb_mac_header(skb);
>         u32 srcmac = 0;
>         u16 vlan;
>         int i;
> 
>         for (i = 0; i < ETH_ALEN; i++)
>                 srcmac = (srcmac << 8) | mac_hdr->h_source[i];
> 
>         if (!skb_vlan_tag_present(skb))
>                 return srcmac;
> 
>         vlan = skb_vlan_tag_get(skb);
> 
>         return vlan ^ srcmac;
> }
> 
> Then the documentation is spot-on, and we're future-proof, though
> marginally less performant in calculating the hash, which may have been a
> consideration when the original function was written, but is probably
> basically irrelevant w/modern systems...

No preference, especially if bond_eth_hash() already uses the last byte.
Just make sure the choice is explained in the commit message.
