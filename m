Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 795F14A73F8
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 15:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345215AbiBBOzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 09:55:42 -0500
Received: from www62.your-server.de ([213.133.104.62]:47160 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345299AbiBBOzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 09:55:37 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nFH2i-0000p7-Hf; Wed, 02 Feb 2022 15:55:32 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nFH2i-000EP4-1r; Wed, 02 Feb 2022 15:55:32 +0100
Subject: Re: [syzbot] KASAN: vmalloc-out-of-bounds Write in ringbuf_map_alloc
To:     Marco Elver <elver@google.com>,
        syzbot <syzbot+5ad567a418794b9b5983@syzkaller.appspotmail.com>
Cc:     akpm@linux-foundation.org, andreyknvl@google.com,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        davem@davemloft.net, glider@google.com, hotforest@gmail.com,
        houtao1@huawei.com, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, sfr@canb.auug.org.au,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
References: <0000000000000a9b7d05d6ee565f@google.com>
 <0000000000004cc7f905d709f0f6@google.com>
 <CANpmjNPL-12uWHk+EDPdz=6rs2+n2zJWX1zMAbsfUm=dbZJ4qQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ee888b57-7d2f-d223-4d38-ff783ae9d263@iogearbox.net>
Date:   Wed, 2 Feb 2022 15:55:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CANpmjNPL-12uWHk+EDPdz=6rs2+n2zJWX1zMAbsfUm=dbZJ4qQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26441/Wed Feb  2 10:43:13 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/22 3:49 PM, Marco Elver wrote:
> On Wed, 2 Feb 2022 at 15:36, syzbot
> <syzbot+5ad567a418794b9b5983@syzkaller.appspotmail.com> wrote:
>>
>> syzbot has bisected this issue to:
>>
>> commit c34cdf846c1298de1c0f7fbe04820fe96c45068c
>> Author: Andrey Konovalov <andreyknvl@google.com>
>> Date:   Wed Feb 2 01:04:27 2022 +0000
>>
>>      kasan, vmalloc: unpoison VM_ALLOC pages after mapping
> 
> Is this a case of a new bug surfacing due to KASAN improvements? But
> it's not quite clear to me why this commit.
> 
> Andrey, any thoughts?

Marco / Andrey, fix should be this one:

https://patchwork.kernel.org/project/netdevbpf/patch/20220202060158.6260-1-houtao1@huawei.com/

>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=128cb900700000
>> start commit:   6abab1b81b65 Add linux-next specific files for 20220202
>> git tree:       linux-next
>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=118cb900700000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=168cb900700000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=b8d8750556896349
>> dashboard link: https://syzkaller.appspot.com/bug?extid=5ad567a418794b9b5983
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1450d9f0700000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=130ef35bb00000
>>
>> Reported-by: syzbot+5ad567a418794b9b5983@syzkaller.appspotmail.com
>> Fixes: c34cdf846c12 ("kasan, vmalloc: unpoison VM_ALLOC pages after mapping")
>>
>> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

