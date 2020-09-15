Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED01E26AEAD
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 22:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgIOUaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 16:30:04 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:16935 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728044AbgIOU3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 16:29:21 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f6123d90003>; Tue, 15 Sep 2020 13:28:09 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 15 Sep 2020 13:28:57 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 15 Sep 2020 13:28:57 -0700
Received: from [10.21.180.184] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 15 Sep
 2020 20:28:48 +0000
Subject: Re: [PATCH net-next RFC v4 10/15] net/mlx5: Add support for devlink
 reload action fw activate
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
 <1600063682-17313-11-git-send-email-moshe@mellanox.com>
 <20200914135442.GJ2236@nanopsycho.orion>
 <565e63b3-2a01-4eba-42d3-f5abc6794ee8@nvidia.com>
 <20200915133705.GR2236@nanopsycho.orion>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <5c5689d9-c2ba-7656-10f3-1d5f33fc6a2e@nvidia.com>
Date:   Tue, 15 Sep 2020 23:28:44 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200915133705.GR2236@nanopsycho.orion>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600201690; bh=04mquwvw+nsnJ9vxBd1TQjzQY+onGs1HBC0MTcuyVQE=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=YULuzCP7FivE9eQRhiWC/QCJW5DpcfZV+gsC3rforTg8OnzTKIqYbG+HV2YKlxfCz
         URpZSKUpScYtSkynsc57iJzLbOf3RAYG0EPLYIafio1t/LqK31HArD3NVqdGA5q4E8
         s6Qqg9yQ1BdsYYlM0+aa8xO8X7qdS4+/3A60LFDuZ8Nj59oTf2cuQP/IWawWEF2llQ
         hkqi9BWKemsAv4yJOImDYPcV8HBPOUmhSV+1Oc56x9M26++N3pjQx+TDv/yqQAwAjk
         kgAKxdfkyKC6Vlt62Y8jxPCn7zPMky2r4OYTaMEyZso6+gyDtCDV8ND7v/XM+I+rBk
         L6ezSbVR/jypQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/15/2020 4:37 PM, Jiri Pirko wrote:
> Tue, Sep 15, 2020 at 02:44:02PM CEST, moshe@nvidia.com wrote:
>> On 9/14/2020 4:54 PM, Jiri Pirko wrote:
>>> Mon, Sep 14, 2020 at 08:07:57AM CEST, moshe@mellanox.com wrote:
>>>
>>> [..]
>>>
>>>> +static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev)
>>>> +{
>>>> +	struct mlx5_fw_reset *fw_reset =3D dev->priv.fw_reset;
>>>> +
>>>> +	/* if this is the driver that initiated the fw reset, devlink comple=
ted the reload */
>>>> +	if (test_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flag=
s)) {
>>>> +		complete(&fw_reset->done);
>>>> +	} else {
>>>> +		mlx5_load_one(dev, false);
>>>> +		devlink_reload_implicit_actions_performed(priv_to_devlink(dev),
>>>> +							  DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE,
>>>> +							  BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
>>>> +							  BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE));
>>> Hmm, who originated the reset? Devlink_reload of the same devlink
>>> instance?
>>
>> Not the same devlink instance for sure. I defer it by the flag above
>> MLX5_FW_RESET_FLAG_PENDING_COMP. If the flag set, I set complete to the
>> reload_down() waiting for it.
> Hmm, thinking about the stats, as
> devlink_reload_implicit_actions_performed() is called only in case
> another instance does the reload, shouldn't it be a separate set of
> stats? I think that the user would like to distinguish local and remote
> reload, don't you think?
>

Possible, it will double the counters, but it will give more info.

So actually, if devlink_reload is not supported by driver, I should hold=20
and show only the remote stats or all stats always ?

How such remote counter should look like ? something like=20
remote_fw_activate=C2=A0 while the local is just fw_activate ?

>>
>>> [..]
