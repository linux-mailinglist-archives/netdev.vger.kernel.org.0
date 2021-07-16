Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000603CBB0E
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 19:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhGPRYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 13:24:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231195AbhGPRXw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 13:23:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BBB4613F6;
        Fri, 16 Jul 2021 17:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626456054;
        bh=N5GhpdYtkMLYCoImrlzc1ma0sto2kRkmBuZwOljwAOI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AoH/UlbGrD9OromDziDnSXri7ny7u60h2seb3RvxcSqqzpUVrXTuB9ym3nLtZFk3U
         wLYJurnEJHu3gW6DwEYyLGuL0FCcMdk6Y2d9fa+WkiV8zRiuZJbIaPn/bmW+JoxHcB
         6N3YcaGa/RDsS/NGdRoi7l3ihsviBy53XgfkotdQ=
Date:   Fri, 16 Jul 2021 19:20:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Len Baker <len.baker@gmx.com>
Cc:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Brian Norris <briannorris@chromium.org>,
        Pkshih <pkshih@realtek.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] rtw88: Fix out-of-bounds write
Message-ID: <YPG/8F7yYLm3vAlG@kroah.com>
References: <20210716155311.5570-1-len.baker@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716155311.5570-1-len.baker@gmx.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 16, 2021 at 05:53:11PM +0200, Len Baker wrote:
> In the rtw_pci_init_rx_ring function the "if (len > TRX_BD_IDX_MASK)"
> statement guarantees that len is less than or equal to GENMASK(11, 0) or
> in other words that len is less than or equal to 4095. However the
> rx_ring->buf has a size of RTK_MAX_RX_DESC_NUM (defined as 512). This
> way it is possible an out-of-bounds write in the for statement due to
> the i variable can exceed the rx_ring->buff size.
> 
> However, this overflow never happens due to the rtw_pci_init_rx_ring is
> only ever called with a fixed constant of RTK_MAX_RX_DESC_NUM. But it is
> better to be defensive in this case and add a new check to avoid
> overflows if this function is called in a future with a value greater
> than 512.

If this can never happen, then no, this is not needed.  Why would you
check twice for the same thing?

thanks,

greg k-h
