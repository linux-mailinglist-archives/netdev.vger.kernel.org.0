Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8A05B37E2
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 14:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiIIMfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 08:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbiIIMfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 08:35:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6620113F80
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 05:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662726942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pGqx2u62hLKKX3N8RYLvbvUVmBm3+8IM9BjADWlLTPk=;
        b=PAT9KSoV1v0cZ612R5k2DRr6Tzad+L+kSgV8+yefcJE2hIAPbK9QcNXgH/Ft9NuFC0zAPP
        Z/ieWM4PYmSb/6Jhzak5c1gLMLy5zYOIDtR512qN3LzJk/qiiHTGwg9vaRWWweatcjyzzk
        1hf/JtUJCiq1P3EaWnoERASPvI/qSPE=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-329-wiXzYFArMD28UMruCfky_w-1; Fri, 09 Sep 2022 08:35:41 -0400
X-MC-Unique: wiXzYFArMD28UMruCfky_w-1
Received: by mail-ej1-f71.google.com with SMTP id hp14-20020a1709073e0e00b00741a2093c4aso956156ejc.20
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 05:35:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=pGqx2u62hLKKX3N8RYLvbvUVmBm3+8IM9BjADWlLTPk=;
        b=z4VetCQTggbyYf6Wa3jZziYjW+tBduSDW6b9SCW2jVvyQKcE0LM6VKG0WwM4vnZqWQ
         mc2YlOVrwQBxcgzo48NX1C4hKEI7SibFW6NhtlCwOgIYutshLoQp4SZX9UYRGmlYyzT8
         GQrCFDrhl+WMYMcg4wFRmhMxAMrlI5Qgjo4I9ILxHhmZkRh8Et1+JuuTPgNrhoV0LX2r
         RZz/4gI8b89mVbZ5ZgCeAgFtYpx9rSGAVf+GuFDFsmXCs3Rl2SvWM/wEUEMatLwAt2du
         iElEhVOxU69glDjJTRTB8tDsybLrIL5o1dVv3dw41JmnJ/f9yThWCoZPkESyl7jTPW6B
         MvSA==
X-Gm-Message-State: ACgBeo1StUu2M93KYVN44+xtRFsRMAa71QUDAdABpGQFoR49tSbUbil0
        j5q+EgTgVAsdZiL8bQhQGlVUC4tWZ4Q13u1WhuWRfCHBHyLHPxOcYiYMozzMoILjJhxIbVeKHnY
        PJQuStbHgUMNb9lIu
X-Received: by 2002:a17:906:730d:b0:73d:c8a1:a8ee with SMTP id di13-20020a170906730d00b0073dc8a1a8eemr9657489ejc.661.1662726939925;
        Fri, 09 Sep 2022 05:35:39 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7xrdLT+WULchCpcxHkmJP6SFvHuAIXTrdsDzhV2eFGA/BoDIs1Xs3kBZx6e509ipV8zqUVew==
X-Received: by 2002:a17:906:730d:b0:73d:c8a1:a8ee with SMTP id di13-20020a170906730d00b0073dc8a1a8eemr9657471ejc.661.1662726939652;
        Fri, 09 Sep 2022 05:35:39 -0700 (PDT)
Received: from [192.168.41.81] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id h22-20020a1709067cd600b0072f112a6ad2sm217729ejp.97.2022.09.09.05.35.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Sep 2022 05:35:39 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <51f40ca1-ccf2-bcc3-d20d-931ad0d22526@redhat.com>
Date:   Fri, 9 Sep 2022 14:35:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Cc:     brouer@redhat.com, Maryam Tahhan <mtahhan@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org, Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: Re: [xdp-hints] Re: [PATCH RFCv2 bpf-next 17/18] xsk: AF_XDP
 xdp-hints support in desc options
Content-Language: en-US
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
 <166256558657.1434226.7390735974413846384.stgit@firesoul>
 <CAJ8uoz3UcC2tnMtG8W6a3HpCKgaYSzSCqowLFQVwCcsr+NKBOQ@mail.gmail.com>
 <b5f0d10d-2d4e-34d6-1e45-c206cb6f5d26@redhat.com>
 <9aab9ef1-446d-57ab-5789-afffe27801f4@redhat.com>
 <CAJ8uoz0CD18RUYU4SMsubB8fhv3uOwp6wi_uKsZSu_aOV5piaA@mail.gmail.com>
 <e1ab2141-03cc-f97c-3788-59923a029203@redhat.com>
 <593cc1df-8b65-ae9e-37eb-091b19c4d00e@redhat.com>
 <CAJ8uoz1omnp888MoZT4AgiPVWo=Ef5nkQApzz7fqnqdcGgR6NA@mail.gmail.com>
