Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21B7A161B1
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 12:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfEGKJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 06:09:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59668 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbfEGKJF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 06:09:05 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ABEDA81F19;
        Tue,  7 May 2019 10:09:04 +0000 (UTC)
Received: from carbon (ovpn-200-42.brq.redhat.com [10.40.200.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 85C6617164;
        Tue,  7 May 2019 10:08:59 +0000 (UTC)
Date:   Tue, 7 May 2019 12:08:57 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@mellanox.com>, brouer@redhat.com,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH net-next 1/2] net: Take common prefetch code structure
 into a function
Message-ID: <20190507120857.5975c059@carbon>
In-Reply-To: <20190506165157.6e0f04e6@cakuba.hsd1.ca.comcast.net>
References: <1557052567-31827-1-git-send-email-tariqt@mellanox.com>
        <1557052567-31827-2-git-send-email-tariqt@mellanox.com>
        <20190506165157.6e0f04e6@cakuba.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 07 May 2019 10:09:04 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 May 2019 16:51:57 -0700
Jakub Kicinski <jakub.kicinski@netronome.com> wrote:

> On Sun,  5 May 2019 13:36:06 +0300, Tariq Toukan wrote:
> > Many device drivers use the same prefetch code structure to
> > deal with small L1 cacheline size.
> > Take this code into a function and call it from the drivers.
> > 
> > Suggested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> > Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> > Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
> > Cc: Jesper Dangaard Brouer <brouer@redhat.com>  
> 
> We could bike shed on the name a little - net_prefetch_headers() ?
> but at least a short kdoc explanation for the purpose of this helper
> would be good IMHO.

I would at least improve the commit message.  As Alexander so nicely
explained[1], this prefetch purpose: "the 2 prefetches are needed for x86
if you want a full TCP or IPv6 header pulled into the L1 cache for
instance."  Although, this is not true for a minimum TCP-packet
Eth(14)+IP(20)+TCP(20)=54 bytes. An I missing an alignment in my calc?

[1] https://lore.kernel.org/netdev/CAKgT0UeEL3W42eDqSt97xnn3tXDtWMf4sdPByAtvbx=Z7Sx7hQ@mail.gmail.com/

The name net_prefetch_headers() suggested by Jakub makes sense, as this
indicate that this should be used for prefetching packet headers.

As Alexander also explained, I was wrong in thinking the HW DCU (Data
Cache Unit) prefetcher will fetch two cache-lines automatically.  As
the DCU prefetcher is a streaming prefetcher, and doesn't see our
access pattern, which is why we need this.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
