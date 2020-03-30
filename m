Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97BE8197EA1
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 16:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbgC3Oja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 10:39:30 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:59484 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727183AbgC3Oja (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 10:39:30 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B5ADD20523;
        Mon, 30 Mar 2020 16:39:29 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Fx4aNTChbPxE; Mon, 30 Mar 2020 16:39:29 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 4990C2006F;
        Mon, 30 Mar 2020 16:39:29 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 30 Mar
 2020 16:39:29 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id D868C3180136; Mon, 30 Mar 2020 16:39:28 +0200 (CEST)
Date:   Mon, 30 Mar 2020 16:39:28 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Florian Westphal <fw@strlen.de>
CC:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>, <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net] udp: fix a skb extensions leak
Message-ID: <20200330143928.GN13121@gauss3.secunet.de>
References: <e17fe23a0a5f652866ec623ef0cde1e6ef5dbcf5.1585213585.git.lucien.xin@gmail.com>
 <20200330132759.GA31510@strlen.de>
 <20200330134531.GK13121@gauss3.secunet.de>
 <20200330141147.GC23604@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200330141147.GC23604@breakpoint.cc>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 cas-essen-02.secunet.de (10.53.40.202)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 04:11:47PM +0200, Florian Westphal wrote:
> Steffen Klassert <steffen.klassert@secunet.com> wrote:
> > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > index 621b4479fee1..7e29590482ce 100644
> > > --- a/net/core/skbuff.c
> > > +++ b/net/core/skbuff.c
> > > @@ -3668,6 +3668,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
> > > 
> > >                 skb_push(nskb, -skb_network_offset(nskb) + offset);
> > > 
> > > +               skb_release_head_state(nskb);
> > >                  __copy_skb_header(nskb, skb);
> > > 
> > >                 skb_headers_offset_update(nskb, skb_headroom(nskb) - skb_headroom(skb));
> > > 
> > > AFAICS we not only leak reference of extensions, but also skb->dst and skb->_nfct.
> > 
> > Would be nice if we would not need to drop the resources
> > just to add them back again in the next line. But it is ok
> > as a quick fix for the bug.
> 
> Yes, but are these the same resources?  AFAIU thats not the case, i.e.
> the skb on fraglist can have different skb->{dst,extension,_nfct} data
> than the skb head one, and we can't tell if that data is still valid
> (rerouting for example).

Some are the same, others not. Originally, I used
a subset of __copy_skb_header here. But decided then
to use __copy_skb_header to make sure I don't forget
anything. So this fix is ok for now.
