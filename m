Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74165BCCA4
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 15:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbiISNL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 09:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiISNL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 09:11:58 -0400
Received: from mail.sf-mail.de (mail.sf-mail.de [IPv6:2a01:4f8:1c17:6fae:616d:6c69:616d:6c69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02251EEDA
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 06:11:48 -0700 (PDT)
Received: (qmail 14401 invoked from network); 19 Sep 2022 13:12:09 -0000
Received: from p200300cf070fe30076d435fffeb7be92.dip0.t-ipconnect.de ([2003:cf:70f:e300:76d4:35ff:feb7:be92]:41162 HELO eto.sf-tec.de) (auth=eike@sf-mail.de)
        by mail.sf-mail.de (Qsmtpd 0.38dev) with (TLS_AES_256_GCM_SHA384 encrypted) ESMTPSA
        for <davem@davemloft.net>; Mon, 19 Sep 2022 15:12:09 +0200
From:   Rolf Eike Beer <eike-kernel@sf-tec.de>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Sean Anderson <seanga2@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Nick Bowler <nbowler@draconx.ca>,
        Sean Anderson <seanga2@gmail.com>
Subject: Re: [PATCH net-next 04/13] sunhme: Return an ERR_PTR from quattro_pci_find
Date:   Mon, 19 Sep 2022 15:11:35 +0200
Message-ID: <14346017.muaEW6z1dk@eto.sf-tec.de>
In-Reply-To: <20220918232626.1601885-5-seanga2@gmail.com>
References: <20220918232626.1601885-1-seanga2@gmail.com> <20220918232626.1601885-5-seanga2@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart31393247.Bq8uY58Wff"; micalg="pgp-sha1"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart31393247.Bq8uY58Wff
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Date: Mon, 19 Sep 2022 15:11:35 +0200
Message-ID: <14346017.muaEW6z1dk@eto.sf-tec.de>
In-Reply-To: <20220918232626.1601885-5-seanga2@gmail.com>
MIME-Version: 1.0

Am Montag, 19. September 2022, 01:26:17 CEST schrieb Sean Anderson:
> In order to differentiate between a missing bridge and an OOM condition,
> return ERR_PTRs from quattro_pci_find. This also does some general linting
> in the area.
> 
> Signed-off-by: Sean Anderson <seanga2@gmail.com>
> ---
> 
>  drivers/net/ethernet/sun/sunhme.c | 33 +++++++++++++++++++------------
>  1 file changed, 20 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sun/sunhme.c
> b/drivers/net/ethernet/sun/sunhme.c index 1fc16801f520..52247505d08e 100644
> --- a/drivers/net/ethernet/sun/sunhme.c
> +++ b/drivers/net/ethernet/sun/sunhme.c
> @@ -2569,30 +2569,33 @@ static void quattro_sbus_free_irqs(void)
>  #ifdef CONFIG_PCI
>  static struct quattro *quattro_pci_find(struct pci_dev *pdev)
>  {
> +	int i;
>  	struct pci_dev *bdev = pdev->bus->self;
>  	struct quattro *qp;
> 
> -	if (!bdev) return NULL;
> +	if (!bdev)
> +		return ERR_PTR(-ENODEV);
> +
>  	for (qp = qfe_pci_list; qp != NULL; qp = qp->next) {
>  		struct pci_dev *qpdev = qp->quattro_dev;
> 
>  		if (qpdev == bdev)
>  			return qp;
>  	}
> +
>  	qp = kmalloc(sizeof(struct quattro), GFP_KERNEL);
> -	if (qp != NULL) {
> -		int i;
> +	if (!qp)
> +		return ERR_PTR(-ENOMEM);
> 
> -		for (i = 0; i < 4; i++)
> -			qp->happy_meals[i] = NULL;
> +	for (i = 0; i < 4; i++)
> +		qp->happy_meals[i] = NULL;

I know you are only reindenting it, but I dislike moving the variable up to 
the top of the function. Since the kernel is C99 meanwhile the variable could 
be declared just in the for loop. And when touching this anyway I think we 
could get rid of the magic "4" by using ARRAY_SIZE(qp->happy_meals). Or just 
replace the whole thing with memset(qp->happy_meals, 0, sizeof(qp-
>happy_meals)).

Eike
--nextPart31393247.Bq8uY58Wff
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSaYVDeqwKa3fTXNeNcpIk+abn8TgUCYyhqhwAKCRBcpIk+abn8
TpJzAKCQGl8upIHMIxG7ipYVnt98wSNOjgCcD4kzEbuTj2LGc/tUBIjhhZif9pg=
=S7Ps
-----END PGP SIGNATURE-----

--nextPart31393247.Bq8uY58Wff--



