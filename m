Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04C296EE28D
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 15:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbjDYNNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 09:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234080AbjDYNNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 09:13:39 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BD32D54;
        Tue, 25 Apr 2023 06:13:38 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f19c473b9eso81762685e9.0;
        Tue, 25 Apr 2023 06:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682428416; x=1685020416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fw45IBooJRHvDJP+m4fpf4zEkBLCSMIA1zdZRImyULk=;
        b=ZFeQwY+mbxyNnRrEcmbP0LbvvvP/dsWeQIgdx1wq33ZQUes3ma9nFUCuBK4hm9D8t9
         2vSSeOMEyQ0LiP9Ea/aEulIGGvevMxeLnyX30c2Z5/j52tRL1eu/G6MO48aSwKCZDfpC
         M0NVlp9ax8nlQDdqPDKR/yoGIZCdMkr6QVhAm8ZAcoC5L6Yij/fAwxda3Z4Rxsvayym3
         ZIS0XIf5s1yauv4Dgt35c/+032/XoKewUsehNTRpykyaCw6+7fnF3R558UUePAloGEGs
         PwcryNMTI0ukCsjuIH+CmyQDVcehbv3oFZAOXlwjAyW81xxSy/RdsbbTFIF30oHWwQ0e
         mFpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682428416; x=1685020416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fw45IBooJRHvDJP+m4fpf4zEkBLCSMIA1zdZRImyULk=;
        b=RyoJgrdyvOvZVONejWGV16t0bYoRNJ5BgrK9dfF44ZMliyPtASmNeLiYsG4M5HyMJI
         wY+2JT3zgBMR9WVd9RJdoO05smisnaelV6lY9+hYscvXl5qAnym1TeGzVlll7LIdUPEv
         XaQPXs4jz/VFvUGQl8AaVNVK+t4+t7FT5+reFcYMG37rc4QwqIp6CQ6kdzh6K8V0aaKZ
         xEmU91GTreTGCWPYPywFDTjGJ0ipr+TemPLJvapKW4jFsiqFbT1Dvh89C/1ZNgmc8loE
         5E7k/5XeJvSv5Ylx2ked7JmZipkgt5SjaIBjRO2+2AQj8qx6dPgFIM1pfPha+u58xHBv
         zbqw==
X-Gm-Message-State: AAQBX9fNaIiMCEk2oiRK/VoavQ3c05raDbq1wDvItdNfp8eh7LxWdGwX
        Ivp8zOJsApAZWgaUQb8SZD9h9y4JsdY=
X-Google-Smtp-Source: AKy350Z8ytvRYve3cZYjp0OE8W8Wzr1SScE5AHXMmPrw8AtAgr1i/+uLqhz9f/CdQgqVBDusJJLr4Q==
X-Received: by 2002:a7b:cc15:0:b0:3f1:65cb:8156 with SMTP id f21-20020a7bcc15000000b003f165cb8156mr10532957wmh.0.1682428416163;
        Tue, 25 Apr 2023 06:13:36 -0700 (PDT)
Received: from suse.localnet (host-95-245-6-24.retail.telecomitalia.it. [95.245.6.24])
        by smtp.gmail.com with ESMTPSA id d3-20020a05600c3ac300b003f19b3d89e9sm8697700wms.33.2023.04.25.06.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 06:13:35 -0700 (PDT)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     David Howells <dhowells@redhat.com>
Cc:     dhowells@redhat.com, Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
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
Date:   Tue, 25 Apr 2023 15:13:33 +0200
Message-ID: <16526634.geO5KgaWL5@suse>
In-Reply-To: <494037.1682411430@warthog.procyon.org.uk>
References: <1957131.PYKUYFuaPT@suse> <20230331160914.1608208-42-dhowells@redhat.com>
 <494037.1682411430@warthog.procyon.org.uk>
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

On marted=EC 25 aprile 2023 10:30:30 CEST David Howells wrote:
> Fabio M. De Francesco <fmdefrancesco@gmail.com> wrote:
> > > -	if (recv) {
> > > -		segment->atomic_mapped =3D true;
> > > -		segment->sg_mapped =3D kmap_atomic(sg_page(sg));
> > > -	} else {
> > > -		segment->atomic_mapped =3D false;
> > > -		/* the xmit path can sleep with the page mapped so use
> >=20
> > kmap */
> >=20
> > > -		segment->sg_mapped =3D kmap(sg_page(sg));
> > > -	}
> > > -
> > > +	segment->atomic_mapped =3D true;
> > > +	segment->sg_mapped =3D kmap_atomic(sg_page(sg));
> >=20
> > As you probably know, kmap_atomic() is deprecated.
> >=20
> > I must admit that I'm not an expert of this code, however, it looks lik=
e=20
the
> > mapping has no need to rely on the side effects of kmap_atomic() (i.e.,
> > pagefault_disable() and preempt_disable() - but I'm not entirely sure=20
about
> > the possibility that preemption should be explicitly disabled along wit=
h=20
the
> > replacement with kmap_local_page()).
> >=20
> > Last year I've been working on several conversions from kmap{,_atomic}(=
)=20
to
> > kmap_local_page(), however I'm still not sure to understand what's=20
happening
> > here...
> >=20
> > Am I missing any important details? Can you please explain why we still=
=20
need
> > that kmap_atomic() instead of kmap_local_page()?
>=20
> Actually, it might be worth dropping segment->sg_mapped and segment->data=
=20
and
> only doing the kmap_local when necessary.
>=20
> And this:
>=20
> 			struct msghdr msg =3D { .msg_flags =3D flags };
> 			struct kvec iov =3D {
> 				.iov_base =3D segment->data + offset,
> 				.iov_len =3D copy
> 			};
>=20
> 			r =3D kernel_sendmsg(sk, &msg, &iov, 1, copy);
>=20
> should really be using struct bvec, not struct kvec - then the mapping is=
n't
> necessary.

=46WIW, struct bvec looks better suited (despite I have very little knowled=
ge of=20
this code).

I assume that you noticed that we also have the unmapping counterpart=20
(iscsi_tcp_segment_unmap()) which should also be addressed accordingly.

> It looks like this might be the only place the mapping is used,
> but I'm not 100% certain.

It seems that kmap_atomic() (as well as kmap(), which you deleted) is only=
=20
called by iscsi_tcp_segment_map(), which in turn is called only by =20
iscsi_tcp_segment_done(). I can't see any other places where the mapping is=
=20
used.

I hope that this dialogue may help you somehow to choose the best suited wa=
y=20
to get rid of that deprecated kmap_atomic().

Thanks for taking time to address questions from newcomers :-)=20

=46abio

>=20
> David




