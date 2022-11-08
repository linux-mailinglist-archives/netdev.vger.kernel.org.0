Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D2A6206E2
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 03:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbiKHCpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 21:45:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbiKHCpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 21:45:04 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2C22E9EB;
        Mon,  7 Nov 2022 18:45:02 -0800 (PST)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N5srf2Yq8z15MNw;
        Tue,  8 Nov 2022 10:44:50 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 10:45:00 +0800
Received: from [10.67.111.205] (10.67.111.205) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 10:44:59 +0800
Subject: Re: [PATCH bpf v2 3/5] libbpf: Skip adjust mem size for load pointer
 in 32-bit arch in CO_RE
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>,
        <illusionist.neo@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <mykolal@fb.com>, <shuah@kernel.org>,
        <benjamin.tissoires@redhat.com>, <memxor@gmail.com>,
        <asavkov@redhat.com>, <delyank@fb.com>, <bpf@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
References: <20221107092032.178235-1-yangjihong1@huawei.com>
 <20221107092032.178235-4-yangjihong1@huawei.com>
 <CAEf4BzZd+hzeRhLD6DaDVx67fySd+KaTP6eOJid-u9mqnQwigg@mail.gmail.com>
From:   Yang Jihong <yangjihong1@huawei.com>
Message-ID: <8911eeb0-d9a9-4592-34b5-e6e0a9efe692@huawei.com>
Date:   Tue, 8 Nov 2022 10:44:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZd+hzeRhLD6DaDVx67fySd+KaTP6eOJid-u9mqnQwigg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.205]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On 2022/11/8 9:22, Andrii Nakryiko wrote:
> On Mon, Nov 7, 2022 at 1:23 AM Yang Jihong <yangjihong1@huawei.com> wrote:
>>
>> bpf_core_patch_insn modifies load's mem size from 8 bytes to 4 bytes.
>> As a result, the bpf check fails, we need to skip adjust mem size to fit
>> the verifier.
>>
>> Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
>> ---
>>   tools/lib/bpf/libbpf.c | 34 +++++++++++++++++++++++++++++-----
>>   1 file changed, 29 insertions(+), 5 deletions(-)
>>
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index 184ce1684dcd..e1c21b631a0b 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -5634,6 +5634,28 @@ static int bpf_core_resolve_relo(struct bpf_program *prog,
>>                                         targ_res);
>>   }
>>
>> +static bool
>> +bpf_core_patch_insn_skip(const struct btf *local_btf, const struct bpf_insn *insn,
>> +                        const struct bpf_core_relo_res *res)
>> +{
>> +       __u8 class;
>> +       const struct btf_type *orig_t;
>> +
>> +       class = BPF_CLASS(insn->code);
>> +       orig_t = btf_type_by_id(local_btf, res->orig_type_id);
>> +
>> +       /*
>> +        * verifier has to see a load of a pointer as a 8-byte load,
>> +        * CO_RE should not screws up access, bpf_core_patch_insn modifies
>> +        * load's mem size from 8 bytes to 4 bytes in 32-bit arch,
>> +        * so we skip adjust mem size.
>> +        */
> 
> Nope, this is only for BPF UAPI context types like __sk_buff (right
> now). fentry/fexit/raw_tp_btf programs traversing kernel types and
> following pointers actually need this to work correctly. Don't do
> this.
Distinguishing BPF UAPI context from kernel type requires some work. 
According to current situation, the solution of patch2 is relatively simple.

Thanks,
Yang
