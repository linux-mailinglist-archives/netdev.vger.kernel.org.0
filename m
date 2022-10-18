Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDDFF6028CC
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 11:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiJRJyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 05:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiJRJx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 05:53:59 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A56836BCD;
        Tue, 18 Oct 2022 02:53:58 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5C8491C09D8; Tue, 18 Oct 2022 11:53:57 +0200 (CEST)
Date:   Tue, 18 Oct 2022 11:53:56 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wen Gong <quic_wgong@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 16/25] wifi: ath10k: reset pointer after
 memory free to avoid potential use-after-free
Message-ID: <20221018095356.GH1264@duo.ucw.cz>
References: <20221009222436.1219411-1-sashal@kernel.org>
 <20221009222436.1219411-16-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="y0Ed1hDcWxc3B7cn"
Content-Disposition: inline
In-Reply-To: <20221009222436.1219411-16-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--y0Ed1hDcWxc3B7cn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Wen Gong <quic_wgong@quicinc.com>
>=20
> [ Upstream commit 1e1cb8e0b73e6f39a9d4a7a15d940b1265387eb5 ]
>=20
> When running suspend test, kernel crash happened in ath10k, and it is
> fixed by commit b72a4aff947b ("ath10k: skip ath10k_halt during suspend
> for driver state RESTARTING").
>=20
> Currently the crash is fixed, but as a common code style, it is better
> to set the pointer to NULL after memory is free.
>=20
> This is to address the code style and it will avoid potential bug of
> use-after-free.

We don't have this patch in 4.19:

b72a4aff947b ("ath10k: skip ath10k_halt during suspend for driver state RES=
TARTING").

We probably should take that one, as this may depend on it. On the
other hand, we don't need this one as it is just a cleanup...

Best regards,
								Pavel
							=09
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -302,12 +302,16 @@ void ath10k_htt_rx_free(struct ath10k_htt *htt)
>  			  ath10k_htt_get_vaddr_ring(htt),
>  			  htt->rx_ring.base_paddr);
> =20
> +	ath10k_htt_config_paddrs_ring(htt, NULL);
> +
>  	dma_free_coherent(htt->ar->dev,
>  			  sizeof(*htt->rx_ring.alloc_idx.vaddr),
>  			  htt->rx_ring.alloc_idx.vaddr,
>  			  htt->rx_ring.alloc_idx.paddr);
> +	htt->rx_ring.alloc_idx.vaddr =3D NULL;
> =20
>  	kfree(htt->rx_ring.netbufs_ring);
> +	htt->rx_ring.netbufs_ring =3D NULL;
>  }
> =20
>  static inline struct sk_buff *ath10k_htt_rx_netbuf_pop(struct ath10k_htt=
 *htt)
> @@ -641,8 +645,10 @@ int ath10k_htt_rx_alloc(struct ath10k_htt *htt)
>  			  ath10k_htt_get_rx_ring_size(htt),
>  			  vaddr_ring,
>  			  htt->rx_ring.base_paddr);
> +	ath10k_htt_config_paddrs_ring(htt, NULL);
>  err_dma_ring:
>  	kfree(htt->rx_ring.netbufs_ring);
> +	htt->rx_ring.netbufs_ring =3D NULL;
>  err_netbuf:
>  	return -ENOMEM;
>  }
> --=20
> 2.35.1

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--y0Ed1hDcWxc3B7cn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY053tAAKCRAw5/Bqldv6
8n84AJ45/QgkGMpSg/yVjmSGm2uAOTr89QCeLihL/LnMqBq5hHDBcCEB+8hBSt0=
=6ejv
-----END PGP SIGNATURE-----

--y0Ed1hDcWxc3B7cn--
