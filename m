Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84EED36D943
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 16:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhD1OKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 10:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbhD1OJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 10:09:48 -0400
Received: from mail.as397444.net (mail.as397444.net [IPv6:2620:6e:a000:dead:beef:15:bad:f00d])
        by lindbergh.monkeyblade.net (Postfix) with UTF8SMTPS id DDAD1C061573
        for <netdev@vger.kernel.org>; Wed, 28 Apr 2021 07:09:03 -0700 (PDT)
Received: by mail.as397444.net (Postfix) with UTF8SMTPSA id 7A0EB55B157;
        Wed, 28 Apr 2021 14:09:00 +0000 (UTC)
X-DKIM-Note: Keys used to sign are likely public at https://as397444.net/dkim/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mattcorallo.com;
        s=1619617264; t=1619618940;
        bh=kPwfSc6GZgnHMSGESH3gG0Wx7jV1FtRi/+5fwFXQmm4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=FLBX1OwnVVsPckLrFoL3ZTrbui5NGZnaEbgmb/4jspbMHbV29UM5jTCcHukE0nhSz
         cQzZlKPZkAjVNrXHOOxdZ6yCxVKSDxOOxVB3A2wUCfhvKaqWth4/VuBDoS8dKRtZPq
         WkpMdqnFJSw9Acmg4Uo459s3wHxass6GXy8loQ5vYiadGoclRtq87+1zbiu0F2Efzr
         QWtMfKtwKBtf21BP3Vc6ZanGzdDRqdarOgBVYvPYbbP5tamX6VgQlYPkKrcdiTBhHL
         1uSpBBm/cbp03pATg5ucW5gQZoUUF7sEFiEyRsxar7z3waOmXCMjjJrFpgedyt0xcd
         FSIliJVgHxb/Q==
Message-ID: <0cb19f7e-a9b3-58f8-6119-0736010f1326@bluematt.me>
Date:   Wed, 28 Apr 2021 10:09:00 -0400
MIME-Version: 1.0
Subject: Re: [PATCH net-next] Reduce IP_FRAG_TIME fragment-reassembly timeout
 to 1s, from 30s
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Willy Tarreau <w@1wt.eu>, Keyu Man <kman001@ucr.edu>
References: <d840ddcf-07a6-a838-abf8-b1d85446138e@bluematt.me>
 <CANn89i+L2DuD2+EMHzwZ=qYYKo1A9gw=nTTmh20GV_o9ADxe2Q@mail.gmail.com>
From:   Matt Corallo <netdev-list@mattcorallo.com>
In-Reply-To: <CANn89i+L2DuD2+EMHzwZ=qYYKo1A9gw=nTTmh20GV_o9ADxe2Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/21 08:20, Eric Dumazet wrote:
> This is going to break many use cases.
> 
> I can certainly say that in many cases, we need more than 1 second to
> complete reassembly.
> Some Internet users share satellite links with 600 ms RTT, not
> everybody has fiber links in 2021.

I'm curious what RTT has to do with it? Frags aren't resent, so there's no RTT you need to wait for, the question is 
more your available bandwidth and how much packet reordering you see, which even for many sat links isn't zero anymore 
(better, in-flow packet reordering is becoming more and more rare!).

Even given some material reordering, 30 seconds on a 100Kb is a lot!

> There is a sysctl, exactly for the cases where admins can decide to
> make the value smaller.

Sadly this doesn't actually solve it in many cases. Because Linux reassembles fragments by default any time conntrack is 
loaded (disabling this is very nontrivial), anyone with a Linux box in between two hosts ends up breaking flows with any 
material loss of frags.

More broadly, just because there is a sysctl, doesn't mean the default needs to be sensible for most users. As you note, 
there's a sysctl, if someone is on a 1Kbps sat link with fragments sent out of order, they can change it :). This 
constant hasn't been touched since pre-git!

> You can laugh all you want, the sad thing with IP frags is that really
> some applications still want to use them.

Yes, including my application, which breaks any time the flow *transits* a Linux box (ie not just my end host(s), but 
any box in between that happens to have conntrack loaded).

> Also, admins willing to use 400 MB of memory instead of 4MB can just
> change a sysctl.
> 
> Again, nothing will prevent reassembly units to be DDOS targets.

Yep, not claiming any differently. As noted in a previous thread you really have to crank up the limits to prevent DDOS.

> At Google, we use 100 MB for /proc/sys/net/ipv4/ipfrag_high_thresh and
> /proc/sys/net/ipv6/ip6frag_high_thresh,
> no kernel patch is needed.
> 
