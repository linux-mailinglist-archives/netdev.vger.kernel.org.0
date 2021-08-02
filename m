Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8613DDBC1
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 17:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234598AbhHBPCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 11:02:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234338AbhHBPCP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 11:02:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7753610A2;
        Mon,  2 Aug 2021 15:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627916526;
        bh=Qr/vm1KlXY0XJtD6Yk5oe7cEh9i4wRwPY9w7iKhs77Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m47a2WC8to4THn9+xkwp9eiCDd3jEF8pwkJn3grtVyBS4ExxhsV329w3p2vbPBfIe
         l1VWGzcuIsSwyBeUzm1Wfg3fQPfBtn+A+koJ8euwmFnhwFgL4HlYhu2UJ1a6jQcQpT
         6WebTz/Nf/5FXa3tmCsydx/nMCuWf+Y/StCDHogj5hZBl+nZFCpwp2/BOGOi1GDWZq
         6Ox2SPEDtQ+8V4D2p7UZoLK1bry/DgUxyk/2S5mKCYrWTS6w+SyvlAj/+QuGfExe0D
         Fq1QrtPgo36i012VNBRs9WiDw0sK/eOeJ70FIVZocgAqZUWAWYEu0epylVThExwRXN
         OqC6gHJ//2Hnw==
Date:   Mon, 2 Aug 2021 08:02:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sparx5: fix bitmask check
Message-ID: <20210802080205.6a9f9bb1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210802145449.1154565-1-arnd@kernel.org>
References: <20210802145449.1154565-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  2 Aug 2021 16:54:37 +0200 Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Older compilers such as gcc-5.5 produce a warning in this driver
> when ifh_encode_bitfield() is not getting inlined:
> 
> drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c: In function 'ifh_encode_bitfield':
> include/linux/compiler_types.h:333:38: error: call to '__compiletime_assert_545' declared with attribute error: Unsupported width, must be <= 40
> drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c:28:2: note: in expansion of macro 'compiletime_assert'
>   compiletime_assert(width <= 40, "Unsupported width, must be <= 40");
>   ^
> 
> Mark the function as __always_inline to make the check work correctly
> on all compilers. 

I fixed this by moving the check out to a macro wrapper in net:
6387f65e2acb ("net: sparx5: fix compiletime_assert for GCC 4.9")

> To make this also work on 32-bit architectures, change
> the GENMASK() to GENMASK_ULL().

Would you mind resending just that part against net/master?

> Fixes: f3cad2611a77 ("net: sparx5: add hostmode with phylink support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
