Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5376B690AE8
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 14:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjBINyZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 9 Feb 2023 08:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjBINyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 08:54:24 -0500
Received: from us-smtp-delivery-44.mimecast.com (unknown [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AABC07A81
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 05:54:23 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-OOexrWVhPm6fO67t4aReIg-1; Thu, 09 Feb 2023 08:54:06 -0500
X-MC-Unique: OOexrWVhPm6fO67t4aReIg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE7D938173D4;
        Thu,  9 Feb 2023 13:54:05 +0000 (UTC)
Received: from hog (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4280B40B42D4;
        Thu,  9 Feb 2023 13:54:04 +0000 (UTC)
Date:   Thu, 9 Feb 2023 14:52:20 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Hyunwoo Kim <v4bel@theori.io>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        steffen.klassert@secunet.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        imv4bel@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2] af_key: Fix heap information leak
Message-ID: <Y+T6lIqdyWWhlXU9@hog>
References: <20230204175018.GA7246@ubuntu>
 <20230209091648.GA5858@ubuntu>
MIME-Version: 1.0
In-Reply-To: <20230209091648.GA5858@ubuntu>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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

2023-02-09, 01:16:48 -0800, Hyunwoo Kim wrote:
> Since x->encap of pfkey_msg2xfrm_state() is not
> initialized to 0, kernel heap data can be leaked.
> 
> Fix with kzalloc() to prevent this.
> 
> Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>

Thanks.

> ---
>  net/key/af_key.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/key/af_key.c b/net/key/af_key.c
> index 2bdbcec781cd..a815f5ab4c49 100644
> --- a/net/key/af_key.c
> +++ b/net/key/af_key.c
> @@ -1261,7 +1261,7 @@ static struct xfrm_state * pfkey_msg2xfrm_state(struct net *net,
>  		const struct sadb_x_nat_t_type* n_type;
>  		struct xfrm_encap_tmpl *natt;
>  
> -		x->encap = kmalloc(sizeof(*x->encap), GFP_KERNEL);
> +		x->encap = kzalloc(sizeof(*x->encap), GFP_KERNEL);
>  		if (!x->encap) {
>  			err = -ENOMEM;
>  			goto out;
> -- 
> 2.25.1
> 

-- 
Sabrina

