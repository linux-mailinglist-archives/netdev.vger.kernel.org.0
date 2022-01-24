Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00226499C19
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 23:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1577273AbiAXV7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 16:59:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58842 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1458079AbiAXVmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 16:42:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B5C161469
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 21:42:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87806C340E5;
        Mon, 24 Jan 2022 21:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643060564;
        bh=FjaU6aqB9SwDetQn47A2eob1aBZMLTumb9NkGNqHtgs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G/LHi5Pa1G51SMYwWJxu1PpDsvHVVLwZ9ymsgbkYuaFz0HF/eLLQBytm3yZLY4z7Z
         xncXOX3pCnsv/ybulMqL9mPTuqNh0IAT1wcczSe30MMRInWMFgKWw//YTpS0itv/i3
         Jk6r/a059Ukya7dVkmRW/6p9akI99XZpUudoADoIH2mF3JmahdnOiIUnztFoAwDmyc
         gO+TofpeVIWdf0oBRksnD2AVIKFGkNZEMN9ke7AqtQqE0I3fBpHHFJWk05JggunAJD
         Clx+swu1PLnSNboo9cOq12fA0oof5EaHpSIDmQKgVWPlNZPtlp4Lb19ODuon3ojIbs
         IgSlX3lbAMDZA==
Date:   Mon, 24 Jan 2022 13:42:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb:
 multiple cpu ports, non cpu extint
Message-ID: <20220124134242.595fd728@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220124205607.kugsccikzgmbdgmf@skbuf>
References: <CAJq09z6aYKhjdXm_hpaKm1ZOXNopP5oD5MvwEmgRwwfZiR+7vg@mail.gmail.com>
        <20220124153147.agpxxune53crfawy@skbuf>
        <20220124084649.0918ba5c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20220124165535.tksp4aayeaww7mbf@skbuf>
        <228b64d7-d3d4-c557-dba9-00f7c094f496@gmail.com>
        <20220124172158.tkbfstpwg2zp5kaq@skbuf>
        <20220124093556.50fe39a3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20220124102051.7c40e015@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20220124190845.md3m2wzu7jx4xtpr@skbuf>
        <20220124113812.5b75eaab@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20220124205607.kugsccikzgmbdgmf@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 22:56:07 +0200 Vladimir Oltean wrote:
> On Mon, Jan 24, 2022 at 11:38:12AM -0800, Jakub Kicinski wrote:
> > On Mon, 24 Jan 2022 21:08:45 +0200 Vladimir Oltean wrote:  
> > > So before we declare that any given Ethernet driver is buggy for declaring
> > > NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM and not checking that skb->csum_start
> > > points where it expects it to (taking into consideration potential VLAN
> > > headers, IPv6 extension headers),  
> >
> > Extension headers are explicitly not supported by NETIF_F_IPV6_CSUM.
> >
> > IIRC Tom's hope was to delete NETIF_F_IP*_CSUM completely once all
> > drivers are converted to parsing and therefore can use NETIF_F_HW_CSUM.  
> 
> IIUC, NETIF_F_IP*_CSUM vs NETIF_F_HW_CSUM doesn't make that big of a
> difference in terms of what the driver should check for, if the hardware
> checksum offload engine can't directly be given the csum_start and
> csum_offset, wherever they may be.
> 
> > > is there any driver that _does_ perform these checks correctly, that
> > > could be used as an example?  
> >
> > I don't think so. Let me put it this way - my understanding is that up
> > until now we had been using the vlan_features, mpls_features etc to
> > perform L2/L2.5/below-IP feature stripping. This scales poorly to DSA
> > tags, as discussed in this thread.
> >
> > I'm suggesting we extend the kind of checking we already do to work
> > around inevitable deficiencies of device parsers for tunnels to DSA
> > tags.  
> 
> Sorry, I'm very tired and I probably don't understand what you're
> saying, so excuse the extra clarification questions.
> 
> The typical protocol checking that drivers with NETIF_F_HW_CSUM do seems
> to be based on vlan_get_protocol()/skb->protocol/skb_network_header()/
> skb_transport_header() values, all of which make DSA invisible. So they
> don't work if the underlying hardware really doesn't like seeing an
> unexpected DSA header.
> 
> When you say "I'm suggesting we extend the kind of checking we already do",
> do you mean we should modify the likes of e1000e and igb such that, if
> they're ever used as DSA masters, they do a full header parse of the
> packet (struct ethhdr :: h_proto, check if VLAN, struct iphdr/ipv6hdr,
> etc.) instead of the current logic?

