Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 544E868917B
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 09:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbjBCIBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 03:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232677AbjBCIBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 03:01:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5AD1B300
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 23:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675411177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QPp0pE5EXgzmra6b8YMgA6FtUNUnW1QTYupjEWodcAs=;
        b=XKnlV6lbRSolzhpIrEDEXM1Smbp83i8xVWfz2OsUmjU/XY2rJ+1aHeQO0Yel828mN5LH30
        gX3RDdWtoo1cEymjXvwR7WOe+mRMLHwSYxJpOE8E5iyA8zeZAVacksGzA1/ZXv1k3RC+9h
        FELcgv+AQtDiS6JCv7euLIoO97Jsvv8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-524-Mr8FmnZ5NZeLTPz_IhKGRQ-1; Fri, 03 Feb 2023 02:59:36 -0500
X-MC-Unique: Mr8FmnZ5NZeLTPz_IhKGRQ-1
Received: by mail-qk1-f197.google.com with SMTP id i13-20020a05620a27cd00b0072b603cf869so2866223qkp.22
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 23:59:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QPp0pE5EXgzmra6b8YMgA6FtUNUnW1QTYupjEWodcAs=;
        b=BmgruZo2B+4wYt2IYqgaf0jf27Sw/JGYYIuFVR+XQPJNuS872+0M4jTcBqOAQZUm2Q
         1/mavCFNarARdUg8Es7oB281FA+Ds5JyAeF218qq2dFcIcnUqaEHHl9FV6hvFJQc6rs9
         DdZ/EpgdXieOzZF+qFXO1uufH1AbhRyDHZ2XJAHU14tmhxStJaUKTgg9UQc38NubplQu
         Eh18ggBA+4odQz9h19pedtxWqm4Ze/fDAMz12fej5e884eZmFP/oCG8FkcIiQ8xcpq0i
         nc2ra363kwBuyd6j9XMKWPEPdxrwRDjDvtaHRyQkhGPA65Oy1/6QDKfZwicTUhrWQxIt
         pGRg==
X-Gm-Message-State: AO0yUKU67ZRHNE1siA1vK5nKgoxjmp875RvDAXQNM34ZKXeP1R2U/d6P
        lXqVXRbhVyPKuxz+kOUXMxCm54u1GOAqvUOJXe89LkC6vfDuf8yAopmyJMcPCvCqQRzK1LSzgvh
        GjX7LkHzG6bd6E3QW
X-Received: by 2002:ac8:4908:0:b0:3b8:6c6e:4949 with SMTP id e8-20020ac84908000000b003b86c6e4949mr14963101qtq.4.1675411175605;
        Thu, 02 Feb 2023 23:59:35 -0800 (PST)
X-Google-Smtp-Source: AK7set8oTAnhQZndrKMfIfxyw4WaYhd+FDAyt+MuuOH4iYQOPtilJFRtIxnSDIzxvRKRw0ab9K7svQ==
X-Received: by 2002:ac8:4908:0:b0:3b8:6c6e:4949 with SMTP id e8-20020ac84908000000b003b86c6e4949mr14963085qtq.4.1675411175373;
        Thu, 02 Feb 2023 23:59:35 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id z10-20020ac8430a000000b003b646a99aa6sm1117995qtm.77.2023.02.02.23.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 23:59:34 -0800 (PST)
Message-ID: <db71bb74eb61fa09226ef5f2071747f35d67df82.camel@redhat.com>
Subject: Re: [PATCH net-next 4/4] net: add dedicated kmem_cache for
 typical/small skb->head
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Alexander Duyck <alexanderduyck@fb.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Date:   Fri, 03 Feb 2023 08:59:31 +0100
In-Reply-To: <20230202185801.4179599-5-edumazet@google.com>
References: <20230202185801.4179599-1-edumazet@google.com>
         <20230202185801.4179599-5-edumazet@google.com>
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

On Thu, 2023-02-02 at 18:58 +0000, Eric Dumazet wrote:
> Note: after Kees Cook patches and this one, we might
> be able to revert commit
> dbae2b062824 ("net: skb: introduce and use a single page frag cache")
> because GRO_MAX_HEAD is also small.

I guess I'll need some time to do the relevant benchmarks, but I'm not
able to schedule them very soon.

> @@ -486,6 +499,21 @@ static void *kmalloc_reserve(unsigned int *size, gfp=
_t flags, int node,
>  	void *obj;
> =20
>  	obj_size =3D SKB_HEAD_ALIGN(*size);
> +	if (obj_size <=3D SKB_SMALL_HEAD_CACHE_SIZE &&
> +	    !(flags & KMALLOC_NOT_NORMAL_BITS)) {
> +
> +		/* skb_small_head_cache has non power of two size,
> +		 * likely forcing SLUB to use order-3 pages.
> +		 * We deliberately attempt a NOMEMALLOC allocation only.
> +		 */
> +		obj =3D kmem_cache_alloc_node(skb_small_head_cache,
> +				flags | __GFP_NOMEMALLOC | __GFP_NOWARN,
> +				node);
> +		if (obj) {
> +			*size =3D SKB_SMALL_HEAD_CACHE_SIZE;
> +			goto out;
> +		}

In case kmem allocation failure, should we try to skip the 2nd=20
__GFP_NOMEMALLOC attempt below?

I *think* non power of two size is also required to avoid an issue
plain (no GFP_DMA nor __GFP_ACCOUNT) allocations in case of fallback to
kmalloc(), to prevent skb_kfree_head() mis-interpreting skb->head as
kmem_cache allocated.

Thanks!

Paolo

