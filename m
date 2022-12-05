Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559456425D4
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 10:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiLEJcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 04:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbiLEJcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 04:32:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2370915800
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 01:32:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF7F2B80CAC
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 09:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157C6C433C1;
        Mon,  5 Dec 2022 09:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670232727;
        bh=WOC4NGSKcpE3psehYws6xoUdfp+/+TNrXzZHo7XVmas=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iG0XrvLqHIBCkpesgAG8ZeHH6uezRpKKkjKF9WI4v0UClNi5HBuISupRm/Ef+8Tik
         Njn2VtTYhiFN7uEc++EJQL0fbANBwl+ktGrYI/8VZlpLHQ9h6rlhcynpYyZJ1xcUq6
         vV1qXs1hVmUTr0c7cNWbUEIDICFhLRxGPNokTjoo0O7N8DHWin8qE3bkE79QXknXKl
         Qv3CaKYDH7cjy5pxsLn41lNSLydVBV4TVAqqsbNNRIai2GCGyk1PC74G5NLWkQOylt
         AN+wGUfM6NMRajwivjHyLOVksmaFKfFCssOs9oZnpcw9TxNx3bV1Y/woXoHSqePkZt
         aqktQI2JhZUUQ==
Date:   Mon, 5 Dec 2022 11:32:03 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH net-next] net: ethernet: mtk_wed: fix possible deadlock
 if mtk_wed_wo_init fails
Message-ID: <Y426k9VzOzYlXuOo@unreal>
References: <a87f05e60ea1a94b571c9c87b69cc5b0e94943f2.1669999089.git.lorenzo@kernel.org>
 <Y4ybbkn+nXkGsqWe@unreal>
 <Y4y4If8XXu+wErIj@lore-desk>
 <Y42d2us5Pv1UqhEj@unreal>
 <Y420B4/IpwFHJAck@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <Y420B4/IpwFHJAck@lore-desk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 10:04:07AM +0100, Lorenzo Bianconi wrote:
> On Dec 05, Leon Romanovsky wrote:
> > On Sun, Dec 04, 2022 at 04:09:21PM +0100, Lorenzo Bianconi wrote:
> > > > On Fri, Dec 02, 2022 at 06:36:33PM +0100, Lorenzo Bianconi wrote:
> > > > > Introduce __mtk_wed_detach() in order to avoid a possible deadloc=
k in
> > > > > mtk_wed_attach routine if mtk_wed_wo_init fails.
> > > > >=20
> > > > > Fixes: 4c5de09eb0d0 ("net: ethernet: mtk_wed: add configure wed w=
o support")
> > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > > ---
> > > > >  drivers/net/ethernet/mediatek/mtk_wed.c     | 24 ++++++++++++++-=
------
> > > > >  drivers/net/ethernet/mediatek/mtk_wed_mcu.c | 10 ++++++---
> > > > >  drivers/net/ethernet/mediatek/mtk_wed_wo.c  |  3 +++
> > > > >  3 files changed, 26 insertions(+), 11 deletions(-)
> > > >=20
> > > > <...>
> > > >=20
> > > > > diff --git a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c b/driver=
s/net/ethernet/mediatek/mtk_wed_mcu.c
> > > > > index f9539e6233c9..b084009a32f9 100644
> > > > > --- a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
> > > > > +++ b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
> > > > > @@ -176,6 +176,9 @@ int mtk_wed_mcu_send_msg(struct mtk_wed_wo *w=
o, int id, int cmd,
> > > > >  	u16 seq;
> > > > >  	int ret;
> > > > > =20
> > > > > +	if (!wo)
> > > > > +		return -ENODEV;
> > > >=20
> > > > <...>
> > > >=20
> > > > >  static void
> > > > >  mtk_wed_wo_hw_deinit(struct mtk_wed_wo *wo)
> > > > >  {
> > > > > +	if (!wo)
> > > > > +		return;
> > > >=20
> > > > How are these changes related to the written in deadlock?
> > > > How is it possible to get internal mtk functions without valid wo?
> > >=20
> > > Hi Leon,
> > >=20
> > > if mtk_wed_rro_alloc() fails in mtk_wed_attach(), we will end up runn=
ing
> > > __mtk_wed_detach() when wo struct is not allocated yet (wo is allocat=
ed in
> > > mtk_wed_wo_init()).
> >=20
> > IMHO, it is a culprit, proper error unwind means that you won't call to
> > uninit functions for something that is not initialized yet. It is better
> > to fix it instead of adding "if (!wo) ..." checks.
>=20
> So, iiuc, you would prefer to do something like:
>=20
> __mtk_wed_detach()
> {
> 	...
> 	if (mtk_wed_get_rx_capa(dev) && wo) {
> 		mtk_wed_wo_reset(dev);
> 		mtk_wed_free_rx_rings(dev);
> 		mtk_wed_wo_deinit(hw);
> 	}
> 	...
> =09
> Right? I am fine both ways :)

Yes

>=20
> >=20
> > > Moreover __mtk_wed_detach() can run mtk_wed_wo_reset() and mtk_wed_wo=
_deinit()
> >=20
> > This is another side of same coin. If you can run them in parallel, you
> > need locking protection and ability to cancel work, so nothing is going
> > to be executed once cleanup succeeded.
>=20
> Sorry, I did not get what you mean here with 'in parallel'. __mtk_wed_det=
ach()
> always run with hw_lock mutex help in both mtk_wed_attach() or
> mtk_wed_detach().

Lock is not enough, you need to make sure that no underlying code is
called without wo. You suggestion above is fine. The less low level code
will have "if (!wo) ...", the better will be.

Thanks

>=20
> Regards,
> Lorenzo
>=20
> >=20
> > These were my 2 cents, totally IMHO.
> >=20
> > Thanks


