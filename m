Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8DE259F9E
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 22:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730149AbgIAUGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 16:06:15 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10606 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727769AbgIAUGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 16:06:14 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4ea9880000>; Tue, 01 Sep 2020 13:05:28 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 01 Sep 2020 13:06:14 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 01 Sep 2020 13:06:14 -0700
Received: from [10.21.180.182] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Sep
 2020 20:06:02 +0000
Subject: Re: [PATCH net-next RFC v3 00/14] Add devlink reload action option
To:     Jiri Pirko <jiri@resnulli.us>, Moshe Shemesh <moshe@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1598801254-27764-1-git-send-email-moshe@mellanox.com>
 <20200831104956.GC3794@nanopsycho.orion>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <917bb002-b15a-c1d5-0366-9f26056b329c@nvidia.com>
Date:   Tue, 1 Sep 2020 23:05:59 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200831104956.GC3794@nanopsycho.orion>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598990728; bh=omp+JH6h2K/zTQptU4FdttRfnPjyJH3p3vSdW1u7r+w=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=bUGSThHVoJWdnK01R1/kxmLlCi31VWtHA9syUU1NsTgCGDu4NLWwj55EFKV13Pjk9
         nmKPs1PimsgZtsfwvqBHYkIUPjP/di7rKteJ92zev0qOhCTD+fRx3FPN5Vh+bDKfId
         VCUDIKGyknpQaMG538b0srFChg6pUy6xT4YnI0wn3Y5JgAwfu1LkfdqPpl/EUPMEwg
         Tlx2AsL3SmX9wKs7rtnZptBd9cpzBiiKib8Xt06JZlRq2D3xLuXwkb0T9ciNhCt0yO
         VWsmQQQ2A2voN3rb6+8KCkB12Q4SHCOB6FExbkYhR6jdoVtNikvdtQAARaBevLjSaf
         mlUi0J6EGJ4IA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/31/2020 1:49 PM, Jiri Pirko wrote:
> Sun, Aug 30, 2020 at 05:27:20PM CEST, moshe@mellanox.com wrote:
>> Introduce new option on devlink reload API to enable the user to select the
>> reload action required. Complete support for all actions in mlx5.
>> The following reload actions are supported:
>>   driver_reinit: driver entities re-initialization, applying devlink-param
>>                  and devlink-resource values.
>>   fw_activate: firmware activate.
>>   fw_activate_no_reset: Activate new firmware image without any reset.
>>                         (also known as: firmware live patching).
>>
>> Each driver which support this command should expose the reload actions
>> supported.
>> The uAPI is backward compatible, if the reload action option is omitted
> >from the reload command, the driver reinit action will be used.
>> Note that when required to do firmware activation some drivers may need
>> to reload the driver. On the other hand some drivers may need to reset
>> the firmware to reinitialize the driver entities. Therefore, the devlink
>> reload command returns the actions which were actually done.
>>
>> Add reload actions counters to hold the history per reload action type.
>> For example, the number of times fw_activate has been done on this
>> device since the driver module was added or if the firmware activation
>> was done with or without reset.
>>
>> Patch 1 adds the new API reload action option to devlink.
>> Patch 2 adds reload actions counters.
>> Patch 3 exposes the reload actions counters on devlink dev get.
>> Patches 4-9 add support on mlx5 for devlink reload action fw_activate
>>             and handle the firmware reset events.
>> Patches 10-11 add devlink enable remote dev reset parameter and use it
>>              in mlx5.
>> Patches 12-13 mlx5 add devlink reload action fw_activate_no_reset support
>>               and event handling.
>> Patch 14 adds documentation file devlink-reload.rst
>>
>> command examples:
>> $devlink dev reload pci/0000:82:00.0 action driver_reinit
>> reload_actions_done:
>>   driver_reinit
>>
>> $devlink dev reload pci/0000:82:00.0 action fw_activate
>> reload_actions_done:
>>   driver_reinit fw_activate
>>
>> $ devlink dev reload pci/0000:82:00.0 action fw_activate no_reset
> You are missing "_".
>
I meant that no_reset is an option, so the uAPI is:

$ devlink dev reload DEV [ netns { PID | NAME | ID } ] [ action { 
driver_reinit | fw_activate [no_reset] } ]

Should have been as "--no_reset" or "-no_reset" but it seems that all 
options in devlink are global, not specific to command.

Probably there is a better way, please advise.

>> reload_actions_done:
> No need to have "reload" word here. And maybe "performed" would be
> better than "done". Idk:
> "actions_performed"
> ?
>

Yes, that's better, I will fix.

>>   fw_activate_no_reset
>>
>> v2 -> v3:
>> - Replace fw_live_patch action by fw_activate_no_reset
>> - Devlink reload returns the actions done over netlink reply
>> - Add reload actions counters
>>
>> v1 -> v2:
>> - Instead of reload levels driver,fw_reset,fw_live_patch have reload
>>   actions driver_reinit,fw_activate,fw_live_patch
>> - Remove driver default level, the action driver_reinit is the default
>>   action for all drivers
>>
>> Moshe Shemesh (14):
>>   devlink: Add reload action option to devlink reload command
>>   devlink: Add reload actions counters
>>   devlink: Add reload actions counters to dev get
>>   net/mlx5: Add functions to set/query MFRL register
>>   net/mlx5: Set cap for pci sync for fw update event
>>   net/mlx5: Handle sync reset request event
>>   net/mlx5: Handle sync reset now event
>>   net/mlx5: Handle sync reset abort event
>>   net/mlx5: Add support for devlink reload action fw activate
>>   devlink: Add enable_remote_dev_reset generic parameter
>>   net/mlx5: Add devlink param enable_remote_dev_reset support
>>   net/mlx5: Add support for fw live patch event
>>   net/mlx5: Add support for devlink reload action fw activate no reset
>>   devlink: Add Documentation/networking/devlink/devlink-reload.rst
>>
>> .../networking/devlink/devlink-params.rst     |   6 +
>> .../networking/devlink/devlink-reload.rst     |  68 +++
>> Documentation/networking/devlink/index.rst    |   1 +
>> drivers/net/ethernet/mellanox/mlx4/main.c     |  14 +-
>> .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
>> .../net/ethernet/mellanox/mlx5/core/devlink.c | 117 ++++-
>> .../mellanox/mlx5/core/diag/fw_tracer.c       |  31 ++
>> .../mellanox/mlx5/core/diag/fw_tracer.h       |   1 +
>> .../ethernet/mellanox/mlx5/core/fw_reset.c    | 453 ++++++++++++++++++
>> .../ethernet/mellanox/mlx5/core/fw_reset.h    |  19 +
>> .../net/ethernet/mellanox/mlx5/core/health.c  |  35 +-
>> .../net/ethernet/mellanox/mlx5/core/main.c    |  13 +
>> .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
>> drivers/net/ethernet/mellanox/mlxsw/core.c    |  24 +-
>> drivers/net/netdevsim/dev.c                   |  16 +-
>> include/linux/mlx5/device.h                   |   1 +
>> include/linux/mlx5/driver.h                   |   4 +
>> include/net/devlink.h                         |  13 +-
>> include/uapi/linux/devlink.h                  |  24 +
>> net/core/devlink.c                            | 174 ++++++-
>> 20 files changed, 967 insertions(+), 51 deletions(-)
>> create mode 100644 Documentation/networking/devlink/devlink-reload.rst
>> create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
>> create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
>>
>> -- 
>> 2.17.1
>>
