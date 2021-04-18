Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103A1363331
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 04:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236811AbhDRC1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 22:27:00 -0400
Received: from mail.as397444.net ([69.59.18.99]:55974 "EHLO mail.as397444.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229870AbhDRC07 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Apr 2021 22:26:59 -0400
X-Greylist: delayed 3381 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Apr 2021 22:26:59 EDT
Received: by mail.as397444.net (Postfix) with UTF8SMTPSA id C0AC853AFB6;
        Sun, 18 Apr 2021 02:26:30 +0000 (UTC)
X-DKIM-Note: Keys used to sign are likely public at https://as397444.net/dkim/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mattcorallo.com;
        s=1618711264; t=1618712790;
        bh=LiyJFwIT2KhGaEmbM/SHTeC/VohaZDVunDtvveghw5Y=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Nzqv9Ftghba6IC1H0bG0ckc2Dj/6DSSNa8Sf0hUiUf9aL6V4kbZv8pCWfcwkGiqam
         +nv00CfNdO5b+O/9pMsa2FlyvTPgkl/OZG7BxoJOIx87x0T0rW/oxhYdvxP/negWki
         5Scc4Bzam7OddowLcRQpDmG7M0tlKt/8kKNW4ZL9KBDCp/U73bTJU8L2/WTCSTpKT6
         OargfOcMwNGrTHi7SKjTHl7OLPqxbi+pw7fn73/Ras0v/gANEYRCJK2Xrkn6rdaheB
         H86Fs57ZX0Gx9qRtf9NvwhvKISxVL1kL5uneH2ogDcsS3InH9O/Ob0n+DBPv1KISSV
         HH48qxkjl9Sag==
Message-ID: <78d776a9-4299-ff4e-8ca2-096ec5c02d05@bluematt.me>
Date:   Sat, 17 Apr 2021 22:26:30 -0400
MIME-Version: 1.0
Subject: Re: PROBLEM: DoS Attack on Fragment Cache
Content-Language: en-US
To:     Keyu Man <kman001@ucr.edu>
Cc:     Willy Tarreau <w@1wt.eu>, Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhiyun Qian <zhiyunq@cs.ucr.edu>
References: <02917697-4CE2-4BBE-BF47-31F58BC89025@hxcore.ol>
 <52098fa9-2feb-08ae-c24f-1e696076c3b9@gmail.com>
 <CANn89iL_V0WbeA-Zr29cLSp9pCsthkX9ze4W46gx=8-UeK2qMg@mail.gmail.com>
 <20210417072744.GB14109@1wt.eu>
 <CAMqUL6bkp2Dy3AMFZeNLjE1f-sAwnuBWpXH_FSYTSh8=Ac3RKg@mail.gmail.com>
 <20210417075030.GA14265@1wt.eu>
 <c6467c1c-54f5-8681-6e7d-aa1d9fc2ff32@bluematt.me>
 <CAMqUL6bAVE9p=XEnH4HdBmBfThaY3FDosqyr8yrQo6N_9+Jf3w@mail.gmail.com>
From:   Matt Corallo <netdev-list@mattcorallo.com>
In-Reply-To: <CAMqUL6bAVE9p=XEnH4HdBmBfThaY3FDosqyr8yrQo6N_9+Jf3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sure, there are better ways to handle the reassembly cache overflowing, but that is pretty unrelated to the fact that 
waiting 30 full seconds for a fragment to come in doesn't really make sense in today's networks (the 30 second delay 
that is used today appears to even be higher than RFC 791 suggested in 1981!). You get a lot more bang for your buck if 
you don't wait around so long (or we could restructure things to kick out the oldest fragments, but that is a lot more 
work, and probably extra indexes that just aren't worth it).

Matt

On 4/17/21 21:38, Keyu Man wrote:
> Willy's words make sense to me and I agree that the existing fragments
> should be evicted when the new one comes in and the cache is full.
> Though the attacker can still leverage this to flush the victim's
> cache, as mentioned previously, since fragments are likely to be
> assembled in a very short time, it would be hard to launch the
> attack(evicting the legit fragment before it's assembled requires a
> large packet sending rate). And this seems better than the existing
> solution (drop all incoming fragments when full).
> 
> Keyu
> 
> On Sat, Apr 17, 2021 at 6:30 PM Matt Corallo
> <netdev-list@mattcorallo.com> wrote:
>>
>> See-also "[PATCH] Reduce IP_FRAG_TIME fragment-reassembly timeout to 1s, from 30s" (and the two resends of it) - given
>> the size of the default cache (4MB) and the time that it takes before we flush the cache (30 seconds) you only need
>> about 1Mbps of fragments to hit this issue. While DoS attacks are concerning, its also incredibly practical (and I do)
>> hit this issue in normal non-adversarial conditions.
>>
>> Matt
>>
>> On 4/17/21 03:50, Willy Tarreau wrote:
>>> On Sat, Apr 17, 2021 at 12:42:39AM -0700, Keyu Man wrote:
>>>> How about at least allow the existing queue to finish? Currently a tiny new
>>>> fragment would potentially invalid all previous fragments by letting them
>>>> timeout without allowing the fragments to come in to finish the assembly.
>>>
>>> Because this is exactly the principle of how attacks are built: reserve
>>> resources claiming that you'll send everything so that others can't make
>>> use of the resources that are reserved to you. The best solution precisely
>>> is *not* to wait for anyone to finish, hence *not* to reserve valuable
>>> resources that are unusuable by others.
>>>
>>> Willy
>>>
