Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 809BA5A76AB
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 08:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiHaGbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 02:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiHaGba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 02:31:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01444BD4D3;
        Tue, 30 Aug 2022 23:31:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6654CB81F3D;
        Wed, 31 Aug 2022 06:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B23C433C1;
        Wed, 31 Aug 2022 06:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661927486;
        bh=JHOAZyhWKsyyrrjvYUmJEzZv4y2TP3kHlAK3zqmtbn4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Lp4cMfGF8lXAapMFgAoZxlnDSc0FxPBq5M6btvE0LGSrPLjO0dL6spPRiiVo/of+9
         jwqQVyuQZjqBl7P1dOmbgYMAd2czaa9cp8i49q5Er7gRylLRmM9uyNSO9yW9ge66y3
         n7LZfMbaXEprGPvwVkn+uDxbZFKcP6nxHtDCRT4bcDho/G39g1IwYzJWLq0sJ6sYwq
         ge3VxcXbjSEkUvCmrIsqEHCP8mN/avITwWjEBAuvfiT7fdsECaWrxuERfi3lwacsOQ
         tlcVQ1RNpmChAT2aoZdyesc5wg/O9IyS5+0/OgQ7XVl53UGHKSvGddlEnT/oxP4Q2/
         bG7KxK9Hw/qvw==
Date:   Tue, 30 Aug 2022 23:31:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gal Pressman <gal@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org, Alexander Aring <alex.aring@gmail.com>
Subject: Re: [PATCH net-next] net: ieee802154: Fix compilation error when
 CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled
Message-ID: <20220830233124.2770ffc2@kernel.org>
In-Reply-To: <4187e35d-0965-cf65-bff5-e4f71a04d272@nvidia.com>
References: <20220830101237.22782-1-gal@nvidia.com>
        <20220830231330.1c618258@kernel.org>
        <4187e35d-0965-cf65-bff5-e4f71a04d272@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 31 Aug 2022 09:20:39 +0300 Gal Pressman wrote:
> So, shouldn't it be:
> #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 .resv_start_op =3D NL802154_CMD_DEL=
_SEC_LEVEL + 1,
> #else
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 .resv_start_op =3D NL802154_CMD_SET=
_WPAN_PHY_NETNS + 1,
> #endif

Hm, let me add 802154 folks.

Either we should treat the commands as reserved in terms of uAPI
even if they get removed the IDs won't be reused, or they are for
testing purposes only.

In the former case we should just remove the #ifdef around the values
in the enum, it just leads to #ifdef proliferation while having no
functional impact.

In the latter case we should start error checking from the last
non-experimental command, as we don't care about breaking the
experimental ones.
