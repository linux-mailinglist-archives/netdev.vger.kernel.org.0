Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5201D717EE
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 14:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389679AbfGWMRw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 23 Jul 2019 08:17:52 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:46457 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389671AbfGWMRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 08:17:52 -0400
Received: by mail-ed1-f67.google.com with SMTP id d4so43700350edr.13
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 05:17:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=BtTlAmH3twmwSRxCGuO2+omE0u2b7SshY+/eIkWyKYM=;
        b=B/HaU/gCGShwimWQYFqzOu1deibPA3+yhNdCywkS+rAu/s8zottLu2OIjyKJbibdRi
         3Ju5OH7mqi46FOBHL3URraUuzKVHG3GSmEeF73C2BI/JuvZUYGt9RY2y64gTdVQSKQlc
         i/Sk8dR59p+0oMDwwoD88NtlM6eirVtRKeKJnpY1wFAwwOeB/0Wwhs5xyNcvt0wXTVg1
         FRCX9wA9V86OIHDcHBDOnLQZRYeMYoKQqmqtZrvLWG7uRBPPGsPPNhWwI59v0Sk+Gtw6
         ICaceLmFznC0z9gtsZM4oGrj55n2HCu830JEgUvC8kJdk8EBL9MkJNysVgd8Yd43O0rw
         RTxA==
X-Gm-Message-State: APjAAAXwXgoIxya2X760xuGea2I2m/8FrM5qsFscncUHWZ5QVthR+Kj8
        S1gbMFii6BVCZNPcIw4funk0ZQ==
X-Google-Smtp-Source: APXvYqwv2xMOu+FyDfTMUCMteLCFd10S8wMI9YUFqHRifC7EQoayrlcVelNsgPDNRTW0uVjcIPPs6Q==
X-Received: by 2002:a17:906:af4f:: with SMTP id ly15mr57090902ejb.126.1563884270849;
        Tue, 23 Jul 2019 05:17:50 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id b30sm12398367ede.88.2019.07.23.05.17.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 05:17:50 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 283EE181CE7; Tue, 23 Jul 2019 14:17:49 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 00/12] drop_monitor: Capture dropped packets and metadata
In-Reply-To: <20190723064659.GA16069@splinter>
References: <20190722183134.14516-1-idosch@idosch.org> <87imrt4zzg.fsf@toke.dk> <20190723064659.GA16069@splinter>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 23 Jul 2019 14:17:49 +0200
Message-ID: <875znt3pxu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ido Schimmel <idosch@idosch.org> writes:

> On Mon, Jul 22, 2019 at 09:43:15PM +0200, Toke Høiland-Jørgensen wrote:
>> Is there a mechanism for the user to filter the packets before they are
>> sent to userspace? A bpf filter would be the obvious choice I guess...
>
> Hi Toke,
>
> Yes, it's on my TODO list to write an eBPF program that only lets
> "unique" packets to be enqueued on the netlink socket. Where "unique" is
> defined as {5-tuple, PC}. The rest of the copies will be counted in an
> eBPF map, which is just a hash table keyed by {5-tuple, PC}.

Yeah, that's a good idea. Or even something simpler like tcpdump-style
filters for the packets returned by drop monitor (say if I'm just trying
to figure out what happens to my HTTP requests).

> I think it would be good to have the program as part of the bcc
> repository [1]. What do you think?

Sure. We could also add it to the XDP tutorial[2]; it could go into a
section on introspection and debugging (just added a TODO about that[3]).

>> For integrating with XDP the trick would be to find a way to do it that
>> doesn't incur any overhead when it's not enabled. Are you envisioning
>> that this would be enabled separately for the different "modes" (kernel,
>> hardware, XDP, etc)?
>
> Yes. Drop monitor have commands to enable and disable tracing, but they
> don't carry any attributes at the moment. My plan is to add an attribute
> (e.g., 'NET_DM_ATTR_DROP_TYPE') that will specify the type of drops
> you're interested in - SW/HW/XDP. If the attribute is not specified,
> then current behavior is maintained and all the drop types are traced.
> But if you're only interested in SW drops, then overhead for the rest
> should be zero.

Makes sense (although "should be" is the key here ;)).

I'm also worried about the drop monitor getting overwhelmed; if you turn
it on for XDP and you're running a filtering program there, you'll
suddenly get *a lot* of drops.

As I read your patch, the current code can basically queue up an
unbounded number of packets waiting to go out over netlink, can't it?

> For HW drops I'm going to have devlink call into drop monitor. The
> function call will just be a NOP in case user is not interested in HW
> drops. I'm not sure if for XDP you want to register a probe on a
> tracepoint or call into drop monitor. If you want to use the former,
> then you can just have drop monitor unregister its probe from the
> tracepoint, which is what drop monitor is currently doing with the
> kfree_skb() tracepoint.

I guess we would use whichever has the least overhead. We do already
have tracepoints in the XDP path, but only on the error path. We
certainly don't want the overhead of a function call in the XDP fast
path when this feature is turned off (even if that function does
nothing), but maybe the NOP-patching for a tracepoint is acceptable.
We'll have to benchmark it :)

-Toke

[2] https://github.com/xdp-project/xdp-tutorial

[3] https://github.com/xdp-project/xdp-project/commit/7637702087a6b9d94816092a054d77c479df808a
