Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A763B5F6D3A
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 19:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbiJFRrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 13:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiJFRrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 13:47:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DA3B5174
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 10:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665078428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B+y8wduK3QfMgdOHpN9KWre0ENB0HamAmdiK58oyOXc=;
        b=RLAXeLd2TueE7VGzNaYEZak6yApL8TVo5pOoCiIryXB8S2pNCqouYNHe4fFm7UK8+Bk8zn
        J1xdWgDA36Wpg0i/sjNWESmFQxTLwk2BuMqzP4H0nR6hp/v0ZQuE0qm96HquyA/OQ6H7og
        Lwe8P43S8yyTqsnnEM5S2jiPrGCstPk=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-308-XCWdwAC5PVGLhKn9-A3Rjw-1; Thu, 06 Oct 2022 13:47:07 -0400
X-MC-Unique: XCWdwAC5PVGLhKn9-A3Rjw-1
Received: by mail-ej1-f72.google.com with SMTP id xc12-20020a170907074c00b007416699ea14so1535556ejb.19
        for <netdev@vger.kernel.org>; Thu, 06 Oct 2022 10:47:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:cc:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B+y8wduK3QfMgdOHpN9KWre0ENB0HamAmdiK58oyOXc=;
        b=gKF3KV2groTJJhRaGqaYfxTWVObpVUvfHYwhGeuVItRot1m5QSN9TIXzLfyfseY2lv
         e5je/J2SVq0hGUwwN9HVqU6Ix39VtLDriSufLb8qvSpWa81JXXWEDk1ujZVkap1A+wcX
         26JXwH+9qufTsynMHzXUtgssSDfKD+v9u46B36SZ9YuJoJp/xZvqujVWpQQJppyqUiyi
         wrExPEqe1SywaDhb91fhp/ftvjM5lb6CgaHIKg7l+Ey/VWSeeoRnhOChw29RAOp8lGAO
         jVYD+nNzHR9PXIHN1vALk986ND9KMd4O3ZcIJninIzCVRor3boJbcY3DuewpPQ3YDuY5
         D7qA==
X-Gm-Message-State: ACrzQf1ssNG7UVi9fNyTZdFbX/0x4pkExxqzJkmgeX/tWkX2XkDYm9bu
        iPTcQS8utzU4Bl0RK7tqbYxqH6/y8WfTDtJiay11m3hUykJlDGKKw7IJVqZ/Ystbt1EQPtPRkhn
        fFTVbqapLAXeOWaWP
X-Received: by 2002:a17:906:794b:b0:787:bb35:84cd with SMTP id l11-20020a170906794b00b00787bb3584cdmr846943ejo.428.1665078425975;
        Thu, 06 Oct 2022 10:47:05 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6lg0yzavx+mGgIRcjGqtXmVn5OTg1yYRu7aB9cVtFvCh+rxiWW6NISbmvxPn0HjI4X1N5jXw==
X-Received: by 2002:a17:906:794b:b0:787:bb35:84cd with SMTP id l11-20020a170906794b00b00787bb3584cdmr846906ejo.428.1665078425568;
        Thu, 06 Oct 2022 10:47:05 -0700 (PDT)
Received: from [192.168.41.81] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id y18-20020a056402359200b00458e40e31c8sm6373631edc.15.2022.10.06.10.47.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Oct 2022 10:47:04 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <ebbb99a1-c3c8-6d97-4bb3-03f28a0a74b1@redhat.com>
Date:   Thu, 6 Oct 2022 19:47:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Cc:     brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Subject: Re: [PATCH RFCv2 bpf-next 00/18] XDP-hints: XDP gaining access to HW
 offload hints via BTF
To:     sdf@google.com, Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
 <Yzt2YhbCBe8fYHWQ@google.com>
 <35fcfb25-583a-e923-6eee-e8bbcc19db17@redhat.com>
 <CAKH8qBuYVk7QwVOSYrhMNnaKFKGd7M9bopDyNp6-SnN6hSeTDQ@mail.gmail.com>
 <982b9125-f849-5e1c-0082-7239b8c8eebf@redhat.com>
 <Yz3QNM7061WmXDHS@google.com>
