Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24EFF6D9C38
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 17:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239322AbjDFP0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 11:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239379AbjDFPZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 11:25:58 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09CB9012
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 08:25:53 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id p3-20020a17090a74c300b0023f69bc7a68so40957410pjl.4
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 08:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680794753;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vimaL8M9vR0QznqDKQ983Ym/MOmmwhUE3iOZFMZlm04=;
        b=eb31ZdEAfb9/0O0JV9sfoyTkB9toYYmlGBfEuI33QSP+1BjCwoBG3upkk9yZCLH+A7
         rHt8TXV3tUS00NRmqvv/M6v+EHL2XyGwfRN42LGkGVZt21Zhc0gQX8L0XEB0y8z7V8sK
         GVys1BGTRhKMFHjNHUYlJfu5wZj/7DPs+D8Zj0sDIQqFcxqNcbQs28vFq5Om6SBkFlVQ
         HLn6OMCgkdoZsYMdOnjlpRf06c4wt/X9cj2qFNwYmx0nMFEvwqTcFPxKva7Heh6ZpdQ4
         Iij8pqBc7Q9E+yQ5B6M0LxE3/9dSRUSJ4pt67IWvKpCz+XA6j7eNYiPmy6yo1H5VtAxo
         bgEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680794753;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vimaL8M9vR0QznqDKQ983Ym/MOmmwhUE3iOZFMZlm04=;
        b=msgVUnNRLNVSJpztvErpfnulgVlP/U+Lt8hOuQiICEn6g0pBByizmoa5NDqJAGiQql
         Lc73b6b9n46dYmGMu1POmfcomxvgo6RGdJsIz/aaztGtvLRqqHKU8a/0EqLA9b6xeUsg
         BH3/GBSDkVlcigRCUT3PA0a0CV4O+OlZKSPmWPOaZ37AAgkREd67IEeTSUGJ9lg0Ykza
         dWGOXFoRUVRcJaBjXAyQYzV5no6ZttvA8QVQSjbKAg8+VICgpATRYYIZP1Kwpju8VwfW
         o5Zsg9/F/eBVCEB8iJ8WZWtoOM/D0yo2KuCrzd2QdQ1nvP2PdzLO2wPTC64CbU2NAYFf
         ubYA==
X-Gm-Message-State: AAQBX9dA1/QjkUZGwiroalpcVK+dVf7cOKv+QAn+2oT89Becggu2VnzN
        FXTH12s+Qj2RolYVTBruGpI=
X-Google-Smtp-Source: AKy350alLjwotSTFpAuR6cOkg3GRmpqln9RhP0Sy7Gstdi3bdPmaIwOXrUjC/0BuenaVc7/PY4CGLg==
X-Received: by 2002:a05:6a20:6d90:b0:e5:5037:9785 with SMTP id gl16-20020a056a206d9000b000e550379785mr3490502pzb.41.1680794752765;
        Thu, 06 Apr 2023 08:25:52 -0700 (PDT)
Received: from [192.168.0.128] ([98.97.117.210])
        by smtp.googlemail.com with ESMTPSA id s5-20020a63f045000000b005038291e5cbsm1278802pgj.35.2023.04.06.08.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 08:25:52 -0700 (PDT)
Message-ID: <ed4b1f1bf72ea1234a283a26d88e00658e9e4311.camel@gmail.com>
Subject: Re: [PATCH v2] skbuff: Fix a race between coalescing and releasing
 SKBs
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Liang Chen <liangchen.linux@gmail.com>, kuba@kernel.org,
        ilias.apalodimas@linaro.org, hawk@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Date:   Thu, 06 Apr 2023 08:25:51 -0700
