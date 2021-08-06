Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273D93E2C7F
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 16:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239174AbhHFO3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 10:29:44 -0400
Received: from mslow1.mail.gandi.net ([217.70.178.240]:32991 "EHLO
        mslow1.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbhHFO3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 10:29:43 -0400
Received: from relay9-d.mail.gandi.net (unknown [217.70.183.199])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id C03ECC9857;
        Fri,  6 Aug 2021 14:23:05 +0000 (UTC)
Received: (Authenticated sender: thomas.petazzoni@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id AADA6FF80D;
        Fri,  6 Aug 2021 14:22:43 +0000 (UTC)
Date:   Fri, 6 Aug 2021 16:22:42 +0200
From:   Thomas Petazzoni <thomas.petazzoni@bootlin.com>
To:     Maksim <bigunclemax@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: marvell: fix MVNETA_TX_IN_PRGRS bit number
Message-ID: <20210806162242.44a60c59@windsurf>
In-Reply-To: <20210806140437.4016159-1-bigunclemax@gmail.com>
References: <20210806140437.4016159-1-bigunclemax@gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri,  6 Aug 2021 17:04:37 +0300
Maksim <bigunclemax@gmail.com> wrote:

> According to Armada XP datasheet bit at 0 position is corresponding for
> TxInProg indication.
> 
> Signed-off-by: Maksim <bigunclemax@gmail.com>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index 76a7777c746da..de32e5b49053b 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -105,7 +105,7 @@
>  #define	MVNETA_VLAN_PRIO_TO_RXQ			 0x2440
>  #define      MVNETA_VLAN_PRIO_RXQ_MAP(prio, rxq) ((rxq) << ((prio) * 3))
>  #define MVNETA_PORT_STATUS                       0x2444
> -#define      MVNETA_TX_IN_PRGRS                  BIT(1)
> +#define      MVNETA_TX_IN_PRGRS                  BIT(0)
>  #define      MVNETA_TX_FIFO_EMPTY                BIT(8)
>  #define MVNETA_RX_MIN_FRAME_SIZE                 0x247c
>  /* Only exists on Armada XP and Armada 370 */

Indeed, I just checked the datasheet, and it's bit 0 in this register
that indicates if transmit is in progress. The only function using this
is mvneta_port_down(), which polls until MVNETA_TX_FIFO_EMPTY is set
and MVNETA_TX_IN_PRGRS is cleared in this register. Bit 1 in this
register is marked as reserved, read-only and read as zero, so I
suppose that mvneta_port_down() was basically never waiting for
MVNETA_TX_IN_PRGRS to clear.

Have you seen some actual visible issue, or was this just found by code
inspection ?

Best regards,

Thomas
-- 
Thomas Petazzoni, co-owner and CEO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
