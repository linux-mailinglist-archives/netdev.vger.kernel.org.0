Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C00D2A050
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 23:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404245AbfEXVUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 17:20:04 -0400
Received: from www62.your-server.de ([213.133.104.62]:49784 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391745AbfEXVUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 17:20:04 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hUHbf-0008TR-1g; Fri, 24 May 2019 23:20:03 +0200
Received: from [178.197.249.12] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hUHbe-000KbC-SO; Fri, 24 May 2019 23:20:02 +0200
Subject: Re: [PATCH v2] bpf: sockmap, fix use after free from sleep in psock
 backlog workqueue
To:     John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        jakub@cloudflare.com, ast@kernel.org
Cc:     netdev@vger.kernel.org
References: <155871006055.18695.17031102947214023468.stgit@john-Precision-5820-Tower>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c41030d0-fa97-a82f-a63c-ebabc1f3d59f@iogearbox.net>
Date:   Fri, 24 May 2019 23:20:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <155871006055.18695.17031102947214023468.stgit@john-Precision-5820-Tower>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25459/Fri May 24 09:59:21 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/24/2019 05:01 PM, John Fastabend wrote:
> Backlog work for psock (sk_psock_backlog) might sleep while waiting
> for memory to free up when sending packets. However, while sleeping
> the socket may be closed and removed from the map by the user space
> side.
> 
> This breaks an assumption in sk_stream_wait_memory, which expects the
> wait queue to be still there when it wakes up resulting in a
> use-after-free shown below. To fix his mark sendmsg as MSG_DONTWAIT
> to avoid the sleep altogether. We already set the flag for the
> sendpage case but we missed the case were sendmsg is used.
> Sockmap is currently the only user of skb_send_sock_locked() so only
> the sockmap paths should be impacted.
> 
> ==================================================================
> BUG: KASAN: use-after-free in remove_wait_queue+0x31/0x70
> Write of size 8 at addr ffff888069a0c4e8 by task kworker/0:2/110
> 
> CPU: 0 PID: 110 Comm: kworker/0:2 Not tainted 5.0.0-rc2-00335-g28f9d1a3d4fe-dirty #14
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-2.fc27 04/01/2014
> Workqueue: events sk_psock_backlog
> Call Trace:
>  print_address_description+0x6e/0x2b0
>  ? remove_wait_queue+0x31/0x70
>  kasan_report+0xfd/0x177
>  ? remove_wait_queue+0x31/0x70
>  ? remove_wait_queue+0x31/0x70
>  remove_wait_queue+0x31/0x70
>  sk_stream_wait_memory+0x4dd/0x5f0
>  ? sk_stream_wait_close+0x1b0/0x1b0
>  ? wait_woken+0xc0/0xc0
>  ? tcp_current_mss+0xc5/0x110
>  tcp_sendmsg_locked+0x634/0x15d0
>  ? tcp_set_state+0x2e0/0x2e0
>  ? __kasan_slab_free+0x1d1/0x230
>  ? kmem_cache_free+0x70/0x140
>  ? sk_psock_backlog+0x40c/0x4b0
>  ? process_one_work+0x40b/0x660
>  ? worker_thread+0x82/0x680
>  ? kthread+0x1b9/0x1e0
>  ? ret_from_fork+0x1f/0x30
>  ? check_preempt_curr+0xaf/0x130
>  ? iov_iter_kvec+0x5f/0x70
[...]

Applied, thanks!
