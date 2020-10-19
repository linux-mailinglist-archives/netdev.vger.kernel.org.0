Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A9F2931F1
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 01:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388995AbgJSX0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 19:26:46 -0400
Received: from kernel.crashing.org ([76.164.61.194]:42628 "EHLO
        kernel.crashing.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729385AbgJSX0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 19:26:46 -0400
Received: from localhost (gate.crashing.org [63.228.1.57])
        (authenticated bits=0)
        by kernel.crashing.org (8.14.7/8.14.7) with ESMTP id 09JNQHHe024378
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 19 Oct 2020 18:26:20 -0500
Message-ID: <fee066de5355c015da4e30957a1d8b8b5da1ef4d.camel@kernel.crashing.org>
Subject: Re: [PATCH 4/4] ftgmac100: Restart MAC HW once
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Dylan Hung <dylan_hung@aspeedtech.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ratbert@faraday-tech.com,
        linux-aspeed@lists.ozlabs.org, openbmc@lists.ozlabs.org
Cc:     BMC-SW@aspeedtech.com, Joel Stanley <joel@jms.id.au>
Date:   Tue, 20 Oct 2020 10:26:17 +1100
In-Reply-To: <20201019085717.32413-5-dylan_hung@aspeedtech.com>
References: <20201019085717.32413-1-dylan_hung@aspeedtech.com>
         <20201019085717.32413-5-dylan_hung@aspeedtech.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-10-19 at 16:57 +0800, Dylan Hung wrote:
> The interrupt handler may set the flag to reset the mac in the
> future,
> but that flag is not cleared once the reset has occured.
> 
> Fixes: 10cbd6407609 ("ftgmac100: Rework NAPI & interrupts handling")
> Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
> Signed-off-by: Joel Stanley <joel@jms.id.au>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> ---
>  drivers/net/ethernet/faraday/ftgmac100.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c
> b/drivers/net/ethernet/faraday/ftgmac100.c
> index 0c67fc3e27df..57736b049de3 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.c
> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> @@ -1326,6 +1326,7 @@ static int ftgmac100_poll(struct napi_struct
> *napi, int budget)
>  	 */
>  	if (unlikely(priv->need_mac_restart)) {
>  		ftgmac100_start_hw(priv);
> +		priv->need_mac_restart = false;
>  
>  		/* Re-enable "bad" interrupts */
>  		ftgmac100_write(FTGMAC100_INT_BAD, priv->base +
> FTGMAC100_OFFSET_IER);

