Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8DC31C0CA
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 18:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhBORkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 12:40:43 -0500
Received: from mga14.intel.com ([192.55.52.115]:34425 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231240AbhBORjg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 12:39:36 -0500
IronPort-SDR: AWpQObXPzsC8UM/KizM5n3ugGdKKyb9lwWsVIGL5tPFLJgiIx10K75j+bokcZyg8/H+iTK940J
 Ybs5nM+pF8Dg==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="181951453"
X-IronPort-AV: E=Sophos;i="5.81,181,1610438400"; 
   d="scan'208";a="181951453"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 09:38:54 -0800
IronPort-SDR: 5dbHVzqD9yQEYHH+BVSwadyPXMdAfqfFtOchrAcua8vl1oeo3tTMUyhPGch6XAcUuLW1VrcTsU
 ga5CRXwcC/kg==
X-IronPort-AV: E=Sophos;i="5.81,181,1610438400"; 
   d="scan'208";a="399159724"
Received: from wwantka-mobl2.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.54.83])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 09:38:51 -0800
Subject: Re: [PATCH bpf-next 1/3] libbpf: xsk: use bpf_link
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     andrii@kernel.org, magnus.karlsson@intel.com,
        ciara.loftus@intel.com
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-2-maciej.fijalkowski@intel.com> <87eehhcl9x.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <fe0c957e-d212-4265-a271-ba301c3c5eca@intel.com>
Date:   Mon, 15 Feb 2021 18:38:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <87eehhcl9x.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-15 18:07, Toke Høiland-Jørgensen wrote:
> Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:
> 
>> Currently, if there are multiple xdpsock instances running on a single
>> interface and in case one of the instances is terminated, the rest of
>> them are left in an inoperable state due to the fact of unloaded XDP
>> prog from interface.
>>
>> To address that, step away from setting bpf prog in favour of bpf_link.
>> This means that refcounting of BPF resources will be done automatically
>> by bpf_link itself.
>>
>> When setting up BPF resources during xsk socket creation, check whether
>> bpf_link for a given ifindex already exists via set of calls to
>> bpf_link_get_next_id -> bpf_link_get_fd_by_id -> bpf_obj_get_info_by_fd
>> and comparing the ifindexes from bpf_link and xsk socket.
> 
> One consideration here is that bpf_link_get_fd_by_id() is a privileged
> operation (privileged as in CAP_SYS_ADMIN), so this has the side effect
> of making AF_XDP privileged as well. Is that the intention?
>

We're already using, e.g., bpf_map_get_fd_by_id() which has that
as well. So we're assuming that for XDP setup already!

> Another is that the AF_XDP code is in the process of moving to libxdp
> (see in-progress PR [0]), and this approach won't carry over as-is to
> that model, because libxdp has to pin the bpf_link fds.
>

I was assuming there were two modes of operations for AF_XDP in libxdp.
One which is with the multi-program support (which AFAIK is why the
pinning is required), and one "like the current libbpf" one. For the
latter Maciej's series would be a good fit, no?

> However, in libxdp we can solve the original problem in a different way,
> and in fact I already suggested to Magnus that we should do this (see
> [1]); so one way forward could be to address it during the merge in
> libxdp? It should be possible to address the original issue (two
> instances of xdpsock breaking each other when they exit), but
> applications will still need to do an explicit unload operation before
> exiting (i.e., the automatic detach on bpf_link fd closure will take
> more work, and likely require extending the bpf_link kernel support)...
>

I'd say it's depending on the libbpf 1.0/libxdp merge timeframe. If
we're months ahead, then I'd really like to see this in libbpf until the
merge. However, I'll leave that for Magnus/you to decide!

Bottom line; I'd *really* like bpf_link behavior (process scoped) for
AF_XDP sooner than later! ;-)


Thanks for the input!
Björn


> -Toke
> 
> [0] https://github.com/xdp-project/xdp-tools/pull/92
> [1] https://github.com/xdp-project/xdp-tools/pull/92#discussion_r576204719
> 
