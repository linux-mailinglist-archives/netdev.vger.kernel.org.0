Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA4562324F
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 19:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiKISWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 13:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiKISWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 13:22:23 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A1E2792B;
        Wed,  9 Nov 2022 10:22:22 -0800 (PST)
Message-ID: <5a23b856-88a3-a57a-2191-b673f4160796@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668018140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PfObcJDPf5gEmYlvJlE9NKgi68kSqcyEYtXQfgjzd4Q=;
        b=S0xfJz/6hcuQo4rMiSyxO+9ePlVkWfpoF9B5A1BlpdgUSqhFTddqAOMUSVSmU0zEtDfIve
        O4XgyubS9/xderFMaGJ8Dh5eKXEszZ78e588H063Y6MxiWLcitYk55s+LXMUTAK0ME5ITA
        pajRF/OaIawTuSfYO/p5Rhn6C1w2gSw=
Date:   Wed, 9 Nov 2022 10:22:11 -0800
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <87leokz8lq.fsf@toke.dk>
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

On 11/9/22 3:10 AM, Toke Høiland-Jørgensen wrote:
> Snipping a bit of context to reply to this bit:
> 
>>>>> Can the xdp prog still change the metadata through xdp->data_meta? tbh, I am not
>>>>> sure it is solid enough by asking the xdp prog not to use the same random number
>>>>> in its own metadata + not to change the metadata through xdp->data_meta after
>>>>> calling bpf_xdp_metadata_export_to_skb().
>>>>
>>>> What do you think the usecase here might be? Or are you suggesting we
>>>> reject further access to data_meta after
>>>> bpf_xdp_metadata_export_to_skb somehow?
>>>>
>>>> If we want to let the programs override some of this
>>>> bpf_xdp_metadata_export_to_skb() metadata, it feels like we can add
>>>> more kfuncs instead of exposing the layout?
>>>>
>>>> bpf_xdp_metadata_export_to_skb(ctx);
>>>> bpf_xdp_metadata_export_skb_hash(ctx, 1234);
> 
> There are several use cases for needing to access the metadata after
> calling bpf_xdp_metdata_export_to_skb():
> 
> - Accessing the metadata after redirect (in a cpumap or devmap program,
>    or on a veth device)
> - Transferring the packet+metadata to AF_XDP
fwiw, the xdp prog could also be more selective and only stores one of the hints 
instead of the whole 'struct xdp_to_skb_metadata'.

> - Returning XDP_PASS, but accessing some of the metadata first (whether
>    to read or change it)
> 
> The last one could be solved by calling additional kfuncs, but that
> would be less efficient than just directly editing the struct which
> will be cache-hot after the helper returns.

Yeah, it is more efficient to directly write if possible.  I think this set 
allows the direct reading and writing already through data_meta (as a _u8 *).

> 
> And yeah, this will allow the XDP program to inject arbitrary metadata
> into the netstack; but it can already inject arbitrary *packet* data
> into the stack, so not sure if this is much of an additional risk? If it
> does lead to trivial crashes, we should probably harden the stack
> against that?
> 
> As for the random number, Jesper and I discussed replacing this with the
> same BTF-ID scheme that he was using in his patch series. I.e., instead
> of just putting in a random number, we insert the BTF ID of the metadata
> struct at the end of it. This will allow us to support multiple
> different formats in the future (not just changing the layout, but
> having multiple simultaneous formats in the same kernel image), in case
> we run out of space.

This seems a bit hypothetical.  How much headroom does it usually have for the 
xdp prog?  Potentially the hints can use all the remaining space left after the 
header encap and the current bpf_xdp_adjust_meta() usage?

> 
> We should probably also have a flag set on the xdp_frame so the stack
> knows that the metadata area contains relevant-to-skb data, to guard
> against an XDP program accidentally hitting the "magic number" (BTF_ID)
> in unrelated stuff it puts into the metadata area.

Yeah, I think having a flag is useful.  The flag will be set at xdp_buff and 
then transfer to the xdp_frame?

