Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A32248211
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 11:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbgHRJlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 05:41:09 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:18247 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbgHRJlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 05:41:07 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3ba1f90001>; Tue, 18 Aug 2020 02:40:09 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 18 Aug 2020 02:41:07 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 18 Aug 2020 02:41:07 -0700
Received: from yaviefel (10.124.1.5) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 18 Aug 2020 09:37:49
 +0000
References: <20200715082733.429610-4-idosch@idosch.org> <20200817153824.GA1420904@bjorn-Precision-5520> <20200818064151.GA214959@shredder>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@nvidia.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     Bjorn Helgaas <helgaas@kernel.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@mellanox.com>,
        <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 03/11] mlxsw: spectrum_policer: Add policer core
In-Reply-To: <20200818064151.GA214959@shredder>
Date:   Tue, 18 Aug 2020 11:37:45 +0200
Message-ID: <87wo1we1li.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597743609; bh=HpTueCmI8dXbky2bWlHCpvB5NTBi0/NU9+a3DcJoAts=;
        h=X-PGP-Universal:References:User-agent:From:To:CC:Subject:
         In-Reply-To:Date:Message-ID:MIME-Version:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=LkLTSPfi0rbrrGatX8ULTctCivykYHjlspqPANDBgOLNALtNmpBC5oVsb2FVRpssI
         SKDz8gkDfFY7ijh+VxmzAxzcFUqg9aY/gvVunBtQ9SygEFqP/otGNkOjjOXu/jTtN4
         UUuylZhpAxuVy+KNICSSBeMUIvmEsWmwyTKq+v+2vsGkjgSCpMRlf3Wq6LNMyxRP3T
         BsS3y2mrwaIVSWeWUUMZRLpEIGQ5JuiJvBbvcPvrf86lc2u/E3+6uU69CGoZ4k8hUB
         LswPEg5w0A/gkYK5wJNzHRfGAeGbxiDbGTl9W8cSAeW51I2I/BXAqFU+LiNl/AFhFg
         sJHqgKau3rqGg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Ido Schimmel <idosch@idosch.org> writes:

> On Mon, Aug 17, 2020 at 10:38:24AM -0500, Bjorn Helgaas wrote:
>> You've likely seen this already, but Coverity found this problem:
>> 
>>   *** CID 1466147:  Control flow issues  (DEADCODE)
>>   /drivers/net/ethernet/mellanox/mlxsw/spectrum_policer.c: 380 in mlxsw_sp_policers_init()
>>   374     	}
>>   375     
>>   376     	return 0;
>>   377     
>>   378     err_family_register:
>>   379     	for (i--; i >= 0; i--) {
>>   >>>     CID 1466147:  Control flow issues  (DEADCODE)
>>   >>>     Execution cannot reach this statement: "struct mlxsw_sp_policer_fam...".
>>   380     		struct mlxsw_sp_policer_family *family;
>>   381     
>>   382     		family = mlxsw_sp->policer_core->family_arr[i];
>>   383     		mlxsw_sp_policer_family_unregister(mlxsw_sp, family);
>>   384     	}
>>   385     err_init:
>> 
>> I think the problem is that MLXSW_SP_POLICER_TYPE_MAX is 0 because
>> 
>> > +enum mlxsw_sp_policer_type {
>> > +	MLXSW_SP_POLICER_TYPE_SINGLE_RATE,
>> > +
>> > +	__MLXSW_SP_POLICER_TYPE_MAX,
>> > +	MLXSW_SP_POLICER_TYPE_MAX = __MLXSW_SP_POLICER_TYPE_MAX - 1,
>> > +};
>> 
>> so we can only execute the family_register loop once, with i == 0,
>> and if we get to err_family_register via the error exit:
>> 
>> > +	for (i = 0; i < MLXSW_SP_POLICER_TYPE_MAX + 1; i++) {
>> > +		err = mlxsw_sp_policer_family_register(mlxsw_sp, mlxsw_sp_policer_family_arr[i]);
>> > +		if (err)
>> > +			goto err_family_register;
>> 
>> i will be 0, so i-- sets i to -1, so we don't enter the
>> family_unregister loop body since -1 is not >= 0.
>
> Thanks for the report, but isn't the code doing the right thing here? I
> mean, it's dead code now, but as soon as we add another family it will
> be executed. It seems error prone to remove it only to please Coverity
> and then add it back when it's actually needed.

Agreed.
