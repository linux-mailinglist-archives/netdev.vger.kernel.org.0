Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 325C862F257
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 11:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241472AbiKRKSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 05:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239887AbiKRKST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 05:18:19 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B15511174
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 02:18:18 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NDCQm4tfDz15Mj6;
        Fri, 18 Nov 2022 18:17:52 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 18:18:16 +0800
Message-ID: <a6aec93a-1166-1d8a-48de-767bc1eb2214@huawei.com>
Date:   Fri, 18 Nov 2022 18:18:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH 0/3 v2] 9p: Fix write overflow in p9_read_work
Content-Language: en-US
To:     <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>
CC:     <ericvh@gmail.com>, <lucho@ionkov.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <v9fs-developer@lists.sourceforge.net>, <netdev@vger.kernel.org>
References: <20221117091159.31533-1-guozihua@huawei.com>
 <3918617.6eBe0Ihrjo@silver> <Y3cRJsRFCZaKrzhe@codewreck.org>
From:   "Guozihua (Scott)" <guozihua@huawei.com>
In-Reply-To: <Y3cRJsRFCZaKrzhe@codewreck.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/11/18 12:59, asmadeus@codewreck.org wrote:
> Christian Schoenebeck wrote on Thu, Nov 17, 2022 at 02:33:28PM +0100:
>>> GUO Zihua (3):
>>>    9p: Fix write overflow in p9_read_work
>>>    9p: Remove redundent checks for message size against msize.
>>>    9p: Use P9_HDRSZ for header size
>>
>> For entire series:
>>
>> Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
>>
>> I agree with Dominique that patch 1 and 2 should be merged.
> 
> Thank you both!
> 
> I've just pushed the patches to my next branch:
> https://github.com/martinetd/linux/commits/9p-next
> 
> ... with a twist, as the original patch fails on any normal workload:
> ---
> / # ls /mnt
> 9pnet: -- p9_read_work (19): requested packet size too big: 9 for tag 0 with capacity 11
> ---
> (so much for having two pairs of eyes :-D
> By the way we -really- need to replace P9_DEBUG_ERROR by pr_error or
> something, these should be displayed without having to specify
> debug=1...)
> 
> 
> capacity is only set in a handful of places (alloc time, hardcoded 7 in
> trans_fd, after receiving packet) so I've added logs and our alloc
> really passed '11' for alloc_rsize (logging tsize/rsize)
> 
> 9pnet: (00000087) >>> TWALK fids 1,2 nwname 0d wname[0] (null)
> 9pnet: -- p9_tag_alloc (87): allocating capacity to 17/11 for tag 0
> 9pnet: -- p9_read_work (19): requested packet size too big: 9 for tag 0 with capacity 11
> 
> ... So this is RWALK, right:
> size[4] Rwalk tag[2] nwqid[2] nwqid*(wqid[13])
> 4 ..... 5.... 7..... 9....... packet end at 9 as 0 nwqid.
> We have capacity 11 to allow rlerror_size which is bigger; everything is
> good.
> 
> Long story short, the size header includes the header size, when I
> misread https://9fans.github.io/plan9port/man/man9/version.html to
> say it didn't (it just says it doesn't include the enveloping transport
> protocol, it starts from size alright and I just misread that)
> Thanksfully the code caught it.
> 
> So I've just removed the - offset part and things appear to work again.
> 
> Guo Zihua, can you check this still fixes your syz repro, or was that
> substraction needed? If it's still needed we have an off by 1 somewhere
> to look for.
> 

Hi Dominique, I retried the repro on your branch, the issue does not 
reproduce. What a good pair of eyes :)！

-- 
Best
GUO Zihua

