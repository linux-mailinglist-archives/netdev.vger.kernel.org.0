Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F9D538FEE
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 13:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238426AbiEaLfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 07:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiEaLfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 07:35:36 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9220684A03;
        Tue, 31 May 2022 04:35:33 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 6E6E7205E3;
        Tue, 31 May 2022 13:35:31 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id P9-6MYtFaaTT; Tue, 31 May 2022 13:35:30 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E1E1B20265;
        Tue, 31 May 2022 13:35:30 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id D920A80004A;
        Tue, 31 May 2022 13:35:30 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 31 May 2022 13:35:30 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 31 May
 2022 13:35:30 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 208603183D61; Tue, 31 May 2022 13:35:30 +0200 (CEST)
Date:   Tue, 31 May 2022 13:35:30 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Hangyu Hua <hbh25y@gmail.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfrm: xfrm_input: fix a possible memory leak in
 xfrm_input()
Message-ID: <20220531113530.GL2517843@gauss3.secunet.de>
References: <20220530102046.41249-1-hbh25y@gmail.com>
 <20220530103734.GD2517843@gauss3.secunet.de>
 <17ce0028-cbf2-20cd-c9ae-16b37ed61924@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <17ce0028-cbf2-20cd-c9ae-16b37ed61924@gmail.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 31, 2022 at 10:12:05AM +0800, Hangyu Hua wrote:
> On 2022/5/30 18:37, Steffen Klassert wrote:
> > On Mon, May 30, 2022 at 06:20:46PM +0800, Hangyu Hua wrote:
> > > xfrm_input needs to handle skb internally. But skb is not freed When
> > > xo->flags & XFRM_GRO == 0 and decaps == 0.
> > > 
> > > Fixes: 7785bba299a8 ("esp: Add a software GRO codepath")
> > > Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> > > ---
> > >   net/xfrm/xfrm_input.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
> > > index 144238a50f3d..6f9576352f30 100644
> > > --- a/net/xfrm/xfrm_input.c
> > > +++ b/net/xfrm/xfrm_input.c
> > > @@ -742,7 +742,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
> > >   			gro_cells_receive(&gro_cells, skb);
> > >   			return err;
> > >   		}
> > > -
> > > +		kfree_skb(skb);
> > >   		return err;
> > >   	}
> > 
> > Did you test this? The function behind the 'afinfo->the transport_finish()'
> > pointer handles this skb and frees it in that case.
> 
> int xfrm4_transport_finish(struct sk_buff *skb, int async)
> {
> 	struct xfrm_offload *xo = xfrm_offload(skb);
> 	struct iphdr *iph = ip_hdr(skb);
> 
> 	iph->protocol = XFRM_MODE_SKB_CB(skb)->protocol;
> 
> #ifndef CONFIG_NETFILTER
> 	if (!async)
> 		return -iph->protocol;		<--- [1]
> #endif
> ...
> 	NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING,
> 		dev_net(skb->dev), NULL, skb, skb->dev, NULL,
> 		xfrm4_rcv_encap_finish);	<--- [2]
> 	return 0;
> }
> 
> int xfrm6_transport_finish(struct sk_buff *skb, int async)
> {
> 	struct xfrm_offload *xo = xfrm_offload(skb);
> 	int nhlen = skb->data - skb_network_header(skb);
> 
> 	skb_network_header(skb)[IP6CB(skb)->nhoff] =
> 		XFRM_MODE_SKB_CB(skb)->protocol;
> 
> #ifndef CONFIG_NETFILTER
> 	if (!async)
> 		return 1;			<--- [3]
> #endif
> ...
> 	NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING,
> 		dev_net(skb->dev), NULL, skb, skb->dev, NULL,
> 		xfrm6_transport_finish2);
> 	return 0;				<--- [4]
> }
> 
> If transport_finish() return in [1] or [3], there will be a memory leak.

No, even in that case there is no memleak. Look for instance at the
IPv4 case, we return -iph->protocol here.
Then look at ip_protocol_deliver_rcu(). If the ipprot->handler (xfrm)
returns a negative value, this is interpreted as the protocol number
and the packet is resubmitted to the next protocol handler.

Please test your patches before you submit them in the future.
