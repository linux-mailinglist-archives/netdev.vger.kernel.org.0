Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08737309CC1
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 15:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbhAaORb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 09:17:31 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:18865 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbhAaNdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 08:33:09 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6016afa70001>; Sun, 31 Jan 2021 05:24:55 -0800
Received: from [172.27.1.148] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 31 Jan
 2021 13:24:53 +0000
Subject: Re: [PATCH mlx5-next v1] RDMA/mlx5: Cleanup the synchronize_srcu()
 from the ODP flow
To:     Saeed Mahameed <saeed@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        "Doug Ledford" <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Jakub Kicinski <kuba@kernel.org>, <linux-rdma@vger.kernel.org>,
        <netdev@vger.kernel.org>, Yishai Hadas <yishaih@nvidia.com>
References: <20210128064812.1921519-1-leon@kernel.org>
 <c79124a204f2207f5f1fae69cc34fb08d91d3535.camel@kernel.org>
From:   Yishai Hadas <yishaih@nvidia.com>
Message-ID: <549b337b-b51e-c984-a4d8-72f9f738be9c@nvidia.com>
Date:   Sun, 31 Jan 2021 15:24:50 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <c79124a204f2207f5f1fae69cc34fb08d91d3535.camel@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612099495; bh=IkmO/L8zoqUnS9ldzzHqjxMoRQXbJUVj07wmo4M28rg=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=SiSRWx1vhttL/xwwhI4rbg9fJiVB1qzxkgVBvoNt5uwcY0uPpWHZxUNIShJWvtqdY
         ACqX0VjgTMmjkNZJjbO9LHFcypHfcJmpYig9C4IlcJDauZ5ZMrS5XWKHI5cVpvMfUD
         BN3xoeex2uAA7kFaduuHVDJ4Rc71eEtfO9tK19mNyFUTLNP++a7eOttvEsNxHWJeIj
         X+/BLQGYmffqkcGBD6qJ3Pety5ky8bIrG4NzIAA/xB7cPPgZ+EdsxxnW4HuizFL9Sx
         4foAH49E5JGtcwbMdMlbx/QcvegwySwf4LxQvyU9By7pNZdSTcYn1Sa9/T1q+tn0TS
         LV5tfdiEettKA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/29/2021 2:23 PM, Saeed Mahameed wrote:
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
>> b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
>> index 9eb51f06d3ae..50af84e76fb6 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
>> @@ -56,6 +56,7 @@ int mlx5_core_create_mkey(struct mlx5_core_dev
>> *dev,
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mkey->size =3D MLX5_GET=
64(mkc, mkc, len);
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mkey->key |=3D mlx5_idx=
_to_mkey(mkey_index);
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mkey->pd =3D MLX5_GET(m=
kc, mkc, pd);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0init_waitqueue_head(&mkey->wa=
it);
>>
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mlx5_core_dbg(dev, "out=
 0x%x, mkey 0x%x\n", mkey_index, mkey-
>>> key);
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return 0;
>> diff --git a/include/linux/mlx5/driver.h
>> b/include/linux/mlx5/driver.h
>> index 4901b4fadabb..f9e7036ae5a5 100644
>> --- a/include/linux/mlx5/driver.h
>> +++ b/include/linux/mlx5/driver.h
>> @@ -373,6 +373,8 @@ struct mlx5_core_mkey {
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u32=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0key;
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u32=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0pd;
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u32=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0type;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct wait_queue_head wait;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0refcount_t usecount;
> mlx5_core_mkey is used everywhere in mlx5_core and we don't care about
> odp complexity, i would like to keep the core simple and primitive as
> it is today.
> please keep the layer separation and find a way to manage refcount and
> wait queue in mlx5_ib driver..
>
The alternative could really be to come with some wrapped mlx5_ib=20
structure that will hold 'mlx5_core_mkey' and will add those two fields.

However,

As ODP is a data path flow we need to minimize any locking scope and=20
reduce branches, having the above stuff on 'mlx5_core_mkey' allows=20
direct access from any type of mlx5_ib object that uses it.
Having it per object (e.g. mlx5_ib_mr, mlx5_ib_mw, mlx5_ib_devx_mr)=20
increasing locking scope and branches on data path to find the refcount=20
field per its 'type'.=C2=A0 (see mlx5_core_mkey->type).

Specifically talking, see pagefault_single_data_segment() [1], its mkey=20
can be from type MR, MW or DEVX, with current patch having the refcount=20
on the core we increase it immediacy and free the lock rather than do=20
some lookup based on type and only then increase refcount and=C2=A0 free th=
e=20
lock.

In addition,

Wrapping 'mlx5_core_mkey' for this might hit other data path flows as of=20
UMR, this may require extra memory access to get the=20
'mlx5_core_mkey->key' field upon building the WR, we prefer to avoid it.
See mlx5_ib_create_xlt_wr [2].

So, it seems reasonable to have those properties on the raw mkey=20
structure, usage of the refcount / wait is done in mlx5 ib, so no impact=20
should be for other users as of that.

[1]=20
https://elixir.bootlin.com/linux/v5.11-rc5/source/drivers/infiniband/hw/mlx=
5/odp.c#L893

[2]=20
https://elixir.bootlin.com/linux/v5.11-rc5/source/drivers/infiniband/hw/mlx=
5/mr.c#L1092

Yishai

