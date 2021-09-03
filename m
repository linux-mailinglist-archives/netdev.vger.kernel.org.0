Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C68593FFC1F
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 10:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348380AbhICIgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 04:36:18 -0400
Received: from novek.ru ([213.148.174.62]:39838 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234851AbhICIgR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 04:36:17 -0400
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id AE3FD501B31;
        Fri,  3 Sep 2021 11:32:01 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru AE3FD501B31
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1630657927; bh=MsKybHT8RmQb65YwwSdgscWTSnQi+KQLM+kwYvpuBt8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=0BLFgPBiM0MrxdO52AV2Rw3fwQ/UvWKocBMx0Tb7BmI9zazHqWSEvr0T5JpAKNOaq
         mONw1zTu41RsNy3FK1P9qCtGhBMXQGy0GZTRIGCsv5iZ+9YhyfbkE5tDcJVdTSTZqr
         6d5/wp81HgIuVdHsayrlacju1kGg/B3074CeVcrg=
Subject: Re: [PATCH bpf-next 1/2] bpf: add hardware timestamp field to
 __sk_buff
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, willemb@google.com
References: <20210902221551.15566-1-vfedorenko@novek.ru>
 <20210902221551.15566-2-vfedorenko@novek.ru>
 <fd2e2457-b3c2-81a4-481a-27555e4473dc@iogearbox.net>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <f4616fe5-6850-1182-dc23-2a6d6375244a@novek.ru>
Date:   Fri, 3 Sep 2021 09:35:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <fd2e2457-b3c2-81a4-481a-27555e4473dc@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.09.2021 09:22, Daniel Borkmann wrote:
> On 9/3/21 12:15 AM, Vadim Fedorenko wrote:
>> BPF programs may want to know hardware timestamps if NIC supports
>> such timestamping.
>>
>> Expose this data as hwtstamp field of __sk_buff the same way as
>> gso_segs/gso_size.
>>
>> Also update BPF_PROG_TEST_RUN tests of the feature.
>>
>> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
>> ---
>>   include/uapi/linux/bpf.h       |  2 ++
>>   net/core/filter.c              | 11 +++++++++++
>>   tools/include/uapi/linux/bpf.h |  2 ++
>>   3 files changed, 15 insertions(+)
>>
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 791f31dd0abe..c7d05b49f557 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -5284,6 +5284,8 @@ struct __sk_buff {
>>       __u32 gso_segs;
>>       __bpf_md_ptr(struct bpf_sock *, sk);
>>       __u32 gso_size;
>> +    __u32 padding;        /* Padding, future use. */
> 
> nit, instead of explicit padding field, just use: __u32 :32;
> 
> Also please add test_verifier coverage for this in BPF selftests, meaning,
> the expectation would be in case someone tries to access the padding field
> with this patch that we get a 'bpf verifier is misconfigured' error given
> it would have no bpf_convert_ctx_access() translation. But it would be overall
> better to add this to bpf_skb_is_valid_access(), so we can reject access to
> the padding area right there instead.

Thanks Daniel, I will update it in v2

>> +    __u64 hwtstamp;
>>   };
>>   struct bpf_tunnel_key {
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 2e32cee2c469..1d8f8494d325 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -8884,6 +8884,17 @@ static u32 bpf_convert_ctx_access(enum bpf_access_type 
>> type,
>>                         si->dst_reg, si->src_reg,
>>                         offsetof(struct sk_buff, sk));
>>           break;
>> +    case offsetof(struct __sk_buff, hwtstamp):
>> +        BUILD_BUG_ON(sizeof_field(struct skb_shared_hwtstamps, hwtstamp) != 8);
>> +        BUILD_BUG_ON(offsetof(struct skb_shared_hwtstamps, hwtstamp) != 0);
>> +
>> +        insn = bpf_convert_shinfo_access(si, insn);
>> +        *insn++ = BPF_LDX_MEM(BPF_DW,
>> +                      si->dst_reg, si->dst_reg,
>> +                      bpf_target_off(struct skb_shared_info,
>> +                             hwtstamps, 8,
>> +                             target_size));
>> +        break;
>>       }
>>       return insn - insn_buf;
>> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
>> index 791f31dd0abe..c7d05b49f557 100644
>> --- a/tools/include/uapi/linux/bpf.h
>> +++ b/tools/include/uapi/linux/bpf.h
>> @@ -5284,6 +5284,8 @@ struct __sk_buff {
>>       __u32 gso_segs;
>>       __bpf_md_ptr(struct bpf_sock *, sk);
>>       __u32 gso_size;
>> +    __u32 padding;        /* Padding, future use. */
>> +    __u64 hwtstamp;
>>   };
>>   struct bpf_tunnel_key {
>>
> 

