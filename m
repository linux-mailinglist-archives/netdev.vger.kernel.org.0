Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81105640FF9
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 22:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbiLBV0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 16:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234582AbiLBV0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 16:26:03 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C48F1145
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 13:25:58 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id t11-20020a17090a024b00b0021932afece4so9438974pje.5
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 13:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jBNUTCSkkYzvGe+KqD5Q14RPIoFCYbk500Bx/00wZJY=;
        b=iJkJGBrXv95E5Xj4ETzcLdCsj029lB89lWExskYIeZxTv/LdsDj1DHERq3RiKoS6Ki
         zDTC4P4fKvv+a3iVLFyXPsVx0fvRJzUjL/6HXCWI2MQku4HyrRPfLNn7bfpLaRErH4UE
         RyMGboHjrjyVragQGGBsbS3u2Y59gS+AumNAP3mZxIU2MJ5RtWY+rJmGaGsl6zcpCCCs
         gRKsnaBhvoDqJbtAmGiZrtVFeG6LgczOo6/vtaePyjC2LOpvkoPeje6wqU3cy7Yvs1Ot
         DWU1PD1bH418oTp/kLsmeasUB6Omu3vXe+WFS3B9d2frbXlua/WI0AdGb4PRBJi0Xadf
         7VLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jBNUTCSkkYzvGe+KqD5Q14RPIoFCYbk500Bx/00wZJY=;
        b=HLseC43o5TleB4xyWWpzpFo+Kg7fBV7kMQ+7WUDmn4nH2AFhTYl41hEuf5UyWlAVPB
         yyYPgXWuy9H9fJh/vC6vpeYXWkD7n4yWCk1A8KGqEiHwtn7CvmBgyp88cFt3VyhclYrM
         nNjlT0RCDOJay4/DxiW/Z1bLmnlQILYb/gKb0rrG6YhqzetCnR4WFkjO1XxPCbb4xKfF
         MVDi5wnPjEY51P/39jsQgjYOvEHRWZnVoJ0A0IuSBP5JnXPweIyD90ya0oedvb31E7YG
         WXTW5sqGdyzc4wlQ6I1SjJm8y8jstxp2IFZLXCMF47StYwbhXOyex72MuoKkTT7iA1lj
         l09A==
X-Gm-Message-State: ANoB5pn89YJ6PT8gjETCQwVpmeMnv2zEu/PH2Y7KbGpipY/tO04zsugP
        nyc0v3/ZEMDsBbeM8TXi3fM=
X-Google-Smtp-Source: AA0mqf50lmP3jPdFlvHqEIhm8sTHJT/0joZz+V7FietxbIA4yTK/IO1Sg97saaEsaSMl25RVMWVsLg==
X-Received: by 2002:a17:902:7585:b0:186:ee56:4a14 with SMTP id j5-20020a170902758500b00186ee564a14mr53714012pll.158.1670016357294;
        Fri, 02 Dec 2022 13:25:57 -0800 (PST)
Received: from [192.168.0.128] ([98.97.42.38])
        by smtp.googlemail.com with ESMTPSA id g18-20020a170902e39200b00188a908cbddsm5919765ple.302.2022.12.02.13.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 13:25:56 -0800 (PST)
Message-ID: <12edd3e450e3dd596e3048609455bfc295e37dee.camel@gmail.com>
Subject: Re: [PATCH 11/24] page_pool: Convert page_pool_empty_ring() to use
 netmem
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, linux-mm@kvack.org
Date:   Fri, 02 Dec 2022 13:25:55 -0800
In-Reply-To: <20221130220803.3657490-12-willy@infradead.org>
References: <20221130220803.3657490-1-willy@infradead.org>
         <20221130220803.3657490-12-willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-11-30 at 22:07 +0000, Matthew Wilcox (Oracle) wrote:
> Retrieve a netmem from the ptr_ring instead of a page.
>=20
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  net/core/page_pool.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index e727a74504c2..7a77e3220205 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -755,16 +755,16 @@ EXPORT_SYMBOL(page_pool_alloc_frag);
> =20
>  static void page_pool_empty_ring(struct page_pool *pool)
>  {
> -	struct page *page;
> +	struct netmem *nmem;
> =20
>  	/* Empty recycle ring */
> -	while ((page =3D ptr_ring_consume_bh(&pool->ring))) {
> +	while ((nmem =3D ptr_ring_consume_bh(&pool->ring)) !=3D NULL) {
>  		/* Verify the refcnt invariant of cached pages */
> -		if (!(page_ref_count(page) =3D=3D 1))
> +		if (!(netmem_ref_count(nmem) =3D=3D 1))

One minor code nit here is that this could just be:
		if (netmem_ref_count(nmem) !=3D 1)

>  			pr_crit("%s() page_pool refcnt %d violation\n",
> -				__func__, page_ref_count(page));
> +				__func__, netmem_ref_count(nmem));
> =20
> -		page_pool_return_page(pool, page);
> +		page_pool_return_netmem(pool, nmem);
>  	}
>  }
> =20

