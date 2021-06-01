Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7406396AAF
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 03:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbhFABqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 21:46:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231714AbhFABqP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 21:46:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 610D061186;
        Tue,  1 Jun 2021 01:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622511874;
        bh=N4QFcFEKQ3MFTOuosPijIimPIpLbyXavUz3xOlXTa2Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k0suyUjAz0rnxgidTCq4eu/a9F+w6/foJsxzcRXupoGTeglrxgqRo2RiMej2vwNPb
         zRmquQS99TvN95ABa0warlyCRQIaHjx754j87uT3FJcRqsNOeenU38aR1TJpuBNwQf
         TwYa4lEFHS8ksNdiRbxUMVsrsaPs4egGoSRdAmKn+qOPLygTcbZpwrwpkdaOAxQXPg
         N43j57lZ0gOGilDb0mfjb7QwQ4mxWaN69lrtcPxOjz5TtJHFgVLq6eZ9XEXGz3envK
         l6LdhrgPFtdJCt9tUQO/uvjJgA9zEHbT7qzkcZhU/5883m/H/rte+bRcmfXSj9+TbS
         dvhONnOf+iiNA==
Date:   Tue, 1 Jun 2021 03:44:30 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     linux-leds@vger.kernel.org
Cc:     netdev@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: Re: [PATCH leds v2 10/10] leds: turris-omnia: support offloading
 netdev trigger for WAN LED
Message-ID: <20210601034430.0b69c05e@thinkpad>
In-Reply-To: <20210601005155.27997-11-kabel@kernel.org>
References: <20210601005155.27997-1-kabel@kernel.org>
        <20210601005155.27997-11-kabel@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int omnia_led_trig_offload_off(struct omnia_leds *leds,
> +				      struct omnia_led *led)
> +{
> +	int ret;
> +
> +	if (!led->phydev)
> +		return 0;
> +
> +	mutex_lock(&leds->lock);
> +
> +	/* set PHY's LED[0] pin to default values */
> +	ret = phy_modify_paged(led->phydev, MII_MARVELL_LED_PAGE,
> +			       MII_PHY_LED_TCR,
> +			       MII_PHY_LED_TCR_PULSESTR_MASK |
> +			       MII_PHY_LED_TCR_BLINKRATE_MASK,
> +			       (4 << MII_PHY_LED_TCR_PULSESTR_SHIFT) |
> +			       (1 << MII_PHY_LED_TCR_BLINKRATE_SHIFT));
> +
> +	ret = phy_modify_paged(led->phydev, MII_MARVELL_LED_PAGE,
> +			       MII_PHY_LED_CTRL, 0xf, 0xe);
> +

I forgot to add warnings here if ret < 0, since offload disabling must
return 0.
