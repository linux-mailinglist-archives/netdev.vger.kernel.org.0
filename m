Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA0668E0A5
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 19:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbjBGS4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 13:56:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBGS4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 13:56:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0C419A;
        Tue,  7 Feb 2023 10:56:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7B046113A;
        Tue,  7 Feb 2023 18:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FC9C433EF;
        Tue,  7 Feb 2023 18:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675796175;
        bh=7ZCUewxyzsIBjoHKDSWlL/p0bac+EsMZWQozA9IaisA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fMe/+c0Hyi99+yLXoOFBxo1q45FYvb1erXcZsuZ5+T+N/Cq6iLJ+psoGOfpnKsTyZ
         dHDHGiOyn+a7+7m+76zc34yV1YXpDX/MKYJ3aeihxdNFMhFlB5C9xOk4WZeMvhVglR
         LhnF4vQ76OxuHo6ki6JZOQFw0PIcdZp+84CZNh7Gs9bKwL4M+Z8ok9lh8noEHNaM9d
         hOL6HYCGm2TTitWaxUgGP5qhGSdBO7Ik9L3XN23jXUFlQ7EZHLtEh56Jtc3bHpgQKC
         TpyElNotkZstA/GwmhmAT5+sVjdqupIqORa0L+1O9y4LKGtkXhfFaClkiTv+P6HocJ
         hb/CR3NRpRhLQ==
Date:   Tue, 7 Feb 2023 10:56:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     arinc9.unal@gmail.com
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        =?UTF-8?B?QXLEsW7DpyDDnE5B?= =?UTF-8?B?TA==?= 
        <arinc.unal@arinc9.com>,
        Richard van Schagen <richard@routerhints.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, erkin.bozoglu@xeront.com
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: enable special tag when
 any MAC uses DSA
Message-ID: <20230207105613.4f56b445@kernel.org>
In-Reply-To: <20230205175331.511332-1-arinc.unal@arinc9.com>
References: <20230205175331.511332-1-arinc.unal@arinc9.com>
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

On Sun,  5 Feb 2023 20:53:31 +0300 arinc9.unal@gmail.com wrote:
> From: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
>=20
> The special tag is only enabled when the first MAC uses DSA. However, it
> must be enabled when any MAC uses DSA. Change the check accordingly.
>=20
> This fixes hardware DSA untagging not working on the second MAC of the
> MT7621 and MT7623 SoCs, and likely other SoCs too. Therefore, remove the
> check that disables hardware DSA untagging for the second MAC of the MT76=
21
> and MT7623 SoCs.
>=20
> Fixes: a1f47752fd62 ("net: ethernet: mtk_eth_soc: disable hardware DSA un=
tagging for second MAC")

As Paolo pointed out to me off-list this is pretty much a revert of
commit under Fixes. Is this an actual regression fix, or second MAC
as DSA port never worked but now you found a way to make it work?
