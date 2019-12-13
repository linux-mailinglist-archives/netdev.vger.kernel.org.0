Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6B211DD06
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 05:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731746AbfLMEP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 23:15:27 -0500
Received: from mail-ot1-f49.google.com ([209.85.210.49]:44734 "EHLO
        mail-ot1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731436AbfLMEP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 23:15:27 -0500
Received: by mail-ot1-f49.google.com with SMTP id x3so4643885oto.11;
        Thu, 12 Dec 2019 20:15:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7LVcz87mfJCZYhCb0ulqJCZii16qq0xWW3eUPOjkGkE=;
        b=n+h8fWzqCvK2t/vEAWYqU8ajyuIOVBeYw3kh27bY7+j/BpT/Mfm0k6+U4B4q/xHfLZ
         HB42i+ZCi9Xdmw7D1jho9iEUPCJy9bh7tO8C9PzN+0EaC8GUZpH7rKDlWtnFn0BULyuX
         URFWSsggrpDYGF6XZyi143GGqY9VYIIvKMkGeSinlt2iHWDSzg/NAoruNR5/5ONAlDJq
         QvAbS8RlAwhwDrJkg15ud0fIgTEnXSOrz2Keh63I61aVnNjhx9+IW/x/zgC3xy0OYsbF
         mNMn6Q/l8Dpmj2d58emBrBhDNzCjeOVmhmN8+/QoYZU6O9G84B4OOukSk2AGnV/Y+HUD
         tc5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7LVcz87mfJCZYhCb0ulqJCZii16qq0xWW3eUPOjkGkE=;
        b=LlidvkNU+IeFFPE+btRJ1PF0Ev6/TfXTzFEzXBFdU9QIIlxppUZQpx3o6z3nAKfZrr
         2xoqkkCBMGcuWL0t7NeE/JRbQ0yhUmunUiYyqsJSAt5mYkOLqVk0N6YJaoyUnv+YApoB
         6OtK/ogaMNskihopXyg/Rb8aN2Bu4QPqQp6wD9Ev5W5jLGYgm3EzeSBqmtoCwRp7iK/+
         Cbi+rpW3LcdqTbG16f6sce+kD9sMKCVxkenru1cfW4nK0sdnPwDi7Df7SDbnVC12NO2Z
         dUTK2z0eDDHTswIjCWJKy4z5F3HEnsX5so6CHrLBu/YGr7wqWT6uZt0NGvVqrnqFlBXY
         sQ5g==
X-Gm-Message-State: APjAAAXVGO2q8u/PyuwMM049EMFCi9xNf93DAB7AaqzBsca2/3mipbfA
        Hev/9ZdQHrrN9rrsiFlSEfaoZwkYQobwCL8oWHZ4pGMhAjo=
X-Google-Smtp-Source: APXvYqy3WiIzz2nXfI2jcEazJ+sFxZAFvmFaLmY8uwdep/ZCq/auKkzN5QEV3q2WvjDiGasCChrVDYXcRPFk9KBIHvA=
X-Received: by 2002:a05:6830:10c9:: with SMTP id z9mr12257307oto.200.1576210526463;
 Thu, 12 Dec 2019 20:15:26 -0800 (PST)
MIME-Version: 1.0
References: <14cedbb9300f887fecc399ebcdb70c153955f876.camel@sipsolutions.net>
In-Reply-To: <14cedbb9300f887fecc399ebcdb70c153955f876.camel@sipsolutions.net>
From:   Justin Capella <justincapella@gmail.com>
Date:   Thu, 12 Dec 2019 20:15:14 -0800
Message-ID: <CAMrEMU-WdaAe2wOxsnMn=npPyAjf1KkuxA8cHE==yez_rUELUQ@mail.gmail.com>
Subject: Re: debugging TCP stalls on high-speed wifi
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Could TCP window size (waiting for ACKnowledgements) be a contributing factor?

On Thu, Dec 12, 2019 at 6:52 AM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> Hi Eric, all,
>
> I've been debugging (much thanks to bpftrace) TCP stalls on wifi, in
> particular on iwlwifi.
>
> What happens, essentially, is that we transmit large aggregates (63
> packets of 7.5k A-MSDU size each, for something on the order of 500kB
> per PPDU). Theoretically we can have ~240 A-MSDUs on our hardware
> queues, and the hardware aggregates them into up to 63 to send as a
> single PPDU.
>
> At HE rates (160 MHz, high rates) such a large PPDU takes less than 2ms
> to transmit.
>
> I'm seeing around 1400 Mbps TCP throughput (a bit more than 1800 UDP),
> but I'm expecting more. A bit more than 1800 for UDP is about the max I
> can expect on this AP (it only does 8k A-MSDU size), but I'd think TCP
> then shouldn't be so much less (and our Windows drivers gets >1600).
>
>
> What I see is that occasionally - and this doesn't happen all the time
> but probably enough to matter - we reclaim a few of those large
> aggregates and free the transmit SKBs, and then we try to pull from
> mac80211's TXQs but they're empty.
>
> At this point - we've just freed 400+k of data, I'd expect TCP to
> immediately push more, but it doesn't happen. I sometimes see another
> set of reclaims emptying the queue entirely (literally down to 0 packets
> on the queue) and it then takes another millisecond or two for TCP to
> start pushing packets again.
>
> Once that happens, I also observe that TCP stops pushing large TSO
> packets and goes down to sometimes less than a single A-MSDU (i.e.
> ~7.5k) in a TSO, perhaps even an MTU-sized frame - didn't check this,
> only the # of frames we make out of this.
>
>
> If you have any thoughts on this, I'd appreciate it.
>
>
> Something I've been wondering is if our TSO implementation causes
> issues, but apart from higher CPU usage I see no real difference if I
> turned it off. I thought so because it splits up the SKBs into those A-
> MSDU sized chunks using skb_gso_segment() and then splits them down into
> MTU-sized all packed together into an A-MSDU using the hardware engine.
> But that means we release a bunch of A-MSDU-sized SKBs back to the TCP
> stack when they transmitted.
>
> Another thought I had was our broken NAPI, but this is TX traffic so the
> only RX thing is sync, and I'm currently still using kernel 5.4 anyway.
>
> Thanks,
> johannes
>
