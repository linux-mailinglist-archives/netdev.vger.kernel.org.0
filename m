Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E5B30937D
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbhA3DLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 22:11:04 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:1373 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233382AbhA3DIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 22:08:25 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6014c5e40001>; Fri, 29 Jan 2021 18:35:16 -0800
Received: from [172.27.8.81] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 30 Jan
 2021 02:35:13 +0000
Subject: Re: [PATCH net-next v4] net: psample: Introduce stubs to remove NIC
 driver dependency
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <jiri@nvidia.com>, <saeedm@nvidia.com>,
        "kernel test robot" <lkp@intel.com>
References: <20210128014543.521151-1-cmi@nvidia.com>
 <20210129135056.0e6733eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Chris Mi <cmi@nvidia.com>
Message-ID: <5b7a1928-be3f-4fa5-b9d2-0851d72ef542@nvidia.com>
Date:   Sat, 30 Jan 2021 10:35:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210129135056.0e6733eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611974116; bh=On+Kc2ovPKhQKvm+lyWInGNhk5fY3TIzMcKgpUrEWKo=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=QGGgdrlZAHqv9pk01Z0HSVqBksqFqnqFN/e9BIR/9mcGvlk8vuhYDU4cigcWZdIQ5
         z4M+tmUjuRaYPJWyJPFgIeHEjHDnMV3ja9nYBrdyHQDB3XCYnBx0DPGxgKQ9ua8xKt
         agYmlsI5OYUR05CsBlOjpxXC5DmULvT3RKaCyDrkSGjjhvsAFi2JUaHLx6/bB3m3lf
         kGx1cCWbzDsw3sI8zRmsI3uftLP/UY3hut+OcdlrFkidsnGCXAuVDHtbqjOJe6JRZt
         dUsLBKauhKLVIToyFFlYxjF9j0Plq6Jg85eYIOae02yuMRr7LySOtUHuY0eeYRhshL
         9s7PxbXlYTOrA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/30/2021 5:50 AM, Jakub Kicinski wrote:
> On Thu, 28 Jan 2021 09:45:43 +0800 Chris Mi wrote:
>> In order to send sampled packets to userspace, NIC driver calls
>> psample api directly. But it creates a hard dependency on module
>> psample. Introduce psample_ops to remove the hard dependency.
>> It is initialized when psample module is loaded and set to NULL
>> when the module is unloaded.
>>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Chris Mi <cmi@nvidia.com>
>> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
>> diff --git a/include/net/psample.h b/include/net/psample.h
>> index 68ae16bb0a4a..e6a73128de59 100644
>> --- a/include/net/psample.h
>> +++ b/include/net/psample.h
>> @@ -4,6 +4,7 @@
>>   
>>   #include <uapi/linux/psample.h>
>>   #include <linux/list.h>
>> +#include <linux/skbuff.h>
> Forward declaration should be enough.
Done.
>
>>   struct psample_group {
>>   	struct list_head list;
>>   static void __exit psample_module_exit(void)
>>   {
>> +	RCU_INIT_POINTER(psample_ops, NULL);
> I think you can use rcu_assign_pointer(), it handles constants
> right these days.
Done.
>
> Please add a comment here saying that you depend on
> genl_unregister_family() executing synchronize_rcu()
> and name the function where it does so.
I added synchronize_rcu() here directly. Maybe it's more clear.
>
>>   	genl_unregister_family(&psample_nl_family);
>>   }
>> diff --git a/net/sched/psample_stub.c b/net/sched/psample_stub.c
>> new file mode 100644
>> index 000000000000..0615a7b64000
>> --- /dev/null
>> +++ b/net/sched/psample_stub.c
>> @@ -0,0 +1,7 @@
>> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
>> +/* Copyright (c) 2021 Mellanox Technologies. */
>> +
>> +#include <net/psample.h>
> Forward declaration is sufficient.
Done.

Thanks,
Chris
>
>> +const struct psample_ops __rcu *psample_ops __read_mostly;
>> +EXPORT_SYMBOL_GPL(psample_ops);

