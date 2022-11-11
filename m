Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCE762588D
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 11:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233492AbiKKKmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 05:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbiKKKmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 05:42:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34ADB65E5A
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 02:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668163265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QNTar+12P1H59OON6fBjXfGGsWJKzpaZOSFcU1s0I+c=;
        b=H6dOFdcf8lUT8KK+3uFcpKWUur77TKoRiwsci+SqxKKxCFqrUPV2+zh8EoiB0tfwI8KNp+
        LOzTxO9xsOiaWNHB3e3/FYFpTXzUDXo8gr7L2+LQjMS+5VEm5NCN1yHm7ulg5q6Qd58UCW
        n0WnuzyQea+fFxdxeqqZ9aJzxQnMvv8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-434-hGcpx8u6OByAY6tBBWueNw-1; Fri, 11 Nov 2022 05:41:04 -0500
X-MC-Unique: hGcpx8u6OByAY6tBBWueNw-1
Received: by mail-ed1-f70.google.com with SMTP id q13-20020a056402518d00b00462b0599644so3418972edd.20
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 02:41:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QNTar+12P1H59OON6fBjXfGGsWJKzpaZOSFcU1s0I+c=;
        b=ae+5MgpKAGitA5oWsG5pJfqf2nBFOOa+kBJAYGljwXYS6vdeq5biaD5u1Py3MTvkKw
         lmvhAG9d6tBurrSC5ZGBGBkKsoHuU4YQ/stA8uSsywRUPO72TDer6K8E4IXNc/bL28gF
         a/zPV0wwRT0l4jYjxY3NDQbNfgnc70fN6r0CcHfauntx6VH1Wj/3awi+hoC92Fb1CyBq
         QXF4ai7N0NKdbk1u0vEjfN9QCvYedSl9/EYOYgDgtSAWoUJ7tjUAThk9ZnKV4WclO8pF
         fdqRFqpOo6EiVTkbH08+IqQ1pNX1F4Fpmwsfj+uEfgvcgQpQU5Yw8bsoPRb761NUMVqU
         13DQ==
X-Gm-Message-State: ANoB5pmRyiJFRnvNKwlTpCBfdmoLhTquIT/DT08nsnQN2V1oqgSvKMMr
        ifyanqkQ8iHqxWRS+3uJFu1XpE0NEz9LlIIFGIQIO/NoRW5dZMhyAujAreEobPOo/x8vhXmdgb+
        S9fnJzFM+TzMnbNY0
X-Received: by 2002:aa7:cd83:0:b0:461:a7f8:c8c7 with SMTP id x3-20020aa7cd83000000b00461a7f8c8c7mr872838edv.325.1668163263093;
        Fri, 11 Nov 2022 02:41:03 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5Yvj0eHjWgLHwSjcUHmBxgq2MUCkRpUAHfcffqzj9MqAWaLMlKVBaKwON2/4JrFMAsLDM2LQ==
X-Received: by 2002:aa7:cd83:0:b0:461:a7f8:c8c7 with SMTP id x3-20020aa7cd83000000b00461a7f8c8c7mr872811edv.325.1668163262867;
        Fri, 11 Nov 2022 02:41:02 -0800 (PST)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id y16-20020a1709064b1000b0077a1dd3e7b7sm736940eju.102.2022.11.11.02.41.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Nov 2022 02:41:02 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <bab405af-aef0-1bc9-410b-ad815f88574c@redhat.com>
Date:   Fri, 11 Nov 2022 11:41:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Cc:     brouer@redhat.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [RFC bpf-next v2 04/14] veth: Support rx timestamp metadata for
 xdp
Content-Language: en-US
To:     John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>
References: <20221104032532.1615099-1-sdf@google.com>
 <20221104032532.1615099-5-sdf@google.com>
 <636c4514917fa_13c168208d0@john.notmuch>
 <CAKH8qBvS9C5Z2L2dT4Ze-dz7YBSpw52VF6iZK5phcU2k4azN5A@mail.gmail.com>
 <636c555942433_13ef3820861@john.notmuch>
 <CAKH8qBtiNiwbupP-jvs5+nSJRJS4DfZGEPsaYFdQcPKu+8G30g@mail.gmail.com>
 <636d37629d5c4_145693208e6@john.notmuch>
