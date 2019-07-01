Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28EF45BA42
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 13:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbfGALBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 07:01:41 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39583 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727162AbfGALBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 07:01:40 -0400
Received: by mail-ot1-f67.google.com with SMTP id r21so12374570otq.6
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 04:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S4HqqhX/CAL2co4lltsJBBgnATx3Snt7AT+ErzueQmc=;
        b=L0hszdzuk4Gr4bO1HGgJfgttpqY06rAHAh3HCUx+CeZyemRQbePeIjkX9oM2gPWhhB
         NJFxuS1OYwFytiYq56hDU4wi2zPOYtixc8dYaX9E1JN4oA3QyGIBmBKfxCfo4ioiRjg/
         gf7kG9iwJs+1nThYLOapU3lzYagRb7SQM+J1U4xwWQCtEhag2KkiKq7BcfcNpUbr9eEI
         y6/GvKXfaIMXDbYndCpjnF12VipqHC2Khu7EpDke1C9/oInEMk3ig7Ylg90RoTTYRWqc
         ErbTiS9ppHODUa0sMuLppN3p0hfqGfwZqvl0XJEltLzOrawkT6TMtV35mvRMO+wNdV3L
         cy6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S4HqqhX/CAL2co4lltsJBBgnATx3Snt7AT+ErzueQmc=;
        b=g5SmSPORxK1czzXaXhtwqqBZfULOT+WdEKabbrmf+1IiiT0ppBtGomfdOnXwrovgKT
         sPinXgL6pq8bKsNBT9G6bnkmHCWpVSFK+hXUmsQ/TQ44lGLrg4jA96Z5eRDSiSHbdpB+
         QSib0eTtZUa20o+ffbHvaX5FmusEgrbX1KlojSVuFC03BvFQ8x3+dCsgn6K7uWyY3ry+
         Uo63A71uFOlnijTGDn6EbBWu9acYFqGr0u+GR/JNXhgpE/6/jGAimF/ILdTGFK2JDexc
         3pTvX7xzuZp6nZhWMZeRIpRBHOGONI0YPzHB8lvFSuzaODXa4s0faBKx8dQUbvIvfho1
         yZ7g==
X-Gm-Message-State: APjAAAWknGAGQsJ1ZJ0/PhEsAeWs4HPVIOk91rj0uklbMlsjID5eymt6
        zllfOfM81wjsjjKcvWJQ8QjoYRCP3gZgvwSNk4s=
X-Google-Smtp-Source: APXvYqzv8PEWEcvJ0M/33cu0PTLCJf/u7ObFLpNWsY6GEwdD51GaMi8pbzT+bj531OomFcw9McJ/GYEB4MCglHOHWFw=
X-Received: by 2002:a9d:69ce:: with SMTP id v14mr761831oto.39.1561978899976;
 Mon, 01 Jul 2019 04:01:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190628221555.3009654-1-jonathan.lemon@gmail.com>
In-Reply-To: <20190628221555.3009654-1-jonathan.lemon@gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 1 Jul 2019 13:01:29 +0200
Message-ID: <CAJ8uoz2HGawFdSuGs_1cZ9uEDTPoMHr5-rXK+JOETD3oGwvoFw@mail.gmail.com>
Subject: Re: [PATCH 0/3 bpf-next] intel: AF_XDP support for TX of RX packets
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        jeffrey.t.kirsher@intel.com, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 29, 2019 at 12:18 AM Jonathan Lemon
<jonathan.lemon@gmail.com> wrote:
>
> NOTE: This patch depends on my previous "xsk: reuse cleanup" patch,
> sent to netdev earlier.
>
> The motivation is to have packets which were received on a zero-copy
> AF_XDP socket, and which returned a TX verdict from the bpf program,
> queued directly on the TX ring (if they're in the same napi context).
>
> When these TX packets are completed, they are placed back onto the
> reuse queue, as there isn't really any other place to handle them.
>
> Space in the reuse queue is preallocated at init time for both the
> RX and TX rings.  Another option would have a smaller TX queue size
> and count in-flight TX packets, dropping any which exceed the reuseq
> size - this approach is omitted for simplicity.

This should speed up XDP_TX under ZC substantially, which of course is
a good thing. Would be great if you could add some performance
numbers.

As other people have pointed out, it would have been great if we had a
page pool we could return the buffers to. But we do not so there are
only two options: keep it in the kernel on the reuse queue in this
case, or return the buffer to user space with a length of zero
indicating that there is no packet data. Just a transfer of ownership.
But let us go with the former one as you have done in this patch set,
as we have so far have always tried to reuse the buffers inside the
kernel. But the latter option might be good to have in store as a
solution for other problems.

/Magnus

>
> Jonathan Lemon (3):
>   net: add convert_to_xdp_frame_keep_zc function
>   i40e: Support zero-copy XDP_TX on the RX path for AF_XDP sockets.
>   ixgbe: Support zero-copy XDP_TX on the RX path for AF_XDP sockets.
>
>  drivers/net/ethernet/intel/i40e/i40e_txrx.h  |  1 +
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c   | 54 ++++++++++++--
>  drivers/net/ethernet/intel/ixgbe/ixgbe.h     |  1 +
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 74 +++++++++++++++++---
>  include/net/xdp.h                            | 20 ++++--
>  5 files changed, 134 insertions(+), 16 deletions(-)
>
> --
> 2.17.1
>
