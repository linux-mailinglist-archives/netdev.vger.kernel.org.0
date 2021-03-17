Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5945233F613
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 17:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbhCQQxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 12:53:02 -0400
Received: from mail-40131.protonmail.ch ([185.70.40.131]:32619 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbhCQQwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 12:52:35 -0400
Date:   Wed, 17 Mar 2021 16:52:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1615999953; bh=oM4XbW1q5zcLndEfkaigVcrh9QJicN69T4/u/Yrv6U8=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=iteX186mLmhS6elYvml44AmeEWYOGvi5Jt8tM+3z7X2+504fS+dlDW4xiCA7pzve7
         Bcn8gJ/jImG0946q5irYxwYXsSR7r3fbV0Oi/r1KC/hsOpqKXxMJiH9NZZHjBe1y4s
         n7ALz8cN/JOftpv3ZA4kwm6N2C0gtxwqor1UC6tlrs/cV6oH4ltkClE0TgTFfW3JSA
         inBauo0r8vPB010z8K1rMhl9JTwg8riSkFHpg7zoD+EqTFOafEGNImufGdqEdNq8Qq
         OMCw1NM3dRhDJq1ZeYYlsO/8QJ3BNbPwo8Y3EjID6uLABrh7/B0fdb9Oywfa7C+gtQ
         EBJiaSTzP+MoA==
To:     Jesper Dangaard Brouer <brouer@redhat.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH 0/7 v4] Introduce a bulk order-0 page allocator with two in-tree users
Message-ID: <20210317165220.808975-1-alobakin@pm.me>
In-Reply-To: <20210317173844.6b10f879@carbon>
References: <20210312154331.32229-1-mgorman@techsingularity.net> <20210317163055.800210-1-alobakin@pm.me> <20210317173844.6b10f879@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Wed, 17 Mar 2021 17:38:44 +0100

> On Wed, 17 Mar 2021 16:31:07 +0000
> Alexander Lobakin <alobakin@pm.me> wrote:
>
> > From: Mel Gorman <mgorman@techsingularity.net>
> > Date: Fri, 12 Mar 2021 15:43:24 +0000
> >
> > Hi there,
> >
> > > This series is based on top of Matthew Wilcox's series "Rationalise
> > > __alloc_pages wrapper" and does not apply to 5.12-rc2. If you want to
> > > test and are not using Andrew's tree as a baseline, I suggest using t=
he
> > > following git tree
> > >
> > > git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-bulk-r=
ebase-v4r2
> >
> > I gave this series a go on my setup, it showed a bump of 10 Mbps on
> > UDP forwarding, but dropped TCP forwarding by almost 50 Mbps.
> >
> > (4 core 1.2GHz MIPS32 R2, page size of 16 Kb, Page Pool order-0
> > allocations with MTU of 1508 bytes, linear frames via build_skb(),
> > GRO + TSO/USO)
>
> What NIC driver is this?

Ah, forgot to mention. It's a WIP driver, not yet mainlined.
The NIC itself is basically on-SoC 1G chip.

> > I didn't have time to drill into the code, so for now can't provide
> > any additional details. You can request anything you need though and
> > I'll try to find a window to collect it.
> >
> > > Note to Chuck and Jesper -- as this is a cross-subsystem series, you =
may
> > > want to send the sunrpc and page_pool pre-requisites (patches 4 and 6=
)
> > > directly to the subsystem maintainers. While sunrpc is low-risk, I'm
> > > vaguely aware that there are other prototype series on netdev that af=
fect
> > > page_pool. The conflict should be obvious in linux-next.
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer

Al

