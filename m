Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 088996EFFD6
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 05:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242723AbjD0Dax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 23:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241612AbjD0Dav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 23:30:51 -0400
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5263A90;
        Wed, 26 Apr 2023 20:30:49 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R751e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=24;SR=0;TI=SMTPD_---0Vh5kUNz_1682566243;
Received: from 30.221.149.75(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0Vh5kUNz_1682566243)
          by smtp.aliyun-inc.com;
          Thu, 27 Apr 2023 11:30:44 +0800
Message-ID: <a8555236-2bef-b0fb-d8a8-dde3058a2271@linux.alibaba.com>
Date:   Thu, 27 Apr 2023 11:30:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH bpf-next 2/5] net/smc: allow smc to negotiate protocols on
 policies
Content-Language: en-US
To:     Kui-Feng Lee <sinquersw@gmail.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        pabeni@redhat.com, song@kernel.org, sdf@google.com,
        haoluo@google.com, yhs@fb.com, edumazet@google.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, jolsa@kernel.org,
        guwen@linux.alibaba.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
References: <1682501055-4736-1-git-send-email-alibuda@linux.alibaba.com>
 <1682501055-4736-3-git-send-email-alibuda@linux.alibaba.com>
 <8e1694ec-9acf-a4bd-4dd2-28a258e1436b@gmail.com>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <8e1694ec-9acf-a4bd-4dd2-28a258e1436b@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-11.3 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Lee,


On 4/27/23 12:47 AM, Kui-Feng Lee wrote:
>
>
> On 4/26/23 02:24, D. Wythe wrote:
>> From: "D. Wythe" <alibuda@linux.alibaba.com>
>> diff --git a/net/smc/bpf_smc.c b/net/smc/bpf_smc.c
>> new file mode 100644
>> index 0000000..0c0ec05
>> --- /dev/null
>> +++ b/net/smc/bpf_smc.c
>> @@ -0,0 +1,201 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
> ... cut ...

Will fix it, Thanks.

>> +
>> +/* register ops */
>> +int smc_sock_register_negotiator_ops(struct smc_sock_negotiator_ops 
>> *ops)
>> +{
>> +    int ret;
>> +
>> +    ret = smc_sock_validate_negotiator_ops(ops);
>> +    if (ret)
>> +        return ret;
>> +
>> +    /* calt key by name hash */
>> +    ops->key = jhash(ops->name, sizeof(ops->name), strlen(ops->name));
>> +
>> +    spin_lock(&smc_sock_negotiator_list_lock);
>> +    if (smc_negotiator_ops_get_by_key(ops->key)) {
>> +        pr_notice("smc: %s negotiator already registered\n", 
>> ops->name);
>> +        ret = -EEXIST;
>> +    } else {
>> +        list_add_tail_rcu(&ops->list, &smc_sock_negotiator_list);
>> +    }
>> +    spin_unlock(&smc_sock_negotiator_list_lock);
>> +    return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(smc_sock_register_negotiator_ops);
>
> This and following functions are not specific to BPF, right?
> I found you have more BPF specific code in this file in following
> patches.  But, I feel these function should not in this file since
> they are not BPF specific because file name "bpf_smc.c" hints.

Yes. Logically those functions are not suitable for being placed in 
"bpf_smc.c".
However, since SMC is compiled as modules by default, and currently
struct ops needs to be built in, or specific symbols will not be found 
during linking.

Of course, I can separate those this function in another new file, which 
can also be built in.
I may have to introduce a new KConfig likes SMC_NEGOTIATOR. But this 
feature is  only effective
when eBPF exists, so from the perspective of SMC, it would also be kind 
of weird.

But whatever, if you do think it's necessary, I can split it into two files.

Besh wishes.
D. Wythe