> 
>> After re-reading patch 6, have another question. The 'void
>> bpf_xdp_metadata_export_to_skb();' function signature. Should it at
>> least return ok/err? or even return a 'struct xdp_to_skb_metadata *'
>> pointer and the xdp prog can directly read (or even write) it?
> 
> Hmm, I'm not sure returning a failure makes sense? Failure to read one
> or more fields just means that those fields will not be populated? We
> should probably have a flags field inside the metadata struct itself to
> indicate which fields are set or not, but I'm not sure returning an
> error value adds anything? Returning a pointer to the metadata field
> might be convenient for users (it would just be an alias to the
> data_meta pointer, but the verifier could know its size, so the program
> doesn't have to bounds check it).

If some hints are not available, those hints should be initialized to 
0/CHECKSUM_NONE/...etc.  The xdp prog needs a direct way to tell hard failure 
when it cannot write the meta area because of not enough space.  Comparing 
xdp->data_meta with xdp->data as a side effect is not intuitive.

It is more than saving the bound check.  With type info of 'struct 
xdp_to_skb_metadata *', the verifier can do more checks like reading in the 
middle of an integer member.  The verifier could also limit write access only to 
a few struct's members if it is needed.

The returning 'struct xdp_to_skb_metadata *' should not be an alias to the 
xdp->data_meta.  They should actually point to different locations in the 
headroom.  bpf_xdp_metadata_export_to_skb() sets a flag in xdp_buff. 
xdp->data_meta won't be changed and keeps pointing to the last 
bpf_xdp_adjust_meta() location.  The kernel will know if there is 
xdp_to_skb_metadata before the xdp->data_meta when that bit is set in the 
xdp_{buff,frame}.  Would it work?

> 
>> A related question, why 'struct xdp_to_skb_metadata' needs
>> __randomize_layout?
> 
> The __randomize_layout thing is there to force BPF programs to use CO-RE
> to access the field. This is to avoid the struct layout accidentally
> ossifying because people in practice rely on a particular layout, even
> though we tell them to use CO-RE. There are lots of examples of this
> happening in other domains (IP header options, TCP options, etc), and
> __randomize_layout seemed like a neat trick to enforce CO-RE usage :)

I am not sure if it is necessary or helpful to only enforce __randomize_layout 
in 'struct xdp_to_skb_metadata'.  There are other CO-RE use cases (tracing and 
non tracing) that already have direct access (reading and/or writing) to other 
kernel structures.

It is more important for the verifier to see the xdp prog accessing it as a 
'struct xdp_to_skb_metadata *' instead of xdp->data_meta which is a __u8 * so 
that the verifier can enforce the rules of access.

> 
>>>>> Does xdp_to_skb_metadata have a use case for XDP_PASS (like patch 7) or the
>>>>> xdp_to_skb_metadata can be limited to XDP_REDIRECT only?
>>>>
>>>> XDP_PASS cases where we convert xdp_buff into skb in the drivers right
>>>> now usually have C code to manually pull out the metadata (out of hw
>>>> desc) and put it into skb.
>>>>
>>>> So, currently, if we're calling bpf_xdp_metadata_export_to_skb() for
>>>> XDP_PASS, we're doing a double amount of work:
>>>> skb_metadata_import_from_xdp first, then custom driver code second.
>>>>
>>>> In theory, maybe we should completely skip drivers custom parsing when
>>>> there is a prog with BPF_F_XDP_HAS_METADATA?
>>>> Then both xdp->skb paths (XDP_PASS+XDP_REDIRECT) will be bpf-driven
>>>> and won't require any mental work (plus, the drivers won't have to
>>>> care either in the future).
>>>>   > WDYT?
>>>
>>>
>>> Yeah, not sure if it can solely depend on BPF_F_XDP_HAS_METADATA but it makes
>>> sense to only use the hints (if ever written) from xdp prog especially if it
>>> will eventually support xdp prog changing some of the hints in the future.  For
>>> now, I think either way is fine since they are the same and the xdp prog is sort
>>> of doing extra unnecessary work anyway by calling
>>> bpf_xdp_metadata_export_to_skb() with XDP_PASS and knowing nothing can be
>>> changed now.
> 
> I agree it would be best if the drivers also use the XDP metadata (if
> present) on XDP_PASS. Longer term my hope is we can make the XDP
> metadata support the only thing drivers need to implement (i.e., have
> the stack call into that code even when no XDP program is loaded), but
> for now just for consistency (and allowing the XDP program to update the
> metadata), we should probably at least consume it on XDP_PASS.
> 
> -Toke
> 

