Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADE5262441F
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 15:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbiKJOU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 09:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbiKJOUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 09:20:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFE31902A
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 06:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668089965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LjLToOja6gaSKNM7gF4gncxkzxf+4owXLPAgRjk5yo0=;
        b=FmS5a+5iTNAj8at8kY5YDgIwge4AevqOKT2sYIp7VHDmW0DDOezal/B4+lgmSy8kF+JgEj
        2fTg0tB7CU2331N183kmw3zOIHxq+XXKvcE787NrE6Rrn5bLqmQsO24XkuryY5okxTkweZ
        F3vdfipL9Ds0IUJ0j1t88XtHAdknrVI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-299-fGJ46-WAOC-bawpSk1hZ0Q-1; Thu, 10 Nov 2022 09:19:21 -0500
X-MC-Unique: fGJ46-WAOC-bawpSk1hZ0Q-1
Received: by mail-ej1-f71.google.com with SMTP id sc40-20020a1709078a2800b007ae024e5e82so1294537ejc.13
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 06:19:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LjLToOja6gaSKNM7gF4gncxkzxf+4owXLPAgRjk5yo0=;
        b=S1/rgViWQF07Z1W7KEtdfx4ra4w0774WgQw96cpUhszjvoAHVMRJsBaf8uJ/PQYJ9/
         hYMGIIeiT6/oPSEHHsn0lPlExtI3H4XzCqlUH3Y4bDbcPjFii6XkLsps4k/ouX80oyA/
         K+x8z9e8jitPsee+tkXImyLHQgYaeQNkhiG0Cqmv8lJMCqUn62Jg+QMaj49g2YzRgmaF
         Wz8ZXe9dOatp1jU0NTHz/kVjAudKzyyfSzuAjjE1DNoD2RoT5aPolx8xXcwUcJvLaFkp
         SjSMPqBRFEVYktPre9CSKvVmzvfPojFjKMJ47Dpxu6VwxQSUrVLTT/4Rfon02CsyNMl+
         aAXA==
X-Gm-Message-State: ACrzQf1J9S3fGpgherK5kWKS6Qrcm1Rudv1sQdRAecHW/X+TlZnHk93y
        fG++gZahvs4zlgZIz7HRmgI7A0/yYNaaiS9pZB7AxCSqyj3ia0tMbiT92O5IhEJeXYd+tUeIAfa
        UxVeqZluwMLFSBrPf
X-Received: by 2002:a05:6402:518c:b0:461:46c7:53aa with SMTP id q12-20020a056402518c00b0046146c753aamr2366307edd.165.1668089960191;
        Thu, 10 Nov 2022 06:19:20 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4PpjyK2m7gsOZsfHvLA/7qDqLNOGfW+gxcORAjYCRyjdpw69x0x0E4B8Z+iPQjnqINxfQEFQ==
X-Received: by 2002:a05:6402:518c:b0:461:46c7:53aa with SMTP id q12-20020a056402518c00b0046146c753aamr2366283edd.165.1668089959690;
        Thu, 10 Nov 2022 06:19:19 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id ue5-20020a170907c68500b007a559542fcfsm7404612ejc.70.2022.11.10.06.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 06:19:19 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9E5AB7826CE; Thu, 10 Nov 2022 15:19:18 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Martin KaFai Lau <martin.lau@linux.dev>
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
Subject: Re: [xdp-hints] Re: [RFC bpf-next v2 06/14] xdp: Carry over xdp
 metadata into skb context
In-Reply-To: <5a23b856-88a3-a57a-2191-b673f4160796@linux.dev>
References: <20221104032532.1615099-1-sdf@google.com>
 <20221104032532.1615099-7-sdf@google.com>
 <187e89c3-d7de-7bec-c72e-d9d6eb5bcca0@linux.dev>
 <CAKH8qBv_ZO=rsJcq2Lvq36d9sTAXs6kfUmW1Hk17bB=BGiGzhw@mail.gmail.com>
 <9a8fefe4-2fcb-95b7-cda0-06509feee78e@linux.dev>
 <6f57370f-7ec3-07dd-54df-04423cab6d1f@linux.dev> <87leokz8lq.fsf@toke.dk>
 <5a23b856-88a3-a57a-2191-b673f4160796@linux.dev>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 10 Nov 2022 15:19:18 +0100