That was my thinking, yes. The exact amount of work depends on the
driver, I believe that more recent Intel parts (igb, ixgbe and newer)
pass a L3 offset to the HW. They treat L2 as opaque, ergo no patches
needed. At a glance e1000e passes the full skb_checksum_start_offset()
to HW, so likely even better. 

It's only drivers for devices which actually want to parse the Ethertype
that would need extra checks. (Coincidentally such devices can't support
MPLS given the lack of L3 indication in the frame.)

> It will be pretty convoluted unless
> we have some helper. Because if I follow through, for a DSA-tagged IP
> packet on xmit, skb->protocol is certainly htons(ETH_P_IP):
> 
> ntohs(skb->protocol) = 0x800, csum_offset = 16, csum_start = 280, skb_checksum_start_offset = 54, skb->network_header = 260, skb_network_header_len = 20
> 
> skb_dump output:
> skb len=94 headroom=226 headlen=94 tailroom=384
> mac=(226,34) net=(260,20) trans=280
> shinfo(txflags=0 nr_frags=0 gso(size=0 type=1 segs=1))
> csum(0x100118 ip_summed=3 complete_sw=0 valid=0 level=0)
> hash(0x7710ee84 sw=0 l4=1) proto=0x0800 pkttype=0 iif=0
> dev name=eno2 feat=0x00020100001149a9
> sk family=2 type=1 proto=6
> skb headroom: 00000000: 6c 00 03 02 64 65 76 00 fe ed ca fe 28 00 00 00
> ...(junk)...
> skb headroom: 000000e0: 5f 43
>                         20 byte DSA tag
>                         |
>                         v
> skb linear:   00000000: 88 80 00 0a 80 00 00 00 00 00 00 00 08 00 30 00
>                                     skb_mac_header()
>                                     |
>                                     v
> skb linear:   00000010: 00 00 00 00 68 05 ca 92 af 20 00 04 9f 05 f6 28
>                               skb_network_header()
>                               |
>                               v
> skb linear:   00000020: 08 00 45 00 00 3c 26 47 40 00 40 06 00 49 0a 00
>                                           skb_checksum_start_offset
>                                           |
>                                           |                       csum_offset
>                                           v                       v
> skb linear:   00000030: 00 2c 0a 00 00 01 b6 08 14 51 11 1f 91 4f 00 00
> skb linear:   00000040: 00 00 a0 02 fa f0 14 5b 00 00 02 04 05 b4 04 02
> skb linear:   00000050: 08 0a 2e 00 e5 b8 00 00 00 00 01 03 03 07

Oof, so in this case the DSA tag is _before_ the skb_mac_header()?
Or the prepend is supposed to be parsable as a Ethernet header?
Seems like any device that can do csum over this packet must already 
use L3/L4 offsets or have explicit knowledge of DSA, right?

> I don't know, I just don't expect that non-DSA users of those drivers
> will be very happy about such changes. Do these existing protocol
> checking schemes qualify as buggy?

Unfortunate reality of the checksum offloads is that most drivers for
devices which parse on Tx are buggy, it's more of a question of whether
anyone tried to use an unsupported protocol stack :( Recent example
that comes to mind is 1698d600b361 ("bnxt_en: Implement
.ndo_features_check().").

> If this is the convention that we want to enforce, then I can't really
> help Luiz with fixing the OpenWRT mtk_eth_soc.c - he'll have to figure
> out a way to parse the packets for which his hardware will accept the
> checksumming offload, and call skb_checksum_help() otherwise.
> 
> > We can come up with various schemes of expressing capabilities
> > between underlying driver and tag driver. I'm not aware of similar
> > out-of-band schemes existing today so it'd be "DSA doing it's own
> > thing", which does not seem great.  
> 
> It at least seems less complex to me, and less checking in the fast path
> if I understand everything that's been said correctly.

I understand, I'm primarily trying to share some context and prior work.
I don't mean to nack all other approaches.

I believe writing a parser matching the device behavior would be easier
for a driver author than interpreting the runes of our csum offload API
and getting thru the thicket of all the bits. If that's not the case my
argument is likely defeated.
