Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690B96C624D
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 09:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbjCWIwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 04:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbjCWIwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 04:52:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF471026A
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 01:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679561509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j5gzYRXzVkiLOcSv37gdQPBZach6Z3N054lQ3FIqJMg=;
        b=hpHXZcmS2wjvxRVdUvcLyvTQEbXjdJ48kq22xTKqK2YnLbDQuNu90KuqRCZ+ZxfWYvjBRr
        GeuuxSE+fawtlkIFkSB6+Pz1vrxSo9d88nGb3D7wvxp1FpV6DYuXs20YvBWNj3OGsLGdEb
        MoDpjI76osKDo1nO3gRmwH4szvVR+Hs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-18-Y5x53CVUOBiaa0HL8uR6UA-1; Thu, 23 Mar 2023 04:51:47 -0400
X-MC-Unique: Y5x53CVUOBiaa0HL8uR6UA-1
Received: by mail-ed1-f70.google.com with SMTP id t26-20020a50d71a000000b005003c5087caso29583200edi.1
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 01:51:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679561506;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j5gzYRXzVkiLOcSv37gdQPBZach6Z3N054lQ3FIqJMg=;
        b=gS6IxzDyAbwF0B0UtcCevHCW6icNvo61SPfvg6oLSaugaNQ2oM/CUl9OuIWt24SW+u
         aSMPYu9PVwR3J2iHKihWtOcjqS4UWG/+iKiRdYE8oO5/QVzPWlJSYh3NXIYRKRmL0vJS
         k820zoGTxOpM6cCEk/jIdLG3iJZX0o50VUzGgc0Il44gatY8h1h+2Z2M3LLcCK4udIHk
         A3b0uDQvNdpmEgH12hUeqBn0uzDQ2Q6HFSXdK4r5l54rgQzNu5u9/ohi3bJnYF8mJdIR
         ySlDA5xxHfbTeYBPlnkHDNG8yk9Q2ARWe4GASGJ3rirECv3xS3bVSNXT6KULHrmXs0o1
         WEMg==
X-Gm-Message-State: AO0yUKWKLgPkGat4Ai/9uxUZDPTbExtZB37MjhkOvOZCS0dLWjalibhN
        /ZVuVjLs0XjiSGHAgmTQ18A3nICoaAsVK3SV/LLjPeWL3P+ZXZ5oGpsCIgzjQTsE6uJWxVMz4c9
        +xtR8jrTOHoaM1uIA
X-Received: by 2002:aa7:cb87:0:b0:4fc:154:3fda with SMTP id r7-20020aa7cb87000000b004fc01543fdamr10115399edt.4.1679561505961;
        Thu, 23 Mar 2023 01:51:45 -0700 (PDT)
X-Google-Smtp-Source: AK7set9ArOW5k1PgG9N2RSTMxnzGIZveA0mr+cYVpJ89mRrFw1sLL8uekgGPY0/WSR1hHofSGeufVA==
X-Received: by 2002:aa7:cb87:0:b0:4fc:154:3fda with SMTP id r7-20020aa7cb87000000b004fc01543fdamr10115390edt.4.1679561505647;
        Thu, 23 Mar 2023 01:51:45 -0700 (PDT)
Received: from [192.168.42.100] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id m10-20020a50998a000000b004e48f8df7e2sm8935019edb.72.2023.03.23.01.51.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 01:51:45 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <d7ac4f80-b65c-5201-086e-3b2645cbe7fe@redhat.com>
Date:   Thu, 23 Mar 2023 09:51:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, bpf <bpf@vger.kernel.org>,
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
Content-Language: en-US
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
In-Reply-To: <CAKH8qBuqxxVM9fSB43cAvvTnaHkA-JNRy=gufCqYf5GNbRA-8g@mail.gmail.com>
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


