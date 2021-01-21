Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4420E2FDF0D
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 02:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392868AbhAUBvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 20:51:40 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:2793 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392187AbhAUBlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 20:41:36 -0500
Received: from dggeme714-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4DLlR21Dn7z13jld;
        Thu, 21 Jan 2021 09:38:38 +0800 (CST)
Received: from [127.0.0.1] (10.69.26.252) by dggeme714-chm.china.huawei.com
 (10.1.199.110) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2106.2; Thu, 21
 Jan 2021 09:40:27 +0800
Subject: Re: [PATCH net-next] net: hns3: debugfs add dump tm info of nodes,
 priority and qset
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        Guangbin Huang <huangguangbin2@huawei.com>
References: <1610694569-43099-1-git-send-email-tanhuazhong@huawei.com>
 <20210116182306.65a268a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d2fc48f6-aa2f-081a-dbce-312b869b8e04@huawei.com>
 <20210118114820.4e40a6ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <970b8526-6470-ffe1-5bb9-58693ac54582@huawei.com>
 <20210118194328.36d1e8c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Huazhong Tan <tanhuazhong@huawei.com>
Message-ID: <94855f6a-c286-272d-7c0b-29228700ce4f@huawei.com>
Date:   Thu, 21 Jan 2021 09:40:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20210118194328.36d1e8c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.69.26.252]
X-ClientProxiedBy: dggeme718-chm.china.huawei.com (10.1.199.114) To
 dggeme714-chm.china.huawei.com (10.1.199.110)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/19 11:43, Jakub Kicinski wrote:
> On Tue, 19 Jan 2021 11:14:51 +0800 Huazhong Tan wrote:
>> On 2021/1/19 3:48, Jakub Kicinski wrote:
>>> On Mon, 18 Jan 2021 19:20:23 +0800 Huazhong Tan wrote:
>>>> On 2021/1/17 10:23, Jakub Kicinski wrote:
>>>>> On Fri, 15 Jan 2021 15:09:29 +0800 Huazhong Tan wrote:
>>>>>> From: Guangbin Huang <huangguangbin2@huawei.com>
>>>>>>
>>>>>> To increase methods to dump more tm info, adds three debugfs commands
>>>>>> to dump tm info of nodes, priority and qset. And a new tm file of debugfs
>>>>>> is created for only dumping tm info.
>>>>>>
>>>>>> Unlike previous debugfs commands, to dump each tm information, user needs
>>>>>> to enter two commands now. The first command writes parameters to tm and
>>>>>> the second command reads info from tm. For examples, to dump tm info of
>>>>>> priority 0, user needs to enter follow two commands:
>>>>>> 1. echo dump priority 0 > tm
>>>>>> 2. cat tm
>>>>>>
>>>>>> The reason for adding new tm file is because we accepted Jakub Kicinski's
>>>>>> opinion as link https://lkml.org/lkml/2020/9/29/2101. And in order to
>>>>>> avoid generating too many files, we implement write ops to allow user to
>>>>>> input parameters.
>>>>> Why are you trying to avoid generating too many files? How many files
>>>>> would it be? What's the size of each dump/file?
>>>> The maximum number of tm node, priority and qset are 8, 256,
>>>> 1280, if we create a file for each one, then there are 8 node
>>>> files, 256 priority files, 1280 qset files. It seems a little
>>>> bit hard for using as well.
>>> Would the information not fit in one file per type with multiple rows?
>> What you means is as below ?
>>
>> estuary:/debugfs/hns3/0000:7d:00.0$ cat qset
>>
>> qset id: 0
>> QS map pri id: 0
>> QS map link_vld: 1
>> QS schedule mode: dwrr
>> QS dwrr: 100
>>
>> qset id: 1
>> QS map pri id: 0
>> QS map link_vld: 0
>> QS schedule mode: sp
>> QS dwrr: 0
>>
>> ...
> I was thinking more like:
>
> ID	PRI	LINK_VLD	MODE	DWRR
> 0	0	1		dwrr	0
> 1	0	0		sp	0
> ...
>
>
> but the exact format is up to you.


It looks better.


>> For example, user want to query qset 1, then all qset info will be output,
> I hope you don't mean end user when you say _user_.  This is debugfs,
> it's intended for developers to debug issues and system dump to gather
> info at customer site.


yes


>> there are too many useless info.
>>
>> So we add an interface to designage the specified id for node, priority
>> or qset.
>>
>>> Can you show example outputs?
>>
>> here is the output of this patch.
>>
>> estuary:/debugfs/hns3/0000:7d:00.0$ echo dump qset 0 > tm
>> estuary:/debugfs/hns3/0000:7d:00.0$ cat tm
>> qset id: 0
>> QS map pri id: 0
>> QS map link_vld: 1
>> QS schedule mode: dwrr
>> QS dwrr: 100
> Thanks. Not that much info per entry, as expected. Single file should
> do nicely.

Ok.

Will send V2 to do that.

Thanks.

> .