Message-ID: <871qqazyc9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau <martin.lau@linux.dev> writes:

> On 11/9/22 3:10 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Snipping a bit of context to reply to this bit:
>>=20
>>>>>> Can the xdp prog still change the metadata through xdp->data_meta? t=
bh, I am not
>>>>>> sure it is solid enough by asking the xdp prog not to use the same r=
andom number
>>>>>> in its own metadata + not to change the metadata through xdp->data_m=
eta after
>>>>>> calling bpf_xdp_metadata_export_to_skb().
>>>>>
>>>>> What do you think the usecase here might be? Or are you suggesting we
>>>>> reject further access to data_meta after
>>>>> bpf_xdp_metadata_export_to_skb somehow?
>>>>>
>>>>> If we want to let the programs override some of this
>>>>> bpf_xdp_metadata_export_to_skb() metadata, it feels like we can add
>>>>> more kfuncs instead of exposing the layout?
>>>>>
>>>>> bpf_xdp_metadata_export_to_skb(ctx);
>>>>> bpf_xdp_metadata_export_skb_hash(ctx, 1234);
>>=20
>> There are several use cases for needing to access the metadata after
>> calling bpf_xdp_metdata_export_to_skb():
>>=20
>> - Accessing the metadata after redirect (in a cpumap or devmap program,
>>    or on a veth device)
>> - Transferring the packet+metadata to AF_XDP
> fwiw, the xdp prog could also be more selective and only stores one of th=
e hints=20
> instead of the whole 'struct xdp_to_skb_metadata'.

Yup, absolutely! In that sense, reusing the SKB format is mostly a
convenience feature. However, lots of people consume AF_XDP through the
default program installed by libxdp in the XSK setup code, and including
custom metadata there is awkward. So having the metadata consumed by the
stack as the "default subset" would enable easy consumption by
non-advanced users, while advanced users can still do custom stuff by
writing their own XDP program that calls the kfuncs.

>> - Returning XDP_PASS, but accessing some of the metadata first (whether
>>    to read or change it)
>>=20
>> The last one could be solved by calling additional kfuncs, but that
>> would be less efficient than just directly editing the struct which
>> will be cache-hot after the helper returns.
>
> Yeah, it is more efficient to directly write if possible.  I think this s=
et=20
> allows the direct reading and writing already through data_meta (as a _u8=
 *).

Yup, totally fine with just keeping that capability :)

>> And yeah, this will allow the XDP program to inject arbitrary metadata
>> into the netstack; but it can already inject arbitrary *packet* data
>> into the stack, so not sure if this is much of an additional risk? If it
>> does lead to trivial crashes, we should probably harden the stack
>> against that?
>>=20
>> As for the random number, Jesper and I discussed replacing this with the
>> same BTF-ID scheme that he was using in his patch series. I.e., instead
>> of just putting in a random number, we insert the BTF ID of the metadata
>> struct at the end of it. This will allow us to support multiple
>> different formats in the future (not just changing the layout, but
>> having multiple simultaneous formats in the same kernel image), in case
>> we run out of space.
>
> This seems a bit hypothetical.  How much headroom does it usually have fo=
r the=20
> xdp prog?  Potentially the hints can use all the remaining space left aft=
er the=20
> header encap and the current bpf_xdp_adjust_meta() usage?

For the metadata consumed by the stack right now it's a bit
hypothetical, yeah. However, there's a bunch of metadata commonly
supported by hardware that the stack currently doesn't consume and that
hopefully this feature will end up making more accessible. My hope is
that the stack can also learn how to use this in the future, in which
case we may run out of space. So I think of that bit mostly as
future-proofing...

