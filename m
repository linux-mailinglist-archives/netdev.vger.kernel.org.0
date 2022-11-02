Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47BD3616477
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 15:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiKBOH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 10:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbiKBOHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 10:07:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C9B659D
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 07:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667398007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2jf4Id8JS47B7k+3UyTqzVbwapS6kaSdZwlME3DJWj8=;
        b=VRhueAu2MNsa/3CG7yDgVY2QBFb9eBe062EkqQNnl/e6RFkuWvJYpYgeJaTaySz5Yonvvu
        77ekvRTlD0v93yS9EH75tD0ixUAnQIkwo/2RGEkS4PRRXxxGH9FuVQc2F4gj3lHrRZIvdR
        uT0RlXofKCfjB8e15V23Q0/8FHgCskU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-214-lzRMmpPSNLiCNWqgXYGVIw-1; Wed, 02 Nov 2022 10:06:45 -0400
X-MC-Unique: lzRMmpPSNLiCNWqgXYGVIw-1
Received: by mail-ej1-f71.google.com with SMTP id qk31-20020a1709077f9f00b00791a3e02c80so10148634ejc.21
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 07:06:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2jf4Id8JS47B7k+3UyTqzVbwapS6kaSdZwlME3DJWj8=;
        b=f7d+8jFxZLVQPK8r5Kes2l30qgRyV/yd3KFRjoVMAY2aLLaA27NYR3WUIR96bH93TM
         O53GQM8hnjwkOeQkAcY+qoxXiYjuNgtPqZCGumAkUykKMR8gIXHUsTTnxn0DKF3yg5iK
         T7apbKv/N/Q5bCrNXrS11l/v8aDjIFOndsIH7FwNKx4NvFTHbfhKLgAczKUByEdYqxBI
         aJIsBey0NRxc5nUW7dwKmoQrVfOpq1n1T+bUoUOhZ0sVWCXYtiTZrLSzQ8q3NFOOITKh
         M4pueTwWqfvVdz07kcdlrnbQR+hVYqI1oDjngvIq5kYOUTVkG0boHvSPRF+dngwsv7b/
         yMAA==
X-Gm-Message-State: ACrzQf2dT5gGxm2NeeN6gjZ1TPymvotbXWBkiKJtfMNp6QU9LJeDqlCe
        MH6NDtQmUfIQMvzUz1UwyFotU7kF2li7V1FlqV+VmclfpQi0CKQzpHAhbKqUq/E3h+l1n9Yff/l
        s4Ijxt2lUN1BY4LEC
X-Received: by 2002:a17:906:eecb:b0:73c:5bcb:8eb3 with SMTP id wu11-20020a170906eecb00b0073c5bcb8eb3mr24267393ejb.284.1667398004322;
        Wed, 02 Nov 2022 07:06:44 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4Tj2FaxU3roPtMp95VNAskvSpB86ZGmAP7J3JbRyK9bWHjEuushbYOKSfv/6bTQnP1PveiZw==
X-Received: by 2002:a17:906:eecb:b0:73c:5bcb:8eb3 with SMTP id wu11-20020a170906eecb00b0073c5bcb8eb3mr24267358ejb.284.1667398004086;
        Wed, 02 Nov 2022 07:06:44 -0700 (PDT)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id f14-20020a056402150e00b004610899742asm5799369edw.13.2022.11.02.07.06.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 07:06:43 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <48ba6e77-1695-50b3-b27f-e82750ee70bb@redhat.com>
