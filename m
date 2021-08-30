Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3513FAF9C
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 03:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235570AbhH3BrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 21:47:19 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:15266 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhH3BrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 21:47:17 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GyY7V23gzz8CQ3;
        Mon, 30 Aug 2021 09:45:58 +0800 (CST)
Received: from dggpeml500024.china.huawei.com (7.185.36.10) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 30 Aug 2021 09:46:18 +0800
Received: from [10.67.103.6] (10.67.103.6) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 30 Aug
 2021 09:46:17 +0800
Subject: Re: [PATCH RESEND ethtool-next] netlink: settings: add netlink
 support for coalesce cqe mode parameter
To:     Michal Kubecek <mkubecek@suse.cz>
References: <1630044408-32819-1-git-send-email-moyufeng@huawei.com>
 <20210829165725.p7tbqwdeaugekb3v@lion.mk-sys.cz>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <amitc@mellanox.com>,
        <idosch@idosch.org>, <andrew@lunn.ch>, <o.rempel@pengutronix.de>,
        <f.fainelli@gmail.com>, <jacob.e.keller@intel.com>,
        <mlxsw@mellanox.com>, <netdev@vger.kernel.org>,
        <lipeng321@huawei.com>, <linuxarm@huawei.com>,
        <linuxarm@openeuler.org>, <moyufeng@huawei.com>
From:   moyufeng <moyufeng@huawei.com>
Message-ID: <8908eb5b-4797-ddb2-b196-d502f03e9796@huawei.com>
Date:   Mon, 30 Aug 2021 09:46:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20210829165725.p7tbqwdeaugekb3v@lion.mk-sys.cz>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/8/30 0:57, Michal Kubecek wrote:
> On Fri, Aug 27, 2021 at 02:06:48PM +0800, Yufeng Mo wrote:
>> Add support for "ethtool -c <dev> cqe-mode-rx/cqe-mode-tx on/off"
>> for setting coalesce cqe mode.
>>
>> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
>> ---
>>  ethtool.c          |  2 ++
>>  netlink/coalesce.c | 15 +++++++++++++++
>>  2 files changed, 17 insertions(+)
> 
> Please update also the man page (file ethtool.8.in) to show the new
> parameters.
> 
> Michal
> 
ok, thanks

>> diff --git a/ethtool.c b/ethtool.c
>> index 2486caa..a6826e9 100644
>> --- a/ethtool.c
>> +++ b/ethtool.c
>> @@ -5703,6 +5703,8 @@ static const struct option args[] = {
>>  			  "		[tx-usecs-high N]\n"
>>  			  "		[tx-frames-high N]\n"
>>  			  "		[sample-interval N]\n"
>> +			  "		[cqe-mode-rx on|off]\n"
>> +			  "		[cqe-mode-tx on|off]\n"
>>  	},
>>  	{
>>  		.opts	= "-g|--show-ring",
>> diff --git a/netlink/coalesce.c b/netlink/coalesce.c
>> index 75922a9..762d0e3 100644
>> --- a/netlink/coalesce.c
>> +++ b/netlink/coalesce.c
>> @@ -66,6 +66,9 @@ int coalesce_reply_cb(const struct nlmsghdr *nlhdr, void *data)
>>  	show_u32(tb[ETHTOOL_A_COALESCE_TX_USECS_HIGH], "tx-usecs-high: ");
>>  	show_u32(tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH], "tx-frame-high: ");
>>  	putchar('\n');
>> +	show_bool("rx", "CQE mode RX: %s  ",
>> +		  tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_RX]);
>> +	show_bool("tx", "TX: %s\n", tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_TX]);
>>  
>>  	return MNL_CB_OK;
>>  }
>> @@ -226,6 +229,18 @@ static const struct param_parser scoalesce_params[] = {
>>  		.handler	= nl_parse_direct_u32,
>>  		.min_argc	= 1,
>>  	},
>> +	{
>> +		.arg		= "cqe-mode-rx",
>> +		.type		= ETHTOOL_A_COALESCE_USE_CQE_MODE_RX,
>> +		.handler	= nl_parse_u8bool,
>> +		.min_argc	= 1,
>> +	},
>> +	{
>> +		.arg		= "cqe-mode-tx",
>> +		.type		= ETHTOOL_A_COALESCE_USE_CQE_MODE_TX,
>> +		.handler	= nl_parse_u8bool,
>> +		.min_argc	= 1,
>> +	},
>>  	{}
>>  };
>>  
>> -- 
>> 2.8.1
>>
