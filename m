Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3913CB154
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 06:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbhGPEOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 00:14:31 -0400
Received: from relay.sw.ru ([185.231.240.75]:46390 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhGPEOb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 00:14:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=4tMOph3Bxi9udxmJFQ6rB4I9o9MwgEFr9xoM3JkuMMM=; b=TclMo+FG6IiTHW3iI
        y5XkPGcOAnwG+6vGIm6EGYu9ih1eM9I0n9G/1OsVuux+y8i10E3hFVuscHyTdep+EYezfPiZ+AzUM
        7bsrhJgLX1ur3g64SlF6TGv2TMdJLGkf9fJcEkutEb9x90KQ5VOTUfrsbmErTen9awR2BAPACEzCc
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m4FC9-0049Gz-Gs; Fri, 16 Jul 2021 07:11:25 +0300
Subject: Re: [PATCH v4 00/16] memcg accounting from OpenVZ
To:     Shakeel Butt <shakeelb@google.com>, Tejun Heo <tj@kernel.org>
Cc:     Cgroups <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Roman Gushchin <guro@fb.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Jeff Layton <jlayton@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Jiri Slaby <jirislaby@kernel.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Serge Hallyn <serge@hallyn.com>, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zefan Li <lizefan.x@bytedance.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <8664122a-99d3-7199-869a-781b21b7e712@virtuozzo.com>
 <919bd022-075e-98a7-cefb-89b5dee80ae8@virtuozzo.com>
 <CALvZod5Kxrj3T99CEd8=OaoW8CwKtHOVhno58_nNOqjR2y=x6Q@mail.gmail.com>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <3a60b936-b618-6cef-532a-97bbdb957fb1@virtuozzo.com>
Date:   Fri, 16 Jul 2021 07:11:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALvZod5Kxrj3T99CEd8=OaoW8CwKtHOVhno58_nNOqjR2y=x6Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/15/21 8:11 PM, Shakeel Butt wrote:
> On Tue, Apr 27, 2021 at 11:51 PM Vasily Averin <vvs@virtuozzo.com> wrote:
>>
>> OpenVZ uses memory accounting 20+ years since v2.2.x linux kernels.
>> Initially we used our own accounting subsystem, then partially committed
>> it to upstream, and a few years ago switched to cgroups v1.
>> Now we're rebasing again, revising our old patches and trying to push
>> them upstream.
>>
>> We try to protect the host system from any misuse of kernel memory
>> allocation triggered by untrusted users inside the containers.
>>
>> Patch-set is addressed mostly to cgroups maintainers and cgroups@ mailing
>> list, though I would be very grateful for any comments from maintainersi
>> of affected subsystems or other people added in cc:
>>
>> Compared to the upstream, we additionally account the following kernel objects:
>> - network devices and its Tx/Rx queues
>> - ipv4/v6 addresses and routing-related objects
>> - inet_bind_bucket cache objects
>> - VLAN group arrays
>> - ipv6/sit: ip_tunnel_prl
>> - scm_fp_list objects used by SCM_RIGHTS messages of Unix sockets
>> - nsproxy and namespace objects itself
>> - IPC objects: semaphores, message queues and share memory segments
>> - mounts
>> - pollfd and select bits arrays
>> - signals and posix timers
>> - file lock
>> - fasync_struct used by the file lease code and driver's fasync queues
>> - tty objects
>> - per-mm LDT
>>
>> We have an incorrect/incomplete/obsoleted accounting for few other kernel
>> objects: sk_filter, af_packets, netlink and xt_counters for iptables.
>> They require rework and probably will be dropped at all.
>>
>> Also we're going to add an accounting for nft, however it is not ready yet.
>>
>> We have not tested performance on upstream, however, our performance team
>> compares our current RHEL7-based production kernel and reports that
>> they are at least not worse as the according original RHEL7 kernel.
> 
> Hi Vasily,
> 
> What's the status of this series? I see a couple patches did get
> acked/reviewed. Can you please re-send the series with updated ack
> tags?

Technically my patches does not have any NAKs. Practically they are still them merged.
I've expected Michal will push it, but he advised me to push subsystem maintainers.
I've asked Tejun to pick up the whole patch set and I'm waiting for his feedback right now.

I can resend patch set once again, with collected approval and with rebase to v5.14-rc1.
However I do not understand how it helps to push them if patches should be processed through
subsystem maintainers. As far as I understand I'll need to split this patch set into
per-subsystem pieces and sent them to corresponded maintainers.

Thank you,
	Vasily Averin.
