Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B239138D3A
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 09:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbgAMIvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 03:51:31 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:47302 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728682AbgAMIva (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 03:51:30 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 1EFB1201CC;
        Mon, 13 Jan 2020 09:51:29 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tpujcnqV9p54; Mon, 13 Jan 2020 09:51:28 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 9E1C02006F;
        Mon, 13 Jan 2020 09:51:28 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Mon, 13 Jan 2020
 09:51:28 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 483E231801A7;
 Mon, 13 Jan 2020 09:51:28 +0100 (CET)
Date:   Mon, 13 Jan 2020 09:51:28 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/4] net: Support GRO/GSO fraglist chaining.
Message-ID: <20200113085128.GH8621@gauss3.secunet.de>
References: <20191218133458.14533-1-steffen.klassert@secunet.com>
 <20191218133458.14533-4-steffen.klassert@secunet.com>
 <CA+FuTScnux23Gj1WTEXHmZkiFG3RQsgmSz19TOWdWByM4Rd15Q@mail.gmail.com>
 <20191219082246.GS8621@gauss3.secunet.de>
 <CA+FuTScKcwyh7rZdDNQsujndrA+ZnYMmtA7Uh7-ji+RM+t6-hQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+FuTScKcwyh7rZdDNQsujndrA+ZnYMmtA7Uh7-ji+RM+t6-hQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 11:28:34AM -0500, Willem de Bruijn wrote:
> On Thu, Dec 19, 2019 at 3:22 AM Steffen Klassert
> <steffen.klassert@secunet.com> wrote:
> >
> > I tried to find the subset of __copy_skb_header() that is needed to copy.
> > Some fields of nskb are still valid, and some (csum related) fields
> > should not be copied from skb to nskb.
> 
> Duplicating that code is kind of fragile wrt new fields being added to
> skbs later (such as the recent skb_ext example).
> 
> Perhaps we can split __copy_skb_header further and call the
> inner part directly.

I thought already about that, but __copy_skb_header does a
memcpy over all the header fields. If we split this, we
would need change the memcpy to direct assignments.

Maybe we can be conservative here and do a full
__copy_skb_header for now. The initial version
does not necessarily need to be the most performant
version. We could try to identify the correct subset
of header fields later then.

> >
> > I had to set ip_summed to CHECKSUM_UNNECESSARY on GRO to
> > make sure the noone touches the checksum of the head
> > skb. Otherise netfilter etc. tries to touch the csum.
> >
> > Before chaining I make sure that ip_summed and csum_level is
> > the same for all chained skbs and here I restore the original
> > value from nskb.
> 
> This is safe because the skb_gro_checksum_validate will have validated
> already on CHECKSUM_PARTIAL? What happens if there is decap or encap
> in the path? We cannot revert to CHECKSUM_PARTIAL after that, I
> imagine.

Yes, the checksum is validated with skb_gro_checksum_validate. If the
packets are UDP encapsulated, they are segmented before decapsulation.
Original values are already restored. If an additional encapsulation
happens, the encap checksum will be calculated after segmentation.
Original values are restored before that.

> 
> Either way, would you mind briefly documenting the checksum behavior
> in the commit message? It's not trivial and I doubt I'll recall the
> details in six months.

Yes, can do this.

> Really about patch 4: that squashed in a lot of non-trivial scaffolding
> from previous patch 'UDP: enable GRO by default'. Does it make sense
> to keep that in a separate patch? That should be a noop, which we can
> verify. And it makes patch 4 easier to reason about on its own, too.

Patch 4 is not that big, so not sure it that makes really sense.
But I can split out a preparation patch if that is preferred.

Anyway, I likely do another RFC version because we are already
late in the development cycle.
