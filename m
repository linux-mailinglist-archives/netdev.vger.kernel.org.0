Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29ED69941C
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 13:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjBPMQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 07:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjBPMQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 07:16:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291E51706
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 04:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676549735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e+i3MFuwVD10qTjm/s7spd20aqFKFXzVYJOnemHHswM=;
        b=erq/99Xv2wmUr4YwRkjl9/M1XPvAlpSUcv6jKEBrw2/WMnpnDbWoZ+b/sThJZs490ZhU+p
        plQe6vnqMhQS1YUEmhTzg6x29gg3E0nM5qyGkLx2rf6x7YHtz2VeX/n51GqxR2fQZwEWwy
        R4irB2Om4EK5hRipIBHueiCMgUr7Vmc=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-378-N_fApPJkMGGMIrz8dpEUVg-1; Thu, 16 Feb 2023 07:15:34 -0500
X-MC-Unique: N_fApPJkMGGMIrz8dpEUVg-1
Received: by mail-qk1-f199.google.com with SMTP id j10-20020a05620a288a00b0070630ecfd9bso1053884qkp.20
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 04:15:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676549731;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e+i3MFuwVD10qTjm/s7spd20aqFKFXzVYJOnemHHswM=;
        b=fUd5jk2OvD1IgYvz9d9y98BC6UfBZ2dkDi8zNyoqIoJk17mWrlD+WNcVKwKQNv7YQk
         BVJK8qLVHbFnsUxwox5aVvC+guWJdpjgt7sMh6x7lzj3pWCUod4P4XcoK5JTucO5fRan
         CX5JdDvpF9lwKMJh3xrgRhVTeuubx04G7k/9+zLtT89SOmSE0LsxhVQe0v/n1wihoaTP
         dYNZD48GKR5xX/xVxKiPIIT9fHZxnIEI27AdH2Fmi9fFFyEGJeRTJ/5EgARavzq6M2Ey
         1t9B9fdsZwCjJHLfCrtsZ2P9ozMqH9hkfdHa2s1d/dT6goTW9Pm87dqBeO1+kLAZU4DA
         YYlw==
X-Gm-Message-State: AO0yUKVg1in70qRsvl9isYtPZm5MLiUAzu0nEMaoxYKy8SiSaYdOHIha
        Uo/vG5IcfjSLOoBTRBjQR0mlCFFbYdotACiXl1ZLihTzMvEJbFuqqDCiEdyZ24d7r9ojGOC2R3O
        ONKKWGnfflKV1dfpE
X-Received: by 2002:a05:622a:309:b0:3b8:6bef:61df with SMTP id q9-20020a05622a030900b003b86bef61dfmr10629632qtw.6.1676549730962;
        Thu, 16 Feb 2023 04:15:30 -0800 (PST)
X-Google-Smtp-Source: AK7set/V7kFydJ2/EWd7gUUgvw80HLCSfL8rnhCoL8Ca1WTha6MPQ8CplV++7+47sxg9BBVS1y7JIQ==
X-Received: by 2002:a05:622a:309:b0:3b8:6bef:61df with SMTP id q9-20020a05622a030900b003b86bef61dfmr10629610qtw.6.1676549730728;
        Thu, 16 Feb 2023 04:15:30 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id ff23-20020a05622a4d9700b003b68ea3d5c8sm1107114qtb.41.2023.02.16.04.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 04:15:30 -0800 (PST)
Message-ID: <1df6e19ddadaedcfe67f47b93610778763bf63fa.camel@redhat.com>
Subject: Re: [PATCH net-next 2/2] skbuff: Add likely to skb pointer in
 build_skb()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Gal Pressman <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Tariq Toukan <tariqt@nvidia.com>
Date:   Thu, 16 Feb 2023 13:15:27 +0100
In-Reply-To: <20230215121707.1936762-3-gal@nvidia.com>
References: <20230215121707.1936762-1-gal@nvidia.com>
         <20230215121707.1936762-3-gal@nvidia.com>
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

On Wed, 2023-02-15 at 14:17 +0200, Gal Pressman wrote:
> Similarly to napi_build_skb(), it is likely the skb allocation in
> build_skb() succeeded.
>=20
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> ---
>  net/core/skbuff.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 069604b9ff9d..3aa9687d7546 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -420,7 +420,7 @@ struct sk_buff *build_skb(void *data, unsigned int fr=
ag_size)
>  {
>  	struct sk_buff *skb =3D __build_skb(data, frag_size);
> =20
> -	if (skb && frag_size) {
> +	if (likely(skb) && frag_size) {

I concur with Jakub: frag_size !=3D 0 is a likely event. Additionally,
without including 'frag_size' into the likely() annotation the compiler
could consider the whole branch not likely: I think should be:

	if (likely(skb && frag_size)) {

Cheers,

Paolo

