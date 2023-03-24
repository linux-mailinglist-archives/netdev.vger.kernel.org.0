Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0610C6C7DCE
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 13:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbjCXMPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 08:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbjCXMPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 08:15:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595A9136DB
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 05:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679660070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pBTZYWuFZuf/Tn0BpTtzc8rxHh/vXia0nkhx33ZjAzM=;
        b=IWntMRAyMgDYdWPizsjtddS9bHH71UVtXaXBYrcNQz5X8F+eQSGXp4Ms6OTTxfU8VbMeIP
        2dhcP1XnpH48WCPbEHqWH8FxwkcYOztnI9fIkDp+wyztR7s6BBY5gRzExjyOHz0G/FsTqh
        RR4aYCUSkUwFFHhaEi7HFKmnhhaJ8B0=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-333-QrM5HjIvOyy1zdY2KTqhug-1; Fri, 24 Mar 2023 08:14:29 -0400
X-MC-Unique: QrM5HjIvOyy1zdY2KTqhug-1
Received: by mail-lj1-f200.google.com with SMTP id g9-20020a2eb5c9000000b0029bd51d335aso398765ljn.0
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 05:14:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679660067;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:cc:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pBTZYWuFZuf/Tn0BpTtzc8rxHh/vXia0nkhx33ZjAzM=;
        b=76eWYtmnFwSdhXQ9sQG7n2J2YiX+VQTUvtSO6MOioVUMBS9AYaXE5/v4HyXhFeuqvN
         qO5U96ETs1oPMXPLuV9hKcfRztLTcb9txBPjh8FFhhyBga1i95HONJ5LXvffi/Lw+XVS
         vANgRNnjb+Rf4sCPKARhCB3bfG5TyoyRP0BoJJYa04ozLg6p4XdM5k4icKHckPHg0Zkx
         OAerx98D+49meHlcQkEKfDb1eziiiLMCoA6CqYjF7WQ6ghFlcV7PG/KM7uFtrOnD0ar3
         a0VVDm78Z0j6+7L8/q/bi4zlxelaSYNsVNNf+iTMv4PATvdoM/++GK3x/SyT+mbWpxYq
         aJOg==
X-Gm-Message-State: AAQBX9dK8N8tzUFP4S3GJZpo/HwsMlWL97Y1ImASNc3ZRyKS86/UHWNg
        UXntKqRuS0JMPTVGW708wkDDX44SpV1wgsiSND+c3XOEvrSh+SqN3wvrNsEnhbwCrFOMnY24VwE
        h0sdmp0CQphIZ2tGk
X-Received: by 2002:ac2:5628:0:b0:4d8:82d5:f5bc with SMTP id b8-20020ac25628000000b004d882d5f5bcmr669120lff.34.1679660067666;
        Fri, 24 Mar 2023 05:14:27 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZGgrq+m4WPQmmsrlK4MMSv11q3GGWp6SPbTmKMQIY/s+s9AMABuSCGVG9pWmv7/y1UkqIgEg==
X-Received: by 2002:ac2:5628:0:b0:4d8:82d5:f5bc with SMTP id b8-20020ac25628000000b004d882d5f5bcmr669105lff.34.1679660067227;
        Fri, 24 Mar 2023 05:14:27 -0700 (PDT)
Received: from [192.168.42.100] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id x22-20020a19f616000000b0048a982ad0a8sm3328632lfe.23.2023.03.24.05.14.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 05:14:26 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <6d9dbeb8-e1e7-8f8e-73eb-8fa66a1323de@redhat.com>
Date:   Fri, 24 Mar 2023 13:14:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, Jesper Dangaard Brouer <jbrouer@redhat.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        xdp-hints@xdp-project.net, anthony.l.nguyen@intel.com,
        "Song, Yoong Siang" <yoong.siang.song@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH bpf-next V2 3/6] selftests/bpf: xdp_hw_metadata RX hash
 return code info
