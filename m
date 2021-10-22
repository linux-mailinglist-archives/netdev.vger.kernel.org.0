Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300AC437EED
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 21:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234338AbhJVT7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 15:59:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53570 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234354AbhJVT7B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 15:59:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=0dw0G2hGw3R8B2utjcHIR0tcRl4woMFQ/0IDH5XuZDg=; b=0u7YSGibNf01FhdYDqRHR0NZ4V
        w/vNk2Md3r2bzZg4fOIqVAKGN6GSv0QA7b+CvzQtglYtJ4xPHypn+ufcofh8bkaHgk9B7ApqZq9yh
        msr230OQqiOjRZT/TsI2td92OgugdaLk9oLLCUZ7hOS8Bm1IV6v/xhh6hiiUFNZlh+zs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1me0eg-00BQQr-ME; Fri, 22 Oct 2021 21:56:42 +0200
Date:   Fri, 22 Oct 2021 21:56:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yuiko Oshino <yuiko.oshino@microchip.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        nisar.sayed@microchip.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next] net: phy: microchip_t1: add cable test support
 for lan87xx phy
Message-ID: <YXMXeuMUVvmR5Zrc@lunn.ch>
References: <20211022183632.8415-1-yuiko.oshino@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022183632.8415-1-yuiko.oshino@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int lan87xx_cable_test_start(struct phy_device *phydev)
> +{
> +	static const struct access_ereg_val cable_test[] = {
> +		/* min wait */
> +		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 93,
> +		 0, 0},
> +		/* max wait */
> +		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 94,
> +		 10, 0},
> +		/* pulse cycle */
> +		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 95,
> +		 90, 0},
> +		/* cable diag thresh */
> +		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 92,
> +		 60, 0},
> +		/* max gain */
> +		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 79,
> +		 31, 0},
> +		/* clock align for each iteration */
> +		{PHYACC_ATTR_MODE_MODIFY, PHYACC_ATTR_BANK_DSP, 55,
> +		 0, 0x0038},
> +		/* max cycle wait config */
> +		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 94,
> +		 70, 0},
> +		/* start cable diag*/
> +		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 90,
> +		 1, 0},
> +	};
> +	int rc, i;
> +
> +	rc = microchip_cable_test_start_common(phydev);
> +	if (rc < 0)
> +		return rc;
> +
> +	/* start cable diag */
> +	/* check if part is alive - if not, return diagnostic error */
> +	rc = access_ereg(phydev, PHYACC_ATTR_MODE_READ, PHYACC_ATTR_BANK_SMI,
> +			 0x00, 0);
> +	if (rc < 0)
> +		return rc;
> +
> +	if (rc != 0x2100)
> +		return -ENODEV;

What does this actually mean? Would -EOPNOTSUPP be better?

> +static int lan87xx_cable_test_report_trans(u32 result)
> +{
> +	switch (result) {
> +	case 0:
> +		return ETHTOOL_A_CABLE_RESULT_CODE_OK;
> +	case 1:
> +		return ETHTOOL_A_CABLE_RESULT_CODE_OPEN;
> +	case 2:
> +		return ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT;

Please add some #defines for 0, 1, 2.

       Andrew
