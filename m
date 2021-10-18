Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00879431A78
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 15:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhJRNQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 09:16:11 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:25229 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhJRNQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 09:16:09 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HXy3H1SVBz8thx;
        Mon, 18 Oct 2021 21:12:43 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 18 Oct 2021 21:13:55 +0800
Received: from [10.174.176.245] (10.174.176.245) by
 kwepemm600001.china.huawei.com (7.193.23.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 18 Oct 2021 21:13:54 +0800
Subject: Re: [PATCH net] mwifiex: Fix possible memleak in probe and disconnect
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <shenyang39@huawei.com>,
        <marcelo@kvack.org>, <linville@tuxdriver.com>,
        <luisca@cozybit.com>, <libertas-dev@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20211018063818.1895774-1-wanghai38@huawei.com>
 <163456107685.11105.13969946027999768773.kvalo@codeaurora.org>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <dc70c674-c47e-9afc-afb8-918f1e22c54d@huawei.com>
Date:   Mon, 18 Oct 2021 21:13:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <163456107685.11105.13969946027999768773.kvalo@codeaurora.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.245]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/10/18 20:44, Kalle Valo 写道:
> Wang Hai <wanghai38@huawei.com> wrote:
>
>> I got memory leak as follows when doing fault injection test:
>>
>> unreferenced object 0xffff888031c2f000 (size 512):
>>    comm "kworker/0:2", pid 165, jiffies 4294922253 (age 391.180s)
>>    hex dump (first 32 bytes):
>>      00 20 f7 08 80 88 ff ff 01 00 00 00 00 00 00 00  . ..............
>>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>    backtrace:
>>      [<00000000537bdb86>] kmem_cache_alloc_trace+0x16d/0x360
>>      [<0000000047666fab>] if_usb_probe+0x90/0x96e [usb8xxx]
>>      [<00000000de44b4f0>] usb_probe_interface+0x31b/0x800 [usbcore]
>>      [<000000009b1a1951>] really_probe+0x299/0xc30
>>      [<0000000055b8ffce>] __driver_probe_device+0x357/0x500
>>      [<00000000bb0c7161>] driver_probe_device+0x4e/0x140
>>      [<00000000866d1730>] __device_attach_driver+0x257/0x340
>>      [<0000000084e79b96>] bus_for_each_drv+0x166/0x1e0
>>      [<000000009bad60ea>] __device_attach+0x272/0x420
>>      [<00000000236b97c1>] bus_probe_device+0x1eb/0x2a0
>>      [<000000008d77d7cf>] device_add+0xbf0/0x1cd0
>>      [<000000004af6a3f0>] usb_set_configuration+0x10fb/0x18d0 [usbcore]
>>      [<000000002ebdfdcd>] usb_generic_driver_probe+0xa2/0xe0 [usbcore]
>>      [<00000000444f344d>] usb_probe_device+0xe4/0x2b0 [usbcore]
>>      [<000000009b1a1951>] really_probe+0x299/0xc30
>>      [<0000000055b8ffce>] __driver_probe_device+0x357/0x500
>>
>> cardp is missing being freed in the error handling path of the probe
>> and the path of the disconnect, which will cause kmemleak.
>>
>> This patch adds the missing free().
>>
>> Fixes: 876c9d3aeb98 ("[PATCH] Marvell Libertas 8388 802.11b/g USB driver")
>> Fixes: c305a19a0d0a ("libertas_tf: usb specific functions")
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> mwifiex patches are applied to wireless-drivers, not to the net tree. Please be
> careful how you mark your patches.
Thanks for the reminder, I will pay attention to it in the future.

-- 
Wang Hai

