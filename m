Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56323296A05
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 09:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S375511AbgJWHB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 03:01:29 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15249 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S373767AbgJWHB2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 03:01:28 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7C66D80E0F5DC6CC8815;
        Fri, 23 Oct 2020 15:01:25 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Fri, 23 Oct 2020 15:01:15 +0800
Subject: Re: [PATCH net] net: hns3: Clear the CMDQ registers before unmapping
 BAR region
To:     Yunsheng Lin <linyunsheng@huawei.com>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wanghaibin.wang@huawei.com>, <tanhuazhong@huawei.com>
References: <20201023051550.793-1-yuzenghui@huawei.com>
 <3c5c98f9-b4a0-69a2-d58d-bfef977c68ad@huawei.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <e74f0a72-92d1-2ac9-1f4b-191477d673ef@huawei.com>
Date:   Fri, 23 Oct 2020 15:01:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <3c5c98f9-b4a0-69a2-d58d-bfef977c68ad@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/10/23 14:22, Yunsheng Lin wrote:
> On 2020/10/23 13:15, Zenghui Yu wrote:
>> When unbinding the hns3 driver with the HNS3 VF, I got the following
>> kernel panic:
>>
>> [  265.709989] Unable to handle kernel paging request at virtual address ffff800054627000
>> [  265.717928] Mem abort info:
>> [  265.720740]   ESR = 0x96000047
>> [  265.723810]   EC = 0x25: DABT (current EL), IL = 32 bits
>> [  265.729126]   SET = 0, FnV = 0
>> [  265.732195]   EA = 0, S1PTW = 0
>> [  265.735351] Data abort info:
>> [  265.738227]   ISV = 0, ISS = 0x00000047
>> [  265.742071]   CM = 0, WnR = 1
>> [  265.745055] swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000009b54000
>> [  265.751753] [ffff800054627000] pgd=0000202ffffff003, p4d=0000202ffffff003, pud=00002020020eb003, pmd=00000020a0dfc003, pte=0000000000000000
>> [  265.764314] Internal error: Oops: 96000047 [#1] SMP
>> [  265.830357] CPU: 61 PID: 20319 Comm: bash Not tainted 5.9.0+ #206
>> [  265.836423] Hardware name: Huawei TaiShan 2280 V2/BC82AMDDA, BIOS 1.05 09/18/2019
>> [  265.843873] pstate: 80400009 (Nzcv daif +PAN -UAO -TCO BTYPE=--)
>> [  265.843890] pc : hclgevf_cmd_uninit+0xbc/0x300
>> [  265.861988] lr : hclgevf_cmd_uninit+0xb0/0x300
>> [  265.861992] sp : ffff80004c983b50
>> [  265.881411] pmr_save: 000000e0
>> [  265.884453] x29: ffff80004c983b50 x28: ffff20280bbce500
>> [  265.889744] x27: 0000000000000000 x26: 0000000000000000
>> [  265.895034] x25: ffff800011a1f000 x24: ffff800011a1fe90
>> [  265.900325] x23: ffff0020ce9b00d8 x22: ffff0020ce9b0150
>> [  265.905616] x21: ffff800010d70e90 x20: ffff800010d70e90
>> [  265.910906] x19: ffff0020ce9b0080 x18: 0000000000000004
>> [  265.916198] x17: 0000000000000000 x16: ffff800011ae32e8
>> [  265.916201] x15: 0000000000000028 x14: 0000000000000002
>> [  265.916204] x13: ffff800011ae32e8 x12: 0000000000012ad8
>> [  265.946619] x11: ffff80004c983b50 x10: 0000000000000000
>> [  265.951911] x9 : ffff8000115d0888 x8 : 0000000000000000
>> [  265.951914] x7 : ffff800011890b20 x6 : c0000000ffff7fff
>> [  265.951917] x5 : ffff80004c983930 x4 : 0000000000000001
>> [  265.951919] x3 : ffffa027eec1b000 x2 : 2b78ccbbff369100
>> [  265.964487] x1 : 0000000000000000 x0 : ffff800054627000
>> [  265.964491] Call trace:
>> [  265.964494]  hclgevf_cmd_uninit+0xbc/0x300
>> [  265.964496]  hclgevf_uninit_ae_dev+0x9c/0xe8
>> [  265.964501]  hnae3_unregister_ae_dev+0xb0/0x130
>> [  265.964516]  hns3_remove+0x34/0x88 [hns3]
>> [  266.009683]  pci_device_remove+0x48/0xf0
>> [  266.009692]  device_release_driver_internal+0x114/0x1e8
>> [  266.030058]  device_driver_detach+0x28/0x38
>> [  266.034224]  unbind_store+0xd4/0x108
>> [  266.037784]  drv_attr_store+0x40/0x58
>> [  266.041435]  sysfs_kf_write+0x54/0x80
>> [  266.045081]  kernfs_fop_write+0x12c/0x250
>> [  266.049076]  vfs_write+0xc4/0x248
>> [  266.052378]  ksys_write+0x74/0xf8
>> [  266.055677]  __arm64_sys_write+0x24/0x30
>> [  266.059584]  el0_svc_common.constprop.3+0x84/0x270
>> [  266.064354]  do_el0_svc+0x34/0xa0
>> [  266.067658]  el0_svc+0x38/0x40
>> [  266.070700]  el0_sync_handler+0x8c/0xb0
>> [  266.074519]  el0_sync+0x140/0x180
>>
>> It looks like the BAR memory region had already been unmapped before we
>> start clearing CMDQ registers in it, which is pretty bad and the kernel
>> happily kills itself because of a Current EL Data Abort (on arm64).
>>
>> Moving the CMDQ uninitialization a bit early fixes the issue for me.
> 
> Yes, this seems a obvious bug, and below patch seems the obvious fix too.
> 
> We has testcase to test the loading and unloading process, but does not
> seem to catch this error, and testing it again using the latest internal
> version seems ok too:

I don't have access to the internal version ;-) I use mainline instead.

> [root@localhost ~]# rmmod hclgevf
> [ 8035.010715] hns3 0000:7d:01.0 eth8: net stop
> [ 8035.079917] hns3 0000:7d:01.0 eth8: link down
> [ 8036.402491] hns3 0000:7d:01.1 eth9: net stop
> [ 8036.472946] hns3 0000:7d:01.1 eth9: link down
> [root@localhost ~]# rmmod hns3
> [ 8045.938705] hns3 0000:bd:00.3 eth7: net stop
> [ 8046.354308] hns3 0000:bd:00.2 eth6: net stop
> [ 8046.627653] hns3 0000:bd:00.1 eth5: net stop
> [ 8046.632251] hns3 0000:bd:00.1 eth5: link down
> [ 8047.050235] hns3 0000:bd:00.0 eth4: net stop
> [ 8047.054837] hns3 0000:bd:00.0 eth4: link down
> [ 8047.340528] hns3 0000:7d:00.3 eth3: net stop
> [ 8047.347633] hns3 0000:7d:00.3 eth3: link down
> [ 8048.879299] hns3 0000:7d:00.2 eth2: net stop
> [ 8050.271999] hns3 0000:7d:00.1 eth1: net stop
> [ 8050.278755] hns3 0000:7d:00.1 eth1: link down
> [ 8051.650607] pci 0000:7d:01.0: Removing from iommu group 44
> [ 8051.657909] pci 0000:7d:01.1: Removing from iommu group 45
> [ 8052.794671] hns3 0000:7d:00.0 eth0: net stop
> [ 8052.800385] hns3 0000:7d:00.0 eth0: link down
> [root@localhost ~]#
> [root@localhost ~]#
> 
> 
> Do you care to provide the testcase for above calltrace?

I noticed it with VFIO, but it's easy to reproduce it manually. Here you
go:

   # cat /sys/bus/pci/devices/0000\:7d\:00.2/sriov_totalvfs
3
   # echo 3 > /sys/bus/pci/devices/0000\:7d\:00.2/sriov_numvfs
   # lspci | grep "Virtual Function"
7d:01.6 Ethernet controller: Huawei Technologies Co., Ltd. HNS RDMA 
Network Controller (Virtual Function) (rev 21)
7d:01.7 Ethernet controller: Huawei Technologies Co., Ltd. HNS RDMA 
Network Controller (Virtual Function) (rev 21)
7d:02.0 Ethernet controller: Huawei Technologies Co., Ltd. HNS RDMA 
Network Controller (Virtual Function) (rev 21)
   # echo 0000:7d:01.6 > /sys/bus/pci/devices/0000:7d:01.6/driver/unbind


Thanks

>>
>> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
>> ---
>>
>> I have almost zero knowledge about the hns3 driver. You can regard this
>> as a report and make a better fix if possible.
>>
>> I can't even figure out that how can we live with this issue for a long
>> time... It should exists since commit 34f81f049e35 ("net: hns3: clear
>> command queue's registers when unloading VF driver"), where we start
>> writing something into the unmapped area.
>>
>>   drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
>> index 50c84c5e65d2..c8e3fdd5999c 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
>> @@ -3262,8 +3262,8 @@ static void hclgevf_uninit_hdev(struct hclgevf_dev *hdev)
>>   		hclgevf_uninit_msi(hdev);
>>   	}
>>   
>> -	hclgevf_pci_uninit(hdev);
>>   	hclgevf_cmd_uninit(hdev);
>> +	hclgevf_pci_uninit(hdev);
>>   	hclgevf_uninit_mac_list(hdev);
>>   }
>>   
>>
> .
> 
