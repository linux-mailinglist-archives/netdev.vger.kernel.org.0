Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 403CB34CEDC
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 13:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbhC2L0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 07:26:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48047 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232817AbhC2LZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 07:25:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617017143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iIxb/iNDI5zbjBNS0Yniaj8jlgpWtPmm+zDOrS4XPwg=;
        b=alsEOcmctvnajBG2Odn9Zz2y3IoDLQnr5AiyL3UrNVkxTUm86YnPj18XmNwPwk8BmJAaG1
        R3gBYjYjEl1B3wNKf1Ucgt/pRD678AR73DuycAHZv0kV6aFJkJs2fsVAr8GOKljIEm1QHI
        yOlOfBEyulapjsqKUzelATOXA3N/QyU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-ufn4WtBHODiOhlGKRJny5Q-1; Mon, 29 Mar 2021 07:25:41 -0400
X-MC-Unique: ufn4WtBHODiOhlGKRJny5Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 085641922020;
        Mon, 29 Mar 2021 11:25:40 +0000 (UTC)
Received: from ovpn-114-151.ams2.redhat.com (ovpn-114-151.ams2.redhat.com [10.36.114.151])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2ED50437F;
        Mon, 29 Mar 2021 11:25:37 +0000 (UTC)
Message-ID: <c7ee2326473578aa1600bf7c062f37c01e95550a.camel@redhat.com>
Subject: Re: [PATCH net-next v2 1/8] udp: fixup csum for GSO receive slow
 path
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Date:   Mon, 29 Mar 2021 13:25:37 +0200
In-Reply-To: <CA+FuTSed_T6+QbdgEUCo2Qy39mH1AVRoPqFYvt_vkRiFxfW7ZA@mail.gmail.com>
References: <cover.1616692794.git.pabeni@redhat.com>
         <28d04433c648ea8143c199459bfe60650b1a0d28.1616692794.git.pabeni@redhat.com>
         <CA+FuTSed_T6+QbdgEUCo2Qy39mH1AVRoPqFYvt_vkRiFxfW7ZA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-03-26 at 14:30 -0400, Willem de Bruijn wrote:
> On Thu, Mar 25, 2021 at 1:24 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > When UDP packets generated locally by a socket with UDP_SEGMENT
> > traverse the following path:
> > 
> > UDP tunnel(xmit) -> veth (segmentation) -> veth (gro) ->
> >         UDP tunnel (rx) -> UDP socket (no UDP_GRO)
> > 
> > they are segmented as part of the rx socket receive operation, and
> > present a CHECKSUM_NONE after segmentation.
> 
> would be good to capture how this happens, as it was not immediately obvious.

The CHECKSUM_PARTIAL is propagated up to the UDP tunnel processing,
where we have:

	__iptunnel_pull_header() -> skb_pull_rcsum() ->
skb_postpull_rcsum() -> __skb_postpull_rcsum() and the latter do the
conversion.

> > Additionally the segmented packets UDP CB still refers to the original
> > GSO packet len. Overall that causes unexpected/wrong csum validation
> > errors later in the UDP receive path.
> > 
> > We could possibly address the issue with some additional checks and
> > csum mangling in the UDP tunnel code. Since the issue affects only
> > this UDP receive slow path, let's set a suitable csum status there.
> > 
> > v1 -> v2:
> >  - restrict the csum update to the packets strictly needing them
> >  - hopefully clarify the commit message and code comments
> > 
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > +       if (skb->ip_summed == CHECKSUM_NONE && !skb->csum_valid)
> > +               skb->csum_valid = 1;
> 
> Not entirely obvious is that UDP packets arriving on a device with rx
> checksum offload off, i.e., with CHECKSUM_NONE, are not matched by
> this test.
> 
> I assume that such packets are not coalesced by the GRO layer in the
> first place. But I can't immediately spot the reason for it..

Packets with CHECKSUM_NONE are actually aggregated by the GRO engine. 

Their checksum is validated by:

udp4_gro_receive -> skb_gro_checksum_validate_zero_check()
	-> __skb_gro_checksum_validate -> __skb_gro_checksum_validate_complete() 

and skb->ip_summed is changed to CHECKSUM_UNNECESSARY by:

__skb_gro_checksum_validate -> skb_gro_incr_csum_unnecessary
	-> __skb_incr_checksum_unnecessary()

and finally to CHECKSUM_PARTIAL by:

udp4_gro_complete() -> udp_gro_complete() -> udp_gro_complete_segment()

Do you prefer I resubmit with some more comments, either in the commit
message or in the code?

Thanks

Paolo

side note: perf probe here is fooled by skb->ip_summed being a bitfield
and does not dump the real value. I had to look at skb-
>__pkt_type_offset[0] instead.

