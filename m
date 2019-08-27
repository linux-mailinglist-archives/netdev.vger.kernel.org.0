Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC57B9DC0E
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 05:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbfH0DkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 23:40:18 -0400
Received: from alexa-out-tai-01.qualcomm.com ([103.229.16.226]:33272 "EHLO
        alexa-out-tai-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728025AbfH0DkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 23:40:18 -0400
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Aug 2019 23:40:15 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=qti.qualcomm.com; i=@qti.qualcomm.com; q=dns/txt;
  s=qcdkim; t=1566877215; x=1598413215;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=HueO28Mo5THvdok84YE2yPuCzBaX4zbwcSWbNLlZqUI=;
  b=VCvX+SeSCIRIoU1niwhciF4srOxAYYSgW4j4fJ6VM8OFkB13VzgqSC46
   CiAitpmEff+BgV3TNwyjpyUICGlaMvJeRn5HHPzqDGToqcTnKoeCxQ2kX
   vbItLLSsyP2XwUmv1mLGmFAzRHhITuyNF1LfU2wgQamofTX876jnYFa76
   I=;
Subject: RE: [PATCH,
 RFC] ath10k: Fix skb->len (properly) in ath10k_sdio_mbox_rx_packet
Thread-Topic: [PATCH, RFC] ath10k: Fix skb->len (properly) in ath10k_sdio_mbox_rx_packet
Received: from ironmsg03-tai.qualcomm.com ([10.249.140.8])
  by alexa-out-tai-01.qualcomm.com with ESMTP; 27 Aug 2019 11:34:07 +0800
Received: from aptaiexm02e.ap.qualcomm.com ([10.249.150.15])
  by ironmsg03-tai.qualcomm.com with ESMTP/TLS/AES256-SHA; 27 Aug 2019 11:33:54 +0800
Received: from aptaiexm02f.ap.qualcomm.com (10.249.150.16) by
 aptaiexm02e.ap.qualcomm.com (10.249.150.15) with Microsoft SMTP Server (TLS)
 id 15.0.1473.3; Tue, 27 Aug 2019 11:33:52 +0800
Received: from aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1]) by
 aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1%19]) with mapi id
 15.00.1473.005; Tue, 27 Aug 2019 11:33:52 +0800
From:   Wen Gong <wgong@qti.qualcomm.com>
To:     Nicolas Boichat <drinkcat@chromium.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     Alagu Sankar <alagusankar@silex-india.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "briannorris@chromium.org" <briannorris@chromium.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "wgong@codeaurora.org" <wgong@codeaurora.org>,
        "niklas.cassel@linaro.org" <niklas.cassel@linaro.org>,
        "tientzu@chromium.org" <tientzu@chromium.org>,
        "David S . Miller" <davem@davemloft.net>
