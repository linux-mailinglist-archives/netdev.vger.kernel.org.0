Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44C4820171
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 10:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfEPIlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 04:41:46 -0400
Received: from mail-oi1-f180.google.com ([209.85.167.180]:35165 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfEPIlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 04:41:46 -0400
Received: by mail-oi1-f180.google.com with SMTP id a132so1931927oib.2
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 01:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E7URQpqMRyJOHlh00wQzzB82hDaRhAqYNSSQIhhGFnA=;
        b=ZoZwWfKmd9kqWwuTbOwUF7OlC2wI+DEecPoIwGYwywNPz7zOIqoIJdNOvEkXQOd8Bd
         JsUQpF/GzlgeEr7Pp6EZUVVi2u6hrCTk1bopmgwX527k4THv7tIoYS2MkUFSwWffbCFz
         FaX09lKzejJ7bMQ3+SMyK51nsKxyZJPGcDm+M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E7URQpqMRyJOHlh00wQzzB82hDaRhAqYNSSQIhhGFnA=;
        b=Z2QBYjd5SNR9YUyMGDA1X7nmPvgiUMX4KhpHRhfCP+C/nnXscbtoWooPMMAb1bMQoX
         zursqu6+HXNurkceA+FTXy9IFiq5lcMnJHB4MzzUWbQsP1DCeofrbzNZsFJ0sF63isSz
         7p7KatQbZVR3tCyNnro/zZCLSkqUpdOQK6Ne+XlwYtXHjrH8QZk7LvZs2dYeuzfbNZhX
         a9hYHR6ZbPHkfbQAHaSFNjLSKEHbph22ayx/8c1Uh7GGcOAIS51YFYSRPEDNUig2Xqo5
         Vo+Q8oItsoboDWOvDD6ytKi6VJlPkwlEL2OsZP4QTszTrC24l0ta9bajfCb+AFd54Y6B
         tv2Q==
X-Gm-Message-State: APjAAAU4bNByxijXqwtQV5iAJhkptzBT7iPHnx84zlIG7Fh6cmq0QHcr
        czuUv3h8sRfFQ/tJcN4WXlUCWlmzlAIX//aaxyCcqQ==
X-Google-Smtp-Source: APXvYqyWlRXKxPPbvyCDXC+HEhunukaK4wtzpCin7lUaYtQnjVPT+nuUnL+AlDuJcTiliSowfyySqFJKyXbhBEJJtk4=
X-Received: by 2002:aca:3111:: with SMTP id x17mr9628187oix.172.1557996105614;
 Thu, 16 May 2019 01:41:45 -0700 (PDT)
MIME-Version: 1.0
References: <CACAyw98+qycmpQzKupquhkxbvWK4OFyDuuLMBNROnfWMZxUWeA@mail.gmail.com>
 <CADa=RyyuAOupK7LOydQiNi6tx2ELOgD+bdu+DHh3xF0dDxw_gw@mail.gmail.com>
In-Reply-To: <CADa=RyyuAOupK7LOydQiNi6tx2ELOgD+bdu+DHh3xF0dDxw_gw@mail.gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Thu, 16 May 2019 09:41:34 +0100
Message-ID: <CACAyw9_EGRob4VG0-G4PN9QS_xB5GoDMBB6mPXR-WcPnrFCuLg@mail.gmail.com>
Subject: Re: RFC: Fixing SK_REUSEPORT from sk_lookup_* helpers
To:     Joe Stringer <joe@isovalent.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 May 2019 at 18:16, Joe Stringer <joe@isovalent.com> wrote:
>
> On Wed, May 15, 2019 at 8:11 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> >
> > In the BPF-based TPROXY session with Joe Stringer [1], I mentioned
> > that the sk_lookup_* helpers currently return inconsistent results if
> > SK_REUSEPORT programs are in play.
> >
> > SK_REUSEPORT programs are a hook point in inet_lookup. They get access
> > to the full packet
> > that triggered the look up. To support this, inet_lookup gained a new
> > skb argument to provide such context. If skb is NULL, the SK_REUSEPORT
> > program is skipped and instead the socket is selected by its hash.
> >
> > The first problem is that not all callers to inet_lookup from BPF have
> > an skb, e.g. XDP. This means that a look up from XDP gives an
> > incorrect result. For now that is not a huge problem. However, once we
> > get sk_assign as proposed by Joe, we can end up circumventing
> > SK_REUSEPORT.
>
> To clarify a bit, the reason this is a problem is that a
> straightforward implementation may just consider passing the skb
> context into the sk_lookup_*() and through to the inet_lookup() so
> that it would run the SK_REUSEPORT BPF program for socket selection on
> the skb when the packet-path BPF program performs the socket lookup.
> However, as this paragraph describes, the skb context is not always
> available.
>
> > At the conference, someone suggested using a similar approach to the
> > work done on the flow dissector by Stanislav: create a dedicated
> > context sk_reuseport which can either take an skb or a plain pointer.
> > Patch up load_bytes to deal with both. Pass the context to
> > inet_lookup.
> >
> > This is when we hit the second problem: using the skb or XDP context
> > directly is incorrect, because it assumes that the relevant protocol
> > headers are at the start of the buffer. In our use case, the correct
> > headers are at an offset since we're inspecting encapsulated packets.
> >
> > The best solution I've come up with is to steal 17 bits from the flags
> > argument to sk_lookup_*, 1 bit for BPF_F_HEADERS_AT_OFFSET, 16bit for
> > the offset itself.
>
> FYI there's also the upper 32 bits of the netns_id parameter, another
> option would be to steal 16 bits from there.

Or len, which is only 16 bits realistically. The offset doesn't really fit into
either of them very well, using flags seemed the cleanest to me.
Is there some best practice around this?

>
> > Thoughts?
>
> Internally with skbs, we use `skb_pull()` to manage header offsets,
> could we do something similar with `bpf_xdp_adjust_head()` prior to
> the call to `bpf_sk_lookup_*()`?

That would only work if it retained the contents of the skipped
buffer, and if there
was a way to undo the adjustment later. We're doing the sk_lookup to
decide whether to
accept or forward the packet, so at the point of the call we might still need
that data. Is that feasible with skb / XDP ctx?

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
