Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45DC42A748E
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 02:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731503AbgKEBIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 20:08:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:56258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730429AbgKEBIo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 20:08:44 -0500
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1082020867;
        Thu,  5 Nov 2020 01:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604538523;
        bh=aRWqTIPOucR+ksCy/ppBnVEjQeq+0oyqh9swwVYac0s=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=ic65GV8OBZxav7N1MQ03JC77T9OQxrfNcU/RzMyHTymUL/rwN+s2tvlH2KIyGP/Zg
         SERqlEx/Al9UXpBI65ZJMty1r8I3IvGXmrxBlPtQSB/FiIh+u8sUyu73omQ2CxZX8L
         SyyZDG3ZWs6XDfEaP8YMMDNKBC9V1JeTjBgLeRtQ=
Message-ID: <f0e95c596be3ebcaf862486af4977a1fb00e8896.camel@kernel.org>
Subject: Re: [PATCH net-next 4/6] ionic: batch rx buffer refilling
From:   Saeed Mahameed <saeed@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Date:   Wed, 04 Nov 2020 17:08:42 -0800
In-Reply-To: <20201104223354.63856-5-snelson@pensando.io>
References: <20201104223354.63856-1-snelson@pensando.io>
         <20201104223354.63856-5-snelson@pensando.io>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-11-04 at 14:33 -0800, Shannon Nelson wrote:
> We don't need to refill the rx descriptors on every napi
> if only a few were handled.  Waiting until we can batch up
> a few together will save us a few Rx cycles.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  .../net/ethernet/pensando/ionic/ionic_dev.h    |  4 +++-
>  .../net/ethernet/pensando/ionic/ionic_txrx.c   | 18 ++++++++++----
> ----
>  2 files changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
> b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
> index 6c243b17312c..9064222a087a 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
> @@ -12,8 +12,10 @@
>  
>  #define IONIC_MAX_TX_DESC		8192
>  #define IONIC_MAX_RX_DESC		16384
> -#define IONIC_MIN_TXRX_DESC		16
> +#define IONIC_MIN_TXRX_DESC		64
>  #define IONIC_DEF_TXRX_DESC		4096
> +#define IONIC_RX_FILL_THRESHOLD		64

isn't 64 a bit high ? 64 is the default napi budget 

Many drivers do this with bulks of 8/16 but I couldn't find any with
higher numbers.

also, just for a reference, GRO and XDP they bulk up to 8. but not
more.

IMHO i think you need to relax the re-fill threshold a bit.

> +#define IONIC_RX_FILL_DIV		8
> 
...

> -	if (work_done)
> +	rx_fill_threshold = min_t(u16, IONIC_RX_FILL_THRESHOLD,
> +				  cq->num_descs / IONIC_RX_FILL_DIV);
> +	if (work_done && ionic_q_space_avail(cq->bound_q) >=
> rx_fill_threshold)
>  		ionic_rx_fill(cq->bound_q);
>  


