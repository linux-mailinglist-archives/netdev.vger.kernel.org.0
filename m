Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A485A47A7F2
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 11:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhLTKuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 05:50:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhLTKuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 05:50:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED269C061574;
        Mon, 20 Dec 2021 02:50:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8ABA960F53;
        Mon, 20 Dec 2021 10:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF06C36AE7;
        Mon, 20 Dec 2021 10:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639997409;
        bh=xcXQPeTYEbRu0CQ1CuO5y0pKV/Zw9ra0nuKXxojfBGA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a8LZO9G+kd4dFkRyPgUulLMLXwwFIE3gM1ZZAEFA3rWYIcKkPuJgMbJ13gQdpF9ej
         mAeXwjTiX9uK1g0E7qsS4+Lv2nS5uYLxHUWCaVhSaOERxbKH6naPrjRiYLlwgsF2sF
         auSSbe0xGQa+OBapfBPDp/Gw66qadUCdrD5a1MV0=
Date:   Mon, 20 Dec 2021 11:50:06 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH stable 4.19] net: systemport: Add global locking for
 descriptor lifecycle
Message-ID: <YcBf3gvBBscdNVLm@kroah.com>
References: <20211219024925.18936-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211219024925.18936-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 18, 2021 at 06:49:25PM -0800, Florian Fainelli wrote:
> commit 8b8e6e782456f1ce02a7ae914bbd5b1053f0b034 upstream
> 
> The descriptor list is a shared resource across all of the transmit queues, and
> the locking mechanism used today only protects concurrency across a given
> transmit queue between the transmit and reclaiming. This creates an opportunity
> for the SYSTEMPORT hardware to work on corrupted descriptors if we have
> multiple producers at once which is the case when using multiple transmit
> queues.
> 
> This was particularly noticeable when using multiple flows/transmit queues and
> it showed up in interesting ways in that UDP packets would get a correct UDP
> header checksum being calculated over an incorrect packet length. Similarly TCP
> packets would get an equally correct checksum computed by the hardware over an
> incorrect packet length.
> 
> The SYSTEMPORT hardware maintains an internal descriptor list that it re-arranges
> when the driver produces a new descriptor anytime it writes to the
> WRITE_PORT_{HI,LO} registers, there is however some delay in the hardware to
> re-organize its descriptors and it is possible that concurrent TX queues
> eventually break this internal allocation scheme to the point where the
> length/status part of the descriptor gets used for an incorrect data buffer.
> 
> The fix is to impose a global serialization for all TX queues in the short
> section where we are writing to the WRITE_PORT_{HI,LO} registers which solves
> the corruption even with multiple concurrent TX queues being used.
> 
> Fixes: 80105befdb4b ("net: systemport: add Broadcom SYSTEMPORT Ethernet MAC driver")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> Link: https://lore.kernel.org/r/20211215202450.4086240-1-f.fainelli@gmail.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/ethernet/broadcom/bcmsysport.c | 5 +++++
>  drivers/net/ethernet/broadcom/bcmsysport.h | 1 +
>  2 files changed, 6 insertions(+)

All now queued up, thanks.

greg k-h
