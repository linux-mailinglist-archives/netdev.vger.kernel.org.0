Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7322B318B2E
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 13:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbhBKMul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 07:50:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231547AbhBKMsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 07:48:09 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 883BFC061574;
        Thu, 11 Feb 2021 04:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jNdqb4nPe0+4Tf1BWon1fj66dn5Zihb+9hnrzoLJEcg=; b=u9lE/RkIgqS1E4pK0wd/xVqNe
        V6OxKFqjaTwRrqyyAj3totCFfnHNrHJe06L7siydeS2uTLfp8sJWxlUheOkaK8TT/LcVLfkEoiLbT
        S2jH0qBAYz/SGzK9wMKm/pK0A+wZYdVuSz6YlcJwQDQf2N0aCJprF0rNzdUWdTxnPzKYZdNhS2SVq
        C5Mc2FqfqTmxtZOqYlsEk/grnyol/6sDwLLk3IZ2unnfKSpTA5KVsRFkjBxYQQenc9BB/fEOK31cB
        jdL/GgHvCsGHwIO27wy/9+5NyN+kBu/jKJSLCgtx62L8J4dy++EKbdX6pLdTE89sd72VVS3nmGFUA
        7MFfkpG0w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42028)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lABNT-00069X-IB; Thu, 11 Feb 2021 12:47:23 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lABNP-00066C-TH; Thu, 11 Feb 2021 12:47:19 +0000
Date:   Thu, 11 Feb 2021 12:47:19 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch, atenart@kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, sebastian.hesselbarth@gmail.com,
        gregory.clement@bootlin.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v13 net-next 07/15] net: mvpp2: add FCA periodic timer
 configurations
Message-ID: <20210211124719.GE1463@shell.armlinux.org.uk>
References: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
 <1613040542-16500-8-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1613040542-16500-8-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 12:48:54PM +0200, stefanc@marvell.com wrote:
> @@ -751,6 +760,10 @@
>  #define MVPP2_TX_FIFO_THRESHOLD(kb)	\
>  		((kb) * 1024 - MVPP2_TX_FIFO_THRESHOLD_MIN)
>  
> +/* MSS Flow control */
> +#define FC_QUANTA		0xFFFF
> +#define FC_CLK_DIVIDER		100

You later change the number of tabs for these definitions in a later
patch. Would it be better to start having the correct number of tabs?

> +
>  /* RX buffer constants */
>  #define MVPP2_SKB_SHINFO_SIZE \
>  	SKB_DATA_ALIGN(sizeof(struct skb_shared_info))
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index 5730900..761f745 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -1280,6 +1280,49 @@ static void mvpp22_gop_init_10gkr(struct mvpp2_port *port)
>  	writel(val, mpcs + MVPP22_MPCS_CLK_RESET);
>  }
>  
> +static void mvpp22_gop_fca_enable_periodic(struct mvpp2_port *port, bool en)
> +{
> +	struct mvpp2 *priv = port->priv;
> +	void __iomem *fca = priv->iface_base + MVPP22_FCA_BASE(port->gop_id);
> +	u32 val;

net likes to have reverse christmas tree variables. I think you should
clean this up. However...

> +
> +	val = readl(fca + MVPP22_FCA_CONTROL_REG);
> +	val &= ~MVPP22_FCA_ENABLE_PERIODIC;
> +	if (en)
> +		val |= MVPP22_FCA_ENABLE_PERIODIC;
> +	writel(val, fca + MVPP22_FCA_CONTROL_REG);

	if (en)
		val = MVPP22_FCA_ENABLE_PERIODIC;
	else
		val = 0;

	mvpp2_modify(priv->iface_base + MVPP22_FCA_BASE(port->gop_id) +
		     MVPP22_FCA_CONTROL_REG, MVPP22_FCA_ENABLE_PERIODIC, val);

avoids the need for "fca".

> +}
> +
> +static void mvpp22_gop_fca_set_timer(struct mvpp2_port *port, u32 timer)
> +{
> +	struct mvpp2 *priv = port->priv;
> +	void __iomem *fca = priv->iface_base + MVPP22_FCA_BASE(port->gop_id);
> +	u32 lsb, msb;

Same reverse christmas tree issue here.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
