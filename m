Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 896E16B6E0D
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 04:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjCMDns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 23:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjCMDnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 23:43:46 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9632BEE8;
        Sun, 12 Mar 2023 20:43:44 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PZjCt6d1HzrSNJ;
        Mon, 13 Mar 2023 11:42:50 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Mon, 13 Mar
 2023 11:32:24 +0800
Subject: Re: [PATCH net v3] net: ravb: Fix possible UAF bug in ravb_remove
To:     Zheng Hacker <hackerzheng666@gmail.com>
CC:     Zheng Wang <zyytlz.wz@163.com>, <s.shtylyov@omp.ru>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <1395428693sheep@gmail.com>,
        <alex000young@gmail.com>
References: <20230311180630.4011201-1-zyytlz.wz@163.com>
 <57f6d87e-8bfb-40fc-7724-89676c2e75ef@huawei.com>
 <CAJedcCy8QOCv3SC-Li2JkaFEQydTDd1aiY77BHn7ht0Y8r1nUA@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <43a4a617-2633-a501-6fd1-b2495aed90f7@huawei.com>
Date:   Mon, 13 Mar 2023 11:32:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAJedcCy8QOCv3SC-Li2JkaFEQydTDd1aiY77BHn7ht0Y8r1nUA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/3/13 11:02, Zheng Hacker wrote:
> Yunsheng Lin <linyunsheng@huawei.com> 于2023年3月13日周一 09:15写道：
>>
>> On 2023/3/12 2:06, Zheng Wang wrote:
>>> In ravb_probe, priv->work was bound with ravb_tx_timeout_work.
>>> If timeout occurs, it will start the work. And if we call
>>> ravb_remove without finishing the work, there may be a
>>> use-after-free bug on ndev.
>>>
>>> Fix it by finishing the job before cleanup in ravb_remove.
>>>
>>> Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
>>> Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
>>> Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
>>> ---
>>> v3:
>>> - fix typo in commit message
>>> v2:
>>> - stop dev_watchdog so that handle no more timeout work suggested by Yunsheng Lin,
>>> add an empty line to make code clear suggested by Sergey Shtylyov
>>> ---
>>>  drivers/net/ethernet/renesas/ravb_main.c | 4 ++++
>>>  1 file changed, 4 insertions(+)
>>>
>>> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
>>> index 0f54849a3823..eb63ea788e19 100644
>>> --- a/drivers/net/ethernet/renesas/ravb_main.c
>>> +++ b/drivers/net/ethernet/renesas/ravb_main.c
>>> @@ -2892,6 +2892,10 @@ static int ravb_remove(struct platform_device *pdev)
>>>       struct ravb_private *priv = netdev_priv(ndev);
>>>       const struct ravb_hw_info *info = priv->info;
>>>
>>> +     netif_carrier_off(ndev);
>>> +     netif_tx_disable(ndev);
>>> +     cancel_work_sync(&priv->work);
>>
>> LGTM.
>> Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>
>>
>> As noted by Sergey, ravb_remove() and ravb_close() may
>> share the same handling, but may require some refactoring
>> in order to do that. So for a fix, it seems the easiest
>> way to just add the handling here.
> 
> Dear Yunsheng,
> 
> I think Sergey is right for I've seen other drivers' same handling
> logic. Do you think we should try to move the cancel-work-related code
> from ravb_remove to ravb_close funtion?
> Appreciate for your precise advice.

As Sergey question "can ravb_remove() be called without ravb_close()
having been called on the bound devices?"
If I understand it correctly, I think ravb_remove() can be called
without ravb_close() having been called on the bound devices. I am
happy to be corrected if I am wrong.

Yes, you can call *_close() directly in *_remove(), but that may
require some refactoring and a lot of testing.

Also, if you found the bug through some static analysis, it may
be better to make it clear in the commit log and share some info
about the static analysis, which I suppose it is a tool?

> 
> Best regards,
> Zheng
> 
>>
>>> +
>>>       /* Stop PTP Clock driver */
>>>       if (info->ccc_gac)
>>>               ravb_ptp_stop(ndev);
>>>
> .
> 
