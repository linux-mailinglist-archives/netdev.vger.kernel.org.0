Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C49074CD8F7
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 17:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236135AbiCDQT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 11:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232609AbiCDQT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 11:19:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560D5127D58
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 08:18:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CD5DB82A55
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 16:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EF6C340E9;
        Fri,  4 Mar 2022 16:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646410715;
        bh=7fOeHPuV2Pt0b1MCZSe5CcU4/KQ6wakcbeUIo9e8NqE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sWM0JYzhk6c+FpU64sM+phP+1hXYBLVJ32Y3V5PfCsfjuNZlLHGPKXOj26/6HwKSC
         XFjJyS/k7jhy0KGfvm/48gXD7APPx0n73zlOcApFD5Od+ghcR1NFgpJrso7aD3gwGN
         PKjZS3+NGNkV09iYab6cs15xFrLNQcyVthDASm8MmBWsggCwpCYcPAdc5bkFpfCFy4
         O63dxb5f2z90r35+de//YtJ10mmLeXrY2sJkHkM/epeyKQJX14diUHrpQkLjBtuGBJ
         lA0AIWEgBpg7zoyavNlheKXWcKP+lzjFcoNkxpzuoJqiEzCJ8RLT9ONzmNEnvJfsWD
         fK509yXrJEWfQ==
Date:   Fri, 4 Mar 2022 08:18:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Jonathan Lemon" <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, kernel-team@fb.com
Subject: Re: [PATCH net-next 1/2] ptp: ocp: add nvmem interface for
 accessing eeprom
Message-ID: <20220304081834.552ae666@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3D45B7EC-D480-4A0F-8ED2-2CC5677B8B13@gmail.com>
References: <20220303233801.242870-1-jonathan.lemon@gmail.com>
        <20220303233801.242870-4-jonathan.lemon@gmail.com>
        <20220303210112.701ed143@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <3D45B7EC-D480-4A0F-8ED2-2CC5677B8B13@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 03 Mar 2022 21:39:48 -0800 Jonathan Lemon wrote:
> On 3 Mar 2022, at 21:01, Jakub Kicinski wrote:
> > On Thu,  3 Mar 2022 15:38:00 -0800 Jonathan Lemon wrote: =20
> >> manufacturer =20
> >
> > The generic string is for manufacture, i.e. fab; that's different
> > from manufacture*r* i.e. vendor. It's when you multi-source a single
> > board design at multiple factories. =20
>=20
> The documentation seems unclear:
>=20
> board.manufacture
> -----------------
> An identifier of the company or the facility which produced the part.

Yeah, so this is for standard NICs. Say you have a NIC made by
Chelsio (just picking a random company that's unlikely to have its=20
own fabs), the vendor is Chelsio but they will contract out building
the boards to whatever contractors. The contractor just puts the board
together and runs manufacturing tests, tho, no real IP work.

> There isn=E2=80=99t a board.vendor (or manufacturer) in devlink.h.
>=20
> The board design is open source, there=E2=80=99s several variants of
> the design being produced, so I=E2=80=99m looking for a simple way to
> identify the design (other than the opaque board id)

And all of them use Facebook PCI_ID, hm. But AFAIU the cards are not
identical, right? Are they using the same exact board design or
something derived from the reference board design that matches=20
the OCP spec?

And AFAIU the company delivering the card writes / assembles the
firmware, you can't take FW load from company A and flash it onto
company B's card, no?
