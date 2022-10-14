Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E952D5FEFBB
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 16:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbiJNOFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 10:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbiJNOFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 10:05:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354E727165
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 07:05:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69325B82215
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 14:04:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A837FC433D6;
        Fri, 14 Oct 2022 14:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665756240;
        bh=RHEB0B+leHqLP5pGjWKJR8d5IzUBOvry2t3kFfTWN2c=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=COmxmsFxkGjFB/X6CUbzdO7JyH69P0BFeHwoQE8vp0f0h5D1HPhcNnvj6NVVJHxMO
         N+2EDf5LF5vMZBsCc0v1G1yxi/hwDdBpAV5YyBFCvmwNXkK7/GFcrOSDehxPObyXrv
         jV/POHUg5Y3EFQbwA3rBTyDZa/IwyQA83xL626o0N4B3U0UQZ/THo64raX2LmVKFq7
         wgYIn3OVDKNWCMO/NgAsiJThcuqTrt36wm78nPWY4F34+l2vT5mWmU2CFYF4NQiVEq
         KNiswlo0gVKbwYHNTIS/FoLgi3PT7h9Z1epy+ajpax3zTiZmmFETrbshewdt+ABwp0
         CsO0ZP0Hg5RKQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <Y0lCHaGTQjsNvzVN@unreal>
References: <cover.1665416630.git.sd@queasysnail.net> <Y0j+E+n/RggT05km@unreal> <Y0kTMXzY3l4ncegR@hog> <Y0lCHaGTQjsNvzVN@unreal>
Subject: Re: [PATCH net 0/5] macsec: offload-related fixes
From:   Antoine Tenart <atenart@kernel.org>
Cc:     netdev@vger.kernel.org,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
Date:   Fri, 14 Oct 2022 16:03:56 +0200
Message-ID: <166575623691.3451.2587099917911763555@kwain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Leon Romanovsky (2022-10-14 13:03:57)
> On Fri, Oct 14, 2022 at 09:43:45AM +0200, Sabrina Dubroca wrote:
> > 2022-10-14, 09:13:39 +0300, Leon Romanovsky wrote:
> > > On Thu, Oct 13, 2022 at 04:15:38PM +0200, Sabrina Dubroca wrote:
> > > > I'm working on a dummy offload for macsec on netdevsim. It just has=
 a
> > > > small SecY and RXSC table so I can trigger failures easily on the
> > > > ndo_* side. It has exposed a couple of issues.
> > > >=20
> > > > The first patch will cause some performance degradation, but in the
> > > > current state it's not possible to offload macsec to lower devices
> > > > that also support ipsec offload.=20
> > >=20
> > > Please don't, IPsec offload is available and undergoing review.
> > > https://lore.kernel.org/netdev/cover.1662295929.git.leonro@nvidia.com/
> > >=20
> > > This is whole series (XFRM + driver) for IPsec full offload.
> > > https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/l=
og/?h=3Dxfrm-next
>=20
> > That patchset is also doing nothing to address the issue I'm refering
> > to here, where xfrm_api_check rejects the macsec device because it has
> > the NETIF_F_HW_ESP flag (passed from the lower device) and no xfrmdev_o=
ps.
>=20
> Of course, why do you think that IPsec series should address MACsec bugs?

I was looking at this and the series LGTM. I don't get the above
concern, can you clarify?

If a lower device has both IPsec & MACsec offload capabilities:

- Without the revert: IPsec can be offloaded to the lower dev, MACsec
  can't. That's a bug.

- With the revert: IPsec and MACsec can be offloaded to the lower dev.
  Some features might not propagate to the MACsec dev, which won't allow
  some performance optimizations in the MACsec data path.

Thanks,
Antoine
