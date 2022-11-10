Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C45806240AC
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 12:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbiKJLEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 06:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiKJLEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 06:04:36 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7338F6C738;
        Thu, 10 Nov 2022 03:04:35 -0800 (PST)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N7Jqq5PnjzHvp7;
        Thu, 10 Nov 2022 19:04:07 +0800 (CST)
Received: from [10.174.179.215] (10.174.179.215) by
 canpemm500007.china.huawei.com (7.192.104.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 19:04:32 +0800
Subject: Re: [PATCH v2] net/mlx5e: Use kvfree() in mlx5e_accel_fs_tcp_create()
To:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Eric Dumazet <edumazet@google.com>
CC:     <borisp@nvidia.com>, <saeedm@nvidia.com>, <leon@kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <lkayal@nvidia.com>, <tariqt@nvidia.com>, <markzhang@nvidia.com>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20221108140614.12968-1-yuehaibing@huawei.com>
 <febe8f20-626a-02d6-c8ed-f0dcf6cd607f@gmail.com>
 <CANn89iKqm9=uyoymd9OvASjnazQVKVW1kwOxhpazxv_FGaVpFg@mail.gmail.com>
 <ba0c84f1-1d99-c0e4-111d-bbd14047ca0b@gmail.com>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <611b2e05-0aca-68e3-b219-e851ce9eadd0@huawei.com>
Date:   Thu, 10 Nov 2022 19:04:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <ba0c84f1-1d99-c0e4-111d-bbd14047ca0b@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/11/10 15:31, Tariq Toukan wrote:
> 
> 
> On 11/8/2022 9:45 PM, Eric Dumazet wrote:
>> On Tue, Nov 8, 2022 at 9:58 AM Tariq Toukan <ttoukan.linux@gmail.com> wrote:
>>>
>>>
>>>
>>> On 11/8/2022 4:06 PM, YueHaibing wrote:
>>>> 'accel_tcp' is allocted by kvzalloc(), which should freed by kvfree().
>>>>
>>>> Fixes: f52f2faee581 ("net/mlx5e: Introduce flow steering API")
>>>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>>>> ---
>>>> v2: fix the same issue in mlx5e_accel_fs_tcp_destroy() and a commit log typo
>>>> ---
>>>>    drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c | 4 ++--
>>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
>>>> index 285d32d2fd08..d7c020f72401 100644
>>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
>>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
>>>> @@ -365,7 +365,7 @@ void mlx5e_accel_fs_tcp_destroy(struct mlx5e_flow_steering *fs)
>>>>        for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++)
>>>>                accel_fs_tcp_destroy_table(fs, i);
>>>>
>>>> -     kfree(accel_tcp);
>>>> +     kvfree(accel_tcp);
>>>>        mlx5e_fs_set_accel_tcp(fs, NULL);
>>>>    }
>>>>
>>>> @@ -397,7 +397,7 @@ int mlx5e_accel_fs_tcp_create(struct mlx5e_flow_steering *fs)
>>>>    err_destroy_tables:
>>>>        while (--i >= 0)
>>>>                accel_fs_tcp_destroy_table(fs, i);
>>>> -     kfree(accel_tcp);
>>>> +     kvfree(accel_tcp);
>>>>        mlx5e_fs_set_accel_tcp(fs, NULL);
>>>>        return err;
>>>>    }
>>>
>>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>>>
>>> Thanks for your patch.
>>
>> Although this structure is 64 bytes... Not sure why kvmalloc() has
>> been used for this small chunk.
> 
> It's a small chunk indeed. Unnecessary usage of kvmalloc.
> 
> Although it's not critical (used only in slowpath), it'd be nice to clean it up and directly call kzalloc, instead of aligning the kfree().
> 
> YueHaibing, can you please submit a v3 for this?

Sure， will resend.
> 
> Regards,
> Tariq
> .