On 22/03/2023 20.33, Stanislav Fomichev wrote:
> On Wed, Mar 22, 2023 at 12:30 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>>
>> On Wed, Mar 22, 2023 at 12:23 PM Stanislav Fomichev <sdf@google.com> wrote:
>>>
>>> On Wed, Mar 22, 2023 at 12:17 PM Alexei Starovoitov
>>> <alexei.starovoitov@gmail.com> wrote:
>>>>
>>>> On Wed, Mar 22, 2023 at 12:00 PM Stanislav Fomichev <sdf@google.com> wrote:
>>>>>
>>>>> On Wed, Mar 22, 2023 at 9:07 AM Alexei Starovoitov
>>>>> <alexei.starovoitov@gmail.com> wrote:
>>>>>>
>>>>>> On Wed, Mar 22, 2023 at 9:05 AM Jesper Dangaard Brouer
>>>>>> <jbrouer@redhat.com> wrote:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> On 21/03/2023 19.47, Stanislav Fomichev wrote:
>>>>>>>> On Tue, Mar 21, 2023 at 6:47 AM Jesper Dangaard Brouer
>>>>>>>> <brouer@redhat.com> wrote:
>>>>>>>>>
>>>>>>>>> When driver developers add XDP-hints kfuncs for RX hash it is
>>>>>>>>> practical to print the return code in bpf_printk trace pipe log.
>>>>>>>>>
>>>>>>>>> Print hash value as a hex value, both AF_XDP userspace and bpf_prog,
>>>>>>>>> as this makes it easier to spot poor quality hashes.
>>>>>>>>>
>>>>>>>>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>>>>>>>>> ---
>>>>>>>>>    .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |    9 ++++++---
>>>>>>>>>    tools/testing/selftests/bpf/xdp_hw_metadata.c      |    5 ++++-
>>>>>>>>>    2 files changed, 10 insertions(+), 4 deletions(-)
>>>>>>>>>
>>>>>>>>> diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
>>>>>>>>> index 40c17adbf483..ce07010e4d48 100644
>>>>>>>>> --- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
>>>>>>>>> +++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
>>>>>>>>> @@ -77,10 +77,13 @@ int rx(struct xdp_md *ctx)
>>>>>>>>>                   meta->rx_timestamp = 0; /* Used by AF_XDP as not avail signal */
>>>>>>>>>           }
>>>>>>>>>
>>>>>>>>> -       if (!bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash))
>>>>>>>>> -               bpf_printk("populated rx_hash with %u", meta->rx_hash);
>>>>>>>>> -       else
>>>>>>>>> +       ret = bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash);
>>>>>>>>> +       if (ret >= 0) {
>>>>>>>>> +               bpf_printk("populated rx_hash with 0x%08X", meta->rx_hash);
>>>>>>>>> +       } else {
>>>>>>>>> +               bpf_printk("rx_hash not-avail errno:%d", ret);
>>>>>>>>>                   meta->rx_hash = 0; /* Used by AF_XDP as not avail signal */
>>>>>>>>> +       }
>>>>>>>>>
>>>>>>>>>           return bpf_redirect_map(&xsk, ctx->rx_queue_index, XDP_PASS);
>>>>>>>>>    }
>>>>>>>>> diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/tools/testing/selftests/bpf/xdp_hw_metadata.c
>>>>>>>>> index 400bfe19abfe..f3ec07ccdc95 100644
>>>>>>>>> --- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
>>>>>>>>> +++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
>>>>>>>>> @@ -3,6 +3,9 @@
>>>>>>>>>    /* Reference program for verifying XDP metadata on real HW. Functional test
>>>>>>>>>     * only, doesn't test the performance.
>>>>>>>>>     *
>>>>>>>>> + * BPF-prog bpf_printk info outout can be access via
>>>>>>>>> + * /sys/kernel/debug/tracing/trace_pipe
>>>>>>>>
>>>>>>>> s/outout/output/
>>>>>>>>
>>>>>>>
>>>>>>> Fixed in V3
>>>>>>>
>>>>>>>> But let's maybe drop it? If you want to make it more usable, let's
>>>>>>>> have a separate patch to enable tracing and periodically dump it to
>>>>>>>> the console instead (as previously discussed).
>>>>>>>
>>>>>>> Cat'ing /sys/kernel/debug/tracing/trace_pipe work for me regardless of
>>>>>>> setting in
>>>>>>> /sys/kernel/debug/tracing/events/bpf_trace/bpf_trace_printk/enable
>>>>>>>
>>>>>>> We likely need a followup patch that adds a BPF config switch that can
>>>>>>> disable bpf_printk calls, because this adds overhead and thus affects
>>>>>>> the timestamps.
>>>>>>
>>>>>> No. This is by design.
>>>>>> Do not use bpf_printk* in production.

I fully agree do not use bpf_printk in *production*.

>>>>>
>>>>> But that's not for the production? xdp_hw_metadata is a small tool to
>>>>> verify that the metadata being dumped is correct (during the
>>>>> development).
>>>>> We have a proper (less verbose) selftest in
>>>>> {progs,prog_tests}/xdp_metadata.c (over veth).
>>>>> This xdp_hw_metadata was supposed to be used for running it against
>>>>> the real hardware, so having as much debugging at hand as possible
>>>>> seems helpful? (at least it was helpful to me when playing with mlx4)

My experience when developing these kfuncs for igc (real hardware), this
"tool" xdp_hw_metadata was super helpful, because it was very verbose
(and I was juggling reading chip registers BE/LE and see patch1 a buggy
implementation for RX-hash).

As I wrote in cover-letter, I recommend other driver developers to do
the same, because it really help speed up the development. In theory
xdp_hw_metadata doesn't belong in selftests directory and IMHO it should
have been placed in samples/bpf/, but given the relationship with real
selftest {progs,prog_tests}/xdp_metadata.c I think it makes sense to
keep here.


>>>>
>>>> The only use of bpf_printk is for debugging of bpf progs themselves.
>>>> It should not be used in any tool.
>>>
>>> Hmm, good point. I guess it also means we won't have to mess with
>>> enabling/dumping ftrace (and don't need this comment about cat'ing the
>>> file).
>>> Jesper, maybe we can instead pass the status of those
>>> bpf_xdp_metadata_xxx kfuncs via 'struct xdp_meta'? And dump this info
>>> from the userspace if needed.
>>
>> There are so many other ways for bpf prog to communicate with user space.
>> Use ringbuf, perf_event buffer, global vars, maps, etc.
>> trace_pipe is debug only because it's global and will conflict with
>> all other debug sessions.

I want to highlight above paragraph: It is very true for production
code. (Anyone Googling this pay attention to above paragraph).

> 
> 👍 makes sense, ty! hopefully we won't have to add a separate channel
> for those and can (ab)use the metadata area.
> 

Proposed solution: How about default disabling the bpf_printk's via a 
macro define, and then driver developer can manually reenable them 
easily via a single define, to enable a debugging mode.

I was only watching /sys/kernel/debug/tracing/trace_pipe when I was 
debugging a driver issue.  Thus, an extra step of modifying a single 
define in BPF seems easier, than instrumenting my driver with printk.

--Jesper

