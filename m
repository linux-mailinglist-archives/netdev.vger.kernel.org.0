Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDD8191FCB
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 04:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbgCYDdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 23:33:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727262AbgCYDdw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 23:33:52 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0408720724;
        Wed, 25 Mar 2020 03:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585107231;
        bh=f0oI14hIMWg3+DqdLYVpol8h1Wn03ZJ5vcr1jkyf+Ec=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=03fQkTOt+zsDQ2YlK1etkfEa5BlFzj+LfNKH1sQKGve9vfOz2qOPrFWanChOfO0Gn
         LMfi1NHwDuimDzCTmfY8RbZsTKeYJffYwro8li9NmU2Kll6TOFZ+Pd1WsjnFT3rV8r
         CWHVR9N+7uBD2tcoyyVWks9UAhjIzD2kCH6LhCqk=
Date:   Tue, 24 Mar 2020 20:33:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 11/15] mlxsw: spectrum_trap: Add devlink-trap
 policer support
Message-ID: <20200324203349.6a76e581@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200324193250.1322038-12-idosch@idosch.org>
References: <20200324193250.1322038-1-idosch@idosch.org>
        <20200324193250.1322038-12-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Mar 2020 21:32:46 +0200 Ido Schimmel wrote:
> +static int mlxsw_sp_trap_policer_params_check(u64 rate, u64 burst,
> +					      u8 *p_burst_size,
> +					      struct netlink_ext_ack *extack)
> +{
> +	int bs = fls64(burst);
> +
> +	if (rate < MLXSW_REG_QPCR_LOWEST_CIR) {
> +		NL_SET_ERR_MSG_MOD(extack, "Policer rate lower than limit");
> +		return -EINVAL;
> +	}
> +
> +	if (rate > MLXSW_REG_QPCR_HIGHEST_CIR) {
> +		NL_SET_ERR_MSG_MOD(extack, "Policer rate higher than limit");
> +		return -EINVAL;
> +	}
> +
> +	if (!bs) {
> +		NL_SET_ERR_MSG_MOD(extack, "Policer burst size lower than limit");
> +		return -EINVAL;
> +	}
> +
> +	--bs;
> +
> +	if (burst != (1 << bs)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Policer burst size is not power of two");
> +		return -EINVAL;
> +	}
> +
> +	if (bs < MLXSW_REG_QPCR_LOWEST_CBS) {
> +		NL_SET_ERR_MSG_MOD(extack, "Policer burst size lower than limit");
> +		return -EINVAL;
> +	}
> +
> +	if (bs > MLXSW_REG_QPCR_HIGHEST_CBS) {
> +		NL_SET_ERR_MSG_MOD(extack, "Policer burst size higher than limit");
> +		return -EINVAL;
> +	}

Any chance we could make the min/max values part of the policer itself?
Are they dynamic? Seems like most drivers will have to repeat this
checking against constants while maybe core could have done it?

> +
> +	*p_burst_size = bs;
> +
> +	return 0;
> +}