Date:   Wed, 2 Nov 2022 15:06:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Cc:     brouer@redhat.com,
        "Bezdeka, Florian" <florian.bezdeka@siemens.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "alexandr.lobakin@intel.com" <alexandr.lobakin@intel.com>,
        "anatoly.burakov@intel.com" <anatoly.burakov@intel.com>,
        "song@kernel.org" <song@kernel.org>,
        "Deric, Nemanja" <nemanja.deric@siemens.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "Kiszka, Jan" <jan.kiszka@siemens.com>,
        "magnus.karlsson@gmail.com" <magnus.karlsson@gmail.com>,
        "willemb@google.com" <willemb@google.com>,
        "ast@kernel.org" <ast@kernel.org>, "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "mtahhan@redhat.com" <mtahhan@redhat.com>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "haoluo@google.com" <haoluo@google.com>,
        Toke Hoiland Jorgensen <toke@redhat.com>
Subject: Re: [xdp-hints] Re: [RFC bpf-next 0/5] xdp: hints via kfuncs
Content-Language: en-US
To:     Martin KaFai Lau <martin.lau@linux.dev>,
        Stanislav Fomichev <sdf@google.com>
References: <20221027200019.4106375-1-sdf@google.com>
 <635bfc1a7c351_256e2082f@john.notmuch> <20221028110457.0ba53d8b@kernel.org>
 <CAKH8qBshi5dkhqySXA-Rg66sfX0-eTtVYz1ymHfBxSE=Mt2duA@mail.gmail.com>
 <635c62c12652d_b1ba208d0@john.notmuch> <20221028181431.05173968@kernel.org>
 <5aeda7f6bb26b20cb74ef21ae9c28ac91d57fae6.camel@siemens.com>
 <875yg057x1.fsf@toke.dk>
 <CAKH8qBvQbgE=oSZoH4xiLJmqMSXApH-ufd-qEKGKD8=POfhrWQ@mail.gmail.com>
 <77b115a0-bbba-48eb-89bd-3078b5fb7eeb@linux.dev>
 <CAKH8qBsGB1G60cu91Au816gsB2zF8T0P-yDwxbTEOxX0TN3WgA@mail.gmail.com>
 <0c00ba33-f37b-dfe6-7980-45920ffa273b@linux.dev>
