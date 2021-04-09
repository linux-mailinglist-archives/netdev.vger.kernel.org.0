Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9E135A1B0
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 17:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbhDIPII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 11:08:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27758 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233878AbhDIPII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 11:08:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617980874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EfS8kVqGOqskdOx2fXWHWDecmRqIDaFnOJp5F2A8YHU=;
        b=aVjYxBas9NUTk1KJWm2hFnO3Hao9986RM94tBKA//ffr3+eYW8Aa488Fnz4uVTjUb+gvjC
        wsA7eRyvPOVRIVUoLOPTgzSbam8nS3Alp7vQmDqFe0EuHa/lPtzlH01xgVFidr42Gut8WE
        WW+oUMSqrGFComP7Hmqq19cL91uiK5w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-lvn4bjTVN_qTJC4lFHYfsg-1; Fri, 09 Apr 2021 11:07:53 -0400
X-MC-Unique: lvn4bjTVN_qTJC4lFHYfsg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD812E99C1;
        Fri,  9 Apr 2021 15:07:51 +0000 (UTC)
Received: from ovpn-115-50.ams2.redhat.com (ovpn-115-50.ams2.redhat.com [10.36.115.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2CE8C5C1A1;
        Fri,  9 Apr 2021 15:07:49 +0000 (UTC)
Message-ID: <f40fd90aa5077896121b368027fa8c70e505a358.camel@redhat.com>
Subject: Re: [PATCH net-next 3/4] veth: refine napi usage
From:   Paolo Abeni <pabeni@redhat.com>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Date:   Fri, 09 Apr 2021 17:07:49 +0200
In-Reply-To: <87y2drtsic.fsf@toke.dk>
References: <cover.1617965243.git.pabeni@redhat.com>
         <b241da0e8aa31773472591e219ada3632a84dfbb.1617965243.git.pabeni@redhat.com>
         <87y2drtsic.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello,

On Fri, 2021-04-09 at 16:57 +0200, Toke Høiland-Jørgensen wrote:
> Paolo Abeni <pabeni@redhat.com> writes:
> 
> > After the previous patch, when enabling GRO, locally generated
> > TCP traffic experiences some measurable overhead, as it traverses
> > the GRO engine without any chance of aggregation.
> > 
> > This change refine the NAPI receive path admission test, to avoid
> > unnecessary GRO overhead in most scenarios, when GRO is enabled
> > on a veth peer.
> > 
> > Only skbs that are eligible for aggregation enter the GRO layer,
> > the others will go through the traditional receive path.
> > 
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> >  drivers/net/veth.c | 23 ++++++++++++++++++++++-
> >  1 file changed, 22 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> > index ca44e82d1edeb..85f90f33d437e 100644
> > --- a/drivers/net/veth.c
> > +++ b/drivers/net/veth.c
> > @@ -282,6 +282,25 @@ static int veth_forward_skb(struct net_device *dev, struct sk_buff *skb,
> >  		netif_rx(skb);
> >  }
> >  
> > +/* return true if the specified skb has chances of GRO aggregation
> > + * Don't strive for accuracy, but try to avoid GRO overhead in the most
> > + * common scenarios.
> > + * When XDP is enabled, all traffic is considered eligible, as the xmit
> > + * device has TSO off.
> > + * When TSO is enabled on the xmit device, we are likely interested only
> > + * in UDP aggregation, explicitly check for that if the skb is suspected
> > + * - the sock_wfree destructor is used by UDP, ICMP and XDP sockets -
> > + * to belong to locally generated UDP traffic.
> > + */
> > +static bool veth_skb_is_eligible_for_gro(const struct net_device *dev,
> > +					 const struct net_device *rcv,
> > +					 const struct sk_buff *skb)
> > +{
> > +	return !(dev->features & NETIF_F_ALL_TSO) ||
> > +		(skb->destructor == sock_wfree &&
> > +		 rcv->features & (NETIF_F_GRO_FRAGLIST | NETIF_F_GRO_UDP_FWD));
> > +}
> > +
> >  static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
> >  {
> >  	struct veth_priv *rcv_priv, *priv = netdev_priv(dev);
> > @@ -305,8 +324,10 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
> >  
> >  		/* The napi pointer is available when an XDP program is
> >  		 * attached or when GRO is enabled
> > +		 * Don't bother with napi/GRO if the skb can't be aggregated
> >  		 */
> > -		use_napi = rcu_access_pointer(rq->napi);
> > +		use_napi = rcu_access_pointer(rq->napi) &&
> > +			   veth_skb_is_eligible_for_gro(dev, rcv, skb);
> >  		skb_record_rx_queue(skb, rxq);
> >  	}
> 
> You just changed the 'xdp_rcv' check to this use_napi, and now you're
> conditioning it on GRO eligibility, so doesn't this break XDP if that
> was the reason NAPI was turned on in the first place?

Thank you for the feedback.

If XDP is enabled, TSO is forced of on 'dev'
and veth_skb_is_eligible_for_gro() returns true, so napi/GRO is always
used - there is no functional change when XDP is enabled.

Please let me know if the above is more clear, thanks!

Paolo

