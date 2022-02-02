Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB2E4A6FC5
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 12:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343840AbiBBLSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 06:18:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38994 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235386AbiBBLSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 06:18:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F119EB82FB3
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 11:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C75C004E1;
        Wed,  2 Feb 2022 11:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643800681;
        bh=qpmN6bEcg9hnbOUO5oHkaLULVswOqWFUc5Il9EuTfcM=;
        h=In-Reply-To:References:From:Subject:Cc:To:Date:From;
        b=dfsuQrZ1wRsQYUVAKeWrwrh4I3in43WhfhK16FRF5PoWpifa2u9Ri0lf7cy4nHq/S
         qteJX3+G8oT7+x2o4bsCVsOaKFJdd5Bpo5yk8EOfvO0qOhoWLstwCQpU+AI1rLIpq8
         bINEref8H+p/sbtHMhn/Abrqwk8U/aGexZ6fKKN025d35Q8xhoIG2yC9gRgnFpxQNs
         aBax2gFy5H4m6aAFBKxtV5nkfix+Jd9gNP44zdcX2IFBHny0Z2HPUm+brRVGGxKnO6
         VLyTUZP2ABW1IyUr1nDvc5MWOnONKAGjzFXnRsaWq2JOIjQZE441RoNEh9yXnxqcSC
         35+14bhZ4HtKQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220202110137.470850-2-atenart@kernel.org>
References: <20220202110137.470850-1-atenart@kernel.org> <20220202110137.470850-2-atenart@kernel.org>
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net 1/2] net: do not keep the dst cache when uncloning an skb dst and its metadata
Cc:     netdev@vger.kernel.org, vladbu@nvidia.com, pabeni@redhat.com,
        pshelar@ovn.org
To:     davem@davemloft.net, kuba@kernel.org
Message-ID: <164380067869.380114.4818810317463668304@kwain>
Date:   Wed, 02 Feb 2022 12:17:58 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Antoine Tenart (2022-02-02 12:01:36)
> When uncloning an skb dst and its associated metadata a new dst+metadata
> is allocated and the tunnel information from the old metadata is copied
> over there.
>=20
> The issue is the tunnel metadata has references to cached dst, which are
> copied along the way. When a dst+metadata refcount drops to 0 the
> metadata is freed including the cached dst entries. As they are also
> referenced in the initial dst+metadata, this ends up in UaFs.
>=20
> In practice the above did not happen because of another issue, the
> dst+metadata was never freed because its refcount never dropped to 0
> (this will be fixed in a subsequent patch).
>=20
> Fix this by initializing the dst cache after copying the tunnel
> information from the old metadata to also unshare the dst cache.
>=20
> Fixes: d71785ffc7e7 ("net: add dst_cache to ovs vxlan lwtunnel")
> Cc: Paolo Abeni <pabeni@redhat.com>
> Reported-by: Vlad Buslov <vladbu@nvidia.com>
> Tested-by: Vlad Buslov <vladbu@nvidia.com>
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> ---
>  include/net/dst_metadata.h | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>=20
> diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
> index 14efa0ded75d..c8f8b7b56bba 100644
> --- a/include/net/dst_metadata.h
> +++ b/include/net/dst_metadata.h
> @@ -110,8 +110,8 @@ static inline struct metadata_dst *tun_rx_dst(int md_=
size)
>  static inline struct metadata_dst *tun_dst_unclone(struct sk_buff *skb)
>  {
>         struct metadata_dst *md_dst =3D skb_metadata_dst(skb);
> -       int md_size;
>         struct metadata_dst *new_md;
> +       int md_size, ret;

Hmmm ret should probably be defined inside a CONFIG_DST_CACHE section.

>         if (!md_dst || md_dst->type !=3D METADATA_IP_TUNNEL)
>                 return ERR_PTR(-EINVAL);
> @@ -123,6 +123,17 @@ static inline struct metadata_dst *tun_dst_unclone(s=
truct sk_buff *skb)
> =20
>         memcpy(&new_md->u.tun_info, &md_dst->u.tun_info,
>                sizeof(struct ip_tunnel_info) + md_size);
> +#ifdef CONFIG_DST_CACHE
> +       ret =3D dst_cache_init(&new_md->u.tun_info.dst_cache, GFP_ATOMIC);
> +       if (ret) {
> +               /* We can't call metadata_dst_free directly as the still =
shared
> +                * dst cache would be released.
> +                */
> +               kfree(new_md);
> +               return ERR_PTR(ret);
> +       }
> +#endif
> +
>         skb_dst_drop(skb);
>         dst_hold(&new_md->dst);
>         skb_dst_set(skb, &new_md->dst);
> --=20
> 2.34.1
>=20
