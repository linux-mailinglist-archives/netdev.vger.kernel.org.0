Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEE6115E4A
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 20:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfLGTuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 14:50:39 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42728 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbfLGTui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 14:50:38 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DD65515413555;
        Sat,  7 Dec 2019 11:50:37 -0800 (PST)
Date:   Sat, 07 Dec 2019 11:50:34 -0800 (PST)
Message-Id: <20191207.115034.1743579700466281633.davem@davemloft.net>
To:     ivan.khoronzhuk@linaro.org
Cc:     grygorii.strashko@ti.com, netdev@vger.kernel.org, nsekhar@ti.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: ethernet: ti: davinci_cpdma: fix warning
 "device driver frees DMA memory with different size"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191207120238.GB2798@khorivan>
References: <0c6b88b2-31b1-11f0-7baa-1ecd5f4b6644@ti.com>
        <20191207114419.GA2798@khorivan>
        <20191207120238.GB2798@khorivan>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Dec 2019 11:50:38 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Date: Sat, 7 Dec 2019 14:02:39 +0200

> @@ -1046,7 +1045,6 @@ static int cpdma_chan_submit_si(struct
> submit_info *si)
>        if (si->data_dma) {
>                buffer = si->data_dma;
>                dma_sync_single_for_device(ctlr->dev, buffer, len, chan->dir);
> -               swlen |= CPDMA_DMA_EXT_MAP;
>        } else {
>                buffer = dma_map_single(ctlr->dev, si->data_virt, len, chan->dir);
>                ret = dma_mapping_error(ctlr->dev, buffer);
> @@ -1065,7 +1063,7 @@ static int cpdma_chan_submit_si(struct
> submit_info *si)
>        writel_relaxed(mode | len, &desc->hw_mode);
>        writel_relaxed((uintptr_t)si->token, &desc->sw_token);
>        writel_relaxed(buffer, &desc->sw_buffer);
> -       writel_relaxed(swlen, &desc->sw_len);
> + writel_relaxed(si->data_dma ? len | CPDMA_DMA_EXT_MAP : len,
> &desc->sw_len);
>        desc_read(desc, sw_len);
> 
>        __cpdma_chan_submit(chan, desc);
> 
> But it's branched twice then.

It's a conditional move rather than a branch....
