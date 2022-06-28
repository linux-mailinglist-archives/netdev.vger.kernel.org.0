Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADF755E921
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236960AbiF1PNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 11:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347985AbiF1PNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 11:13:08 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61277AE61
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 08:13:06 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-101bb9275bcso17434202fac.8
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 08:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:content-transfer-encoding
         :user-agent:mime-version;
        bh=QGxRJA9nwArFJx49jv8WJK/GJ7cOrBKNTA4/7xnGZPw=;
        b=OiC0eZPF1k9AdJ3sA9+9pWmbHo5aZfb7DE/35sRlfT1bFsybn8P9mqnVQ123N3XkRs
         /foCCGEt9CDhagJUlSAlq6uk0aIhkUAThY8a2DAum5RgioYRIM4dxZ6HqE+qsBrx85O6
         iIMkXUy7P6FvT0pkxIh3ZrXJiZkzRwMQ+V7DWasjKU0TFWvdb3vgUIjudcupvDVq0I+U
         XOacM3thdnbEp0Krn/V+kZeYg05YZ20j6C7EBtv8LcLUvi7et1dTpgDqyeTZmcDpfNgT
         kIUCyW50YXlmBCc5aB94bprTtPyfOQbU20hzhtt/7C0RXa8lBN3f3n8tty+b6nfO6+JB
         4X+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date
         :content-transfer-encoding:user-agent:mime-version;
        bh=QGxRJA9nwArFJx49jv8WJK/GJ7cOrBKNTA4/7xnGZPw=;
        b=wZ16DE86mm7PWoMVnOdF1Vmuct7qZB0aG+8mtc2EsTfKp8KwfOSqHE6frHLX+urLvJ
         HBcj9nKm9LzjYePNzneBBgNEqpKJgt5RJcmgEALf4lnGwgN5g7Vsn6Nu2HKrFs2O2QuM
         mGqpIi9J2vPGiLDsZ6SdYf4hfGvPfolk1DQgbKbmTYbTgRUFGvfcHU/y4H8zfDa5R/g/
         aufjfqxrff6IS/KbSe1VqtkdwZC4AFSB6pWZ2IiW/FZEFu9m0gvKuk/Qq4HeXyHzaNk1
         cAf+oA+XwuxDaKZQeVqo3VuC8yO9u492jAm2BMYqK0CEMR6VFtlQp0eXkhpumsY5S2DR
         E5mQ==
X-Gm-Message-State: AJIora/8Xa7IqfUmH5igV5T4hf69DiwoJZyHr3B3552Aavq5FIRmbIUu
        TJOceHAVilo9vHmNxhweZXrU1fTxHcQ=
X-Google-Smtp-Source: AGRyM1vBUGK5HycLnuzB9xrP01VWaiH8FQcvCLgaLDHJ/TSHEtgOWXz0x9GJOTsSQ6UUpgqtU/wR+w==
X-Received: by 2002:a05:6870:470d:b0:101:c49b:7e0d with SMTP id b13-20020a056870470d00b00101c49b7e0dmr22787oaq.273.1656429185445;
        Tue, 28 Jun 2022 08:13:05 -0700 (PDT)
Received: from ?IPv6:2804:14c:71:974c:ca57:10bc:696d:66a8? ([2804:14c:71:974c:ca57:10bc:696d:66a8])
        by smtp.gmail.com with ESMTPSA id h20-20020a4adcd4000000b004258ce7a111sm6391280oou.24.2022.06.28.08.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 08:13:04 -0700 (PDT)
Message-ID: <d6970bb04bf67598af4d316eaeb1792040b18cfd.camel@gmail.com>
Subject: [PATCH net] net: usb: ax88179_178a: Fix packet receiving
From:   Jose Alonso <joalonsof@gmail.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        Jann Horn <jannh@google.com>, Freddy Xin <freddy@asix.com.tw>
Date:   Tue, 28 Jun 2022 12:13:02 -0300
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch corrects packet receiving in ax88179_rx_fixup.

