Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717772CF8DD
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 02:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727622AbgLEB61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 20:58:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:58776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725300AbgLEB61 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 20:58:27 -0500
Date:   Fri, 4 Dec 2020 17:57:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607133466;
        bh=oQNxjll2KncKGYxiDzOZF57W2uvqk23uXAjjQ78k7sU=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=sS3EAepcHZkOIJKQZ6zgG3SkJUt2erW3pgeH/Kbmp9Ze4ODDMq1e4IvgzcgNSoZDu
         sw0J9goTQ5QMgRoZv5vylKlQpPSLHu9YRibGLW/Ybv7X7/K5J2zZ0oEqRjDYt5cgW0
         gcR99pnl8OrSIwVI3vtWe819thvCVujL6vixXbWecL+i2iSmZdxSWL5zGOdXnMMDMq
         9chxIIA5rUBAa0nhpYhx14TB2jw9uPDggyhx4ndKSjFynOWickUXCGHZTW3NYJ434D
         y+4vPBY/oj7lgSRJwPHZqKjZYRq7TlUR5mzyxQnnjiWv1nVbvTicerinnmUUiQSQwh
         3mqcMCPmzClKA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        YueHaibing <yuehaibing@huawei.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] ch_ktls: fix build warning for ipv4-only config
Message-ID: <20201204175745.1cd433f7@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201203222641.964234-1-arnd@kernel.org>
References: <20201203222641.964234-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Dec 2020 23:26:16 +0100 Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When CONFIG_IPV6 is disabled, clang complains that a variable
> is uninitialized for non-IPv4 data:
> 
> drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c:1046:6: error: variable 'cntrl1' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>         if (tx_info->ip_family == AF_INET) {
>             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c:1059:2: note: uninitialized use occurs here
>         cntrl1 |= T6_TXPKT_ETHHDR_LEN_V(maclen - ETH_HLEN) |
>         ^~~~~~
> 
> Replace the preprocessor conditional with the corresponding C version,
> and make the ipv4 case unconditional in this configuration to improve
> readability and avoid the warning.
> 
> Fixes: 86716b51d14f ("ch_ktls: Update cheksum information")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

This is for evrey clang build or just W=1+? Would be annoying if clang
produced this on every build with 5.10 (we need to decide fix vs -next).
