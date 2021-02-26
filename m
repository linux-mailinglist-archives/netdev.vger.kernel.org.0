Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F24B32620A
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 12:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhBZLi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 06:38:56 -0500
Received: from mga18.intel.com ([134.134.136.126]:48589 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229537AbhBZLiz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 06:38:55 -0500
IronPort-SDR: FqGkg9ILuFDtaNBZY2Mc+kIH1+w15XTE/jg3DzczTTcAfYcDi9tXKkolFVQwNJvxDL+Wzi1a1H
 N24GFZpgOUcg==
X-IronPort-AV: E=McAfee;i="6000,8403,9906"; a="173498178"
X-IronPort-AV: E=Sophos;i="5.81,208,1610438400"; 
   d="scan'208";a="173498178"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 03:38:14 -0800
IronPort-SDR: rhOnYUYDaLRqw9fJo8tMyhsjyXHtMrr9zg0B48NBhd+TAKheFFHY7DfiJHKI+MYkkaSsJQI2TX
 JuhCVUJfYehQ==
X-IronPort-AV: E=Sophos;i="5.81,208,1610438400"; 
   d="scan'208";a="404867022"
Received: from hkarray-mobl2.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.60.134])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 03:38:10 -0800
Subject: Re: [PATCH bpf-next v4 0/2] Optimize
 bpf_redirect_map()/xdp_do_redirect()
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     maciej.fijalkowski@intel.com, hawk@kernel.org,
        magnus.karlsson@intel.com, john.fastabend@gmail.com,
        kuba@kernel.org, davem@davemloft.net
References: <20210226112322.144927-1-bjorn.topel@gmail.com>
 <87v9afysd0.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <1759bd57-0c52-d1f2-d620-e7796f95cff6@intel.com>
Date:   Fri, 26 Feb 2021 12:38:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <87v9afysd0.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-26 12:35, Toke Høiland-Jørgensen wrote:
> Björn Töpel <bjorn.topel@gmail.com> writes:
> 
>> Hi XDP-folks,
>>
>> This two patch series contain two optimizations for the
>> bpf_redirect_map() helper and the xdp_do_redirect() function.
>>
>> The bpf_redirect_map() optimization is about avoiding the map lookup
>> dispatching. Instead of having a switch-statement and selecting the
>> correct lookup function, we let bpf_redirect_map() be a map operation,
>> where each map has its own bpf_redirect_map() implementation. This way
>> the run-time lookup is avoided.
>>
>> The xdp_do_redirect() patch restructures the code, so that the map
>> pointer indirection can be avoided.
>>
>> Performance-wise I got 3% improvement for XSKMAP
>> (sample:xdpsock/rx-drop), and 4% (sample:xdp_redirect_map) on my
>> machine.
>>
>> More details in each commit.
>>
>> @Jesper/Toke I dropped your Acked-by: on the first patch, since there
>> were major restucturing. Please have another look! Thanks!
> 
> Will do! Did you update the performance numbers above after that change?
>

I did. The XSKMAP performance stayed the same (no surprise, since the
code was the same). However, for the DEVMAP the v4 got rid of a call, so
it *should* be a bit better, but for some reason it didn't show on my
machine.


Björn
