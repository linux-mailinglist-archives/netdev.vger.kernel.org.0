Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF160642393
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 08:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbiLEH3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 02:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiLEH3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 02:29:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E2010056
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 23:29:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B2EE60F91
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 07:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AABFC433C1;
        Mon,  5 Dec 2022 07:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670225374;
        bh=fx8DijmljxFft2vuBcvu+su0yNi3F7HjMQ2QA0Z/qsA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ArPxW/i43FgeOiVQwWsnHQz8lP9FM7g1jZ82IQgQoJNy+5y/JXTULJu2m/eQmA8kw
         MkvrBPqvGOfHjxkvGzQEUhLA3oZnB/1X3Hf9B9deqirDJTkD50z+/ChnRqAn5fGJJT
         wraL883KEEQdChnvBqmOZBznbVuQwzytrs8/oKMSvohcewZs8VtpvywCrVTz3wc6CH
         mxAZZyGMuh5PSzXSprPY+hkbY1H7klD0Z5LmJCl4PsMl6K+vpRrTB//NZwJlkWli6q
         2dS33bfzZwQmYVH+hSS1EP94T7L20cLg3kkZe2CEPPMuz7W7pvkHFKEy612JupzKgO
         gTCbvuGm6esEA==
Date:   Mon, 5 Dec 2022 09:29:30 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH net-next] net: ethernet: mtk_wed: fix possible deadlock
 if mtk_wed_wo_init fails
Message-ID: <Y42d2us5Pv1UqhEj@unreal>
References: <a87f05e60ea1a94b571c9c87b69cc5b0e94943f2.1669999089.git.lorenzo@kernel.org>
 <Y4ybbkn+nXkGsqWe@unreal>
 <Y4y4If8XXu+wErIj@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <Y4y4If8XXu+wErIj@lore-desk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 04, 2022 at 04:09:21PM +0100, Lorenzo Bianconi wrote:
> > On Fri, Dec 02, 2022 at 06:36:33PM +0100, Lorenzo Bianconi wrote:
> > > Introduce __mtk_wed_detach() in order to avoid a possible deadlock in
> > > mtk_wed_attach routine if mtk_wed_wo_init fails.
> > >=20
> > > Fixes: 4c5de09eb0d0 ("net: ethernet: mtk_wed: add configure wed wo su=
pport")
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > >  drivers/net/ethernet/mediatek/mtk_wed.c     | 24 ++++++++++++++-----=
--
> > >  drivers/net/ethernet/mediatek/mtk_wed_mcu.c | 10 ++++++---
> > >  drivers/net/ethernet/mediatek/mtk_wed_wo.c  |  3 +++
> > >  3 files changed, 26 insertions(+), 11 deletions(-)
> >=20
> > <...>
> >=20
> > > diff --git a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c b/drivers/ne=
t/ethernet/mediatek/mtk_wed_mcu.c
> > > index f9539e6233c9..b084009a32f9 100644
> > > --- a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
> > > +++ b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
> > > @@ -176,6 +176,9 @@ int mtk_wed_mcu_send_msg(struct mtk_wed_wo *wo, i=
nt id, int cmd,
> > >  	u16 seq;
> > >  	int ret;
> > > =20
> > > +	if (!wo)
> > > +		return -ENODEV;
> >=20
> > <...>
> >=20
> > >  static void
> > >  mtk_wed_wo_hw_deinit(struct mtk_wed_wo *wo)
> > >  {
> > > +	if (!wo)
> > > +		return;
> >=20
> > How are these changes related to the written in deadlock?
> > How is it possible to get internal mtk functions without valid wo?
>=20
> Hi Leon,
>=20
> if mtk_wed_rro_alloc() fails in mtk_wed_attach(), we will end up running
> __mtk_wed_detach() when wo struct is not allocated yet (wo is allocated in
> mtk_wed_wo_init()).

IMHO, it is a culprit, proper error unwind means that you won't call to
uninit functions for something that is not initialized yet. It is better
to fix it instead of adding "if (!wo) ..." checks.

> Moreover __mtk_wed_detach() can run mtk_wed_wo_reset() and mtk_wed_wo_dei=
nit()

This is another side of same coin. If you can run them in parallel, you
need locking protection and ability to cancel work, so nothing is going
to be executed once cleanup succeeded.

These were my 2 cents, totally IMHO.

Thanks