Content-Language: en-US
In-Reply-To: <Yz3QNM7061WmXDHS@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/10/2022 20.43, sdf@google.com wrote:
> On 10/05, Jesper Dangaard Brouer wrote:
> 
>> On 04/10/2022 20.26, Stanislav Fomichev wrote:
>> > On Tue, Oct 4, 2022 at 2:29 AM Jesper Dangaard Brouer
>> > <jbrouer@redhat.com> wrote:
>> > >
>> > >
>> > > On 04/10/2022 01.55, sdf@google.com wrote:
>> > > > On 09/07, Jesper Dangaard Brouer wrote:
>> > > > > This patchset expose the traditional hardware offload hints to XDP and
>> > > > > rely on BTF to expose the layout to users.
>> > > >
>> > > > > Main idea is that the kernel and NIC drivers simply defines the struct
>> > > > > layouts they choose to use for XDP-hints. These XDP-hints structs gets
>> > > > > naturally and automatically described via BTF and implicitly exported to
>> > > > > users. NIC drivers populate and records their own BTF ID as the last
>> > > > > member in XDP metadata area (making it easily accessible by AF_XDP
>> > > > > userspace at a known negative offset from packet data start).
>> > > >
>> > > > > Naming conventions for the structs (xdp_hints_*) is used such that
>> > > > > userspace can find and decode the BTF layout and match against the
>> > > > > provided BTF IDs. Thus, no new UAPI interfaces are needed for  exporting
>> > > > > what XDP-hints a driver supports.
>> > > >
>> > > > > The patch "i40e: Add xdp_hints_union" introduce the idea of creating a
>> > > > > union named "xdp_hints_union" in every driver, which contains all
>> > > > > xdp_hints_* struct this driver can support. This makes it easier/quicker
>> > > > > to find and parse the relevant BTF types.  (Seeking input before fixing
>> > > > > up all drivers in patchset).
>> > > >
[...]
>> >
>> > > > b. Each device defines much denser <device>_xdp_rx_hints struct with the
>> > > >      metadata that it supports
>> > >
>> > > Thus, the NIC device is limited to what is defined in UAPI struct
>> > > xdp_rx_hints.  Again this limits innovation.
>> >
>> > I guess what I'm missing from your series is the bpf/userspace side.
>> > Do you have an example on the bpf side that will work for, say,
>> > xdp_hints_ixgbe_timestamp?

We have been consuming this from AF_XDP and decoding BTF in userspace
and checking BTF IDs in our userspace apps.  I will try to codeup
consuming this from XDP BPF-progs to get a better feel for that.

