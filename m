Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB4951A387
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 17:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352089AbiEDPUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 11:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352129AbiEDPT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 11:19:56 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971CC2228E
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 08:16:20 -0700 (PDT)
Received: from fsav117.sakura.ne.jp (fsav117.sakura.ne.jp [27.133.134.244])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 244FFmYv098182;
        Thu, 5 May 2022 00:15:48 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav117.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav117.sakura.ne.jp);
 Thu, 05 May 2022 00:15:48 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav117.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 244FFmOU098179
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 5 May 2022 00:15:48 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <5f3feecc-65ad-af5f-0ecd-94b2605ab67e@I-love.SAKURA.ne.jp>
Date:   Thu, 5 May 2022 00:15:46 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v2] net: rds: acquire refcount on TCP sockets
Content-Language: en-US
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To:     Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        linux-rdma <linux-rdma@vger.kernel.org>
References: <a5fb1fc4-2284-3359-f6a0-e4e390239d7b@I-love.SAKURA.ne.jp>
 <165157801106.17866.6764782659491020080.git-patchwork-notify@kernel.org>
 <CANn89iLHihonbBUQWkd0mjJPUuYBLMVoLCsRswtXmGjU3NKL5w@mail.gmail.com>
 <CANn89iJ=LF0KhRXDiFcky7mqpVaiHdbc6RDacAdzseS=iwjr4Q@mail.gmail.com>
 <f6f9f21d-7cdd-682f-f958-5951aa180ec7@I-love.SAKURA.ne.jp>
 <CANn89iJOt9oC_sSmVhRx8fyyvJ2hWzYKcTfH1Rvbzpt5aP0qNA@mail.gmail.com>
 <bf5ce176-35e6-0a75-1ada-6bed071a6a75@I-love.SAKURA.ne.jp>
In-Reply-To: <bf5ce176-35e6-0a75-1ada-6bed071a6a75@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/05/04 13:58, Tetsuo Handa wrote:
> On 2022/05/04 12:09, Eric Dumazet wrote:
>> This exit() handler _has_ to remove all known listeners, and
>> definitely cancel work queues (synchronous operation)
>> before the actual "struct net" free can happen later.
> 
> But in your report, rds_tcp_tune() is called from rds_tcp_conn_path_connect() from
> rds_connect_worker() via "struct rds_connection"->cp_conn_w work. I can see that
> rds_tcp_kill_sock() calls rds_tcp_listen_stop(lsock, &rtn->rds_tcp_accept_w), and
> rds_tcp_listen_stop() calls flush_workqueue(rds_wq) and flush_work(&rtn->rds_tcp_accept_w).
> 
> But I can't see how rds_tcp_exit_net() synchronously cancels all works associated
> with "struct rds_conn_path".
> 
> struct rds_conn_path {
>         struct delayed_work     cp_send_w;
>         struct delayed_work     cp_recv_w;
>         struct delayed_work     cp_conn_w;
>         struct work_struct      cp_down_w;
> }
> 
> These works are queued to rds_wq, but flush_workqueue() waits for completion only
> if already queued. What if timer for queue_delayed_work() has not expired, or was
> about to call queue_delayed_work() ? Is flush_workqueue(rds_wq) sufficient?


 rds_tcp_tune+0x5a0/0x5f0 net/rds/tcp.c:503
 rds_tcp_conn_path_connect+0x489/0x880 net/rds/tcp_connect.c:127
 rds_connect_worker+0x1a5/0x2c0 net/rds/threads.c:176
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289

rds_tcp_conn_path_connect is referenced by
"struct rds_transport rds_tcp_transport"->conn_path_connect.
It is invoked by

  ret = conn->c_trans->conn_path_connect(cp)

in rds_connect_worker().

rds_connect_worker is referenced by "struct rds_conn_path"->cp_conn_w
via INIT_DELAYED_WORK().

queue_delayed_work(rds_wq, &cp->cp_conn_w, *) is called by
rds_queue_reconnect() or rds_conn_path_connect_if_down().

If rds_conn_path_connect_if_down() were called from
rds_tcp_accept_one_path() from rds_tcp_accept_one(),
rds_tcp_tune() from rds_tcp_accept_one() was already called
before rds_tcp_tune() from rds_tcp_conn_path_connect() is called.
Since the addition on 0 was not reported at rds_tcp_tune() from
rds_tcp_accept_one(), what Eric is reporting cannot be from
rds_tcp_accept_one() from rds_tcp_accept_worker().

Despite rds_tcp_kill_sock() sets rtn->rds_tcp_listen_sock = NULL and
waits for rds_tcp_accept_one() from rds_tcp_accept_worker() to complete
using flush_workqueue(rds_wq), what Eric is reporting is different from
what syzbot+694120e1002c117747ed was reporting.

> 
> Anyway, if rds_tcp_kill_sock() can somehow guarantee that all works are completed
> or cancelled, the fix would look like something below?

I think it is OK to apply below diff in order to avoid addition on 0 problem, but
it is not proven that kmem_cache_free() is not yet called. What should we do?

> 
>  net/rds/tcp.c         | 11 ++++++++---
>  net/rds/tcp.h         |  2 +-
>  net/rds/tcp_connect.c |  5 ++++-
>  net/rds/tcp_listen.c  |  5 ++++-
>  4 files changed, 17 insertions(+), 6 deletions(-)
> 
