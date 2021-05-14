Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455CF3813EF
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 00:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234095AbhENWxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 18:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbhENWxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 18:53:41 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED107C06174A;
        Fri, 14 May 2021 15:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xgSsfKWkA74e0iXAMwBxkWJB/DtTeegQWgf7EKPF2SU=; b=Sy+SUM4cfMuNPa9aN/X8S7cGM
        MPQs+haIZnGFUHksu//RCxpMISA9lmq7A6dtz4c9cvKubmw6YAYBS0VHhklpf8KQspJDeVtOcFn5+
        xSzSjSTEGdwOoH6iMNnUoZVf9HImUXCd9y612TTQGVfYJDhZRWupnOyt39pNiegoSUUN5TqffaKix
        S6GsZygOAb6ZQhpLnMAcV3zmvofxdYiNp5nn/LQQgPtNoFcx0ptKR4H1emIZT5iJs12XTmKd27bJ1
        fw67LdkX8VdUMk6iQDGS9MPAVSwGt27muDBfStLdxcBC9mE0YqqXKJOxMulelisERs/n/85QSUMNk
        E7wH92Dtg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43986)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lhgfR-0000Wu-Qf; Fri, 14 May 2021 23:52:25 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lhgfR-0004NM-Db; Fri, 14 May 2021 23:52:25 +0100
Date:   Fri, 14 May 2021 23:52:25 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 02/25] net: dsa: qca8k: use iopoll macro for
 qca8k_busy_wait
Message-ID: <20210514225225.GI12395@shell.armlinux.org.uk>
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
 <20210514210015.18142-3-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210514210015.18142-3-ansuelsmth@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 10:59:52PM +0200, Ansuel Smith wrote:
> Use iopoll macro instead of while loop.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

This doesn't look quite right to me.

>  static int
>  qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
>  {
> -	unsigned long timeout;
> -
> -	timeout = jiffies + msecs_to_jiffies(20);
> +	u32 val;

val is unsigned here.

> +	/* Check if qca8k_read has failed for a different reason
> +	 * before returning -ETIMEDOUT
> +	 */
> +	if (ret < 0 && val < 0)

but here you are checking it for a negative number - this will always be
false, making the conditional code unreachable. Either the test is wrong,
or the type of val is wrong. Please resolve.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