To:     Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <167940634187.2718137.10209374282891218398.stgit@firesoul>
 <167940643669.2718137.4624187727245854475.stgit@firesoul>
 <CAKH8qBuv-9TXAmi0oTbB0atC4f6jzFcFhAgQ3D89VX45vUU9hw@mail.gmail.com>
 <080640fc-5835-26f1-2b20-ff079bd59182@redhat.com>
 <CAADnVQKsxzLTZ2XoLbmKKLAeaSyvf3P+w8V143iZ4cEWWTEUfw@mail.gmail.com>
 <CAKH8qBuHaaqnV-_mb1Roao9ZDrEHm+1Cj77hPZSRgwxoqphvxQ@mail.gmail.com>
 <CAADnVQ+6FeQ97DZLco3OtbtXQvGUAY4nr5tM++6NEDr+u8m7GQ@mail.gmail.com>
 <CAKH8qBvzVASpUu3M=6ohDqJgJjoR33jQ-J44ESD9SdkvFoGAZg@mail.gmail.com>
 <CAADnVQLC7ma7SWPOcjXhsZ2N0OyVtBr7TzCoT-_Dn+zQ2DEyWg@mail.gmail.com>
 <CAKH8qBuqxxVM9fSB43cAvvTnaHkA-JNRy=gufCqYf5GNbRA-8g@mail.gmail.com>
 <d7ac4f80-b65c-5201-086e-3b2645cbe7fe@redhat.com>
 <CAADnVQ+Jc6G78gJOA758bkCt4sgiwaxgC7S0cr9J=XBPfMDUSg@mail.gmail.com>
 <CAKH8qBupRYEg+SPMTMb4h532GESG7P1QdaFJ-+zrbARVN9xrdA@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAKH8qBupRYEg+SPMTMb4h532GESG7P1QdaFJ-+zrbARVN9xrdA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23/03/2023 18.47, Stanislav Fomichev wrote:
