Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A885480594
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 02:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234488AbhL1Bt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 20:49:59 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36586 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234477AbhL1Bt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 20:49:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A8FEB81185;
        Tue, 28 Dec 2021 01:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D505C36AE7;
        Tue, 28 Dec 2021 01:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640656195;
        bh=kbm0qdsE3K55z11kzBPcoPlelzmKe3s6q4qARM5HFxo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RUS34wVAsjVmGTdtTXOI2qeyuK/K4VMoA4HPLZ0LskU2+ZKi/osGN9YYN5lAWD9K5
         tqeYMuEZgJQK5ElzMXG4Tbn7p7zzDajIeNPkc9EqV2gHuXhU4eWYHXuXwLn2wuAgB4
         STLTv5+mpHr9txNoVpHyo6MclQzj96lyWmgYvZ7ANf5yOoTzZH+vIWrsUd/xKtj4p9
         CS4cFCjLqY9x9GlxirGG0DJuOgsMg+ChM7cArfNZ9lQsA7Mqyg0e+bGb4cjoBAbYlr
         FYO6HSFznVZ8yC4NtNImFqltwDo2hTZxjoaYyGRcfL5W04RBqH8GrK+Y7SkiNA/1ys
         rUB3KutB5mD6w==
Date:   Mon, 27 Dec 2021 17:49:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joseph CHAMG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, joseph_chang@davicom.com.tw,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v9, 2/2] net: Add dm9051 driver
Message-ID: <20211227174954.1411a643@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211227100233.8037-3-josright123@gmail.com>
References: <20211227100233.8037-1-josright123@gmail.com>
        <20211227100233.8037-3-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Dec 2021 18:02:33 +0800 Joseph CHAMG wrote:
> +static inline void dm9051_phyup_lock(struct board_info *db)
> +{
> +	int val, ret;
> +
> +	mutex_lock(&db->addr_lock);
> +
> +	ret = dm9051_phy_read(db, MII_BMCR, &val);
> +	if (ret)
> +		return;
> +
> +	/* BMCR Power-up PHY */
> +	ret = dm9051_phy_write(db, MII_BMCR, val & ~0x0800);
> +	if (ret)
> +		return;
> +
> +	/* GPR Power-up PHY */
> +	dm9051_iow(db, DM9051_GPR, 0);
> +	mdelay(1); /* need for activate phyxcer */
> +
> +	mutex_unlock(&db->addr_lock);
> +}
> +
> +static inline void dm9051_phydown_lock(struct board_info *db)
> +{
> +	mutex_lock(&db->addr_lock);
> +	dm9051_iow(db, DM9051_GPR, 0x01); /* Power-Down PHY */
> +	mutex_unlock(&db->addr_lock);
> +}

Please remove the 'inline' qualifier from functions in C sources.
Compiler will know which static functions to inline these days.
