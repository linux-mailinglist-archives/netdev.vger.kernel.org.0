Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0AA668E4B1
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 00:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjBGX6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 18:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBGX6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 18:58:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FD1252B1;
        Tue,  7 Feb 2023 15:58:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 805B2B816D4;
        Tue,  7 Feb 2023 23:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88304C433D2;
        Tue,  7 Feb 2023 23:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675814283;
        bh=sGXVaRq6vYQJqxYDtBacKqsMgua8qseAvNZKfXM4PXY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bqKCVz+Mave8Fx0zq4+M9qYMTm6ZlSWC2rAFunG41hjqgDqk5UJtVuwWBn03cGKRV
         aWvZUKFTvEPyFi2qOTONmDbuqbEXbZsXZQ97yHpL1TZ4I3lFk1h86CqtFFd72RvzRW
         pcOoPLGqq3pBRqMacLJWsYdNiWDBCKnfsagPYaksIY/CbUcZBC4Q0Wuv4EWyxePl39
         A9NlmcyS81s97RzyP3dE1U67sXxVIIgKcvG2twTQspMTepg2aOyQtpBfFH09X9vLxs
         QaxB0Etglbnv/xlu7YsIymkLms6gaxwJJbXl9erWtJzyLt1VU67qCped3nXH1ZcXOC
         +7Cpr2+cTmhPg==
Date:   Tue, 7 Feb 2023 15:58:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     arinc9.unal@gmail.com, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Richard van Schagen <richard@routerhints.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, erkin.bozoglu@xeront.com,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: enable special tag when
 any MAC uses DSA
Message-ID: <20230207155801.3e6295b0@kernel.org>
In-Reply-To: <52f8fc7f-9578-6873-61ae-b4bf85151c0f@arinc9.com>
References: <20230205175331.511332-1-arinc.unal@arinc9.com>
        <20230207105613.4f56b445@kernel.org>
        <5d025125-77e4-cbfb-8caa-b71dd4adfc40@arinc9.com>
        <52f8fc7f-9578-6873-61ae-b4bf85151c0f@arinc9.com>
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

On Tue, 7 Feb 2023 23:25:32 +0300 Ar=C4=B1n=C3=A7 =C3=9CNAL wrote:
> >> As Paolo pointed out to me off-list this is pretty much a revert of
> >> commit under Fixes. Is this an actual regression fix, or second MAC
> >> as DSA port never worked but now you found a way to make it work? =20
> >=20
> > Second MAC as DSA master after hardware DSA untagging was enabled never=
=20
> > worked. I first disabled it to make the communication work again, then,=
=20
> > with this patch, I found a way to make it work which is what should've=
=20
> > been done with the commit for adding hardware DSA untagging support. =20
>=20
> Should both commits be mentioned with Fixes tag?

No strong preference, TBH.

The motivation for my question was to try to figure out how long we
should wait with applying this patch. I applied the commit under Fixes
without waiting for a test from Frank, which made me feel a bit guilty
:)
