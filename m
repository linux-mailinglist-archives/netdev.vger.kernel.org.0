Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A82E23BB7A
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 15:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbgHDNyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 09:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728523AbgHDNyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 09:54:39 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1382C061756
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 06:54:39 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id 25so12809603oir.0
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 06:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WPFgLpgYL7yMuND45g8DnZJ+IemPso1f0aKeQwzoDJk=;
        b=HILmeSDxPWSWARyrCzdOz1oMfV8N1075Jk6j8HZWkuCJj79dQO2e/2f0xHb+S9PQ95
         xON3Y5fnr9hXdVpn+SXcqasUDuVsf8iqZWHEMIqtfUlfOsncRqv8RJVaBFcmBoG1OVHL
         2BxTThpfqzs/6malnvXmZWpAwvTGuRlBwgDTKdemKCVe7Y9F2gxsckAe0Zos6SSWP1oA
         cgBAtWhDpJPeQpM5+kPbq7Hh91OPctK0Lr3gWoJYFAepCW1u8dAoonQwuYy1bi9tx5iU
         qspwFu2slKbh7HWBqDjTPpMj6aWjYlDFL1WAQ0kHAnLLrtXIEL6sTyic5HcLJQICyWo9
         9UBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WPFgLpgYL7yMuND45g8DnZJ+IemPso1f0aKeQwzoDJk=;
        b=EKuqDr0XXkUPJtqdM0Q8RegCdluNtrtR/CP9Kmjfka2i9tovLOz1W0UJ2YUYQYheWI
         5FvSipcFEVCLwXHy3IoIg4nEtewMaMsm54e5frxjV0leE3d2CyeCh8h7PbiQT/r55grx
         FDl3HczErG7iDvyj148IThnRGjeHbym2rUSHbknRngGwRrXhvOSCwcuGWXh62iIWA18X
         s4LmdEKhPrte9BN01KBz6Ri48Ws5UWAmcDLWk7LoIDF4M9zlx/v9fSms215iYCJUthne
         iQ3nhHF/XPhs+evx4mm20yHEPsd9214K1NIcwjuYzq3uYpewPsK23/hwIVb0P2Uj7CzN
         +2vg==
X-Gm-Message-State: AOAM5301SBckO/zYqNGoR36R07u1VvtGaDaxXB/QmFP5QTbMFEU9w27X
        5YBbbO19ZkUkYF4Um3hfnDmUu2PR
X-Google-Smtp-Source: ABdhPJxsJ9spmiendvp743Q2MPy1gDN1u6gdvEDWvlhp3ableH/fRDSAD0wmQXGU/oOo44Jf9CDkoQ==
X-Received: by 2002:aca:edc8:: with SMTP id l191mr3253656oih.104.1596549278885;
        Tue, 04 Aug 2020 06:54:38 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:14ac:dc81:c028:3eca])
        by smtp.googlemail.com with ESMTPSA id m205sm3551412oig.34.2020.08.04.06.54.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 06:54:38 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/6] tunnels: PMTU discovery support for
 directly bridged IP packets
To:     Stefano Brivio <sbrivio@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Westphal <fw@strlen.de>, Aaron Conole <aconole@redhat.com>,
        Numan Siddique <nusiddiq@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Lourdes Pedrajas <lu@pplo.net>, netdev@vger.kernel.org
References: <cover.1596520062.git.sbrivio@redhat.com>
 <83e5876f589b0071638630dd93fbe0fa6b1b257c.1596520062.git.sbrivio@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <437077cc-8c3c-79de-3475-6c717001d8ae@gmail.com>
Date:   Tue, 4 Aug 2020 07:54:37 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <83e5876f589b0071638630dd93fbe0fa6b1b257c.1596520062.git.sbrivio@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/20 11:53 PM, Stefano Brivio wrote:
> It's currently possible to bridge Ethernet tunnels carrying IP
> packets directly to external interfaces without assigning them
> addresses and routes on the bridged network itself: this is the case
> for UDP tunnels bridged with a standard bridge or by Open vSwitch.
> 
> PMTU discovery is currently broken with those configurations, because
> the encapsulation effectively decreases the MTU of the link, and
> while we are able to account for this using PMTU discovery on the
> lower layer, we don't have a way to relay ICMP or ICMPv6 messages
> needed by the sender, because we don't have valid routes to it.
> 
> On the other hand, as a tunnel endpoint, we can't fragment packets
> as a general approach: this is for instance clearly forbidden for
> VXLAN by RFC 7348, section 4.3:
> 
>    VTEPs MUST NOT fragment VXLAN packets.  Intermediate routers may
>    fragment encapsulated VXLAN packets due to the larger frame size.
>    The destination VTEP MAY silently discard such VXLAN fragments.
> 
> The same paragraph recommends that the MTU over the physical network
> accomodates for encapsulations, but this isn't a practical option for
> complex topologies, especially for typical Open vSwitch use cases.
> 
> Further, it states that:
> 
>    Other techniques like Path MTU discovery (see [RFC1191] and
>    [RFC1981]) MAY be used to address this requirement as well.
> 
> Now, PMTU discovery already works for routed interfaces, we get
> route exceptions created by the encapsulation device as they receive
> ICMP Fragmentation Needed and ICMPv6 Packet Too Big messages, and
> we already rebuild those messages with the appropriate MTU and route
> them back to the sender.
> 
> Add the missing bits for bridged cases:
> 
> - checks in skb_tunnel_check_pmtu() to understand if it's appropriate
>   to trigger a reply according to RFC 1122 section 3.2.2 for ICMP and
>   RFC 4443 section 2.4 for ICMPv6. This function is already called by
>   UDP tunnels
> 
> - a new function generating those ICMP or ICMPv6 replies. We can't
>   reuse icmp_send() and icmp6_send() as we don't see the sender as a
>   valid destination. This doesn't need to be generic, as we don't
>   cover any other type of ICMP errors given that we only provide an
>   encapsulation function to the sender
> 
> While at it, make the MTU check in skb_tunnel_check_pmtu() accurate:
> we might receive GSO buffers here, and the passed headroom already
> includes the inner MAC length, so we don't have to account for it
> a second time (that would imply three MAC headers on the wire, but
> there are just two).
> 
> This issue became visible while bridging IPv6 packets with 4500 bytes
> of payload over GENEVE using IPv4 with a PMTU of 4000. Given the 50
> bytes of encapsulation headroom, we would advertise MTU as 3950, and
> we would reject fragmented IPv6 datagrams of 3958 bytes size on the
> wire. We're exclusively dealing with network MTU here, though, so we
> could get Ethernet frames up to 3964 octets in that case.
> 
> v2:
> - moved skb_tunnel_check_pmtu() to ip_tunnel_core.c (David Ahern)
> - split IPv4/IPv6 functions (David Ahern)
> 
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---
>  drivers/net/bareudp.c     |   5 +-
>  drivers/net/geneve.c      |   5 +-
>  drivers/net/vxlan.c       |   4 +-
>  include/net/dst.h         |  10 --
>  include/net/ip_tunnels.h  |   2 +
>  net/ipv4/ip_tunnel_core.c | 244 ++++++++++++++++++++++++++++++++++++++
>  6 files changed, 254 insertions(+), 16 deletions(-)
> 

Much easier to follow

Reviewed-by: David Ahern <dsahern@gmail.com>


