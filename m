Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90A0E3166C
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 23:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbfEaVKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 17:10:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46424 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726676AbfEaVKr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 17:10:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GaQCzB0wZgr4EV7KlO1Sm7eUbwlLBvCSgorIdOKC9Ic=; b=pTB+0gsq7hbKgb0so1oxtsW2Ol
        YJCFbIWalxM1+o4JQa7iILYFsFTv9GXwUFzs0bSQzrAYK433uOuRfA+rSGkdoCeykO/LCkHQzc2Jm
        5LpTRd67ajUnsEmAn0drqnh/bFSwFQEqkJOTMLGe98STMHyCuJoG9JCA1UYGjuM7s+NA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hWonT-0001TU-HE; Fri, 31 May 2019 23:10:43 +0200
Date:   Fri, 31 May 2019 23:10:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org, anirudh@xilinx.com, John.Linn@xilinx.com
Subject: Re: [PATCH net-next 01/13] net: axienet: Fixed 64-bit compile,
 enable build on X86 and ARM
Message-ID: <20190531211043.GD3154@lunn.ch>
References: <1559326545-28825-1-git-send-email-hancock@sedsystems.ca>
 <1559326545-28825-2-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559326545-28825-2-git-send-email-hancock@sedsystems.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Robert

I think you can split this into three patches, in order to make it
easier to review:

IO accessors
skb in the control block
MDIO changes.

>  static inline u32 axienet_ior(struct axienet_local *lp, off_t offset)
>  {
> -	return in_be32(lp->regs + offset);
> +#ifdef CONFIG_MICROBLAZE
> +	return __raw_readl(lp->regs + offset);
> +#else
> +	return ioread32(lp->regs + offset);
> +#endif
>  }

Please dig deeper into the available accessor functions. There should
be a set which works without this #defery. 

   Andrew