- problem observed:
  ifconfig shows allways a lot of 'RX Errors' while packets
  are received normally.

  This occurs because ax88179_rx_fixup does not recognise properly
  the usb urb received.
  The packets are normally processed and at the end, the code exits
  with 'return 0', generating RX Errors.
  (pkt_cnt=3D=3D-2 and ptk_hdr over field rx_hdr trying to identify
   another packet there)

  This is a usb urb received by "tcpdump -i usbmon2 -X" on a
  little-endian CPU:
  0x0000:  eeee f8e3 3b19 87a0 94de 80e3 daac 0800
           ^         packet 1 start (pkt_len =3D 0x05ec)
           ^^^^      IP alignment pseudo header
                ^    ethernet packet start
           last byte ethernet packet   v
           padding (8-bytes aligned)     vvvv vvvv
  0x05e0:  c92d d444 1420 8a69 83dd 272f e82b 9811
  0x05f0:  eeee f8e3 3b19 87a0 94de 80e3 daac 0800
  ...      ^ packet 2
  0x0be0:  eeee f8e3 3b19 87a0 94de 80e3 daac 0800
  ...
  0x1130:  9d41 9171 8a38 0ec5 eeee f8e3 3b19 87a0
  ...
  0x1720:  8cfc 15ff 5e4c e85c eeee f8e3 3b19 87a0
  ...
  0x1d10:  ecfa 2a3a 19ab c78c eeee f8e3 3b19 87a0
  ...
  0x2070:  eeee f8e3 3b19 87a0 94de 80e3 daac 0800
  ...      ^ packet 7
  0x2120:  7c88 4ca5 5c57 7dcc 0d34 7577 f778 7e0a
  0x2130:  f032 e093 7489 0740 3008 ec05 0000 0080
                               =3D=3D=3D=3D1=3D=3D=3D=3D =3D=3D=3D=3D2=3D=
=3D=3D=3D
           hdr_off             ^
           pkt_len =3D 0x05ec         ^^^^
           AX_RXHDR_*=3D0x00830  ^^^^   ^
           pkt_len =3D 0                        ^^^^
           AX_RXHDR_DROP_ERR=3D0x80000000  ^^^^   ^
  0x2140:  3008 ec05 0000 0080 3008 5805 0000 0080
  0x2150:  3008 ec05 0000 0080 3008 ec05 0000 0080
  0x2160:  3008 5803 0000 0080 3008 c800 0000 0080
           =3D=3D=3D11=3D=3D=3D=3D =3D=3D=3D12=3D=3D=3D=3D =3D=3D=3D13=3D=
=3D=3D=3D =3D=3D=3D14=3D=3D=3D=3D
  0x2170:  0000 0000 0e00 3821
                     ^^^^ ^^^^ rx_hdr
                     ^^^^      pkt_cnt=3D14
                          ^^^^ hdr_off=3D0x2138
           ^^^^ ^^^^           padding

  The dump shows that pkt_cnt is the number of entrys in the
  per-packet metadata. It is "2 * packet count".
  Each packet have two entrys. The first have a valid
  value (pkt_len and AX_RXHDR_*) and the second have a
  dummy-header 0x80000000 (pkt_len=3D0 with AX_RXHDR_DROP_ERR).
  Why exists dummy-header for each packet?!?
  My guess is that this was done probably to align the
  entry for each packet to 64-bits and maintain compatibility
  with old firmware.
  There is also a padding (0x00000000) before the rx_hdr to
  align the end of rx_hdr to 64-bit.
  Note that packets have a alignment of 64-bits (8-bytes).

  This patch assumes that the dummy-header and the last
  padding are optional. So it preserves semantics and
  recognises the same valid packets as the current code.
=20
  This patch was made using only the dumpfile information and
  tested with only one device:
  0b95:1790 ASIX Electronics Corp. AX88179 Gigabit Ethernet

