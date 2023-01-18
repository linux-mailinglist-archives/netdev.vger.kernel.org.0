Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F96A672477
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 18:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjARRHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 12:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbjARRHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 12:07:32 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C158354B2C
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 09:07:31 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id d62so22744786ybh.8
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 09:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tqn8ngv8vJVJFZE9Yxyd0ZMMeO96zAsJWEttYJc4eVE=;
        b=HrO1p9cvKEmHEC99PGRKa8Qb20OIIyu3BTt35fPKnFQ4fcduytL1SBauT0Jz36v9Uu
         szZublYnUcPs0zv+X52SnFR6L/sHtmguyKfBm9CHr2PaG1+gPY/MjPBRjB7pjZPUDehM
         8IYvmS540pMBLDdvfviNvwlySpFW0mtWe2LndOsiMwM64wdA7HufKw3K78hNBaTenQ38
         H9vf/NXkjTAO1js7+F8ZicNY8FkBjIajQlME32i9qHFmL0E8hGi4LHRWyR8Sr95WQiMO
         9EaRjbURepXqzjWfTmY1peGtpQUg4aYGsqbUlpsNwB9AuHA7eXdjvSmoNAuGrEVgbU3A
         Qizw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tqn8ngv8vJVJFZE9Yxyd0ZMMeO96zAsJWEttYJc4eVE=;
        b=UrbsRAClMZ060HkegVEgsbo+xIj20jiG8D6b/KQBBkT40kPYNTMcWqafLTYIUOzrfR
         J/mEGhLdbsOqk3UBCkJ1yElav1GGbq1K5SMzgGcUcNnKZO0bZ7/Ns5z8Ejh75oBQIkYK
         nUvZpi9LQmZTiHqGS/t0tl8O1hMpo8EtIq03h1kVGS0cRkCqEDsTMgP38atU90KTSaGL
         kAm20ig1Eq4dHmHfAeIbHYl4K7bqZBZVGoCnswBceB3pd8fKGUbl+BBaiqfFBfYGtMVG
         DWk3OQLnSyjirLdCe7aUTYkUBT2L9WWBkVx7OPAFY6GFtBqsvRWcrNpA7sPXRT1xn3Uy
         6OsQ==
X-Gm-Message-State: AFqh2koeb5N8z0OjcQukQ7v6Z7DIY2bB3K0Af/WzPcc36/aXt/tIfMDu
        g6kdwHXXiNh5CsI0jxH05zbP36MEhfyMWca/mD1VUA==
X-Google-Smtp-Source: AMrXdXv0O4jghRTbvyqPg0XjPNrcbV3K4PvKtwcXdmcZ2nJBAKpcBeR6O2o51PQ8nzgB0Wq+5qNgogwtrJEIKOBe1RY=
X-Received: by 2002:a25:bf8e:0:b0:7d7:ec44:7cdc with SMTP id
 l14-20020a25bf8e000000b007d7ec447cdcmr902243ybk.598.1674061650706; Wed, 18
 Jan 2023 09:07:30 -0800 (PST)
