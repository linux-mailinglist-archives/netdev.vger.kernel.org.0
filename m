Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03014610EB7
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 12:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiJ1KjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 06:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbiJ1Kip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 06:38:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C831C77CC
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 03:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666953439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rQlWIN7d57RONqQ/e3CUzK190bnqtzPjHOTosJNCfJ4=;
        b=gGFy3yPmeo3lq5o+otvkZ/Wo4l7YMp1aP97qlEXE80B/MEjzULvz3fYuc7euYOiP2v81ya
        EYf2gb6M79Jn/pyjutAhLQ336KGFZ0o3+T6adw5lKcI6nB9lIcM5quv6I/tp5UO6wqziqL
        cdCyOwQudU5HkSPP7FdqSAksXQYazVg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-542-ifaBCY_wOXqHMyzGkm-sig-1; Fri, 28 Oct 2022 06:37:18 -0400
X-MC-Unique: ifaBCY_wOXqHMyzGkm-sig-1
Received: by mail-ej1-f72.google.com with SMTP id ho8-20020a1709070e8800b0078db5e53032so2570926ejc.9
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 03:37:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rQlWIN7d57RONqQ/e3CUzK190bnqtzPjHOTosJNCfJ4=;
        b=F3MdrZgecalkC/Az5llFFn2mtKiWY5RngMgyLguJOdsWLkfrRuprQatcKZ2Kovtupj
         b0TjfXvvZN5Zf88o8giY5VBjSRhjPlAG4a7bqfZ/uiGxYU0wwZ+vRsC7/wGl48DADUhK
         UVLWGF0zw3q+0Fi0jOpMmuVm9ZiRlJTqPQ/P5vGfmyqX6C6fKlcKQlxeHor91QJwMV8R
         nQzuT6gzidjnSY8kj5QKDxQS4EVbG2750NJRbNII3RlAEmxE80ZnvXb4tHo6Npl3uB9X
         Do5JAzPvmhE7Pe5PCAiwMP4gF2esVRsWhdsTWhyhkIWAcKht2ojN1J7qt8A3tqkRF+ET
         s1rQ==
X-Gm-Message-State: ACrzQf1qIgk5Y+2bVC9P83Q7pO8dGEC7WNMZRTgU/DvEtO63XeE3F1d3
        2s7pqsfRKC9Wfxm3L53dPXNIjqhKKowCQ290stcL2jT0UODxW2qlHlivESK83TW3h+rXMCaqpgR
        Qq/2US7g7aCXQThzp
X-Received: by 2002:a05:6402:496:b0:443:a5f5:d3b with SMTP id k22-20020a056402049600b00443a5f50d3bmr51671294edv.331.1666953437173;
        Fri, 28 Oct 2022 03:37:17 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5uTFGVbbkxX7P5NzYfu2FbthkGa0Xbcx4RUw8v8EnATeCMfvmoC6hTxlmMZASEebuYKgB7aw==
X-Received: by 2002:a05:6402:496:b0:443:a5f5:d3b with SMTP id k22-20020a056402049600b00443a5f50d3bmr51671268edv.331.1666953436969;
        Fri, 28 Oct 2022 03:37:16 -0700 (PDT)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id ds12-20020a0564021ccc00b00461aebb2fe2sm2426729edb.54.2022.10.28.03.37.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 03:37:16 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <1885bc0c-1929-53ba-b6f8-ace2393a14df@redhat.com>
Date:   Fri, 28 Oct 2022 12:37:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Cc:     brouer@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC bpf-next 5/5] selftests/bpf: Test rx_timestamp metadata in
 xskxceiver
Content-Language: en-US
To:     Martin KaFai Lau <martin.lau@linux.dev>,
        Stanislav Fomichev <sdf@google.com>
References: <20221027200019.4106375-1-sdf@google.com>
 <20221027200019.4106375-6-sdf@google.com>
 <31f3aa18-d368-9738-8bb5-857cd5f2c5bf@linux.dev>
