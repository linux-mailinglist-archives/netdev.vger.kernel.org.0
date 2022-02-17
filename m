Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 683044BA8DD
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 19:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234983AbiBQSz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 13:55:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244807AbiBQSzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 13:55:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8655035DD7;
        Thu, 17 Feb 2022 10:54:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DB9561BA2;
        Thu, 17 Feb 2022 18:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C209C340E8;
        Thu, 17 Feb 2022 18:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645124044;
        bh=MbQrC0DuaWykssEif2K4UqZMoBje0xkc2CHA1AW/mCQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NjSS2Q5EN57kgvz4emp31Dem8VSFUDRlJbHR0ti3/oFEUsBIeMZvaqtXfrmtKxtvL
         /iDhzP9teLQ/OyQsD0/BRt6wdmeZT6As3aJKyWMuHqHXlqDrZXE8MS+5CCiLhCKsPP
         QPA2K4/9E5TNxWY3B/SONimiUDq1p2kZ62jUB5+kXmsmpI7S+HDI1TLTpnMaydEHgB
         T4VHNAOD8W6wWRAR8YZSpO4IP5q+HFUvcGGlWKYbtuquILJ5zUTxburt6tb5YFwdq8
         gmt7e647ISqChh7af6TPp0QuC4g2c6SBegOQWxeMVA1KomMkfP0f6Na1ukFJMnOzt3
         zA0AJhgSr3vXQ==
Date:   Thu, 17 Feb 2022 10:54:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>
Subject: Re: [PATCH net-next v1] net: Use csum_replace_... and csum_sub()
 helpers instead of opencoding
Message-ID: <20220217105402.302a2d20@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a7fe3817-a9ed-fb48-c3ab-1d17e8961e7f@csgroup.eu>
References: <fe60030b6f674d9bf41f56426a4b0a8a9db0d20f.1645112415.git.christophe.leroy@csgroup.eu>
        <20220217092442.4948b48c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <13805dc8-4f96-9621-3b8b-4ec5ea6aeffe@csgroup.eu>
        <20220217101442.0a2805b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a7fe3817-a9ed-fb48-c3ab-1d17e8961e7f@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Feb 2022 18:39:07 +0000 Christophe Leroy wrote:
> Le 17/02/2022 =C3=A0 19:14, Jakub Kicinski a =C3=A9crit=C2=A0:
> > On Thu, 17 Feb 2022 18:11:58 +0000 Christophe Leroy wrote: =20
> >> Looks like csum_replace4() expects __be32 inputs, I'll look at it but
> >> I'm not inclined at adding force cast, so will probably leave
> >> nft_csum_replace() as is. =20
> >=20
> > That may imply also leaving it in your tree.. =20
>=20
> By "leave as is" I meant I'll drop the change.
>=20
> I'll send v2 without this hunk.

Thanks, sorry for the snarky comment, I read it as "take it or leave
it". I've heard too many of those lately.
