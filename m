Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F325AD1E0A
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 03:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732621AbfJJBdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 21:33:22 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:45454 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731589AbfJJBdW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 21:33:22 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 475FF8DF00DC2B6C8ED0;
        Thu, 10 Oct 2019 09:33:20 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Thu, 10 Oct 2019
 09:33:09 +0800
Subject: Re: [RFC PATCH] net: hns3: add devlink health dump support for hw mac
 tbl
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     <jiri@mellanox.com>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linuxarm@huawei.com>
References: <1569759223-200101-1-git-send-email-linyunsheng@huawei.com>
 <20190930092724.GB2211@nanopsycho>
 <f82df09f-fe13-5583-2cac-5ceaf3aeff2a@huawei.com>
Message-ID: <a5b5c5c5-8e48-260d-8631-62d94f779ca7@huawei.com>
Date:   Thu, 10 Oct 2019 09:32:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <f82df09f-fe13-5583-2cac-5ceaf3aeff2a@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/10/5 10:06, Yunsheng Lin wrote:
> On 2019/9/30 17:27, Jiri Pirko wrote:
>> Sun, Sep 29, 2019 at 02:13:43PM CEST, linyunsheng@huawei.com wrote:
>>> This patch adds the devlink health dump support for hw mac tbl,
>>> which helps to debug some hardware packet switching problem or
>>> misconfiguation of the hardware mac table.
>>
>> So you basically make internal hw table available to the user to see if
>> I understand that correctly. There is a "devlink dpipe" api that
>> basically serves the purpose of describing the hw pipeline and also
>> allows user to see content of individual tables in the pipeline. Perhaps
>> that would be more suitable for you?
>>
> 
> Thanks.
> I will look into the "devlink dpipe" api.
> It seems the dpipe api is a little complicated than health api, and
> there seems to be no mention of it in man page in below:
> http://man7.org/linux/man-pages/man8/devlink.8.html
> 
> Any more detail info about "devlink dpipe" api would be very helpful.

After looking into "devlink dpipe" api, it seems dpipe is used to debug
match and action operation of a hardware table.

We might be able to use "devlink dpipe" api for dumping the mac tbl in
our hardware if we extend the action type.
But I am not sure a few field in our hw table below to match or action
operation, like the type(0 for unicast and 2 for multicast) field, it is
used to tell hardware the specfic entry is about unicast or multicast,
so that the hardware does a different processing when a packet is matched,
it is more like the property of the specfic entry.

So the health dump is flexible enough for us to dump the hw table in
our hardware, we plan to use health dump api instead of dpipe api.

If we implement the recover ops, we can reuse the dump ops to dump the
hw table the moment the erorr happens too.

> 
>>
>>>
>>> And diagnose and recover support has not been added because
>>> RAS and misc error handling has done the recover process, we
>>> may also support the recover process through the devlink health
>>> api in the future.
>>
>> What would be the point for the reporter and what would you recover
>> from? It that related to the mac table? How?
> 
> There is some error that can be detected by hw when it is accessing some
> internal memory, such as below error types defined in
> ethernet/hisilicon/hns3/hns3pf/hclge_err.c:
> 
> static const struct hclge_hw_error hclge_ppp_mpf_abnormal_int_st1[] = {
> 	{ .int_msk = BIT(0), .msg = "vf_vlan_ad_mem_ecc_mbit_err",
> 	  .reset_level = HNAE3_GLOBAL_RESET },
> 	{ .int_msk = BIT(1), .msg = "umv_mcast_group_mem_ecc_mbit_err",
> 	  .reset_level = HNAE3_GLOBAL_RESET },
> 	{ .int_msk = BIT(2), .msg = "umv_key_mem0_ecc_mbit_err",
> 	  .reset_level = HNAE3_GLOBAL_RESET },
> 	{ .int_msk = BIT(3), .msg = "umv_key_mem1_ecc_mbit_err",
> 	  .reset_level = HNAE3_GLOBAL_RESET },
> .....
> 
> The above errors can be reported to the driver through struct pci_error_handlers
> api, and the driver can record the error and recover the error by asserting a PF
> or global reset according to the error type.
> 
> As for the relation to the mac table, we may need to dump everything including
> the internal memory content to further analyze the root cause of the problem.
> 
> Does above make sense?
> 
> Thanks for taking a look at this.
> 
>>
>>
>>>
>>> Command example and output:
>>>
>>> root@(none):~# devlink health dump show pci/0000:7d:00.2 reporter hw_mac_tbl
>>> index: 556 mac: 33:33:00:00:00:01 vlan: 0 port: 0 type: 2 mc_mac_en: 1 egress_port: 255 egress_queue: 0 vsi: 0 mc bitmap:
>>>   1 0 0 0 0 0 0 0
>>> index: 648 mac: 00:18:2d:02:00:10 vlan: 0 port: 1 type: 0 mc_mac_en: 0 egress_port: 2 egress_queue: 0 vsi: 0
>>> index: 728 mac: 00:18:2d:00:00:10 vlan: 0 port: 0 type: 0 mc_mac_en: 0 egress_port: 0 egress_queue: 0 vsi: 0
>>> index: 1028 mac: 00:18:2d:01:00:10 vlan: 0 port: 2 type: 0 mc_mac_en: 0 egress_port: 1 egress_queue: 0 vsi: 0
>>> index: 1108 mac: 00:18:2d:03:00:10 vlan: 0 port: 3 type: 0 mc_mac_en: 0 egress_port: 3 egress_queue: 0 vsi: 0
>>> index: 1204 mac: 33:33:00:00:00:01 vlan: 0 port: 1 type: 2 mc_mac_en: 1 egress_port: 253 egress_queue: 0 vsi: 0 mc bitmap:
>>>   4 0 0 0 0 0 0 0
>>> index: 2844 mac: 01:00:5e:00:00:01 vlan: 0 port: 0 type: 2 mc_mac_en: 1 egress_port: 254 egress_queue: 0 vsi: 0 mc bitmap:
>>>   1 0 0 0 0 0 0 0
>>> index: 3460 mac: 01:00:5e:00:00:01 vlan: 0 port: 1 type: 2 mc_mac_en: 1 egress_port: 252 egress_queue: 0 vsi: 0 mc bitmap:
>>>   4 0 0 0 0 0 0 0
>>>
>>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>>> ---


