Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3349F6E257A
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 16:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbjDNOTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 10:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjDNOTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 10:19:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F5A7ED2
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 07:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681481926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sX4uJHc1E4iUI/WZObcqqEuHDDY4tzWA7F305PZUU8s=;
        b=ME9FFBiDQ38nt6+105/oZVcYwfdt4/iNMdA74alPteNd1KODKEevsxhR+KssYuguU+DmxM
        Uda6WyqE+tBl2O0lOCSHpq07TfS9JC9WoHLHnHRSc2aGx8ERv/OU/Th9igBM/Wi1KYgd3q
        Tm8XBX1WZr1Q+0umjWTDKneU8RQ9jUo=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-142-wLOwV0NNOjOiAJQTKL1KOA-1; Fri, 14 Apr 2023 10:18:43 -0400
X-MC-Unique: wLOwV0NNOjOiAJQTKL1KOA-1
Received: by mail-ej1-f70.google.com with SMTP id vc12-20020a170907d08c00b0094e793d95efso3042455ejc.15
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 07:18:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681481922; x=1684073922;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sX4uJHc1E4iUI/WZObcqqEuHDDY4tzWA7F305PZUU8s=;
        b=UP6HFu4difJBxKBwezOpbQedlDwsfoCLx1pKp9xTKw3dKJjiOu8P0kB1lq9fAMtzhX
         qaALkNnSVp/2Zm3q7TUfMiUYhlIl4Oon/9HKb+X1bn9AZCtd3uRjRioFbnX1FtZ0CiC6
         yBUGccbyd2lmlhvA2c1/k5vIpL7CCAVP9TXys14B9hbS7Zva892qcQ9INcPxS9DGIiE8
         s6ZkUR2/3RK8SaYDDQo0JzvX6/ZUFYbD/Xij+b3iE3HL8DUv4kMacupmaRWVhJGIveS/
         EmNOmA2OytB9gPsPt5MrJayDFVI9xR0wy1EA65/N4DkKwe/O+53ME9Y0NnXO3NQknx37
         0wBQ==
X-Gm-Message-State: AAQBX9cjwJh3nrsyzS9OgpqocKrubvLRZh7a4yDwqrd7cHF7ml2jkfJ+
        1HigMULzPBwMQB3GarKK4n2c5yXSiCaMHFCcIFWi7TBqMXWTF6OIwpYyqJypb+j8lGL0baFwu1U
        V3Z3dbRXDL1RjdgaT
X-Received: by 2002:a17:907:7241:b0:94a:643e:9e26 with SMTP id ds1-20020a170907724100b0094a643e9e26mr5922547ejc.14.1681481922654;
        Fri, 14 Apr 2023 07:18:42 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZGanoF3DPoBXFRBQWN2exgOX9hffPn/GzhyqL5JtNnAtLoKcw780bho7MF1qA/qcnMgOnwzA==
X-Received: by 2002:a17:907:7241:b0:94a:643e:9e26 with SMTP id ds1-20020a170907724100b0094a643e9e26mr5922524ejc.14.1681481922343;
        Fri, 14 Apr 2023 07:18:42 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id p9-20020a170906838900b009497509fda3sm2503755ejx.40.2023.04.14.07.18.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 07:18:41 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <a81e4d8e-c668-5238-225a-8223af45a063@redhat.com>
Date:   Fri, 14 Apr 2023 16:18:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: Re: [PATCH net v2 1/1] igc: read before write to SRRCTL register
Content-Language: en-US
To:     David Laight <David.Laight@ACULAB.COM>,
        "'Song, Yoong Siang'" <yoong.siang.song@intel.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        "Joseph, Jithu" <jithu.joseph@intel.com>,
        Andre Guedes <andre.guedes@intel.com>,
        Stanislav Fomichev <sdf@google.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>
References: <20230414020915.1869456-1-yoong.siang.song@intel.com>
 <8214fb10-8caa-4418-8435-85b6ac27b69e@redhat.com>
 <PH0PR11MB5830D3F9144B61A6959A4A0FD8999@PH0PR11MB5830.namprd11.prod.outlook.com>
 <4dc9ea6c77ff49138a49d7f73f7301fd@AcuMS.aculab.com>
In-Reply-To: <4dc9ea6c77ff49138a49d7f73f7301fd@AcuMS.aculab.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14/04/2023 14.32, David Laight wrote:
> From: Song, Yoong Siang
>> Sent: 14 April 2023 12:16
> ...
>>> I have checked Foxville manual for SRRCTL (Split and Replication Receive
>>> Control) register and below GENMASKs looks correct.
>>>
>>>> -#define IGC_SRRCTL_BSIZEPKT_SHIFT		10 /* Shift _right_ */
>>>> -#define IGC_SRRCTL_BSIZEHDRSIZE_SHIFT		2  /* Shift _left_ */
>>>> +#define IGC_SRRCTL_BSIZEPKT_MASK	GENMASK(6, 0)
>>>> +#define IGC_SRRCTL_BSIZEPKT_SHIFT	10 /* Shift _right_ */
>>>
>>> Shift due to 1 KB resolution of BSIZEPKT (manual field BSIZEPACKET)
>>
>> Ya, 1K = BIT(10), so need to shift right 10 bits.
> 
> I bet the code would be easier to read if it did 'value / 1024u'.
> The object code will be (much) the same.

I agree. Code becomes more readable for humans and machine code will be 
the same.

>>>> +#define IGC_SRRCTL_BSIZEHDRSIZE_MASK	GENMASK(13, 8)
>>>> +#define IGC_SRRCTL_BSIZEHDRSIZE_SHIFT	2  /* Shift _left_ */
>>>
>>> This shift is suspicious, but as you inherited it I guess it works.
>>> I did the math, and it happens to work, knowing (from manual) value is in 64 bytes
>>> resolution.
>>
>> It is in 64 = BIT(6) resolution, so need to shift right 6 bits.
>> But it start on 8th bit, so need to shift left 8 bits.
>> Thus, total = shift left 2 bits.
>>
>> I didnt put the explanation into the header file because it is too lengthy
>> and user can know from databook.

Well, users usually don't have access to the databook (Programming
Interface) PDF.  Personally I have it, but I had to go though a lot of
red-tape to get it (under Red Hat NDA).


>>
>> How do you feel on the necessary of explaining the shifting logic?
> 
> Not everyone trying to grok the code will have the manual.
> Even writing (8 - 6) will help.
> Or (I think) if the value is in bits 13-8 in units of 64 then just:
> 	((value >> 8) & 0x1f) * 64
> gcc will do a single shift right and a mask 9at some point).
> You might want some defines, but if they aren't used much
> just comments that refer to the names in the manual/datasheet
> can be enough.
> 

After Alexander Lobakin opened my eyes for GENMASK, FIELD_PREP and
FIELD_GET, I find that easier to read and work-with these kind of
register value manipulations, see[1] include/linux/bitfield.h.  It will
also detect if the assigned value exceeds the mask (like David code
handled via mask). (thx Alex)

  [1] 
https://elixir.bootlin.com/linux/v6.3-rc6/source/include/linux/bitfield.h#L14

So, instead of:
   srrctl |= IGC_RX_HDR_LEN << IGC_SRRCTL_BSIZEHDRSIZE_SHIFT;

I would write

   /* BSIZEHDR value in 64 bytes resolution */
   srrctl |= FIELD_PREP(IGC_SRRCTL_BSIZEHDRSIZE_MASK, (IGC_RX_HDR_LEN / 
64));

--Jesper

