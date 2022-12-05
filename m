Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27B0642EFA
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 18:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiLERir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 12:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiLERiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 12:38:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9BA9FE0
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 09:38:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C357B8119F
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 17:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403ECC433D6;
        Mon,  5 Dec 2022 17:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670261919;
        bh=DiELGqOeqRCXeJFQiJ4pqJlVnhWHvx8K7+9u4AOMvpM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uyo90APpQG4zqe7TkGs/DAg6D7Er/0KzY5ZNTiU3l+gA3rephyej9bFuZwHtvgJjC
         VeJ5QjM0rQeV5ML63jqktSphNaVUHHzclb5OL7mCHeZW1xxEHmhy8PLW5Le4wL/arS
         qEMd2FsxSAk89OLrxfln497CF8XcjOYaTD3EI7EVvGOj/40pkQguFK/sskKNPmX62X
         XxadYBLv+8DQHsl0ITZ3j0CQW87ptppFC6kUEFJMmwYjpQAUHKt9bkBxGrn4zYibMt
         BICShv0o8TEhd+9rJWIspTrb7+N0Fmh4w/yP2UNm9fxRGadhQNbyU6Tbx6Z58sLsv7
         jYnmu2Q5wzNcQ==
Date:   Mon, 5 Dec 2022 19:38:34 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, sujuan.chen@mediatek.com
Subject: Re: [PATCH v2 net-next] net: ethernet: mtk_wed: fix possible
 deadlock if mtk_wed_wo_init fails
Message-ID: <Y44smiGYEI/WlG1D@unreal>
References: <5a29aae6c4a26e807844210d4ddac7950ca5f63d.1670238731.git.lorenzo@kernel.org>
 <Y44jO1ZT9RgqYtxF@unreal>
 <Y44k7X5YYbuSntd2@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <Y44k7X5YYbuSntd2@lore-desk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 06:05:49PM +0100, Lorenzo Bianconi wrote:
