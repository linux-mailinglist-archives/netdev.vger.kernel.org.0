Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8654C2AC3C7
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 19:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729660AbgKISZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 13:25:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:54870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729243AbgKISZU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 13:25:20 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84423206A1;
        Mon,  9 Nov 2020 18:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604946319;
        bh=hdql1xFq0miEbLZKysTkTv5s405pbcvR14kKWYvxEV0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Hg3ezfSmRwBc1P97OKH7Y18aGv7zzMHE+SQvWA354erRji7kaF4sww7OrPGNE1WQ2
         5Ya89DIueuUurkgq842DZQkU9uU9vgaHQl/IDX4B2JGbY9OYcdzTjBTpxGBYdFCDnh
         9vPaeDLHq2JZXWuVgKKzQwGK4tZ0DoOTX7ADsrLw=
Date:   Mon, 9 Nov 2020 10:25:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhu Yanjun <zyjzyj2000@gmail.com>
Cc:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-rdma@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/1] RDMA/rxe: Fetch skb packets from ethernet layer
Message-ID: <20201109102518.6b3d92a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAD=hENdP8sJrBZ7uDEWtatZ3D6bKQY=wBKdM5NQ79xveohAnhQ@mail.gmail.com>
References: <20201107122617.55d0909c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <222b9c1b-9d60-22f3-6097-8abd651cc192@gmail.com>
        <CAD=hENdP8sJrBZ7uDEWtatZ3D6bKQY=wBKdM5NQ79xveohAnhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 8 Nov 2020 13:27:32 +0800 Zhu Yanjun wrote:
> On Sun, Nov 8, 2020 at 1:24 PM Zhu Yanjun <zyjzyj2000@gmail.com> wrote:
> > On Thu, 5 Nov 2020 19:12:01 +0800 Zhu Yanjun wrote:
> >
> > In the original design, in rx, skb packet would pass ethernet
> > layer and IP layer, eventually reach udp tunnel.
> >
> > Now rxe fetches the skb packets from the ethernet layer directly.
> > So this bypasses the IP and UDP layer. As such, the skb packets
> > are sent to the upper protocals directly from the ethernet layer.
> >
> > This increases bandwidth and decreases latency.
> >
> > Signed-off-by: Zhu Yanjun <yanjunz@nvidia.com>
> >
> >
> > Nope, no stealing UDP packets with some random rx handlers.  
> 
> Why? Is there any risks?

Are there risks in layering violations? Yes.

For example - you do absolutely no protocol parsing, checksum
validation, only support IPv4, etc.

Besides it also makes the code far less maintainable, rx_handler is a
singleton, etc. etc.

> > The tunnel socket is a correct approach.  
