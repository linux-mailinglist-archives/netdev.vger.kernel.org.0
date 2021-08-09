Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9373E3E2E
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 05:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbhHIDOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 23:14:42 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:39475 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229942AbhHIDOl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 23:14:41 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Gjh546hDXz9sWX;
        Mon,  9 Aug 2021 13:14:16 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1628478857;
        bh=PBjj26Hp+FfI8m2spcLYZvozmryRWtrKTxfF7Ad3WGA=;
        h=Date:From:To:Cc:Subject:From;
        b=VcmIWNspdC6lAnHMNrVYxF5y4Li4iJPbB4YRQyhyQJog1Ou2qprvIEscmhdDWaPmz
         JiBB8nY+aBJ1xtWqjw8Rr0t5AwBjovweJnopKJQpMJ5WsZIbCVtoWaCwsv6fDCHvKg
         d0T+3g1muWJbO4CwQEsYyH6iCcQhu4q91DjNn7Qg/v1JgbYtmms8maelSfIFg3yp8N
         nIPWJwt5lHU8nVj5hBnRnnQyYSnOlmAv3fKit9toI8eB3Xfb7tk8qM6RxQPoIn0M4S
         xpzpQZ52EnSmP/t3fyQ9Tvbz3lzqh+YbADotUjyos01LD0/b3It8QZ/mHu5NGMxYo4
         lKiXW3emL7AvA==
Date:   Mon, 9 Aug 2021 13:14:13 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210809131413.5a77ef8c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/mP7danhSHhkkwqeqiQ08ZYV";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/mP7danhSHhkkwqeqiQ08ZYV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h

between commit:

  9e26680733d5 ("bnxt_en: Update firmware call to retrieve TX PTP timestamp=
")

from the net tree and commits:

  9e518f25802c ("bnxt_en: 1PPS functions to configure TSIO pins")
  099fdeda659d ("bnxt_en: Event handler for PPS events")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
index 524f1c272054,cc3cdbaab6cf..000000000000
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
@@@ -19,9 -19,58 +19,59 @@@
 =20
  #define BNXT_PTP_QTS_TIMEOUT	1000
  #define BNXT_PTP_QTS_TX_ENABLES	(PORT_TS_QUERY_REQ_ENABLES_PTP_SEQ_ID |	\
 -				 PORT_TS_QUERY_REQ_ENABLES_TS_REQ_TIMEOUT)
 +				 PORT_TS_QUERY_REQ_ENABLES_TS_REQ_TIMEOUT | \
 +				 PORT_TS_QUERY_REQ_ENABLES_PTP_HDR_OFFSET)
 =20
+ struct pps_pin {
+ 	u8 event;
+ 	u8 usage;
+ 	u8 state;
+ };
+=20
+ #define TSIO_PIN_VALID(pin) ((pin) < (BNXT_MAX_TSIO_PINS))
+=20
+ #define EVENT_DATA2_PPS_EVENT_TYPE(data2)				\
+ 	((data2) & ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_EVENT_TYPE)
+=20
+ #define EVENT_DATA2_PPS_PIN_NUM(data2)					\
+ 	(((data2) &							\
+ 	  ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_PIN_NUMBER_MASK) >>\
+ 	 ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_PIN_NUMBER_SFT)
+=20
+ #define BNXT_DATA2_UPPER_MSK						\
+ 	ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_PPS_TIMESTAMP_UPPER_MASK
+=20
+ #define BNXT_DATA2_UPPER_SFT						\
+ 	(32 -								\
+ 	 ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_PPS_TIMESTAMP_UPPER_SFT)
+=20
+ #define BNXT_DATA1_LOWER_MSK						\
+ 	ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA1_PPS_TIMESTAMP_LOWER_MASK
+=20
+ #define BNXT_DATA1_LOWER_SFT						\
+ 	  ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA1_PPS_TIMESTAMP_LOWER_SFT
+=20
+ #define EVENT_PPS_TS(data2, data1)					\
+ 	(((u64)((data2) & BNXT_DATA2_UPPER_MSK) << BNXT_DATA2_UPPER_SFT) |\
+ 	 (((data1) & BNXT_DATA1_LOWER_MSK) >> BNXT_DATA1_LOWER_SFT))
+=20
+ #define BNXT_PPS_PIN_DISABLE	0
+ #define BNXT_PPS_PIN_ENABLE	1
+ #define BNXT_PPS_PIN_NONE	0
+ #define BNXT_PPS_PIN_PPS_IN	1
+ #define BNXT_PPS_PIN_PPS_OUT	2
+ #define BNXT_PPS_PIN_SYNC_IN	3
+ #define BNXT_PPS_PIN_SYNC_OUT	4
+=20
+ #define BNXT_PPS_EVENT_INTERNAL	1
+ #define BNXT_PPS_EVENT_EXTERNAL	2
+=20
+ struct bnxt_pps {
+ 	u8 num_pins;
+ #define BNXT_MAX_TSIO_PINS	4
+ 	struct pps_pin pins[BNXT_MAX_TSIO_PINS];
+ };
+=20
  struct bnxt_ptp_cfg {
  	struct ptp_clock_info	ptp_info;
  	struct ptp_clock	*ptp_clock;
@@@ -76,7 -125,9 +127,9 @@@ do {					=09
  	((dst) =3D READ_ONCE(src))
  #endif
 =20
 -int bnxt_ptp_parse(struct sk_buff *skb, u16 *seq_id);
 +int bnxt_ptp_parse(struct sk_buff *skb, u16 *seq_id, u16 *hdr_off);
+ void bnxt_ptp_pps_event(struct bnxt *bp, u32 data1, u32 data2);
+ void bnxt_ptp_reapply_pps(struct bnxt *bp);
  int bnxt_hwtstamp_set(struct net_device *dev, struct ifreq *ifr);
  int bnxt_hwtstamp_get(struct net_device *dev, struct ifreq *ifr);
  int bnxt_get_tx_ts_p5(struct bnxt *bp, struct sk_buff *skb);

--Sig_/mP7danhSHhkkwqeqiQ08ZYV
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmEQnYUACgkQAVBC80lX
0GwPcQgAjpAQ3xfm4l/f2SuChIkPXRVFfLQHyOGIupdka5B/lK8695b/ZwwBsQTo
Iar0UG00IpjFNaVYAlENMrBoeD6tJL1jNwopzsbYr7XAXi3/VIKE3sqz7TheNb1C
H22lGYtZPZm/Sco0A53zXmVrFelC6yNJ4JMbJL3G0kA6miCBGr42EHRmW26v+0hM
Nlb0lt7Obgyr4KxQwV6iWBhtIbBNPkXbzcvnUa4Vn0ntHRK4x1xDz0zFc5Yk7VWd
kAr34aA72qfl6YLBP+wGqZY7h0L3V4dZSEMzKqBdV/ZdPPChKaZUmU+cfZwALGdf
XXbOIHgSrRWCKVN6f+wwqCOgrtU6Ew==
=RaU7
-----END PGP SIGNATURE-----

--Sig_/mP7danhSHhkkwqeqiQ08ZYV--
