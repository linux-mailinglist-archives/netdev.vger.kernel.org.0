Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74AA6137AFA
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 02:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgAKBvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 20:51:08 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:51004 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727833AbgAKBvI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 20:51:08 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D14DC7E5FFDB8F9333DE;
        Sat, 11 Jan 2020 09:51:05 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Sat, 11 Jan 2020
 09:51:00 +0800
Subject: Re: [PATCH v2 0/3] devlink region trigger support
To:     Jacob Keller <jacob.e.keller@intel.com>, <netdev@vger.kernel.org>
CC:     <valex@mellanox.com>, <jiri@resnulli.us>
References: <20200109193311.1352330-1-jacob.e.keller@intel.com>
 <4d8fe881-8d36-06dd-667a-276a717a0d89@huawei.com>
 <1d00deb9-16fc-b2a5-f8f7-5bb8316dbac2@intel.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <fe6c0d5e-5705-1118-1a71-80bd0e26a97e@huawei.com>
Date:   Sat, 11 Jan 2020 09:51:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <1d00deb9-16fc-b2a5-f8f7-5bb8316dbac2@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/1/11 1:52, Jacob Keller wrote:
> On 1/9/2020 8:10 PM, Yunsheng Lin wrote:
>> On 2020/1/10 3:33, Jacob Keller wrote:
>>> This series consists of patches to enable devlink to request a snapshot via
>>> a new DEVLINK_CMD_REGION_TRIGGER_SNAPSHOT.
>>>
>>> A reviewer might notice that the devlink health API already has such support
>>> for handling a similar case. However, the health API does not make sense in
>>> cases where the data is not related to an error condition.
>>
>> Maybe we need to specify the usecases for the region trigger as suggested by
>> Jacob.
>>
>> For example, the orginal usecase is to expose some set of flash/NVM contents.
>> But can it be used to dump the register of the bar space? or some binary
>> table in the hardware to debug some error that is not detected by hw?
>>
> 
> 
> regions can essentially be used to dump arbitrary addressable content. I
> think all of the above are great examples.
> 
> I have a series of patches to update and convert the devlink
> documentation, and I do provide some further detail in the new
> devlink-region.rst file.
> 
> Perhaps you could review that and provide suggestions on what would make
> sense to add there?

For the case of region for mlx4, I am not sure it worths the effort to
document it, because Jiri has mention that there was plan to convert mlx4 to
use "devlink health" api for the above case.

Also, there is dpipe, health and region api:
For health and region, they seems similar to me, and the non-essential
difference is:
1. health can be used used to dump content of tlv style, and can be triggered
   by driver automatically or by user manually.

2. region can be used to dump binary content and can be triggered by driver
   automatically only.

It would be good to merged the above to the same api(perhaps merge the binary
content dumping of region api to health api), then we can resue the same dump
ops for both driver and user triggering case.

For dpipe, it does not seems flexible enough to dump a table, yes, it provides
better visibility, but I am not sure it worth the effort, also, it would be better
to share the same table dump ops for driver and user triggering case.
For hns3 driver, we may have mac, vlan and flow director table that may need to dump
in both driver and user triggering case to debug some complex issues.

So It would be better to be able to dump table(maybe including binary table), binary
content and tlv content for a sinle api, I suppose the health api is the one to do
that? because health api has already supported driver and user triggering case, and
only need to add the table and binary content dumpping.


> 
> https://lore.kernel.org/netdev/20200109224625.1470433-13-jacob.e.keller@intel.com/
> 
> Thanks,
> Jake
> 
> .
> 

