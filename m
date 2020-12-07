Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F052D0A6F
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 06:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbgLGFwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 00:52:36 -0500
Received: from smtp2.cs.stanford.edu ([171.64.64.26]:45060 "EHLO
        smtp2.cs.Stanford.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgLGFwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 00:52:35 -0500
Received: from mail-lf1-f53.google.com ([209.85.167.53]:43921)
        by smtp2.cs.Stanford.EDU with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92.3)
        (envelope-from <ouster@cs.stanford.edu>)
        id 1km9RC-0003Nt-Fa
        for netdev@vger.kernel.org; Sun, 06 Dec 2020 21:51:55 -0800
Received: by mail-lf1-f53.google.com with SMTP id 23so3298743lfg.10
        for <netdev@vger.kernel.org>; Sun, 06 Dec 2020 21:51:54 -0800 (PST)
X-Gm-Message-State: AOAM5323p4F2M8gMCaaiOsICZCnkC40q7tT6uVxLGn7BY9uRJZ6AiiHd
        rUWgAkuSYmFo8TLMp+jfW2Ajw+5xahtCS3kBzNQ=
X-Google-Smtp-Source: ABdhPJz5tzXTnwEBvSyoj64+NEXC80RKh0rHqMRHeFs6LGokOKNMzaMGJF+8VMVPnRBN3c6j+opCkLznA+NLLKNBabk=
X-Received: by 2002:a05:6512:2008:: with SMTP id a8mr881300lfb.259.1607320313331;
 Sun, 06 Dec 2020 21:51:53 -0800 (PST)
MIME-Version: 1.0
References: <CAGXJAmx_xQr56oiak8k8MC+JPBNi+tQBtTvBRqYVsimmKtW4MA@mail.gmail.com>
 <72f3ea21-b4bd-b5bd-f72f-be415598591f@gmail.com> <CAGXJAmwEEnhX5KBvPZmwOKF_0hhVuGfvbXsoGR=+vB8bGge1sQ@mail.gmail.com>
 <4d5b237b-3439-8242-4d2c-b27f9fcb49ca@gmail.com>
In-Reply-To: <4d5b237b-3439-8242-4d2c-b27f9fcb49ca@gmail.com>
From:   John Ousterhout <ouster@cs.stanford.edu>
Date:   Sun, 6 Dec 2020 21:51:16 -0800
X-Gmail-Original-Message-ID: <CAGXJAmyhULC3g+UGobd_Vo3zUvaxLMLJFXZBD9OY8w4nJhNo1g@mail.gmail.com>
Message-ID: <CAGXJAmyhULC3g+UGobd_Vo3zUvaxLMLJFXZBD9OY8w4nJhNo1g@mail.gmail.com>
Subject: Re: GRO: can't force packet up stack immediately?
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Score: -1.0
X-Spam-Level: 
X-Spam-Checker-Version: SpamAssassin on smtp2.cs.Stanford.EDU
X-Scan-Signature: 8e086a056c9d4443aaf3b84243aabc30
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 4, 2020 at 3:20 AM Edward Cree <ecree.xilinx@gmail.com> wrote:
>
> On 03/12/2020 19:52, John Ousterhout wrote:
> > Homa uses GRO to collect batches of packets for protocol processing,
> > but there are times when it wants to push a batch of packet up through
> > the stack immediately (it doesn't want any more packets to be
> > processed at NAPI level before pushing the batch up). However, I can't
> > see a way to achieve this goal.
> It's kinda hacky, but you might be able to call netif_receive_skb_internal()
>  yourself, and then return ERR_PTR(-EINPROGRESS), so that dev_gro_receive()
>  returns GRO_CONSUMED.
> Of course, you'd need to be careful about out-of-order issues in case
>  any earlier homa packets were still sitting in the rx_list.

It doesn't appear to me that this approach will work, because the
packet I want to force up through the stack is not the new one being
passed into homa_gro_receive, but one of the packets on the list
passed in as the first argument (gro_head in dev_gro_receive).
Removing a packet from this list looks tricky, because it also
requires updating a count in the napi structure, which
homa_gro_receive doesn't have immediate access to. I might be able to
figure out a way to get the napi pointer, but this is starting to feel
pretty hacky (and brittle w.r.t. kernel changes).

BTW, out-of-order issues don't matter for Homa; this is one of the
areas where the "protocol independent" parts of the networking code
build in TCP-specific assumptions, which are either unnecessary or, in
some cases, problematic for Homa.

Thanks anyway for the suggestion.

-John-