Fixes: 57bc3d3ae8c1 ("net: usb: ax88179_178a: Fix out-of-bounds accesses in=
 RX fixup")
Fixes: e2ca90c276e1 ("ax88179_178a: ASIX AX88179_178A USB 3.0/2.0 to gigabi=
t ethernet adapter driver")
Signed-off-by: Jose Alonso <joalonsof@gmail.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>

---

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.=
c
index 4704ed6f00ef..ac2d400d1d6c 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1472,6 +1472,42 @@ static int ax88179_rx_fixup(struct usbnet *dev, stru=
ct sk_buff *skb)
 	 * are bundled into this buffer and where we can find an array of
 	 * per-packet metadata (which contains elements encoded into u16).
 	 */
+
+	/* SKB contents for current firmware:
+	 *   <packet 1> <padding>
+	 *   ...
+	 *   <packet N> <padding>
+	 *   <per-packet metadata entry 1> <dummy header>
+	 *   ...
+	 *   <per-packet metadata entry N> <dummy header>
+	 *   <padding2> <rx_hdr>
+	 *
+	 * where:
+	 *   <packet N> contains pkt_len bytes:
+	 *		2 bytes of IP alignment pseudo header
+	 *		packet received
+	 *   <per-packet metadata entry N> contains 4 bytes:
+	 *		pkt_len and fields AX_RXHDR_*
+	 *   <padding>	0-7 bytes to terminate at
+	 *		8 bytes boundary (64-bit).
+	 *   <padding2> 4 bytes to make rx_hdr terminate at
+	 *		8 bytes boundary (64-bit)
+	 *   <dummy-header> contains 4 bytes:
+	 *		pkt_len=3D0 and AX_RXHDR_DROP_ERR
+	 *   <rx-hdr>	contains 4 bytes:
+	 *		pkt_cnt and hdr_off (offset of
+	 *		  <per-packet metadata entry 1>)
+	 *
+	 * pkt_cnt is number of entrys in the per-packet metadata.
+	 * In current firmware there is 2 entrys per packet.
+	 * The first points to the packet and the
+	 *  second is a dummy header.
+	 * This was done probably to align fields in 64-bit and
+	 *  maintain compatibility with old firmware.
+	 * This code assumes that <dummy header> and <padding2> are
+	 *  optional.
+	 */
+
 	if (skb->len < 4)
 		return 0;
 	skb_trim(skb, skb->len - 4);
@@ -1485,51 +1521,66 @@ static int ax88179_rx_fixup(struct usbnet *dev, str=
uct sk_buff *skb)
 	/* Make sure that the bounds of the metadata array are inside the SKB
 	 * (and in front of the counter at the end).
 	 */
-	if (pkt_cnt * 2 + hdr_off > skb->len)
+	if (pkt_cnt * 4 + hdr_off > skb->len)
 		return 0;
 	pkt_hdr =3D (u32 *)(skb->data + hdr_off);
=20
 	/* Packets must not overlap the metadata array */
 	skb_trim(skb, hdr_off);
=20
-	for (; ; pkt_cnt--, pkt_hdr++) {
+	for (; pkt_cnt > 0; pkt_cnt--, pkt_hdr++) {
+		u16 pkt_len_plus_padd;
 		u16 pkt_len;
=20
 		le32_to_cpus(pkt_hdr);
 		pkt_len =3D (*pkt_hdr >> 16) & 0x1fff;
+		pkt_len_plus_padd =3D (pkt_len + 7) & 0xfff8;
=20
-		if (pkt_len > skb->len)
+		/* Skip dummy header used for alignment
+		 */
+		if (pkt_len =3D=3D 0)
+			continue;
+
+		if (pkt_len_plus_padd > skb->len)
 			return 0;
=20
 		/* Check CRC or runt packet */
-		if (((*pkt_hdr & (AX_RXHDR_CRC_ERR | AX_RXHDR_DROP_ERR)) =3D=3D 0) &&
-		    pkt_len >=3D 2 + ETH_HLEN) {
-			bool last =3D (pkt_cnt =3D=3D 0);
-
-			if (last) {
-				ax_skb =3D skb;
-			} else {
-				ax_skb =3D skb_clone(skb, GFP_ATOMIC);
-				if (!ax_skb)
-					return 0;
-			}
-			ax_skb->len =3D pkt_len;
-			/* Skip IP alignment pseudo header */
-			skb_pull(ax_skb, 2);
-			skb_set_tail_pointer(ax_skb, ax_skb->len);
-			ax_skb->truesize =3D pkt_len + sizeof(struct sk_buff);
-			ax88179_rx_checksum(ax_skb, pkt_hdr);
+		if ((*pkt_hdr & (AX_RXHDR_CRC_ERR | AX_RXHDR_DROP_ERR)) ||
+		    pkt_len < 2 + ETH_HLEN) {
+			dev->net->stats.rx_errors++;
+			skb_pull(skb, pkt_len_plus_padd);
+			continue;
+		}
=20
-			if (last)
-				return 1;
+		/* last packet */
+		if (pkt_len_plus_padd =3D=3D skb->len) {
+			skb_trim(skb, pkt_len);
=20
-			usbnet_skb_return(dev, ax_skb);
+			/* Skip IP alignment pseudo header */
+			skb_pull(skb, 2);
+
+			skb->truesize =3D SKB_TRUESIZE(pkt_len_plus_padd);
+			ax88179_rx_checksum(skb, pkt_hdr);
+			return 1;
 		}
=20
-		/* Trim this packet away from the SKB */
-		if (!skb_pull(skb, (pkt_len + 7) & 0xFFF8))
+		ax_skb =3D skb_clone(skb, GFP_ATOMIC);
+		if (!ax_skb)
 			return 0;
+		skb_trim(ax_skb, pkt_len);
+
+		/* Skip IP alignment pseudo header */
+		skb_pull(ax_skb, 2);
+
+		skb->truesize =3D pkt_len_plus_padd +
+				SKB_DATA_ALIGN(sizeof(struct sk_buff));
+		ax88179_rx_checksum(ax_skb, pkt_hdr);
+		usbnet_skb_return(dev, ax_skb);
+
+		skb_pull(skb, pkt_len_plus_padd);
 	}
+
+	return 0;
 }
=20
 static struct sk_buff *

--

