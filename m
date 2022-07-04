Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC3C565D7D
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 20:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbiGDS0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 14:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiGDS0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 14:26:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CB5B82AD1
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 11:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656959180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PnHE1Fmm3dD20/PWMICE8P40a11Tvt3NNjhIvetHMKs=;
        b=dMROpZQXPgP7FUfW8pPQBOi2ydZpyFNczgJXPeamZGrg3vxACo2U2ABsovJMsf/5w0oMD0
        qHWrQ/I+F71ycrVjsZWdtyumqt457FUbfTiqpl4K1bXTEA3+Bt3YEUF6E9xsVb6ebSRFdx
        YK+EpTdUqVlPn/zpsNlHVSr0LBkxkXI=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-iZPXazR4M5e9bH_vxYNhmQ-1; Mon, 04 Jul 2022 14:26:19 -0400
X-MC-Unique: iZPXazR4M5e9bH_vxYNhmQ-1
Received: by mail-lf1-f71.google.com with SMTP id bp15-20020a056512158f00b0047f603e5f92so3316888lfb.20
        for <netdev@vger.kernel.org>; Mon, 04 Jul 2022 11:26:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=PnHE1Fmm3dD20/PWMICE8P40a11Tvt3NNjhIvetHMKs=;
        b=Hkszabi5ByQR8Y1NxwhAW6Mprg+jPdTPSHXP4Gqf+4XgkfAMAwPq0Hd0C4+EB77rr/
         uhxdYpWLosu9eOti9blSCeiLzTIfVWRpV1JxhG9k911sVGBtVRV1q8ZkKIIqQ3QybpES
         OUAcc2D76CB5W/zfbght0dXLbk0kcEpmXs07Ws66aGXeEqkZTe/Tx7xW1svlFjlqQhkK
         kCiRqCN2KWBlpnH0RN3/s9eMqexQGfjBtva2+I/QDw9A91TRa+g+Eq3WDqdNQ0sZJrCT
         3/iCi2ELyL9y/Uufq5CQh6/zNQSZyqufnP6X1n69hYk+ggQvj5lmHMGFQ3zeK4qZ9FIa
         Zz+A==
X-Gm-Message-State: AJIora8Aa6hk2rbMAGa6uPqFvWixBIyaS/AM1t0xMtQqzxYjzXEWmlYa
        jlP4U1PN+gOlkvxnIPdcUmSvZId3zuvBZByQopjoycNp9Ue+lhs/uJ7Gj+AqoqaFMBEmigGdF7y
        MpKb9bRahElPBLm74
X-Received: by 2002:a2e:bf27:0:b0:246:7ed6:33b0 with SMTP id c39-20020a2ebf27000000b002467ed633b0mr18205726ljr.167.1656959178030;
        Mon, 04 Jul 2022 11:26:18 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tAcT1V6ZC9TJlTz3gqpYB/0gVILKOCboMNrd6sk9hCWdcja7d6UyTIl9BqZhEQjLo/O2JEbA==
X-Received: by 2002:a2e:bf27:0:b0:246:7ed6:33b0 with SMTP id c39-20020a2ebf27000000b002467ed633b0mr18205718ljr.167.1656959177737;
        Mon, 04 Jul 2022 11:26:17 -0700 (PDT)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id c2-20020ac25f62000000b00478f3fe716asm5248002lfc.200.2022.07.04.11.26.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jul 2022 11:26:16 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <b8085a4d-5ede-3cc0-a177-ad97fe08ce25@redhat.com>
Date:   Mon, 4 Jul 2022 20:26:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Cc:     brouer@redhat.com,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>
Subject: Re: [PATCH RFC bpf-next 5/9] xdp: controlling XDP-hints from BPF-prog
 via helper
