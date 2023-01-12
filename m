Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63FF667D47
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 19:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbjALSCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 13:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239911AbjALSBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 13:01:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FD01C91E;
        Thu, 12 Jan 2023 09:24:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8BCAACE1EE8;
        Thu, 12 Jan 2023 17:24:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B6FC433D2;
        Thu, 12 Jan 2023 17:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673544238;
        bh=BBL4eRT9LuIjRu+BhsqKzGDfJ7+01aLPrn3j15DcV1A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZiOxpOsqB1lk285bMsQQimEAbNEUp95G/ISy+y3PNKtlIKb+mNXN8eJAHfItvdJhG
         SJKE2Caf7atfXMbBZtCUbW/vy9EBXdUcN3ieIaAAwgCTSbhR1dL4kojIl4VYYcMLMZ
         JsUAFt393SL3KweE08CsVWaterHeDlfSpqQH/Vg0TBfC3HkR4fYxxkJR1zwZaXMk/p
         m2vD4vsXQq9bsvfsAbd8ALXGZjIqGp+4XCvWiZ9A18jq8351sGPPyDCKJwCfxjv40i
         dgPHs1oNINeUriWlhyjvJjfGa+Q3GRwR29doUggFLdrUwBC1Err3Qkfm22Y2CLTIO3
         jTpXZZIOR/4yQ==
Date:   Thu, 12 Jan 2023 18:23:54 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Cc:     nbd@nbd.name, ryder.lee@mediatek.com, shayne.chen@mediatek.com,
        sean.wang@mediatek.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        matthias.bgg@gmail.com, sujuan.chen@mediatek.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@collabora.com, nfraprado@collabora.com, wenst@chromium.org
Subject: Re: [PATCH] wifi: mt76: Stop unmapping all buffers when WED not
 present
