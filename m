Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 619AD6C3343
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 14:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbjCUNtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 09:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbjCUNs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 09:48:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC5E34320
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 06:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679406489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bnzw40W4FEb0L33e1Mp4fLzGvHbT4d6YAsRF5znlBGI=;
        b=TLwflMwkld7+P/CKTDZA/PJb9dgwwHaeEZ04GuWIeIYCI14R5QDC4rDrRGzoR6Jt84pRI0
        3NuyqrPsmBJT4lRd+isNk24Us+3eKDpqTc/uLZQ0AqF7/MMtE7mDZCI0Oj0EmbkY5WWbjz
        Ktm/RyflsACtq+vAHj8hLv3w396VMtc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-266-EcLY5gSRND-USyzK5psL5A-1; Tue, 21 Mar 2023 09:48:06 -0400
X-MC-Unique: EcLY5gSRND-USyzK5psL5A-1
Received: by mail-ed1-f72.google.com with SMTP id b1-20020aa7dc01000000b004ad062fee5eso21896891edu.17
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 06:48:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679406485;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bnzw40W4FEb0L33e1Mp4fLzGvHbT4d6YAsRF5znlBGI=;
        b=SuSMFIhEBKdr17FbfC+MQMOMTYobacGywVDqBOdWZ5dOtbKoIGN24OyqcrHV+UdHjC
         fR9ytbhZAQx8Iws6Kp1a0bggaGrT/G/27zcE6uvMvNcqC89mebSqkcww/+5VUlbSEq9x
         1cfDC78TIWIQ4VDNwzQ+X6dFPV+EBz3o2pMowsyG5pOAQBB54jZNXj3mHxifiaTGGya5
         JkXdibV8zH8rJxN297tYB6ZugWL8AFrwzqN7w/1L27t54RTOSLgqNkWqUQtsrDdM2hzs
         AxTw07f3BNsqdeCsXstei3eBybnw9uJlOvyoP5nDsaUCwD73ZZ/AOzx1Bo9WpieVuOEv
         I77Q==
X-Gm-Message-State: AO0yUKWKIdVV8f1VlnLPRk6lMVMSt1vEB+4avhmNPThLtfU2UZjMTlBt
        B/ei1gpz0/bp6Apzpju2+ug2m05ZOwPKyHxLjWx6/n9S+WFM6/LVql37SNgEkoUGRc0U+iZ5k4Z
        4jtmfHstNKdL8c73b
X-Received: by 2002:a17:906:a219:b0:931:c7fd:10b1 with SMTP id r25-20020a170906a21900b00931c7fd10b1mr3051146ejy.19.1679406485417;
        Tue, 21 Mar 2023 06:48:05 -0700 (PDT)
X-Google-Smtp-Source: AK7set+569YcCQkBJfLUuFvWudGUBTxjUXWfsTiV3jSvd8/LLOnVaaorSzvRy1+EfecXtbKBu0X6qA==
X-Received: by 2002:a17:906:a219:b0:931:c7fd:10b1 with SMTP id r25-20020a170906a21900b00931c7fd10b1mr3051122ejy.19.1679406485145;
        Tue, 21 Mar 2023 06:48:05 -0700 (PDT)
Received: from [192.168.42.100] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id l19-20020a170906079300b00932ed432475sm4657809ejc.124.2023.03.21.06.48.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 06:48:04 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <985e1576-7191-9f65-d96f-3f51cf01044b@redhat.com>
Date:   Tue, 21 Mar 2023 14:48:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net, anthony.l.nguyen@intel.com,
        yoong.siang.song@intel.com, boon.leong.ong@intel.com
Subject: Re: [xdp-hints] Re: [PATCH bpf-next V1 1/7] xdp: bpf_xdp_metadata use
 EOPNOTSUPP for no driver support
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Stanislav Fomichev <sdf@google.com>
References: <167906343576.2706833.17489167761084071890.stgit@firesoul>
 <167906359575.2706833.545256364239637451.stgit@firesoul>
 <ZBTZ7J9B6yXNJO1m@google.com>
 <f42ff647-11b2-4f09-7652-ad85d35b5617@redhat.com> <87bkkm8f6y.fsf@toke.dk>
In-Reply-To: <87bkkm8f6y.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21/03/2023 13.24, Toke Høiland-Jørgensen wrote:
> Jesper Dangaard Brouer <jbrouer@redhat.com> writes:
> 
>> On 17/03/2023 22.21, Stanislav Fomichev wrote:
>>> On 03/17, Jesper Dangaard Brouer wrote:
>>>> When driver doesn't implement a bpf_xdp_metadata kfunc the fallback
>>>> implementation returns EOPNOTSUPP, which indicate device driver doesn't
>>>> implement this kfunc.
>>>
>>>> Currently many drivers also return EOPNOTSUPP when the hint isn't
>>>> available, which is inconsistent from an API point of view. Instead
>>>> change drivers to return ENODATA in these cases.
>>>
>>>> There can be natural cases why a driver doesn't provide any hardware
>>>> info for a specific hint, even on a frame to frame basis (e.g. PTP).
>>>> Lets keep these cases as separate return codes.
>>>
>>>> When describing the return values, adjust the function kernel-doc layout
>>>> to get proper rendering for the return values.
>>>
>>>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>>>
>>> I don't remember whether the previous discussion ended in something?
>>> IIRC Martin was preferring to use xdp-features for this instead?
>>>
>>
>> IIRC Martin asked for a second vote/opinion to settle the vote.
>> The xdp-features use is orthogonal and this patch does not prohibit the
>> later implementation of xdp-features, to detect if driver doesn't
>> implement kfuncs via using global vars.  Not applying this patch leaves
>> the API in an strange inconsistent state, because of an argument that in
>> the *future* we can use xdp-features to solve *one* of the discussed
>> use-cases for another return code.
>> I argued for a practical PTP use-case where not all frames contain the
>> PTP timestamp.  This patch solve this use-case *now*, so I don't see why
>> we should stall solving this, because of a "future" feature we might
>> never get around to implement, which require the user to use global vars.
>>
>>
>>> Personally I'm fine with having this convention, but I'm not sure how well
>>> we'll be able to enforce them. (In general, I'm not a fan of userspace
>>> changing it's behavior based on errno. If it's mostly for
>>> debugging/development - seems ok)
>>>
>>
>> We enforce the API by documenting the return behavior, like below.  If a
>> driver violate this, then we will fix the driver code with a fixes tag.
>>
>> My ask is simply let not have ambiguous return codes.
> 
> FWIW I don't get the opposition to this patch: having distinct return
> codes strictly increases the amount of information that is available to
> the caller. Even if some driver happens to use the "wrong" return code,
> it's still an improvement for all the drivers that do the right thing
> (and, well, we can fix broken drivers). And if a BPF program doesn't
> care about the type of failure they can just ignore treat all error
> codes the same; realistically, that is what most programs will do, but
> that doesn't mean we can't provide the more-granular error codes to the
> programs that do care.
> 
> My only concern with this patch is that it targets bpf-next and carries
> no Fixes tag, so we'll end up with a kernel release that doesn't have
> this change...
> 

Good point, I'll send this patch against 'bpf' tree instead.

--Jesper

