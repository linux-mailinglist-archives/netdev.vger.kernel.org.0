Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59BC941950D
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 15:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234425AbhI0N2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 09:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234058AbhI0N2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 09:28:11 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE0BC061575;
        Mon, 27 Sep 2021 06:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=D69+WMYjsBza4pCHXiDUwD0y0AQnmhzf6CDyMOe/EuU=; b=ikyBuHzwSU4yHkTXEHatgY0pCC
        D5KLVQhHXayUMSj5wV+7RwDYy1+H5DALN1ZCI5xMUjd0wMfjEapDwmXWXNlLv3RKP1XojtQtcQ3Xb
        CxOPoSKq7GFCdK3iuMsGzCpSgtg+qj8g2sQxGwH9OyQMyWnzRy0QDNNK+2rSiNmuI3cgkK//mdEls
        Y32ZTSJkShqGTQUtOAOjhQEpPLLwbywE0ql9Jwty2ID5sHS+HUYiEgUiCo3LmVOc/rUqwwb+W4o20
        8NSNIaD/vLJIIKFkdfyL+nLmdEE0yoTnqEk7tq+GZodm/0E5lK2A42yqn8rYodDNfZ6dohUj9KK4T
        1jBUGbQg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54812)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mUqe4-0008RG-2Z; Mon, 27 Sep 2021 14:26:12 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mUqdy-0000mU-U4; Mon, 27 Sep 2021 14:26:06 +0100
Date:   Mon, 27 Sep 2021 14:26:06 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND] net: stmmac: fix gcc-10 -Wrestrict warning
Message-ID: <YVHGblt9rYg7kbWR@shell.armlinux.org.uk>
References: <20210927100336.1334028-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210927100336.1334028-1-arnd@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 12:02:44PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> gcc-10 and later warn about a theoretical array overrun when
> accessing priv->int_name_rx_irq[i] with an out of bounds value
> of 'i':
> 
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c: In function 'stmmac_request_irq_multi_msi':
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:3528:17: error: 'snprintf' argument 4 may overlap destination object 'dev' [-Werror=restrict]
>  3528 |                 snprintf(int_name, int_name_len, "%s:%s-%d", dev->name, "tx", i);
>       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:3404:60: note: destination object referenced by 'restrict'-qualified argument 1 was declared here
>  3404 | static int stmmac_request_irq_multi_msi(struct net_device *dev)
>       |                                         ~~~~~~~~~~~~~~~~~~~^~~
> 
> The warning is a bit strange since it's not actually about the array
> bounds but rather about possible string operations with overlapping
> arguments, but it's not technically wrong.
> 
> Avoid the warning by adding an extra bounds check.
> 
> Fixes: 8532f613bc78 ("net: stmmac: introduce MSI Interrupt routines for mac, safety, RX & TX")
> Link: https://lore.kernel.org/all/20210421134743.3260921-1-arnd@kernel.org/
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 553c4403258a..640c0ffdff3d 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -3502,6 +3502,8 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
>  
>  	/* Request Rx MSI irq */
>  	for (i = 0; i < priv->plat->rx_queues_to_use; i++) {
> +		if (i > MTL_MAX_RX_QUEUES)
> +			break;
>  		if (priv->rx_irq[i] == 0)
>  			continue;

This looks rather weird. rx_irq[] is defined as:

        int rx_irq[MTL_MAX_RX_QUEUES];

If "i" were to become MTL_MAX_RX_QUEUES, then the above code overlows
the array.

So while this may stop gcc-10 complaining, I'd argue that making the
new test ">=" rather than ">" would have also made it look correct.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
