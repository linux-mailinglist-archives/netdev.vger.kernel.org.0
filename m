Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8EE94DCA09
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 16:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235874AbiCQPeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 11:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234996AbiCQPef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 11:34:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4D310E06A;
        Thu, 17 Mar 2022 08:33:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 875BCB81E9E;
        Thu, 17 Mar 2022 15:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0831C340E9;
        Thu, 17 Mar 2022 15:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647531196;
        bh=hiTMb+hb7jq8mjJx4i7OhpNxGdWwl9SpPg2VvjLQpmQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VXj1oJDiJjfkEBwEX0TqV3EZ+ogzh7KOGzCeGOjvcjJA4iRqIKpBNuM2feKJPFmuI
         KWnPG58NZw0u1tOJPAKuG29iLdbxRKXmkIdjBy+Cb8VvVOmJcszmTXDMK4eM/3v5kc
         18DcRBBo7Uhr7Sx5xHih+Em+j98fQqg+ZPyOMtcgJA5e6uuZ+UArtXe23p+5jMU/dS
         1UmbgNWymSrhSak22KQii/vBgB40UcTrcLfWYS+YRrsufAWG2hj/6UVkBIK7+L23no
         3L4PhrNFe8rW53UNSGYm0qViNKzxqeM/gB9EJ5q5pvgeBWU5RTZSc6drwgnXb4/mGx
         fE/0a1iaXPNoA==
Date:   Thu, 17 Mar 2022 08:33:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Manish Chopra <manishc@marvell.com>, netdev@vger.kernel.org,
        Ariel Elior <aelior@marvell.com>, regressions@lists.linux.dev,
        stable@vger.kernel.org, it+netdev@molgen.mpg.de
Subject: Re: [EXT] Re: [PATCH net] bnx2x: fix built-in kernel driver load
 failure
Message-ID: <20220317083314.54f360b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1986e70f-9e3b-cc64-4c15-dbc2abd1dc8d@molgen.mpg.de>
References: <20220316214613.6884-1-manishc@marvell.com>
        <35d305f5-aa84-2c47-7efd-66fffb91c398@molgen.mpg.de>
        <BY3PR18MB46129020BC8C93377CA16FB8AB129@BY3PR18MB4612.namprd18.prod.outlook.com>
        <1986e70f-9e3b-cc64-4c15-dbc2abd1dc8d@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Mar 2022 14:31:45 +0100 Paul Menzel wrote:
> >> I think it=E2=80=99s important to document, that the firmware was not =
present in the
> >> initrd. =20
> >=20
> > I believe this problem has nothing to do with initrd module/FW but
> > rather a module built in the kernel/vmlinuz (CONFIG_BNX2X=3Dy) itself,=
=20
> > A module load from initrd works fine and can access the initrd FW
> > files present in initrd file system even during the probe. For
> > example, when I had CONFIG_BNX2X=3Dm, it loads the module fine from
> > initrd with FW files present in initrd file system. When I had
> > CONFIG_BNX2X=3Dy, which I believe doesn't install/load module in/from
> > initrd but in kernel (vmlinuz) itself, that's where it can't access
> > the firmware file and cause the load failure. =20
>=20
> I can only say, that adding the firmware to the initrd worked around the=
=20
> problem on our side with `CONFIG_BNX2X=3Dy`.

Hi Paul, I'd like to ship this one to Linus today. It sounds like it's
okay from functional perspective, can I improve the commit message as
you were suggesting and leave the comment / print improvements to a
later patch?
