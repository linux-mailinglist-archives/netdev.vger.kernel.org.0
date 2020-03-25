Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1212C192E8F
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 17:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbgCYQpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 12:45:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbgCYQpw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 12:45:52 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 159822073E;
        Wed, 25 Mar 2020 16:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585154751;
        bh=Pad+Otka5Vlu6MlmmwloZY7090ZcCs4qq3UIfr6E+lQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P+tcWXNjB7MnDgAsk2ADJH6wIJgUCP7folYejWQ+yIMrJyP3SLY6nOmDJgqt4aVq1
         mc2hKpayV/W6Feb5JpL/fJkm9QFjMZHqghIHcz/dOl8zbbxA7shHiJR1gYV/KkN8M2
         pzivCLqMPOGXjRyxtHw33Cftnk2J+TL/IFMSfCgg=
Date:   Wed, 25 Mar 2020 09:45:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 11/15] mlxsw: spectrum_trap: Add devlink-trap
 policer support
Message-ID: <20200325094549.5b0c5bc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200325105121.GD1332836@splinter>
References: <20200324193250.1322038-1-idosch@idosch.org>
        <20200324193250.1322038-12-idosch@idosch.org>
        <20200324203349.6a76e581@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200325105121.GD1332836@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Mar 2020 12:51:21 +0200 Ido Schimmel wrote:
> On Tue, Mar 24, 2020 at 08:33:49PM -0700, Jakub Kicinski wrote:
> > On Tue, 24 Mar 2020 21:32:46 +0200 Ido Schimmel wrote:  
> > > +static int mlxsw_sp_trap_policer_params_check(u64 rate, u64 burst,
> > > +					      u8 *p_burst_size,
> > > +					      struct netlink_ext_ack *extack)
> > > +{
> > > +	int bs = fls64(burst);
> > > +
> > > +	if (rate < MLXSW_REG_QPCR_LOWEST_CIR) {
> > > +		NL_SET_ERR_MSG_MOD(extack, "Policer rate lower than limit");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	if (rate > MLXSW_REG_QPCR_HIGHEST_CIR) {
> > > +		NL_SET_ERR_MSG_MOD(extack, "Policer rate higher than limit");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	if (!bs) {
> > > +		NL_SET_ERR_MSG_MOD(extack, "Policer burst size lower than limit");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	--bs;
> > > +
> > > +	if (burst != (1 << bs)) {
> > > +		NL_SET_ERR_MSG_MOD(extack, "Policer burst size is not power of two");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	if (bs < MLXSW_REG_QPCR_LOWEST_CBS) {
> > > +		NL_SET_ERR_MSG_MOD(extack, "Policer burst size lower than limit");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	if (bs > MLXSW_REG_QPCR_HIGHEST_CBS) {
> > > +		NL_SET_ERR_MSG_MOD(extack, "Policer burst size higher than limit");
> > > +		return -EINVAL;
> > > +	}  
> > 
> > Any chance we could make the min/max values part of the policer itself?
> > Are they dynamic? Seems like most drivers will have to repeat this
> > checking against constants while maybe core could have done it?  
> 
> Yea, it's a good idea. We can also expose these values to user space,
> but I think it's not really necessary and I prefer not to extend uAPI
> unless we really have to.

SGTM, thanks!
