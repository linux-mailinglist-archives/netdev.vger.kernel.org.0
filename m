Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 678DA1BFD6
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 01:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbfEMXdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 19:33:55 -0400
Received: from www62.your-server.de ([213.133.104.62]:60172 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbfEMXdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 19:33:55 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hQKS3-0002iv-W3; Tue, 14 May 2019 01:33:48 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hQKS3-0004So-PK; Tue, 14 May 2019 01:33:47 +0200
Subject: Re: [PATCH net] bpf: devmap: fix use-after-free Read in
 __dev_map_entry_free
To:     Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        syzbot+457d3e2ffbcf31aee5c0@syzkaller.appspotmail.com,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
References: <20190513165916.259013-1-edumazet@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <16b48eca-0898-71f3-cfd1-c7e54da1a5dc@iogearbox.net>
Date:   Tue, 14 May 2019 01:33:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190513165916.259013-1-edumazet@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25448/Mon May 13 09:57:34 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/13/2019 06:59 PM, Eric Dumazet wrote:
> synchronize_rcu() is fine when the rcu callbacks only need
> to free memory (kfree_rcu() or direct kfree() call rcu call backs)
> 
> __dev_map_entry_free() is a bit more complex, so we need to make
> sure that call queued __dev_map_entry_free() callbacks have completed.
> 
> sysbot report:
> 
> BUG: KASAN: use-after-free in dev_map_flush_old kernel/bpf/devmap.c:365
> [inline]
> BUG: KASAN: use-after-free in __dev_map_entry_free+0x2a8/0x300
> kernel/bpf/devmap.c:379
> Read of size 8 at addr ffff8801b8da38c8 by task ksoftirqd/1/18
> 
[...]
> 
> Fixes: 546ac1ffb70d ("bpf: add devmap, a map for storing net device references")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot+457d3e2ffbcf31aee5c0@syzkaller.appspotmail.com
> Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

Applied, thanks!
