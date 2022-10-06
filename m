Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A127A5F6A9A
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 17:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbiJFP3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 11:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbiJFP3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 11:29:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B0F64D5
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 08:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665070182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jeDE3VY4eN1XGo20Hxq7qlQi31z/52Vmo9cUweF80Dw=;
        b=BoE/X/oE3FxGTZ9ipTjZ0J3nSb/0m4g4ssYtq6w0/eNjk1wQWjY5+7XUqVZ2b11mp99mEI
        zpqZkWj3NGv76R3wTcP3CRkUZGPaOl/eIXlw65JbRML1Q68LEsk/1dAVEgDIBVXFukVv5h
        6RVjbMIJxgTfk1Z6DMQ9J1vK1Idkr/g=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-519-R-vtBBu6O-mDaU8vOBjz_Q-1; Thu, 06 Oct 2022 11:29:37 -0400
X-MC-Unique: R-vtBBu6O-mDaU8vOBjz_Q-1
Received: by mail-ej1-f72.google.com with SMTP id xh12-20020a170906da8c00b007413144e87fso1361361ejb.14
        for <netdev@vger.kernel.org>; Thu, 06 Oct 2022 08:29:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jeDE3VY4eN1XGo20Hxq7qlQi31z/52Vmo9cUweF80Dw=;
        b=GBPciiJx8K01Tx5xCjnxU/kBtY7MT4CtoW8pZHqjjOL1ab0rc/O/50CsjZrXzfqg2v
         vP6sgofnKiaSDPVD4uC+WaUGREDBN78MYk0ai0pKzPgzmJbbF71LdBEuFdWS8RTNNYQw
         x5UBusHnWPkveruHbmXJuE/gpTmIo3Sf9Z/sywUJjHkifBNOUnGUMx4Eu9YkSqRBLUaG
         VrvJwf5orS6BBQWDC2OmEyyZvBpkADJBli4hbZ5ndbr+/u7rh9jj4UcGbZ0okAdxahLo
         BtjGtUBEqZ5aAG9gfVM3VtZYgAbwyBzKs4GhdN2EVeIMPmoEbZsERnI03yVxcnODLESU
         WBXg==
X-Gm-Message-State: ACrzQf0btJJhVDfYfjUALILjcXHUU6HTK+19RJgCPO5wa9UXck5ga7Bm
        5BDPjw5wBdQHLybXySvMLrw1QEIt5fne4/aR3iG/tkCQFWUVS9jv583izcfrJQ++z6fN9ZzlDat
        3yrb1XH3Ki7f2x2f2
X-Received: by 2002:a17:906:db03:b0:741:337e:3600 with SMTP id xj3-20020a170906db0300b00741337e3600mr315672ejb.343.1665070175505;
        Thu, 06 Oct 2022 08:29:35 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM44qyySMQJpSLMtUDZV9hpeYypVUS1+NP/mwP5fayPtfoYAAVQF9qsDFAlZeoX/4u4d99z5gA==
X-Received: by 2002:a17:906:db03:b0:741:337e:3600 with SMTP id xj3-20020a170906db0300b00741337e3600mr315654ejb.343.1665070175263;
        Thu, 06 Oct 2022 08:29:35 -0700 (PDT)
