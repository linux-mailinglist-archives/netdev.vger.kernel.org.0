Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 683AB4BF534
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 10:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiBVJ5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 04:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiBVJ5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 04:57:01 -0500
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFF5109A;
        Tue, 22 Feb 2022 01:56:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1645523606;
    s=strato-dkim-0002; d=fpond.eu;
    h=Subject:References:In-Reply-To:Message-ID:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=dWKZOFQ+HIvrBNvfir4obwb7uVDZZb0beIIECXtlDkQ=;
    b=exfJhR7jvCtg4CEw/NPhwh4CrS/VHlNeZhrary/CFZIVX0kpWMYhA10vK6naSw4iMY
    nYyBeUC8Afyiu/qE7odMcG7NAQIFB9J41nU7dVAbQVLO3QmiY9cqp8faFxXIuGMFbzYw
    KziTMkmXEwB0XAmjIkyE1GVV2nH4Qns92uFRI3zyIg3TuW0nw4D9ww1mn7FyJAorGnHE
    yhJOqiyDQWnA+5Ll8RxVVFOQynKJ4EfD8iKLZPtJud/ZaaItB2dsBwDSW1j7BsbqkEv2
    vRPmVu+o5PWG/mzREGV0C/+iZQ7OS3P/V0Qs4GgJCXRDBdkQbYoJK/vPtVecD9MMkLpF
    EA5A==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73amq+g13rqGzvv3qxio1R8fCs/87J2o0="
X-RZG-CLASS-ID: mo00
Received: from oxapp05-05.back.ox.d0m.de
    by smtp-ox.front (RZmta 47.40.0 AUTH)
    with ESMTPSA id 6c30c7y1M9rQ2KB
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
    Tue, 22 Feb 2022 10:53:26 +0100 (CET)
Date:   Tue, 22 Feb 2022 10:53:26 +0100 (CET)
From:   Ulrich Hecht <uli@fpond.eu>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        Pavel Machek <pavel@denx.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>
Message-ID: <1103141484.974980.1645523606875@webmail.strato.com>
In-Reply-To: <20220221225935.12300-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20220221225935.12300-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: Re: [PATCH] can: rcar_canfd: Register the CAN device when fully
 ready
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.5-Rev38
X-Originating-Client: open-xchange-appsuite
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 02/21/2022 11:59 PM Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> 
>  
> Register the CAN device only when all the necessary initialization
> is completed. This patch makes sure all the data structures and locks are
> initialized before registering the CAN device.
> 
> Reported-by: Pavel Machek <pavel@denx.de>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  drivers/net/can/rcar/rcar_canfd.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
> index 3ad3a6f6a1dd..8c378b20b2aa 100644
> --- a/drivers/net/can/rcar/rcar_canfd.c
> +++ b/drivers/net/can/rcar/rcar_canfd.c
> @@ -1783,15 +1783,15 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
>  
>  	netif_napi_add(ndev, &priv->napi, rcar_canfd_rx_poll,
>  		       RCANFD_NAPI_WEIGHT);
> +	spin_lock_init(&priv->tx_lock);
> +	devm_can_led_init(ndev);
> +	gpriv->ch[priv->channel] = priv;
>  	err = register_candev(ndev);
>  	if (err) {
>  		dev_err(&pdev->dev,
>  			"register_candev() failed, error %d\n", err);
>  		goto fail_candev;
>  	}
> -	spin_lock_init(&priv->tx_lock);
> -	devm_can_led_init(ndev);
> -	gpriv->ch[priv->channel] = priv;
>  	dev_info(&pdev->dev, "device registered (channel %u)\n", priv->channel);
>  	return 0;
>  
> -- 
> 2.17.1

Reviewed-by: Ulrich Hecht <uli+renesas@fpond.eu>

CU
Uli
