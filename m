Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20E2271C73
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 18:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733052AbfGWQIZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 23 Jul 2019 12:08:25 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35937 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727363AbfGWQIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 12:08:25 -0400
Received: by mail-ed1-f65.google.com with SMTP id k21so44503639edq.3
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 09:08:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=QyNCFwrwm8gMr9aaSUZmpWN4s4yhL0ljiXv9ae7c4Nc=;
        b=FIKl6pPnYtrb+RgEeoi7etc95E4g1fZcQQmSdt9Qj9gq9BzY6+NK+raWscaKHDkpRu
         1E3sEDEhl7Ov25FSGf64xAzDRXIysO0WK6NXmwFeM0c3lL8dhmm/IuGg8C/aPHrxYFVN
         ErPNSZQJB9nYaUgMHgMN72ZQU2i5jQQU3v9q5uQUmH652mhgWvRLvAFU3pfrE2L0xLpw
         wmswBB2m8sC8RugbxNXoJtUIIs/rX1JaREd8IMqbROEeHzOhqPHLk7L1fjtzsjREIoRz
         HKQoKV5EGuigzR2cBVD7xLhmaV4KZ2pDn31aws+PhrHojQxu+stumN3RFOBAr1oyO7El
         yMOw==
X-Gm-Message-State: APjAAAVsRjV4To2tlhZehgd0q/RAX+Z6k3De4dgb2O/dv1EI2wZytj1R
        Gn563xuoSh27N0ZWN2jHv7O1Hg==
X-Google-Smtp-Source: APXvYqxoF+nDjkg2jDe1H83vcnPEBcgCeEWvqq/tpzB+PM8xn2V/5daqvvHat9ZDVCbkqXGyxVJCgg==
X-Received: by 2002:a05:6402:6cb:: with SMTP id n11mr66746566edy.101.1563898103253;
        Tue, 23 Jul 2019 09:08:23 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id f21sm11983966edj.36.2019.07.23.09.08.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 09:08:22 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CB145181CE7; Tue, 23 Jul 2019 18:08:21 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 00/12] drop_monitor: Capture dropped packets and metadata
In-Reply-To: <20190723151423.GA10342@splinter>
References: <20190722183134.14516-1-idosch@idosch.org> <87imrt4zzg.fsf@toke.dk> <20190723064659.GA16069@splinter> <875znt3pxu.fsf@toke.dk> <20190723151423.GA10342@splinter>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 23 Jul 2019 18:08:21 +0200
Message-ID: <87ftmw3f9m.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ido Schimmel <idosch@idosch.org> writes:

> On Tue, Jul 23, 2019 at 02:17:49PM +0200, Toke Høiland-Jørgensen wrote:
>> Ido Schimmel <idosch@idosch.org> writes:
>> 
>> > On Mon, Jul 22, 2019 at 09:43:15PM +0200, Toke Høiland-Jørgensen wrote:
>> >> Is there a mechanism for the user to filter the packets before they are
>> >> sent to userspace? A bpf filter would be the obvious choice I guess...
>> >
>> > Hi Toke,
>> >
>> > Yes, it's on my TODO list to write an eBPF program that only lets
>> > "unique" packets to be enqueued on the netlink socket. Where "unique" is
>> > defined as {5-tuple, PC}. The rest of the copies will be counted in an
>> > eBPF map, which is just a hash table keyed by {5-tuple, PC}.
>> 
>> Yeah, that's a good idea. Or even something simpler like tcpdump-style
>> filters for the packets returned by drop monitor (say if I'm just trying
>> to figure out what happens to my HTTP requests).
>
> Yep, that's a good idea. I guess different users will use different
> programs. Will look into both options.

Cool.

>> > I think it would be good to have the program as part of the bcc
>> > repository [1]. What do you think?
>> 
>> Sure. We could also add it to the XDP tutorial[2]; it could go into a
>> section on introspection and debugging (just added a TODO about that[3]).
>
> Great!
>
>> >> For integrating with XDP the trick would be to find a way to do it that
>> >> doesn't incur any overhead when it's not enabled. Are you envisioning
>> >> that this would be enabled separately for the different "modes" (kernel,
>> >> hardware, XDP, etc)?
>> >
>> > Yes. Drop monitor have commands to enable and disable tracing, but they
>> > don't carry any attributes at the moment. My plan is to add an attribute
>> > (e.g., 'NET_DM_ATTR_DROP_TYPE') that will specify the type of drops
>> > you're interested in - SW/HW/XDP. If the attribute is not specified,
>> > then current behavior is maintained and all the drop types are traced.
>> > But if you're only interested in SW drops, then overhead for the rest
>> > should be zero.
>> 
>> Makes sense (although "should be" is the key here ;)).
>> 
>> I'm also worried about the drop monitor getting overwhelmed; if you turn
>> it on for XDP and you're running a filtering program there, you'll
>> suddenly get *a lot* of drops.
>> 
>> As I read your patch, the current code can basically queue up an
>> unbounded number of packets waiting to go out over netlink, can't it?
>
> That's a very good point. Each CPU holds a drop list. It probably makes
> sense to limit it by default (to 1000?) and allow user to change it
> later, if needed. I can expose a counter that shows how many packets
> were dropped because of this limit. It can be used as an indication to
> adjust the queue length (or flip to 'summary' mode).

Yup, sounds reasonable. What we don't want to happen is that the system
falls over as soon as someone turns on debugging, because XDP dumps 20
million packets/s into the debug queue ;)

Also, presumably the queue will have to change from a struct
sk_buff_head to something that can hold XDP frames and whatever devlink
puts there as well, right?

-Toke
