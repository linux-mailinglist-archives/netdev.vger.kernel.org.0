Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9926B23B4A3
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 07:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729841AbgHDFyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 01:54:05 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:59113 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726398AbgHDFyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 01:54:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596520444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QnBHHhZ53Hmxu+zkpmaAK/12m09PHTO5t2M4X1Dr+8Q=;
        b=ee3MSB7DbRSCiYk/xMms6xs2lU1KL6neNydyP5uRYw4i8piuNE5jLHS1hglCuT8jZ0gO6i
        plbyLeNCmyKhhVSWXDc2LTtClnP9xs9ca4FOwIdlISwodshhab8NqkeOkp7czah1T57Fab
        CPb5/CJp8Y9RtE51THe8upx0EtFDHKM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-uoNcO_wFP9qLNGsgdi5T7g-1; Tue, 04 Aug 2020 01:52:58 -0400
X-MC-Unique: uoNcO_wFP9qLNGsgdi5T7g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E58E38017FB;
        Tue,  4 Aug 2020 05:52:56 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CDEB8FA30;
        Tue,  4 Aug 2020 05:52:53 +0000 (UTC)
Date:   Tue, 4 Aug 2020 07:52:47 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Aaron Conole <aconole@redhat.com>,
        Numan Siddique <nusiddiq@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Lourdes Pedrajas <lu@pplo.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/6] ipv4: route: Ignore output interface in
 FIB lookup for PMTU route
Message-ID: <20200804075247.3db502f3@elisabeth>
In-Reply-To: <26681884-43fa-65b7-4832-ef9d757e8c0b@gmail.com>
References: <cover.1596487323.git.sbrivio@redhat.com>
        <86a082ace1356cebc4430ea38256069e6e2966c3.1596487323.git.sbrivio@redhat.com>
        <26681884-43fa-65b7-4832-ef9d757e8c0b@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Aug 2020 17:30:46 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 8/3/20 2:52 PM, Stefano Brivio wrote:
> > diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> > index a01efa062f6b..c14fd8124f57 100644
> > --- a/net/ipv4/route.c
> > +++ b/net/ipv4/route.c
> > @@ -1050,6 +1050,7 @@ static void ip_rt_update_pmtu(struct dst_entry *dst, struct sock *sk,
> >  	struct flowi4 fl4;
> >  
> >  	ip_rt_build_flow_key(&fl4, sk, skb);
> > +	fl4.flowi4_oif = 0;	/* Don't make lookup fail for encapsulations */
> >  	__ip_rt_update_pmtu(rt, &fl4, mtu);
> >  }
> >  
> 
> Can this be limited to:
> 	if (skb &&
> 	    netif_is_bridge_port(skb->dev) || netif_is_ovs_port(skb->dev))
> 		fl4.flowi4_oif = 0;
> 
> I'm not sure we want to reset oif for all MTU updates.

I think that generally speaking we might, because this is about the
*path* MTU after all, so the output interface doesn't look very
relevant.

On the other hand, I couldn't find any other case where this makes a
difference, and I guess it's better to eventually find out about those
other cases if any, rather than fixing things by accident possibly in
the wrong way.

Changed in v2, thanks.

-- 
Stefano

