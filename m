Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1524899FA
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 14:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbiAJNbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 08:31:48 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58804 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbiAJNbs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 08:31:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ag4Nxvxok9wcDRwHNJeJRl3CvnWuIJVwteaFrvKqWVg=; b=Uyy+yAyFK/GKA5sOrbq7Lm1/tq
        0hbowu45PaorCDcMT6UdhQkSyfqa96OvLBffdHk2Aap4dfZh4VkEWr/xMrPxXtTn34tGCiSZHP8tY
        r2n7HhgU9MFH9t1GhYB9j3O4BVeobihzgKd3Px85FaZU+8uwTtK1NF9V6aEaRhSCqZu8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n6ulk-000zRb-HZ; Mon, 10 Jan 2022 14:31:28 +0100
Date:   Mon, 10 Jan 2022 14:31:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Conley Lee <conleylee@foxmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
        wens@csie.org, clabbe.montjoie@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: ethernet: sun4i-emac: replace magic number with
 macro
Message-ID: <Ydw1MOcmS6fZ6J8d@lunn.ch>
References: <tencent_58B12979F0BFDB1520949A6DB536ED15940A@qq.com>
 <tencent_AEEE0573A5455BBE4D5C05226C6C1E3AEF08@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_AEEE0573A5455BBE4D5C05226C6C1E3AEF08@qq.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -637,7 +637,9 @@ static void emac_rx(struct net_device *dev)
>  		if (!rxcount) {
>  			db->emacrx_completed_flag = 1;
>  			reg_val = readl(db->membase + EMAC_INT_CTL_REG);
> -			reg_val |= (0xf << 0) | (0x01 << 8);
> +			reg_val |=
> +				(EMAC_INT_CTL_TX_EN | EMAC_INT_CTL_TX_ABRT_EN |
> +				 EMAC_INT_CTL_RX_EN);

Putting the first value on the next line is a bit odd. This would be
preferred:

+			reg_val |= (EMAC_INT_CTL_TX_EN |
+                                   EMAC_INT_CTL_TX_ABRT_EN |
+				    EMAC_INT_CTL_RX_EN);

I also have to wonder why two | have become three? (0x01 << 8) is
clearly a single value. (0xf << 0) should either be a single macro, or
4 macros since 0xf is four bits. Without looking into the details, i
cannot say this is wrong, but it does look strange.

       Andrew
