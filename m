Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410C42CB604
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 08:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387659AbgLBH4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 02:56:49 -0500
Received: from mga18.intel.com ([134.134.136.126]:40184 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbgLBH4t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 02:56:49 -0500
IronPort-SDR: A4IDKox7wYwoUmASHjupPfwaRT/1JfzOPj5NZt/ogjo0Ln7Tl4guo5AkzmT3u+KTmdqXlFILuU
 6DIuoTy7PsjQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9822"; a="160740640"
X-IronPort-AV: E=Sophos;i="5.78,386,1599548400"; 
   d="scan'208";a="160740640"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2020 23:56:05 -0800
IronPort-SDR: V7S7YJnVJj6Qag5dKZQSHz7a0GW/uW8bm1Fa6fj/dc5zZ88L8pPW6l00VsuFA/SAMRi6mOTTTI
 R2Nac6rIs29Q==
X-IronPort-AV: E=Sophos;i="5.78,386,1599548400"; 
   d="scan'208";a="481445384"
Received: from saenger-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.46.246])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2020 23:56:01 -0800
Subject: Re: [PATCH bpf-next] bpf, xdp: add bpf_redirect{,_map}() leaf node
 detection and optimization
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andrii@kernel.org,
        john.fastabend@gmail.com, hawk@kernel.org, kuba@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com
References: <20201201172345.264053-1-bjorn.topel@gmail.com>
 <87y2ihyzhp.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <f7480e4a-26f5-b3fa-69b9-3a80e4cc362d@intel.com>
Date:   Wed, 2 Dec 2020 08:55:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <87y2ihyzhp.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-01 22:42, Toke Høiland-Jørgensen wrote:
> Björn Töpel <bjorn.topel@gmail.com> writes:
> 
[...]
>>
>> Performance up ~5% Mpps for the xdp_redirect_map and xdpsock samples,
>> and ~3% for bpf_redirect() programs.
> 
> Neat! Got actual numbers? :)
>

+~1 Mpps for AF_XDP, and +~3 Mpps for a naive (non-swapping) redirect.


[...]
> 
> This seems like an awful lot of copy-paste code reuse. Why not keep the
> __xdp_map_lookup_elem() (and flags handling) in bpf_xdp_redirect_map()
> and call this function after that lookup (using ri->tgt_value since
> you're passing in ri anyway)? Similarly, __bpf_tx_xdp_map() already does
> the disambiguation on map type for enqueue that you are duplicating here.
> 
> I realise there may be some performance benefit to the way this is
> structured (assuming the compiler is not smart enough to optimise the
> code into basically the same thing as this), but at the very least I'd
> like to see the benefit quantified before accepting this level of code
> duplication :)
>

Good points; I'll need to take this to the drawing board again. Please
refer to Alexei's reply.

Thanks for taking a look!


Björn

