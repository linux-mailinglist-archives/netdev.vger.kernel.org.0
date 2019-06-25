Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC81559A6
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 23:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfFYVGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 17:06:05 -0400
Received: from mail-ed1-f51.google.com ([209.85.208.51]:35308 "EHLO
        mail-ed1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbfFYVGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 17:06:05 -0400
Received: by mail-ed1-f51.google.com with SMTP id w20so21601030edd.2
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 14:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=P9d9BlcZhISyrqbkQk6b2UJfzj1gIdmTrAr7ReqLMZI=;
        b=kmt5uciw+MgUdkbhdXbg5M+8PtaU70FqUXKbaVB8L6umbvKpQwcDMCXXdsW89b/5cm
         s4fAGzhjAWyssfGwxWV5dEhIJD6d21Ud1iAjhVkp45khTrzALHzONvPHb/VpmfQGLMqe
         oosWgohdDm4lfpki7HHhpvPMgVyZGP+Gov36sf5QbPcyb5m4CmagZWSFV76YoAUDURot
         Ci/yawDYQrC6s8/1GaAf3V1O5hgx7aav1WWxSwLtjqOjCFQ9S67MRdpDgS0/lAye5P7i
         mHKfVp3XU8xYeJNWmcSP2LTtZU2oHhgcoQXEqkVsKIOp7hUnxoFOdZw2qFi5G8J6+cGC
         TT/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=P9d9BlcZhISyrqbkQk6b2UJfzj1gIdmTrAr7ReqLMZI=;
        b=Bixhf5e016VK+cCbx6h3VQ+y1klPbGMTzhN/cH3riWGbnudN6MpBpCdYZ/wM8j+WTi
         0Jj5ns7M78ml7JQ/6vVJ1t4cy7kZPYp1pdKHNvc0wIPRqjbG4R1M1WEK84Jy0AVDvu6t
         a0ehAMmwvfGpXgue1Z7Tv87pOHpYO8vERPjTqHtgP1wtKUeTmCoKTicHGJxxsLWVlO4k
         fq/4AFWMn5oYQFf+KcuYGEnE0mtsDORNnQB503may/CUuKaNQbWqCXGTLdjppy6v8C3U
         vhuL6Z8glTgGhnZZWce+X2XLttFijBmfR/hgxzIKc2iGmm5Y/omlSH9wPPvz+cU95iwO
         xQCA==
X-Gm-Message-State: APjAAAXaA0kyIhV5txezIhaMQSm4qDWcpgeL8q1M4gE3ugl4wcCdBA5u
        WxMehDEUUeTivtMs6aEL9bs9ctr7Fh2DG3lkbbQnBNgPs00=
X-Google-Smtp-Source: APXvYqzNkFvYIf17DTCOy7wPCmBphru2C4rKMnuxCsc83WqOOATpT0CU3TCDYDqbJRFhfrGjtJqimB05bJrh4C0foCI=
X-Received: by 2002:a50:aa14:: with SMTP id o20mr610495edc.165.1561496763360;
 Tue, 25 Jun 2019 14:06:03 -0700 (PDT)
MIME-Version: 1.0
References: <CA+h21hrRMrLH-RjBGhEJSTZd6_QPRSd3RkVRQF-wNKkrgKcRSA@mail.gmail.com>
In-Reply-To: <CA+h21hrRMrLH-RjBGhEJSTZd6_QPRSd3RkVRQF-wNKkrgKcRSA@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 26 Jun 2019 00:05:52 +0300
Message-ID: <CA+h21hrpXbzAhT26JJt56MtxT4XfwWxWFs8KTw4kmM=OB+11uA@mail.gmail.com>
Subject: Re: What to do when a bridge port gets its pvid deleted?
To:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        stephen@networkplumber.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jun 2019 at 23:49, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Hi,
>
> A number of DSA drivers (BCM53XX, Microchip KSZ94XX, Mediatek MT7530
> at the very least), as well as Mellanox Spectrum (I didn't look at all
> the pure switchdev drivers) try to restore the pvid to a default value
> on .port_vlan_del.
> Sure, the port stops receiving traffic when its pvid is a VLAN ID that
> is not installed in its hw filter, but as far as the bridge core is
> concerned, this is to be expected:
>
> # bridge vlan add dev swp2 vid 100 pvid untagged
> # bridge vlan
> port    vlan ids
> swp5     1 PVID Egress Untagged
>
> swp2     1 Egress Untagged
>          100 PVID Egress Untagged
>
> swp3     1 PVID Egress Untagged
>
> swp4     1 PVID Egress Untagged
>
> br0      1 PVID Egress Untagged
> # ping 10.0.0.1
> PING 10.0.0.1 (10.0.0.1) 56(84) bytes of data.
> 64 bytes from 10.0.0.1: icmp_seq=1 ttl=64 time=0.682 ms
> 64 bytes from 10.0.0.1: icmp_seq=2 ttl=64 time=0.299 ms
> 64 bytes from 10.0.0.1: icmp_seq=3 ttl=64 time=0.251 ms
> 64 bytes from 10.0.0.1: icmp_seq=4 ttl=64 time=0.324 ms
> 64 bytes from 10.0.0.1: icmp_seq=5 ttl=64 time=0.257 ms
> ^C
> --- 10.0.0.1 ping statistics ---
> 5 packets transmitted, 5 received, 0% packet loss, time 4188ms
> rtt min/avg/max/mdev = 0.251/0.362/0.682/0.163 ms
> # bridge vlan del dev swp2 vid 100
> # bridge vlan
> port    vlan ids
> swp5     1 PVID Egress Untagged
>
> swp2     1 Egress Untagged
>
> swp3     1 PVID Egress Untagged
>
> swp4     1 PVID Egress Untagged
>
> br0      1 PVID Egress Untagged
>
> # ping 10.0.0.1
> PING 10.0.0.1 (10.0.0.1) 56(84) bytes of data.
> ^C
> --- 10.0.0.1 ping statistics ---
> 8 packets transmitted, 0 received, 100% packet loss, time 7267ms
>
> What is the consensus here? Is there a reason why the bridge driver
> doesn't take care of this? Do switchdev drivers have to restore the
> pvid to always be operational, even if their state becomes
> inconsistent with the upper dev? Is it just 'nice to have'? What if
> VID 1 isn't in the hw filter either (perfectly legal)?
>
> Thanks!
> -Vladimir

Or rather, let me put it differently.
I am not only asking to figure out whether I should put this extra
logic or not in a switchdev driver - I can understand the "you don't
want it, don't put it" concept.
But let's say that for various reasons, MSTP is not supported in the
Linux kernel and I'm trying to create an ad-hoc MSTP setup where I
break the loop manually in the pvid. Is there any good reason why a
switchdev driver would oppose fierce resistance to me trying to do
that? Again, this is perfectly valid - the switch will no longer
receive untagged traffic but it will continue to forward frames in
other VLANs.

-Vladimir
