Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC8934D4DA
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 18:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhC2QX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 12:23:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52763 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231192AbhC2QXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 12:23:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617035004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x/aYAUvWB711QPexKZbhR4TR0UH2bQY9H3I5ishpIwA=;
        b=TUTg+wj+yOjnIDRxbuR0Yd+Rj4UAezHXOt2kOSik8Hmu6HhwsNhSuE6F3UNlXyhINIuTb3
        JOwWTlNkXwR5zV2sim0ABueFm+8iu9Q43EusOp9/upgeIaGolMQ2QNaaglTlGyesbTRxvk
        eJ4PCxb3xmGGkSWgHJp45TE7ymFSW1E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-qjHnTjKPNzqtnsQh-32TYg-1; Mon, 29 Mar 2021 12:23:20 -0400
X-MC-Unique: qjHnTjKPNzqtnsQh-32TYg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81A81802B7E;
        Mon, 29 Mar 2021 16:23:18 +0000 (UTC)
Received: from ovpn-114-151.ams2.redhat.com (ovpn-114-151.ams2.redhat.com [10.36.114.151])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95C8C5D9F0;
        Mon, 29 Mar 2021 16:23:16 +0000 (UTC)
Message-ID: <dc7a2ef8286516e805df7cae21f2b193d8da9761.camel@redhat.com>
Subject: Re: [PATCH net-next v2 1/8] udp: fixup csum for GSO receive slow
 path
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Date:   Mon, 29 Mar 2021 18:23:15 +0200
In-Reply-To: <CA+FuTScQW-jYCHksXk=85Ssa=HWWce7103A=Y69uduNzpfd6cA@mail.gmail.com>
References: <cover.1616692794.git.pabeni@redhat.com>
         <28d04433c648ea8143c199459bfe60650b1a0d28.1616692794.git.pabeni@redhat.com>
         <CA+FuTSed_T6+QbdgEUCo2Qy39mH1AVRoPqFYvt_vkRiFxfW7ZA@mail.gmail.com>
         <c7ee2326473578aa1600bf7c062f37c01e95550a.camel@redhat.com>
         <CA+FuTSfMgXog6AMhNg8H5mBTKTXYMhUG8_KvcKNYF5VS+hiroQ@mail.gmail.com>
         <1a33dd110b4b43a7d65ce55e13bff4a69b89996c.camel@redhat.com>
         <CA+FuTSduw1eK+CuEgzzwA+6QS=QhMhFQpgyVGH2F8aNH5gwv5A@mail.gmail.com>
         <c296fa344bacdcd23049516e8404931abc70b793.camel@redhat.com>
         <CA+FuTScQW-jYCHksXk=85Ssa=HWWce7103A=Y69uduNzpfd6cA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-03-29 at 11:24 -0400, Willem de Bruijn wrote:
> On Mon, Mar 29, 2021 at 11:01 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > On Mon, 2021-03-29 at 09:52 -0400, Willem de Bruijn wrote:
> > > > +       if (skb->ip_summed == CHECKSUM_NONE && !skb->csum_valid)
> > > > +               skb->csum_valid = 1;
> > > 
> > > Not entirely obvious is that UDP packets arriving on a device with rx
> > > checksum offload off, i.e., with CHECKSUM_NONE, are not matched by
> > > this test.
> > > 
> > > I assume that such packets are not coalesced by the GRO layer in the
> > > first place. But I can't immediately spot the reason for it..
> 
> As you point out, such packets will already have had their checksum
> verified at this point, so this branch only matches tunneled packets.
> That point is just not immediately obvious from the code.

I understand is a matter of comment clarity ?!?

I'll rewrite the related code comment - in udp_post_segment_fix_csum()
- as:

	/* UDP packets generated with UDP_SEGMENT and traversing:
	 *
         * UDP tunnel(xmit) -> veth (segmentation) -> veth (gro) -> UDP tunnel (rx)
	 * 
         * land here with CHECKSUM_NONE, because __iptunnel_pull_header() converts
         * CHECKSUM_PARTIAL into NONE.
	 * SKB_GSO_UDP_L4 or SKB_GSO_FRAGLIST packets with no UDP tunnel will land
	 * here with valid checksum, as the GRO engine validates the UDP csum
	 * before the aggregation and nobody strips such info in between.
	 * Instead of adding another check in the tunnel fastpath, we can force
	 * a valid csum here.
         * Additionally fixup the UDP CB.
         */

Would that be clear enough?

> > I do see checksum validation in the GRO engine for CHECKSUM_NONE UDP
> > packet prior to this series.
> > 
> > I *think* the checksum-and-copy optimization is lost
> > since 573e8fca255a27e3573b51f9b183d62641c47a3d.
> 
> Wouldn't this have been introduced with UDP_GRO?

Uhmm.... looks like the checksum-and-copy optimization has been lost
and recovered a few times. I think the last one
with 9fd1ff5d2ac7181844735806b0a703c942365291, which move the csum
validation before the static branch on udp_encap_needed_key.

Can we agree re-introducing the optimization is independent from this
series?

Thanks!

Paolo


