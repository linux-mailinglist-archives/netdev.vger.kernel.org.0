Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDCA9387295
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 08:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241874AbhERGte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 02:49:34 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4656 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239746AbhERGtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 02:49:33 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fkmj51XgLz16Q9S;
        Tue, 18 May 2021 14:45:29 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 18 May 2021 14:48:14 +0800
Received: from [10.67.102.67] (10.67.102.67) by dggemi759-chm.china.huawei.com
 (10.1.198.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 18
 May 2021 14:48:13 +0800
Subject: Re: [PATCH net-next v2 0/6] ethtool: add standard FEC statistics
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <michael.chan@broadcom.com>,
        <saeedm@nvidia.com>, <leon@kernel.org>, <ecree.xilinx@gmail.com>,
        <habetsm.xilinx@gmail.com>, <f.fainelli@gmail.com>,
        <andrew@lunn.ch>, <mkubecek@suse.cz>, <ariela@nvidia.com>
References: <20210415225318.2726095-1-kuba@kernel.org>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <b5bb362e-a430-2cc8-291e-b407e306fd49@huawei.com>
Date:   Tue, 18 May 2021 14:48:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20210415225318.2726095-1-kuba@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/4/16 6:53, Jakub Kicinski wrote:
> This set adds uAPI for reporting standard FEC statistics, and
> implements it in a handful of drivers.
> 
> The statistics are taken from the IEEE standard, with one
> extra seemingly popular but not standard statistics added.
> 
> The implementation is similar to that of the pause frame
> statistics, user requests the stats by setting a bit
> (ETHTOOL_FLAG_STATS) in the common ethtool header of
> ETHTOOL_MSG_FEC_GET.
> 
> Since standard defines the statistics per lane what's
> reported is both total and per-lane counters:
> 
>   # ethtool -I --show-fec eth0
>   FEC parameters for eth0:
>   Configured FEC encodings: None
>   Active FEC encoding: None
>   Statistics:
>    corrected_blocks: 256
>      Lane 0: 255
>      Lane 1: 1
>    uncorrectable_blocks: 145
>      Lane 0: 128
>      Lane 1: 17
> 
Hi, I have a doubt that why active FEC encoding is None here?  Should it actually be BaseR or RS if FEC statistics are reported?

> v2: check for errors in mlx5 register access
> 
> Jakub Kicinski (6):
>    ethtool: move ethtool_stats_init
>    ethtool: fec_prepare_data() - jump to error handling
>    ethtool: add FEC statistics
>    bnxt: implement ethtool::get_fec_stats
>    sfc: ef10: implement ethtool::get_fec_stats
>    mlx5: implement ethtool::get_fec_stats
> 
>   Documentation/networking/ethtool-netlink.rst  | 21 +++++
>   Documentation/networking/statistics.rst       |  2 +
>   .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 15 ++++
>   .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  9 +++
>   .../ethernet/mellanox/mlx5/core/en_stats.c    | 29 ++++++-
>   .../ethernet/mellanox/mlx5/core/en_stats.h    |  2 +
>   drivers/net/ethernet/sfc/ef10.c               | 17 ++++
>   drivers/net/ethernet/sfc/ethtool.c            | 10 +++
>   drivers/net/ethernet/sfc/net_driver.h         |  3 +
>   include/linux/ethtool.h                       | 46 +++++++++++
>   include/uapi/linux/ethtool_netlink.h          | 14 ++++
>   net/ethtool/fec.c                             | 80 ++++++++++++++++++-
>   net/ethtool/pause.c                           |  6 --
>   13 files changed, 242 insertions(+), 12 deletions(-)
> 
