Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE68624A35
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 20:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbiKJTFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 14:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiKJTEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 14:04:40 -0500
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EAF3C6F8;
        Thu, 10 Nov 2022 11:04:38 -0800 (PST)
Message-ID: <7eb3e22a-c416-e898-dff0-1146d3cc82c0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668107075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+NSPXeLQ/Mg0rCIKeH+oDdwD6iVX2B+YTMnbLZkHni4=;
        b=o1DspNdBKs9kWMisaewWSwdQEiy7LnpDmQcUnj11PH3HsYa9jwEXdebpykTPCEve+U0if0
        KU/zgbiiPfvKEzBcNsVhH+oHEOvH4Kko0ahM7o77KpE5R1a+PGeEWLjfijRNXnhZJJzYl3
        gS9YT5cLFdF3H+F1WTmZZDlQU0PsuXU=
Date:   Thu, 10 Nov 2022 11:04:28 -0800
MIME-Version: 1.0
Subject: Re: [xdp-hints] Re: [RFC bpf-next v2 06/14] xdp: Carry over xdp
 metadata into skb context
Content-Language: en-US
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <871qqazyc9.fsf@toke.dk>
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

On 11/10/22 6:19 AM, Toke Høiland-Jørgensen wrote:
> Martin KaFai Lau <martin.lau@linux.dev> writes:
> 
>> On 11/9/22 3:10 AM, Toke Høiland-Jørgensen wrote:
>>> Snipping a bit of context to reply to this bit:
>>>
>>>>>>> Can the xdp prog still change the metadata through xdp->data_meta? tbh, I am not
>>>>>>> sure it is solid enough by asking the xdp prog not to use the same random number
>>>>>>> in its own metadata + not to change the metadata through xdp->data_meta after
>>>>>>> calling bpf_xdp_metadata_export_to_skb().
>>>>>>
>>>>>> What do you think the usecase here might be? Or are you suggesting we
>>>>>> reject further access to data_meta after
>>>>>> bpf_xdp_metadata_export_to_skb somehow?
>>>>>>
>>>>>> If we want to let the programs override some of this
>>>>>> bpf_xdp_metadata_export_to_skb() metadata, it feels like we can add
>>>>>> more kfuncs instead of exposing the layout?
>>>>>>
>>>>>> bpf_xdp_metadata_export_to_skb(ctx);
>>>>>> bpf_xdp_metadata_export_skb_hash(ctx, 1234);
>>>
>>> There are several use cases for needing to access the metadata after
>>> calling bpf_xdp_metdata_export_to_skb():
>>>
>>> - Accessing the metadata after redirect (in a cpumap or devmap program,
>>>     or on a veth device)
>>> - Transferring the packet+metadata to AF_XDP
>> fwiw, the xdp prog could also be more selective and only stores one of the hints
>> instead of the whole 'struct xdp_to_skb_metadata'.
> 
> Yup, absolutely! In that sense, reusing the SKB format is mostly a
> convenience feature. However, lots of people consume AF_XDP through the
> default program installed by libxdp in the XSK setup code, and including
> custom metadata there is awkward. So having the metadata consumed by the
> stack as the "default subset" would enable easy consumption by
> non-advanced users, while advanced users can still do custom stuff by
> writing their own XDP program that calls the kfuncs.
> 
>>> - Returning XDP_PASS, but accessing some of the metadata first (whether
>>>     to read or change it)
>>>
>>> The last one could be solved by calling additional kfuncs, but that
>>> would be less efficient than just directly editing the struct which
>>> will be cache-hot after the helper returns.
>>
>> Yeah, it is more efficient to directly write if possible.  I think this set
>> allows the direct reading and writing already through data_meta (as a _u8 *).
> 
> Yup, totally fine with just keeping that capability :)
> 
>>> And yeah, this will allow the XDP program to inject arbitrary metadata
>>> into the netstack; but it can already inject arbitrary *packet* data
>>> into the stack, so not sure if this is much of an additional risk? If it
>>> does lead to trivial crashes, we should probably harden the stack
>>> against that?
>>>
>>> As for the random number, Jesper and I discussed replacing this with the
>>> same BTF-ID scheme that he was using in his patch series. I.e., instead
>>> of just putting in a random number, we insert the BTF ID of the metadata
>>> struct at the end of it. This will allow us to support multiple
>>> different formats in the future (not just changing the layout, but
>>> having multiple simultaneous formats in the same kernel image), in case
>>> we run out of space.
>>
>> This seems a bit hypothetical.  How much headroom does it usually have for the
>> xdp prog?  Potentially the hints can use all the remaining space left after the
>> header encap and the current bpf_xdp_adjust_meta() usage?
> 
> For the metadata consumed by the stack right now it's a bit
> hypothetical, yeah. However, there's a bunch of metadata commonly
> supported by hardware that the stack currently doesn't consume and that
> hopefully this feature will end up making more accessible. My hope is
> that the stack can also learn how to use this in the future, in which
> case we may run out of space. So I think of that bit mostly as
> future-proofing...

