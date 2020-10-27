Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFAD629A22B
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 02:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503832AbgJ0BYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 21:24:20 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5169 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409216AbgJ0BYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 21:24:19 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CKvBF6gphz15M7B;
        Tue, 27 Oct 2020 09:24:21 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Tue, 27 Oct 2020 09:24:11 +0800
Subject: Re: [PATCH net] net: hns3: Clear the CMDQ registers before unmapping
 BAR region
To:     Jakub Kicinski <kuba@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
CC:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wanghaibin.wang@huawei.com>,
        <tanhuazhong@huawei.com>
References: <20201023051550.793-1-yuzenghui@huawei.com>
 <3c5c98f9-b4a0-69a2-d58d-bfef977c68ad@huawei.com>
 <e74f0a72-92d1-2ac9-1f4b-191477d673ef@huawei.com>
 <20201026161325.6f33d9c8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <bca7fb17-2390-7ff3-d62d-fe279af6a225@huawei.com>
Date:   Tue, 27 Oct 2020 09:24:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20201026161325.6f33d9c8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/10/27 7:13, Jakub Kicinski wrote:
> On Fri, 23 Oct 2020 15:01:14 +0800 Zenghui Yu wrote:
>> On 2020/10/23 14:22, Yunsheng Lin wrote:
>>> On 2020/10/23 13:15, Zenghui Yu wrote:  
>>>> When unbinding the hns3 driver with the HNS3 VF, I got the following
>>>> kernel panic:
>>>>
>>>> [  265.709989] Unable to handle kernel paging request at virtual address ffff800054627000
>>>> [  265.717928] Mem abort info:
>>>> [  265.720740]   ESR = 0x96000047
>>>> [  265.723810]   EC = 0x25: DABT (current EL), IL = 32 bits
>>>> [  265.729126]   SET = 0, FnV = 0
>>>> [  265.732195]   EA = 0, S1PTW = 0
>>>> [  265.735351] Data abort info:
>>>> [  265.738227]   ISV = 0, ISS = 0x00000047
>>>> [  265.742071]   CM = 0, WnR = 1
>>>> [  265.745055] swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000009b54000
>>>> [  265.751753] [ffff800054627000] pgd=0000202ffffff003, p4d=0000202ffffff003, pud=00002020020eb003, pmd=00000020a0dfc003, pte=0000000000000000
>>>> [  265.764314] Internal error: Oops: 96000047 [#1] SMP
>>>> [  265.830357] CPU: 61 PID: 20319 Comm: bash Not tainted 5.9.0+ #206
>>>> [  265.836423] Hardware name: Huawei TaiShan 2280 V2/BC82AMDDA, BIOS 1.05 09/18/2019
>>>
>>> Do you care to provide the testcase for above calltrace?  
>>
>> I noticed it with VFIO, but it's easy to reproduce it manually. Here you
>> go:
>>
>>    # cat /sys/bus/pci/devices/0000\:7d\:00.2/sriov_totalvfs
>> 3
>>    # echo 3 > /sys/bus/pci/devices/0000\:7d\:00.2/sriov_numvfs
>>    # lspci | grep "Virtual Function"
>> 7d:01.6 Ethernet controller: Huawei Technologies Co., Ltd. HNS RDMA 
>> Network Controller (Virtual Function) (rev 21)
>> 7d:01.7 Ethernet controller: Huawei Technologies Co., Ltd. HNS RDMA 
>> Network Controller (Virtual Function) (rev 21)
>> 7d:02.0 Ethernet controller: Huawei Technologies Co., Ltd. HNS RDMA 
>> Network Controller (Virtual Function) (rev 21)
>>    # echo 0000:7d:01.6 > /sys/bus/pci/devices/0000:7d:01.6/driver/unbind
> 
> Do you know if the bug occurred on 5.4? Is this the correct fixes tag?
> 
> Fixes: 862d969a3a4d ("net: hns3: do VF's pci re-initialization while PF doing FLR")

The correct Fixes tag should be:

Fixes: e3338205f0c7 ("net: hns3: uninitialize pci in the hclgevf_uninit")

Thanks

> 
> .
> 
