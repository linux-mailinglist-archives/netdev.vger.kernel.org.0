Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93BD66639AE
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 08:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbjAJHFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 02:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbjAJHFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 02:05:21 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3EF6657B;
        Mon,  9 Jan 2023 23:05:19 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NrhcB3HtDznVB9;
        Tue, 10 Jan 2023 15:03:38 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Tue, 10 Jan 2023 15:05:11 +0800
Message-ID: <b44a75c9-078a-d4ed-8313-45428e8ec8b0@huawei.com>
Date:   Tue, 10 Jan 2023 15:05:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH v2] Bluetooth: hci_sync: fix memory leak in
 hci_update_adv_data()
To:     <linux-bluetooth@vger.kernel.org>, <netdev@vger.kernel.org>,
        <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <brian.gix@intel.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>
References: <20230110064420.3409168-1-shaozhengchao@huawei.com>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <20230110064420.3409168-1-shaozhengchao@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Sorry for Repeatedly senting. Please ignore this patch.

On 2023/1/10 14:44, Zhengchao Shao wrote:
> When hci_cmd_sync_queue() failed in hci_update_adv_data(), inst_ptr is
> not freed, which will cause memory leak. ERR_PTR/PTR_ERR is used to
> replace memory allocation to simplify code.
> 
> Fixes: 651cd3d65b0f ("Bluetooth: convert hci_update_adv_data to hci_sync")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
> v2: Use ERR_PTR/PTR_ERR to replace memory allocation
> ---
>   net/bluetooth/hci_sync.c | 10 ++--------
>   1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> index 9e2d7e4b850c..8744bbecac9e 100644
> --- a/net/bluetooth/hci_sync.c
> +++ b/net/bluetooth/hci_sync.c
> @@ -6187,20 +6187,14 @@ int hci_get_random_address(struct hci_dev *hdev, bool require_privacy,
>   
>   static int _update_adv_data_sync(struct hci_dev *hdev, void *data)
>   {
> -	u8 instance = *(u8 *)data;
> -
> -	kfree(data);
> +	u8 instance = PTR_ERR(data);
>   
>   	return hci_update_adv_data_sync(hdev, instance);
>   }
>   
>   int hci_update_adv_data(struct hci_dev *hdev, u8 instance)
>   {
> -	u8 *inst_ptr = kmalloc(1, GFP_KERNEL);
> -
> -	if (!inst_ptr)
> -		return -ENOMEM;
> +	u8 *inst_ptr = ERR_PTR(instance);
>   
> -	*inst_ptr = instance;
>   	return hci_cmd_sync_queue(hdev, _update_adv_data_sync, inst_ptr, NULL);
>   }
