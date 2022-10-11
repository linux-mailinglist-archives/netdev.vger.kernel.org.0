Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 447A35FB1E2
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 13:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiJKL5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 07:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiJKL5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 07:57:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D303180EAD
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 04:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665489462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hx8VYBfOo97s7JqgJ8RxYkCcwtrkc30xw9K5nM/Rsyc=;
        b=Ynj8xJbG/RvLNNTC5fhnwQtEPwNQSe48JJkrGgwb+SpDtMC5wxe+hofpXW9Dh7lCWf+DOW
        LN0y7TksUNKWMXUJrWs9sOSEmudvIuU6RFHrXHBUWk3RpevbiidrHgd3LYLOiMd/VRwL9k
        0dji0xp35HqD7zkk5bhuRUxQQkCBVio=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-177-Goj6mV8qN6GE5TlM0FSO_w-1; Tue, 11 Oct 2022 07:57:41 -0400
X-MC-Unique: Goj6mV8qN6GE5TlM0FSO_w-1
Received: by mail-ej1-f70.google.com with SMTP id qw31-20020a1709066a1f00b00783d9fd7df2so5821655ejc.17
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 04:57:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hx8VYBfOo97s7JqgJ8RxYkCcwtrkc30xw9K5nM/Rsyc=;
        b=yaQeZodCeJPX417qs08L6WWMxHn18Qa1S89dzRS8GDTrGnrulLpGrhpPUNItHocMTE
         qvTxCVM/T7TZA9kPc5YAaEJUX8D74uJLkpPVFvCKh7uVFP5ywtMtBfx9xlvU0mLqOztY
         P3QuW86o4K0H6pa+kDpf0bxZdvoadPa3JFFfNDEWui6v4wnBGG/pJtbmkRKQuVil6n8k
         CuxQ3JJKyosOmlCYxywRkPKrytUWRvmyrVlIJvu8TWeDJVmNNkXPL6tA1ubOUxscx0kC
         Plu1bzBzIUg4BEnXIkn5jM9FKwGsOROS8xQ9pBbZ/8zoHfcGxCimoGiAAbENJpSn+Mmx
         kxXA==
X-Gm-Message-State: ACrzQf2jqccbA2EjKnkYPhGThwjA0QeLFgCrFkUkkacFOQW5/v6n+Y0D
        9MoZ0+kYmtfi2pvrCevWaT0TqYWtcTAAoLyMzXP8d5Gv+otvPYOCa3iac/KzGmX3JBpdMg/Hj4S
        EqINi3NBfoefBMCma
X-Received: by 2002:a17:906:730d:b0:782:a4e0:bb54 with SMTP id di13-20020a170906730d00b00782a4e0bb54mr18879425ejc.659.1665489460167;
        Tue, 11 Oct 2022 04:57:40 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6r6+NLk1bapBg7twZGRxaCDC8DC7D8M2O1fue98kxpCQ1GcL42pTAJDG9lqZbtBsS6jplWbg==
X-Received: by 2002:a17:906:730d:b0:782:a4e0:bb54 with SMTP id di13-20020a170906730d00b00782a4e0bb54mr18879403ejc.659.1665489459918;
        Tue, 11 Oct 2022 04:57:39 -0700 (PDT)
Received: from [192.168.41.81] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id s19-20020aa7d793000000b00459d0df08f0sm9115628edq.75.2022.10.11.04.57.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Oct 2022 04:57:39 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <ad360933-953a-7a99-5057-4d452a9a6005@redhat.com>
Date:   Tue, 11 Oct 2022 13:57:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Cc:     brouer@redhat.com, Stanislav Fomichev <sdf@google.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH RFCv2 bpf-next 00/18] XDP-hints: XDP gaining access to HW
 offload hints via BTF
