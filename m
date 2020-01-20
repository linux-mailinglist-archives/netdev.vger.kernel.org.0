Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 794101425A1
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 09:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgATIf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 03:35:27 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:47964 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgATIf1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jan 2020 03:35:27 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id D1B972009B;
        Mon, 20 Jan 2020 09:35:24 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id mm0pOLf4caNm; Mon, 20 Jan 2020 09:35:24 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 989A120519;
        Mon, 20 Jan 2020 09:35:19 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Mon, 20 Jan 2020
 09:35:19 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 023CF318032D;
 Mon, 20 Jan 2020 09:35:18 +0100 (CET)
Date:   Mon, 20 Jan 2020 09:35:18 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/4] net: Support GRO/GSO fraglist chaining.
Message-ID: <20200120083518.GL23018@gauss3.secunet.de>
References: <20191218133458.14533-1-steffen.klassert@secunet.com>
 <20191218133458.14533-4-steffen.klassert@secunet.com>
 <CA+FuTScnux23Gj1WTEXHmZkiFG3RQsgmSz19TOWdWByM4Rd15Q@mail.gmail.com>
 <20191219082246.GS8621@gauss3.secunet.de>
 <CA+FuTScKcwyh7rZdDNQsujndrA+ZnYMmtA7Uh7-ji+RM+t6-hQ@mail.gmail.com>
 <20200113085128.GH8621@gauss3.secunet.de>
 <CA+FuTSc3sOuPsQ3sJSCudCwZky4FcGF5CopejURmGZUSjXEn3Q@mail.gmail.com>
 <20200115094733.GP8621@gauss3.secunet.de>
 <CA+FuTSeF06hJstQBH4eL4L3=yGdiizw_38BUheYyircW8E3cXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+FuTSeF06hJstQBH4eL4L3=yGdiizw_38BUheYyircW8E3cXg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 10:43:08AM -0500, Willem de Bruijn wrote:
> > > > Maybe we can be conservative here and do a full
> > > > __copy_skb_header for now. The initial version
> > > > does not necessarily need to be the most performant
> > > > version. We could try to identify the correct subset
> > > > of header fields later then.
> > >
> > > We should probably aim for the right set from the start. If you think
> > > this set is it, let's keep it.
> >
> > I'd prefer to do a full __copy_skb_header for now and think a bit
> > longer if that what I chose is really the correct subset.
> 
> Ok
> 
> > > > > > I had to set ip_summed to CHECKSUM_UNNECESSARY on GRO to
> > > > > > make sure the noone touches the checksum of the head
> > > > > > skb. Otherise netfilter etc. tries to touch the csum.
> > > > > >
> > > > > > Before chaining I make sure that ip_summed and csum_level is
> > > > > > the same for all chained skbs and here I restore the original
> > > > > > value from nskb.
> > > > >
> > > > > This is safe because the skb_gro_checksum_validate will have validated
> > > > > already on CHECKSUM_PARTIAL? What happens if there is decap or encap
> > > > > in the path? We cannot revert to CHECKSUM_PARTIAL after that, I
> > > > > imagine.
> > > >
> > > > Yes, the checksum is validated with skb_gro_checksum_validate. If the
> > > > packets are UDP encapsulated, they are segmented before decapsulation.
> > > > Original values are already restored. If an additional encapsulation
> > > > happens, the encap checksum will be calculated after segmentation.
> > > > Original values are restored before that.
> > >
> > > I was wondering more about additional other encapsulation protocols.
> > >
> > > >From a quick read, it seems like csum_level is associated only with
> > > CHECKSUM_UNNECESSARY.
> > >
> > > What if a device returns CHECKSUM_COMPLETE for packets with a tunnel
> > > that is decapsulated before forwarding. Say, just VLAN. That gets
> > > untagged in __netif_receive_skb_core with skb_vlan_untag calling
> > > skb_pull_rcsum. After segmentation the ip_summed is restored, with
> > > skb->csum still containing the unmodified csum that includes the VLAN
> > > tag?
> >
> > Hm, that could be really a problem. So setting CHECKSUM_UNNECESSARY
> > should be ok, but restoring the old values are not. Our checksum
> > magic is rather complex, it's hard to get it right for all possible
> > cases. Maybe we can just set CHECKSUM_UNNECESSARY for all packets
> > and keep this value after segmentation.
> 
> Note that I'm not 100% sure that the issue can occur. But it seems likely.
> 
> Yes, inverse CHECKSUM_UNNECESSARY conversion after verifying the checksum is
> probably the way to go. Inverse, because it is the opposite of
> __skb_gro_checksum_convert.

I'm not sure if I understand what you mean here. I'd do the following
for fraglist GRO in udp4_gro_complete:

        if (skb->ip_summed == CHECKSUM_UNNECESSARY) {
                if (skb->csum_level < SKB_MAX_CSUM_LEVEL)
                        skb->csum_level++;
        } else {
                skb->ip_summed = CHECKSUM_UNNECESSARY;
                skb->csum_level = 0;
        }

and then copy these values to the segments after segmentation.

