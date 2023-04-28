Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95BD26F1517
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 12:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345595AbjD1KOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 06:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345347AbjD1KOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 06:14:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42021735
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 03:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682676834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o0hfmSjrbmFcUA3spV8vN0sZHy4e8avPyPdESyqTTH0=;
        b=h/E9rwa8KNhsRTeWV6lM5eRrAENDkqgKaVhOvKNkXhCKreGDPq2orhPsezPJKrHtIDRx0u
        BaRs8zG7nYngTUw4VnRon1D/NTnuEPeznGnJwBwtVSfbwFhmm8iZq/xvzrunzcGxSS1N0K
        z61kK6dlgStzPM3mZvKe9ffvWcogcjs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-148-fFRD53elNhG1IWsx_JT2qw-1; Fri, 28 Apr 2023 06:13:52 -0400
X-MC-Unique: fFRD53elNhG1IWsx_JT2qw-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-504ecbc85c2so10959873a12.1
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 03:13:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682676831; x=1685268831;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o0hfmSjrbmFcUA3spV8vN0sZHy4e8avPyPdESyqTTH0=;
        b=Y5FYmyD8/ZmaUD67ihS75OikwngBDm1/2WgdCOl+ObqDYBa1kn8hhWiKA75wSxfRKQ
         BrphHVBlx/a/HdnPYSrc3ZXnd9wuFCD/FBnsdcRQvnITn/n32Qv6UrRTyyQYMdX5uU7T
         ZijFulxmxHyK/4wTrS55ZUpz6LoqG1LojV4bDXz6gu3IxtVvXnbQS7F2XJ7FKbHzrYTD
         RGLZkd9uAaNSQjXwhxFzv8y8DAHcRj5nkXXeYMeBNOD5R2OA5AkJP1OETO/KM8fVo6QN
         V3sI1JoAgjOFvVb5Z9Ll0FX6UdrN+W0TyaNTTA39EOXWgRKQ2GNo3REJXVdXm0ufCKyj
         gRbw==
X-Gm-Message-State: AC+VfDzbhVlcUV/G1LLPjHqMg/k/6aiI6xWVDYphB8XNebsuLcpLjPix
        oY9ZTGANcANRR0F2qfFCTYbIrksWuzRotLhg+gxnkvZ6zDGq9tybIKLmvOpzqRgumNG5Jszfa/L
        8NGRJNh5pvXu7iiGyoGdEtc2v
X-Received: by 2002:a05:6402:b22:b0:504:bde3:104 with SMTP id bo2-20020a0564020b2200b00504bde30104mr3726742edb.20.1682676831438;
        Fri, 28 Apr 2023 03:13:51 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7cveE8gzZX1Y02kVoAS/aujVy/7IMD6pXMByAMrrkr3Vm9T2UQrY1YT6T8mVbxkGw1R+cbQg==
X-Received: by 2002:a05:6402:b22:b0:504:bde3:104 with SMTP id bo2-20020a0564020b2200b00504bde30104mr3726710edb.20.1682676831096;
        Fri, 28 Apr 2023 03:13:51 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id a7-20020aa7d907000000b00506a09795e6sm8919954edr.26.2023.04.28.03.13.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Apr 2023 03:13:50 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <b9084797-ba50-d2c0-2c4f-e0964505126e@redhat.com>
Date:   Fri, 28 Apr 2023 12:13:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Cc:     brouer@redhat.com, netdev@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        John Fastabend <john.fastabend@gmail.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        yoong.siang.song@intel.com, intel-wired-lan@lists.osuosl.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com,
        Stanislav Fomichev <sdf@google.com>, kuba@kernel.org,
        edumazet@google.com, hawk@kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next V2 1/5] igc: enable and fix RX hash usage by
 netstack
Content-Language: en-US
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        davem@davemloft.net, bpf@vger.kernel.org
References: <168182460362.616355.14591423386485175723.stgit@firesoul>
 <168182464270.616355.11391652654430626584.stgit@firesoul>
 <644544b3206f0_19af02085e@john.notmuch>
 <622a8fa6-ec07-c150-250b-5467b0cddb0c@redhat.com>
 <6446d5af80e06_338f220820@john.notmuch>
 <e6bc2340-9cb5-def1-b347-af25ce2f8225@redhat.com>
 <86517b44-b998-a4ac-da13-1f30d5f69975@iogearbox.net>
In-Reply-To: <86517b44-b998-a4ac-da13-1f30d5f69975@iogearbox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 27/04/2023 19.00, Daniel Borkmann wrote:
> On 4/25/23 10:43 AM, Jesper Dangaard Brouer wrote:
>> On 24/04/2023 21.17, John Fastabend wrote:
>>>>> Just curious why not copy the logic from the other driver fms10k, 
>>>>> ice, ect.
>>>>>
>>>>>     skb_set_hash(skb, le32_to_cpu(rx_desc->wb.lower.hi_dword.rss),
>>>>>              (IXGBE_RSS_L4_TYPES_MASK & (1ul << rss_type)) ?
>>>>>              PKT_HASH_TYPE_L4 : PKT_HASH_TYPE_L3);
>>>> Detail: This code mis-categorize (e.g. ARP) PKT_HASH_TYPE_L2 as
>>>> PKT_HASH_TYPE_L3, but as core reduces this further to one SKB bit, it
>>>> doesn't really matter.
>>>>
>>>>> avoiding the table logic. Do the driver folks care?
>>>> The define IXGBE_RSS_L4_TYPES_MASK becomes the "table" logic as a 1-bit
>>>> true/false table.  It is a more compact table, let me know if this is
>>>> preferred.
>>>>
>>>> Yes, it is really upto driver maintainer people to decide, what code is
>>>> preferred ?
>>  >
>>> Yeah doesn't matter much to me either way. I was just looking at code
>>> compared to ice driver while reviewing.
>>
>> My preference is to apply this patchset. We/I can easily followup and
>> change this to use the more compact approach later (if someone prefers).
> 
> Consistency might help imo and would avoid questions/confusion on /why/
> doing it differently for igc vs some of the others.
>

Well, drivers often do things differently, so that not something new. I
found the other approach less readable (and theoretically wrong for the
L2 case).  For igc this approach makes it easier to read (IMHO I'm
biased of cause) and easier to compare with kfunc metadata hint type
(that doesn't have RSS type information loss).

>> I know net-next is "closed", but this patchset was posted prior to the
>> close.  Plus, a number of companies are waiting for the XDP-hint for HW
>> RX timestamp.  The support for driver stmmac is already in net-next
>> (commit e3f9c3e34840 ("net: stmmac: add Rx HWTS metadata to XDP receive
>> pkt")). Thus, it would be a help if both igc+stmmac changes land in same
>> kernel version, as both drivers are being evaluated by these companies.
> 
> Given merge window is open now and net-next closed, it's too late to land
> (unless Dave/Jakub thinks otherwise given it touches also driver bits).
> I've applied the series to bpf-next right now.

It's not a big deal that it didn't reached net-next, end-users will just
have to wait for another kernel release to see this feature, or backport
the feature themselves.

Thanks for applying it.

--Jesper