Content-Language: en-US
To:     Martin KaFai Lau <martin.lau@linux.dev>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
 <Yzt2YhbCBe8fYHWQ@google.com>
 <35fcfb25-583a-e923-6eee-e8bbcc19db17@redhat.com>
 <CAKH8qBuYVk7QwVOSYrhMNnaKFKGd7M9bopDyNp6-SnN6hSeTDQ@mail.gmail.com>
 <5ccff6fa-0d50-c436-b891-ab797fe7e3c4@linux.dev>
 <20221004175952.6e4aade7@kernel.org>
 <CAKH8qBtdAeHqbWa33yO-MMgC2+h2qehFn8Y_C6ZC1=YsjQS-Bw@mail.gmail.com>
 <20221004182451.6804b8ca@kernel.org>
 <CAKH8qBtTPNULZDLd2n1r2o7XZwvs_q5OkNqhdq0A+b5zkHRNMw@mail.gmail.com>
 <e29082a8-bbd5-6ee3-34bf-c16d0f6ed45a@linux.dev>
 <CAJ8uoz2ng=wv=dWQqxomQX4h11QsYq=scU++MSJ3Q0PMQWuzWQ@mail.gmail.com>
 <cc7e4a27-93ab-e9de-55e0-10029948d738@redhat.com>
 <c8a712d8-dc97-8df5-6421-a5ccb1357b67@linux.dev>
In-Reply-To: <c8a712d8-dc97-8df5-6421-a5ccb1357b67@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/10/2022 08.29, Martin KaFai Lau wrote:
> On 10/6/22 8:29 AM, Jesper Dangaard Brouer wrote:
>>
>> On 06/10/2022 11.14, Magnus Karlsson wrote:
>>> On Wed, Oct 5, 2022 at 9:27 PM Martin KaFai Lau 
>>> <martin.lau@linux.dev> wrote:
>>>>
>>>> On 10/4/22 7:15 PM, Stanislav Fomichev wrote:
>>>>> On Tue, Oct 4, 2022 at 6:24 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>>>>>
>>>>>> On Tue, 4 Oct 2022 18:02:56 -0700 Stanislav Fomichev wrote:
>>>>>>> +1, sounds like a good alternative (got your reply while typing)
>>>>>>> I'm not too versed in the rx_desc/rx_queue area, but seems like worst
>>>>>>> case that bpf_xdp_get_hwtstamp can probably receive a xdp_md ctx and
>>>>>>> parse it out from the pre-populated metadata?
>>>>>>
>>>>>> I'd think so, worst case the driver can put xdp_md into a struct
>>>>>> and container_of() to get to its own stack with whatever fields
>>>>>> it needs.
>>>>>
>>>>> Ack, seems like something worth exploring then.
>>>>>
>>>>> The only issue I see with that is that we'd probably have to extend
>>>>> the loading api to pass target xdp device so we can pre-generate
>>>>> per-device bytecode for those kfuncs?
>>>>
>>>> There is an existing attr->prog_ifindex for dev offload purpose.  
>>>> May be we can
>>>> re-purpose/re-use some of the offload API.  How this kfunc can be 
>>>> presented also
>>>> needs some thoughts, could be a new ndo_xxx.... not sure.
>>>>> And this potentially will block attaching the same program
>>>>   > to different drivers/devices?
>>>>> Or, Martin, did you maybe have something better in mind?
>>>>
>>>> If the kfunc/helper is inline, then it will have to be per device.  
>>>> Unless the
>>>> bpf prog chooses not to inline which could be an option but I am 
>>>> also not sure
>>>> how often the user wants to 'attach' a loaded xdp prog to a 
>>>> different device.
>>>> To some extend, the CO-RE hints-loading-code will have to be per 
>>>> device also, no?
>>>>
>>>> Why I asked the kfunc/helper approach is because, from the set, it 
>>>> seems the
>>>> hints has already been available at the driver.  The specific 
>>>> knowledge that the
>>>> xdp prog missing is how to get the hints from the rx_desc/rx_queue.  
>>>> The
>>>> straight forward way to me is to make them (rx_desc/rx_queue) 
>>>> available to xdp
>>>> prog and have kfunc/helper to extract the hints from them only if 
>>>> the xdp prog
>>>> needs it.  The xdp prog can selectively get what hints it needs and 
>>>> then
>>>> optionally store them into the meta area in any layout.
>>>
>>> This sounds like a really good idea to me, well worth exploring. To
>>> only have to pay, performance wise, for the metadata you actually use
>>> is very important. I did some experiments [1] on the previous patch
>>> set of Jesper's and there is substantial overhead added for each
>>> metadata enabled (and fetched from the NIC). This is especially
>>> important for AF_XDP in zero-copy mode where most packets are directed
>>> to user-space (if not, you should be using the regular driver that is
>>> optimized for passing packets to the stack or redirecting to other
>>> devices). In this case, the user knows exactly what metadata it wants
>>> and where in the metadata area it should be located in order to offer
>>> the best performance for the application in question. But as you say,
>>> your suggestion could potentially offer a good performance upside to
>>> the regular XDP path too.
> 
> Yeah, since we are on this flexible hint layout, after reading the 
> replies in other threads, now I am also not sure why we need a 
> xdp_hints_common and probably I am missing something also.  It seems to 
> be most useful in __xdp_build_skb_from_frame. However, the xdp prog can 
> also fill in the xdp_hints_common by itself only when needed instead of 
> having the driver always filling it in.
> 

