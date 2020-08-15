Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469702454F8
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 01:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728830AbgHOXzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 19:55:16 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:57161 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726429AbgHOXzP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Aug 2020 19:55:15 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 9aa8e9b7
        for <netdev@vger.kernel.org>;
        Sat, 15 Aug 2020 07:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=zwkte4Bws3IhFK25KApEnosGnhY=; b=gObJ3a
        8WecvnlwyDV9q20WasYeX+3ConSorJLAhGfNDTcDyq0F6DsNyaptGZmhHmxVtfh2
        Bc9CdT/m/xiaVsJF0P6mfy9db6uVVtcXT+jViwXS0J91oYq0fHQn9+M0/HUrv/j6
        suSS7j6RoyeifSJIMBiBV0q2iI23cPwI6Y2H+Ngx/4+mKLKZA2OSOSy5uVGAoiai
        2LLLdCej1SmUV1DlvBaU6BHvEc+vHgXgBDTgu08YCdpCRT4My97lUbQnvLxY237W
        g1KOvOKvJMWsKFWD7Z1AGyo+72m89xfWdp1trLclTBMckUT+uARBnGnZCkZtIy7j
        /Ufp85dXWiZlSMlg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0f514774 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Sat, 15 Aug 2020 07:29:23 +0000 (UTC)
Received: by mail-io1-f45.google.com with SMTP id k23so12896471iom.10
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 00:55:08 -0700 (PDT)
X-Gm-Message-State: AOAM531bE3QUZuhLIJ15dcI6w3Su49hQwVPJ4K00tkVoeMQ0+TSAhfyV
        RP70Sebo8hf1aGS8oYUKWPGsucVlM0/A9wXDm84=
X-Google-Smtp-Source: ABdhPJzU1lCYHKlo+A8DMBSR6OICKoKYtGj8w6/7MW4V0FisblrtQ7IZyE60pXJOo3g7032WqSr9oKfqFHolSJEWDNs=
X-Received: by 2002:a05:6638:250f:: with SMTP id v15mr6117856jat.75.1597478108200;
 Sat, 15 Aug 2020 00:55:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9rbRrdV0ePxT0DgurGdEKOWiEi5mH5Wtg=aJwSA6fxwMg@mail.gmail.com>
 <20200814083153.06b180b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAHmME9rt-8Z1FJo9YSEqQHyEd1178cfizNa08BiakZYr+FR=Wg@mail.gmail.com> <20200814.142656.1061722366614948972.davem@davemloft.net>
In-Reply-To: <20200814.142656.1061722366614948972.davem@davemloft.net>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sat, 15 Aug 2020 09:54:56 +0200
X-Gmail-Original-Message-ID: <CAHmME9pq8iFfuf2EZG_4xQhDekP+hZR8yUDgYEf3gWNONM_3Ew@mail.gmail.com>
Message-ID: <CAHmME9pq8iFfuf2EZG_4xQhDekP+hZR8yUDgYEf3gWNONM_3Ew@mail.gmail.com>
Subject: Re: [PATCH net v4] net: xdp: account for layer 3 packets in generic
 skb handler
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Netdev <netdev@vger.kernel.org>,
        Thomas Ptacek <thomas@sockpuppet.org>,
        Adhipati Blambangan <adhipati@tuta.io>,
        David Ahern <dsahern@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 14, 2020 at 11:27 PM David Miller <davem@davemloft.net> wrote:
>
> From: "Jason A. Donenfeld" <Jason@zx2c4.com>
> Date: Fri, 14 Aug 2020 23:04:56 +0200
>
> > What? No. It comes up repeatedly because people want to reuse their
> > XDP processing logic with layer 3 devices.
>
> XDP is a layer 2 packet processing technology.  It assumes an L2
> ethernet and/or VLAN header is going to be there.
>
> Putting a pretend ethernet header there doesn't really change that.

Actually, I wasn't aware that XDP was explicitly limited to L2-only,
as some kind of fundamental thing. A while back when this patchset
first came up, I initially posted something that gave unmodified L3
frames to XDP programs in the generic handler, but commenters pointed
out that this loses the skb->protocol changing capability, which could
be useful (e.g. some kind of custom v4->v6 modifying code), and adding
the pretend ethernet header would allow people to keep the same
programs for the L2 case as for the L3 case, which seemed *extremely*
compelling to me. Hence, this patch series has gone in the pretend
ethernet header direction.

But, anyway, as I said, I wasn't aware that XDP was explicitly limited
to L2-only, as some kind of fundamental thing. This actually surprises
me. I always thought the original motivation of XDP was that it
allowed putting a lot of steering and modification logic into the
network card hardware, for fancy new cards that support eBPF. Later,
the generic handler got added on so people could reuse those programs
in heterogeneous environments, where some cards have hardware support
and others do not. That seemed like a good idea to me. Extending that
a step further for layer 3 devices seems like a logical next step, in
the sense that if that step is invalid, surely the previous one of
adding the generic handler must be invalid too? At least that's my
impression of the historical evolution of this; I'm confident you know
much better than I do.

It makes me wonder, though, what will you say when hardware comes out
that has layer 3 semantics and a thirst for eBPF? Also deny that
hardware of XDP, because "XDP is a layer 2 packet processing
technology"? I know what you'll say now: "we don't design our
networking stack around hypothetical hardware, so why even bring it
up? I won't entertain that." But nevertheless, contemplating those
hypotheticals might be a good exercise for seeing how committed you
are to the XDP=L2-only assertion. For example, maybe there are
fundamental L2 semantics that XDP needs, and can't be emulated with my
pretend ethernet header -- like if you really are relying on the MACs
for something I'm not aware of; were that the case, it'd be compelling
to me. But if it's a bit weaker, in the form of, "we just don't want
to try anything with L3 at all because," then I admit I'm still a bit
mystified.

Nevertheless, at the risk of irritating you further, I will willingly
drop this patchset at your request, even though I don't completely
understand the entire scope of reasoning for doing so. (For posterity,
I just posted a v6, which splits out that other bug fix into something
separate for you to take, so that this one here can exist on its own.)

Jason
