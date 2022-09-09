Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 243D05B3441
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 11:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiIIJmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 05:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbiIIJmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 05:42:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D65ED6B86
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 02:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662716569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5iXKFaXwMwTj+qx5rpepg8IFprmEKxi1vIibj/a0OYc=;
        b=bK/l9YBHQPDf1/4xPd8idtn2JE2He9aQWi1DPsLncv2sEaJGLjJZeOyIES3xYlaW8956DW
        zKBZeGcTuSr4bZMwpVMePprOlUJqxSkJoZkX+D0nRaYjJ6Srzg4diT0RqUhOjF22nvXqnZ
        QYhTD+OQhG9gTIIEnXpf0WFSnuP3Pik=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-347-4zGhDmt8NfGv_v8VL2htug-1; Fri, 09 Sep 2022 05:42:45 -0400
X-MC-Unique: 4zGhDmt8NfGv_v8VL2htug-1
Received: by mail-ed1-f71.google.com with SMTP id b16-20020a056402279000b0044f1102e6e2so885572ede.20
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 02:42:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:cc:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=5iXKFaXwMwTj+qx5rpepg8IFprmEKxi1vIibj/a0OYc=;
        b=hI5s9yWFjbimPYddyN0e49SENQq6cHNSc6EuLfTsjnTC1qLy2ZZPpr1RbBayOkRVkw
         a+2AJYiQbam6Zv2Cdhh764Ieg8wJ7+5AcHycTgvalUnZqh3JqjW+IIXxZ9orieCoxn17
         jtblVF/Mt3SWimYGPxN+e/rU3bMWZLDtAskP+4GLR1poY+U1knw4j49YTfSpK6biWpjs
         ybpTjKMRlCRebAAGo8CRFMvlc/ljvZaOenKfc94XArLdcI17mw7ZmlM0EtYlOKmZKdwj
         f5Su9Zzepg1V2giqo1xi9BKQgBUS6XxYbD1/rF0FX4Ifv5HUEXdD7XYVU/N/RuPAGibD
         pIow==
X-Gm-Message-State: ACgBeo2Y0QOAG1fqoaD0Xd1yvUhkEJ5E0wcL+nntpB+bKoDDIkklxlih
        Zj157oy6Tq2WEHdaXmfixVW+TUBPtn+xzzfq0EwRWpU6eX1Gc6IShkNmWKXiB87Fpc7IDuDcVF3
        otBoCQG8SgD3Xf1Oe
X-Received: by 2002:a05:6402:351:b0:44e:1cd2:bd53 with SMTP id r17-20020a056402035100b0044e1cd2bd53mr10507099edw.364.1662716560197;
        Fri, 09 Sep 2022 02:42:40 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7VORBRl+U9ThWWjUQ2G9Wxzqu4Djdg56wVHmV/d5FLJ5A38wxS4QWjJ3t06dJtL6JweATOcw==
X-Received: by 2002:a05:6402:351:b0:44e:1cd2:bd53 with SMTP id r17-20020a056402035100b0044e1cd2bd53mr10507075edw.364.1662716559994;
        Fri, 09 Sep 2022 02:42:39 -0700 (PDT)
Received: from [192.168.41.81] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id c19-20020a056402121300b0044f0f51f813sm17379edw.83.2022.09.09.02.42.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Sep 2022 02:42:32 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <593cc1df-8b65-ae9e-37eb-091b19c4d00e@redhat.com>
Date:   Fri, 9 Sep 2022 11:42:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Cc:     brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Subject: Re: [PATCH RFCv2 bpf-next 17/18] xsk: AF_XDP xdp-hints support in
 desc options
To:     Maryam Tahhan <mtahhan@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
 <166256558657.1434226.7390735974413846384.stgit@firesoul>
 <CAJ8uoz3UcC2tnMtG8W6a3HpCKgaYSzSCqowLFQVwCcsr+NKBOQ@mail.gmail.com>
 <b5f0d10d-2d4e-34d6-1e45-c206cb6f5d26@redhat.com>
 <9aab9ef1-446d-57ab-5789-afffe27801f4@redhat.com>
 <CAJ8uoz0CD18RUYU4SMsubB8fhv3uOwp6wi_uKsZSu_aOV5piaA@mail.gmail.com>
 <e1ab2141-03cc-f97c-3788-59923a029203@redhat.com>
Content-Language: en-US
In-Reply-To: <e1ab2141-03cc-f97c-3788-59923a029203@redhat.com>
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


On 09/09/2022 10.12, Maryam Tahhan wrote:
> <snip>
>>>>>
>>>>> * Instead encode this information into each metadata entry in the
>>>>> metadata area, in some way so that a flags field is not needed (-1
>>>>> signifies not valid, or whatever happens to make sense). This has the
>>>>> drawback that the user might have to look at a large number of entries
>>>>> just to find out there is nothing valid to read. To alleviate this, it
>>>>> could be combined with the next suggestion.
>>>>>
>>>>> * Dedicate one bit in the options field to indicate that there is at
>>>>> least one valid metadata entry in the metadata area. This could be
>>>>> combined with the two approaches above. However, depending on what
>>>>> metadata you have enabled, this bit might be pointless. If some
>>>>> metadata is always valid, then it serves no purpose. But it might if
>>>>> all enabled metadata is rarely valid, e.g., if you get an Rx timestamp
>>>>> on one packet out of one thousand.
>>>>>
>>>
>>> I like this option better! Except that I have hoped to get 2 bits ;-)
>>
>> I will give you two if you need it Jesper, no problem :-).
>>
> 
> Ok I will look at implementing and testing this and post an update.

Perfect if you Maryam have cycles to work on this.

Let me explain what I wanted the 2nd bit for.  I simply wanted to also
transfer the XDP_FLAGS_HINTS_COMPAT_COMMON flag.  One could argue that
is it redundant information as userspace AF_XDP will have to BTF decode
all the know XDP-hints. Thus, it could know if a BTF type ID is
compatible with the common struct.   This problem is performance as my
userspace AF_XDP code will have to do more code (switch/jump-table or
table lookup) to map IDs to common compat (to e.g. extract the RX-csum
indication).  Getting this extra "common-compat" bit is actually a
micro-optimization.  It is up to AF_XDP maintainers if they can spare
this bit.


> Thanks folks
> 
>>> The performance advantage is that the AF_XDP descriptor bits will
>>> already be cache-hot, and if it indicates no-metadata-hints the AF_XDP
>>> application can avoid reading the metadata cache-line :-).
>>
>> Agreed. I prefer if we can keep it simple and fast like this.
>>

Great, lets proceed this way then.

> <snip>
> 

Thinking ahead: We will likely need 3 bits.

The idea is that for TX-side, we set a bit indicating that AF_XDP have
provided a valid XDP-hints layout (incl corresponding BTF ID). (I would
overload and reuse "common-compat" bit if TX gets a common struct).

But lets land RX-side first, but make sure we can easily extend for the 
TX-side.

--Jesper

