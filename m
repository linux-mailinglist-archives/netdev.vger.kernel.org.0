Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1B65378EF
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234200AbiE3KId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 06:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbiE3KIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 06:08:30 -0400
Received: from mail-4323.proton.ch (mail-4323.proton.ch [185.70.43.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA5F7A80B
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 03:08:29 -0700 (PDT)
Date:   Mon, 30 May 2022 10:08:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.ch;
        s=protonmail2; t=1653905306; x=1654164506;
        bh=GH/to77fqKdxrJgyMcrSrCi+sI0uVLKarG9jq+i7Zag=;
        h=Date:To:From:Reply-To:Subject:Message-ID:Feedback-ID:From:To:Cc:
         Date:Subject:Reply-To:Feedback-ID:Message-ID;
        b=YSoeaP2wvDnOUT5N7fCjuj/IEy4bMuNtxFQWxJNhe41VU8TSFIaok1shjjAGt+Ayi
         CfoPs84em0HeTZF91jkpBv9pnmWx+RUb+qLwlQDPwPRm0dq7mFo7Yp961s/VgmnY3q
         cY5vyujPKHxquRTf4iJit/GY5kn1gOyBcjBwayNCxcTNAzKcNCW1r/1yJ86QM6Q4Tm
         JGZpcN91+FXdMmCVmkRyFJC3EsOJYEZukfWH3/ZoXS6FA0AtMYHjMej7vDuip3m/bd
         Dc+CiW6h9yPSkNYlvC9FKSE9lzIjpKlz/eZcYmZuUDiKcklQ7dPWg0dMYiwuHFr0i5
         pJTei4KgrtfHw==
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Laurent Fasnacht <laurent.fasnacht@proton.ch>
Reply-To: Laurent Fasnacht <laurent.fasnacht@proton.ch>
Subject: Bug in tcp_rtx_synack?
Message-ID: <99ZT3wzzJiMfHBn9Ul-NdFqpZAo3QoZbOGfgFx-X60_EOIzwtUNC6991CzKn0CSNukTVz1ib9TrLSgTlhePSDVK70nTaQlx5oTxXHYbsSyg=@proton.ch>
Feedback-ID: 37000963:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I'm having the following bug on a 5.16 kernel, it happens periodically (a f=
ew times per day, on every of our production server that has this kernel). =
I'm unable to reproduce on machines with lower load and I also know for sur=
e that it doesn't happen on the 5.10 kernel.

I wonder if it's related to trace_tcp_retransmit_synack?

I'm happy to help, let me know.

Cheers,
Laurent

---

(gdb) l *(tcp_rtx_synack+0x8d)
0xffffffff817ee76d is in tcp_rtx_synack (arch/x86/include/asm/preempt.h:95)=
.
90       * a decrement which hits zero means we have no preempt_count and s=
hould
91       * reschedule.
92       */
93      static __always_inline bool __preempt_count_dec_and_test(void)
94      {
95              return GEN_UNARY_RMWcc("decl", __preempt_count, e, __percpu=
_arg([var]));
96      }
97
98      /*
99       * Returns true when we need to resched and can (barring IRQ state)=
.
(gdb) l *(tcp_rtx_synack+0x8d-4)
0xffffffff817ee769 is in tcp_rtx_synack (include/trace/events/tcp.h:190).
185             TP_PROTO(struct sock *sk),
186
187             TP_ARGS(sk)
188     );
189
190     TRACE_EVENT(tcp_retransmit_synack,
191
192             TP_PROTO(const struct sock *sk, const struct request_sock *=
req),
193
194             TP_ARGS(sk, req),

--

BUG: using __this_cpu_add() in preemptible [00000000] code: epollpep/2180
caller is tcp_rtx_synack.part.0+0x36/0xc0
CPU: 10 PID: 2180 Comm: epollpep Tainted: G           OE     5.16.0-0.bpo.4=
-amd64 #1  Debian 5.16.12-1~bpo11+1
Hardware name: Supermicro SYS-5039MC-H8TRF/X11SCD-F, BIOS 1.7 11/23/2021
Call Trace:
 <TASK>
 dump_stack_lvl+0x48/0x5e
 check_preemption_disabled+0xde/0xe0
 tcp_rtx_synack.part.0+0x36/0xc0
 tcp_rtx_synack+0x8d/0xa0
 ? kmem_cache_alloc+0x2e0/0x3e0
 ? apparmor_file_alloc_security+0x3b/0x1f0
 inet_rtx_syn_ack+0x16/0x30
 tcp_check_req+0x367/0x610
 tcp_rcv_state_process+0x91/0xf60
 ? get_nohz_timer_target+0x18/0x1a0
 ? lock_timer_base+0x61/0x80
 ? preempt_count_add+0x68/0xa0
 tcp_v4_do_rcv+0xbd/0x270
 __release_sock+0x6d/0xb0
 release_sock+0x2b/0x90
 sock_setsockopt+0x138/0x1140
 ? __sys_getsockname+0x7e/0xc0
 ? aa_sk_perm+0x3e/0x1a0
 __sys_setsockopt+0x198/0x1e0
 __x64_sys_setsockopt+0x21/0x30
 do_syscall_64+0x38/0xc0
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fefe7d4441a
Code: ff ff ff c3 0f 1f 40 00 48 8b 15 71 ea 0b 00 f7 d8 64 89 02 48 c7 c0 =
ff ff ff ff eb b7 0f 1f 00 49 89 ca b8 36 00 00 00 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 8b 0d 46 ea 0b 00 f7 d8 64 89 01 48
RSP: 002b:00007ffca1cd0ab8 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fefe7d4441a
RDX: 0000000000000009 RSI: 0000000000000001 RDI: 00000000000006f3
RBP: 00007ffca1cd1410 R08: 0000000000000004 R09: 0000560e9f8a55ec
R10: 00007ffca1cd10f0 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffca1cd1190 R14: 00007ffca1cd1198 R15: 00007ffca1cd23f0
 </TASK>

