Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C49D25C377
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 16:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbgICOwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 10:52:00 -0400
Received: from www62.your-server.de ([213.133.104.62]:35936 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729058AbgICONn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 10:13:43 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kDpdy-0007al-SI; Thu, 03 Sep 2020 15:51:15 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kDpdy-0008BF-Ll; Thu, 03 Sep 2020 15:51:14 +0200
Subject: Re: [PATCH] libbpf: Remove arch-specific include path in Makefile
To:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Networking <netdev@vger.kernel.org>,
        Vaidyanathan Srinivasan <svaidy@linux.ibm.com>
References: <20200902084246.1513055-1-naveen.n.rao@linux.vnet.ibm.com>
 <CAEf4BzZXyJsJ6rFp7pj_0PhyE_df9Z08wE9pUkZBp8i1qz_h1Q@mail.gmail.com>
 <fc8b0c65-b74a-d924-4189-ff6359d1ebdc@iogearbox.net>
 <1599111859.vtxbe8ojub.naveen@linux.ibm.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c31ef991-25d0-dab4-819f-13eb38965a86@iogearbox.net>
Date:   Thu, 3 Sep 2020 15:51:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1599111859.vtxbe8ojub.naveen@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25918/Wed Sep  2 15:41:14 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/3/20 7:46 AM, Naveen N. Rao wrote:
> Daniel Borkmann wrote:
>> On 9/2/20 10:58 PM, Andrii Nakryiko wrote:
>>> On Wed, Sep 2, 2020 at 1:43 AM Naveen N. Rao
>>> <naveen.n.rao@linux.vnet.ibm.com> wrote:
>>>>
>>>> Ubuntu mainline builds for ppc64le are failing with the below error (*):
>>>>      CALL    /home/kernel/COD/linux/scripts/atomic/check-atomics.sh
>>>>      DESCEND  bpf/resolve_btfids
>>>>
>>>>    Auto-detecting system features:
>>>>    ...                        libelf: [ [32mon[m  ]
>>>>    ...                          zlib: [ [32mon[m  ]
>>>>    ...                           bpf: [ [31mOFF[m ]
>>>>
>>>>    BPF API too old
>>>>    make[6]: *** [Makefile:295: bpfdep] Error 1
>>>>    make[5]: *** [Makefile:54: /home/kernel/COD/linux/debian/build/build-generic/tools/bpf/resolve_btfids//libbpf.a] Error 2
>>>>    make[4]: *** [Makefile:71: bpf/resolve_btfids] Error 2
>>>>    make[3]: *** [/home/kernel/COD/linux/Makefile:1890: tools/bpf/resolve_btfids] Error 2
>>>>    make[2]: *** [/home/kernel/COD/linux/Makefile:335: __build_one_by_one] Error 2
>>>>    make[2]: Leaving directory '/home/kernel/COD/linux/debian/build/build-generic'
>>>>    make[1]: *** [Makefile:185: __sub-make] Error 2
>>>>    make[1]: Leaving directory '/home/kernel/COD/linux'
>>>>
>>>> resolve_btfids needs to be build as a host binary and it needs libbpf.
>>>> However, libbpf Makefile hardcodes an include path utilizing $(ARCH).
>>>> This results in mixing of cross-architecture headers resulting in a
>>>> build failure.
>>>>
>>>> The specific header include path doesn't seem necessary for a libbpf
>>>> build. Hence, remove the same.
>>>>
>>>> (*) https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.9-rc3/ppc64el/log
>>>>
>>>> Reported-by: Vaidyanathan Srinivasan <svaidy@linux.ibm.com>
>>>> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>>>> ---
>>>
>>> This seems to still build fine for me, so I seems fine. Not sure why
>>> that $(ARCH)/include/uapi path is there.
>>>
>>> Acked-by: Andrii Nakryiko <andriin@fb.com>
>>
>> Same here, builds fine from my side too. Looks like this was from the very early days,
>> added in commit 1b76c13e4b36 ("bpf tools: Introduce 'bpf' library and add bpf feature
>> check"). Applied, thanks!
> 
> Thanks!
> 
> Daniel, I see that this has been applied to bpf-next. Can you please consider sending this in for v5.9-rc series so as to resolve the build failures?

Ok, done, I've moved it to bpf tree so its on track for 5.9.

Thanks,
Daniel