> > On Mon, Dec 05, 2022 at 12:14:41PM +0100, Lorenzo Bianconi wrote:
> > > Introduce __mtk_wed_detach() in order to avoid a possible deadlock in
> > > mtk_wed_attach routine if mtk_wed_wo_init fails.
> > > Check wo pointer is properly allocated before running mtk_wed_wo_rese=
t()
> > > and mtk_wed_wo_deinit() in __mtk_wed_detach routine.
> > > Honor mtk_wed_mcu_send_msg return value in mtk_wed_wo_reset().
> > >=20
> > > Fixes: 4c5de09eb0d0 ("net: ethernet: mtk_wed: add configure wed wo su=
pport")
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > > Changes since v1:
> > > - move wo pointer checks in __mtk_wed_detach()
> > > ---
> > >  drivers/net/ethernet/mediatek/mtk_wed.c     | 30 ++++++++++++++-----=
--
> > >  drivers/net/ethernet/mediatek/mtk_wed_mcu.c |  3 +++
> > >  2 files changed, 23 insertions(+), 10 deletions(-)
> > >=20
> > > diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/et=
hernet/mediatek/mtk_wed.c
> > > index d041615b2bac..2ce9fbb1c66d 100644
> > > --- a/drivers/net/ethernet/mediatek/mtk_wed.c
> > > +++ b/drivers/net/ethernet/mediatek/mtk_wed.c
> > > @@ -174,9 +174,10 @@ mtk_wed_wo_reset(struct mtk_wed_device *dev)
> > >  	mtk_wdma_tx_reset(dev);
> > >  	mtk_wed_reset(dev, MTK_WED_RESET_WED);
> > > =20
> > > -	mtk_wed_mcu_send_msg(wo, MTK_WED_MODULE_ID_WO,
> > > -			     MTK_WED_WO_CMD_CHANGE_STATE, &state,
> > > -			     sizeof(state), false);
> > > +	if (mtk_wed_mcu_send_msg(wo, MTK_WED_MODULE_ID_WO,
> > > +				 MTK_WED_WO_CMD_CHANGE_STATE, &state,
> > > +				 sizeof(state), false))
> > > +		return;
> > > =20
> > >  	if (readx_poll_timeout(mtk_wed_wo_read_status, dev, val,
> > >  			       val =3D=3D MTK_WED_WOIF_DISABLE_DONE,
> > > @@ -576,12 +577,10 @@ mtk_wed_deinit(struct mtk_wed_device *dev)
> > >  }
> > > =20
> > >  static void
> > > -mtk_wed_detach(struct mtk_wed_device *dev)
> > > +__mtk_wed_detach(struct mtk_wed_device *dev)
> > >  {
> > >  	struct mtk_wed_hw *hw =3D dev->hw;
> > > =20
> > > -	mutex_lock(&hw_lock);
> > > -
> > >  	mtk_wed_deinit(dev);
> > > =20
> > >  	mtk_wdma_rx_reset(dev);
> > > @@ -590,9 +589,11 @@ mtk_wed_detach(struct mtk_wed_device *dev)
> > >  	mtk_wed_free_tx_rings(dev);
> > > =20
> > >  	if (mtk_wed_get_rx_capa(dev)) {
> > > -		mtk_wed_wo_reset(dev);
> > > +		if (hw->wed_wo)
> > > +			mtk_wed_wo_reset(dev);
> > >  		mtk_wed_free_rx_rings(dev);
> > > -		mtk_wed_wo_deinit(hw);
> > > +		if (hw->wed_wo)
> > > +			mtk_wed_wo_deinit(hw);
> > >  	}
> > > =20
> > >  	if (dev->wlan.bus_type =3D=3D MTK_WED_BUS_PCIE) {
> > > @@ -612,6 +613,13 @@ mtk_wed_detach(struct mtk_wed_device *dev)
> > >  	module_put(THIS_MODULE);
> > > =20
> > >  	hw->wed_dev =3D NULL;
> > > +}
> > > +
> > > +static void
> > > +mtk_wed_detach(struct mtk_wed_device *dev)
> > > +{
> > > +	mutex_lock(&hw_lock);
> > > +	__mtk_wed_detach(dev);
> > >  	mutex_unlock(&hw_lock);
> > >  }
> > > =20
> > > @@ -1490,8 +1498,10 @@ mtk_wed_attach(struct mtk_wed_device *dev)
> > >  		ret =3D mtk_wed_wo_init(hw);
> > >  	}
> > >  out:
> > > -	if (ret)
> > > -		mtk_wed_detach(dev);
> > > +	if (ret) {
> > > +		dev_err(dev->hw->dev, "failed to attach wed device\n");
> > > +		__mtk_wed_detach(dev);
> > > +	}
> > >  unlock:
> > >  	mutex_unlock(&hw_lock);
> > > =20
> > > diff --git a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c b/drivers/ne=
t/ethernet/mediatek/mtk_wed_mcu.c
> > > index f9539e6233c9..3dd02889d972 100644
> > > --- a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
> > > +++ b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
> > > @@ -207,6 +207,9 @@ int mtk_wed_mcu_msg_update(struct mtk_wed_device =
*dev, int id, void *data,
> > >  	if (dev->hw->version =3D=3D 1)
> > >  		return 0;
> > > =20
> > > +	if (!wo)
> > > +		return -ENODEV;
> > > +
> >=20
> > Can you please help me to understand how and when this mtk_wed_mcu_msg_=
update()
> > function is called?
> >=20
> > I see this line .msg_update =3D mtk_wed_mcu_msg_update, and
> > relevant mtk_wed_device_update_msg() define, but nothing calls to this
> > define.
>=20
> mtk_wed_device_update_msg() is currently run by mt7915 driver in
> mt7915_mcu_wed_enable_rx_stats() and in mt76_connac_mcu_sta_wed_update().

I see, I didn't fetch latest net-next.

> At the moment we always run mtk_wed_mcu_msg_update with non-NULL wo point=
er,
> but I would prefer to add this safety check.

If it is impossible, please add WARN_ON(!wo) instead of "if ...". It
describes better what is expected here.

Thanks

>=20
> Regards,
> Lorenzo
>=20
> >=20
> >=20
> >=20
> > >  	return mtk_wed_mcu_send_msg(wo, MTK_WED_MODULE_ID_WO, id, data, len,
> > >  				    true);
> > >  }
> > > --=20
> > > 2.38.1
> > >=20
> >=20


