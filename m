Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B31F34D7100
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 22:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbiCLVTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 16:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbiCLVTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 16:19:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEF8554B8;
        Sat, 12 Mar 2022 13:18:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2C52611E4;
        Sat, 12 Mar 2022 21:18:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A854C340EB;
        Sat, 12 Mar 2022 21:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647119888;
        bh=CqybOwz/LLG4adtApkIEKsJSXWtpNr58vIootKUXpck=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OQxKxxQa5Zn2OQrmNjMli8LPcHzzNJwqfx+JMI7OQFHBZjDSVh7YWUt+9t69KOhAW
         UCqKm6adB2mUHSLKG2EOMkp5CteGIq02W2P1T8HcgYBplL01YRwO3U9nPa49rIZ08x
         2x7U/FaKxXJuYPCZVjkM1JmwV1A2g65uP4XS9218m2o4UOwdX6S92iJTWHYqbJuF+P
         vydcbDvMhYtDdOXp3egGHB+1sBtFw2340S/0PMHm1fsXXeUI5CvJENa1/dPubGLAK3
         G7T5ZvHB1Fj2+wVXFvN4nGJwBwIZCX4N69e+Dc+w1noAWQOCCUBXPdHf6mcGumvCRx
         cwLvLvgONNKYA==
Date:   Sat, 12 Mar 2022 13:18:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, pabeni@redhat.com,
        echaudro@redhat.com, toshiaki.makita1@gmail.com, andrii@kernel.org
Subject: Re: [PATCH v4 bpf-next 2/3] veth: rework veth_xdp_rcv_skb in order
 to accept non-linear skb
Message-ID: <20220312131806.1c2919ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87ilsly6db.fsf@toke.dk>
References: <cover.1646755129.git.lorenzo@kernel.org>
        <24703dbc3477a4b3aaf908f6226a566d27969f83.1646755129.git.lorenzo@kernel.org>
        <87ee3auk70.fsf@toke.dk>
        <YinkUiv/yC/gJhYZ@lore-desk>
        <87ilsly6db.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Mar 2022 20:06:40 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> So this always clones the skb if it has frags? Is that really needed? =
=20
> >
> > if we look at skb_cow_data(), paged area is always considered not writa=
ble =20
>=20
> Ah, right, did not know that. Seems a bit odd, but OK.

Yeah, I think I pointed that out, I may well be wrong.

AFAICT frags which are not writable are not marked in any clear
way. We have SKBFL_SHARED_FRAG which seems pretty close but its
documented as an indication that the frag can be written under our
feet, not that we can't write to it. Subtly different. And (as
documented) it's only used when doing SW csums, as far as I can
grep.

Maybe someone else knows the semantics.