I *want* the XDP-hints to be populated even when no XDP-prog is running.
The xdp_frame *is* the mini-SKB concept. These XDP-hints are about
adding HW offload hints to this mini-SKB, to allow it grow into a
full-SKB with these offloads.

I could add this purely as a netstack feature, via extending xdp_frame
area with a common struct. For XDP-prog access I could extend xdp_md
with fields that gets UAPI rewrite mapped to access these fields. For
the AF_XDP users this data becomes harder to access, but an XDP-prog
could (spend cycles) moving these offloads into the metadata area, but
why not place them there is the first place.

I think the main point is that I don't see the XDP-prog as the primary
consumer of these hints.
One reason/use-case for letting XDP-prog access these hints prior to
creating a full-SKB is to help fixing up (or providing) offload hints.
The mvneta driver patch highlight this as HW have limited hints, which
an XDP-prog can provide prior to calling netstack.

In this patchset I'm trying to balance the different users. And via BTF
I'm trying hard not to create more UAPI (e.g. more fixed fields avail in
xdp_md that we cannot get rid of). And trying to add driver flexibility
on-top of the common struct.  This flexibility seems to be stalling the
patchset as we haven't found the perfect way to express this (yet) given
BTF layout is per driver.


>>
>> Okay, lets revisit this again.  And let me explain why I believe this
>> isn't going to fly.
>>
>> I was also my initial though, lets just give XDP BPF-prog direct access
>> to the NIC rx_descriptor, or another BPF-prog populate XDP-hints prior
>> to calling XDP-prog.  Going down this path (previously) I learned three
>> things:
>>
>> (1) Understanding/decoding rx_descriptor requires access to the
>> programmers datasheet, because it is very compacted and the mean of the
>> bits depend on other bits and plus current configuration status of the 
>> HW.
>>
>> (2) HW have bugs and for certain chip revisions driver will skip some
>> offload hints.  Thus, chip revisions need to be exported to BPF-progs
>> and handled appropriately.
>>
>> (3) Sometimes the info is actually not available in the rx_descriptor.
>> Often for HW timestamps, the timestamp need to be read from a HW
>> register.  How do we expose this to the BPF-prog?
> 
> hmm.... may be I am missing those hw specific details here.  How would 
> the driver handle the above cases and fill in the xdp_hints in the 
> meta?  Can the same code be called by the xdp prog?
>

As I mentioned above, I want the XDP-hints to be populated even when no 
XDP-prog is running. I don't want the dependency on loading an XDP-prog 
to get the hints populated, as e.g. netstack is one of the users.


>>
>> Notice that this patchset doesn't block this idea, as it is orthogonal.
>> After we have established a way to express xdp_hints layouts via BTF,
>> then we can still add a pre-XDP BPF-prog that populates the XDP-hints,
>> and squeeze out more performance by skipping some of the offloads that
>> your-specific-XDP-prog are not interested in.
>>
>> --Jesper
>>
> 

