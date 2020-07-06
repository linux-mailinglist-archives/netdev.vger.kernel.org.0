Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC78D215FFB
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 22:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgGFUP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 16:15:59 -0400
Received: from www62.your-server.de ([213.133.104.62]:58946 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgGFUP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 16:15:59 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jsXWu-0003oD-66; Mon, 06 Jul 2020 22:15:56 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jsXWt-000N6o-V5; Mon, 06 Jul 2020 22:15:55 +0200
Subject: Re: [PATCH bpf v2] restore behaviour of CAP_SYS_ADMIN allowing the
 loading of networking bpf programs
To:     John Stultz <john.stultz@linaro.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <zenczykowski@gmail.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
References: <CAADnVQ+BqPeVqbgojN+nhYTE0nDcGF2-TfaeqyfPLOF-+DLn5Q@mail.gmail.com>
 <20200620212616.93894-1-zenczykowski@gmail.com>
 <CALAqxLVeg=EE06Eh5yMBoXtb2KTHLKKnBLXwGu-yGV4aGgoVMA@mail.gmail.com>
 <CAADnVQJOpsQhT0oY5GZikf00MT1=pR3vpCZkn+Z4hp2_duUFSQ@mail.gmail.com>
 <CALAqxLVfxSj961C5muL5iAYjB5p_JTx7T6E7zQ7nsfQGC-exFA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <39345ec1-79a1-c329-4d2e-98904cdb11e1@iogearbox.net>
Date:   Mon, 6 Jul 2020 22:15:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CALAqxLVfxSj961C5muL5iAYjB5p_JTx7T6E7zQ7nsfQGC-exFA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25865/Mon Jul  6 16:07:44 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/6/20 10:11 PM, John Stultz wrote:
> On Tue, Jun 23, 2020 at 5:54 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>> On Mon, Jun 22, 2020 at 12:44 PM John Stultz <john.stultz@linaro.org> wrote:
>>> On Sat, Jun 20, 2020 at 2:26 PM Maciej Żenczykowski
>>> <zenczykowski@gmail.com> wrote:
>>>> From: Maciej Żenczykowski <maze@google.com>
>>>>
>>>> This is a fix for a regression introduced in 5.8-rc1 by:
>>>>    commit 2c78ee898d8f10ae6fb2fa23a3fbaec96b1b7366
>>>>    'bpf: Implement CAP_BPF'
>>>>
>>>> Before the above commit it was possible to load network bpf programs
>>>> with just the CAP_SYS_ADMIN privilege.
>>>>
>>>> The Android bpfloader happens to run in such a configuration (it has
>>>> SYS_ADMIN but not NET_ADMIN) and creates maps and loads bpf programs
>>>> for later use by Android's netd (which has NET_ADMIN but not SYS_ADMIN).
>>>>
>>>> Cc: Alexei Starovoitov <ast@kernel.org>
>>>> Cc: Daniel Borkmann <daniel@iogearbox.net>
>>>> Reported-by: John Stultz <john.stultz@linaro.org>
>>>> Fixes: 2c78ee898d8f ("bpf: Implement CAP_BPF")
>>>> Signed-off-by: Maciej Żenczykowski <maze@google.com>
>>>
>>> Thanks so much for helping narrow this regression down and submitting this fix!
>>> It's much appreciated!
>>>
>>> Tested-by: John Stultz <john.stultz@linaro.org>
>>
>> Applied to bpf tree. Thanks
> 
> Hey all,
>    Just wanted to follow up on this as I've not seen the regression fix
> land in 5.8-rc4 yet? Is it still pending, or did it fall through a
> gap?

No, it's in DaveM's -net tree currently, will go to Linus' tree on his next pull req:

   https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=b338cb921e6739ff59ce32f43342779fe5ffa732
