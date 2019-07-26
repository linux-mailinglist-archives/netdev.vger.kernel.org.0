Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69F4D75CE7
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 04:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbfGZCVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 22:21:32 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2431 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725808AbfGZCVc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 22:21:32 -0400
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 1352BF589A1FF2D3A17D;
        Fri, 26 Jul 2019 10:21:30 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 26 Jul 2019 10:21:29 +0800
Received: from [127.0.0.1] (10.57.37.248) by dggeme760-chm.china.huawei.com
 (10.3.19.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Fri, 26
 Jul 2019 10:21:29 +0800
Subject: Re: [PATCH net-next 07/11] net: hns3: adds debug messages to identify
 eth down cause
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "tanhuazhong@huawei.com" <tanhuazhong@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "lipeng321@huawei.com" <lipeng321@huawei.com>,
        "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1563938327-9865-1-git-send-email-tanhuazhong@huawei.com>
 <1563938327-9865-8-git-send-email-tanhuazhong@huawei.com>
 <ffd942e7d7442549a3a6d469709b7f7405928afe.camel@mellanox.com>
 <30483e38-5e4a-0111-f431-4742ceb1aa62@huawei.com>
 <75a02bbe5b3b0f2755cd901a8830d4a3026f9383.camel@mellanox.com>
From:   liuyonglong <liuyonglong@huawei.com>
Message-ID: <9ae85be2-b958-ecb4-2980-ca7e977606a1@huawei.com>
Date:   Fri, 26 Jul 2019 10:21:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <75a02bbe5b3b0f2755cd901a8830d4a3026f9383.camel@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.57.37.248]
X-ClientProxiedBy: dggeme701-chm.china.huawei.com (10.1.199.97) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We will change all of them to netif_msg_drv() which is default off
Thanks for your reply!

On 2019/7/26 5:59, Saeed Mahameed wrote:
> On Thu, 2019-07-25 at 20:28 +0800, liuyonglong wrote:
>>
>> On 2019/7/25 3:12, Saeed Mahameed wrote:
>>> On Wed, 2019-07-24 at 11:18 +0800, Huazhong Tan wrote:
>>>> From: Yonglong Liu <liuyonglong@huawei.com>
>>>>
>>>> Some times just see the eth interface have been down/up via
>>>> dmesg, but can not know why the eth down. So adds some debug
>>>> messages to identify the cause for this.
>>>>
>>>
>>> I really don't like this. your default msg lvl has NETIF_MSG_IFDOWN
>>> turned on .. dumping every single operation that happens on your
>>> device
>>> by default to kernel log is too much ! 
>>>
>>> We should really consider using trace buffers with well defined
>>> structures for vendor specific events. so we can use bpf filters
>>> and
>>> state of the art tools for netdev debugging.
>>>
>>
>> We do this because we can just see a link down message in dmesg, and
>> had
>> take a long time to found the cause of link down, just because
>> another
>> user changed the settings.
>>
>> We can change the net_open/net_stop/dcbnl_ops to msg_drv (not default
>> turned on),  and want to keep the others default print to kernel log,
>> is it acceptable?
>>
> 
> acceptable as long as debug information are kept off by default and
> your driver doens't spam the kernel log.
> 
> you should use dynamic debug [1] and/or "off by default" msg lvls for
> debugging information..
> 
> I couldn't find any rules regarding what to put in kernel log, Maybe
> someone can share ?. but i vaguely remember that the recommendation
> for device drivers is to put nothing, only error/warning messages.
> 
> [1] 
> https://www.kernel.org/doc/html/v4.15/admin-guide/dynamic-debug-howto.html
> 
>>>> @@ -1593,6 +1603,11 @@ static int hns3_ndo_set_vf_vlan(struct
>>>> net_device *netdev, int vf, u16 vlan,
>>>>  	struct hnae3_handle *h = hns3_get_handle(netdev);
>>>>  	int ret = -EIO;
>>>>  
>>>> +	if (netif_msg_ifdown(h))
>>>
>>> why msg_ifdown ? looks like netif_msg_drv is more appropriate, for
>>> many
>>> of the cases in this patch.
>>>
>>
>> This operation may cause link down, so we use msg_ifdown.
>>
> 
> ifdown isn't link down.. 
> 
> to be honest, I couldn't find any documentation explaining how/when to
> use msg lvls, (i didn't look too deep though), by looking at other
> drivers, my interpretations is:
> 
> ifdup (open/boot up flow)
> ifdwon (close/teardown flow)
> drv (driver based or dynamic flows) 
> etc .. 
> 
> -Saeed.
> 

