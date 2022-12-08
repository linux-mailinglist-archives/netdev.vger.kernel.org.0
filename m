Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A98647910
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 23:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiLHWxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 17:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiLHWxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 17:53:47 -0500
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D92A60EB9
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 14:53:46 -0800 (PST)
Message-ID: <a5a636cc-5b03-686f-4be0-000383b05cfc@linux.dev>
Date:   Thu, 8 Dec 2022 14:53:37 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v3 03/12] bpf: XDP metadata RX kfuncs
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20221206024554.3826186-1-sdf@google.com>
 <20221206024554.3826186-4-sdf@google.com>
 <391b9abf-c53a-623c-055f-60768c716baa@linux.dev>
 <CAKH8qBvfNDo-+qB-CyvCjQAcTtftWoQJTPwVb4zdAMZs=TzG7w@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CAKH8qBvfNDo-+qB-CyvCjQAcTtftWoQJTPwVb4zdAMZs=TzG7w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/22 11:07 AM, Stanislav Fomichev wrote:
>>> @@ -102,11 +112,25 @@ int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
>>>        if (err)
>>>                goto err_maybe_put;
>>>
>>> +     prog->aux->offload_requested = !(attr->prog_flags & BPF_F_XDP_HAS_METADATA);
>>> +
>>
>> If I read the set correctly, bpf prog can either use metadata kfunc or offload
>> but not both. It is fine to start with only supporting metadata kfunc when there
>> is no offload but will be useful to understand the reason. I assume an offloaded
>> bpf prog should still be able to call the bpf helpers like adjust_head/tail and
>> the same should go for any kfunc?
> 
> Yes, I'm assuming there should be some work on the offloaded device
> drivers to support metadata kfuncs.
> Offloaded kfuncs, in general, seem hard (how do we call kernel func
> from the device-offloaded prog?); so refusing kfuncs early for the
> offloaded case seems fair for now?

Ah, ok.  I was actually thinking the HW offloaded prog can just use the software 
ndo_* kfunc (like other bpf-helpers).  From skimming some 
bpf_prog_offload_ops:prepare implementation, I think you are right and it seems 
BPF_PSEUDO_KFUNC_CALL has not been recognized yet.

[ ... ]

>>> @@ -226,10 +263,17 @@ static void __bpf_prog_offload_destroy(struct bpf_prog *prog)
>>>
>>>    void bpf_prog_offload_destroy(struct bpf_prog *prog)
>>>    {
>>> +     struct net_device *netdev = NULL;
>>> +
>>>        down_write(&bpf_devs_lock);
>>> -     if (prog->aux->offload)
>>> +     if (prog->aux->offload) {
>>> +             netdev = prog->aux->offload->netdev;
>>>                __bpf_prog_offload_destroy(prog);
>>> +     }
>>>        up_write(&bpf_devs_lock);
>>> +
>>> +     if (netdev)
>>
>> May be I have missed a refcnt or lock somewhere.  Is it possible that netdev may
>> have been freed?
> 
> Yeah, with the offload framework, there are no refcnts. We put an
> "offloaded" device into a separate hashtable (protected by
> rtnl/semaphore).
> maybe_remove_bound_netdev will re-grab the locks (due to ordering:
> rtnl->bpf_devs_lock) and remove the device from the hashtable if it's
> still there.
> At least this is how, I think, it should work; LMK if something is
> still fishy here...
> 
> Or is the concern here that somebody might allocate new netdev reusing
> the same address? I think I have enough checks in
> maybe_remove_bound_netdev to guard against that. Or, at least, to make
> it safe :-)

Race is ok because ondev needs to be removed anyway when '!ondev->offdev && 
list_empty(&ondev->progs)'?  hmmm... tricky, please add a comment. :)

Why it cannot be done together in the bpf_devs_lock above?  The above cannot 
take an extra rtnl_lock before bpf_devs_lock?

