Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657D0637728
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 12:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbiKXLH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 06:07:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiKXLHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 06:07:55 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3EE4A5A3
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 03:07:51 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B25E120563;
        Thu, 24 Nov 2022 12:07:49 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hCPDU2TiYDRg; Thu, 24 Nov 2022 12:07:49 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 310E22049B;
        Thu, 24 Nov 2022 12:07:49 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 20AED80004A;
        Thu, 24 Nov 2022 12:07:49 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 12:07:48 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 24 Nov
 2022 12:07:48 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 4EF263180D1A; Thu, 24 Nov 2022 12:07:48 +0100 (CET)
Date:   Thu, 24 Nov 2022 12:07:48 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH xfrm-next v7 6/8] xfrm: speed-up lookup of HW policies
Message-ID: <20221124110748.GP424616@gauss3.secunet.de>
References: <20221121112521.GX704954@gauss3.secunet.de>
 <Y3tiRnbfBcaH7bP0@unreal>
 <Y3to7FYBwfkBSZYA@unreal>
 <20221121124349.GZ704954@gauss3.secunet.de>
 <Y3t2tsHDpxjnBAb/@unreal>
 <20221122131002.GN704954@gauss3.secunet.de>
 <Y3zVVzfrR1YKL4Xd@unreal>
 <20221123083720.GM424616@gauss3.secunet.de>
 <Y33pk/3rUxFqbH2h@unreal>
 <Y34Xtqa+F79DCf6S@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y34Xtqa+F79DCf6S@unreal>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 02:53:10PM +0200, Leon Romanovsky wrote:
> On Wed, Nov 23, 2022 at 11:36:19AM +0200, Leon Romanovsky wrote:
> > Thanks for an explanation, trying it now.
> 
> Something like that?

Yes :)

> 
> The code is untested yet.
> 
> diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
> index 5076f9d7a752..5819023c32ba 100644
> --- a/net/xfrm/xfrm_state.c
> +++ b/net/xfrm/xfrm_state.c
> @@ -1115,6 +1115,19 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
>  	rcu_read_lock();
>  	h = xfrm_dst_hash(net, daddr, saddr, tmpl->reqid, encap_family);
>  	hlist_for_each_entry_rcu(x, net->xfrm.state_bydst + h, bydst) {
> +		if (IS_ENABLED(CONFIG_XFRM_OFFLOAD) &&
> +		    pol->xdo.type == XFRM_DEV_OFFLOAD_PACKET) {

Please try to avoid that check for every state in the list.
Maybe enable this code with a static key if packet offload
is used?

> +			if (x->xso.type != XFRM_DEV_OFFLOAD_PACKET)
> +				/* HW states are in the head of list, there is no need
> +				 * to iterate further.
> +				 */
> +				break;
> +
> +			/* Packet offload: both policy and SA should have same device */
> +			if (pol->xdo.dev != x->xso.dev)
> +				continue;
> +		}
> +
>  		if (x->props.family == encap_family &&
>  		    x->props.reqid == tmpl->reqid &&
>  		    (mark & x->mark.m) == x->mark.v &&
> @@ -1132,6 +1145,19 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
>  
>  	h_wildcard = xfrm_dst_hash(net, daddr, &saddr_wildcard, tmpl->reqid, encap_family);
>  	hlist_for_each_entry_rcu(x, net->xfrm.state_bydst + h_wildcard, bydst) {
> +		if (IS_ENABLED(CONFIG_XFRM_OFFLOAD) &&
> +		    pol->xdo.type == XFRM_DEV_OFFLOAD_PACKET) {
> +			if (x->xso.type != XFRM_DEV_OFFLOAD_PACKET)
> +				/* HW states are in the head of list, there is no need
> +				 * to iterate further.
> +				 */
> +				break;
> +
> +			/* Packet offload: both policy and SA should have same device */
> +			if (pol->xdo.dev != x->xso.dev)
> +				continue;
> +		}
> +
>  		if (x->props.family == encap_family &&
>  		    x->props.reqid == tmpl->reqid &&
>  		    (mark & x->mark.m) == x->mark.v &&
> @@ -1185,6 +1211,17 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
>  			goto out;
>  		}
>  
> +		if (pol->xdo.type == XFRM_DEV_OFFLOAD_PACKET) {
> +			memcpy(&x->xso, &pol->xdo, sizeof(x->xso));
> +			error = pol->xdo.dev->xfrmdev_ops->xdo_dev_state_add(x);
> +			if (error) {
> +				x->km.state = XFRM_STATE_DEAD;
> +				to_put = x;
> +				x = NULL;
> +				goto out;
> +			}
> +		}

I guess that is to handle acquires, right?
What is the idea behind that? xdo_dev_state_add sets
offload type and dev?

