Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E34B66DB6B
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 11:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236481AbjAQKpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 05:45:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235963AbjAQKpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 05:45:13 -0500
Received: from air.basealt.ru (air.basealt.ru [194.107.17.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A217F72A4;
        Tue, 17 Jan 2023 02:45:12 -0800 (PST)
Received: by air.basealt.ru (Postfix, from userid 490)
        id 408F52F20230; Tue, 17 Jan 2023 10:45:11 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
Received: from localhost (broadband-188-32-10-232.ip.moscow.rt.ru [188.32.10.232])
        by air.basealt.ru (Postfix) with ESMTPSA id 6A7CD2F2022A;
        Tue, 17 Jan 2023 10:45:08 +0000 (UTC)
Date:   Tue, 17 Jan 2023 13:45:08 +0300
From:   "Alexey V. Vissarionov" <gremlin@altlinux.org>
To:     Arend van Spriel <aspriel@gmail.com>
Cc:     Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Chi-hsien Lin <chi-hsien.lin@cypress.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Wataru Gohda <wataru.gohda@cypress.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        lvc-project@linuxtesting.org,
        "Alexey V. Vissarionov" <gremlin@altlinux.org>
Subject: [PATCH] wifi: brcmfmac: Fix allocation size
Message-ID: <20230117104508.GB12547@altlinux.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The "pkt" is a pointer to struct sk_buff, so it's just 4 or 8
bytes, while the structure itself is much bigger.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: bbd1f932e7c45ef1 ("brcmfmac: cleanup ampdu-rx host reorder code")
Signed-off-by: Alexey V. Vissarionov <gremlin@altlinux.org>

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index 36af81975855c525..0d283456da331464 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -1711,7 +1711,7 @@ void brcmf_fws_rxreorder(struct brcmf_if *ifp, struct=
 sk_buff *pkt)
 		buf_size =3D sizeof(*rfi);
 		max_idx =3D reorder_data[BRCMF_RXREORDER_MAXIDX_OFFSET];
=20
-		buf_size +=3D (max_idx + 1) * sizeof(pkt);
+		buf_size +=3D (max_idx + 1) * sizeof(struct sk_buff);
=20
 		/* allocate space for flow reorder info */
 		brcmf_dbg(INFO, "flow-%d: start, maxidx %d\n",



--=20
Alexey V. Vissarionov
gremlin =F0=F2=E9 altlinux =F4=FE=EB org; +vii-cmiii-ccxxix-lxxix-xlii
GPG: 0D92F19E1C0DC36E27F61A29CD17E2B43D879005 @ hkp://keys.gnupg.net

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJjxnw0AAoJEFv2F9znRj5KQvAP/0vVdNTgXeTXiNmYRz66mfge
uzb0OEuTbO7b5fm+PszT9w+gArHzfoPuJIviWLJlC34vH/25WUTouZudPmF9QhG4
WiixT07wc1Urd+1Oi62bEoSn41gs9UE431R1wRuUKENwRp5E8JVQ15xW5O9YrxLi
oQ1KzOIHR84Z5Qi+3bQnp/8ZX5b3G+2Zs9h573szhsfGWQ7+ERBJ2MgJI76Mw5aZ
IEy2Pmtxy4YE5pYqz7fNRSSBS8ogFSjY8AXqQkfGJcKyU5xsWEo9Pv6+QnouE55K
jMQ8+04IxdS6sONhYh4AWawQRHsFzEwnCqLTagScUeahPgAXeHTmjWbw6n5rddF0
hEgsby5bEgIQMoaRyAowUsnoUsBE+TXGywlVZwjHMmH6z1Gl2EElWm111wJjaNo4
J54EFfodR8SDyHlLPj8KGq3NkBX0Ur2UTdGw69acRnoNqA4gCCBy7KobPoanRNFG
831bqWdEdFymktaKgZlq136MC+WAAf3ZVpCM/RPY44E6iP1iZs8A0RcV2Q4nfuJE
nLPih2ehsVYvcrOHB+Neyfxf/iNt4TUZVmYIpo8KAiIZDTm/9/RKqDZBm50vL9TI
PPpExGb36sl83O/Pkna0PQ0v8gp37kpD453Tbhu0bcDsQaEm70Rfruexec0CNC6g
twh9nUXNws+N5iuGCPQk
=yQpN
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
