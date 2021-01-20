Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE1E2FD85F
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 19:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733283AbhATSeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 13:34:23 -0500
Received: from mga06.intel.com ([134.134.136.31]:19371 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404610AbhATSbM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 13:31:12 -0500
IronPort-SDR: jYERuX7VYTBSpjRp7G0rXFc8mlcULJ26afa4vf5nfs6J0aj96SAQjp5PjtPALcZqzOpRyHQJ+9
 Vy0CAnwGPW1w==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="240697048"
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="240697048"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 10:30:23 -0800
IronPort-SDR: xquYD5VDyQRiT5Qr5GXXTRCCPRt48zoJz91ZmNb3/88G9m+jiWj83NIW77d55bh/yrBb4tEeK7
 JfAsp64yFMMA==
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="384963935"
Received: from myegin-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.42.133])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 10:30:16 -0800
Subject: Re: [PATCH bpf-next v2 5/8] libbpf, xsk: select AF_XDP BPF program
 based on kernel version
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
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
        weqaar.a.janjua@intel.com, Marek Majtyka <alardam@gmail.com>
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
 <20210119155013.154808-6-bjorn.topel@gmail.com> <875z3repng.fsf@toke.dk>
 <6c7da700-700d-c7f6-fe0a-c42e55e81c8a@intel.com>
 <6cda7383-663e-ed92-45dd-bbf87ca45eef@intel.com> <87eeif4p96.fsf@toke.dk>
 <2751bcd9-b3af-0366-32ee-a52d5919246c@intel.com>
 <CAADnVQK1vL307SmmUZyuEAmy9S_A2fJwyHryCHBavQ-QDNyxww@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <9a624fee-6b49-9f00-3c21-d8ec3026a5a5@intel.com>
Date:   Wed, 20 Jan 2021 19:30:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAADnVQK1vL307SmmUZyuEAmy9S_A2fJwyHryCHBavQ-QDNyxww@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-20 19:25, Alexei Starovoitov wrote:
> On Wed, Jan 20, 2021 at 7:27 AM Björn Töpel <bjorn.topel@intel.com> wrote:
>>
>>>> Would it make sense with some kind of BPF-specific "supported
>>>> features" mechanism? Something else with a bigger scope (whole
>>>> kernel)?
>>>
>>> Heh, in my opinion, yeah. Seems like we'll finally get it for XDP, but
>>> for BPF in general the approach has always been probing AFAICT.
>>>
>>> For the particular case of arguments to helpers, I suppose the verifier
>>> could technically validate value ranges for flags arguments, say. That
>>> would be nice as an early reject anyway, but I'm not sure if it is
>>> possible to add after-the-fact without breaking existing programs
>>> because the verifier can't prove the argument is within the valid range.
>>> And of course it doesn't help you with compatibility with
>>> already-released kernels.
>>>
>>
>> Hmm, think I have a way forward. I'll use BPF_PROG_TEST_RUN.
>>
>> If the load fail for the new helper, fallback to bpf_redirect_map(). Use
>> BPF_PROG_TEST_RUN to make sure that "action via flags" passes.
> 
> +1 to Toke's point. No version checks please.
> One way to detect is to try prog_load. Search for FEAT_* in libbpf.
> Another approach is to scan vmlinux BTF for necessary helpers.
> Currently libbpf is relying on the former.
> I think going forward would be good to detect features via BTF.
> It's going to be much faster and won't create noise for audit that
> could be looking at prog_load calls.
> 

Thanks Alexei. I'll explore both options for the next spin!


Björn
