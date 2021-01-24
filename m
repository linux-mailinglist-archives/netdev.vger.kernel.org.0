Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94496301BE9
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 13:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbhAXMp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 07:45:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbhAXMp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 07:45:26 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11134C061573;
        Sun, 24 Jan 2021 04:44:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=OUUmvGFFed3VF14x9AJZnsLh0I+LDXrMD5jb+zPJRz0=; b=xq+pQ4eIJ1iYDiD4QywJhngTn
        T2FNSpaJ4jvc98MGhfEgtvw0f3aAqWPntU5wzIdHmupUppykY8mNGANNza3Z8+WT/xlFZz9Wrl8Hw
        uEBMGhiBZXm+5WERwbBttfo0Fecb06i/x8isYs3U+f1ogv/ihB0wOr4A8m9D02k2Sr+TI5jpz2G/c
        upQ77klFMnz+xg2xueFsUrcXU+tjzgBeIHXmfFBZfN3rgpiB7+OinnbLtzIzx4D91DV7kr2B4JPyH
        CRhfS27wU9vrJkeUupaDikzdP7dU4egFSco9GmwLiUdiU8KIvs1jnAtL+AdIzl/DGAeIghp7PLCAA
        fnid3ilkA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52112)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l3el2-0002Ns-5z; Sun, 24 Jan 2021 12:44:44 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l3el1-0001iZ-DV; Sun, 24 Jan 2021 12:44:43 +0000
Date:   Sun, 24 Jan 2021 12:44:43 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch, atenart@kernel.org
Subject: Re: [PATCH v2 RFC net-next 03/18] net: mvpp2: add CM3 SRAM memory map
Message-ID: <20210124124443.GX1551@shell.armlinux.org.uk>
References: <1611488647-12478-1-git-send-email-stefanc@marvell.com>
 <1611488647-12478-4-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611488647-12478-4-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 24, 2021 at 01:43:52PM +0200, stefanc@marvell.com wrote:
> +		priv->sram_pool = of_gen_pool_get(dn, "cm3-mem", 0);
> +		if (!priv->sram_pool) {
> +			if (!defer_once) {
> +				defer_once = true;
> +				/* Try defer once */
> +				return -EPROBE_DEFER;
> +			}
> +			dev_warn(&pdev->dev, "DT is too old, Flow control not supported\n");
> +			return -ENOMEM;
> +		}
> +		priv->cm3_base = (void __iomem *)gen_pool_alloc(priv->sram_pool,
> +								MSS_SRAM_SIZE);
> +		if (!priv->cm3_base)
> +			return -ENOMEM;

This probably could do with a comment indicating that it is reliant on
this allocation happening at offset zero into the SRAM. The only reason
that is guaranteed _at the moment_ is because the SRAM mapping is 0x800
bytes in size, and you are requesting 0x800 bytes in this allocation,
so allocating the full size.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