In-Reply-To: <20230406114825.18597-1-liangchen.linux@gmail.com>
References: <20230406114825.18597-1-liangchen.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-04-06 at 19:48 +0800, Liang Chen wrote:
> Commit 1effe8ca4e34 ("skbuff: fix coalescing for page_pool fragment
> recycling") allowed coalescing to proceed with non page pool page and
> page pool page when @from is cloned, i.e.
>=20
> to->pp_recycle    --> false
> from->pp_recycle  --> true
> skb_cloned(from)  --> true
>=20
> However, it actually requires skb_cloned(@from) to hold true until
> coalescing finishes in this situation. If the other cloned SKB is
> released while the merging is in process, from_shinfo->nr_frags will be
> set to 0 towards the end of the function, causing the increment of frag
> page _refcount to be unexpectedly skipped resulting in inconsistent
> reference counts. Later when SKB(@to) is released, it frees the page
> directly even though the page pool page is still in use, leading to
> use-after-free or double-free errors.
>=20
> So it needs to be specially handled at where the ref count may get lost.
>=20
> The double-free error message below prompted us to investigate:
> BUG: Bad page state in process swapper/1  pfn:0e0d1
> page:00000000c6548b28 refcount:-1 mapcount:0 mapping:0000000000000000
> index:0x2 pfn:0xe0d1
> flags: 0xfffffc0000000(node=3D0|zone=3D1|lastcpupid=3D0x1fffff)
> raw: 000fffffc0000000 0000000000000000 ffffffff00000101 0000000000000000
> raw: 0000000000000002 0000000000000000 ffffffffffffffff 0000000000000000
> page dumped because: nonzero _refcount
>=20
> CPU: 1 PID: 0 Comm: swapper/1 Tainted: G            E      6.2.0+
> Call Trace:
>  <IRQ>
> dump_stack_lvl+0x32/0x50
> bad_page+0x69/0xf0
> free_pcp_prepare+0x260/0x2f0
> free_unref_page+0x20/0x1c0
> skb_release_data+0x10b/0x1a0
> napi_consume_skb+0x56/0x150
> net_rx_action+0xf0/0x350
> ? __napi_schedule+0x79/0x90
> __do_softirq+0xc8/0x2b1
> __irq_exit_rcu+0xb9/0xf0
> common_interrupt+0x82/0xa0
> </IRQ>
> <TASK>
> asm_common_interrupt+0x22/0x40
> RIP: 0010:default_idle+0xb/0x20
>=20
> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> ---
> Changes from v1:
> - deal with the ref count problem instead of return back to give more opp=
ortunities to coalesce skbs.
> ---
>  net/core/skbuff.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 050a875d09c5..77da8ce74a1e 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -5643,7 +5643,19 @@ bool skb_try_coalesce(struct sk_buff *to, struct s=
k_buff *from,
> =20
>  		skb_fill_page_desc(to, to_shinfo->nr_frags,
>  				   page, offset, skb_headlen(from));
> -		*fragstolen =3D true;
> +
> +		/* When @from is pp_recycle and @to isn't, coalescing is
> +		 * allowed to proceed if @from is cloned. However if the
> +		 * execution reaches this point, @from is already transitioned
> +		 * into non-cloned because the other cloned skb is released
> +		 * somewhere else concurrently. In this case, we need to make
> +		 * sure the ref count is incremented, not directly stealing
> +		 * from page pool.
> +		 */
> +		if (to->pp_recycle !=3D from->pp_recycle)
> +			get_page(page);
> +		else
> +			*fragstolen =3D true;
>  	} else {
>  		if (to_shinfo->nr_frags +
>  		    from_shinfo->nr_frags > MAX_SKB_FRAGS)
> @@ -5659,7 +5671,13 @@ bool skb_try_coalesce(struct sk_buff *to, struct s=
k_buff *from,
>  	       from_shinfo->nr_frags * sizeof(skb_frag_t));
>  	to_shinfo->nr_frags +=3D from_shinfo->nr_frags;
> =20
> -	if (!skb_cloned(from))
> +	/* Same situation as above where head data presents. When @from is
> +	 * pp_recycle and @to isn't, coalescing is allowed to proceed if @from
> +	 * is cloned. However @from can be transitioned into non-cloned
> +	 * concurrently by this point. If it does happen, we need to make sure
> +	 * the ref count is properly incremented.
> +	 */
> +	if (to->pp_recycle =3D=3D from->pp_recycle && !skb_cloned(from))
>  		from_shinfo->nr_frags =3D 0;
> =20
>  	/* if the skb is not cloned this does nothing

So looking this over I believe this should resolve the issue you
pointed out while maintaining current functionality.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

One follow-on that we may want to do with this would be to look at
consolidating the 3 spots where we are checking for our combination of
pp_recycle comparison and skb_cloned and maybe pass one boolean flag
indicating that we have to transfer everything by taking page
references.

Also I think we can actually increase the number of cases where we
support coalescing if we were to take apart the skb_head_is_locked call
and move the skb_cloned check from it into your recycle check in the
portion where we are stealing from the header.