In-Reply-To: <31f3aa18-d368-9738-8bb5-857cd5f2c5bf@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 28/10/2022 08.22, Martin KaFai Lau wrote:
> On 10/27/22 1:00 PM, Stanislav Fomichev wrote:
>> Example on how the metadata is prepared from the BPF context
>> and consumed by AF_XDP:
>>
>> - bpf_xdp_metadata_have_rx_timestamp to test whether it's supported;
>>    if not, I'm assuming verifier will remove this "if (0)" branch
>> - bpf_xdp_metadata_rx_timestamp returns a _copy_ of metadata;
>>    the program has to bpf_xdp_adjust_meta+memcpy it;
>>    maybe returning a pointer is better?
>> - af_xdp consumer grabs it from data-<expected_metadata_offset> and
>>    makes sure timestamp is not empty
>> - when loading the program, we pass BPF_F_XDP_HAS_METADATA+prog_ifindex
>>
>> Cc: Martin KaFai Lau <martin.lau@linux.dev>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: Willem de Bruijn <willemb@google.com>
>> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
>> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
>> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
>> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
>> Cc: Maryam Tahhan <mtahhan@redhat.com>
>> Cc: xdp-hints@xdp-project.net
>> Cc: netdev@vger.kernel.org
>> Signed-off-by: Stanislav Fomichev <sdf@google.com>
>> ---
>>   .../testing/selftests/bpf/progs/xskxceiver.c  | 22 ++++++++++++++++++
>>   tools/testing/selftests/bpf/xskxceiver.c      | 23 ++++++++++++++++++-
>>   2 files changed, 44 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/bpf/progs/xskxceiver.c 
>> b/tools/testing/selftests/bpf/progs/xskxceiver.c
>> index b135daddad3a..83c879aa3581 100644
>> --- a/tools/testing/selftests/bpf/progs/xskxceiver.c
>> +++ b/tools/testing/selftests/bpf/progs/xskxceiver.c
>> @@ -12,9 +12,31 @@ struct {
>>       __type(value, __u32);
>>   } xsk SEC(".maps");
>> +extern int bpf_xdp_metadata_have_rx_timestamp(struct xdp_md *ctx) 
>> __ksym;
>> +extern __u32 bpf_xdp_metadata_rx_timestamp(struct xdp_md *ctx) __ksym;
>> +
>>   SEC("xdp")
>>   int rx(struct xdp_md *ctx)
>>   {
>> +    void *data, *data_meta;
>> +    __u32 rx_timestamp;
>> +    int ret;
>> +
>> +    if (bpf_xdp_metadata_have_rx_timestamp(ctx)) {

In current veth implementation, bpf_xdp_metadata_have_rx_timestamp()
will always return true here.

In the case of hardware timestamps, not every packet will contain a 
hardware timestamp.  (See my/Maryam ixgbe patch, where timestamps are 
read via HW device register, which isn't fast, and HW only support this 
for timesync protocols like PTP).

How do you imagine we can extend this?

>> +        ret = bpf_xdp_adjust_meta(ctx, -(int)sizeof(__u32));

IMHO sizeof() should come from a struct describing data_meta area see:
 
https://github.com/xdp-project/bpf-examples/blob/master/AF_XDP-interaction/af_xdp_kern.c#L62


>> +        if (ret != 0)
>> +            return XDP_DROP;
>> +
>> +        data = (void *)(long)ctx->data;
>> +        data_meta = (void *)(long)ctx->data_meta;
>> +
>> +        if (data_meta + sizeof(__u32) > data)
>> +            return XDP_DROP;
>> +
>> +        rx_timestamp = bpf_xdp_metadata_rx_timestamp(ctx);
>> +        __builtin_memcpy(data_meta, &rx_timestamp, sizeof(__u32));

So, this approach first stores hints on some other memory location, and 
then need to copy over information into data_meta area. That isn't good 
from a performance perspective.

My idea is to store it in the final data_meta destination immediately.

Do notice that in my approach, the existing ethtool config setting and 
socket options (for timestamps) still apply.  Thus, each individual 
hardware hint are already configurable. Thus we already have a config 
interface. I do acknowledge, that in-case a feature is disabled it still 
takes up space in data_meta areas, but importantly it is NOT stored into 
the area (for performance reasons).


>> +    }
> 
> Thanks for the patches.  I took a quick look at patch 1 and 2 but 
> haven't had a chance to look at the implementation details (eg. 
> KF_UNROLL...etc), yet.
> 

Yes, thanks for the patches, even-though I don't agree with the
approach, at-least until my concerns/use-case can be resolved.
IMHO the best way to convince people is through code. So, thank you for
the effort.  Hopefully we can use some of these ideas and I can also
change/adjust my XDP-hints ideas to incorporate some of this :-)


> Overall (with the example here) looks promising.  There is a lot of 
> flexibility on whether the xdp prog needs any hint at all, which hint it 
> needs, and how to store it.
> 

I do see the advantage that XDP prog only populates metadata it needs.
But how can we use/access this in __xdp_build_skb_from_frame() ?


>> +
>>       return bpf_redirect_map(&xsk, ctx->rx_queue_index, XDP_PASS);
>>   }
>> diff --git a/tools/testing/selftests/bpf/xskxceiver.c 
>> b/tools/testing/selftests/bpf/xskxceiver.c
>> index 066bd691db13..ce82c89a432e 100644
>> --- a/tools/testing/selftests/bpf/xskxceiver.c
>> +++ b/tools/testing/selftests/bpf/xskxceiver.c
>> @@ -871,7 +871,9 @@ static bool is_offset_correct(struct xsk_umem_info 
>> *umem, struct pkt_stream *pkt
>>   static bool is_pkt_valid(struct pkt *pkt, void *buffer, u64 addr, 
>> u32 len)
>>   {
>>       void *data = xsk_umem__get_data(buffer, addr);
>> +    void *data_meta = data - sizeof(__u32);
>>       struct iphdr *iphdr = (struct iphdr *)(data + sizeof(struct 
>> ethhdr));
>> +    __u32 rx_timestamp = 0;
>>       if (!pkt) {
>>           ksft_print_msg("[%s] too many packets received\n", __func__);
>> @@ -907,6 +909,13 @@ static bool is_pkt_valid(struct pkt *pkt, void 
>> *buffer, u64 addr, u32 len)
>>           return false;
>>       }
>> +    memcpy(&rx_timestamp, data_meta, sizeof(rx_timestamp));

I acknowledge that it is too extensive to add to this patch, but in my 
AF_XDP-interaction example[1], I'm creating a struct xdp_hints_rx_time 
that gets BTF exported[1][2] to the userspace application, and userspace 
decodes the BTF and gets[3] a xsk_btf_member struct for members that 
simply contains a offset+size to read from.

[1] 
https://github.com/xdp-project/bpf-examples/blob/master/AF_XDP-interaction/af_xdp_kern.c#L47-L51

[2] 
https://github.com/xdp-project/bpf-examples/blob/master/AF_XDP-interaction/af_xdp_kern.c#L80

[3] 
https://github.com/xdp-project/bpf-examples/blob/master/AF_XDP-interaction/af_xdp_user.c#L123-L129

>> +    if (rx_timestamp == 0) {
>> +        ksft_print_msg("Invalid metadata received: ");
>> +        ksft_print_msg("got %08x, expected != 0\n", rx_timestamp);
>> +        return false;
>> +    }
>> +
>>       return true;
>>   }
> 

Looking forward to collaborate :-)
--Jesper

