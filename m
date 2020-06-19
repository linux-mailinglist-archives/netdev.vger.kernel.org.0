Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B74B20098D
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 15:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgFSNI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 09:08:27 -0400
Received: from www62.your-server.de ([213.133.104.62]:50548 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbgFSNIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 09:08:24 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jmGkm-0004dR-KW; Fri, 19 Jun 2020 15:08:20 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jmGkm-0002Dp-BA; Fri, 19 Jun 2020 15:08:20 +0200
Subject: Re: [PATCH bpf-next 1/2] bpf: switch most helper return values from
 32-bit int to 64-bit long
To:     John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
References: <20200617202112.2438062-1-andriin@fb.com>
 <5eeb0e5dcb010_8712abba49be5bc91@john-XPS-13-9370.notmuch>
 <CAEf4BzZi5pMTC9Fq53Mi_mXUm-EQZDyqS_pxEYuGoc0J1ETGUA@mail.gmail.com>
 <5eebb95299a20_6d292ad5e7a285b835@john-XPS-13-9370.notmuch>
 <CAEf4BzZmWO=hO0kmtwkACEfHZm+H7+FZ+5moaLie2=13U3xU=g@mail.gmail.com>
 <5eebf9321e11a_519a2abc9795c5bc21@john-XPS-13-9370.notmuch>
 <5eec09418954e_27ce2adb0816a5b8f7@john-XPS-13-9370.notmuch>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <45321002-2676-0f5b-c729-5526e503ebd2@iogearbox.net>
Date:   Fri, 19 Jun 2020 15:08:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <5eec09418954e_27ce2adb0816a5b8f7@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25847/Thu Jun 18 14:58:52 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/19/20 2:39 AM, John Fastabend wrote:
> John Fastabend wrote:
>> Andrii Nakryiko wrote:
>>> On Thu, Jun 18, 2020 at 11:58 AM John Fastabend
>>> <john.fastabend@gmail.com> wrote:
> 
> [...]
> 
>>> That would be great. Self-tests do work, but having more testing with
>>> real-world application would certainly help as well.
>>
>> Thanks for all the follow up.
>>
>> I ran the change through some CI on my side and it passed so I can
>> complain about a few shifts here and there or just update my code or
>> just not change the return types on my side but I'm convinced its OK
>> in most cases and helps in some so...
>>
>> Acked-by: John Fastabend <john.fastabend@gmail.com>
> 
> I'll follow this up with a few more selftests to capture a couple of our
> patterns. These changes are subtle and I worry a bit that additional
> <<,s>> pattern could have the potential to break something.
> 
> Another one we didn't discuss that I found in our code base is feeding
> the output of a probe_* helper back into the size field (after some
> alu ops) of subsequent probe_* call. Unfortunately, the tests I ran
> today didn't cover that case.
> 
> I'll put it on the list tomorrow and encode these in selftests. I'll
> let the mainainers decide if they want to wait for those or not.

Given potential fragility on verifier side, my preference would be that we
have the known variations all covered in selftests before moving forward in
order to make sure they don't break in any way. Back in [0] I've seen mostly
similar cases in the way John mentioned in other projects, iirc, sysdig was
another one. If both of you could hack up the remaining cases we need to
cover and then submit a combined series, that would be great. I don't think
we need to rush this optimization w/o necessary selftests.

Thanks everyone,
Daniel

   [0] https://lore.kernel.org/bpf/20200421125822.14073-1-daniel@iogearbox.net/
