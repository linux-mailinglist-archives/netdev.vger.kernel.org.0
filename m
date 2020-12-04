Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174D52CEC07
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 11:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729798AbgLDKTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 05:19:55 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9014 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729514AbgLDKTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 05:19:54 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CnTFD1s3hzhk8n;
        Fri,  4 Dec 2020 18:18:40 +0800 (CST)
Received: from [10.174.177.230] (10.174.177.230) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Fri, 4 Dec 2020 18:19:03 +0800
Subject: Re: [PATCH net] xsk: Fix error return code in __xp_assign_dev()
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
CC:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1607071819-34127-1-git-send-email-zhangchangzhong@huawei.com>
 <CAJ8uoz0LCkR+zHKSto9JyTqeybRXqF1SbH_B6cBHu9n5r-UXKA@mail.gmail.com>
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
Message-ID: <fcb6b23a-4ecc-465e-6716-0725c9610da7@huawei.com>
Date:   Fri, 4 Dec 2020 18:18:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CAJ8uoz0LCkR+zHKSto9JyTqeybRXqF1SbH_B6cBHu9n5r-UXKA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.230]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 
> Good catch! My intention here by not setting err is that it should
> fall back to copy mode, which it does. The problem is that the
> force_zc flag is disregarded when err is not set (see exit code below)
> and your patch fixes that. If force_zc is set, we should exit out with
> an error, not fall back. Could you please write about this in your
> cover letter and send a v2?
> 

Thanks for the suggestion, I have sent the v2 patch, please take another look.

> BTW, what is the "Hulk Robot" that is in your Reported-by tag?

It's an auto tester, here is some information: https://lwn.net/Articles/804119/

> 
> Thank you: Magnus
> 
> err_unreg_xsk:
>         xp_disable_drv_zc(pool);
> err_unreg_pool:
>         if (!force_zc)
>                 err = 0; /* fallback to copy mode */
>         if (err)
>                 xsk_clear_pool_at_qid(netdev, queue_id);
>         return err;
> 
>>                 goto err_unreg_xsk;
>>         }
>>         pool->umem->zc = true;
>> --
>> 2.9.5
>>
> .
> 
