Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 945385BFE1C
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiIUMnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiIUMnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:43:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B0286887;
        Wed, 21 Sep 2022 05:43:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 484ADB81B1C;
        Wed, 21 Sep 2022 12:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55148C433D6;
        Wed, 21 Sep 2022 12:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663764179;
        bh=9SIsgEZDXH7+JI+d9iRn2G0EfLXDT4/JWJpJozreBdw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MTPc36+TcxZoaVX6OfmzqolFrEa4eQjyXWca93IU01neVV8qA4SlqSUsUFqf7bgtr
         /sLQIwvfg5W/0O1kmdCEWlda9w/4/8e3nhS3lpFI8Bb6kXauCXYQaJVCjX69SaHYZO
         xpjrhFg8lbVMCtWoM/DOJ8awGrUfqYqtFCrA2GJ5ORSNLs4kptlA8nLbcYSlU8myip
         m6omQYK//fzm/M4HLAkJs1vN3dWamRnCWkaa+QLK1Dub24JK2iXwagLqXBDb79wZ2Q
         sH6yXl7xLKveMEOf4Ftr/TJuSIiOLRqxlSVsK80lRxxJ5qEWFkDTfiZIUGIXyq4v+0
         GxPIL5s6pKs1Q==
Date:   Wed, 21 Sep 2022 05:42:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     Sevinj Aghayeva <sevinj.aghayeva@gmail.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        aroulin@nvidia.com, sbrivio@redhat.com, roopa@nvidia.com,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH RFC net-next 0/5] net: vlan: fix bridge binding behavior
 and add selftests
Message-ID: <20220921054258.41e06387@kernel.org>
In-Reply-To: <3f2d6682-7c5c-5a6d-110b-568331650949@blackwall.org>
References: <cover.1663445339.git.sevinj.aghayeva@gmail.com>
        <78bd0e54-4ee3-bd3c-2154-9eb8b9a70497@blackwall.org>
        <20220920162954.1f4aaf7b@kernel.org>
        <3f2d6682-7c5c-5a6d-110b-568331650949@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Sep 2022 07:45:07 +0300 Nikolay Aleksandrov wrote:
> > IDK, vlan knows it's calling the bridge:
> >=20
> > +	if ((vlan->flags ^ old_flags) & VLAN_FLAG_BRIDGE_BINDING &&
> > +	    netif_is_bridge_master(vlan->real_dev)) {
>=20
> This one is more of an optimization so notifications are sent only when t=
he bridge
> is involved, it can be removed if other interested parties show up.
>=20
> > bridge knows it's vlan calling:
> >=20
> > +	if (is_vlan_dev(dev)) {
> > +		br_vlan_device_event(dev, event, ptr);
> >=20
> > going thru the generic NETDEV notifier seems odd.
> >=20
> > If this is just to avoid the dependency we can perhaps add a stub=20
> > like net/ipv4/udp_tunnel_stub.c ?
>=20
> I suggested the notifier to be more generic and be able to re-use it for =
other link types although
> I don't have other use cases in mind right now. Stubs are an alternative =
as long as they and
> their lifetime are properly managed. I don't have a strong preference her=
e so if you prefer
> stubs I'm good.

Yup, stub seems simpler and more efficient to me. Only time will
tell if indeed this ntf type would have been reused further.. =F0=9F=A4=B7
