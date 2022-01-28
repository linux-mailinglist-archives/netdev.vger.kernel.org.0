Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C184A03A5
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 23:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344651AbiA1W36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 17:29:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235188AbiA1W35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 17:29:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C45FC061714;
        Fri, 28 Jan 2022 14:29:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 166BA61EEF;
        Fri, 28 Jan 2022 22:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046FDC340E7;
        Fri, 28 Jan 2022 22:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643408996;
        bh=/0PcLhzM3o3gTPcTwW++SS6uCEned56O6MZTTXV0Kuk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SRpwUf0fs/Ep35ll5BhkOoDKUd0qzePeblFcn100koZFuBviowiqLMMMbvfzVAi+x
         mdPIvRC4X8gVNpeU5aeNYbiK+aBYD+K71/SuzPQvGKyNzCOEtlEm6heFazznoiYuRZ
         mFZb+ubE7OF1UFB2VMcS0O7wALN/ptxyoT1mLlNTMCjBxtP0HVKkoIax4Cu7nUPPBN
         i0A2PIJ4NREwA0DS6TJPhFXYZsU59UgSzZazMlnL3nYciZVqFz8JPLMikclmp38dUk
         KtNrJflFmwgCIo6yAsnaNTSrecmCKKvJdbWbDu3VcnSgE+macV9y2AOo3t7LQi523c
         SoiPEjrhSry/A==
Date:   Fri, 28 Jan 2022 14:29:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Camel Guo <camel.guo@axis.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>, <kernel@axis.com>,
        Camel Guo <camelg@axis.com>, <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: stmmac: dump gmac4 DMA registers correctly
Message-ID: <20220128142955.047bd9d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220128153642.3129922-1-camel.guo@axis.com>
References: <20220128153642.3129922-1-camel.guo@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jan 2022 16:36:42 +0100 Camel Guo wrote:
> From: Camel Guo <camelg@axis.com>
> 
> Unlike gmac100, gmac1000, gmac4 has 27 DMA registers and they are
> located at DMA_CHAN_BASE_ADDR (0x1100). In order for ethtool to dump
> gmac4 DMA registers correctly, this commit checks if a net_device has
> gmac4 and uses different logic to dump its DMA registers.
> 
> This fixes the following KASAN warning, which can normally be triggered
> by a command similar like "ethtool -d eth0":
> 
> BUG: KASAN: vmalloc-out-of-bounds in dwmac4_dump_dma_regs+0x6d4/0xb30
> Write of size 4 at addr ffffffc010177100 by task ethtool/1839
>  kasan_report+0x200/0x21c
>  __asan_report_store4_noabort+0x34/0x60
>  dwmac4_dump_dma_regs+0x6d4/0xb30
>  stmmac_ethtool_gregs+0x110/0x204
>  ethtool_get_regs+0x200/0x4b0
>  dev_ethtool+0x1dac/0x3800
>  dev_ioctl+0x7c0/0xb50
>  sock_ioctl+0x298/0x6c4
>  ...
> 
> Signed-off-by: Camel Guo <camelg@axis.com>

Can we get a Fixes tag for this? If it was always broken the Fixes tag
should point to the commit which added gmac4 support.
