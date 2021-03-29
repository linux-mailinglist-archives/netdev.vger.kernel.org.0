Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5020334C726
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 10:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbhC2ING (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 04:13:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52267 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231940AbhC2ILh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 04:11:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617005496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hc/IHiZBvCEOWZGDwayCpSIOdIPLRJGkB1tz9DIx69Y=;
        b=LxK3/8unjAIRqum/H8JuaIt5iho4HnuVX+H8gP/ltJ/AbtRpehvm4vniFxWfogYxPEn2cs
        H6cLkIM4ujYebSWlXwTcYDFMA8w3chm8mS/kpQeCcdbjQnunEqwXuvmHukvDJny32DY+0x
        lAF4YvVSZg3RFHj8v7EUr/O4+JnvJtY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-EI-_NAchOXOT7oZLeuCsrA-1; Mon, 29 Mar 2021 04:11:34 -0400
X-MC-Unique: EI-_NAchOXOT7oZLeuCsrA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 174291009E33;
        Mon, 29 Mar 2021 08:11:33 +0000 (UTC)
Received: from ovpn-114-151.ams2.redhat.com (ovpn-114-151.ams2.redhat.com [10.36.114.151])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5E9E5D9D3;
        Mon, 29 Mar 2021 08:11:30 +0000 (UTC)
Message-ID: <846f001b9f4b3d377318ddbe4907f79ff4256019.camel@redhat.com>
Subject: Re: [PATCH net-next v2 4/8] udp: never accept GSO_FRAGLIST packets
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Date:   Mon, 29 Mar 2021 10:11:29 +0200
In-Reply-To: <CA+FuTScNjt0dTEHM8WprhDZ5G3H0Y4af4fg2Xqs+eCCrNtHwVA@mail.gmail.com>
References: <cover.1616692794.git.pabeni@redhat.com>
         <7fa75957409a3f5d14198261a7eddb2bf1bff8e1.1616692794.git.pabeni@redhat.com>
         <CA+FuTScNjt0dTEHM8WprhDZ5G3H0Y4af4fg2Xqs+eCCrNtHwVA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-03-26 at 14:15 -0400, Willem de Bruijn wrote:
> On Thu, Mar 25, 2021 at 1:24 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > Currently the UDP protocol delivers GSO_FRAGLIST packets to
> > the sockets without the expected segmentation.
> > 
> > This change addresses the issue introducing and maintaining
> > a couple of new fields to explicitly accept SKB_GSO_UDP_L4
> > or GSO_FRAGLIST packets. Additionally updates  udp_unexpected_gso()
> > accordingly.
> > 
> > UDP sockets enabling UDP_GRO stil keep accept_udp_fraglist
> > zeroed.
> > 
> > v1 -> v2:
> >  - use 2 bits instead of a whole GSO bitmask (Willem)
> > 
> > Fixes: 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> 
> This looks good to me in principle, thanks for the revision.
> 
> I hadn't fully appreciated that gro_enabled implies accept_udp_l4, but
> not necessarily vice versa.
> 
> It is equivalent to (accept_udp_l4 && !up->gro_receive), right?

In this series, yes. 

> Could the extra bit be avoided with
> 
> "
> +      /* Prefer fraglist GRO unless target is a socket with UDP_GRO,
> +       * which requires all but last segments to be of same gso_size,
> passed in cmsg */
>         if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
> -                NAPI_GRO_CB(skb)->is_flist = sk ? !udp_sk(sk)->gro_enabled: 1;
> +               NAPI_GRO_CB(skb)->is_flist = sk ?
> (!udp_sk(sk)->gro_enabled || udp_sk(sk)->accept_udp_fraglist) : 1;

This is not ovious at all to me.

> +     /* Apply transport layer GRO if forwarding is enabled or the
> flow lands at a local socket */
>        if ((!sk && (skb->dev->features & NETIF_F_GRO_UDP_FWD)) ||
>             (sk && udp_sk(sk)->gro_enabled && !up->encap_rcv) ||
> NAPI_GRO_CB(skb)->is_flist) {
>                 pp = call_gro_receive(udp_gro_receive_segment, head, skb);
>                 return pp;
>         }
> 
> +      /* Continue with tunnel GRO */
> "
> 
> .. not that the extra bit matters a lot. And these two conditions with
> gro_enabled are not very obvious.
> 
> Just a thought.

Overall looks more complex to me. I would keep the extra bit, unless
you have strong opinion.

Side note: I was wondering about a follow-up to simplify the condition:

	if ((!sk && (skb->dev->features & NETIF_F_GRO_UDP_FWD)) ||
             (sk && udp_sk(sk)->gro_enabled && !up->encap_rcv) || NAPI_GRO_CB(skb)->is_flist) {

Since UDP sockets could process (segmenting as needed) unexpected GSO
packets, we could always do 'NETIF_F_GRO_UDP_FWD', when enabled on the
device level. The above becomes:

	if (skb->dev->features & NETIF_F_GRO_UDP_FWD) ||
            (sk && udp_sk(sk)->gro_enabled && !up->encap_rcv) ||
            NAPI_GRO_CB(skb)->is_flist) {

which is hopefully more clear (and simpler). As said, non for this
series anyhow.

Thanks,

Paolo

