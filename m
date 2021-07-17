Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE703CC4E4
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 19:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbhGQRgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 13:36:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232828AbhGQRgy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Jul 2021 13:36:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2761360FE9;
        Sat, 17 Jul 2021 17:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626543236;
        bh=GDqTCOO4uFGwemmRAEP2WS2n7BZO4bDcvurji9/tB1g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lBbpu4nsV39zDRohQAu43Y327W1pCIkBvQrXND3O1vZP3qSqvDY+SOe5O+rOxL1tn
         3wvZK+CjfK8Hg5EShc+7YSXxgSHT8qFPXAXs6wD/0El/TMcpcx9ZMil5go+I9AKXk6
         dQKb9NBQ2MWsHcjBchVILzoX3mE7Q0oYVfWfSUcc=
Date:   Sat, 17 Jul 2021 19:33:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Len Baker <len.baker@gmx.com>
Cc:     Brian Norris <briannorris@chromium.org>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Pkshih <pkshih@realtek.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] rtw88: Fix out-of-bounds write
Message-ID: <YPMUfbDh3jnV8hRZ@kroah.com>
References: <20210716155311.5570-1-len.baker@gmx.com>
 <YPG/8F7yYLm3vAlG@kroah.com>
 <20210717133343.GA2009@titan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210717133343.GA2009@titan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 17, 2021 at 03:33:43PM +0200, Len Baker wrote:
> On Fri, Jul 16, 2021 at 07:20:48PM +0200, Greg KH wrote:
> > On Fri, Jul 16, 2021 at 05:53:11PM +0200, Len Baker wrote:
> > > In the rtw_pci_init_rx_ring function the "if (len > TRX_BD_IDX_MASK)"
> > > statement guarantees that len is less than or equal to GENMASK(11, 0) or
> > > in other words that len is less than or equal to 4095. However the
> > > rx_ring->buf has a size of RTK_MAX_RX_DESC_NUM (defined as 512). This
> > > way it is possible an out-of-bounds write in the for statement due to
> > > the i variable can exceed the rx_ring->buff size.
> > >
> > > However, this overflow never happens due to the rtw_pci_init_rx_ring is
> > > only ever called with a fixed constant of RTK_MAX_RX_DESC_NUM. But it is
> > > better to be defensive in this case and add a new check to avoid
> > > overflows if this function is called in a future with a value greater
> > > than 512.
> >
> > If this can never happen, then no, this is not needed.
> 
> Then, if this can never happen, the current check would not be necessary
> either.
> 
> > Why would you check twice for the same thing?
> 
> Ok, it makes no sense to double check the "len" variable twice. So, I
> propose to modify the current check as follows:
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
> index e7d17ab8f113..0fd140523868 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.c
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -268,8 +268,8 @@ static int rtw_pci_init_rx_ring(struct rtw_dev *rtwdev,
>         int i, allocated;
>         int ret = 0;
> 
> -       if (len > TRX_BD_IDX_MASK) {
> -               rtw_err(rtwdev, "len %d exceeds maximum RX entries\n", len);
> +       if (len > ARRAY_SIZE(rx_ring->buf)) {
> +               rtw_err(rtwdev, "len %d exceeds maximum RX ring buffer\n", len);
>                 return -EINVAL;
>         }
> 
> This way the overflow can never happen with the current call to
> rtw_pci_init_rx_ring function or with a future call with a "len" parameter
> greater than 512. What do you think?
> 
> If there are no objections I will send a v3 for review.
> 
> Another question: If this can never happen should I include the "Fixes" tag,
> "Addresses-Coverity-ID" tag and Cc to stable?

If it can never happen, why have this check at all?

Looks like a Coverity false positive?

thanks,

greg k-h
