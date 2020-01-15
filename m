Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 751EC13BCB6
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 10:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729536AbgAOJrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 04:47:36 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:35892 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729497AbgAOJrf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 04:47:35 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 42A59201E4;
        Wed, 15 Jan 2020 10:47:34 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id GE3sKTFuVl9K; Wed, 15 Jan 2020 10:47:33 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B5409200A3;
        Wed, 15 Jan 2020 10:47:33 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 15 Jan 2020
 10:47:33 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 18EDC318021B;
 Wed, 15 Jan 2020 10:47:33 +0100 (CET)
Date:   Wed, 15 Jan 2020 10:47:33 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/4] net: Support GRO/GSO fraglist chaining.
Message-ID: <20200115094733.GP8621@gauss3.secunet.de>
References: <20191218133458.14533-1-steffen.klassert@secunet.com>
 <20191218133458.14533-4-steffen.klassert@secunet.com>
 <CA+FuTScnux23Gj1WTEXHmZkiFG3RQsgmSz19TOWdWByM4Rd15Q@mail.gmail.com>
 <20191219082246.GS8621@gauss3.secunet.de>
 <CA+FuTScKcwyh7rZdDNQsujndrA+ZnYMmtA7Uh7-ji+RM+t6-hQ@mail.gmail.com>
 <20200113085128.GH8621@gauss3.secunet.de>
 <CA+FuTSc3sOuPsQ3sJSCudCwZky4FcGF5CopejURmGZUSjXEn3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+FuTSc3sOuPsQ3sJSCudCwZky4FcGF5CopejURmGZUSjXEn3Q@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 13, 2020 at 11:21:07AM -0500, Willem de Bruijn wrote:
> On Mon, Jan 13, 2020 at 3:51 AM Steffen Klassert
> <steffen.klassert@secunet.com> wrote:
> >
> > On Thu, Dec 19, 2019 at 11:28:34AM -0500, Willem de Bruijn wrote:
> > > On Thu, Dec 19, 2019 at 3:22 AM Steffen Klassert
> > > <steffen.klassert@secunet.com> wrote:
> > > >
> > > > I tried to find the subset of __copy_skb_header() that is needed to copy.
> > > > Some fields of nskb are still valid, and some (csum related) fields
> > > > should not be copied from skb to nskb.
> > >
> > > Duplicating that code is kind of fragile wrt new fields being added to
> > > skbs later (such as the recent skb_ext example).
> > >
> > > Perhaps we can split __copy_skb_header further and call the
> > > inner part directly.
> >
> > I thought already about that, but __copy_skb_header does a
> > memcpy over all the header fields. If we split this, we
> > would need change the memcpy to direct assignments.
> 
> Okay, if any of those fields should not be overwritten in this case,
> then that's not an option. That memcpy is probably a lot more
> efficient than all the direct assignments.
> 
> > Maybe we can be conservative here and do a full
> > __copy_skb_header for now. The initial version
> > does not necessarily need to be the most performant
> > version. We could try to identify the correct subset
> > of header fields later then.
> 
> We should probably aim for the right set from the start. If you think
> this set is it, let's keep it.

I'd prefer to do a full __copy_skb_header for now and think a bit
longer if that what I chose is really the correct subset.

> > > > I had to set ip_summed to CHECKSUM_UNNECESSARY on GRO to
> > > > make sure the noone touches the checksum of the head
> > > > skb. Otherise netfilter etc. tries to touch the csum.
> > > >
> > > > Before chaining I make sure that ip_summed and csum_level is
> > > > the same for all chained skbs and here I restore the original
> > > > value from nskb.
> > >
> > > This is safe because the skb_gro_checksum_validate will have validated
> > > already on CHECKSUM_PARTIAL? What happens if there is decap or encap
> > > in the path? We cannot revert to CHECKSUM_PARTIAL after that, I
> > > imagine.
> >
> > Yes, the checksum is validated with skb_gro_checksum_validate. If the
> > packets are UDP encapsulated, they are segmented before decapsulation.
> > Original values are already restored. If an additional encapsulation
> > happens, the encap checksum will be calculated after segmentation.
> > Original values are restored before that.
> 
> I was wondering more about additional other encapsulation protocols.
> 
> >From a quick read, it seems like csum_level is associated only with
> CHECKSUM_UNNECESSARY.
> 
> What if a device returns CHECKSUM_COMPLETE for packets with a tunnel
> that is decapsulated before forwarding. Say, just VLAN. That gets
> untagged in __netif_receive_skb_core with skb_vlan_untag calling
> skb_pull_rcsum. After segmentation the ip_summed is restored, with
> skb->csum still containing the unmodified csum that includes the VLAN
> tag?

Hm, that could be really a problem. So setting CHECKSUM_UNNECESSARY
should be ok, but restoring the old values are not. Our checksum
magic is rather complex, it's hard to get it right for all possible
cases. Maybe we can just set CHECKSUM_UNNECESSARY for all packets
and keep this value after segmentation.
