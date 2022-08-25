Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C909B5A1CC1
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 00:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243696AbiHYWvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 18:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244254AbiHYWvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 18:51:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E28B4E865;
        Thu, 25 Aug 2022 15:51:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C525B82EA7;
        Thu, 25 Aug 2022 22:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BDBC433C1;
        Thu, 25 Aug 2022 22:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661467901;
        bh=4iKux3Xn8/sGhLVgAenf+fAieLH4Z5NmeBdWsfuZqAw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WU8CcAXdU04NLADV0964g/T6hiMtmbk/ieVMOyovnEXub8w+D9B//I4he5jLhRWTj
         v4W9xRvW4BNgfzN9SvmZAs+4uSJOgpihaBUyWNCW4scea2KhtT/ne4C7My6UqXtf0w
         lNYKodzNaymSu/0tSllDtur8/FNRssQ6k4xO79ucPRWjXYJGYqpcqsXBN8tXcs+wmv
         5iT3blUUIhEvqwk0ofjBC1h0ZiOPjfobVNMS1dqPtXCCOkb4e9MEUK3YaCB4oB38rn
         UWDKpg4Cg5H9Tek40zHGM4Ydj2yYZNnal1RL4Efo0h2GX0KOCPCI0o3OhQfru+IzDe
         AcsW6TFw6QifQ==
Date:   Thu, 25 Aug 2022 15:51:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     Marcus Carlberg <marcus.carlberg@axis.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <kernel@axis.com>,
        Pavana Sharma <pavana.sharma@digi.com>,
        Ashkan Boldaji <ashkan.boldaji@digi.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] net: dsa: mv88e6xxx: support RGMII cmode
Message-ID: <20220825155140.038e4d12@kernel.org>
In-Reply-To: <20220826000605.5cff0db8@thinkpad>
References: <20220822144136.16627-1-marcus.carlberg@axis.com>
        <20220825123807.3a7e37b7@kernel.org>
        <20220826000605.5cff0db8@thinkpad>
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

On Fri, 26 Aug 2022 00:06:05 +0200 Marek Beh=C3=BAn wrote:
> > On Mon, 22 Aug 2022 16:41:36 +0200 Marcus Carlberg wrote: =20
> > > Since the probe defaults all interfaces to the highest speed possible
> > > (10GBASE-X in mv88e6393x) before the phy mode configuration from the
> > > devicetree is considered it is currently impossible to use port 0 in
> > > RGMII mode.
> > >=20
> > > This change will allow RGMII modes to be configurable for port 0
> > > enabling port 0 to be configured as RGMII as well as serial depending
> > > on configuration.
> > >=20
> > > Fixes: de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x=
 family")
> > > Signed-off-by: Marcus Carlberg <marcus.carlberg@axis.com>   =20
> >=20
> > Seems like a new configuration which was not previously supported
> > rather than a regression, right? If so I'll drop the Fixes tag
> > when applying. =20
>=20
> Please leave the fixes tag. This configuration should have been
> supported from the beginning.

Could you explain why? Is there an upstream-supported platform
already in Linus's tree which doesn't boot or something?
