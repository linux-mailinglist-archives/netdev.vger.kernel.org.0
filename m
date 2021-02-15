Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D3B31B628
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 10:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhBOJE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 04:04:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35593 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230046AbhBOJDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 04:03:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613379709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xyoZzU1t5wWIo9oF7w8GE4+S+o/jhCoDxbXJWRl3Sr8=;
        b=Qbnun9C+g8tkKTG8aBMikkglZXFoW/ReZos4bKPrsaIUFs5rhe+QD9x8+TCmaOjMyLVUH+
        9SInP3ts1WkHbS5GNeck2uCbm1f8m5CMeuYTvnoNkhkxRbh4kCPR38VdMSzNVQefZyYBj6
        gnnEUMNjHNCa/WxZKW4QO/NJayUjBFo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-DLLgHfIMPSycrEjDpFAk7w-1; Mon, 15 Feb 2021 04:01:46 -0500
X-MC-Unique: DLLgHfIMPSycrEjDpFAk7w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A5FF100CCD1;
        Mon, 15 Feb 2021 09:01:45 +0000 (UTC)
Received: from carbon (unknown [10.36.110.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 232DE7771B;
        Mon, 15 Feb 2021 09:01:39 +0000 (UTC)
Date:   Mon, 15 Feb 2021 10:01:38 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, brouer@redhat.com
Subject: Re: [PATCH net-next V1] net: followup adjust net_device layout for
 cacheline usage
Message-ID: <20210215100138.64ef5269@carbon>
In-Reply-To: <bbae767f-ebb5-51a2-7123-5f2251cdbb2c@gmail.com>
References: <161313782625.1008639.6000589679659428869.stgit@firesoul>
        <bbae767f-ebb5-51a2-7123-5f2251cdbb2c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Feb 2021 18:03:44 +0100
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> On 2/12/21 2:50 PM, Jesper Dangaard Brouer wrote:
> > As Eric pointed out in response to commit 28af22c6c8df ("net: adjust
> > net_device layout for cacheline usage") the netdev_features_t members
> > wanted_features and hw_features are only used in control path.
> > 
> > Thus, this patch reorder the netdev_features_t to let more members that
> > are used in fast path into the 3rd cacheline. Whether these members are
> > read depend on SKB properties, which are hinted as comments. The member
> > mpls_features could not fit in the cacheline, but it was the least
> > commonly used (depend on CONFIG_NET_MPLS_GSO).
> > 
> > In the future we should consider relocating member gso_partial_features
> > to be closer to member gso_max_segs. (see usage in gso_features_check()).
> > 
> > Suggested-by: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >  include/linux/netdevice.h |   11 +++++++----
> >  1 file changed, 7 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index bfadf3b82f9c..3898bb167579 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -1890,13 +1890,16 @@ struct net_device {
> >  	unsigned short		needed_headroom;
> >  	unsigned short		needed_tailroom;
> >  
> > +	/* Fast path features - via netif_skb_features */
> >  	netdev_features_t	features;
> > +	netdev_features_t	vlan_features;       /* if skb_vlan_tagged */
> > +	netdev_features_t	hw_enc_features;     /* if skb->encapsulation */
> > +	netdev_features_t	gso_partial_features;/* if skb_is_gso */
> > +	netdev_features_t	mpls_features; /* if eth_p_mpls+NET_MPLS_GSO */
> > +
> > +	/* Control path features */
> >  	netdev_features_t	hw_features;
> >  	netdev_features_t	wanted_features;
> > -	netdev_features_t	vlan_features;
> > -	netdev_features_t	hw_enc_features;
> > -	netdev_features_t	mpls_features;
> > -	netdev_features_t	gso_partial_features;
> >  
> >  	unsigned int		min_mtu;
> >  	unsigned int		max_mtu;
> > 
> >   
> 
> 
> Please also note we currently have at least 3 distinct blocks for tx path.
> 
> Presumably netdev_features_t are only used in TX, so should be grouped with the other TX
> sections.
> 
> 
>         /* --- cacheline 3 boundary (192 bytes) --- */       
> ...
>         netdev_features_t          features;             /*  0xe0   0x8 */  
> 
> ... Lots of ctrl stuff....
> 
> 
>         /* --- cacheline 14 boundary (896 bytes) --- */
>          struct netdev_queue *      _tx __attribute__((__aligned__(64))); /* 0x380   0x8 */          
> 
> 
> ....
> 
> /* Mix of unrelated control stuff like rtnl_link_ops
> 
>  /* --- cacheline 31 boundary (1984 bytes) --- */ 
>  unsigned int               gso_max_size;         /* 0x7c0   0x4 */
>  u16                        gso_max_segs;         /* 0x7c4   0x2 */ 
> 
> 
> 
> Ideally we should move _all_ control/slow_path stuff at the very end of the structure,
> in order to not pollute the cache lines we need for data path, to keep them as small
> and packed as possible.
> 
> This could be done one field at a time, to ease code review.
> 
> We should have something like this 
> 
> /* section used in RX (fast) path */
> /* section used in both RX/TX (fast) path */
> /* section used in TX (fast) path */
> /* section used for slow path, and control path */

I fully agree with above, but this is the long term plan, that I have
added to my TODO list.

This patch is a followup to commit 28af22c6c8df ("net: adjust
net_device layout for cacheline usage") for fixing that the feature
members got partitioned into two cache-lines.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

