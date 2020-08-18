Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC101248484
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 14:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgHRMKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 08:10:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726688AbgHRMKG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 08:10:06 -0400
Received: from localhost (104.sub-72-107-126.myvzw.com [72.107.126.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D470A204EA;
        Tue, 18 Aug 2020 12:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597752606;
        bh=124vr7K2HrRgvr5UQMbnrfHKbMJ19rh68+CacxvRWTM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=VCIZQMYUYcPWTY/ckM7+ntjG/hidUg2a3gG8TJPxzSCmU5CpEE/lKI2ix4LRQ9exs
         At8rKWgr0glSzTik65t1LzZubXyi7fHQw/1TX2gXpt3FXi2dsSQD3UR/jZUP6rdUHh
         xqjSSy78pwBkDQ2gRnZhQ1hRi32P9K+7uetakSYk=
Date:   Tue, 18 Aug 2020 07:10:04 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 03/11] mlxsw: spectrum_policer: Add policer core
Message-ID: <20200818121004.GA1491413@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wo1we1li.fsf@nvidia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 11:37:45AM +0200, Petr Machata wrote:
> Ido Schimmel <idosch@idosch.org> writes:
> > On Mon, Aug 17, 2020 at 10:38:24AM -0500, Bjorn Helgaas wrote:
> >> You've likely seen this already, but Coverity found this problem:
> >> 
> >>   *** CID 1466147:  Control flow issues  (DEADCODE)
> >>   /drivers/net/ethernet/mellanox/mlxsw/spectrum_policer.c: 380 in mlxsw_sp_policers_init()
> >>   374     	}
> >>   375     
> >>   376     	return 0;
> >>   377     
> >>   378     err_family_register:
> >>   379     	for (i--; i >= 0; i--) {
> >>   >>>     CID 1466147:  Control flow issues  (DEADCODE)
> >>   >>>     Execution cannot reach this statement: "struct mlxsw_sp_policer_fam...".
> >>   380     		struct mlxsw_sp_policer_family *family;
> >>   381     
> >>   382     		family = mlxsw_sp->policer_core->family_arr[i];
> >>   383     		mlxsw_sp_policer_family_unregister(mlxsw_sp, family);
> >>   384     	}
> >>   385     err_init:
> >> 
> >> I think the problem is that MLXSW_SP_POLICER_TYPE_MAX is 0 because
> >> 
> >> > +enum mlxsw_sp_policer_type {
> >> > +	MLXSW_SP_POLICER_TYPE_SINGLE_RATE,
> >> > +
> >> > +	__MLXSW_SP_POLICER_TYPE_MAX,
> >> > +	MLXSW_SP_POLICER_TYPE_MAX = __MLXSW_SP_POLICER_TYPE_MAX - 1,
> >> > +};
> >> 
> >> so we can only execute the family_register loop once, with i == 0,
> >> and if we get to err_family_register via the error exit:
> >> 
> >> > +	for (i = 0; i < MLXSW_SP_POLICER_TYPE_MAX + 1; i++) {
> >> > +		err = mlxsw_sp_policer_family_register(mlxsw_sp, mlxsw_sp_policer_family_arr[i]);
> >> > +		if (err)
> >> > +			goto err_family_register;
> >> 
> >> i will be 0, so i-- sets i to -1, so we don't enter the
> >> family_unregister loop body since -1 is not >= 0.
> >
> > Thanks for the report, but isn't the code doing the right thing here? I
> > mean, it's dead code now, but as soon as we add another family it will
> > be executed. It seems error prone to remove it only to please Coverity
> > and then add it back when it's actually needed.
> 
> Agreed.

You're right, I missed the forest for the trees.  Sorry for the noise.

Bjorn
