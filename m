Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2572117339
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 18:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfLIR4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 12:56:30 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39988 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfLIR4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 12:56:30 -0500
Received: by mail-wr1-f67.google.com with SMTP id c14so17217195wrn.7
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 09:56:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=47tOogRVPsN3pILBUcIR6sGq30lJrJOYcswpOnQA894=;
        b=IDuEoa2KHRBJeiBgYDu5NZ6vKL18RxIuoD3iKPXfQJ7zGTuTDrAVjyP4wAO8GpJziY
         MW728vtOw194Z5g51mEY9NBaRLEFERjtpmhWcnq4Mx0GieGw6N+a6ZqB6lA83f9QFNxt
         hQzVVI99sWQcQ6g5Oofex8gJKVHIHEiRCuU7c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=47tOogRVPsN3pILBUcIR6sGq30lJrJOYcswpOnQA894=;
        b=NwOhfKgTJnQ/4IxCJcQgTmh2p1A4Yf0kWVWzRUs7g2i9iCDL4+6S+SW+inJbsCD97L
         CSDB9JLYda2HIaC4+t65UZhoY62sfNm3qzv8umAKHVI6Edh+SfOVkk6yX9Lz2qrK03YE
         2wgOvANCDIHVAqzIuTWs9L5mBVNLLyC2xL+KadEr8ljZdhK2zckj1H/cPrClS7ryKhDR
         UWoJaqJcZBQeiWZer6f+yoZXDFzhi48O1JhL5gbzmkJozKNsvRbsu14ZE/p/9p8VCBrr
         P2xlKy8VYzHe2eMe/LS5Q9OZ58aanjpJ5O3JwCiTuNMtELqpdAq43+cIN3BEZG/c+aCz
         RImQ==
X-Gm-Message-State: APjAAAXnde1ltZSp4Zj5CyneO5ViqGpJwWgeq3aXx2hQLcJ0tNmQiKbQ
        MsddsWAUI9Tcp1VMONpt5VLJ04dwRT0Q4wMEcBxrVQ==
X-Google-Smtp-Source: APXvYqycZBNtjVcssdYNUEiUjN6BUWNv177Ygs2RaUu/gnTjTW5T7vkapAF+a9uP+gjA44AdmBD5A4NYl3QLote1QfI=
X-Received: by 2002:adf:f103:: with SMTP id r3mr3385191wro.295.1575914188280;
 Mon, 09 Dec 2019 09:56:28 -0800 (PST)
MIME-Version: 1.0
References: <20191203160345.24743-1-labbott@redhat.com> <20191203170114.GB377782@localhost.localdomain>
 <9bc4b04b-a3cc-4e58-4c73-1d77b7ed05da@redhat.com> <CAFxkdAraVz6mbQ3OFRGF3DmfWMDNzuXd+HJ14ypex6bMm-oCGw@mail.gmail.com>
 <20191207173805.jvunyfnijgefn3z5@salvia>
In-Reply-To: <20191207173805.jvunyfnijgefn3z5@salvia>
From:   Justin Forbes <jmforbes@linuxtx.org>
Date:   Mon, 9 Dec 2019 11:56:17 -0600
Message-ID: <CAFxkdAqaOu98H5uaSr2DHrFoa+woB0ypt02y2rtau8x_gFj_eg@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nf_flow_table_offload: Correct memcpy size for flow_overload_mangle
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Laura Abbott <labbott@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 7, 2019 at 11:38 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Fri, Dec 06, 2019 at 04:58:30PM -0600, Justin Forbes wrote:
> > On Tue, Dec 3, 2019 at 2:50 PM Laura Abbott <labbott@redhat.com> wrote:
> > >
> > > On 12/3/19 12:01 PM, Marcelo Ricardo Leitner wrote:
> > > > On Tue, Dec 03, 2019 at 11:03:45AM -0500, Laura Abbott wrote:
> > > >> The sizes for memcpy in flow_offload_mangle don't match
> > > >> the source variables, leading to overflow errors on some
> > > >> build configurations:
> > > >>
> > > >> In function 'memcpy',
> > > >>      inlined from 'flow_offload_mangle' at net/netfilter/nf_flow_table_offload.c:112:2,
> > > >>      inlined from 'flow_offload_port_dnat' at net/netfilter/nf_flow_table_offload.c:373:2,
> > > >>      inlined from 'nf_flow_rule_route_ipv4' at net/netfilter/nf_flow_table_offload.c:424:3:
> > > >> ./include/linux/string.h:376:4: error: call to '__read_overflow2' declared with attribute error: detected read beyond size of object passed as 2nd parameter
> > > >>    376 |    __read_overflow2();
> > > >>        |    ^~~~~~~~~~~~~~~~~~
> > > >> make[2]: *** [scripts/Makefile.build:266: net/netfilter/nf_flow_table_offload.o] Error 1
> > > >>
> > > >> Fix this by using the corresponding type.
> > > >>
> > > >> Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
> > > >> Signed-off-by: Laura Abbott <labbott@redhat.com>
> > > >> ---
> > > >> Seen on a Fedora powerpc little endian build with -O3 but it looks like
> > > >> it is correctly catching an error with doing a memcpy outside the source
> > > >> variable.
> > > >
> > > > Hi,
> > > >
> > > > It is right but the fix is not. In that call trace:
> > > >
> > > > flow_offload_port_dnat() {
> > > > ...
> > > >          u32 mask = ~htonl(0xffff);
> > > >          __be16 port;
> > > > ...
> > > >          flow_offload_mangle(entry, flow_offload_l4proto(flow), offset,
> > > >                                   (u8 *)&port, (u8 *)&mask);
> > > > }
> > > >
> > > > port should have a 32b storage as well, and aligned with the mask.
> > > >
> > > >> ---
> > > >>   net/netfilter/nf_flow_table_offload.c | 4 ++--
> > > >>   1 file changed, 2 insertions(+), 2 deletions(-)
> > > >>
> > > >> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> > > >> index c54c9a6cc981..526f894d0bdb 100644
> > > >> --- a/net/netfilter/nf_flow_table_offload.c
> > > >> +++ b/net/netfilter/nf_flow_table_offload.c
> > > >> @@ -108,8 +108,8 @@ static void flow_offload_mangle(struct flow_action_entry *entry,
> > > >>      entry->id = FLOW_ACTION_MANGLE;
> > > >>      entry->mangle.htype = htype;
> > > >>      entry->mangle.offset = offset;
> > > >> -    memcpy(&entry->mangle.mask, mask, sizeof(u32));
> > > >> -    memcpy(&entry->mangle.val, value, sizeof(u32));
> > > >                                     ^^^^^         ^^^ which is &port in the call above
> > > >> +    memcpy(&entry->mangle.mask, mask, sizeof(u8));
> > > >> +    memcpy(&entry->mangle.val, value, sizeof(u8));
> > > >
> > > > This fix would cause it to copy only the first byte, which is not the
> > > > intention.
> > > >
> > >
> > > Thanks for the review. I took another look at fixing this and I
> > > think it might be better for the maintainer or someone who is more
> > > familiar with the code to fix this. I ended up down a rabbit
> > > hole trying to get the types to work and I wasn't confident about
> > > the casting.
> >
> > Any update on this? It is definitely a problem on PPC LE.
>
> I'm attaching a tentative patch to address this problem.
>
This patch does in fact fix the build issue.

Thanks,
Justin
