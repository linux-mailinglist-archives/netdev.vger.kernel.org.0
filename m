Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195103ED905
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 16:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbhHPOg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 10:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbhHPOgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 10:36:52 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B39C061764;
        Mon, 16 Aug 2021 07:36:20 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id z24so14365007qtn.8;
        Mon, 16 Aug 2021 07:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yFdljhVjDuLng1/MC++vR38rIxpQzuFaE1GasB0pmls=;
        b=cBOyJtXmd5hVdjww4hKERJz1zcGv1w5A/QmeWOBGQM3gpQDSDjsV6FQK9RAzYXInVl
         jkHumf2OTHlHF0rkFN6lDac4MjAFwiVY2eLxc+m2hW+rHuZHMtVoIH7l19xUOPoKgbxl
         sZ5SqXTuiWK7k0uC3iTqhAkUFaUmpA04UaZdca2rHGWGq5mXiW/HQBuHOcy5gr3AMtAo
         Yr8/YdBo/dSzc2bhJcoPpZPqSGJ2bWStjP14KqWpaTTLO1P/RxB64ZmXtXTAIKRg+B6w
         3HFy/sRhP6XhK39NKY0SoFzmRH3A31ZCSWgUI0bKBsWdpDEcM2OWYMT9nMGW68TWm+0x
         uFwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yFdljhVjDuLng1/MC++vR38rIxpQzuFaE1GasB0pmls=;
        b=qHAID+3rrEHvT/xfhzqGT+xB9gPdp3EKtP5bPjFSj+EfghuSvABQWnxAqA+BpRF7E3
         j4giK0UqyxUC+jzhOa/t+vg4sqpizXT9jCzNgneBEZCfYfnIjAzGSzkt31PefixWZKF3
         BFo+ee4bIUbYP45YguEQtxEjIleP7ffmcrm6ksVanYYPz1SkHGEyp0UUCg2xJtVrfWLm
         YxlKJKEwLNOsxBWeRFmVrGFh+v0qwo56qZBbybrXNELPdQzbUAEmYN08qh1SRKbxYX6f
         a4Sj2b1+rqd0n+0l510ypIE+WvE2N7O0yyJrb537HrntYjYrHdb25tAy8h2ro33Bhfpg
         V+pQ==
X-Gm-Message-State: AOAM53273c3uqGJpdvZveXtHoeD/hNbT9FjpPP4sypncdTsAEdei2Ulg
        +L2thwbpx2/ZKszxuAgzQliRN/3w2kQV4uRD11w=
X-Google-Smtp-Source: ABdhPJwkUeKO9sCKGr0Yh4/j+eBi2h5it+Yy85mI/XaLImS7CASfUM3S0i14wK4JeamGjrPQGqcYYCMOVJ3ZEBiw8oE=
X-Received: by 2002:ac8:4643:: with SMTP id f3mr9444893qto.216.1629124579592;
 Mon, 16 Aug 2021 07:36:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210811154557.6935-1-minhquangbui99@gmail.com>
 <721a2e32-c930-ad6b-5055-631b502ed11b@gmail.com> <7f3ecbaf-7759-88ae-53d3-2cc5b1623aff@gmail.com>
 <489f0200-b030-97de-cf3a-2d715b07dfa4@gmail.com> <3f861c1d-bd33-f074-8ef3-eede9bff73c1@gmail.com>
In-Reply-To: <3f861c1d-bd33-f074-8ef3-eede9bff73c1@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 16 Aug 2021 07:35:40 -0700
Message-ID: <CAF=yD-+077uFihRAB0L5xr4pNLFAEnxnoNcCinVE0qt57_6Kwg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] udp: UDP socket send queue repair
To:     Bui Quang Minh <minhquangbui99@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrei Vagin <avagin@gmail.com>, alexander@mihalicyn.com,
        Lese Doru Calin <lesedorucalin01@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 4:52 AM Bui Quang Minh <minhquangbui99@gmail.com> wrote:
>
>
>
> On 8/12/2021 10:51 PM, Eric Dumazet wrote:
> >
> >
> > On 8/12/21 3:46 PM, Bui Quang Minh wrote:
> >>
> >>
> >> On 8/11/2021 11:14 PM, Eric Dumazet wrote:
> >>>
> >>>
> >>> On 8/11/21 5:45 PM, Bui Quang Minh wrote:
> >>>> In this patch, I implement UDP_REPAIR sockoption and a new path in
> >>>> udp_recvmsg for dumping the corked packet in UDP socket's send queue.
> >>>>
> >>>> A userspace program can use recvmsg syscall to get the packet's data and
> >>>> the msg_name information of the packet. Currently, other related
> >>>> information in inet_cork that are set in cmsg are not dumped.
> >>>>
> >>>> While working on this, I was aware of Lese Doru Calin's patch and got some
> >>>> ideas from it.
> >>>
> >>>
> >>> What is the use case for this feature, adding a test in UDP fast path ?
> >>
> >> This feature is used to help CRIU to dump CORKed UDP packet in send queue. I'm sorry for being not aware of the performance perspective here.
> >
> > UDP is not reliable.
> >
> > I find a bit strange we add so many lines of code
> > for a feature trying very hard to to drop _one_ packet.
> >
> > I think a much better changelog would be welcomed.
>
> The reason we want to dump the packet in send queue is to make to state of the
> application consistent. The scenario is that when an application sends UDP
> packets via UDP_CORK socket or with MSG_MORE, CRIU comes and checkpoints the
> application. If we drop the data in send queue, when application restores, it
> sends some more data then turns off the cork and actually sends a packet. The
> receiving side may get that packet but it's unusual that the first part of that
> packet is missing because we drop it. So we try to solve this problem with some
> help from the Linux kernel.

Instead of checkpointing the state, how about making the kernel drop
the next packet.

For instance by setting up->pending to something else than AF_UNSPEC,
AF_INET, AF_INET6 from a new setsockopt and testing for this case in
the udp_sendmsg up->pending slowpath.

udp_sendmsg already calls udp_v6_flush_pending_frames on error when
appending to a pending packet, so returning an error on the next call
after restore and have that imply a flush is acceptable. I would
introduce a new error code.

The state can perhaps be inferred in other ways, e.g., from
up->pending && !up->len or up->pending && !skb_peek_tail(queue). But
an explicit up->pending mode will be easier to grasp.