In-Reply-To: <636d37629d5c4_145693208e6@john.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/11/2022 18.39, John Fastabend wrote:
> Stanislav Fomichev wrote:
>> On Wed, Nov 9, 2022 at 5:35 PM John Fastabend <john.fastabend@gmail.com> wrote:
>>>
>>> Stanislav Fomichev wrote:
>>>> On Wed, Nov 9, 2022 at 4:26 PM John Fastabend <john.fastabend@gmail.com> wrote:
>>>>>
>>>>> Stanislav Fomichev wrote:
>>>>>> xskxceiver conveniently setups up veth pairs so it seems logical
>>>>>> to use veth as an example for some of the metadata handling.
>>>>>>
>>>>>> We timestamp skb right when we "receive" it, store its
>>>>>> pointer in new veth_xdp_buff wrapper and generate BPF bytecode to
>>>>>> reach it from the BPF program.
>>>>>>
>>>>>> This largely follows the idea of "store some queue context in
>>>>>> the xdp_buff/xdp_frame so the metadata can be reached out
>>>>>> from the BPF program".
>>>>>>
>>>>>
>>>>> [...]
>>>>>
>>>>>>        orig_data = xdp->data;
>>>>>>        orig_data_end = xdp->data_end;
>>>>>> +     vxbuf.skb = skb;
>>>>>>
>>>>>>        act = bpf_prog_run_xdp(xdp_prog, xdp);
>>>>>>
>>>>>> @@ -942,6 +946,7 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
>>>>>>                        struct sk_buff *skb = ptr;
>>>>>>
>>>>>>                        stats->xdp_bytes += skb->len;
>>>>>> +                     __net_timestamp(skb);
>>>>>
>>>>> Just getting to reviewing in depth a bit more. But we hit veth with lots of
>>>>> packets in some configurations I don't think we want to add a __net_timestamp
>>>>> here when vast majority of use cases will have no need for timestamp on veth
>>>>> device. I didn't do a benchmark but its not free.
>>>>>
>>>>> If there is a real use case for timestamping on veth we could do it through
>>>>> a XDP program directly? Basically fallback for devices without hw timestamps.
>>>>> Anyways I need the helper to support hardware without time stamping.
>>>>>
>>>>> Not sure if this was just part of the RFC to explore BPF programs or not.
>>>>
>>>> Initially I've done it mostly so I can have selftests on top of veth
>>>> driver, but I'd still prefer to keep it to have working tests.
>>>
>>> I can't think of a use for it though so its just extra cycles. There
>>> is a helper to read the ktime.
>>
>> As I mentioned in another reply, I wanted something SW-only to test
>> this whole metadata story.
> 
> Yeah I see the value there. Also because this is in the veth_xdp_rcv
> path we don't actually attach XDP programs to veths except for in
> CI anyways. I assume though if someone actually does use this in
> prod having an extra _net_timestamp there would be extra unwanted
> cycles.
> 

Sorry, but I think it is wrong to add this SW-timestamp to veth.
As John already pointed out the BPF-prog can just call ktime helper
itself. Plus, we *do* want to use this code path as a fast-path, not
just for CI testing.

I suggest you use the offloaded VLAN tag instead.


>> The idea was:
>> - veth rx sets skb->tstamp (otherwise it's 0 at this point)
>> - veth kfunc to access rx_timestamp returns skb->tstamp
>> - xsk bpf program verifies that the metadata is non-zero
>> - the above shows end-to-end functionality with a software driver
> 
> Yep 100% agree very handy for testing just not sure we can add code
> to hotpath just for testing.

I agree, I really dislike adding code to hotpath just for testing.

Using VLAN instead would solve a practical problem, that XDP lacks
access to the offloaded VLAN tag.  Which is one of the lacking features
that XDP-hints targets to add.

--Jesper

