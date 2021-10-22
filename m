Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B03C4373D1
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 10:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbhJVIqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 04:46:40 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:29926 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbhJVIqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 04:46:40 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HbHpT6WhGzbnNZ;
        Fri, 22 Oct 2021 16:39:45 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Fri, 22 Oct 2021 16:44:20 +0800
Received: from [10.174.176.245] (10.174.176.245) by
 kwepemm600001.china.huawei.com (7.193.23.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Fri, 22 Oct 2021 16:44:19 +0800
Subject: Re: [PATCH] Bluetooth: cmtp: fix possible panic when
 cmtp_init_sockets() fails
To:     Marcel Holtmann <marcel@holtmann.org>
CC:     Karsten Keil <isdn@linux-pingi.de>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        <linux-bluetooth@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20211022034417.766659-1-wanghai38@huawei.com>
 <9D8B1F5B-8EFE-40CB-BC85-F6EC3483CC61@holtmann.org>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <ca60862b-594f-3b79-5683-1e3d78811f42@huawei.com>
Date:   Fri, 22 Oct 2021 16:43:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <9D8B1F5B-8EFE-40CB-BC85-F6EC3483CC61@holtmann.org>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.245]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/10/22 12:48, Marcel Holtmann Ð´µÀ:
> Hi Wang,
>
>> I got a kernel BUG report when doing fault injection test:
>>
>> ------------[ cut here ]------------
>> kernel BUG at lib/list_debug.c:45!
>> ...
>> RIP: 0010:__list_del_entry_valid.cold+0x12/0x4d
>> ...
>> Call Trace:
>> proto_unregister+0x83/0x220
>> cmtp_cleanup_sockets+0x37/0x40 [cmtp]
>> cmtp_exit+0xe/0x1f [cmtp]
>> do_syscall_64+0x35/0xb0
>> entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> If cmtp_init_sockets() in cmtp_init() fails, cmtp_init() still returns
>> success. This will cause a kernel bug when accessing uncreated ctmp
>> related data when the module exits.
>>
>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Wang Hai <wanghai38@huawei.com>
>> ---
>> net/bluetooth/cmtp/core.c | 6 ++++--
>> 1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/bluetooth/cmtp/core.c b/net/bluetooth/cmtp/core.c
>> index 0a2d78e811cf..ccf48f50afdf 100644
>> --- a/net/bluetooth/cmtp/core.c
>> +++ b/net/bluetooth/cmtp/core.c
>> @@ -499,11 +499,13 @@ int cmtp_get_conninfo(struct cmtp_conninfo *ci)
>>
>> static int __init cmtp_init(void)
>> {
>> +	int err;
>> +
>> 	BT_INFO("CMTP (CAPI Emulation) ver %s", VERSION);
>>
>> -	cmtp_init_sockets();
>> +	err = cmtp_init_sockets();
>>
>> -	return 0;
>> +	return err;
>> }
> just do return cmtp_init_sockets();
>
> Regards
>
> Marcel
Ok, I will send v2
> .
>
-- 
Wang Hai