>> >
>> > Suppose, you pass this custom hints btf_id via xdp_md as proposed,
> 
>> I just want to reiterate why we place btf_full_id at the "end inline".
>> This makes it easily available for AF_XDP to consume.  Plus, we already
>> have to write info into this metadata cache-line anyway, thus it's
>> almost free.  Moving bpf_full_id into xdp_md, will require expanding
>> both xdp_buff and xdp_frame (+ extra store for converting
>> buff-to-frame). If AF_XDP need this btf_full_id the BPF-prog _could_
>> move/copy it from xdp_md to metadata, but that will just waste cycles,
>> why not just store it once in a known location.
> 
>> One option, for convenience, would be to map xdp_md->bpf_full_id to load
>> the btf_full_id value from the metadata.  But that would essentially be
>> syntax-sugar and adds UAPI.
> 
>> > what's the action on the bpf side to consume this?
>> >
>> > If (ctx_hints_btf_id == xdp_hints_ixgbe_timestamp_btf_id /* supposedly
>> > populated at runtime by libbpf? */) {
> 
>> See e.g. bpf_core_type_id_kernel(struct xdp_hints_ixgbe_timestamp)
>> AFAIK libbpf will make this a constant at load/setup time, and give us
>> dead-code elimination.
> 
> Even with bpf_core_type_id_kernel() you still would have the following:
> 
>      if (ctx_hints_btf_id == bpf_core_type_id_kernel(struct xdp_hints_ixgbe)) {
>      } else if (the same for every driver that has custom hints) {
>      }
> 
> Toke has a good suggestion on hiding this behind a helper; either
> pre-generated on the libbpf side or a kfunc. We should try to hide
> this per-device logic if possible; otherwise we'll get to per-device
> XDP programs that only work on some special deployments. 
> OTOH, we'll probably get there with the hints anyway?

Well yes, hints is trying to let NIC driver innovate and export HW hints
that are specific for a given driver.  Thus, we should allow code to get
device specific hints.

I do like this idea of hiding this behind something. Like libbpf could
detect this and apply CO-RE tricks, e.g. based on the struct name
starting with xdp_rx_hints___xxx and member rx_timestamp, it could scan
entire system (all loaded modules) for xdp_rx_hints_* structs and find
those that contain member rx_timestamp, and then expand that to the
if-else-if statements matching against IDs and access rx_timestamp at
correct offset.
   Unfortunately this auto expansion will add code that isn't needed for
a XDP BPF-prog loaded on a specific physical device (as some IDs will
not be able to appear). For the veth case it is useful. Going back to
ifindex, if a XDP BPF-prog do have ifindex, then we could limit the
expansion to BTF layouts from that driver.  It just feels like a lot of
syntax-sugar and magic to hide the driver name e.g.
"xdp_hints_ixgbe_timestamp" in the C-code.


>> >    // do something with rx_timestamp
>> >    // also, handle xdp_hints_ixgbe and then xdp_hints_common ?
>> > } else if (ctx_hints_btf_id == xdp_hints_ixgbe) {
>> >    // do something else
>> >    // plus explicitly handle xdp_hints_common here?
>> > } else {
>> >    // handle xdp_hints_common
>> > }
> 
>> I added a BPF-helper that can tell us if layout if compatible with
>> xdp_hints_common, which is basically the only UAPI the patchset 
>> introduces.
>> The handle xdp_hints_common code should be common.
>> 
>> I'm not super happy with the BPF-helper approach, so suggestions are
>> welcome.  E.g. xdp_md/ctx->is_hint_common could be one approach and
>> ctx->has_hint (ctx is often called xdp so it reads xdp->has_hint).
>> 
>> One feature I need from the BPF-helper is to "disable" the xdp_hints and
>> allow the BPF-prog to use the entire metadata area for something else
>> (avoiding it to be misintrepreted by next prog or after redirect).
>> 
> As mentioned in the previous emails, let's try to have a bpf side
> example/selftest for the next round? 

Yes, I do need to add BPF-prog examples and selftests.

I am considering sending next round (still as RFC) without this, to show
what Maryam and Magnus settled on for AF_XDP desc option flags.


> I also feel like xdp_hints_common is
> a bit distracting. It makes the common case easy and it hides the
> discussion/complexity about per-device hints. Maybe we can drop this
> common case at all? Why can't every driver has a custom hints struct?
> If we agree that naming/size will be the same across them (and review
> catches/guaranteed that), why do we even care about having common
> xdp_hints_common struct?

The xdp_hints_common struct is a stepping stone to making this easily
consumable from C-code that need to generate SKBs and info for
virtio_net 'hdr' desc.

David Ahern have been begging me for years to just add this statically
to xdp_frame.  I have been reluctant, because I think we can come up
with a more flexible (less UAPI fixed) way, that both allows kerne-code
and BPF-prog to access these fields.  I think of this approach as a
compromise between these two users.

  Meaning struct xdp_hints_common can be changed anytime in the kernel
C-code and BPF-prog's must access area via BTF/CO-RE.


