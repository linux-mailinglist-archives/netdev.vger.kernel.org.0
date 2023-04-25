Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8F7C6EDE74
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbjDYIrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233371AbjDYIqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:46:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10DCC14458
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 01:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682412197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z0zVDpGNPOtgS6OZt5Y/hC+DSyVwR0iNEJU4rcM7cZw=;
        b=L2Ky8ofjQIqadlMEBOTwC+MqXOR2Jkyecf0zsIqDBcdoN2RNaoLs2mTft5d4QGL1jzNamP
        5yuGmWr8xrXYgB6xfsU/4QJJ0ZEO1prnZDTUU7+DsiPnQYQwqbyj3ezzJWfyUrGfzxeB68
        Q3CsDA+WUi443XaF8P0UlF25ZZO19xY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-389-vUhRz2lzMwuzsPkP8CeLCQ-1; Tue, 25 Apr 2023 04:43:14 -0400
X-MC-Unique: vUhRz2lzMwuzsPkP8CeLCQ-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-95707df1f05so559579566b.3
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 01:43:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682412193; x=1685004193;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z0zVDpGNPOtgS6OZt5Y/hC+DSyVwR0iNEJU4rcM7cZw=;
        b=bgs7rX1E7HR/CuKr9S/3WcF/if2E7pD1rAPQ/pH/ILx4+Zy7/XbFel+M5ZZWSLNRz1
         oNH/oF1mEMWq547Y9jE3SGBj5PhCGiJePHwcFxCvm/rfMasxJRt1m2lQkktIzrFw1qFy
         iBev+l1dccFIxTTjDfopft/oJ8F2QBtkDqM3tcKpU6eVrBlvSyxq4kPEPX8dwOr1RaPT
         3e+pLwoI70c8vMdorDC3hBPdlCl5v/ACqvejkfDLLNO6awh+1WuQgAWAdGAh30No8VF1
         11aNM0fDL5dWfETuVcaWaCs52+46k/vIXeDFilvCwAVDmoNaFHNjDdX6amFiybNRXeki
         32PA==
X-Gm-Message-State: AAQBX9ffG0Aax+zPwMm1LmF74/lFJgaQYyMkGPx8z1r8s+dcL4VWkcf2
        mFgN2sw3KBGAlSeGFBN8s56ncYO/pfkX7ku4YYLg5kyC4/Yekdn5Xx2Jgge7mULkvj9LqmtxGLQ
        WdF8+o5JoIxky0n2B
X-Received: by 2002:a17:907:a688:b0:953:4d9e:4dc5 with SMTP id vv8-20020a170907a68800b009534d9e4dc5mr11371456ejc.22.1682412193247;
        Tue, 25 Apr 2023 01:43:13 -0700 (PDT)
X-Google-Smtp-Source: AKy350bMzEkeOJ+lrxIh0zBcCHx4TX83ikBmu1uOT+zXFM5ixyoq1CeTkKqu+M7H2eyoLrpcS9oLHw==
X-Received: by 2002:a17:907:a688:b0:953:4d9e:4dc5 with SMTP id vv8-20020a170907a68800b009534d9e4dc5mr11371436ejc.22.1682412192893;
        Tue, 25 Apr 2023 01:43:12 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id bh20-20020a170906a0d400b0094fbb76f49esm6589052ejb.17.2023.04.25.01.43.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Apr 2023 01:43:12 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <e6bc2340-9cb5-def1-b347-af25ce2f8225@redhat.com>
Date:   Tue, 25 Apr 2023 10:43:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
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
To:     davem@davemloft.net, bpf@vger.kernel.org, daniel@iogearbox.net
References: <168182460362.616355.14591423386485175723.stgit@firesoul>
 <168182464270.616355.11391652654430626584.stgit@firesoul>
 <644544b3206f0_19af02085e@john.notmuch>
 <622a8fa6-ec07-c150-250b-5467b0cddb0c@redhat.com>
 <6446d5af80e06_338f220820@john.notmuch>
In-Reply-To: <6446d5af80e06_338f220820@john.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 24/04/2023 21.17, John Fastabend wrote:
>>> Just curious why not copy the logic from the other driver fms10k, ice, ect.
>>>
>>> 	skb_set_hash(skb, le32_to_cpu(rx_desc->wb.lower.hi_dword.rss),
>>> 		     (IXGBE_RSS_L4_TYPES_MASK & (1ul << rss_type)) ?
>>> 		     PKT_HASH_TYPE_L4 : PKT_HASH_TYPE_L3);
>> Detail: This code mis-categorize (e.g. ARP) PKT_HASH_TYPE_L2 as
>> PKT_HASH_TYPE_L3, but as core reduces this further to one SKB bit, it
>> doesn't really matter.
>>
>>> avoiding the table logic. Do the driver folks care?
>> The define IXGBE_RSS_L4_TYPES_MASK becomes the "table" logic as a 1-bit
>> true/false table.  It is a more compact table, let me know if this is
>> preferred.
>>
>> Yes, it is really upto driver maintainer people to decide, what code is
>> preferred ?
 >
> Yeah doesn't matter much to me either way. I was just looking at code
> compared to ice driver while reviewing.

My preference is to apply this patchset. We/I can easily followup and
change this to use the more compact approach later (if someone prefers).

I know net-next is "closed", but this patchset was posted prior to the
close.  Plus, a number of companies are waiting for the XDP-hint for HW
RX timestamp.  The support for driver stmmac is already in net-next
(commit e3f9c3e34840 ("net: stmmac: add Rx HWTS metadata to XDP receive
pkt")). Thus, it would be a help if both igc+stmmac changes land in same
kernel version, as both drivers are being evaluated by these companies.

Pretty please,
--Jesper

