Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1FA4A7316
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 15:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344963AbiBBO3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 09:29:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344964AbiBBO3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 09:29:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D1CC06173B
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 06:29:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47BF5B83106
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 14:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867C4C004E1;
        Wed,  2 Feb 2022 14:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643812153;
        bh=1MwwpzGG8bljs8RRYKIYw6dBW/OnZzZdKukJzCHfJDE=;
        h=In-Reply-To:References:From:Subject:Cc:To:Date:From;
        b=KynmxMwLnD/benlmB7FrYwBf0+SX38Piefu3Vpc+yHRxgRTcnPaK5vz3FHGQIXywo
         oF6ZXvhk/G05q7FIkHZ/n3hE37Hw4mBRrWj5DUkZYMrYw6My3HPxMWE8nGhp4aDyQ4
         7XfL72ZnWbVmCGai/yguNI9VaYSWZmTpfpNFLd2iRYRry+h5z80sn8AEc/RJ2ZY8m7
         pgLeD2RFsK4azkptzTEJvUeTef5XKYxVptjGgJjaik5vWcildUs7yFFGJilXeX9Cfq
         cEkm8KQTCu4Jm5IAeYdVvl9voyd3hLjyN6F1/3pkyutfmvWBlr4R8VCZfwywM37PZl
         oUhj8cJsLldCw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <c699ed79feb4f86f02e882597bffd8c91782d573.camel@redhat.com>
References: <20220202110137.470850-1-atenart@kernel.org> <20220202110137.470850-2-atenart@kernel.org> <c699ed79feb4f86f02e882597bffd8c91782d573.camel@redhat.com>
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net 1/2] net: do not keep the dst cache when uncloning an skb dst and its metadata
Cc:     netdev@vger.kernel.org, vladbu@nvidia.com, pshelar@ovn.org
To:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org
Message-ID: <164381215019.380114.11003803249824068036@kwain>
Date:   Wed, 02 Feb 2022 15:29:10 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Paolo Abeni (2022-02-02 15:24:51)
> On Wed, 2022-02-02 at 12:01 +0100, Antoine Tenart wrote:
> >       memcpy(&new_md->u.tun_info, &md_dst->u.tun_info,
> >              sizeof(struct ip_tunnel_info) + md_size);
> > +#ifdef CONFIG_DST_CACHE
> > +     ret =3D dst_cache_init(&new_md->u.tun_info.dst_cache, GFP_ATOMIC);
> > +     if (ret) {
> > +             /* We can't call metadata_dst_free directly as the still =
shared
> > +              * dst cache would be released.
> > +              */
> > +             kfree(new_md);
>=20
> I think here you can use metadata_dst_free(): if dst_cache_init fails,
> the dst_cache will be zeroed.

You're right, I'll use it in v2.

Thanks!
Antoine
