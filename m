Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA3EE163684
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 23:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgBRWyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 17:54:39 -0500
Received: from www62.your-server.de ([213.133.104.62]:55200 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbgBRWyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 17:54:39 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j4BlC-00070m-Ty; Tue, 18 Feb 2020 23:54:34 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j4BlC-000Vnk-MV; Tue, 18 Feb 2020 23:54:34 +0100
Subject: Re: [PATCH bpf] libbpf: Sanitise internal map names so they are not
 rejected by the kernel
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Yonghong Song <yhs@fb.com>, ast@fb.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20200217171701.215215-1-toke@redhat.com>
 <9ddddbd6-aca2-61ae-b864-0f12d7fd33b4@iogearbox.net>
 <a0923745-ee34-3eb0-7f9b-31cec99661ec@fb.com> <87sgj7yhif.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e7a1f042-a3d7-ad25-e195-fdd5f8b78680@iogearbox.net>
Date:   Tue, 18 Feb 2020 23:54:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87sgj7yhif.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.1/25727/Tue Feb 18 15:05:00 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/18/20 5:42 PM, Toke Høiland-Jørgensen wrote:
> Yonghong Song <yhs@fb.com> writes:
>> On 2/18/20 6:40 AM, Daniel Borkmann wrote:
>>> On 2/17/20 6:17 PM, Toke Høiland-Jørgensen wrote:
>>>> The kernel only accepts map names with alphanumeric characters,
>>>> underscores
>>>> and periods in their name. However, the auto-generated internal map names
>>>> used by libbpf takes their prefix from the user-supplied BPF object name,
>>>> which has no such restriction. This can lead to "Invalid argument" errors
>>>> when trying to load a BPF program using global variables.
>>>>
>>>> Fix this by sanitising the map names, replacing any non-allowed
>>>> characters
>>>> with underscores.
>>>>
>>>> Fixes: d859900c4c56 ("bpf, libbpf: support global data/bss/rodata
>>>> sections")
>>>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>>
>>> Makes sense to me, applied, thanks! I presume you had something like '-'
>>> in the
>>> global var leading to rejection?
>>
>> The C global variable cannot have '-'. I saw a complain in bcc mailing
>> list sometimes back like: if an object file is a-b.o, then we will
>> generate a map name like a-b.bss for the bss ELF section data. The
>> map name "a-b.bss" name will be rejected by the kernel. The workaround
>> is to change object file name. Not sure whether this is the only
>> issue which may introduce non [a-zA-Z0-9_] or not. But this patch indeed
>> should fix the issue I just described.

Yep, meant object file name, just realized too late after sending. :/

> Yes, this was exactly my problem; my object file is called
> 'xdp-dispatcher.o'. Fun error to track down :P
> 
> Why doesn't the kernel allow dashes in the name anyway?

Commit cb4d2b3f03d8 ("bpf: Add name, load_time, uid and map_ids to bpf_prog_info")
doesn't state a specific reason, and we did later extend it via 3e0ddc4f3ff1 ("bpf:
allow . char as part of the object name"). My best guess right now is potentially
not to confuse BPF's kallsyms handling with dashes etc.