> On Thu, Mar 23, 2023 at 10:35 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>>
>> On Thu, Mar 23, 2023 at 1:51 AM Jesper Dangaard Brouer
>> <jbrouer@redhat.com> wrote:
>>>
>>>
>>> On 22/03/2023 20.33, Stanislav Fomichev wrote:
>>>> On Wed, Mar 22, 2023 at 12:30 PM Alexei Starovoitov
>>>> <alexei.starovoitov@gmail.com> wrote:
>>>>>
>>>>> On Wed, Mar 22, 2023 at 12:23 PM Stanislav Fomichev <sdf@google.com> wrote:
>>>>>>
>>>>>> On Wed, Mar 22, 2023 at 12:17 PM Alexei Starovoitov
>>>>>> <alexei.starovoitov@gmail.com> wrote:
>>>>>>>
>>>>>>> On Wed, Mar 22, 2023 at 12:00 PM Stanislav Fomichev <sdf@google.com> wrote:
>>>>>>>>
>>>>>>>> On Wed, Mar 22, 2023 at 9:07 AM Alexei Starovoitov
>>>>>>>> <alexei.starovoitov@gmail.com> wrote:
>>>>>>>>>
>>>>>>>>> On Wed, Mar 22, 2023 at 9:05 AM Jesper Dangaard Brouer
>>>>>>>>> <jbrouer@redhat.com> wrote:
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> On 21/03/2023 19.47, Stanislav Fomichev wrote:
>>>>>>>>>>> On Tue, Mar 21, 2023 at 6:47 AM Jesper Dangaard Brouer
>>>>>>>>>>> <brouer@redhat.com> wrote:
>>>>>>>>>>>>
>>>>>>>>>>>> When driver developers add XDP-hints kfuncs for RX hash it is
>>>>>>>>>>>> practical to print the return code in bpf_printk trace pipe log.
>>>>>>>>>>>>
>>>>>>>>>>>> Print hash value as a hex value, both AF_XDP userspace and bpf_prog,
>>>>>>>>>>>> as this makes it easier to spot poor quality hashes.
>>>>>>>>>>>>
>>>>>>>>>>>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>>>>>>>>>>>> ---
>>>>>>>>>>>>     .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |    9 ++++++---
>>>>>>>>>>>>     tools/testing/selftests/bpf/xdp_hw_metadata.c      |    5 ++++-
>>>>>>>>>>>>     2 files changed, 10 insertions(+), 4 deletions(-)
>>>>>>>>>>>>
>>>>>>>>>>>> diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
>>>>>>>>>>>> index 40c17adbf483..ce07010e4d48 100644
>>>>>>>>>>>> --- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
>>>>>>>>>>>> +++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
>>>>>>>>>>>> @@ -77,10 +77,13 @@ int rx(struct xdp_md *ctx)
>>>>>>>>>>>>                    meta->rx_timestamp = 0; /* Used by AF_XDP as not avail signal */
>>>>>>>>>>>>            }
>>>>>>>>>>>>
>>>>>>>>>>>> -       if (!bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash))
>>>>>>>>>>>> -               bpf_printk("populated rx_hash with %u", meta->rx_hash);
>>>>>>>>>>>> -       else
>>>>>>>>>>>> +       ret = bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash);
>>>>>>>>>>>> +       if (ret >= 0) {
>>>>>>>>>>>> +               bpf_printk("populated rx_hash with 0x%08X", meta->rx_hash);
>>>>>>>>>>>> +       } else {
>>>>>>>>>>>> +               bpf_printk("rx_hash not-avail errno:%d", ret);
>>>>>>>>>>>>                    meta->rx_hash = 0; /* Used by AF_XDP as not avail signal */
>>>>>>>>>>>> +       }
>>>>>>>>>>>>
>>>>>>>>>>>>            return bpf_redirect_map(&xsk, ctx->rx_queue_index, XDP_PASS);
>>>>>>>>>>>>     }
>>>>>>>>>>>> diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/tools/testing/selftests/bpf/xdp_hw_metadata.c
>>>>>>>>>>>> index 400bfe19abfe..f3ec07ccdc95 100644
>>>>>>>>>>>> --- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
>>>>>>>>>>>> +++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
>>>>>>>>>>>> @@ -3,6 +3,9 @@
>>>>>>>>>>>>     /* Reference program for verifying XDP metadata on real HW. Functional test
>>>>>>>>>>>>      * only, doesn't test the performance.
>>>>>>>>>>>>      *
>>>>>>>>>>>> + * BPF-prog bpf_printk info outout can be access via
>>>>>>>>>>>> + * /sys/kernel/debug/tracing/trace_pipe
>>>>>>>>>>>
>>>>>>>>>>> s/outout/output/
>>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> Fixed in V3
>>>>>>>>>>
>>>>>>>>>>> But let's maybe drop it? If you want to make it more usable, let's
>>>>>>>>>>> have a separate patch to enable tracing and periodically dump it to
>>>>>>>>>>> the console instead (as previously discussed).
>>>>>>>>>>
>>>>>>>>>> Cat'ing /sys/kernel/debug/tracing/trace_pipe work for me regardless of
>>>>>>>>>> setting in
>>>>>>>>>> /sys/kernel/debug/tracing/events/bpf_trace/bpf_trace_printk/enable
>>>>>>>>>>
>>>>>>>>>> We likely need a followup patch that adds a BPF config switch that can
>>>>>>>>>> disable bpf_printk calls, because this adds overhead and thus affects
>>>>>>>>>> the timestamps.
>>>>>>>>>
>>>>>>>>> No. This is by design.
>>>>>>>>> Do not use bpf_printk* in production.
>>>
>>> I fully agree do not use bpf_printk in *production*.
>>>
>>>>>>>>
>>>>>>>> But that's not for the production? xdp_hw_metadata is a small tool to
>>>>>>>> verify that the metadata being dumped is correct (during the
>>>>>>>> development).
>>>>>>>> We have a proper (less verbose) selftest in
>>>>>>>> {progs,prog_tests}/xdp_metadata.c (over veth).
>>>>>>>> This xdp_hw_metadata was supposed to be used for running it against
>>>>>>>> the real hardware, so having as much debugging at hand as possible
>>>>>>>> seems helpful? (at least it was helpful to me when playing with mlx4)
>>>
>>> My experience when developing these kfuncs for igc (real hardware), this
>>> "tool" xdp_hw_metadata was super helpful, because it was very verbose
>>> (and I was juggling reading chip registers BE/LE and see patch1 a buggy
>>> implementation for RX-hash).
>>>
>>> As I wrote in cover-letter, I recommend other driver developers to do
>>> the same, because it really help speed up the development. In theory
>>> xdp_hw_metadata doesn't belong in selftests directory and IMHO it should
>>> have been placed in samples/bpf/, but given the relationship with real
>>> selftest {progs,prog_tests}/xdp_metadata.c I think it makes sense to
>>> keep here.
>>>
>>>
>>>>>>>
>>>>>>> The only use of bpf_printk is for debugging of bpf progs themselves.
>>>>>>> It should not be used in any tool.
>>>>>>
>>>>>> Hmm, good point. I guess it also means we won't have to mess with
>>>>>> enabling/dumping ftrace (and don't need this comment about cat'ing the
>>>>>> file).
>>>>>> Jesper, maybe we can instead pass the status of those
>>>>>> bpf_xdp_metadata_xxx kfuncs via 'struct xdp_meta'? And dump this info
>>>>>> from the userspace if needed.
>>>>>
>>>>> There are so many other ways for bpf prog to communicate with user space.
>>>>> Use ringbuf, perf_event buffer, global vars, maps, etc.
>>>>> trace_pipe is debug only because it's global and will conflict with
>>>>> all other debug sessions.
>>>
>>> I want to highlight above paragraph: It is very true for production
>>> code. (Anyone Googling this pay attention to above paragraph).
>>>
>>>>
>>>> 👍 makes sense, ty! hopefully we won't have to add a separate channel
>>>> for those and can (ab)use the metadata area.
>>>>
>>>
>>> Proposed solution: How about default disabling the bpf_printk's via a
>>> macro define, and then driver developer can manually reenable them
>>> easily via a single define, to enable a debugging mode.
>>>
>>> I was only watching /sys/kernel/debug/tracing/trace_pipe when I was
>>> debugging a driver issue.  Thus, an extra step of modifying a single
>>> define in BPF seems easier, than instrumenting my driver with printk.
>>
>> It's certainly fine to have commented out bpf_printk in selftests
>> and sample code.
>> But the patch does:
>> +       if (ret >= 0) {
>> +               bpf_printk("populated rx_hash with 0x%08X", meta->rx_hash);
>> +       } else {
>> +               bpf_printk("rx_hash not-avail errno:%d", ret);
>>                  meta->rx_hash = 0; /* Used by AF_XDP as not avail signal */
>> +       }
>>
>> It feels that printk is the only thing that provides the signal to the user.
>> Doing s/ret >= 0/true/ won't make any difference to selftest and
>> to the consumer and that's my main concern with such selftest/samples.
> 
> I agree, having this signal delivered to the user (without the ifdefs)
> seems like a better way to go.

