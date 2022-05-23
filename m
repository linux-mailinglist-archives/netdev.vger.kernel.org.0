Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A03985306FA
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 03:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235566AbiEWBKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 21:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbiEWBK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 21:10:29 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24329377C6;
        Sun, 22 May 2022 18:10:26 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L5zlg4BlGz4xXg;
        Mon, 23 May 2022 11:10:23 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1653268224;
        bh=eOTK4n9SkYDRGWdogVlDv82mfD+vR0bPl0p1Xhqr6eM=;
        h=Date:From:To:Cc:Subject:From;
        b=E2yhFzALr25iM+46FmkqyyYqGRptGHYevdNixYgMSVGZvGB3tjkd2rGx1dJVPvOFB
         tjmq1XPfEwHzy4PhSV1OFmUK3LtSi7lADyQgmU+9w9SpDTeH8VzsAwIFNOaxVsenkb
         97c44yEAaBGCpH1Q8yigFyQSgDRxhGs9RDvzZlklDwfrTvUq3ghc0iFoHTyRYovHjk
         h4cLkVWeKG5efqbLHtxzTYhcbu5QrYj05yWg3xd0FZF4Akj3hsIIWSlp4lTvqZHCVL
         j2Rj3Y0tZ3TXi6+fv8XYytLWJXtd+fsqxTOD/N1y6ksa6+EY+PkSXMCvxdcBaZoXEI
         UlhoHqN28GhgA==
Date:   Mon, 23 May 2022 11:10:21 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Harini Katakam <harini.katakam@xilinx.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Robert Hancock <robert.hancock@calian.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20220523111021.31489367@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/rJVZW_6UKvrEmkhGS8oX/mw";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/rJVZW_6UKvrEmkhGS8oX/mw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/cadence/macb_main.c

between commit:

  5cebb40bc955 ("net: macb: Fix PTP one step sync support")

from the net tree and commit:

  138badbc21a0 ("net: macb: use NAPI for TX completion path")

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

diff --cc drivers/net/ethernet/cadence/macb_main.c
index 3a1b5ac48ca5,d6cdb97bfb38..000000000000
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@@ -1123,57 -1119,20 +1120,50 @@@ static void macb_tx_error_task(struct w
  	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
 =20
  	spin_unlock_irqrestore(&bp->lock, flags);
+ 	napi_enable(&queue->napi_tx);
  }
 =20
 +static bool ptp_one_step_sync(struct sk_buff *skb)
 +{
 +	struct ptp_header *hdr;
 +	unsigned int ptp_class;
 +	u8 msgtype;
 +
 +	/* No need to parse packet if PTP TS is not involved */
 +	if (likely(!(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)))
 +		goto not_oss;
 +
 +	/* Identify and return whether PTP one step sync is being processed */
 +	ptp_class =3D ptp_classify_raw(skb);
 +	if (ptp_class =3D=3D PTP_CLASS_NONE)
 +		goto not_oss;
 +
 +	hdr =3D ptp_parse_header(skb, ptp_class);
 +	if (!hdr)
 +		goto not_oss;
 +
 +	if (hdr->flag_field[0] & PTP_FLAG_TWOSTEP)
 +		goto not_oss;
 +
 +	msgtype =3D ptp_get_msgtype(hdr, ptp_class);
 +	if (msgtype =3D=3D PTP_MSGTYPE_SYNC)
 +		return true;
 +
 +not_oss:
 +	return false;
 +}
 +
- static void macb_tx_interrupt(struct macb_queue *queue)
+ static int macb_tx_complete(struct macb_queue *queue, int budget)
  {
- 	unsigned int tail;
- 	unsigned int head;
- 	u32 status;
  	struct macb *bp =3D queue->bp;
  	u16 queue_index =3D queue - bp->queues;
+ 	unsigned int tail;
+ 	unsigned int head;
+ 	int packets =3D 0;
 =20
- 	status =3D macb_readl(bp, TSR);
- 	macb_writel(bp, TSR, status);
-=20
- 	if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
- 		queue_writel(queue, ISR, MACB_BIT(TCOMP));
-=20
- 	netdev_vdbg(bp->dev, "macb_tx_interrupt status =3D 0x%03lx\n",
- 		    (unsigned long)status);
-=20
+ 	spin_lock(&queue->tx_ptr_lock);
  	head =3D queue->tx_head;
- 	for (tail =3D queue->tx_tail; tail !=3D head; tail++) {
+ 	for (tail =3D queue->tx_tail; tail !=3D head && packets < budget; tail++=
) {
  		struct macb_tx_skb	*tx_skb;
  		struct sk_buff		*skb;
  		struct macb_dma_desc	*desc;

--Sig_/rJVZW_6UKvrEmkhGS8oX/mw
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmKK3v4ACgkQAVBC80lX
0Gw5mwf8DC0QHsCJrn+g1jKU4ysIqP+XePG2ugM2/sEWkQE2JNkKa88RV6DxMFG1
lgSmV4iFK2qD0Aj7ntlYnPgNUZnNDIpXwnZmAcAGHaCoY0Wc/uR3BrkLHNPMEhWV
EMubNwhRHJnqs/qr3c2SAdgpZkkRCXmpWHIh22AVJDEt/3LFCH21/kzdRpCsS6gr
cR8AmKCP0MiLgzgQnrPKl9uF5QwP63WkV8uDGMKZlmDsXh5gFY0B7e/vqpaBLdwB
4D1IQKZZuIhJdBDmehjg9v1nTTcpOjCudDH0eSLcjgNn69USIqmTWrkM42ckDnD+
dmEugOlnXGYOnrrCmSyDOh4WkFnP8w==
=nSlw
-----END PGP SIGNATURE-----

--Sig_/rJVZW_6UKvrEmkhGS8oX/mw--
