Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783CB5FACC1
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 08:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiJKG1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 02:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJKG1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 02:27:11 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F4487F98;
        Mon, 10 Oct 2022 23:27:10 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Mmm0n6Sv7zmV6S;
        Tue, 11 Oct 2022 14:22:33 +0800 (CST)
Received: from [10.67.111.192] (10.67.111.192) by
 kwepemi500013.china.huawei.com (7.221.188.120) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 11 Oct 2022 14:26:34 +0800
Message-ID: <a49eed59-8e26-fa9c-c7a6-8cb4656b0d55@huawei.com>
Date:   Tue, 11 Oct 2022 14:26:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH bpf v3 2/6] libbpf: Fix memory leak in parse_usdt_arg()
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
References: <20221010142553.776550-1-xukuohai@huawei.com>
 <20221010142553.776550-3-xukuohai@huawei.com>
 <CAEf4BzbJ8LW1Q_hBc-eB25f=F+jdQ5aPucEv_oDNrbjB=GGR+g@mail.gmail.com>
From:   Xu Kuohai <xukuohai@huawei.com>
In-Reply-To: <CAEf4BzbJ8LW1Q_hBc-eB25f=F+jdQ5aPucEv_oDNrbjB=GGR+g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.192]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/2022 9:34 AM, Andrii Nakryiko wrote:
> On Mon, Oct 10, 2022 at 7:08 AM Xu Kuohai <xukuohai@huawei.com> wrote:
>>
>> In the arm64 version of parse_usdt_arg(), when sscanf returns 2, reg_name
>> is allocated but not freed. Fix it.
>>
>> Fixes: 0f8619929c57 ("libbpf: Usdt aarch64 arg parsing support")
>> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
>> ---
>>   tools/lib/bpf/usdt.c | 59 +++++++++++++++++++++++++-------------------
>>   1 file changed, 33 insertions(+), 26 deletions(-)
>>
>> diff --git a/tools/lib/bpf/usdt.c b/tools/lib/bpf/usdt.c
>> index e83b497c2245..f3b5be7415b5 100644
>> --- a/tools/lib/bpf/usdt.c
>> +++ b/tools/lib/bpf/usdt.c
>> @@ -1351,8 +1351,10 @@ static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec
>>          char *reg_name = NULL;
>>          int arg_sz, len, reg_off;
>>          long off;
>> +       int ret;
>>
>> -       if (sscanf(arg_str, " %d @ \[ %m[a-z0-9], %ld ] %n", &arg_sz, &reg_name, &off, &len) == 3) {
>> +       ret = sscanf(arg_str, " %d @ \[ %m[a-z0-9], %ld ] %n", &arg_sz, &reg_name, &off, &len);
>> +       if (ret == 3) {
>>                  /* Memory dereference case, e.g., -4@[sp, 96] */
>>                  arg->arg_type = USDT_ARG_REG_DEREF;
>>                  arg->val_off = off;
>> @@ -1361,32 +1363,37 @@ static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec
>>                  if (reg_off < 0)
>>                          return reg_off;
>>                  arg->reg_off = reg_off;
>> -       } else if (sscanf(arg_str, " %d @ \[ %m[a-z0-9] ] %n", &arg_sz, &reg_name, &len) == 2) {
>> -               /* Memory dereference case, e.g., -4@[sp] */
>> -               arg->arg_type = USDT_ARG_REG_DEREF;
>> -               arg->val_off = 0;
>> -               reg_off = calc_pt_regs_off(reg_name);
>> -               free(reg_name);
>> -               if (reg_off < 0)
>> -                       return reg_off;
>> -               arg->reg_off = reg_off;
>> -       } else if (sscanf(arg_str, " %d @ %ld %n", &arg_sz, &off, &len) == 2) {
>> -               /* Constant value case, e.g., 4@5 */
>> -               arg->arg_type = USDT_ARG_CONST;
>> -               arg->val_off = off;
>> -               arg->reg_off = 0;
>> -       } else if (sscanf(arg_str, " %d @ %m[a-z0-9] %n", &arg_sz, &reg_name, &len) == 2) {
>> -               /* Register read case, e.g., -8@x4 */
>> -               arg->arg_type = USDT_ARG_REG;
>> -               arg->val_off = 0;
>> -               reg_off = calc_pt_regs_off(reg_name);
>> -               free(reg_name);
>> -               if (reg_off < 0)
>> -                       return reg_off;
>> -               arg->reg_off = reg_off;
>>          } else {
>> -               pr_warn("usdt: unrecognized arg #%d spec '%s'\n", arg_num, arg_str);
>> -               return -EINVAL;
>> +               if (ret == 2)
>> +                       free(reg_name);
>> +
>> +               if (sscanf(arg_str, " %d @ \[ %m[a-z0-9] ] %n", &arg_sz, &reg_name, &len) == 2) {
>> +                       /* Memory dereference case, e.g., -4@[sp] */
>> +                       arg->arg_type = USDT_ARG_REG_DEREF;
>> +                       arg->val_off = 0;
>> +                       reg_off = calc_pt_regs_off(reg_name);
>> +                       free(reg_name);
>> +                       if (reg_off < 0)
>> +                               return reg_off;
>> +                       arg->reg_off = reg_off;
>> +               } else if (sscanf(arg_str, " %d @ %ld %n", &arg_sz, &off, &len) == 2) {
>> +                       /* Constant value case, e.g., 4@5 */
>> +                       arg->arg_type = USDT_ARG_CONST;
>> +                       arg->val_off = off;
>> +                       arg->reg_off = 0;
>> +               } else if (sscanf(arg_str, " %d @ %m[a-z0-9] %n", &arg_sz, &reg_name, &len) == 2) {
>> +                       /* Register read case, e.g., -8@x4 */
>> +                       arg->arg_type = USDT_ARG_REG;
>> +                       arg->val_off = 0;
>> +                       reg_off = calc_pt_regs_off(reg_name);
>> +                       free(reg_name);
>> +                       if (reg_off < 0)
>> +                               return reg_off;
>> +                       arg->reg_off = reg_off;
>> +               } else {
>> +                       pr_warn("usdt: unrecognized arg #%d spec '%s'\n", arg_num, arg_str);
>> +                       return -EINVAL;
>> +               }
>>          }
>>
> 
> I think all this is more complicated than it has to be. How big  can
> register names be? Few characters? Let's get rid of %m[a-z0-9] and
> instead use fixed-max-length strings, e.g., %5s. And read register
> names into such local char buffers. It will simplify everything
> tremendously. Let's use 16-byte buffers and use %15s to match it?
> Would that be enough?
> 

The valid register names accepted by calc_pt_regs_off() are x0~x31 and sp, so
16-byte buffer is enough. Since %15s matches all non-space characters, will use
%15[a-z0-9] to match it.

>>          arg->arg_signed = arg_sz < 0;
>> --
>> 2.30.2
>>
> .

