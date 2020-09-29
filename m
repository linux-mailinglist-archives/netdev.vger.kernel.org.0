Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B203527D427
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 19:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgI2RKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 13:10:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34020 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728205AbgI2RKc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 13:10:32 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNJ94-00GmQl-Bq; Tue, 29 Sep 2020 19:10:30 +0200
Date:   Tue, 29 Sep 2020 19:10:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 2/3] net: atlantic: implement phy downshift
 feature
Message-ID: <20200929171030.GC3996795@lunn.ch>
References: <20200929161307.542-1-irusskikh@marvell.com>
 <20200929161307.542-3-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929161307.542-3-irusskikh@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +int aq_nic_set_downshift(struct aq_nic_s *self)
> +{
> +	int err = 0;
> +	struct aq_nic_cfg_s *cfg = &self->aq_nic_cfg;
> +
> +	if (!self->aq_fw_ops->set_downshift)
> +		return -EOPNOTSUPP;
> +
> +	if (ATL_HW_IS_CHIP_FEATURE(self->aq_hw, ANTIGUA)) {
> +		if (cfg->downshift_counter > 15)
> +			cfg->downshift_counter = 15;
> +	} else {
> +		if (cfg->downshift_counter > 255)
> +			cfg->downshift_counter = 255;
> +	}

Hi Igor

I think all other implementations return -EINVAL or -E2BIG or similar
when the value is not supported.

Also, given that a u8 is being passed, is cfg->downshift_counter > 255
possible? I'm not even sure 255 makes any sense. Autoneg takes around
1.5s, maybe longer. Do you really want to wait 255 * 1.5 seconds
before downshifting? Even 15*1.5 seems a long time.

	Andrew
