Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7181182FF
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 10:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfLJJFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 04:05:10 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:41059 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbfLJJFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 04:05:09 -0500
Received: by mail-ot1-f65.google.com with SMTP id r27so14837513otc.8;
        Tue, 10 Dec 2019 01:05:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tPekY5KE1OlmnrXzeQ7lGwG+ABY09TaAXjZgxNUA778=;
        b=WBSa2LJ3EdEs6rGos7ldZWofOEoOSC1OSIZSVnChUt70PVnO8gDYieB0yxZdMakA4s
         bMHzLay3jD9rIWGYj9ippXd9Yb7itl99wfNQKHEthmf2L4M2jtJqj6ng9zGIB/eEZWHo
         jNwJgNhzTO82JaXJkTHEyOHFTaXxdIc/zHbBjX6gV3OG/OyTVOti7U/CSrVCS9GQv0I6
         AvP69lLh7P4B1XQ0eIMcD2tT2tPi3QcEugcn6vJHE0s75X374oK3TxUxY964DuwCHzsE
         kgw1YEs2jrYRxC+WuMRMaT4/QOWGfnhJYO7CAP0ttTljc3pOS8CCFRZXxcTTV/vIhS0l
         RKcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tPekY5KE1OlmnrXzeQ7lGwG+ABY09TaAXjZgxNUA778=;
        b=CIt4zGBuWril8oec3Al/+YcuGtkkKWIsxYHoLMuywMK2KDlQ+tpqRDBInXwgRLML3+
         8vUMA8pfnb5ElPyWTnWx6DAIZJQTJyadpwT0/N0/JxH1orONSXdsxK9Uxz9EGJmUvxRW
         hLjJ+kcroC3BeyJFaEwTwVTLWCWhrgG4lcYbCN3K+mLhzXiPqo5ir06nQxgzdMvHXdQM
         EbAvuiNaNMF9eR0ZjJK8husoqzan5xxxzER5jCWyOtX3KW4yWvRBtPWUGfCQKNIqCXt9
         +GAc6csp5PFHrMzxLYzXWpUo91UDmS/qMtXBre0RZF8YRtxR8jft4kQ0+RFstKTcSxlq
         ifww==
X-Gm-Message-State: APjAAAWr22+/1Ntqzln6KGMjgVXYER9hIhbsoTAwDxeC7aFVUoXpsqKZ
        lG5wI+RS3VZhy0dkAVibLHyR8T03Z9cIbLzDEorHTAF5rmI=
X-Google-Smtp-Source: APXvYqy77a+errJwKDFsdbu0D8dhM21aesmoOUWSNreISh6WeugexkF+feJYESrc+OBLI8ffMt4S/2fGDrrCcVyrcMU=
X-Received: by 2002:a9d:5c1:: with SMTP id 59mr25043961otd.192.1575968708856;
 Tue, 10 Dec 2019 01:05:08 -0800 (PST)
MIME-Version: 1.0
References: <1575878189-31860-1-git-send-email-magnus.karlsson@intel.com>
 <1575878189-31860-3-git-send-email-magnus.karlsson@intel.com> <20191210004254.m5cicj3tkc2bhlrd@kafai-mbp>
In-Reply-To: <20191210004254.m5cicj3tkc2bhlrd@kafai-mbp>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 10 Dec 2019 10:04:58 +0100
Message-ID: <CAJ8uoz3o23wbezwLpONts=qTdC1Fr9JK1hD=fkwF4snS2Jdqbg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 02/12] xsk: consolidate to one single cached
 producer pointer
To:     Martin Lau <kafai@fb.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "maciej.fijalkowski@intel.com" <maciej.fijalkowski@intel.com>,
        "maciejromanfijalkowski@gmail.com" <maciejromanfijalkowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 1:43 AM Martin Lau <kafai@fb.com> wrote:
>
> On Mon, Dec 09, 2019 at 08:56:19AM +0100, Magnus Karlsson wrote:
> > Currently, the xsk ring code has two cached producer pointers:
> > prod_head and prod_tail. This patch consolidates these two into a
> > single one called cached_prod to make the code simpler and easier to
> > maintain. This will be in line with the user space part of the the
> > code found in libbpf, that only uses a single cached pointer.
> >
> > The Rx path only uses the two top level functions
> > xskq_produce_batch_desc and xskq_produce_flush_desc and they both use
> > prod_head and never prod_tail. So just move them over to
> > cached_prod.
> >
> > The Tx XDP_DRV path uses xskq_produce_addr_lazy and
> > xskq_produce_flush_addr_n and unnecessarily operates on both prod_tail
> > and prod_cons, so move them over to just use cached_prod by skipping
> prod_cons or prod_head?

Thanks. It should read prod_head. Will fix in a v2.

/Magnus

> > the intermediate step of updating prod_tail.
> >
> > The Tx path in XDP_SKB mode uses xskq_reserve_addr and
> > xskq_produce_addr. They currently use both cached pointers, but we can
> > operate on the global producer pointer in xskq_produce_addr since it
> > has to be updated anyway, thus eliminating the use of both cached
> > pointers. We can also remove the xskq_nb_free in xskq_produce_addr
> > since it is already called in xskq_reserve_addr. No need to do it
> > twice.
> >
> > When there is only one cached producer pointer, we can also simplify
> > xskq_nb_free by removing one argument.
