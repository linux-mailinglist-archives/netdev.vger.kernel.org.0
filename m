Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 440BC624FB7
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 02:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiKKBjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 20:39:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbiKKBjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 20:39:08 -0500
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A17D6175B;
        Thu, 10 Nov 2022 17:39:07 -0800 (PST)
Message-ID: <ed37045f-eb3d-8db0-4e5d-12bf7da8587e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668130746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=twDtSwj2Z37lCvXOgLdZKmh5FpMX714tcT+gZauocX4=;
        b=KOIpzGnbUf+6ykkdl3c9FO5xpydUPJ3oSwuzM6myq3dUhK/+2ddxSgHbU9kvQCY/0CxXvw
        kil1n3mvrlUGjXkDfmvRFkL2TxEsBRasxhG+Sc4RK9ZGk19KbiODfNiBKr93CiTDQQzHp+
        VQi1/+b8rH84Qo9pF1nSINvoWS2Zqm0=
Date:   Thu, 10 Nov 2022 17:39:00 -0800
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
Subject: Re: [xdp-hints] Re: [RFC bpf-next v2 06/14] xdp: Carry over xdp
 metadata into skb context
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     Stanislav Fomichev <sdf@google.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20221104032532.1615099-1-sdf@google.com>
 <20221104032532.1615099-7-sdf@google.com>
 <187e89c3-d7de-7bec-c72e-d9d6eb5bcca0@linux.dev>
 <CAKH8qBv_ZO=rsJcq2Lvq36d9sTAXs6kfUmW1Hk17bB=BGiGzhw@mail.gmail.com>
 <9a8fefe4-2fcb-95b7-cda0-06509feee78e@linux.dev>
 <6f57370f-7ec3-07dd-54df-04423cab6d1f@linux.dev> <87leokz8lq.fsf@toke.dk>
 <5a23b856-88a3-a57a-2191-b673f4160796@linux.dev> <871qqazyc9.fsf@toke.dk>
 <7eb3e22a-c416-e898-dff0-1146d3cc82c0@linux.dev> <87mt8yxuag.fsf@toke.dk>
Content-Language: en-US
In-Reply-To: <87mt8yxuag.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/10/22 3:29 PM, Toke Høiland-Jørgensen wrote:
>>> For the metadata consumed by the stack right now it's a bit
>>> hypothetical, yeah. However, there's a bunch of metadata commonly
>>> supported by hardware that the stack currently doesn't consume and that
>>> hopefully this feature will end up making more accessible. My hope is
>>> that the stack can also learn how to use this in the future, in which
>>> case we may run out of space. So I think of that bit mostly as
>>> future-proofing...
>>
>> ic. in this case, Can the btf_id be added to 'struct xdp_to_skb_metadata' later
>> if it is indeed needed?  The 'struct xdp_to_skb_metadata' is not in UAPI and
>> doing it with CO-RE is to give us flexibility to make this kind of changes in
>> the future.
> 
> My worry is mostly that it'll be more painful to add it later than just
> including it from the start, mostly because of AF_XDP users. But if we
> do the randomisation thing (thus forcing AF_XDP users to deal with the
> dynamic layout as well), it should be possible to add it later, and I
> can live with that option as well...

imo, considering we are trying to optimize unnecessary field initialization as 
below, it is sort of wasteful to always initialize the btf_id with the same 
value.  It is better to add it in the future when there is a need.

>>>>> We should probably also have a flag set on the xdp_frame so the stack
>>>>> knows that the metadata area contains relevant-to-skb data, to guard
>>>>> against an XDP program accidentally hitting the "magic number" (BTF_ID)
>>>>> in unrelated stuff it puts into the metadata area.
>>>>
>>>> Yeah, I think having a flag is useful.  The flag will be set at xdp_buff and
>>>> then transfer to the xdp_frame?
>>>
>>> Yeah, exactly!
>>>
>>>>>> After re-reading patch 6, have another question. The 'void
>>>>>> bpf_xdp_metadata_export_to_skb();' function signature. Should it at
>>>>>> least return ok/err? or even return a 'struct xdp_to_skb_metadata *'
>>>>>> pointer and the xdp prog can directly read (or even write) it?
>>>>>
>>>>> Hmm, I'm not sure returning a failure makes sense? Failure to read one
>>>>> or more fields just means that those fields will not be populated? We
>>>>> should probably have a flags field inside the metadata struct itself to
>>>>> indicate which fields are set or not, but I'm not sure returning an
>>>>> error value adds anything? Returning a pointer to the metadata field
>>>>> might be convenient for users (it would just be an alias to the
>>>>> data_meta pointer, but the verifier could know its size, so the program
>>>>> doesn't have to bounds check it).
>>>>
>>>> If some hints are not available, those hints should be initialized to
>>>> 0/CHECKSUM_NONE/...etc.
>>>
>>> The problem with that is that then we have to spend cycles writing
>>> eight bytes of zeroes into the checksum field :)
>>
>> With a common 'struct xdp_to_skb_metadata', I am not sure how some of these zero
>> writes can be avoided.  If the xdp prog wants to optimize, it can call
>> individual kfunc to get individual hints.
> 
> Erm, we just... don't write those fields? Something like:
> 
> void write_skb_meta(hw, ctx) {
>    struct xdp_skb_metadata meta = ctx->data_meta - sizeof(struct xdp_skb_metadata);
>    meta->valid_fields = 0;
> 
>    if (hw_has_timestamp) {
>      meta->timestamp = hw->timestamp;
>      meta->valid_fields |= FIELD_TIMESTAMP;
>    } /* otherwise meta->timestamp is just uninitialised */
> 
>    if (hw_has_rxhash) {
>      meta->rxhash = hw->rxhash;
>      meta->valid_fields |= FIELD_RXHASH;
>    } /* otherwise meta->rxhash is just uninitialised */
>    ...etc...
> }

Ah, got it.  Make sense.  My mind was stalled in the paradigm that a helper that 
needs to initialize the result.
