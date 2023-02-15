Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3F6697866
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 09:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjBOImL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 03:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjBOImK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 03:42:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08ABD1715
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 00:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676450485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Rh9IkJntZgdRsnT7idwV+vuqdD8fR59sXuF4HecIDM=;
        b=I463pHN/cr3TvofqgWNI4q/rTzNz4HCGfs5sQ4BucS40iDiURuJC3LAWr7sp2NueHnszBc
        CpmDbEP9qopjEPbEPcQzTEMqhLgR500psU4gDqPuLG+US5PhPY6178uBPkeWixz8vNELUm
        +Zcp0xee8kwTMrKajQAyw+TWaLOQb8E=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-553-PvIqX9wuM_2ZEDm_4ak6NQ-1; Wed, 15 Feb 2023 03:41:17 -0500
X-MC-Unique: PvIqX9wuM_2ZEDm_4ak6NQ-1
Received: by mail-qk1-f199.google.com with SMTP id s7-20020a05620a0bc700b006e08208eb31so11003841qki.3
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 00:41:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/Rh9IkJntZgdRsnT7idwV+vuqdD8fR59sXuF4HecIDM=;
        b=YqmiHe0ihpqshHB4+nzkHAR8IotjCQanxo15Ikvel5yYsy+7FyEPyN/GdX6Fe65FgT
         vbaZoHxAP7Ht7fzuZUJaJ06DbkA/856XMNZe5Xl29P44aS6K1P03FBejqYCq18HKigE/
         lBBxTJlcYkDUcxSssdq5R7Jm7Z6elzAsKGyAdavHlb/oiqE13CxJ/kSRXIlS8g80pG8Y
         JQvJEmdL5KkrBRP64jOQYpn/bUVM77//55NRNz57Rfmd5GpunSw+QusJmv4u1rRW4fKk
         5Q3orzhJwZrDtYGKRkim1r1fp6kHR36UluwsQIXRIn1OYkYCG3evl94wgjQTSSs7zsqJ
         mhrg==
X-Gm-Message-State: AO0yUKX1fAQVGo997DHXDv/tFExis1XuanvCKj9s7umQ5oJZzcxrZNc9
        AhDO/w0rl+0bA7RNIOl80ocyHwPQ1W3rS4axn1VSeatr6/761TroN1WITY3sOmuM3+Ug7RjgGgh
        Jvuh9iqt4Edk3/ira
X-Received: by 2002:a05:622a:1052:b0:3b5:87db:f979 with SMTP id f18-20020a05622a105200b003b587dbf979mr2598819qte.5.1676450477259;
        Wed, 15 Feb 2023 00:41:17 -0800 (PST)
X-Google-Smtp-Source: AK7set+dWlKkSTclx21dZ+E0CPOg4wT2TbYwnGJd32Lsl2KmTVQ0Cx/C0NMAU+B94CRIkNCzB0Grrg==
X-Received: by 2002:a05:622a:1052:b0:3b5:87db:f979 with SMTP id f18-20020a05622a105200b003b587dbf979mr2598803qte.5.1676450476968;
        Wed, 15 Feb 2023 00:41:16 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id r18-20020ac87ef2000000b003b86b088755sm12536481qtc.15.2023.02.15.00.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 00:41:16 -0800 (PST)
Message-ID: <ef9ab8960763289e990b0010ee2aa761c3ee80a3.camel@redhat.com>
Subject: Re: [PATCH net-next 2/3] net: skbuff: cache one skb_ext for use by
 GRO
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, willemb@google.com,
        fw@strlen.de
Date:   Wed, 15 Feb 2023 09:41:13 +0100
In-Reply-To: <20230215034355.481925-3-kuba@kernel.org>
References: <20230215034355.481925-1-kuba@kernel.org>
         <20230215034355.481925-3-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-02-14 at 19:43 -0800, Jakub Kicinski wrote:
> On the driver -> GRO path we can avoid thrashing the kmemcache
> by holding onto one skb_ext.
>=20
> Drivers usually report static data, so don't bother trying to
> hold onto the skb_ext if the ext has contents which require
> a destructor.
>=20
> With a single flow and SW GRO adding a tc_skb_ext to every
> frame costs around 16.6% of performance (21.2Gbps -> 17.6Gbps,
> yes it's a relatively slow CPU). Using the cache reduces
> the loss to 9.3%, (-> 19.2Gbps) although obviously in real
> life the recycling will be less effective.
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/linux/skbuff.h |  1 +
>  net/core/skbuff.c      | 79 +++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 75 insertions(+), 5 deletions(-)
>=20
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index d5602b15c714..e68cb0a777b9 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -4622,6 +4622,7 @@ struct skb_ext *__skb_ext_alloc(gfp_t flags);
>  void *__skb_ext_set(struct sk_buff *skb, enum skb_ext_id id,
>  		    struct skb_ext *ext);
>  void *skb_ext_add(struct sk_buff *skb, enum skb_ext_id id);
> +void *napi_skb_ext_add(struct sk_buff *skb, enum skb_ext_id id);
>  void __skb_ext_del(struct sk_buff *skb, enum skb_ext_id id);
>  void __skb_ext_put(struct skb_ext *ext);
> =20
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 6f0fc1f09536..feb5034b13ad 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -224,6 +224,9 @@ static void *page_frag_alloc_1k(struct page_frag_1k *=
nc, gfp_t gfp_mask)
>  struct napi_alloc_cache {
>  	struct page_frag_cache page;
>  	struct page_frag_1k page_small;
> +#ifdef CONFIG_SKB_EXTENSIONS
> +	struct skb_ext *ext;
> +#endif
>  	unsigned int skb_count;
>  	void *skb_cache[NAPI_SKB_CACHE_SIZE];
>  };
> @@ -1228,6 +1231,43 @@ static void napi_skb_cache_put(struct sk_buff *skb=
)
>  	}
>  }
> =20
> +static bool skb_ext_needs_destruct(const struct skb_ext *ext)
> +{
> +	bool needs_destruct =3D false;
> +
> +#ifdef CONFIG_XFRM
> +	needs_destruct |=3D __skb_ext_exist(ext, SKB_EXT_SEC_PATH);
> +#endif
> +#ifdef CONFIG_MCTP_FLOWS
> +	needs_destruct |=3D __skb_ext_exist(ext, SKB_EXT_MCTP);
> +#endif
> +
> +	return needs_destruct;
> +}
> +
> +static void napi_skb_ext_put(struct sk_buff *skb)
> +{
> +#ifdef CONFIG_SKB_EXTENSIONS
> +	struct skb_ext *ext;
> +
> +	if (!skb->active_extensions)
> +		return;
> +
> +	ext =3D skb->extensions;
> +	if (!skb_ext_needs_destruct(ext)) {
> +		struct napi_alloc_cache *nc =3D this_cpu_ptr(&napi_alloc_cache);
> +
> +		if (refcount_read(&ext->refcnt) =3D=3D 1 && !nc->ext) {
> +			kasan_poison_object_data(skbuff_ext_cache, ext);
> +			nc->ext =3D ext;
> +			return;
> +		}
> +	}
> +
> +	__skb_ext_put(ext);
> +#endif
> +}
> +
>  void __kfree_skb_defer(struct sk_buff *skb)

I'm wondering if napi_reuse_skb() should be touched, too? Even it's not
directly used by the following patch...

Cheers,

Paolo

