Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5914E2FE4E2
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 09:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbhAUIYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 03:24:41 -0500
Received: from mga14.intel.com ([192.55.52.115]:61595 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbhAUITy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 03:19:54 -0500
IronPort-SDR: YBufAQxKLCERx7GAKrDaU1Zlbx2QtUZhRHwLxS/Iz5G1U9FoI5acLDPVaNeBCWY4JFtSMNxVMI
 Fh687BIDT3NQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="178455904"
X-IronPort-AV: E=Sophos;i="5.79,363,1602572400"; 
   d="scan'208";a="178455904"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2021 00:18:57 -0800
IronPort-SDR: va0h/m6+D7EFfHL2T6AUJjRCdtNh19fdz62WtZ9HhGDeqNHAdCyC8qwnjfz21dwrTQABd4o5Ii
 jKzEpjGcauoA==
X-IronPort-AV: E=Sophos;i="5.79,363,1602572400"; 
   d="scan'208";a="385209218"
Received: from mirthes-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.51.235])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2021 00:18:52 -0800
Subject: Re: [PATCH bpf-next v2 4/8] xsk: register XDP sockets at bind(), and
 add new AF_XDP BPF helper
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>, maximmi@nvidia.com,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Ciara Loftus <ciara.loftus@intel.com>,
        weqaar.a.janjua@intel.com
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
 <20210119155013.154808-5-bjorn.topel@gmail.com> <878s8neprj.fsf@toke.dk>
 <46162f5f-5b3c-903b-8b8d-7c1afc74cb05@intel.com> <87k0s74q1a.fsf@toke.dk>
 <3c6feb0d-6a64-2251-3cac-c79cff29d85c@intel.com> <8735yv4iv1.fsf@toke.dk>
 <ca8cbe21-f020-e5c0-5f09-19260e95839f@intel.com> <87pn1z2w38.fsf@toke.dk>
 <CAADnVQ+R5JHhqUFnB_o3nJkkkcEtvO_Vk+xSDFiqP9dZ9H6vxw@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <36d92c18-e0a0-a4dc-3797-539f8fe6333c@intel.com>
Date:   Thu, 21 Jan 2021 09:18:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAADnVQ+R5JHhqUFnB_o3nJkkkcEtvO_Vk+xSDFiqP9dZ9H6vxw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-20 22:15, Alexei Starovoitov wrote:
> On Wed, Jan 20, 2021 at 12:26 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>> This argument, however, I buy: bpf_redirect() is the single-purpose
>> helper for redirecting to an ifindex, bpf_redirect_xsk() is the
>> single-purpose helper for redirecting to an XSK, and bpf_redirect_map()
>> is the generic one that does both of those and more. Fair enough,
>> consider me convinced :)
>>
>>> A lot of back-and-forth for *one* if-statement, but it's kind of a
>>> design thing for me. ;-)
>>
>> Surely you don't mean to imply that you have *better* things to do with
>> your time than have a 10-emails-long argument over a single if
>> statement? ;)
> 
> After reading this thread I think I have to pour cold water on the design.
> 
> The performance blip comes from hard coded assumptions:
> + queue_id = xdp->rxq->queue_index;
> + xs = READ_ONCE(dev->_rx[queue_id].xsk);
>

Yes, one can see this as a constrained map:

* The map belongs to a certain netdev.
* Each entry corresponds to a certain queue id.

I.e if we do a successful (non-NULL) lookup, we *know* that all sockets
in that map belong to the netdev, and has the correct queue id.

By doing that we can get rid of two run-time checks: "Is the socket
bound to this netdev?" and "Is this the correct queue id?".

> bpf can have specialized helpers, but imo this is beyond what's reasonable.
> Please move such things into the program and try to make
> bpf_redirect_map faster.
>

I obviously prefer this path, and ideally combined with a way to even
more specialize xdp_do_redirect(). Then again, you are the maintainer! :-)

Maybe an alternative be adding a new type of XSKMAP constrained in the
similar way as above, and continue with bpf_redirect_map(), but with
this new map the index argument would be ignored. Unfortunately the BPF
context (xdp_buff in this case) is not passed to bpf_redirect_map(), so
getting the actual queue_id in the helper is hard. Adding the context as
an additional argument would be a new helper...

I'll need to think a bit more about it. Input/ideas are welcome!


> Making af_xdp non-root is orthogonal. If there is actual need for that
> it has to be designed thoroughly and not presented as "this helper may
> help to do that".
> I don't think "may" will materialize unless people actually work
> toward the goal of non-root.
> 

Fair enough! Same goal could be reached using the existing map approach.


Björn
