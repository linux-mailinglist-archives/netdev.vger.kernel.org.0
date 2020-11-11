Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A812AEF15
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 12:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgKKLCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 06:02:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32637 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725895AbgKKLCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 06:02:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605092554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HgnsptKYrAYETwb6RQgP12ipc3XlwLCSG6GxAjNNiQg=;
        b=HdYebn0bjIhjrD1RljpXkyCe3gqmj/Xge1/BecCBYojGzfm0xUKSj1Xqgk5TJEsCPZ153M
        Q19YUQfqg5L/K0FXNc/y5TSgsQKhLsc7439FDwStCJbJWgN+QosmB87WYQMsBuwmyV9N/1
        HRUNQm7cPMsBh6EVVx52E7/tROnUVc0=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-fvTjL9tIPsiQnlwEjcKVqw-1; Wed, 11 Nov 2020 06:02:32 -0500
X-MC-Unique: fvTjL9tIPsiQnlwEjcKVqw-1
Received: by mail-qk1-f199.google.com with SMTP id z68so1380862qkc.4
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 03:02:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=HgnsptKYrAYETwb6RQgP12ipc3XlwLCSG6GxAjNNiQg=;
        b=V9kxq9ZcPcpvsSXAs4sbcNti+sT3cNemgapjnSX947tO2FnEnFbZ4nVHRgM87/TC20
         3RE/ZowBlX0ut6eieuAcOU+clLjxG/s2GawS8Gt2Efh3+Ik6xxQThyoOER/juJ4s/n8T
         vBtoynyW41C6n+k1Wm/OpsEywHfm8sT8mzc9hpahffLuXSVwytrtjSWBENc8VLQ+TdzW
         ZnVWnyYLUw1I0Oz/fshwfk4EQ24KipuZJbRqzU56thvSBNz8/sEvlCOe+6PGLjOx6npd
         o+YFQIKPKa6n3Z84RnG4FmD0Ao+yc+pPIIoejsutPg51L2OagUMIImLH0uTh1aHfoP7O
         lQHA==
X-Gm-Message-State: AOAM530g+CsG6rXqLBRIGyg4Dtf8ANvhVa9R019NY+xKz6yikk0vLNKy
        Hi2E0iVPiDVvwAq0MG1cTRDL9dvZjgescPwcGvrXBRttnFjg1X47jE+tffUi7mRRFlZhi13V6wh
        YgyFv3YDxXRsI8P2V
X-Received: by 2002:ac8:1201:: with SMTP id x1mr12717903qti.339.1605092551553;
        Wed, 11 Nov 2020 03:02:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzk553Y+qO9pY8i86H2Q8DT91q75yDtJJLXiQ9gewjey8d5E3lMiuoHYWNh9qdk7ow0cv4rww==
X-Received: by 2002:ac8:1201:: with SMTP id x1mr12717886qti.339.1605092551320;
        Wed, 11 Nov 2020 03:02:31 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id s23sm1718122qke.11.2020.11.11.03.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 03:02:29 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B1EAB1833E9; Wed, 11 Nov 2020 12:02:26 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Benc <jbenc@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Hangbin Liu <haliu@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
In-Reply-To: <20201111004749.r37tqrhskrcxjhhx@ast-mbp>
References: <CAADnVQKu7usDXbwwcjKChcs0NU3oP0deBsGGEavR_RuPkht74g@mail.gmail.com>
 <07f149f6-f8ac-96b9-350d-b289ef16d82f@solarflare.com>
 <CAEf4BzaSfutBt3McEPjmu_FyxyzJa_xVGfhP_7v0oGuqG_HBEw@mail.gmail.com>
 <20201106094425.5cc49609@redhat.com>
 <CAEf4Bzb2fuZ+Mxq21HEUKcOEba=rYZHc+1FTQD98=MPxwj8R3g@mail.gmail.com>
 <CAADnVQ+S7fusZ6RgXBKJL7aCtt3jpNmCnCkcXd0fLayu+Rw_6Q@mail.gmail.com>
 <20201106152537.53737086@hermes.local>
 <45d88ca7-b22a-a117-5743-b965ccd0db35@gmail.com>
 <20201109014515.rxz3uppztndbt33k@ast-mbp>
 <14c9e6da-e764-2e2c-bbbb-bc95992ed258@gmail.com>
 <20201111004749.r37tqrhskrcxjhhx@ast-mbp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 11 Nov 2020 12:02:26 +0100
Message-ID: <874klwcg1p.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Mon, Nov 09, 2020 at 09:09:44PM -0700, David Ahern wrote:
>> On 11/8/20 6:45 PM, Alexei Starovoitov wrote:
>> > 
>> > I don't understand why on one side you're pointing out existing quirkiness with
>> > bpf usability while at the same time arguing to make it _less_ user friendly
>> 
>> I believe you have confused my comments with others. My comments have
>> focused on one aspect: The insistence by BPF maintainers that all code
>> bases and users constantly chase latest and greatest versions of
>> relevant S/W to use BPF
>
> yes, because we care about user experience while you're still insisting
> on make it horrible.
> With random pick of libbpf.so we would have no choice, but to actively tell
> users to avoid using tc, because sooner or later they will be pissed. I'd
> rather warn them ahead of time.

Could we *please* stop with this "my way or the highway" extortion? It's
incredibly rude, and it's not helping the discussion.

>> - though I believe a lot of the tool chasing
>> stems from BTF. I am fairly certain I have been consistent in that theme
>> within this thread.
>
> Right. A lot of features added in the last couple years depend on BTF:
> static vs global linking, bpf_spin_lock, function by function verification, etc
>
>> > when myself, Daniel, Andrii explained in detail what libbpf does and how it
>> > affects user experience?
>> > 
>> > The analogy of libbpf in iproute2 and libbfd in gdb is that both libraries
>> 
>> Your gdb / libbfd analogy misses the mark - by a lot. That analogy is
>> relevant for bpftool, not iproute2.
>> 
>> iproute2 can leverage libbpf for 3 or 4 tc modules and a few xdp hooks.
>> That is it, and it is a tiny percentage of the functionality in the package.
>
> cat tools/lib/bpf/*.[hc]|wc -l
> 23950
> cat iproute2/tc/*.[hc]|wc -l
> 29542
>
> The point is that for these few tc commands the amount logic in libbpf/tc is 90/10.
>
> Let's play it out how libbpf+tc is going to get developed moving forward if
> libbpf is a random version. Say, there is a patch for libbpf that makes
> iproute2 experience better. bpf maintainers would have no choice, but to reject
> it, since we don't add features/apis to libbpf if there is no active user.
> Adding a new libbpf api that iproute2 few years from now may or may not take
> advantage makes little sense.

What? No one has said that iproute2 would never use any new features,
just that they would be added conditionally on a compatibility check
with libbpf (like the check for bpf_program__section_name() in the
current patch series).

Besides, for the entire history of BPF support in iproute2 so far, the
benefit has come from all the features that libbpf has just started
automatically supporting on load (BTF, etc), so users would have
benefited from automatic library updates had it *not* been vendored in.

-Toke

