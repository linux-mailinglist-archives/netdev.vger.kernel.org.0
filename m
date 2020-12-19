Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475BA2DF0F7
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 19:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbgLSSOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 13:14:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:59220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725562AbgLSSOS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Dec 2020 13:14:18 -0500
Date:   Sat, 19 Dec 2020 10:13:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608401618;
        bh=ptVwJyI5H10k0583Y1hewpHYrQYSx7sniB/tuySg6Xo=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=jsZJg6srgtVdkNysI/WvNsSVYEXSY01PeP4QSFp84TzcUN5lMyaicO8Soqv5RKV3Z
         3IvDxP2lULd0o+M/cFxggb3qjInW6wnMNqkzXaCxir2Xst1B4BY5o+wnmjqcwObOdI
         KGBnql3XZD66SfYsmWt5ZUM+3fJfk0KUFN6tH6dWxLFFS957T0rA7r8AC4VNH8M3yL
         DvJQ46ObNBEvUSSfBNALV6YXHKTcB9b9Q94a4aloSifLzJPfP8cpotq74pQUWgp0QL
         BArmah3Vakl01H/0bYqJwIPGE4h9aw6o9H4YhNvOZq8BtewYTUWdmH/88UqP7fVq5G
         9dhECq1PLWIdA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     <stefanc@marvell.com>
Cc:     <netdev@vger.kernel.org>, <thomas.petazzoni@bootlin.com>,
        <davem@davemloft.net>, <nadavh@marvell.com>,
        <ymarkman@marvell.com>, <linux-kernel@vger.kernel.org>,
        <linux@armlinux.org.uk>, <mw@semihalf.com>, <andrew@lunn.ch>,
        <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH net v2] net: mvpp2: Add TCAM entry to drop flow control
 pause frames
Message-ID: <20201219101337.65e1795c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1608229817-21951-1-git-send-email-stefanc@marvell.com>
References: <1608229817-21951-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Dec 2020 20:30:17 +0200 stefanc@marvell.com wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> Issue:
> Flow control frame used to pause GoP(MAC) was delivered to the CPU
> and created a load on the CPU. Since XOFF/XON frames are used only
> by MAC, these frames should be dropped inside MAC.
> 
> Fix:
> According to 802.3-2012 - IEEE Standard for Ethernet pause frame
> has unique destination MAC address 01-80-C2-00-00-01.
> Add TCAM parser entry to track and drop pause frames by destination MAC.
> 
> Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>

Applied, thanks..

> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
> index 1a272c2..3a9c747 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
> @@ -405,6 +405,39 @@ static int mvpp2_prs_tcam_first_free(struct mvpp2 *priv, unsigned char start,
>  	return -EINVAL;
>  }
>  
> +/* Drop flow control pause frames */
> +static void mvpp2_prs_drop_fc(struct mvpp2 *priv)
> +{
> +	struct mvpp2_prs_entry pe;
> +	unsigned int len;
> +	unsigned char da[ETH_ALEN] = {
> +			0x01, 0x80, 0xC2, 0x00, 0x00, 0x01 };

but I reordered these so they follow the reverse xmas tree ordering
netdev prefers.