Content-Language: en-US
To:     "Zaremba, Larysa" <larysa.zaremba@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Netdev <netdev@vger.kernel.org>
References: <DM4PR11MB54718267242004151337602F97BE9@DM4PR11MB5471.namprd11.prod.outlook.com>
In-Reply-To: <DM4PR11MB54718267242004151337602F97BE9@DM4PR11MB5471.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 04/07/2022 13.00, Zaremba, Larysa wrote:
> Toke Høiland-Jørgensen <toke@redhat.com> writes:
>>
>> Jesper Dangaard Brouer <jbrouer@redhat.com> writes:
>>
>>> On 29/06/2022 16.20, Toke Høiland-Jørgensen wrote:
>>>> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>>>>
>>>>> XDP BPF-prog's need a way to interact with the XDP-hints. This
>>>>> patch introduces a BPF-helper function, that allow XDP BPF-prog's
>>>>> to interact with the XDP-hints.
>>>>>
>>>>> BPF-prog can query if any XDP-hints have been setup and if this is
>>>>> compatible with the xdp_hints_common struct. If XDP-hints are
>>>>> available the BPF "origin" is returned (see enum
>>>>> xdp_hints_btf_origin) as BTF can come from different sources or
>>>>> origins e.g. vmlinux, module or local.
>>>>
>>>> I'm not sure I quite understand what this origin is supposed to be
>>>> good for?
>>>
>>> Some background info on BTF is needed here: BTF_ID numbers are not
>>> globally unique identifiers, thus we need to know where it originate
>>> from, to make it unique (as we store this BTF_ID in XDP-hints).
>>>
>>> There is a connection between origin "vmlinux" and "module", which
>>> is that vmlinux will start at ID=1 and end at a max ID number.
>>> Modules refer to ID's in "vmlinux", and for this to work, they will
>>> shift their own numbering to start after ID=max-vmlinux-id.
>>>
>>> Origin "local" is for BTF information stored in the BPF-ELF object file.
>>> Their numbering starts at ID=1.  The use-case is that a BPF-prog
>>> want to extend the kernel drivers BTF-layout, and e.g. add a
>>> RX-timestamp like [1].  Then BPF-prog can check if it knows module's
>>> BTF_ID and then extend via bpf_xdp_adjust_meta, and update BTF_ID in
>>> XDP-hints and call the helper (I introduced) marking this as origin
>>> "local" for kernel to know this is no-longer origin "module".
>>
>> Right, I realise that :)
>>
>> My point was that just knowing "this is a BTF ID coming from a module"
>> is not terribly useful; you could already figure that out by just
>> looking at the ID and seeing if it's larger than the maximum ID in vmlinux BTF.
>>
>> Rather, what we need is a way to identify *which* module the BTF ID
>> comes from; and luckily, the kernel assigns a unique ID to every BTF
>> *object* as well as to each type ID within that object. These can be
>> dumped by bpftool:
>>
>> # bpftool btf
>> bpftool btf
>> [sudo] password for alrua:
>> 1: name [vmlinux]  size 4800187B
>> 2: name [serio]  size 2588B
>> 3: name [i8042]  size 11786B
>> 4: name [rng_core]  size 8184B
>> [...]
>> 2062: name <anon>  size 36965B
>> 	pids bpftool(547298)
>>
>> IDs 2-4 are module BTF objects, and that last one is the ID of a BTF
>> object loaded along with a BPF program by bpftool itself... So we *do*
>> in fact have a unique ID, by combining the BTF object ID with the type
>> ID; this is what Alexander is proposing to put into the xdp-hints
>> struct as well (combining the two IDs into a single u64).

Thanks for the explanation. I think I understand it now, and I agree
that we should extend/combining the two IDs into a single u64.

To Andrii, what is the right terminology when talking about these two
different BTF-ID's:

- BTF object ID and BTF type ID?

- Where BTF *object* ID are the IDs we see above from 'bpftool btf',
   where vmlinux=1 and module's IDs will start after 1.

- Where BTF *type* ID are the IDs the individual data "types" within a
   BTF "object" (e.g. struct xdp_hints_common that BPF-prog's can get
   via calling bpf_core_type_id_kernel()).


> That's correct, concept was previously discussed [1]. The ID of BTF object wasn't
> exposed in CO-RE allocations though, we've changed it in the first 4 patches.
> The main logic is in "libbpf: factor out BTF loading from load_module_btfs()"
> and "libbpf: patch module BTF ID into BPF insns".
> 
> We have a sample that wasn't included eventually, but can possibly
> give a general understanding of our approach [2].
> 
> [1] https://lore.kernel.org/all/CAEf4BzZO=7MKWfx2OCwEc+sKkfPZYzaELuobi4q5p1bOKk4AQQ@mail.gmail.com/
> [2] https://github.com/alobakin/linux/pull/16/files#diff-c5983904cbe0c280453d59e8a1eefb56c67018c38d5da0c1122abc86225fc7c9
> 
(appreciate the links)

I wonder how these BTF object IDs gets resolved for my "local" category?
(Origin "local" is for BTF information stored in the BPF-ELF object file)

Note: For "local" BTF type IDs BPF-prog resolve these via
bpf_core_type_id_local() (why I choose the term "local").

--Jesper

p.s. For unknown reasons lore.kernel.org did match Larysa's reply with 
the patchset thread here[3].

  [3] 
https://lore.kernel.org/bpf/165643378969.449467.13237011812569188299.stgit@firesoul/#r


