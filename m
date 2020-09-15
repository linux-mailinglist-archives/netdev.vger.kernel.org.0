Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2135A26B899
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 02:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgIPAq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 20:46:57 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5409 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgIOMoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 08:44:34 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f60b6ef0003>; Tue, 15 Sep 2020 05:43:27 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 15 Sep 2020 05:44:15 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 15 Sep 2020 05:44:15 -0700
Received: from [10.21.180.139] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 15 Sep
 2020 12:44:05 +0000
Subject: Re: [PATCH net-next RFC v4 10/15] net/mlx5: Add support for devlink
 reload action fw activate
To:     Jiri Pirko <jiri@resnulli.us>, Moshe Shemesh <moshe@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
 <1600063682-17313-11-git-send-email-moshe@mellanox.com>
 <20200914135442.GJ2236@nanopsycho.orion>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <565e63b3-2a01-4eba-42d3-f5abc6794ee8@nvidia.com>
Date:   Tue, 15 Sep 2020 15:44:02 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200914135442.GJ2236@nanopsycho.orion>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600173807; bh=7rQyaAReotzZWpPqHAaqGW2Wo3CINvZ2L34zAIN8X2c=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=D7f+DJqXVkTMThenOHlBq6uWEiE0NCP897MxBPEkCBwOhq843LW8gm5YAMKDK7Zo5
         vAkDJzw3+R1YZjwM9c9YADRJ7ksypSTMrmC8DmNqFjNuemKZe6V6ys9GR9MLsXFwK3
         40cv5sbC0QH+SqBys2ogGPFGXQEVMX4coi6fRZWPueeKurMWiYjZ8nO2HhblIRWj0R
         UDdhmVx/tBs8nK+zzUtF9xKC9Cv70+fCQfzxx/DNgI2rKdRGc+SS5SnZY+FM9E/GoC
         rrcbn2eVHpL72IV/DFhpCN4wzwok9hDB1ki0J5cFrI1Bggq/8bvJI8KC7w/ogUF64a
         HeMJGxR5eceCg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/14/2020 4:54 PM, Jiri Pirko wrote:
> Mon, Sep 14, 2020 at 08:07:57AM CEST, moshe@mellanox.com wrote:
>
> [..]
>
>> +static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev)
>> +{
>> +	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
>> +
>> +	/* if this is the driver that initiated the fw reset, devlink completed the reload */
>> +	if (test_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags)) {
>> +		complete(&fw_reset->done);
>> +	} else {
>> +		mlx5_load_one(dev, false);
>> +		devlink_reload_implicit_actions_performed(priv_to_devlink(dev),
>> +							  DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE,
>> +							  BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
>> +							  BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE));
> Hmm, who originated the reset? Devlink_reload of the same devlink
> instance?


Not the same devlink instance for sure. I defer it by the flag above 
MLX5_FW_RESET_FLAG_PENDING_COMP. If the flag set, I set complete to the 
reload_down() waiting for it.


> [..]
