Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03475FE6B8
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 03:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiJNBx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 21:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiJNBx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 21:53:28 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F7F18982A;
        Thu, 13 Oct 2022 18:53:26 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MpTqt6pYKzDsVV;
        Fri, 14 Oct 2022 09:50:50 +0800 (CST)
Received: from [10.67.111.192] (10.67.111.192) by
 kwepemi500013.china.huawei.com (7.221.188.120) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 14 Oct 2022 09:53:23 +0800
Message-ID: <86c88c01-22eb-b7f8-9c65-0faf97b4096b@huawei.com>
Date:   Fri, 14 Oct 2022 09:53:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v4 2/6] libbpf: Fix memory leak in
 parse_usdt_arg()
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Xu Kuohai <xukuohai@huaweicloud.com>
CC:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Delyan Kratunov <delyank@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
References: <20221011120108.782373-1-xukuohai@huaweicloud.com>
 <20221011120108.782373-3-xukuohai@huaweicloud.com>
 <CAEf4BzZVYO42kDcmNqorLfwJcMcN7fyTLdp2GWbGfV5akP12GQ@mail.gmail.com>
From:   Xu Kuohai <xukuohai@huawei.com>
In-Reply-To: <CAEf4BzZVYO42kDcmNqorLfwJcMcN7fyTLdp2GWbGfV5akP12GQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.192]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/2022 11:47 PM, Andrii Nakryiko wrote:
> On Tue, Oct 11, 2022 at 4:43 AM Xu Kuohai <xukuohai@huaweicloud.com> wrote:
>>
>> From: Xu Kuohai <xukuohai@huawei.com>
>>
>> In the arm64 version of parse_usdt_arg(), when sscanf returns 2, reg_name
>> is allocated but not freed. Fix it.
>>
>> Fixes: 0f8619929c57 ("libbpf: Usdt aarch64 arg parsing support")
>> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
>> ---
>>   tools/lib/bpf/usdt.c | 11 ++++-------
>>   1 file changed, 4 insertions(+), 7 deletions(-)
>>
>> diff --git a/tools/lib/bpf/usdt.c b/tools/lib/bpf/usdt.c
>> index e83b497c2245..49f3c3b7f609 100644
>> --- a/tools/lib/bpf/usdt.c
>> +++ b/tools/lib/bpf/usdt.c
>> @@ -1348,25 +1348,23 @@ static int calc_pt_regs_off(const char *reg_name)
>>
>>   static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec *arg)
>>   {
>> -       char *reg_name = NULL;
>> +       char reg_name[16];
>>          int arg_sz, len, reg_off;
>>          long off;
>>
>> -       if (sscanf(arg_str, " %d @ \[ %m[a-z0-9], %ld ] %n", &arg_sz, &reg_name, &off, &len) == 3) {
>> +       if (sscanf(arg_str, " %d @ \[ %15[a-z0-9], %ld ] %n", &arg_sz, reg_name, &off, &len) == 3) {
> 
> It would be nice to do the same change for other architectures where
> it makes sense and avoid having to deal with unnecessary memory
> allocations. Please send follow up patches with similar changes for
> other implementations of parse_usdt_arg. Thanks.
>

ok, will do

> 
>>                  /* Memory dereference case, e.g., -4@[sp, 96] */
>>                  arg->arg_type = USDT_ARG_REG_DEREF;
>>                  arg->val_off = off;
>>                  reg_off = calc_pt_regs_off(reg_name);
>> -               free(reg_name);
>>                  if (reg_off < 0)
>>                          return reg_off;
>>                  arg->reg_off = reg_off;
>> -       } else if (sscanf(arg_str, " %d @ \[ %m[a-z0-9] ] %n", &arg_sz, &reg_name, &len) == 2) {
>> +       } else if (sscanf(arg_str, " %d @ \[ %15[a-z0-9] ] %n", &arg_sz, reg_name, &len) == 2) {
>>                  /* Memory dereference case, e.g., -4@[sp] */
>>                  arg->arg_type = USDT_ARG_REG_DEREF;
>>                  arg->val_off = 0;
>>                  reg_off = calc_pt_regs_off(reg_name);
>> -               free(reg_name);
>>                  if (reg_off < 0)
>>                          return reg_off;
>>                  arg->reg_off = reg_off;
>> @@ -1375,12 +1373,11 @@ static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec
>>                  arg->arg_type = USDT_ARG_CONST;
>>                  arg->val_off = off;
>>                  arg->reg_off = 0;
>> -       } else if (sscanf(arg_str, " %d @ %m[a-z0-9] %n", &arg_sz, &reg_name, &len) == 2) {
>> +       } else if (sscanf(arg_str, " %d @ %15[a-z0-9] %n", &arg_sz, reg_name, &len) == 2) {
>>                  /* Register read case, e.g., -8@x4 */
>>                  arg->arg_type = USDT_ARG_REG;
>>                  arg->val_off = 0;
>>                  reg_off = calc_pt_regs_off(reg_name);
>> -               free(reg_name);
>>                  if (reg_off < 0)
>>                          return reg_off;
>>                  arg->reg_off = reg_off;
>> --
>> 2.30.2
>>
> .