MIME-Version: 1.0
References: <2d2ad1e5-8b03-0c59-4cf1-6a5cc85bbd94@cloudflare.com>
In-Reply-To: <2d2ad1e5-8b03-0c59-4cf1-6a5cc85bbd94@cloudflare.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 18 Jan 2023 18:07:19 +0100
Message-ID: <CANn89iJvOPH9rJ4YjRP-i99beY3g+moLnRQH2ED-CQX7QnDYpA@mail.gmail.com>
Subject: Re: BUG: using __this_cpu_add() in preemptible in tcp_make_synack()
To:     Frederick Lawler <fred@cloudflare.com>
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 5:56 PM Frederick Lawler <fred@cloudflare.com> wrote:
>
> Hello,
>
> We've been testing Linux 6.1.4, and came across an intermittent "BUG:
> using __this_cpu_add() in preemptible" [1] in our services leveraging
> TCP_FASTOPEN and our kernel configured with:
>
> CONFIG_PREEMPT_BUILD=y
> CONFIG_PREEMPT_VOLUNTARY=y
> CONFIG_PREEMPT_COUNT=y
> CONFIG_PREEMPTION=y
> CONFIG_PREEMPT_DYNAMIC=y
> CONFIG_PREEMPT_RCU=y
> CONFIG_HAVE_PREEMPT_DYNAMIC=y
> CONFIG_HAVE_PREEMPT_DYNAMIC_CALL=y
> CONFIG_PREEMPT_NOTIFIERS=y
> CONFIG_DEBUG_PREEMPT=y
>
> I'm not sure how related this is to commit 0a375c822497 ("tcp:
> tcp_rtx_synack() can be called from process context
> "), as I haven't found a reliable reproducer yet.
>
> The stack trace below has audit_*(), but we have other traces with
> do_tcp_setsockopt() mixed in the backtrace. Once we get to
> tcp_rx_synack() in the __release_sock() path, we get the same problem.
>
> [1]:
> BUG: using __this_cpu_add() in preemptible [00000000] code: nginx-ssl/209282
> caller is tcp_make_synack+0x38d/0x5a0
> CPU: 3 PID: 209282 Comm: nginx-ssl Kdump: loaded Tainted: G           O
>       6.1.4-cloudflare-2023.1.2 #1
> Hardware name: Quanta Cloud Technology Inc. QuantaPlex T42S-2U/T42S-2U
> MB (Lewisburg-1G) CLX, BIOS 3B16.Q102 02/19/2020
> Call Trace:
> <TASK>
>   dump_stack_lvl+0x34/0x48
>   check_preemption_disabled+0xdd/0xe0
>   tcp_make_synack+0x38d/0x5a0
>   tcp_v4_send_synack+0x50/0x1f0
>   tcp_rtx_synack+0x55/0x140
>   ? load_balance+0xa91/0xd40
>   ? _copy_to_iter+0x1d6/0x560
>   inet_rtx_syn_ack+0x16/0x30
>   tcp_check_req+0x39f/0x660
>   tcp_rcv_state_process+0xa3/0x1020
>   ? tcp_mstamp_refresh+0xe/0x40
>   ? tcp_update_recv_tstamps+0x61/0x90
>   ? tcp_recvmsg_locked+0x1eb/0x960
>   tcp_v4_do_rcv+0xc6/0x280
>   __release_sock+0xb4/0xc0
>   release_sock+0x2b/0x90
>   tcp_recvmsg+0x7c/0x200
>   inet_recvmsg+0x52/0x130
>   __sys_recvfrom+0xa8/0x120
>   ? audit_filter_inodes.part.0+0x2e/0x110
>   ? auditd_test_task+0x3c/0x50
>   ? __audit_syscall_entry+0xd5/0x120
>   __x64_sys_recvfrom+0x20/0x30
>   do_syscall_64+0x38/0x90
>   entry_SYSCALL_64_after_hwframe+0x4b/0xb5
> RIP: 0033:0x7fafc19adc74
> Code: 89 4c 24 1c e8 2d 41 f8 ff 44 8b 54 24 1c 8b 3c 24 45 31 c9 89 c5
> 48 8b 54 24 10 48 8b 74 24 08 45 31 c0 b8 2d 00 00 00 0f 05 <48> 3d 00
> f0 ff ff 77 34 89 ef 48 89 04 24 e8 59 41 f8 ff 48 8b 04
> RSP: 002b:00007ffc42e18a20 EFLAGS: 00000246 ORIG_RAX: 000000000000002d
> RAX: ffffffffffffffda RBX: 00007faf26457870 RCX: 00007fafc19adc74
> RDX: 0000000000000001 RSI: 00007ffc42e18a60 RDI: 000000000000076a
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000002 R11: 0000000000000246 R12: 00007faf2261fd40
> R13: 00007faf26457870 R14: 00007faf1fe962c0 R15: 00007ffc42e18a60
> </TASK>
>
> Thanks,
> Fred

Thanks for the report

I guess this part has been missed in commit 0a375c822497ed6a

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 71d01cf3c13eb4bd3d314ef140568d2ffd6a499e..ba839e441450f195012a8d77cb9e5ed956962d2f
100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3605,7 +3605,7 @@ struct sk_buff *tcp_make_synack(const struct
sock *sk, struct dst_entry *dst,
        th->window = htons(min(req->rsk_rcv_wnd, 65535U));
        tcp_options_write(th, NULL, &opts);
        th->doff = (tcp_header_size >> 2);
-       __TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
+       TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);

 #ifdef CONFIG_TCP_MD5SIG
        /* Okay, we have all we need - do the md5 hash if needed */
