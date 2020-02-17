Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBEF0160E53
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 10:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgBQJUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 04:20:09 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:50513 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728272AbgBQJUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 04:20:09 -0500
X-Originating-IP: 90.65.102.129
Received: from localhost (lfbn-lyo-1-1670-129.w90-65.abo.wanadoo.fr [90.65.102.129])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id BAC8320005;
        Mon, 17 Feb 2020 09:20:06 +0000 (UTC)
Date:   Mon, 17 Feb 2020 10:20:06 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     UNGLinuxDriver@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mscc: fix in frame extraction
Message-ID: <20200217092006.GA3634@piout.net>
References: <20200217083133.20828-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217083133.20828-1-horatiu.vultur@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/02/2020 09:31:33+0100, Horatiu Vultur wrote:
> Each extracted frame on Ocelot has an IFH. The frame and IFH are extracted
> by reading chuncks of 4 bytes from a register.
> 
> In case the IFH and frames were read corretly it would try to read the next
> frame. In case there are no more frames in the queue, it checks if there
> were any previous errors and in that case clear the queue. But this check
> will always succeed also when there are no errors. Because when extracting
> the IFH the error is checked against 4(number of bytes read) and then the
> error is set only if the extraction of the frame failed. So in a happy case
> where there are no errors the err variable is still 4. So it could be
> a case where after the check that there are no more frames in the queue, a
> frame will arrive in the queue but because the error is not reseted, it
> would try to flush the queue. So the frame will be lost.
> 
> The fix consist in resetting the error after reading the IFH.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
>  drivers/net/ethernet/mscc/ocelot_board.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
> index b38820849faa..1135a18019c7 100644
> --- a/drivers/net/ethernet/mscc/ocelot_board.c
> +++ b/drivers/net/ethernet/mscc/ocelot_board.c
> @@ -114,6 +114,14 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
>  		if (err != 4)
>  			break;
>  
> +		/* At this point the IFH was read correctly, so it is safe to
> +		 * presume that there is no error. The err needs to be reset
> +		 * otherwise a frame could come in CPU queue between the while
> +		 * condition and the check for error later on. And in that case
> +		 * the new frame is just removed and not processed.
> +		 */
> +		err = 0;
> +
>  		ocelot_parse_ifh(ifh, &info);
>  
>  		ocelot_port = ocelot->ports[info.port];
> -- 
> 2.17.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