ic. in this case, Can the btf_id be added to 'struct xdp_to_skb_metadata' later 
if it is indeed needed?  The 'struct xdp_to_skb_metadata' is not in UAPI and 
doing it with CO-RE is to give us flexibility to make this kind of changes in 
the future.

> 
>>> We should probably also have a flag set on the xdp_frame so the stack
>>> knows that the metadata area contains relevant-to-skb data, to guard
>>> against an XDP program accidentally hitting the "magic number" (BTF_ID)
>>> in unrelated stuff it puts into the metadata area.
>>
>> Yeah, I think having a flag is useful.  The flag will be set at xdp_buff and
>> then transfer to the xdp_frame?
> 
> Yeah, exactly!
> 
>>>> After re-reading patch 6, have another question. The 'void
>>>> bpf_xdp_metadata_export_to_skb();' function signature. Should it at
>>>> least return ok/err? or even return a 'struct xdp_to_skb_metadata *'
>>>> pointer and the xdp prog can directly read (or even write) it?
>>>
>>> Hmm, I'm not sure returning a failure makes sense? Failure to read one
>>> or more fields just means that those fields will not be populated? We
>>> should probably have a flags field inside the metadata struct itself to
>>> indicate which fields are set or not, but I'm not sure returning an
>>> error value adds anything? Returning a pointer to the metadata field
>>> might be convenient for users (it would just be an alias to the
>>> data_meta pointer, but the verifier could know its size, so the program
>>> doesn't have to bounds check it).
>>
>> If some hints are not available, those hints should be initialized to
>> 0/CHECKSUM_NONE/...etc.
> 
> The problem with that is that then we have to spend cycles writing
> eight bytes of zeroes into the checksum field :)

With a common 'struct xdp_to_skb_metadata', I am not sure how some of these zero 
writes can be avoided.  If the xdp prog wants to optimize, it can call 
individual kfunc to get individual hints.

> 
>> The xdp prog needs a direct way to tell hard failure when it cannot
>> write the meta area because of not enough space. Comparing
>> xdp->data_meta with xdp->data as a side effect is not intuitive.
> 
> Yeah, hence a flags field so we can just see if setting each field
> succeeded?

How testing a flag is different from checking 0/invalid-value of a field?  or 
some fields just don't have an invalid value to check for like vlan_tci?

You meant a flags field as a return value or in the 'struct xdp_to_skb_metadata' ?

> 
>> It is more than saving the bound check.  With type info of 'struct
>> xdp_to_skb_metadata *', the verifier can do more checks like reading in the
>> middle of an integer member.  The verifier could also limit write access only to
>> a few struct's members if it is needed.
>>
>> The returning 'struct xdp_to_skb_metadata *' should not be an alias to the
>> xdp->data_meta.  They should actually point to different locations in the
>> headroom.  bpf_xdp_metadata_export_to_skb() sets a flag in xdp_buff.
>> xdp->data_meta won't be changed and keeps pointing to the last
>> bpf_xdp_adjust_meta() location.  The kernel will know if there is
>> xdp_to_skb_metadata before the xdp->data_meta when that bit is set in the
>> xdp_{buff,frame}.  Would it work?
> 
> Hmm, logically splitting the program metadata and the xdp_hints metadata
> (but having them share the same area) *could* work, I guess, I'm just
> not sure it's worth the extra complexity?

It shouldn't stop the existing xdp prog writing its own metadata from using the 
the new bpf_xdp_metadata_export_to_skb().

> 
>>>> A related question, why 'struct xdp_to_skb_metadata' needs
>>>> __randomize_layout?
>>>
>>> The __randomize_layout thing is there to force BPF programs to use CO-RE
>>> to access the field. This is to avoid the struct layout accidentally
>>> ossifying because people in practice rely on a particular layout, even
>>> though we tell them to use CO-RE. There are lots of examples of this
>>> happening in other domains (IP header options, TCP options, etc), and
>>> __randomize_layout seemed like a neat trick to enforce CO-RE usage :)
>>
>> I am not sure if it is necessary or helpful to only enforce __randomize_layout
>> in 'struct xdp_to_skb_metadata'.  There are other CO-RE use cases (tracing and
>> non tracing) that already have direct access (reading and/or writing) to other
>> kernel structures.
>>
>> It is more important for the verifier to see the xdp prog accessing it as a
>> 'struct xdp_to_skb_metadata *' instead of xdp->data_meta which is a __u8 * so
>> that the verifier can enforce the rules of access.
> 
> That only works inside the kernel, though. Since the metadata field can
> be copied wholesale to AF_XDP, having it randomized forces userspace
> consumers to also write code to deal with the layout being dynamic...

hm... I still don't see how useful it is, in particular you mentioned the libxdp 
will install a xdp prog to write this default format (xdp_to_skb_metadata) and 
likely libxdp will also provide some helpers to parse the xdp_to_skb_metadata 
and the libxdp user should not need to know if CO-RE is used or not. 
Considering it is a kernel internal struct, I think it is fine to keep it and 
can be revisited later if needed.  Lets get on to other things first :)

