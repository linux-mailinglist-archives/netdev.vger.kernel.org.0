Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C78F6A54C9
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 09:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbjB1IvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 03:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjB1Iut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 03:50:49 -0500
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF91E2BF31;
        Tue, 28 Feb 2023 00:50:29 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VciREhF_1677574225;
Received: from 30.221.150.82(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VciREhF_1677574225)
          by smtp.aliyun-inc.com;
          Tue, 28 Feb 2023 16:50:26 +0800
Message-ID: <5cef1246-5a84-b6e9-86aa-86a1cb6bd217@linux.alibaba.com>
Date:   Tue, 28 Feb 2023 16:50:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH bpf-next v2 1/2] net/smc: Introduce BPF injection
 capability for SMC
Content-Language: en-US
To:     Wenjia Zhang <wenjia@linux.ibm.com>, kgraul@linux.ibm.com,
        jaka@linux.ibm.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
References: <1676981919-64884-1-git-send-email-alibuda@linux.alibaba.com>
 <1676981919-64884-2-git-send-email-alibuda@linux.alibaba.com>
 <2972ad09-291b-0c34-fa35-b7852038b32f@linux.ibm.com>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <2972ad09-291b-0c34-fa35-b7852038b32f@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-10.0 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/27/23 3:58 PM, Wenjia Zhang wrote:
> 
> 
> On 21.02.23 13:18, D. Wythe wrote:
>> From: "D. Wythe" <alibuda@linux.alibaba.com>
>>
>> This PATCH attempts to introduce BPF injection capability for SMC.
>> As we all know that the SMC protocol is not suitable for all scenarios,
>> especially for short-lived. However, for most applications, they cannot
>> guarantee that there are no such scenarios at all. Therefore, apps
>> may need some specific strategies to decide shall we need to use SMC
>> or not, for example, apps can limit the scope of the SMC to a specific
>> IP address or port.

...

>> +static int bpf_smc_passive_sk_ops_check_member(const struct btf_type *t,
>> +                           const struct btf_member *member,
>> +                           const struct bpf_prog *prog)
>> +{
>> +    return 0;
>> +}
> 
> Please check the right pointer type of check_member:
> 
> int (*check_member)(const struct btf_type *t,
>              const struct btf_member *member);
> 

Hi Wenjia,

That's weird. the prototype of check_member on
latested net-next and bpf-next is:

struct bpf_struct_ops {
	const struct bpf_verifier_ops *verifier_ops;
	int (*init)(struct btf *btf);
	int (*check_member)(const struct btf_type *t,
			    const struct btf_member *member,
			    const struct bpf_prog *prog);
	int (*init_member)(const struct btf_type *t,
			   const struct btf_member *member,
			   void *kdata, const void *udata);
	int (*reg)(void *kdata);
	void (*unreg)(void *kdata);
	const struct btf_type *type;
	const struct btf_type *value_type;
	const char *name;
	struct btf_func_model func_models[BPF_STRUCT_OPS_MAX_NR_MEMBERS];
	u32 type_id;
	u32 value_id;
};

I wonder if there is any code out of sync?

And also I found that this patch is too complex and mixed with the code of two modules (smc & bpf).
I will split them out for easier review today.

Best wishes
D. Wythe

