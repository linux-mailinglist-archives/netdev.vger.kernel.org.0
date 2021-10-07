Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078CD425ED7
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 23:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240837AbhJGV1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 17:27:43 -0400
Received: from www62.your-server.de ([213.133.104.62]:38132 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241559AbhJGV11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 17:27:27 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mYatN-000EC6-Ne; Thu, 07 Oct 2021 23:25:29 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mYatN-0009y9-HO; Thu, 07 Oct 2021 23:25:29 +0200
Subject: Re: [PATCH bpf-next v2 0/3] Add XDP support for bpf_load_hdr_opt
To:     Joanne Koong <joannekoong@fb.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org
Cc:     kafai@fb.com, netdev@vger.kernel.org, Kernel-team@fb.com
References: <20211006230543.3928580-1-joannekoong@fb.com>
 <87h7dsnbh5.fsf@toke.dk> <9f8c195c-9c03-b398-2803-386c7af99748@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <43bfb0fe-5476-c62c-51f2-a83da9fef659@iogearbox.net>
Date:   Thu, 7 Oct 2021 23:25:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <9f8c195c-9c03-b398-2803-386c7af99748@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26315/Thu Oct  7 11:09:01 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/7/21 10:57 PM, Joanne Koong wrote:
> On 10/7/21 7:41 AM, Toke Høiland-Jørgensen wrote:
>> Joanne Koong <joannekoong@fb.com> writes:
>>
>>> Currently, bpf_sockops programs have been using bpf_load_hdr_opt() to
>>> parse the tcp header option. It will be useful to allow other bpf prog
>>> types to have a similar way of handling tcp hdr options.
>>>
>>> This series adds XDP support for bpf_load_hdr_opt(). At a high level,
>>> these patches are:
>> Why is this needed? Why not just parse the header directly in XDP?
> Parsing a variable number of TCP options is challenging for the verifier.
> Some programs are using #pragma unroll as a temporary workaround
> (https://github.com/xdp-project/bpf-examples/blob/master/pping/pping_kern.c#L95)
> I believe Christian Deacon also recently posted about this on the xdp mailing list
> with a link to his bpf fail logs in https://github.com/gamemann/XDP-TCP-Header-Options
> which showcases some of the difficulties involved
> 
>> Seems
>> a bit arbitrary to add a helper for this particular type of packet
>> payload parsing to this particular program type. I.e., what about other
>> headers (IP options?)?
> The current use case needs so far have been for parsing tcp headers, but
> in the future, when there are needs for parsing other types, they
> can be supported as well through bpf_load_hdr_opt.
> 
>> Are we going to have a whole bunch of
>> special-purpose parsing helpers to pick out protocol data from packets?
> 
> I think bpf_load_hdr_opt is generic enough to support parsing
> any kind of protocol data (as specified through flags) in the packets

I tend to agree with Toke here that this is not generic. What has been tried
to improve the verifier instead before submitting the series? It would be much
more preferable to improve the developer experience with regards to a generic
solution, so that other/similar problems can be tackled in one go as well such
as IP options, extension headers, etc.

>> Also, why only enable this for XDP (and not, say the TC hook as well)?
> The plan is to also support this in tc as well (this will be in a separate
> patchset)
