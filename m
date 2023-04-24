Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 903AB6ED36B
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 19:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbjDXRTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 13:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbjDXRTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 13:19:15 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A34A17D84;
        Mon, 24 Apr 2023 10:19:11 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f193ca059bso22638325e9.3;
        Mon, 24 Apr 2023 10:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682356749; x=1684948749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q5ffUKulywUVWsUyD54zTOn22OGaFxg4joquRNd4FgQ=;
        b=WUz8je7TAP9X0ZWTXN/DcIyVw3PSqQ6c+xZTy4D0RLal25VJ7IsPKmZdWbLw3jz7/K
         KVlkJcMB3+qjXl8qVGPpaChDawz7eLxlQnFKgYMc3g08s+N0nY4+q6TNXc2rli8wuJHf
         gcYnXs9U8/XouCegDQatfFV1D32O4Ui/ia3LrDFjUqR13p0pb0iEoTSkV9HrmAIC0DQo
         1WEX2Vlu2Yho7dNkddLYnS4CcmcC/Ts+qaCzq0/pt00EcYBTQajLEBRbiURDAK9YXx90
         439jUXDRabDTH9xDYyaHCEaAGhJJl2Fnclqag4G+/3vhHEyvO2IDXHin3qWrozA5ak49
         nQ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682356749; x=1684948749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q5ffUKulywUVWsUyD54zTOn22OGaFxg4joquRNd4FgQ=;
        b=EWgHU/CryEjsX86WOx2Vvle9K3Zudf3wuaWRat8cz6/siSX0tQfmjU5hGwHWas84bs
         /t57bgL/X4GlSvfZDKpITTOuqi57O9ZDbTVaPLFm1n6+kzpPu5BOYkX2cpPRxIULXgYm
         Em/n1oxxIdYeROpYdsWUgv16HEcSu6VePHY3IZXeYgTDKzEYR3WKQFuWdxdwxLOVc8Eu
         UYGxPxmmICYreGfyf/CPQiP7LarnsVT4QPGDcaXisltiEqoZi0p5OBikokK4GpFYKtc8
         f8n8N59yylMoZpy2ovuYCp8VTzQXVc6iZoh6m7P/4VMsDsu4vwec5AEyS8G31r8r+avX
         nSAg==
X-Gm-Message-State: AAQBX9fph4omxg9WFHi6LtlfijD9mGFgy6F+oeTkWtGjHQ3mCyElCUfx
        LLiivvATTp+rc6zUCSseOEM=
X-Google-Smtp-Source: AKy350Ywom400cz3IyOOqt4vzhP+ONiCCOrenGpF0cgItGHbLrhWmKEBovxp3ORq5wPXvjxIpaC9iw==
X-Received: by 2002:a05:600c:22d4:b0:3f1:82c6:2d80 with SMTP id 20-20020a05600c22d400b003f182c62d80mr8679594wmg.5.1682356749143;
        Mon, 24 Apr 2023 10:19:09 -0700 (PDT)
Received: from suse.localnet (host-79-36-111-57.retail.telecomitalia.it. [79.36.111.57])
        by smtp.gmail.com with ESMTPSA id m18-20020a7bcb92000000b003f24f245f57sm3884154wmi.42.2023.04.24.10.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 10:19:08 -0700 (PDT)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     David Howells <dhowells@redhat.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH v3 41/55] iscsi: Assume "sendpage" is okay in
 iscsi_tcp_segment_map()
Date:   Mon, 24 Apr 2023 19:19:04 +0200
Message-ID: <1957131.PYKUYFuaPT@suse>
In-Reply-To: <20230331160914.1608208-42-dhowells@redhat.com>
References: <20230331160914.1608208-1-dhowells@redhat.com>
 <20230331160914.1608208-42-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On venerd=EC 31 marzo 2023 18:09:00 CEST David Howells wrote:
> As iscsi is now using sendmsg() with MSG_SPLICE_PAGES rather than sendpag=
e,
> assume that sendpage_ok() will return true in iscsi_tcp_segment_map() and
> leave it to TCP to copy the data if not.
>=20
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Eric Dumazet <edumazet@google.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: linux-scsi@vger.kernel.org
> cc: target-devel@vger.kernel.org
> cc: netdev@vger.kernel.org
> ---
>  drivers/scsi/libiscsi_tcp.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
> index c182aa83f2c9..07ba0d864820 100644
> --- a/drivers/scsi/libiscsi_tcp.c
> +++ b/drivers/scsi/libiscsi_tcp.c
> @@ -128,18 +128,11 @@ static void iscsi_tcp_segment_map(struct iscsi_segm=
ent
> *segment, int recv) * coalescing neighboring slab objects into a single f=
rag
> which
>  	 * triggers one of hardened usercopy checks.
>  	 */
> -	if (!recv && sendpage_ok(sg_page(sg)))
> +	if (!recv)
>  		return;
>=20
> -	if (recv) {
> -		segment->atomic_mapped =3D true;
> -		segment->sg_mapped =3D kmap_atomic(sg_page(sg));
> -	} else {
> -		segment->atomic_mapped =3D false;
> -		/* the xmit path can sleep with the page mapped so use=20
kmap */
> -		segment->sg_mapped =3D kmap(sg_page(sg));
> -	}
> -
> +	segment->atomic_mapped =3D true;
> +	segment->sg_mapped =3D kmap_atomic(sg_page(sg));

As you probably know, kmap_atomic() is deprecated.

I must admit that I'm not an expert of this code, however, it looks like th=
e=20
mapping has no need to rely on the side effects of kmap_atomic() (i.e.,=20
pagefault_disable() and preempt_disable() - but I'm not entirely sure about=
=20
the possibility that preemption should be explicitly disabled along with th=
e=20
replacement with kmap_local_page()).=20

Last year I've been working on several conversions from kmap{,_atomic}() to=
=20
kmap_local_page(), however I'm still not sure to understand what's happenin=
g=20
here...

Am I missing any important details? Can you please explain why we still nee=
d=20
that kmap_atomic() instead of kmap_local_page()?=20

Thanks in advance,

=46abio

>  	segment->data =3D segment->sg_mapped + sg->offset + segment-
>sg_offset;
>  }




