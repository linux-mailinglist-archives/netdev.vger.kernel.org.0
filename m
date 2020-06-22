Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDFB202E36
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 04:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731012AbgFVCFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 22:05:14 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2525 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726602AbgFVCFO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 22:05:14 -0400
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 5E7D43C679A44B4457E8;
        Mon, 22 Jun 2020 10:05:09 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 22 Jun 2020 10:05:07 +0800
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Mon, 22 Jun 2020 10:05:07 +0800
Subject: Re: [PATCH net-next v1 5/5] hinic: add support to get eeprom
 information
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
References: <20200620094258.13181-1-luobin9@huawei.com>
 <20200620094258.13181-6-luobin9@huawei.com> <20200620160038.GQ304147@lunn.ch>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <14f91738-ae07-f56d-bf77-1cedb6d842d6@huawei.com>
Date:   Mon, 22 Jun 2020 10:05:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200620160038.GQ304147@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme708-chm.china.huawei.com (10.1.199.104) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/6/21 0:00, Andrew Lunn wrote:
>> +static int hinic_get_module_eeprom(struct net_device *netdev,
>> +				   struct ethtool_eeprom *ee, u8 *data)
>> +{
>> +	struct hinic_dev *nic_dev = netdev_priv(netdev);
>> +	u8 sfp_data[STD_SFP_INFO_MAX_SIZE];
> 
> sfp_data will contain whatever is on the stack.
> 
>> +	u16 len;
>> +	int err;
>> +
>> +	if (!ee->len || ((ee->len + ee->offset) > STD_SFP_INFO_MAX_SIZE))
>> +		return -EINVAL;
>> +
>> +	memset(data, 0, ee->len);
> 
> This clears what you are going to return.
> 
>> +
>> +	err = hinic_get_sfp_eeprom(nic_dev->hwdev, sfp_data, &len);
> 
> Upto len bytes of sfp_data now contain useful data. The rest of
> sfp_data is still stack data.
> 
> 
>> +	if (err)
>> +		return err;
>> +
>> +	memcpy(data, sfp_data + ee->offset, ee->len);
> 
> If len < ee->len, you have just returned to user space some stack data.
> 
>    Andrew
> .
> 
The whole sfp_data will be assigned values in hinic_get_sfp_eeprom function,
so stack data won't be returned to user space. Thanks for your review.
