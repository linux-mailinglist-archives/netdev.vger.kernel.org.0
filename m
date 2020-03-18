Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26D9518937B
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 02:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbgCRBKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 21:10:31 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46091 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbgCRBKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 21:10:30 -0400
Received: by mail-wr1-f68.google.com with SMTP id w16so11803227wrv.13;
        Tue, 17 Mar 2020 18:10:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c+3pQ2+vnTiQ1WeGKgUzvE9Mca8ETLvj3fth5jgOXvo=;
        b=IyaPciI4RQMkdB4+BXni8dDSnwYuEOiSBUPY3+IBAonTmP5RA6PsNZONR7WVH3Wv0b
         P0Fku4w5jms5WEM+SuoiRLO2nDNiHpxYDghrAUQIKu+0/M2eB1OBEISu8/FQIguFbQG8
         AL0giSlXo1Sf0jDdGeoZM/BLcCbtIFTcqCnYqw6GrBGXZGK8TR7l7XNcJGGJihte8FHZ
         qt5HCfsmYENjTXBk6Bg6/JLyyqmd2fZL4PCMBD4/xTb1IOW9CBsAPxBrI+EmF4u3CGXk
         Q8ovp3xv10WhnweB+k08eAckqNzqjLUdUT5C9Mtzo8oRxExUutV6vF4L/8aCgV62ICvN
         4Uhg==
X-Gm-Message-State: ANhLgQ2dmo9e5f42ptgtPGay22j7tAkVojtVSLRDOYLn0b3VqI/0jU14
        qmki9/R++IILnwCSSwxxae4OGsZ2mKXxDaAYXFY=
X-Google-Smtp-Source: ADFU+vus8iC8Om+rvyqdVj3Nde9t7NWXyPRFZN9j103m6RWmeEa1OO8kEKPO0tp3QM6eJxwi0trus/0Qp9nWi0Y97wY=
X-Received: by 2002:adf:bb45:: with SMTP id x5mr1720280wrg.388.1584493828524;
 Tue, 17 Mar 2020 18:10:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200312233648.1767-1-joe@wand.net.nz> <20200312233648.1767-4-joe@wand.net.nz>
 <20200316225729.kd4hmz3oco5l7vn4@kafai-mbp> <CAOftzPgsVOqCLZatjytBXdQxH-DqJxiycXWN2d4C_-BjR5v1Kw@mail.gmail.com>
 <CACAyw9_zt-wetBiFWXtpQOOv79QCFR12dA9jx1UDEya=0_poyQ@mail.gmail.com>
In-Reply-To: <CACAyw9_zt-wetBiFWXtpQOOv79QCFR12dA9jx1UDEya=0_poyQ@mail.gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Tue, 17 Mar 2020 18:10:16 -0700
Message-ID: <CAOftzPjeO4QJJnOBHjhzDmJRwqRztYaHLuKEOB_7a4KwDxgAHw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/7] bpf: Add socket assign support
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Joe Stringer <joe@wand.net.nz>, Martin KaFai Lau <kafai@fb.com>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 3:10 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Tue, 17 Mar 2020 at 03:06, Joe Stringer <joe@wand.net.nz> wrote:
> >
> > On Mon, Mar 16, 2020 at 3:58 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > On Thu, Mar 12, 2020 at 04:36:44PM -0700, Joe Stringer wrote:
> > > > Add support for TPROXY via a new bpf helper, bpf_sk_assign().
> > > >
> > > > This helper requires the BPF program to discover the socket via a call
> > > > to bpf_sk*_lookup_*(), then pass this socket to the new helper. The
> > > > helper takes its own reference to the socket in addition to any existing
> > > > reference that may or may not currently be obtained for the duration of
> > > > BPF processing. For the destination socket to receive the traffic, the
> > > > traffic must be routed towards that socket via local route, the socket
> > > I also missed where is the local route check in the patch.
> > > Is it implied by a sk can be found in bpf_sk*_lookup_*()?
> >
> > This is a requirement for traffic redirection, it's not enforced by
> > the patch. If the operator does not configure routing for the relevant
> > traffic to ensure that the traffic is delivered locally, then after
> > the eBPF program terminates, it will pass up through ip_rcv() and
> > friends and be subject to the whims of the routing table. (or
> > alternatively if the BPF program redirects somewhere else then this
> > reference will be dropped).
>
> Can you elaborate what "an appropriate routing configuration" would be?
> I'm not well versed with how routing works, sorry.

Maybe I should add this into the git commit message :-)

The simplest version of it is demonstrated in patch 6:
https://www.spinics.net/lists/netdev/msg637176.html

$ ip route add local default dev lo

Depending on your use case, you may want to be more specific on the
matches, eg using a specific CIDR rather than setting a default route.

> Do you think being subject to the routing table is desirable, or is it an
> implementation trade-off?

I think it's an implementation trade-off.

> >
> > I think this is a general bpf_sk*_lookup_*() question, previous
> > discussion[0] settled on avoiding that complexity before a use case
> > arises, for both TC and XDP versions of these helpers; I still don't
> > have a specific use case in mind for such functionality. If we were to
> > do it, I would presume that the socket lookup caller would need to
> > pass a dedicated flag (supported at TC and likely not at XDP) to
> > communicate that SO_ATTACH_REUSEPORT_EBPF progs should be respected
> > and used to select the reuseport socket.
>
> I was surprised that both TC and XDP don't run the reuseport program!

FWIW this is explicitly documented in the helper man pages for
sk_lookup_tcp() and friends:
http://man7.org/linux/man-pages/man7/bpf-helpers.7.html

> So far I assumed that TC did pass the skb. I understand that you don't want
> to tackle this issue, but is it possible to reject reuseport sockets from
> sk_assign in that case?

What if users don't attach a reuseport BPF program, but rely on the
standard hashing mechanism? Then we would be artificially limiting
that case.

What do you have in mind for the motivation of this, are you concerned
about feature probing or something else?

> --
> Lorenz Bauer  |  Systems Engineer
> 6th Floor, County Hall/The Riverside Building, SE1 7PB, UK
>
> www.cloudflare.com
