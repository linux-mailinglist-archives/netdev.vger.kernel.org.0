Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0600C62F0A2
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 10:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241753AbiKRJLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 04:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241622AbiKRJLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 04:11:16 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0DDE140D7
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 01:11:15 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id g2so4603716wrv.6
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 01:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uwIMstugFjvC26xnxtrGyNiC2iOLrrdjIjfOy4MwghE=;
        b=B93YL28hCXjKS+FUX0WYbcIKB03wdF907plkl8f6BXvu/zien86QjcCU/5N9B2XMue
         8Oo6tZMObBZLs7GzRfbBcqjXAxUvNBBdyQaThaf4Ie3acEj4ZZCBcIfMWp9VfiK/qWpm
         wqXS06pc83GlkEcmoABohxR3L8GnVsTrkGTwa4K1Z7yQKLo1Z9uQYda1ZI4BHHtbdSRp
         boYdBvDLF2CtIKRi9yN6D+OTbqYkacD/cjJiw/M4BOYj62nfbbVr8xcKW098+zHagZDU
         ONKXrNYXHrOtD14gSlQrFDG4WhVIC9/km8IrBLJ35jTk+YL4KVNPKImPsd1mcgHFPhFL
         Ncsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uwIMstugFjvC26xnxtrGyNiC2iOLrrdjIjfOy4MwghE=;
        b=cTd0s061ZyCRTnmW+1l+2qDQU9h17Vhl14CM0bUwTVrRQQer9KGAJf6WJdBMceX3c2
         4KeJ8dtxw5bqATx087sPmBktytyQxJ4ptQFjMdOlM3DxVjEkHI+wB50A91hQ2VtA97kG
         9nItef6n5TBv+rB+giZ4YhojPOnmST8cSv6ZBQdYJ0eyIcbMKQtczQqpsO7kG91TGX1a
         MtjpYXcM04fU0BY1Nr2lswdnhtrSLYvgPuGffCrbdsLjQvEHiQ/okSq4okgifPQqw4UT
         KrCkD0ydRgqln/UCVt+dqXFL/ssYEwg3s4deQ2rYpowAGvh25RnZidwnqK/EgjMkWmha
         7ILw==
X-Gm-Message-State: ANoB5pnvJJdjhHiv+2oqlgrEVf4Y4hqAZOfCVppgh7r/5XkyXytWUEW6
        xjoucuGIh6R+b5T30GlpTA7410zm+YQ=
X-Google-Smtp-Source: AA0mqf4RroaYYwKxeLoeeb9k6fBt2we87m3gBD8gvGyWpvHAEMTu2JULcum1poJjycsVz84CLMDfKw==
X-Received: by 2002:adf:e3cd:0:b0:241:bc27:f8b6 with SMTP id k13-20020adfe3cd000000b00241bc27f8b6mr2904625wrm.367.1668762674115;
        Fri, 18 Nov 2022 01:11:14 -0800 (PST)
Received: from suse.localnet (host-79-26-100-208.retail.telecomitalia.it. [79.26.100.208])
        by smtp.gmail.com with ESMTPSA id e28-20020adfa45c000000b00228cbac7a25sm3101384wra.64.2022.11.18.01.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 01:11:13 -0800 (PST)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     netdev@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Subject: Re: [PATCH net-next 5/5] sunvnet: Use kmap_local_page() instead of kmap_atomic()
Date:   Fri, 18 Nov 2022 10:11:12 +0100
Message-ID: <2373606.NG923GbCHz@suse>
In-Reply-To: <20221117222557.2196195-6-anirudh.venkataramanan@intel.com>
References: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com> <20221117222557.2196195-6-anirudh.venkataramanan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On gioved=EC 17 novembre 2022 23:25:57 CET Anirudh Venkataramanan wrote:
> kmap_atomic() is being deprecated in favor of kmap_local_page().
> Replace kmap_atomic() and kunmap_atomic() with kmap_local_page()
> and kunmap_local() respectively.
>=20
> Note that kmap_atomic() disables preemption and page-fault processing,
> but kmap_local_page() doesn't. Converting the former to the latter is safe
> only if there isn't an implicit dependency on preemption and page-fault
> handling being disabled, which does appear to be the case here.
>=20
> Also note that the page being mapped is not allocated by the driver, and =
so
> the driver doesn't know if the page is in normal memory. This is the reas=
on
> kmap_local_page() is used as opposed to page_address().
>=20
> I don't have hardware, so this change has only been compile tested.
>=20
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> ---
>  drivers/net/ethernet/sun/sunvnet_common.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/sun/sunvnet_common.c
> b/drivers/net/ethernet/sun/sunvnet_common.c index 80fde5f..a6211b9 100644
> --- a/drivers/net/ethernet/sun/sunvnet_common.c
> +++ b/drivers/net/ethernet/sun/sunvnet_common.c
> @@ -1085,13 +1085,13 @@ static inline int vnet_skb_map(struct ldc_channel=
=20
*lp,
> struct sk_buff *skb, u8 *vaddr;
>=20
>  		if (nc < ncookies) {
> -			vaddr =3D kmap_atomic(skb_frag_page(f));
> +			vaddr =3D kmap_local_page(skb_frag_page(f));
>  			blen =3D skb_frag_size(f);
>  			blen +=3D 8 - (blen & 7);
>  			err =3D ldc_map_single(lp, vaddr +=20
skb_frag_off(f),
>  					     blen, cookies + nc,=20
ncookies - nc,
>  					     map_perm);
> -			kunmap_atomic(vaddr);
> +			kunmap_local(vaddr);
>  		} else {
>  			err =3D -EMSGSIZE;
>  		}
> --
> 2.37.2

Reviewed-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>

Thanks,

=46abio