I agree that we have a signal that we are not delivering to the user.

Just so we are on the same page, let me explain how above code is
problematic. As the rx_hash value zero have two meanings:

  (1) Negative 'ret' set rx_hash=0 as err signal to AF_XDP "user"
  (2) Hardware set rx_hash=0, when hash-type == IGC_RSS_TYPE_NO_HASH

Case (2) happens for all L2 packets e.g. ARP packets.  See in patch-1
where I map IGC_RSS_TYPE_NO_HASH to netstack type PKT_HASH_TYPE_L2.
I did consider return errno/negative number for IGC_RSS_TYPE_NO_HASH,
but I wanted to keep kfunc code as simple as possible (both for speed
and if we need to unroll as byte-code later). As i225 hardware still
writes zero into hash word I choose to keep code simple.


IMHO this symptom is related to an API problem of the kfunc, that
doesn't provide the hash-type.

> Seems trivial to do something like the following below? (untested,
> doesn't compile, gmail-copy-pasted so don't try to apply it)
> 

If the kfunc provided the hash-type, which will be a positive number.
Then I would add a signed integer to meta, which can store the hash-type
or the negative errno number.


> diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> index 4c55b4d79d3d..061c410f68ea 100644
> --- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> +++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> @@ -12,6 +12,9 @@ struct {
>    __type(value, __u32);
>   } xsk SEC(".maps");
> 
> +int received;
> +int dropped;
> +
>   extern int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx,
>    __u64 *timestamp) __ksym;
>   extern int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx,
> @@ -52,11 +55,11 @@ int rx(struct xdp_md *ctx)
>    if (udp->dest != bpf_htons(9091))
>    return XDP_PASS;

It we wanted to make this program user "friendly", we should also count
packets that doesn't get redirected to AF_XDP "user" and instead skipped.

> - bpf_printk("forwarding UDP:9091 to AF_XDP");
> + __sync_fetch_and_add(&received, 1);
> 
>    ret = bpf_xdp_adjust_meta(ctx, -(int)sizeof(struct xdp_meta));
>    if (ret != 0) {
> - bpf_printk("bpf_xdp_adjust_meta returned %d", ret);
> + __sync_fetch_and_add(&dropped, 1);
>    return XDP_PASS;

Is it a "dropped" or a "skipped" packet (return XDP_PASS)?

>    }
[...]

--Jesper

