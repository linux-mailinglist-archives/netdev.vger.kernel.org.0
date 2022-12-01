Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B155B63F9E8
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 22:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbiLAVe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 16:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbiLAVeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 16:34:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6BAC3591
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 13:34:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23D31B82037
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 21:34:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73710C433C1;
        Thu,  1 Dec 2022 21:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669930461;
        bh=WSxq0VVXBR36KvHqkgdZDoUaRmpg0ZDZ/oFsMEnQxIU=;
        h=Date:From:To:Cc:Subject:From;
        b=CoZzjVcCPM+rOx0J2mgxjBoPtV/9Djio2jC9CzCAGaUf7+RzlpyJD3lUgtYwAgKpr
         AR1oOU1wH1Mesx/UgeslaUZ3DqDwLn0byOJsQZF87L2y7tchuubwTN1Ux6cEOeIUEi
         0eP5FkuXBF/VhkGDHpDDRWWdJDvzHQuOlYxq+QlqHB0BIAucJfIof/j3vA8n8/KPji
         E1W7OSYxUVmQsQW0V/SP6B6VUN46DPy3iEc+hNZL158qmpSu9wP36O2BDEsOP/R5nE
         ztPuB8anac8jRtZiB3+I8UJ5MZM09EfwDAys80K1jzWmqpBxVaxFx/VyfbT/i8PiMV
         VeFWkCZl+JgmQ==
Date:   Thu, 1 Dec 2022 22:34:17 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     claudiu.manoil@nxp.com
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com
Subject: non-linear xdp fix for enetc driver
Message-ID: <Y4kd2f0563PVof5O@lore-desk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pj+KNPPIwowdv3g/"
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--pj+KNPPIwowdv3g/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Claudiu,

I am not very familiar with enetc driver codebase but I guess we are missin=
g to
set frag bit in xdp_buff flag whenever the driver receives a non linear pac=
ket
in xdp mode (frag bit is needed by xdp stack). Can you please check the pat=
ch
below? (if it is ok I will post a formal fix).

Regards,
Lorenzo

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/eth=
ernet/freescale/enetc/enetc.c
index 8671591cb750..9ddd6c1c6e0e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1416,6 +1416,7 @@ static void enetc_add_rx_buff_to_xdp(struct enetc_bdr=
 *rx_ring, int i,
 	skb_frag_size_set(frag, size);
 	__skb_frag_set_page(frag, rx_swbd->page);
=20
+	xdp_buff_set_frags_flag(xdp_buff);
 	shinfo->nr_frags++;
 }
=20

--pj+KNPPIwowdv3g/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY4kd2QAKCRA6cBh0uS2t
rBP5AP0bhDwWTENNtylCdPxAGZy+WgAdpOJ60CXpXSzmEUOWfgEAsCCa2ikYd7aj
WEau5dUM5jS/jQyx+XEhvbCIIY32cQE=
=9mS5
-----END PGP SIGNATURE-----

--pj+KNPPIwowdv3g/--
