Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEFE20E957
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 01:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729352AbgF2X36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 19:29:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:42875 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726746AbgF2X35 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 19:29:57 -0400
IronPort-SDR: ChGv7A3YB36SMC06qp63EzxxJ6lnJrwBONr+kM9GyrJCTxeqYnNqRdaQ+GCP3Y46JiYL/kKmat
 Y44zPZx2R5ZA==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="144288591"
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="144288591"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 16:29:57 -0700
IronPort-SDR: VL7Gd3pQQAh+aXQYpQMG/TzJIj41pLmcQWxr/twceaL8WlC/yjLlPLfK1I2qLfcQrBkwf6EI3K
 GVE8toNLsSQQ==
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="454376782"
Received: from jlbliss-mobl.amr.corp.intel.com ([10.255.231.136])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 16:29:57 -0700
Date:   Mon, 29 Jun 2020 16:29:56 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@jlbliss-mobl.amr.corp.intel.com
To:     Davide Caratti <dcaratti@redhat.com>
cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org
Subject: Re: [PATCH net-next 2/6] mptcp: fallback in case of simultaneous
 connect
In-Reply-To: <e64ab0baf0f68bc4499201fe5ea7a33d92ee7c08.1593461586.git.dcaratti@redhat.com>
Message-ID: <alpine.OSX.2.23.453.2006291629360.11066@jlbliss-mobl.amr.corp.intel.com>
References: <cover.1593461586.git.dcaratti@redhat.com> <e64ab0baf0f68bc4499201fe5ea7a33d92ee7c08.1593461586.git.dcaratti@redhat.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jun 2020, Davide Caratti wrote:

> when a MPTCP client tries to connect to itself, tcp_finish_connect() is
> never reached. Because of this, depending on the socket current state,
> multiple faulty behaviours can be observed:
>
> 1) a WARN_ON() in subflow_data_ready() is hit
> WARNING: CPU: 2 PID: 882 at net/mptcp/subflow.c:911 subflow_data_ready+0x18b/0x230
> [...]
> CPU: 2 PID: 882 Comm: gh35 Not tainted 5.7.0+ #187
> [...]
> RIP: 0010:subflow_data_ready+0x18b/0x230
> [...]
> Call Trace:
>  tcp_data_queue+0xd2f/0x4250
>  tcp_rcv_state_process+0xb1c/0x49d3
>  tcp_v4_do_rcv+0x2bc/0x790
>  __release_sock+0x153/0x2d0
>  release_sock+0x4f/0x170
>  mptcp_shutdown+0x167/0x4e0
>  __sys_shutdown+0xe6/0x180
>  __x64_sys_shutdown+0x50/0x70
>  do_syscall_64+0x9a/0x370
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> 2) client is stuck forever in mptcp_sendmsg() because the socket is not
>   TCP_ESTABLISHED
>
> crash> bt 4847
> PID: 4847   TASK: ffff88814b2fb100  CPU: 1   COMMAND: "gh35"
>  #0 [ffff8881376ff680] __schedule at ffffffff97248da4
>  #1 [ffff8881376ff778] schedule at ffffffff9724a34f
>  #2 [ffff8881376ff7a0] schedule_timeout at ffffffff97252ba0
>  #3 [ffff8881376ff8a8] wait_woken at ffffffff958ab4ba
>  #4 [ffff8881376ff940] sk_stream_wait_connect at ffffffff96c2d859
>  #5 [ffff8881376ffa28] mptcp_sendmsg at ffffffff97207fca
>  #6 [ffff8881376ffbc0] sock_sendmsg at ffffffff96be1b5b
>  #7 [ffff8881376ffbe8] sock_write_iter at ffffffff96be1daa
>  #8 [ffff8881376ffce8] new_sync_write at ffffffff95e5cb52
>  #9 [ffff8881376ffe50] vfs_write at ffffffff95e6547f
> #10 [ffff8881376ffe90] ksys_write at ffffffff95e65d26
> #11 [ffff8881376fff28] do_syscall_64 at ffffffff956088ba
> #12 [ffff8881376fff50] entry_SYSCALL_64_after_hwframe at ffffffff9740008c
>     RIP: 00007f126f6956ed  RSP: 00007ffc2a320278  RFLAGS: 00000217
>     RAX: ffffffffffffffda  RBX: 0000000020000044  RCX: 00007f126f6956ed
>     RDX: 0000000000000004  RSI: 00000000004007b8  RDI: 0000000000000003
>     RBP: 00007ffc2a3202a0   R8: 0000000000400720   R9: 0000000000400720
>     R10: 0000000000400720  R11: 0000000000000217  R12: 00000000004004b0
>     R13: 00007ffc2a320380  R14: 0000000000000000  R15: 0000000000000000
>     ORIG_RAX: 0000000000000001  CS: 0033  SS: 002b
>
> 3) tcpdump captures show that DSS is exchanged even when MP_CAPABLE handshake
>   didn't complete.
>
> $ tcpdump -tnnr bad.pcap
> IP 127.0.0.1.20000 > 127.0.0.1.20000: Flags [S], seq 3208913911, win 65483, options [mss 65495,sackOK,TS val 3291706876 ecr 3291694721,nop,wscale 7,mptcp capable v1], length 0
> IP 127.0.0.1.20000 > 127.0.0.1.20000: Flags [S.], seq 3208913911, ack 3208913912, win 65483, options [mss 65495,sackOK,TS val 3291706876 ecr 3291706876,nop,wscale 7,mptcp capable v1], length 0
> IP 127.0.0.1.20000 > 127.0.0.1.20000: Flags [.], ack 1, win 512, options [nop,nop,TS val 3291706876 ecr 3291706876], length 0
> IP 127.0.0.1.20000 > 127.0.0.1.20000: Flags [F.], seq 1, ack 1, win 512, options [nop,nop,TS val 3291707876 ecr 3291706876,mptcp dss fin seq 0 subseq 0 len 1,nop,nop], length 0
> IP 127.0.0.1.20000 > 127.0.0.1.20000: Flags [.], ack 2, win 512, options [nop,nop,TS val 3291707876 ecr 3291707876], length 0
>
> force a fallback to TCP in these cases, and adjust the main socket
> state to avoid hanging in mptcp_sendmsg().
>
> Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/35
> Reported-by: Christoph Paasch <cpaasch@apple.com>
> Suggested-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
> net/mptcp/protocol.h | 10 ++++++++++
> net/mptcp/subflow.c  | 10 ++++++++++
> 2 files changed, 20 insertions(+)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