In-Reply-To: <0c00ba33-f37b-dfe6-7980-45920ffa273b@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01/11/2022 18.05, Martin KaFai Lau wrote:
> On 10/31/22 6:59 PM, Stanislav Fomichev wrote:
>> On Mon, Oct 31, 2022 at 3:57 PM Martin KaFai Lau 
>> <martin.lau@linux.dev> wrote:
>>>
>>> On 10/31/22 10:00 AM, Stanislav Fomichev wrote:
>>>>> 2. AF_XDP programs won't be able to access the metadata without 
>>>>> using a
>>>>> custom XDP program that calls the kfuncs and puts the data into the
>>>>> metadata area. We could solve this with some code in libxdp, 
>>>>> though; if
>>>>> this code can be made generic enough (so it just dumps the available
>>>>> metadata functions from the running kernel at load time), it may be
>>>>> possible to make it generic enough that it will be forward-compatible
>>>>> with new versions of the kernel that add new fields, which should
>>>>> alleviate Florian's concern about keeping things in sync.
>>>>
>>>> Good point. I had to convert to a custom program to use the kfuncs :-(
>>>> But your suggestion sounds good; maybe libxdp can accept some extra
>>>> info about at which offset the user would like to place the metadata
>>>> and the library can generate the required bytecode?
>>>>
>>>>> 3. It will make it harder to consume the metadata when building 
>>>>> SKBs. I
>>>>> think the CPUMAP and veth use cases are also quite important, and that
>>>>> we want metadata to be available for building SKBs in this path. Maybe
>>>>> this can be resolved by having a convenient kfunc for this that can be
>>>>> used for programs doing such redirects. E.g., you could just call
>>>>> xdp_copy_metadata_for_skb() before doing the bpf_redirect, and that
>>>>> would recursively expand into all the kfunc calls needed to extract 
>>>>> the
>>>>> metadata supported by the SKB path?
>>>>
>>>> So this xdp_copy_metadata_for_skb will create a metadata layout that
>>>
>>> Can the xdp_copy_metadata_for_skb be written as a bpf prog itself?
>>> Not sure where is the best point to specify this prog though.  
>>> Somehow during
>>> bpf_xdp_redirect_map?
>>> or this prog belongs to the target cpumap and the xdp prog 
>>> redirecting to this
>>> cpumap has to write the meta layout in a way that the cpumap is 
>>> expecting?
>>
>> We're probably interested in triggering it from the places where xdp
>> frames can eventually be converted into skbs?
>> So for plain 'return XDP_PASS' and things like bpf_redirect/etc? (IOW,
>> anything that's not XDP_DROP / AF_XDP redirect).
>> We can probably make it magically work, and can generate
>> kernel-digestible metadata whenever data == data_meta, but the
>> question - should we?
>> (need to make sure we won't regress any existing cases that are not
>> relying on the metadata)
> 
> Instead of having some kernel-digestible meta data, how about calling 
> another bpf prog to initialize the skb fields from the meta area after 
> __xdp_build_skb_from_frame() in the cpumap, so 
> run_xdp_set_skb_fileds_from_metadata() may be a better name.
> 

I very much like this idea of calling another bpf prog to initialize the
SKB fields from the meta area. (As a reminder, data need to come from
meta area, because at this point the hardware RX-desc is out-of-scope).
I'm onboard with xdp_copy_metadata_for_skb() populating the meta area.

We could invoke this BPF-prog inside __xdp_build_skb_from_frame().

We might need a new BPF_PROG_TYPE_XDP2SKB as this new BPF-prog
run_xdp_set_skb_fields_from_metadata() would need both xdp_buff + SKB as
context inputs. Right?  (Not sure, if this is acceptable with the BPF
maintainers new rules)

> The xdp_prog@rx sets the meta data and then redirect.  If the 
> xdp_prog@rx can also specify a xdp prog to initialize the skb fields 
> from the meta area, then there is no need to have a kfunc to enforce a 
> kernel-digestible layout.  Not sure what is a good way to specify this 
> xdp_prog though...

The challenge of running this (BPF_PROG_TYPE_XDP2SKB) BPF-prog inside
__xdp_build_skb_from_frame() is that it need to know howto decode the
meta area for every device driver or XDP-prog populating this (as veth
and cpumap can get redirected packets from multiple device drivers).
Sure, using a common function/helper/macro like
xdp_copy_metadata_for_skb() could help reduce this multiplexing, but we
want to have maximum flexibility to extend this without having to update
the kernel, right.

Fortunately __xdp_build_skb_from_frame() have a net_device parameter,
that points to the device is was received on (xdp_frame->dev_rx).
Thus, we could extend net_device and add this BPF-prog on a per
net_device basis.  This could function as a driver BPF-prog callback
that populates the SKB fields from the XDP meta data.
Is this a good or bad idea?


>>>> the kernel will be able to understand when converting back to skb?
>>>> IIUC, the xdp program will look something like the following:
>>>>
>>>> if (xdp packet is to be consumed by af_xdp) {
>>>>     // do a bunch of bpf_xdp_metadata_<metadata> calls and assemble 
>>>> your
>>>> own metadata layout
>>>>     return bpf_redirect_map(xsk, ...);
>>>> } else {
>>>>     // if the packet is to be consumed by the kernel
>>>>     xdp_copy_metadata_for_skb(ctx);
>>>>     return bpf_redirect(...);
>>>> }
>>>>
>>>> Sounds like a great suggestion! xdp_copy_metadata_for_skb can maybe
>>>> put some magic number in the first byte(s) of the metadata so the
>>>> kernel can check whether xdp_copy_metadata_for_skb has been called
>>>> previously (or maybe xdp_frame can carry this extra signal, idk).

I'm in favor of adding a flag bit to xdp_frame to signal this.
In __xdp_build_skb_from_frame() we could check this flag signal and then
invoke the BPF-prog type BPF_PROG_TYPE_XDP2SKB.

--Jesper

