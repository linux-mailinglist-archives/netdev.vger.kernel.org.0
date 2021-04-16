Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB5836273C
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 19:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243934AbhDPRxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 13:53:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50770 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243916AbhDPRxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 13:53:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618595588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q8wN6Vz7h1mTgh45gac0QdkeBJiXZJoOcn6X1iVFLj8=;
        b=fINs5JQGXUu4XuJNhD89y+0ieg5TrSP6H3/qAU1hmopX1Ri2efFLq5IBKfCi7j2ajlm42z
        C4xzw/wrUecyyiVa5+tcaktl/SUT2zmfQytIRCAxmW/uC6QL97X2E4lHm4XZOrEfd7YNJU
        eTtNrqcHIxf1EDW0HKlfuDxSIRm5yXM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-Nl8FxM20ODWQnGUgtomTMw-1; Fri, 16 Apr 2021 13:53:06 -0400
X-MC-Unique: Nl8FxM20ODWQnGUgtomTMw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1145100A67C;
        Fri, 16 Apr 2021 17:53:04 +0000 (UTC)
Received: from ovpn-114-195.ams2.redhat.com (ovpn-114-195.ams2.redhat.com [10.36.114.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9EC259479;
        Fri, 16 Apr 2021 17:52:59 +0000 (UTC)
Message-ID: <b2c333ce0d3d32719f1813dee11b243654b5a2f8.camel@redhat.com>
Subject: Re: [PATCH net-next] veth: check for NAPI instead of xdp_prog
 before xmit of XDP frame
From:   Paolo Abeni <pabeni@redhat.com>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Fri, 16 Apr 2021 19:52:58 +0200
In-Reply-To: <20210416154745.238804-1-toke@redhat.com>
References: <20210416154745.238804-1-toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-04-16 at 17:47 +0200, Toke Høiland-Jørgensen wrote:
> The recent patch that tied enabling of veth NAPI to the GRO flag also has
> the nice side effect that a veth device can be the target of an
> XDP_REDIRECT without an XDP program needing to be loaded on the peer
> device. However, the patch adding this extra NAPI mode didn't actually
> change the check in veth_xdp_xmit() to also look at the new NAPI pointer,
> so let's fix that.
> 
> Fixes: 6788fa154546 ("veth: allow enabling NAPI even without XDP")
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  drivers/net/veth.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 15b2e3923c47..bdb7ce3cb054 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -486,11 +486,10 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
>  
>  	rcv_priv = netdev_priv(rcv);
>  	rq = &rcv_priv->rq[veth_select_rxq(rcv)];
> -	/* Non-NULL xdp_prog ensures that xdp_ring is initialized on receive
> -	 * side. This means an XDP program is loaded on the peer and the peer
> -	 * device is up.
> +	/* The napi pointer is set if NAPI is enabled, which ensures that
> +	 * xdp_ring is initialized on receive side and the peer device is up.
>  	 */
> -	if (!rcu_access_pointer(rq->xdp_prog))
> +	if (!rcu_access_pointer(rq->napi))
>  		goto out;
>  
>  	max_len = rcv->mtu + rcv->hard_header_len + VLAN_HLEN;

Acked-by: Paolo Abeni <pabeni@redhat.com>

Thanks for the quick turn-around!

