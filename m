Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0506278BA
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 10:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236727AbiKNJJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 04:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236444AbiKNJJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 04:09:07 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5BD1D64C;
        Mon, 14 Nov 2022 01:08:46 -0800 (PST)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N9k4S6xhDzmVvC;
        Mon, 14 Nov 2022 17:08:24 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 17:08:44 +0800
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 17:08:44 +0800
Subject: Re: linux-next: build failure after merge of the modules tree
To:     Jiri Olsa <olsajiri@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC:     Luis Chamberlain <mcgrof@kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Linux Next Mailing List" <linux-next@vger.kernel.org>
References: <20221114111350.38e44eec@canb.auug.org.au>
 <Y3H12Xyt8ALo+HAU@krava>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <4d2bd614-028e-ec8c-597c-56353a0a4ccf@huawei.com>
Date:   Mon, 14 Nov 2022 17:08:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <Y3H12Xyt8ALo+HAU@krava>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/11/14 16:01, Jiri Olsa wrote:
> On Mon, Nov 14, 2022 at 11:13:50AM +1100, Stephen Rothwell wrote:
>> Hi all,
>>
>> After merging the modules tree, today's linux-next build (powerpc
>> ppc64_defconfig) failed like this:
>>
>> kernel/trace/ftrace.c: In function 'ftrace_lookup_symbols':
>> kernel/trace/ftrace.c:8316:52: error: passing argument 1 of 'module_kallsyms_on_each_symbol' from incompatible pointer type [-Werror=incompatible-pointer-types]
>>  8316 |         found_all = module_kallsyms_on_each_symbol(kallsyms_callback, &args);
>>       |                                                    ^~~~~~~~~~~~~~~~~
>>       |                                                    |
>>       |                                                    int (*)(void *, const char *, long unsigned int)
>> In file included from include/linux/device/driver.h:21,
>>                  from include/linux/device.h:32,
>>                  from include/linux/node.h:18,
>>                  from include/linux/cpu.h:17,
>>                  from include/linux/stop_machine.h:5,
>>                  from kernel/trace/ftrace.c:17:
>> include/linux/module.h:882:48: note: expected 'const char *' but argument is of type 'int (*)(void *, const char *, long unsigned int)'
>>   882 | int module_kallsyms_on_each_symbol(const char *modname,
>>       |                                    ~~~~~~~~~~~~^~~~~~~
>> kernel/trace/ftrace.c:8316:71: error: passing argument 2 of 'module_kallsyms_on_each_symbol' from incompatible pointer type [-Werror=incompatible-pointer-types]
>>  8316 |         found_all = module_kallsyms_on_each_symbol(kallsyms_callback, &args);
>>       |                                                                       ^~~~~
>>       |                                                                       |
>>       |                                                                       struct kallsyms_data *
>> include/linux/module.h:883:42: note: expected 'int (*)(void *, const char *, long unsigned int)' but argument is of type 'struct kallsyms_data *'
>>   883 |                                    int (*fn)(void *, const char *, unsigned long),
>>       |                                    ~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> kernel/trace/ftrace.c:8316:21: error: too few arguments to function 'module_kallsyms_on_each_symbol'
>>  8316 |         found_all = module_kallsyms_on_each_symbol(kallsyms_callback, &args);
>>       |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> include/linux/module.h:882:5: note: declared here
>>   882 | int module_kallsyms_on_each_symbol(const char *modname,
>>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>
>> Caused by commit
>>
>>   90de88426f3c ("livepatch: Improve the search performance of module_kallsyms_on_each_symbol()")
>>
>> from the modules tree interatcing with commit
>>
>>   3640bf8584f4 ("ftrace: Add support to resolve module symbols in ftrace_lookup_symbols")
>>
>> from the next-next tree.
>>
>> I have no idea how to easily fix this up, so I have used the modules
>> tree from next-20221111 for today in the hope someone will send me a fix.
> 
> hi,
> there's no quick fix.. I sent follow up email to the original
> change and cc-ed you

The fastest fix is drop my patch 7/9, 8/9, they depend on the interface change
of patch 6/9，but other patches don't rely on either of them.. And I can repost
them after v6.2-rc1.

Otherwise, you'll need to modify your patch, take the module reference before
invoking callback and put it after it is called, without passing modname.


> 
> thanks,
> jirka
> .
> 

-- 
Regards,
  Zhen Lei