Received: from [192.168.41.81] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id w15-20020a1709062f8f00b007415f8ffcbbsm10619559eji.98.2022.10.06.08.29.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Oct 2022 08:29:34 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <cc7e4a27-93ab-e9de-55e0-10029948d738@redhat.com>
Date:   Thu, 6 Oct 2022 17:29:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Cc:     brouer@redhat.com, Stanislav Fomichev <sdf@google.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
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
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        Martin KaFai Lau <martin.lau@linux.dev>
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
In-Reply-To: <CAJ8uoz2ng=wv=dWQqxomQX4h11QsYq=scU++MSJ3Q0PMQWuzWQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 06/10/2022 11.14, Magnus Karlsson wrote:
> On Wed, Oct 5, 2022 at 9:27 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>>
>> On 10/4/22 7:15 PM, Stanislav Fomichev wrote:
>>> On Tue, Oct 4, 2022 at 6:24 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>>>
>>>> On Tue, 4 Oct 2022 18:02:56 -0700 Stanislav Fomichev wrote:
>>>>> +1, sounds like a good alternative (got your reply while typing)
>>>>> I'm not too versed in the rx_desc/rx_queue area, but seems like worst
>>>>> case that bpf_xdp_get_hwtstamp can probably receive a xdp_md ctx and
>>>>> parse it out from the pre-populated metadata?
>>>>
>>>> I'd think so, worst case the driver can put xdp_md into a struct
>>>> and container_of() to get to its own stack with whatever fields
>>>> it needs.
>>>
>>> Ack, seems like something worth exploring then.
>>>
>>> The only issue I see with that is that we'd probably have to extend
>>> the loading api to pass target xdp device so we can pre-generate
>>> per-device bytecode for those kfuncs?
>>
>> There is an existing attr->prog_ifindex for dev offload purpose.  May be we can
>> re-purpose/re-use some of the offload API.  How this kfunc can be presented also
>> needs some thoughts, could be a new ndo_xxx.... not sure.
>>> And this potentially will block attaching the same program
>>   > to different drivers/devices?
>>> Or, Martin, did you maybe have something better in mind?
>>
>> If the kfunc/helper is inline, then it will have to be per device.  Unless the
>> bpf prog chooses not to inline which could be an option but I am also not sure
>> how often the user wants to 'attach' a loaded xdp prog to a different device.
>> To some extend, the CO-RE hints-loading-code will have to be per device also, no?
>>
>> Why I asked the kfunc/helper approach is because, from the set, it seems the
>> hints has already been available at the driver.  The specific knowledge that the
>> xdp prog missing is how to get the hints from the rx_desc/rx_queue.  The
>> straight forward way to me is to make them (rx_desc/rx_queue) available to xdp
>> prog and have kfunc/helper to extract the hints from them only if the xdp prog
>> needs it.  The xdp prog can selectively get what hints it needs and then
>> optionally store them into the meta area in any layout.
> 
> This sounds like a really good idea to me, well worth exploring. To
> only have to pay, performance wise, for the metadata you actually use
> is very important. I did some experiments [1] on the previous patch
> set of Jesper's and there is substantial overhead added for each
> metadata enabled (and fetched from the NIC). This is especially
> important for AF_XDP in zero-copy mode where most packets are directed
> to user-space (if not, you should be using the regular driver that is
> optimized for passing packets to the stack or redirecting to other
> devices). In this case, the user knows exactly what metadata it wants
> and where in the metadata area it should be located in order to offer
> the best performance for the application in question. But as you say,
> your suggestion could potentially offer a good performance upside to
> the regular XDP path too.

Okay, lets revisit this again.  And let me explain why I believe this
isn't going to fly.

I was also my initial though, lets just give XDP BPF-prog direct access
to the NIC rx_descriptor, or another BPF-prog populate XDP-hints prior
to calling XDP-prog.  Going down this path (previously) I learned three
things:

(1) Understanding/decoding rx_descriptor requires access to the
programmers datasheet, because it is very compacted and the mean of the
bits depend on other bits and plus current configuration status of the HW.

(2) HW have bugs and for certain chip revisions driver will skip some
offload hints.  Thus, chip revisions need to be exported to BPF-progs
and handled appropriately.

(3) Sometimes the info is actually not available in the rx_descriptor.
Often for HW timestamps, the timestamp need to be read from a HW
register.  How do we expose this to the BPF-prog?

> [1] https://lore.kernel.org/bpf/CAJ8uoz1XVqVCpkKo18qbkh6jq_Lejk24OwEWCB9cWhokYLEBDQ@mail.gmail.com/


Notice that this patchset doesn't block this idea, as it is orthogonal.
After we have established a way to express xdp_hints layouts via BTF,
then we can still add a pre-XDP BPF-prog that populates the XDP-hints,
and squeeze out more performance by skipping some of the offloads that
your-specific-XDP-prog are not interested in.

--Jesper