>> > What I'd like to avoid is an xdp program targeting specific drivers.
>> > Where possible, we should aim towards something like "if this device
>> > has rx_timestamp offload -> use it without depending too much on
>> > specific btf_ids.
>> >
> 
>> I do understand your wish, and adding rx_timestamps to xdp_hints_common
>> would be too easy (and IMHO wasting u64/8-bytes for all packets not
>> needing this timestamp).  Hopefully we can come up with a good solution
>> together.
> 
>> One idea would be to extend libbpf to lookup or translate struct name
> 
>>   struct xdp_hints_DRIVER_timestamp {
>>     __u64 rx_timestamp;
>>   } __attribute__((preserve_access_index));
> 
>> into e.g. xdp_hints_i40e_timestamp, if an ifindex was provided when 
>> loading
>> the XDP prog.  And the bpf_core_type_id_kernel() result of the struct
>> returning id from xdp_hints_i40e_timestamp.
> 
>> But this ideas doesn't really work for the veth redirect use-case :-(
>> As veth need to handle xdp_hints from other drivers.
> 
> Agreed. If we want redirect to work, then the parsing should be either
> mostly pre-generated by libbpf to include all possible btf ids that
> matter; or done similarly by a kfunc. The idea that we can pre-generate
> per-device bpf program seems to be out of the window now?
> 

Hmm, the per-device thing could be an optimization that is performed if
an ifindex have been provided.

BUT for redirect to work, we do need to have the full BTF ID, to
identify structs coming from other device drivers and their BTF layout.
We have mentioned redirect into veth several times, but the same goes 
for redirect into AF_XDP, that needs to identify the BTF layout.

[...]
>> > See above. I think even with your series, that btf_id info should also
>> > come via netlink so the programs can query it before loading and do
>> > the required adjustments. Otherwise, I'm not sure I understand what I
>> > need to do with a btf_id that comes via xdp_md/xdp_frame. It seems too
>> > late? I need to know them in advance to at least populate those ids
>> > into the bpf program itself?
> 
>> Yes, we need to know these IDs in advance and can.  I don't think we need
>> the netlink interface, as we can already read out the BTF layout and IDs
>> today.  I coded it up in userspace, where the intented consumer is AF_XDP
>> (as libbpf already does this itself).
> 
>> See this code:
>>   - 
>> https://github.com/xdp-project/bpf-examples/blob/master/BTF-playground/btf_module_ids.c
>>   - 
>> https://github.com/xdp-project/bpf-examples/blob/master/BTF-playground/btf_module_read.c
> 
> SG, if we can have some convention on the names where we can reliably
> parse out all possible structs with the hints, let's rely solely on
> vmlinux+vmlinux module btf.
> 

Yes, I am proposing convention on the struct BTF names to find 
'xdp_hints_*' that the driver can produce.

To make it quicker to find xdp_hints struct in a driver, I am also 
proposing a 'union' that contains all the xdp_hints struct's.

  - See "[PATCH 14/18] i40e: Add xdp_hints_union".

The BTF effect of this is that each driver will have a xdp_hints_union 
with same "name".  That points to all the other BTF IDs.

I am wondering if we can leverage this for CO-RE relocations too.
Then you can define your BPF-prog shadow union with the member 
rx_timestamp (and __attribute__((preserve_access_index))) and let 
CO-RE/libbpf do the offset adjustments. (But again we are back to which 
driver BPF-prog are attached on and veth having to handle all possible 
drivers)