In-Reply-To: <CAJ8uoz1omnp888MoZT4AgiPVWo=Ef5nkQApzz7fqnqdcGgR6NA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09/09/2022 12.14, Magnus Karlsson wrote:
> On Fri, Sep 9, 2022 at 11:42 AM Jesper Dangaard Brouer
> <jbrouer@redhat.com> wrote:
>>
>>
>> On 09/09/2022 10.12, Maryam Tahhan wrote:
>>> <snip>
>>>>>>>
>>>>>>> * Instead encode this information into each metadata entry in the
>>>>>>> metadata area, in some way so that a flags field is not needed (-1
>>>>>>> signifies not valid, or whatever happens to make sense). This has the
>>>>>>> drawback that the user might have to look at a large number of entries
>>>>>>> just to find out there is nothing valid to read. To alleviate this, it
>>>>>>> could be combined with the next suggestion.
>>>>>>>
>>>>>>> * Dedicate one bit in the options field to indicate that there is at
>>>>>>> least one valid metadata entry in the metadata area. This could be
>>>>>>> combined with the two approaches above. However, depending on what
>>>>>>> metadata you have enabled, this bit might be pointless. If some
>>>>>>> metadata is always valid, then it serves no purpose. But it might if
>>>>>>> all enabled metadata is rarely valid, e.g., if you get an Rx timestamp
>>>>>>> on one packet out of one thousand.
>>>>>>>
>>>>>
>>>>> I like this option better! Except that I have hoped to get 2 bits ;-)
>>>>
>>>> I will give you two if you need it Jesper, no problem :-).
>>>>
>>>
>>> Ok I will look at implementing and testing this and post an update.
>>
>> Perfect if you Maryam have cycles to work on this.
>>
>> Let me explain what I wanted the 2nd bit for.  I simply wanted to also
>> transfer the XDP_FLAGS_HINTS_COMPAT_COMMON flag.  One could argue that
>> is it redundant information as userspace AF_XDP will have to BTF decode
>> all the know XDP-hints. Thus, it could know if a BTF type ID is
>> compatible with the common struct.   This problem is performance as my
>> userspace AF_XDP code will have to do more code (switch/jump-table or
>> table lookup) to map IDs to common compat (to e.g. extract the RX-csum
>> indication).  Getting this extra "common-compat" bit is actually a
>> micro-optimization.  It is up to AF_XDP maintainers if they can spare
>> this bit.
>>
>>
>>> Thanks folks
>>>
>>>>> The performance advantage is that the AF_XDP descriptor bits will
>>>>> already be cache-hot, and if it indicates no-metadata-hints the AF_XDP
>>>>> application can avoid reading the metadata cache-line :-).
>>>>
>>>> Agreed. I prefer if we can keep it simple and fast like this.
>>>>
>>
>> Great, lets proceed this way then.
>>
>>> <snip>
>>>
>>
>> Thinking ahead: We will likely need 3 bits.
>>
>> The idea is that for TX-side, we set a bit indicating that AF_XDP have
>> provided a valid XDP-hints layout (incl corresponding BTF ID). (I would
>> overload and reuse "common-compat" bit if TX gets a common struct).
> 
> I think we should reuse the "Rx metadata valid" flag for this since
> this will not be used in the Tx case by definition. In the Tx case,
> this bit would instead mean that the user has provided a valid
> XDP-hints layout. It has a nice symmetry, on Rx it is set by the
> kernel when it has put something relevant in the metadata area. On Tx,
> it is set by user-space if it has put something relevant in the
> metadata area. 

I generally like reusing the bit, *BUT* there is the problem of 
(existing) applications ignoring the desc-options bit and forwarding 
packets.  This would cause the "Rx metadata valid" flag to be seen as 
userspace having set the "TX-hints-bit" and kernel would use what is 
provided in metadata area (leftovers from RX-hints).  IMHO that will be 
hard to debug for end-users and likely break existing applications.

> We can also reuse this bit when we get a notification
> in the completion queue to indicate if the kernel has produced some
> metadata on tx completions. This could be a Tx timestamp for example.
> 

Big YES, reuse "Rx metadata valid" bit when we get a TX notification in 
completion queue.  This will be okay because it cannot be forgotten and 
misinterpreted as the kernel will have responsibility to update this bit.

> So hopefully we could live with only two bits :-).
> 

I still think we need three bits ;-)
That should be enough to cover the 6 states:
  - RX hints
  - RX hints and compat
  - TX hints
  - TX hints and compat
  - TX completion
  - TX completion and compat


>> But lets land RX-side first, but make sure we can easily extend for the
>> TX-side.

