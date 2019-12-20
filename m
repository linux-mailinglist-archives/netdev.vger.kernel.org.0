Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE27C12832E
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 21:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbfLTUWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 15:22:52 -0500
Received: from www62.your-server.de ([213.133.104.62]:48248 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727413AbfLTUWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 15:22:51 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iiOnO-0005EJ-EG; Fri, 20 Dec 2019 21:22:46 +0100
Received: from [178.197.248.55] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iiOnO-000BM7-2K; Fri, 20 Dec 2019 21:22:46 +0100
Subject: Re: [PATCH bpf-next] libbpf: fix AF_XDP helper program to support
 kernels without the JMP32 eBPF instruction class
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alex Forster <aforster@cloudflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        bpf <bpf@vger.kernel.org>
References: <20191219201601.7378-1-aforster@cloudflare.com>
 <CAADnVQLrsgGzVcBea68gf+yZ2R-iYzCJupE6jzaqR5ctbCKxNw@mail.gmail.com>
 <CAKxSbF19OsyE8B9mM+nB6676R6oA0duXSLn6_GGr1A+tCKhY9w@mail.gmail.com>
 <c02dbf12-f1ae-8cb1-13fc-a7bb2fbff3aa@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e8253d51-1821-af17-ce07-7c4cbc28f15e@iogearbox.net>
Date:   Fri, 20 Dec 2019 21:22:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <c02dbf12-f1ae-8cb1-13fc-a7bb2fbff3aa@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25669/Fri Dec 20 10:57:00 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/20/19 8:20 AM, Björn Töpel wrote:
> On 2019-12-19 23:29, Alex Forster wrote:
>>> I though af_xdp landed after jmp32 ?
>>
>> They were indeed pretty close together, but AF_XDP became usable in
>> late 2018 with either 4.18 or 4.19. JMP32 landed in early 2019 with
>> 5.1.
> 
> Correct, but is anyone really using AF_XDP pre-5.1?
> 
> The rationale for doing JMP32:
> https://lore.kernel.org/bpf/87v9sip0i8.fsf@toke.dk/
> 
> I think going forward, a route where different AF_XDP programs is loaded
> based on what currently running kernel supports. "Every s^Hcycle is
> sacred", and we're actually paying for the extra checks.
> 
> Then again, failing to load is still pretty bad. :-) Thanks for fixing this.

Could we simply just test availability of JMP32 in underlying kernel and use
it if available, if not, fall back to regular JMP. libbpf already has infra
for this, so xsk code could make use of it.

Thanks,
Daniel
