Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1D9633B86
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbiKVLhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233483AbiKVLhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:37:12 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE8C4045C;
        Tue, 22 Nov 2022 03:32:00 -0800 (PST)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NGhpg5BX8zJnph;
        Tue, 22 Nov 2022 19:28:43 +0800 (CST)
Received: from [10.174.179.215] (10.174.179.215) by
 canpemm500007.china.huawei.com (7.192.104.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 19:31:58 +0800
Subject: Re: [PATCH -next] crypto: ccree - Fix section mismatch due to
 cc_debugfs_global_fini()
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "s.shtylyov@omp.ru" <s.shtylyov@omp.ru>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20221122030542.23920-1-yuehaibing@huawei.com>
 <e3a466e7-5c5d-1288-9918-982edf597c24@huawei.com>
 <OS0PR01MB59224447AE5AB1A04567EBF2860D9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <e1fd1bf8-d97a-5881-c4f2-ec5ef563e11a@huawei.com>
Date:   Tue, 22 Nov 2022 19:31:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB59224447AE5AB1A04567EBF2860D9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
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

On 2022/11/22 19:24, Biju Das wrote:
>> Subject: Re: [PATCH -next] crypto: ccree - Fix section mismatch due to
>> cc_debugfs_global_fini()
>>
>> Sorry， Pls ignore this.
> 
> This is real issue, right?
> 
> "WARNING: modpost: drivers/crypto/ccree/ccree.o: section mismatch in
> reference: init_module (section: .init.text) -> cc_debugfs_global_fini
> (section: .exit.text)"
> 
> 
> Looks like the committer of the patch without building submitted the patch.
> 4f1c596df706 ("crypto: ccree - Remove debugfs when platform_driver_register failed")
> 

Yes, I send the patch to wrong mail list. A new version has sent.

https://lore.kernel.org/lkml/20221122030555.26612-1-yuehaibing@huawei.com/

> Cheers,
> Biju
> 
> 
>>
>> On 2022/11/22 11:05, YueHaibing wrote:
>>> cc_debugfs_global_fini() is marked with __exit now, however it is used
>>> in __init ccree_init() for cleanup. Remove the __exit annotation to
>>> fix build warning:
>>>
>>> WARNING: modpost: drivers/crypto/ccree/ccree.o: section mismatch in
>>> reference: init_module (section: .init.text) -> cc_debugfs_global_fini
>>> (section: .exit.text)
>>>
>>> Fixes: 4f1c596df706 ("crypto: ccree - Remove debugfs when
>>> platform_driver_register failed")
>>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>>> ---
>>>  drivers/crypto/ccree/cc_debugfs.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/crypto/ccree/cc_debugfs.c
>>> b/drivers/crypto/ccree/cc_debugfs.c
>>> index 7083767602fc..8f008f024f8f 100644
>>> --- a/drivers/crypto/ccree/cc_debugfs.c
>>> +++ b/drivers/crypto/ccree/cc_debugfs.c
>>> @@ -55,7 +55,7 @@ void __init cc_debugfs_global_init(void)
>>>  	cc_debugfs_dir = debugfs_create_dir("ccree", NULL);  }
>>>
>>> -void __exit cc_debugfs_global_fini(void)
>>> +void cc_debugfs_global_fini(void)
>>>  {
>>>  	debugfs_remove(cc_debugfs_dir);
>>>  }
