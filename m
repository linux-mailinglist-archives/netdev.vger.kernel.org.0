Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A276F207E7C
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 23:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403813AbgFXV2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 17:28:05 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:46477 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390437AbgFXV2F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 17:28:05 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 5b8dc3a7;
        Wed, 24 Jun 2020 21:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=date:from:to
        :cc:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=mail; bh=lBGWaWSniCgW2rkSG/g/Me2LyUA=; b=TpJYuTv
        /1y34hOuTp3rYLWpfMyZ6W/HtiRi8W4pwjFKS7i+PFCWV08NEbGtrNA57aZ6Z7c3
        0qAax0qjvlsFC7xPn7QTTLLte5Av//wNT9hTkQ4yFYp8B42OaVErvSvDLFnn3jIn
        e4yxTFLsvjkhgt+TmZNfrMOPlw7uxZ8tQ7IqBYxGFu0WLo586W46V4ySdp3mNwS7
        A+1PhLEALi2HHsrb+N00xAyQ27NdJPOvC3DvvdtsfRpLgty6Ov7DXpX8JueSA1p/
        g9cnwlDhD41RDe3NzWpslaGQ7IVOpiqsnOapEEZsGYuDkk/t0eBnh1jcYHCWMd9x
        SSpd6S67oxtCALA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6cb6511a (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 24 Jun 2020 21:09:00 +0000 (UTC)
Date:   Wed, 24 Jun 2020 15:28:02 -0600
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Alexander Lobakin <alobakin@dlink.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@mellanox.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: core: use listified Rx for GRO_NORMAL
 in napi_gro_receive()
Message-ID: <20200624212802.GA1386764@zx2c4.com>
References: <20191014080033.12407-1-alobakin@dlink.ru>
 <20200624210606.GA1362687@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200624210606.GA1362687@zx2c4.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 03:06:10PM -0600, Jason A. Donenfeld wrote:
> Hi Alexander,
> 
> This patch introduced a behavior change around GRO_DROP:
> 
> napi_skb_finish used to sometimes return GRO_DROP:
> 
> > -static gro_result_t napi_skb_finish(gro_result_t ret, struct sk_buff *skb)
> > +static gro_result_t napi_skb_finish(struct napi_struct *napi,
> > +				    struct sk_buff *skb,
> > +				    gro_result_t ret)
> >  {
> >  	switch (ret) {
> >  	case GRO_NORMAL:
> > -		if (netif_receive_skb_internal(skb))
> > -			ret = GRO_DROP;
> > +		gro_normal_one(napi, skb);
> >
> 
> But under your change, gro_normal_one and the various calls that makes
> never propagates its return value, and so GRO_DROP is never returned to
> the caller, even if something drops it.
> 
> Was this intentional? Or should I start looking into how to restore it?
> 
> Thanks,
> Jason

For some context, I'm consequently mulling over this change in my code,
since checking for GRO_DROP now constitutes dead code:

diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
index 91438144e4f7..9b2ab6fc91cd 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -414,14 +414,8 @@ static void wg_packet_consume_data_done(struct wg_peer *peer,
 	if (unlikely(routed_peer != peer))
 		goto dishonest_packet_peer;

-	if (unlikely(napi_gro_receive(&peer->napi, skb) == GRO_DROP)) {
-		++dev->stats.rx_dropped;
-		net_dbg_ratelimited("%s: Failed to give packet to userspace from peer %llu (%pISpfsc)\n",
-				    dev->name, peer->internal_id,
-				    &peer->endpoint.addr);
-	} else {
-		update_rx_stats(peer, message_data_len(len_before_trim));
-	}
+	napi_gro_receive(&peer->napi, skb);
+	update_rx_stats(peer, message_data_len(len_before_trim));
 	return;

 dishonest_packet_peer:

