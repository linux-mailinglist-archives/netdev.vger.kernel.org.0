Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B306588B1F
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 13:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbiHCL1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 07:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiHCL1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 07:27:13 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD53B275CF;
        Wed,  3 Aug 2022 04:27:11 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0VLGi36p_1659526024;
Received: from 30.227.65.209(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VLGi36p_1659526024)
          by smtp.aliyun-inc.com;
          Wed, 03 Aug 2022 19:27:06 +0800
Message-ID: <ecf07c1b-a6f3-2537-aacd-a768c437fa7f@linux.alibaba.com>
Date:   Wed, 3 Aug 2022 19:27:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v3] net/smc: fix refcount bug in sk_psock_get (2)
To:     Hawkins Jiawei <yin31149@gmail.com>,
        syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com
Cc:     andrii@kernel.org, ast@kernel.org, borisp@nvidia.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        edumazet@google.com, john.fastabend@gmail.com, kafai@fb.com,
        kgraul@linux.ibm.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com, 18801353760@163.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        jakub@cloudflare.com, paskripkin@gmail.com,
        skhan@linuxfoundation.org
References: <00000000000026328205e08cdbeb@google.com>
 <20220803080338.166730-1-yin31149@gmail.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <20220803080338.166730-1-yin31149@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/8/3 16:03, Hawkins Jiawei wrote:
> Syzkaller reports refcount bug as follows:
> ------------[ cut here ]------------
> refcount_t: saturated; leaking memory.
> WARNING: CPU: 1 PID: 3605 at lib/refcount.c:19 refcount_warn_saturate+0xf4/0x1e0 lib/refcount.c:19
> Modules linked in:
> CPU: 1 PID: 3605 Comm: syz-executor208 Not tainted 5.18.0-syzkaller-03023-g7e062cda7d90 #0
>   <TASK>
>   __refcount_add_not_zero include/linux/refcount.h:163 [inline]
>   __refcount_inc_not_zero include/linux/refcount.h:227 [inline]
>   refcount_inc_not_zero include/linux/refcount.h:245 [inline]
>   sk_psock_get+0x3bc/0x410 include/linux/skmsg.h:439
>   tls_data_ready+0x6d/0x1b0 net/tls/tls_sw.c:2091
>   tcp_data_ready+0x106/0x520 net/ipv4/tcp_input.c:4983
>   tcp_data_queue+0x25f2/0x4c90 net/ipv4/tcp_input.c:5057
>   tcp_rcv_state_process+0x1774/0x4e80 net/ipv4/tcp_input.c:6659
>   tcp_v4_do_rcv+0x339/0x980 net/ipv4/tcp_ipv4.c:1682
>   sk_backlog_rcv include/net/sock.h:1061 [inline]
>   __release_sock+0x134/0x3b0 net/core/sock.c:2849
>   release_sock+0x54/0x1b0 net/core/sock.c:3404
>   inet_shutdown+0x1e0/0x430 net/ipv4/af_inet.c:909
>   __sys_shutdown_sock net/socket.c:2331 [inline]
>   __sys_shutdown_sock net/socket.c:2325 [inline]
>   __sys_shutdown+0xf1/0x1b0 net/socket.c:2343
>   __do_sys_shutdown net/socket.c:2351 [inline]
>   __se_sys_shutdown net/socket.c:2349 [inline]
>   __x64_sys_shutdown+0x50/0x70 net/socket.c:2349
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x46/0xb0
>   </TASK>
> 
> During SMC fallback process in connect syscall, kernel will
> replaces TCP with SMC. In order to forward wakeup
> smc socket waitqueue after fallback, kernel will sets
> clcsk->sk_user_data to origin smc socket in
> smc_fback_replace_callbacks().
> 
> Later, in shutdown syscall, kernel will calls
> sk_psock_get(), which treats the clcsk->sk_user_data
> as psock type, triggering the refcnt warning.
> 
> So, the root cause is that smc and psock, both will use
> sk_user_data field. So they will mismatch this field
> easily.
> 
> This patch solves it by using another bit(defined as
> SK_USER_DATA_PSOCK) in PTRMASK, to mark whether
> sk_user_data points to a psock object or not.
> This patch depends on a PTRMASK introduced in commit f1ff5ce2cd5e
> ("net, sk_msg: Clear sk_user_data pointer on clone if tagged").
> 
> Reported-and-tested-by: syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Acked-by: Wen Gu <guwen@linux.alibaba.com>
> Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
> ---
> v2 -> v3:
>    - use SK_USER_DATA_PSOCK instead of SK_USER_DATA_NOTPSOCK
> to patch the bug
>    - refactor the code on assigning to sk_user_data field
> in psock part
>    - refactor the code on getting and setting the flag
> with sk_user_data field
> 
> v1 -> v2:
>    - add bit in PTRMASK to patch the bug
> 
>   include/linux/skmsg.h |  2 +-
>   include/net/sock.h    | 58 +++++++++++++++++++++++++++++++------------
>   net/core/skmsg.c      |  3 ++-
>   3 files changed, 45 insertions(+), 18 deletions(-)
> 

Hi Hawkins,

Since the fix v3 doesn't involved smc codes any more, I wonder if it's still
appropriate to use 'net/smc:' in subject?

Cheers,
Wen Gu