Thread-Index: AQHVXG89wIhJ11LRtUm/dwetQaAonKcOT+iw
Date:   Tue, 27 Aug 2019 03:33:52 +0000
Message-ID: <36878f3488f047978038c844daedd02f@aptaiexm02f.ap.qualcomm.com>
References: <20190827003326.147452-1-drinkcat@chromium.org>
In-Reply-To: <20190827003326.147452-1-drinkcat@chromium.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.249.136.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: ath10k <ath10k-bounces@lists.infradead.org> On Behalf Of Nicolas
> Boichat
> Sent: Tuesday, August 27, 2019 8:33 AM
> To: kvalo@codeaurora.org
> Cc: Alagu Sankar <alagusankar@silex-india.com>; netdev@vger.kernel.org;
> briannorris@chromium.org; linux-wireless@vger.kernel.org; linux-
> kernel@vger.kernel.org; ath10k@lists.infradead.org;
> wgong@codeaurora.org; niklas.cassel@linaro.org; tientzu@chromium.org;
> David S . Miller <davem@davemloft.net>
> Subject: [EXT] [PATCH, RFC] ath10k: Fix skb->len (properly) in
> ath10k_sdio_mbox_rx_packet
>=20
> (not a formal patch, take this as a bug report for now, I can clean
> up depending on the feedback I get here)
>=20
> There's at least 3 issues here, and the patch fixes 2/3 only, I'm not sur=
e
> how/if 1 should be handled.
>  1. ath10k_sdio_mbox_rx_alloc allocating skb of a incorrect size (too
>     small)
>  2. ath10k_sdio_mbox_rx_packet calling skb_put with that incorrect size.
>  3. ath10k_sdio_mbox_rx_process_packet attempts to fixup the size, but
>     does not use proper skb_put commands to do so, so we end up with
>     a mismatch between skb->head + skb->tail and skb->data + skb->len.
>=20
> Let's start with 3, this is quite serious as this and causes corruptions
> in the TCP stack, as the stack tries to coalesce packets, and relies on
> skb->tail being correct (that is, skb_tail_pointer must point to the
> first byte _after_ the data): one must never manipulate skb->len
> directly.
>=20
> Instead, we need to use skb_put to allocate more space (which updates
> skb->len and skb->tail). But it seems odd to do that in
> ath10k_sdio_mbox_rx_process_packet, so I move the code to
> ath10k_sdio_mbox_rx_packet (point 2 above).
>=20
> However, there is still something strange (point 1 above), why is
> ath10k_sdio_mbox_rx_alloc allocating packets of the incorrect
> (too small?) size? What happens if the packet is bigger than alloc_len?
> Does this lead to corruption/lost data?
>=20
> Fixes: 8530b4e7b22bc3b ("ath10k: sdio: set skb len for all rx packets")
> Signed-off-by: Nicolas Boichat <drinkcat@chromium.org>
>=20
> ---
>=20
> One simple way to test this is this scriplet, that sends a lot of
> small packets over SSH:
> (for i in `seq 1 300`; do echo $i; sleep 0.1; done) | ssh $IP cat
>=20
> In my testing it rarely ever reach 300 without failure.
>=20
>  drivers/net/wireless/ath/ath10k/sdio.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath10k/sdio.c
> b/drivers/net/wireless/ath/ath10k/sdio.c
> index 8ed4fbd8d6c3888..a9f5002863ee7bb 100644
> --- a/drivers/net/wireless/ath/ath10k/sdio.c
> +++ b/drivers/net/wireless/ath/ath10k/sdio.c
> @@ -381,16 +381,14 @@ static int
> ath10k_sdio_mbox_rx_process_packet(struct ath10k *ar,
>  	struct ath10k_htc_hdr *htc_hdr =3D (struct ath10k_htc_hdr *)skb->data;
>  	bool trailer_present =3D htc_hdr->flags &
> ATH10K_HTC_FLAG_TRAILER_PRESENT;
>  	enum ath10k_htc_ep_id eid;
> -	u16 payload_len;
>  	u8 *trailer;
>  	int ret;
>=20
> -	payload_len =3D le16_to_cpu(htc_hdr->len);
> -	skb->len =3D payload_len + sizeof(struct ath10k_htc_hdr);
> +	/* TODO: Remove this? */
If the pkt->act_len has set again in ath10k_sdio_mbox_rx_packet, seems not =
needed.
> +	WARN_ON(skb->len !=3D le16_to_cpu(htc_hdr->len) + sizeof(*htc_hdr));
>=20
>  	if (trailer_present) {
> -		trailer =3D skb->data + sizeof(*htc_hdr) +
> -			  payload_len - htc_hdr->trailer_len;
> +		trailer =3D skb->data + skb->len - htc_hdr->trailer_len;
>=20
>  		eid =3D pipe_id_to_eid(htc_hdr->eid);
>=20
> @@ -637,8 +635,16 @@ static int ath10k_sdio_mbox_rx_packet(struct
> ath10k *ar,
>  	ret =3D ath10k_sdio_readsb(ar, ar_sdio->mbox_info.htc_addr,
>  				 skb->data, pkt->alloc_len);
>  	pkt->status =3D ret;
> -	if (!ret)
> +	if (!ret) {
> +		/* Update actual length. */
> +		/* FIXME: This looks quite wrong, why is pkt->act_len not
> +		 * correct in the first place?
> +		 */
Firmware will do bundle for rx packet, and the aligned length by block size=
(256) of each packet's len is same=20
in a bundle.

Eg.=20
packet 1 len: 300, aligned length:512
packet 2 len: 400, aligned length:512
packet 3 len: 200, aligned length:256
packet 4 len: 100, aligned length:256
packet 5 len: 700, aligned length:768
packet 6 len: 600, aligned length:768

then packet 1,2 will in bundle 1, packet 3,4 in a bundle 2, packet 5,6 in a=
 bundle 3.

For bundle 1, packet 1,2 will both allocate with len 512, and act_len is 30=
0 first,
then packet 2's len will be overwrite to 400.

For bundle 2, packet 3,4 will both allocate with len 256, and act_len is 20=
0 first,
then packet 4's len will be overwrite to 100.

For bundle 3, packet 5,6 will both allocate with len 768, and act_len is 70=
0 first,
then packet 6's len will be overwrite to 600.

> +		struct ath10k_htc_hdr *htc_hdr =3D
> +			(struct ath10k_htc_hdr *)skb->data;
> +		pkt->act_len =3D le16_to_cpu(htc_hdr->len) + sizeof(*htc_hdr);
>  		skb_put(skb, pkt->act_len);
> +	}
>=20
>  	return ret;
>  }
> --
> 2.23.0.187.g17f5b7556c-goog
>=20
>=20
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