[...]
>> > > >
>> > > > All we need here is for libbpf to, again, do xdp_rx_hints ->
>> > > > <device>_xdp_rx_hints translation before it evaluates
>> > > > bpf_core_field_exists()?
>> > > >
>> > > > Thoughts? Any downsides? Am I missing something?
>> > > >
>> > >
>> > > Well, the downside is primarily that this design limits innovation.
>> > >
>> > > Each time a NIC driver want to introduce a new hardware hint, they have
>> > > to update the central UAPI xdp_rx_hints struct first.
>> > >
>> > > The design in the patchset is to open for innovation.  Driver can extend
>> > > their own xdp_hints_<driver>_xxx struct(s).  They still have to land
>> > > their patches upstream, but avoid mangling a central UAPI struct. As
>> > > upstream we review driver changes and should focus on sane struct member
>> > > naming(+size) especially if this "sounds" like a hint/feature that more
>> > > driver are likely to support.  With help from BTF relocations, a new
>> > > driver can support same hint/feature if naming(+size) match (without
>> > > necessary the same offset in the struct).
>> >
>> > The opposite side of this approach is that we'll have 'ixgbe_hints'
>> > with 'rx_timestamp' and 'mvneta_hints' with something like
>> > 'rx_tstamp'.
> 
>> Well, as I wrote reviewers should ask drivers to use the same member 
>> name.
> 
> SG!
> 
>> > > > Also, about the TX side: I feel like the same can be applied there,
>> > > > the program works with xdp_tx_hints and libbpf will rewrite to
>> > > > <device>_xdp_tx_hints. xdp_tx_hints might have fields like "has_tx_vlan:1";
>> > > > those, presumably, can be relocatable by libbpf as well?
>> > > >
>> > >
>> > > Good to think ahead for TX-side, even-though I think we should focus on
>> > > landing RX-side first.
>> > >
>> > > I notice your naming xdp_rx_hints vs. xdp_tx_hints.  I have named the
>> > > common struct xdp_hints_common, without a RX/TX direction indication.
>> > > Maybe this is wrong of me, but my thinking was that most of the  common
>> > > hints can be directly used as TX-side hints.  I'm hoping TX-side
>> > > xdp-hints will need to do little-to-non adjustment, before using the
>> > > hints as TX "instruction".  I'm hoping that XDP-redirect will just work
>> > > and xmit driver can use XDP-hints area.
>> > >
>> > > Please correct me if I'm wrong.
>> > > The checksum fields hopefully translates to similar TX offload "actions".
>> > > The VLAN offload hint should translate directly to TX-side.
>> > >
>> > > I can easily be convinced we should name it xdp_hints_rx_common from the
>> > > start, but then I will propose that xdp_hints_tx_common have the
>> > > checksum and VLAN fields+flags at same locations, such that we don't
>> > > take any performance hint for moving them to "TX-side" hints, making
>> > > XDP-redirect just work.
>> >
>> > Might be good to think about this beforehand. I agree that most of the
>> > layout should hopefully match. However once case that I'm interested
>> > in is rx_timestamp vs tx_timestamp. For rx, I'm getting the timestamp
>> > in the metadata; for tx, I'm merely setting a flag somewhere to
>> > request it for async delivery later (I hope we plan to support that
>> > for af_xdp?). So the layout might be completely different :-(
>> >
> 
>> Yes, it is definitely in my plans to support handling at TX-completion
>> time, so you can extract the TX-wire-timestamp.  This is easy for AF_XDP
>> as it has the CQ (Completion Queue) step.
> 
>> I'm getting ahead of myself, but for XDP I imagine that driver will
>> populate this xdp_tx_hint in DMA TX-completion function, and we can add
>> a kfunc "not-a-real-hook" to xdp_return_frame that can run another XDP
>> BPF-prog that can inspect the xdp_tx_hint in metadata.
> 
> Can we also place that xdp_tx_hint somewhere in the completion ring
> for AF_XDP to consume?

Yes, that is basically what I said above. This will be automatic/easy
for AF_XDP as it has the CQ (Completion Queue) ring.  The packets in the
completion ring will still contain the metadata area, which could have
been populated with the TX-wire-timestamp.


>> At this proposed kfunc xdp_return_frame call point, we likely cannot know
>> what driver that produced the xdp_hints metadata either, and thus not 
>> lock our design or BTF-reloacations to assume which driver is it loaded on.
> 
>> [... cut ... getting too long]

--Jesper