>> We should probably also have a flag set on the xdp_frame so the stack
>> knows that the metadata area contains relevant-to-skb data, to guard
>> against an XDP program accidentally hitting the "magic number" (BTF_ID)
>> in unrelated stuff it puts into the metadata area.
>
> Yeah, I think having a flag is useful.  The flag will be set at xdp_buff =
and=20
> then transfer to the xdp_frame?

Yeah, exactly!

>>> After re-reading patch 6, have another question. The 'void
>>> bpf_xdp_metadata_export_to_skb();' function signature. Should it at
>>> least return ok/err? or even return a 'struct xdp_to_skb_metadata *'
>>> pointer and the xdp prog can directly read (or even write) it?
>>=20
>> Hmm, I'm not sure returning a failure makes sense? Failure to read one
>> or more fields just means that those fields will not be populated? We
>> should probably have a flags field inside the metadata struct itself to
>> indicate which fields are set or not, but I'm not sure returning an
>> error value adds anything? Returning a pointer to the metadata field
>> might be convenient for users (it would just be an alias to the
>> data_meta pointer, but the verifier could know its size, so the program
>> doesn't have to bounds check it).
>
> If some hints are not available, those hints should be initialized to
> 0/CHECKSUM_NONE/...etc.

The problem with that is that then we have to spend cycles writing
eight bytes of zeroes into the checksum field :)

> The xdp prog needs a direct way to tell hard failure when it cannot
> write the meta area because of not enough space. Comparing
> xdp->data_meta with xdp->data as a side effect is not intuitive.

Yeah, hence a flags field so we can just see if setting each field
succeeded?

> It is more than saving the bound check.  With type info of 'struct=20
> xdp_to_skb_metadata *', the verifier can do more checks like reading in t=
he=20
> middle of an integer member.  The verifier could also limit write access =
only to=20
> a few struct's members if it is needed.
>
> The returning 'struct xdp_to_skb_metadata *' should not be an alias to th=
e=20
> xdp->data_meta.  They should actually point to different locations in the=
=20
> headroom.  bpf_xdp_metadata_export_to_skb() sets a flag in xdp_buff.=20
> xdp->data_meta won't be changed and keeps pointing to the last=20
> bpf_xdp_adjust_meta() location.  The kernel will know if there is=20
> xdp_to_skb_metadata before the xdp->data_meta when that bit is set in the=
=20
> xdp_{buff,frame}.  Would it work?

Hmm, logically splitting the program metadata and the xdp_hints metadata
(but having them share the same area) *could* work, I guess, I'm just
not sure it's worth the extra complexity?

>>> A related question, why 'struct xdp_to_skb_metadata' needs
>>> __randomize_layout?
>>=20
>> The __randomize_layout thing is there to force BPF programs to use CO-RE
>> to access the field. This is to avoid the struct layout accidentally
>> ossifying because people in practice rely on a particular layout, even
>> though we tell them to use CO-RE. There are lots of examples of this
>> happening in other domains (IP header options, TCP options, etc), and
>> __randomize_layout seemed like a neat trick to enforce CO-RE usage :)
>
> I am not sure if it is necessary or helpful to only enforce __randomize_l=
ayout=20
> in 'struct xdp_to_skb_metadata'.  There are other CO-RE use cases (tracin=
g and=20
> non tracing) that already have direct access (reading and/or writing) to =
other=20
> kernel structures.
>
> It is more important for the verifier to see the xdp prog accessing it as=
 a=20
> 'struct xdp_to_skb_metadata *' instead of xdp->data_meta which is a __u8 =
* so=20
> that the verifier can enforce the rules of access.

That only works inside the kernel, though. Since the metadata field can
be copied wholesale to AF_XDP, having it randomized forces userspace
consumers to also write code to deal with the layout being dynamic...

-Toke

