Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0EA25E9BD
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 20:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgIESiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 14:38:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728393AbgIESiV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 14:38:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 116B62074D;
        Sat,  5 Sep 2020 18:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599331101;
        bh=RiJx3p6tZX3vdqPValVYqRIYJonUSDkljdfqqiP+ivI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AYJf0gVvVsrVa3xgabN92BL2dNFHUnkQ8IToSzTbkQynaCqg9Rc9Aja6504ozX0QB
         VFh6wBxQXTrMCARG8mire+mVRLCSEWQtgDPclIbCl/QAzrDUBYJ4MzIoHjhDPlVmzR
         fp57e4uL+am9TVrTzTvSjTahtLLaDO6nwlHctG+A=
Date:   Sat, 5 Sep 2020 11:38:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 3/3] net: dp83869: Add speed optimization
 feature
Message-ID: <20200905113818.7962b6d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200903114259.14013-4-dmurphy@ti.com>
References: <20200903114259.14013-1-dmurphy@ti.com>
        <20200903114259.14013-4-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Sep 2020 06:42:59 -0500 Dan Murphy wrote:
> +static int dp83869_set_downshift(struct phy_device *phydev, u8 cnt)
> +{
> +	int val, count;
> +
> +	if (cnt > DP83869_DOWNSHIFT_8_COUNT)
> +		return -E2BIG;

ERANGE

> +	if (!cnt)
> +		return phy_clear_bits(phydev, DP83869_CFG2,
> +				      DP83869_DOWNSHIFT_EN);
> +
> +	switch (cnt) {
> +	case DP83869_DOWNSHIFT_1_COUNT:
> +		count = DP83869_DOWNSHIFT_1_COUNT_VAL;
> +		break;
> +	case DP83869_DOWNSHIFT_2_COUNT:
> +		count = DP83869_DOWNSHIFT_2_COUNT_VAL;
> +		break;
> +	case DP83869_DOWNSHIFT_4_COUNT:
> +		count = DP83869_DOWNSHIFT_4_COUNT_VAL;
> +		break;
> +	case DP83869_DOWNSHIFT_8_COUNT:
> +		count = DP83869_DOWNSHIFT_8_COUNT_VAL;
> +		break;
> +	default:
> +		phydev_err(phydev,
> +			   "Downshift count must be 1, 2, 4 or 8\n");
> +		return -EINVAL;
> +	}
> +
> +	val = DP83869_DOWNSHIFT_EN;
> +	val |= FIELD_PREP(DP83869_DOWNSHIFT_ATTEMPT_MASK, count);
> +
> +	return phy_modify(phydev, DP83869_CFG2,
> +			  DP83869_DOWNSHIFT_EN | DP83869_DOWNSHIFT_ATTEMPT_MASK,
> +			  val);
> +}
