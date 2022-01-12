Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D88248BF5A
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 08:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237886AbiALH5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 02:57:12 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:58996 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237500AbiALH5L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 02:57:11 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 14C31201A0;
        Wed, 12 Jan 2022 08:57:10 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id deMvrlIzOcJy; Wed, 12 Jan 2022 08:57:09 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8C37920199;
        Wed, 12 Jan 2022 08:57:09 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 865F980004A;
        Wed, 12 Jan 2022 08:57:09 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 12 Jan 2022 08:57:09 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Wed, 12 Jan
 2022 08:57:09 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id CE6E53180D7C; Wed, 12 Jan 2022 08:57:08 +0100 (CET)
Date:   Wed, 12 Jan 2022 08:57:08 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Yan Yan <evitayan@google.com>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <lorenzo@google.com>,
        <maze@google.com>, <nharold@googlel.com>,
        <benedictwong@googlel.com>
Subject: Re: [PATCH v1 2/2] xfrm: Fix xfrm migrate issues when address family
 changes
Message-ID: <20220112075708.GB1223722@gauss3.secunet.de>
References: <20220106005251.2833941-1-evitayan@google.com>
 <20220106005251.2833941-3-evitayan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220106005251.2833941-3-evitayan@google.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 04:52:51PM -0800, Yan Yan wrote:

...

> -static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
> -					   struct xfrm_encap_tmpl *encap)
> +static struct xfrm_state *xfrm_state_clone1(struct xfrm_state *orig,
> +					    struct xfrm_encap_tmpl *encap)
>  {
>  	struct net *net = xs_net(orig);
>  	struct xfrm_state *x = xfrm_state_alloc(net);
> @@ -1579,8 +1579,20 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
>  	memcpy(&x->mark, &orig->mark, sizeof(x->mark));
>  	memcpy(&x->props.smark, &orig->props.smark, sizeof(x->props.smark));
>  
> -	if (xfrm_init_state(x) < 0)
> -		goto error;
> +	return x;
> +
> + error:
> +	xfrm_state_put(x);
> +out:
> +	return NULL;
> +}
> +
> +static int xfrm_state_clone2(struct xfrm_state *orig, struct xfrm_state *x)

I'm not a frind of numbering function names, this just invites to
create xfrm_state_clone3 :)

> +{
> +	int err = xfrm_init_state(x);
> +
> +	if (err < 0)
> +		return err;
>  
>  	x->props.flags = orig->props.flags;
>  	x->props.extra_flags = orig->props.extra_flags;
> @@ -1595,12 +1607,7 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
>  	x->replay = orig->replay;
>  	x->preplay = orig->preplay;
>  
> -	return x;
> -
> - error:
> -	xfrm_state_put(x);
> -out:
> -	return NULL;
> +	return 0;
>  }
>  
>  struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *net,
> @@ -1661,10 +1668,14 @@ struct xfrm_state *xfrm_state_migrate(struct xfrm_state *x,
>  {
>  	struct xfrm_state *xc;
>  
> -	xc = xfrm_state_clone(x, encap);
> +	xc = xfrm_state_clone1(x, encap);
>  	if (!xc)
>  		return NULL;
>  
> +	xc->props.family = m->new_family;
> +	if (xfrm_state_clone2(x, xc) < 0)
> +		goto error;

xfrm_state_migrate() is the only function that calls xfrm_state_clone().
Wouldn't it be better to move xfrm_init_state() out of xfrm_state_clone()
and call it afterwards?

This would also fix the replay window initialization on ESN because
currently x->props.flags (which holds XFRM_STATE_ESN) is initialized
after xfrm_init_state().

