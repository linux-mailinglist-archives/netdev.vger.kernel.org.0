Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA80068EFA7
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 14:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbjBHNRx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Feb 2023 08:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjBHNRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 08:17:52 -0500
Received: from us-smtp-delivery-44.mimecast.com (unknown [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4411C6185
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 05:17:50 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-501-1DgjbP6mNa-Wz1atG_073Q-1; Wed, 08 Feb 2023 08:17:32 -0500
X-MC-Unique: 1DgjbP6mNa-Wz1atG_073Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E39B22804826;
        Wed,  8 Feb 2023 13:17:31 +0000 (UTC)
Received: from hog (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 759A4140EBF4;
        Wed,  8 Feb 2023 13:17:30 +0000 (UTC)
Date:   Wed, 8 Feb 2023 14:15:47 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Hyunwoo Kim <v4bel@theori.io>, steffen.klassert@secunet.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, imv4bel@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] xfrm: Zero padding when dumping algos and encap
Message-ID: <Y+Oggx0YBA3kLLcw@hog>
References: <20230204175018.GA7246@ubuntu>
 <Y+Hp+0LzvScaUJV0@gondor.apana.org.au>
 <20230208085434.GA2933@ubuntu>
 <Y+N4Q2B01iRfXlQu@gondor.apana.org.au>
MIME-Version: 1.0
In-Reply-To: <Y+N4Q2B01iRfXlQu@gondor.apana.org.au>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_VALIDITY_RPBL,RDNS_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-02-08, 18:24:03 +0800, Herbert Xu wrote:
> On Wed, Feb 08, 2023 at 12:54:34AM -0800, Hyunwoo Kim wrote:
> > On Tue, Feb 07, 2023 at 02:04:43PM +0800, Herbert Xu wrote:
> > > On Sat, Feb 04, 2023 at 09:50:18AM -0800, Hyunwoo Kim wrote:
> > > > Since x->calg etc. are allocated with kmalloc, information
> > > > in kernel heap can be leaked using netlink socket on
> > > > systems without CONFIG_INIT_ON_ALLOC_DEFAULT_ON.
> > > > 
> > Reported-by: syzbot+fa5414772d5c445dac3c@syzkaller.appspotmail.com
> 
> Thanks.  This line should go into the patch description.
> 
> However, I don't think your patch is sufficient as xfrm_user
> does the same thing as af_key.
> 
> I think a better approach would be to not copy out past the
> end of string in copy_to_user_state_extra.  Something like
> this:

Do you mean as a replacement for Hyunwoo's patch, or that both are
needed? pfkey_msg2xfrm_state doesn't always initialize encap_sport and
encap_dport (and calg->alg_key_len, but you're not using that in
copy_to_user_calg), so I guess you mean both patches.

> ---8<---
> When copying data to user-space we should ensure that only valid
> data is copied over.  Padding in structures may be filled with
> random (possibly sensitve) data and should never be given directly
> to user-space.
> 
> This patch fixes the copying of xfrm algorithms and the encap
> template in xfrm_user so that padding is zeroed.
> 
> Reported-by: syzbot+fa5414772d5c445dac3c@syzkaller.appspotmail.com
> Reported-by: Hyunwoo Kim <v4bel@theori.io>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
> index cf5172d4ce68..b5d50ae89840 100644
> --- a/net/xfrm/xfrm_user.c
> +++ b/net/xfrm/xfrm_user.c
> @@ -1012,7 +1012,9 @@ static int copy_to_user_aead(struct xfrm_algo_aead *aead, struct sk_buff *skb)
>  		return -EMSGSIZE;
>  
>  	ap = nla_data(nla);
> -	memcpy(ap, aead, sizeof(*aead));
> +	strscpy_pad(ap->alg_name, aead->alg_name, sizeof(ap->alg_name));
> +	ap->alg_key_len = aead->alg_key_len;
> +	ap->alg_icv_len = aead->alg_icv_len;
>  
>  	if (redact_secret && aead->alg_key_len)
>  		memset(ap->alg_key, 0, (aead->alg_key_len + 7) / 8);
> @@ -1032,7 +1034,8 @@ static int copy_to_user_ealg(struct xfrm_algo *ealg, struct sk_buff *skb)
>  		return -EMSGSIZE;
>  
>  	ap = nla_data(nla);
> -	memcpy(ap, ealg, sizeof(*ealg));
> +	strscpy_pad(ap->alg_name, ealg->alg_name, sizeof(ap->alg_name));
> +	ap->alg_key_len = ealg->alg_key_len;
>  
>  	if (redact_secret && ealg->alg_key_len)
>  		memset(ap->alg_key, 0, (ealg->alg_key_len + 7) / 8);
> @@ -1043,6 +1046,40 @@ static int copy_to_user_ealg(struct xfrm_algo *ealg, struct sk_buff *skb)
>  	return 0;
>  }
>  
> +static int copy_to_user_calg(struct xfrm_algo *calg, struct sk_buff *skb)
> +{
> +	struct nlattr *nla = nla_reserve(skb, XFRMA_ALG_COMP, sizeof(*calg));
> +	struct xfrm_algo *ap;
> +
> +	if (!nla)
> +		return -EMSGSIZE;
> +
> +	ap = nla_data(nla);
> +	strscpy_pad(ap->alg_name, calg->alg_name, sizeof(ap->alg_name));
> +	ap->alg_key_len = 0;
> +
> +	return 0;
> +}
> +
> +static int copy_to_user_encap(struct xfrm_encap_tmpl *ep, struct sk_buff *skb)
> +{
> +	struct nlattr *nla = nla_reserve(skb, XFRMA_ALG_COMP, sizeof(*ep));

XFRMA_ENCAP

> +	struct xfrm_encap_tmpl *uep;
> +
> +	if (!nla)
> +		return -EMSGSIZE;
> +
> +	uep = nla_data(nla);
> +	memset(uep, 0, sizeof(*uep));
> +
> +	uep->encap_type = ep->encap_type;
> +	uep->encap_sport = ep->encap_sport;
> +	uep->encap_dport = ep->encap_dport;
> +	uep->encap_oa = ep->encap_oa;

Should that be a memcpy? At least that's how xfrm_user.c usually does
copies of xfrm_address_t.

> +
> +	return 0;
> +}
> +
>  static int xfrm_smark_put(struct sk_buff *skb, struct xfrm_mark *m)
>  {
>  	int ret = 0;
> @@ -1098,12 +1135,12 @@ static int copy_to_user_state_extra(struct xfrm_state *x,
>  			goto out;
>  	}
>  	if (x->calg) {
> -		ret = nla_put(skb, XFRMA_ALG_COMP, sizeof(*(x->calg)), x->calg);
> +		ret = copy_to_user_calg(x->calg, skb);
>  		if (ret)
>  			goto out;
>  	}
>  	if (x->encap) {
> -		ret = nla_put(skb, XFRMA_ENCAP, sizeof(*x->encap), x->encap);
> +		ret = copy_to_user_encap(x->encap, skb);
>  		if (ret)
>  			goto out;
>  	}
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> 

-- 
Sabrina

