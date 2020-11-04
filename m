Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17FE92A6776
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 16:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730750AbgKDPVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 10:21:54 -0500
Received: from mout01.posteo.de ([185.67.36.65]:49901 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730751AbgKDPVx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 10:21:53 -0500
Received: from submission (posteo.de [89.146.220.130]) 
        by mout01.posteo.de (Postfix) with ESMTPS id BDC7C160061
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 16:21:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1604503310; bh=YyoGNxPEtZTBMBKDNxVmymxRbElJ86keMPNynE37mMI=;
        h=Subject:To:Cc:From:Date:From;
        b=TEjSl4C23DLeqH0ZH7lgrDfKiVnkkPvJab+b5C/wGr57ZbixEcb7iDhqpsrf4v49w
         RPAhHMWNyx5W8P1YyQpj7CiCJ4t1E0WE+DaV/ZiU7527SvY40f+Tr6uAlXO5maCN7E
         5qN25/tAKCYoXBdCHt1QnZH6qFmctoU6kwC9b6/5JJFvHCBZq0mJdlFEjSdj6i3OtN
         zjDh1kzJkJFaVYLcDYeXn8ukMwhfvxXxDPlV+qgXzLWbDxsscLpEX6AfWN5FzEmE4G
         ToRg5Atysm3xj5bIEbBlczNUc2J8bz+49nFbkKTOKsIoSwt73UB0v07VOqhmVSyuQK
         ar232FFxBqigQ==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4CR9Nq4GlJz9rxq;
        Wed,  4 Nov 2020 16:21:47 +0100 (CET)
Subject: Re: [PATCH 1/2] rsi: Move card interrupt handling to RX thread
To:     Marek Vasut <marex@denx.de>, linux-wireless@vger.kernel.org
Cc:     Angus Ainslie <angus@akkea.ca>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
References: <20201103180941.443528-1-marex@denx.de>
From:   Martin Kepplinger <martink@posteo.de>
Message-ID: <e7e5ad92-de6b-1bd5-18e0-728b8ea454c4@posteo.de>
Date:   Wed, 4 Nov 2020 16:21:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201103180941.443528-1-marex@denx.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.11.20 19:09, Marek Vasut wrote:
> The interrupt handling of the RS911x is particularly heavy. For each RX
> packet, the card does three SDIO transactions, one to read interrupt
> status register, one to RX buffer length, one to read the RX packet(s).
> This translates to ~330 uS per one cycle of interrupt handler. In case
> there is more incoming traffic, this will be more.
> 
> The drivers/mmc/core/sdio_irq.c has the following comment, quote "Just
> like traditional hard IRQ handlers, we expect SDIO IRQ handlers to be
> quick and to the point, so that the holding of the host lock does not
> cover too much work that doesn't require that lock to be held."
> 
> The RS911x interrupt handler does not fit that. This patch therefore
> changes it such that the entire IRQ handler is moved to the RX thread
> instead, and the interrupt handler only wakes the RX thread.
> 
> This is OK, because the interrupt handler only does things which can
> also be done in the RX thread, that is, it checks for firmware loading
> error(s), it checks buffer status, it checks whether a packet arrived
> and if so, reads out the packet and passes it to network stack.
> 
> Moreover, this change permits removal of a code which allocated an
> skbuff only to get 4-byte-aligned buffer, read up to 8kiB of data
> into the skbuff, queue this skbuff into local private queue, then in
> RX thread, this buffer is dequeued, the data in the skbuff as passed
> to the RSI driver core, and the skbuff is deallocated. All this is
> replaced by directly calling the RSI driver core with local buffer.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Angus Ainslie <angus@akkea.ca>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Martin Kepplinger <martink@posteo.de>
> Cc: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
> Cc: Siva Rebbagondla <siva8118@gmail.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> ---
>   drivers/net/wireless/rsi/rsi_91x_sdio.c     |  6 +--
>   drivers/net/wireless/rsi/rsi_91x_sdio_ops.c | 52 ++++++---------------
>   drivers/net/wireless/rsi/rsi_sdio.h         |  8 +---
>   3 files changed, 15 insertions(+), 51 deletions(-)


hi Marek,

I'm running this without problems, so feel free to add

Tested-by: Martin Kepplinger <martin.kepplinger@puri.sm>

to both of your changes. thanks a lot,

                            martin
