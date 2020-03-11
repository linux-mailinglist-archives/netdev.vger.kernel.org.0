Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAB2181945
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 14:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbgCKNKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 09:10:47 -0400
Received: from www62.your-server.de ([213.133.104.62]:49500 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729320AbgCKNKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 09:10:47 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jC18H-0001Dz-Cq; Wed, 11 Mar 2020 14:10:45 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jC18G-0009xv-J1; Wed, 11 Mar 2020 14:10:45 +0100
Subject: Re: [bpf PATCH] bpf: sockmap, remove bucket->lock from
 sock_{hash|map}_free
To:     John Fastabend <john.fastabend@gmail.com>, jakub@cloudflare.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <158385850787.30597.8346421465837046618.stgit@john-Precision-5820-Tower>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <337666f6-b6b3-4b01-a62e-783486bcb404@iogearbox.net>
Date:   Wed, 11 Mar 2020 14:10:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <158385850787.30597.8346421465837046618.stgit@john-Precision-5820-Tower>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25748/Wed Mar 11 12:08:41 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/20 5:41 PM, John Fastabend wrote:
> The bucket->lock is not needed in the sock_hash_free and sock_map_free
> calls, in fact it is causing a splat due to being inside rcu block.
> 
> 
> | BUG: sleeping function called from invalid context at net/core/sock.c:2935
> | in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 62, name: kworker/0:1
> | 3 locks held by kworker/0:1/62:
> |  #0: ffff88813b019748 ((wq_completion)events){+.+.}, at: process_one_work+0x1d7/0x5e0
> |  #1: ffffc900000abe50 ((work_completion)(&map->work)){+.+.}, at: process_one_work+0x1d7/0x5e0
> |  #2: ffff8881381f6df8 (&stab->lock){+...}, at: sock_map_free+0x26/0x180
> | CPU: 0 PID: 62 Comm: kworker/0:1 Not tainted 5.5.0-04008-g7b083332376e #454
> | Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
> | Workqueue: events bpf_map_free_deferred
> | Call Trace:
> |  dump_stack+0x71/0xa0
> |  ___might_sleep.cold+0xa6/0xb6
> |  lock_sock_nested+0x28/0x90
> |  sock_map_free+0x5f/0x180
> |  bpf_map_free_deferred+0x58/0x80
> |  process_one_work+0x260/0x5e0
> |  worker_thread+0x4d/0x3e0
> |  kthread+0x108/0x140
> |  ? process_one_work+0x5e0/0x5e0
> |  ? kthread_park+0x90/0x90
> |  ret_from_fork+0x3a/0x50
> 
> The reason we have stab->lock and bucket->locks in sockmap code is to
> handle checking EEXIST in update/delete cases. We need to be careful during
> an update operation that we check for EEXIST and we need to ensure that the
> psock object is not in some partial state of removal/insertion while we do
> this. So both map_update_common and sock_map_delete need to guard from being
> run together potentially deleting an entry we are checking, etc. But by the
> time we get to the tear-down code in sock_{ma[|hash}_free we have already
> disconnected the map and we just did synchronize_rcu() in the line above so
> no updates/deletes should be in flight. Because of this we can drop the
> bucket locks from the map free'ing code, noting no update/deletes can be
> in-flight.
> 
> Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
> Reported-by: Jakub Sitnicki <jakub@cloudflare.com>
> Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Applied, thanks!
