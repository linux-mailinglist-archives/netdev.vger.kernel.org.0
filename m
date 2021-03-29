Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21ED334D10F
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 15:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhC2NZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 09:25:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55597 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229479AbhC2NYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 09:24:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617024284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gSe9kjLk6MVajmRYE3K2ERfETj0lAR+bKrJd8FwDSv4=;
        b=cVcWStuBplnSzfUb+zeMWLiebsyD5Ep7IExWpHNLF0/e6BTmpJYtDGL9urJyufm1Oyy87J
        //4nGF33C3xhpthg3GKuSKa8KgKAeWWf8V9A5KW6H9uQHU80Q4TnxuV0iRAUUkkWYqCWTJ
        GRGWOnTwBRJ8TgoVV3Niib0ZsyRsnAc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-Kj0jptLUNHmT0Ojz7DgmRg-1; Mon, 29 Mar 2021 09:24:40 -0400
X-MC-Unique: Kj0jptLUNHmT0Ojz7DgmRg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77E418018AD;
        Mon, 29 Mar 2021 13:24:38 +0000 (UTC)
Received: from ovpn-114-151.ams2.redhat.com (ovpn-114-151.ams2.redhat.com [10.36.114.151])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5FFACBA6F;
        Mon, 29 Mar 2021 13:24:36 +0000 (UTC)
Message-ID: <1a33dd110b4b43a7d65ce55e13bff4a69b89996c.camel@redhat.com>
Subject: Re: [PATCH net-next v2 1/8] udp: fixup csum for GSO receive slow
 path
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Date:   Mon, 29 Mar 2021 15:24:35 +0200
In-Reply-To: <CA+FuTSfMgXog6AMhNg8H5mBTKTXYMhUG8_KvcKNYF5VS+hiroQ@mail.gmail.com>
References: <cover.1616692794.git.pabeni@redhat.com>
         <28d04433c648ea8143c199459bfe60650b1a0d28.1616692794.git.pabeni@redhat.com>
         <CA+FuTSed_T6+QbdgEUCo2Qy39mH1AVRoPqFYvt_vkRiFxfW7ZA@mail.gmail.com>
         <c7ee2326473578aa1600bf7c062f37c01e95550a.camel@redhat.com>
         <CA+FuTSfMgXog6AMhNg8H5mBTKTXYMhUG8_KvcKNYF5VS+hiroQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-03-29 at 08:28 -0400, Willem de Bruijn wrote:
> On Mon, Mar 29, 2021 at 7:26 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > On Fri, 2021-03-26 at 14:30 -0400, Willem de Bruijn wrote:
> > > On Thu, Mar 25, 2021 at 1:24 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > > > When UDP packets generated locally by a socket with UDP_SEGMENT
> > > > traverse the following path:
> > > > 
> > > > UDP tunnel(xmit) -> veth (segmentation) -> veth (gro) ->
> > > >         UDP tunnel (rx) -> UDP socket (no UDP_GRO)
> > > > 
> > > > they are segmented as part of the rx socket receive operation, and
> > > > present a CHECKSUM_NONE after segmentation.
> > > 
> > > would be good to capture how this happens, as it was not immediately obvious.
> > 
> > The CHECKSUM_PARTIAL is propagated up to the UDP tunnel processing,
> > where we have:
> > 
> >         __iptunnel_pull_header() -> skb_pull_rcsum() ->
> > skb_postpull_rcsum() -> __skb_postpull_rcsum() and the latter do the
> > conversion.
> 
> Please capture this in the commit message.

I will do.

> > > > Additionally the segmented packets UDP CB still refers to the original
> > > > GSO packet len. Overall that causes unexpected/wrong csum validation
> > > > errors later in the UDP receive path.
> > > > 
> > > > We could possibly address the issue with some additional checks and
> > > > csum mangling in the UDP tunnel code. Since the issue affects only
> > > > this UDP receive slow path, let's set a suitable csum status there.
> > > > 
> > > > v1 -> v2:
> > > >  - restrict the csum update to the packets strictly needing them
> > > >  - hopefully clarify the commit message and code comments
> > > > 
> > > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > > +       if (skb->ip_summed == CHECKSUM_NONE && !skb->csum_valid)
> > > > +               skb->csum_valid = 1;
> > > 
> > > Not entirely obvious is that UDP packets arriving on a device with rx
> > > checksum offload off, i.e., with CHECKSUM_NONE, are not matched by
> > > this test.
> > > 
> > > I assume that such packets are not coalesced by the GRO layer in the
> > > first place. But I can't immediately spot the reason for it..
> > 
> > Packets with CHECKSUM_NONE are actually aggregated by the GRO engine.
> > 
> > Their checksum is validated by:
> > 
> > udp4_gro_receive -> skb_gro_checksum_validate_zero_check()
> >         -> __skb_gro_checksum_validate -> __skb_gro_checksum_validate_complete()
> > 
> > and skb->ip_summed is changed to CHECKSUM_UNNECESSARY by:
> > 
> > __skb_gro_checksum_validate -> skb_gro_incr_csum_unnecessary
> >         -> __skb_incr_checksum_unnecessary()
> > 
> > and finally to CHECKSUM_PARTIAL by:
> > 
> > udp4_gro_complete() -> udp_gro_complete() -> udp_gro_complete_segment()
> > 
> > Do you prefer I resubmit with some more comments, either in the commit
> > message or in the code?
> 
> That breaks the checksum-and-copy optimization when delivering to
> local sockets. I wonder if that is a regression.

The conversion to CHECKSUM_UNNECESSARY happens since
commit 573e8fca255a27e3573b51f9b183d62641c47a3d.

Even the conversion to CHECKSUM_PARTIAL happens independently from this
series, since commit 6f1c0ea133a6e4a193a7b285efe209664caeea43.

I don't see a regression here ?!?

Thanks!

Paolo