Message-ID: <Y8BCKrlCtwedrk3U@lore-desk>
References: <20230112171706.294550-1-angelogioacchino.delregno@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="luqFSIfwu5Nm9Vpn"
Content-Disposition: inline
In-Reply-To: <20230112171706.294550-1-angelogioacchino.delregno@collabora.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--luqFSIfwu5Nm9Vpn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Before the introduction of WED RX support, this driver was resetting
> buf0 and the TXWI pointer only on the head of the passed queue but
> now it's doing that on all buffers: while this is fine on systems
> that are not relying on IOMMU, such as the MT8192 Asurada Spherion
> Chromebook (MT7921E), it causes a crash on others using IOMMUs, such
> as the MT8195 Cherry Tomato Chromebook (MT7921E again!).
>=20
> Reverting to the described behavior solves the following kernel panic:
>=20
> [   20.357772] Unable to handle kernel paging request at virtual address =
ffff170fc0000000
> [   20.365943] Mem abort info:
> [   20.368989]   ESR =3D 0x0000000096000145
> [   20.372988]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
> [   20.378551]   SET =3D 0, FnV =3D 0
> [   20.381857]   EA =3D 0, S1PTW =3D 0
> [   20.385248]   FSC =3D 0x05: level 1 translation fault
> [   20.390376] Data abort info:
> [   20.393507]   ISV =3D 0, ISS =3D 0x00000145
> [   20.397593]   CM =3D 1, WnR =3D 1
> [   20.400811] swapper pgtable: 4k pages, 48-bit VAs, pgdp=3D0000000041fb=
3000
> [   20.407763] [ffff170fc0000000] pgd=3D180000023fff7003, p4d=3D180000023=
fff7003, pud=3D0000000000000000
> [   20.416714] Internal error: Oops: 0000000096000145 [#1] SMP
> [   20.422535] Modules linked in: af_alg qrtr mt7921e mt7921_common mt76_=
connac_lib mt76 mac80211 btusb btrtl btintel btmtk btbcm 8021q cfg80211 blu=
etooth uvcvideo garp mrp snd_sof_ipc_msg_injector snd_sof_ipc_flood_test st=
p snd_sof_mt8195 videobuf2_vmalloc llc panfrost cros_ec_sensors cros_ec_lid=
_angle crct10dif_ce mtk_adsp_common ecdh_generic cros_ec_sensors_core ecc s=
nd_sof_xtensa_dsp gpu_sched rfkill snd_sof_of sbs_battery hid_multitouch cr=
os_usbpd_logger snd_sof snd_sof_utils fuse ipv6
> [   20.465969] CPU: 6 PID: 9 Comm: kworker/u16:0 Tainted: G        W     =
     6.2.0-rc3-next-20230111+ #237
> [   20.475695] Hardware name: Acer Tomato (rev2) board (DT)
> [   20.481254] Workqueue: phy0 ieee80211_iface_work [mac80211]
> [   20.487119] pstate: 80400009 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYP=
E=3D--)
> [   20.494328] pc : dcache_clean_poc+0x20/0x38
> [   20.498764] lr : arch_sync_dma_for_device+0x2c/0x40
> [   20.503893] sp : ffff8000080cb430
> [   20.507457] x29: ffff8000080cb430 x28: 0000000000000000 x27: ffff1710c=
740e0d0
> [   20.514842] x26: ffff1710d8c03b38 x25: ffff1710d75e4fb0 x24: ffff1710c=
619e280
> [   20.522225] x23: ffff8000080cb578 x22: 0000000000000001 x21: 000000000=
0000040
> [   20.529608] x20: 0000000000000000 x19: ffff1710c740e0d0 x18: 000000000=
0000030
> [   20.536991] x17: 000000040044ffff x16: ffffc06d4c37d200 x15: fffffffff=
fffffff
> [   20.544373] x14: 0000000000000000 x13: 0000000000007800 x12: 000000000=
0000000
> [   20.551755] x11: 0000000000007961 x10: 0000000000007961 x9 : ffffc06d4=
cbe0ff8
> [   20.559137] x8 : 0000000000000001 x7 : 0000000000008000 x6 : 000000000=
0000000
> [   20.566518] x5 : 000000000000801e x4 : 0000000054765809 x3 : 000000000=
000003f
> [   20.573899] x2 : 0000000000000040 x1 : ffff170fc0000040 x0 : ffff170fc=
0000000
> [   20.581282] Call trace:
> [   20.583976]  dcache_clean_poc+0x20/0x38
> [   20.588061]  iommu_dma_sync_single_for_device+0xc4/0xdc
> [   20.593534]  dma_sync_single_for_device+0x38/0x120
> [   20.598574]  mt76_dma_tx_queue_skb+0x4f4/0x5b0 [mt76]
> [   20.603880]  __mt76_tx_queue_skb+0x5c/0xe0 [mt76]
> [   20.608836]  mt76_tx+0xbc/0x164 [mt76]
> [   20.612838]  mt7921_tx+0x9c/0x170 [mt7921_common]
> [   20.617795]  ieee80211_tx_frags+0x22c/0x2a0 [mac80211]
> [   20.623215]  __ieee80211_tx+0x90/0x1c0 [mac80211]
> [   20.628195]  ieee80211_tx+0x114/0x160 [mac80211]
> [   20.633088]  ieee80211_xmit+0xa0/0xd4 [mac80211]
> [   20.637980]  __ieee80211_tx_skb_tid_band+0xa8/0x2e0 [mac80211]
> [   20.644087]  ieee80211_tx_skb_tid+0xac/0x270 [mac80211]
> [   20.649585]  ieee80211_send_auth+0x1ac/0x250 [mac80211]
> [   20.655080]  ieee80211_auth+0x16c/0x2dc [mac80211]
> [   20.660145]  ieee80211_sta_work+0x3a0/0xab4 [mac80211]
> [   20.665557]  ieee80211_iface_work+0x394/0x400 [mac80211]
> [   20.671144]  process_one_work+0x294/0x674
> [   20.675406]  worker_thread+0x7c/0x45c
> [   20.679316]  kthread+0x104/0x110
> [   20.682793]  ret_from_fork+0x10/0x20
> [   20.686621] Code: d2800082 9ac32042 d1000443 8a230000 (d50b7a20)
> [   20.692962] ---[ end trace 0000000000000000 ]---
>=20
> Fixes: cd372b8c99c5 ("wifi: mt76: add WED RX support to mt76_dma_{add,get=
}_buf")
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@coll=
abora.com>
> ---
>  drivers/net/wireless/mediatek/mt76/dma.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wirel=
ess/mediatek/mt76/dma.c
> index 420302ff0328..a0fe3ab0126d 100644
> --- a/drivers/net/wireless/mediatek/mt76/dma.c
> +++ b/drivers/net/wireless/mediatek/mt76/dma.c
> @@ -215,6 +215,12 @@ mt76_dma_add_buf(struct mt76_dev *dev, struct mt76_q=
ueue *q,
>  	u32 ctrl;
>  	int i, idx =3D -1;
> =20
> +	if (txwi && !(q->flags & MT_QFLAG_WED) &&
> +	    !FIELD_GET(MT_QFLAG_WED_TYPE, q->flags)) {
> +		q->entry[q->head].txwi =3D DMA_DUMMY_DATA;
> +		q->entry[q->head].skip_buf0 =3D true;
> +	}
> +
>  	for (i =3D 0; i < nbufs; i +=3D 2, buf +=3D 2) {
>  		u32 buf0 =3D buf[0].addr, buf1 =3D 0;
> =20
> @@ -238,11 +244,6 @@ mt76_dma_add_buf(struct mt76_dev *dev, struct mt76_q=
ueue *q,
>  			ctrl =3D FIELD_PREP(MT_DMA_CTL_SD_LEN0, buf[0].len) |
>  			       MT_DMA_CTL_TO_HOST;
>  		} else {
> -			if (txwi) {
> -				q->entry[q->head].txwi =3D DMA_DUMMY_DATA;
> -				q->entry[q->head].skip_buf0 =3D true;
> -			}
> -
>  			if (buf[0].skip_unmap)
>  				entry->skip_buf0 =3D true;
>  			entry->skip_buf1 =3D i =3D=3D nbufs - 1;
> --=20
> 2.39.0
>=20

I think this issue has been already fixed by Felix here:
https://lore.kernel.org/linux-wireless/a30d8580-936a-79e4-c1c7-70f3d3b8da35=
@nbd.name/

Regards,
Lorenzo

--luqFSIfwu5Nm9Vpn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY8BCKgAKCRA6cBh0uS2t
rA/jAQCdqv3DR4wJvKGDGbEHn7GN+1hbN1u9xaVXyuUH/5sSfAD/SSUtxeGi8eWG
VH/7JRnX80nENCiJkK2aJnCQ6tqaRgg=
=+V0g
-----END PGP SIGNATURE-----

--luqFSIfwu5Nm9Vpn--
