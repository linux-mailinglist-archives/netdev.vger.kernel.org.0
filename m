Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6891753889C
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 23:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238694AbiE3VhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 17:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234936AbiE3VhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 17:37:20 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D396EC79
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 14:37:18 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id c2so11244272plh.2
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 14:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oToy6kmJnhx8mRreN/ZinyzzZwnGFWlfUKlgbjPTM4I=;
        b=cRgqZqcj1DZC7cIqldAWxyrSJA8Yc2CTf5PIM5xAVpNdeHMIRaqUhkLaJU5GWeWcy7
         8429ByuhPB1KbdbM7tEdd8RywnxOXyOlTrEK0kvNSiexzRlc+8hwLJqtSYWjA6jlrTQR
         paHcc7wREL3pA6mfMIwCVl29Eyoom2aCX2bA7xlmdt91U/nvdp1gW0WSHjx3QeskvG70
         npqUOkSMJg+pIoq5cIQy9N5Cq8GmWojnhGSDvj1qc/PHzVL2oavej6odkwDfzIH0FI1N
         zFVTPgHNaEed3uP5WYtEA/ZebkJ9uuEevmAB+td/hQzNTcy9xaREn68DaqQopRdSTFQw
         /rig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oToy6kmJnhx8mRreN/ZinyzzZwnGFWlfUKlgbjPTM4I=;
        b=UzGUkQdkvLd0BD9BZDfSbNulJlAr5HMhFKK/scN9g1Zcrz7JeCevfRObymTCGC00SS
         nD6BPkA1wh9wK2a7f0ml3eYTVt1r5KO5BEifFCWtZ0AMfT/fdsc4yZk51qK7JBOQ0IUI
         aTIXHLkkwalSfhT/dd/vWJ/QgttMb9B0J+X0YRYaECHm8Vtng4c/35GN/w3P80cX1Rmt
         YtMLvbTZyOQEtabrsw76Nb5GqJfBjDH65+Cjr4cNdkFsPqobzhjCILzFW9ry/BIGWJBU
         jXv3jIn9AmwHtD1fjIA4jMNYQttClVTh3tEXUSqTZJQ/8tdVBWiFSwj5ZH1lzrjSlMRD
         0+Ow==
X-Gm-Message-State: AOAM53208d7X1mWWs8BQ9S56zunpcgE1PoyDfMmdaHXEYpvXN1pYqnOR
        Cs5FAPVaM9vtY8bvjgworzg=
X-Google-Smtp-Source: ABdhPJx/riDqDg9/Uk9ViZtx6Y3C/Vqy2YDGaWLGwXaspqVwzabkcI+1LC0khrAcjzqtUfa3Nx5t7A==
X-Received: by 2002:a17:903:240a:b0:14e:dad4:5ce4 with SMTP id e10-20020a170903240a00b0014edad45ce4mr59747559plo.125.1653946637477;
        Mon, 30 May 2022 14:37:17 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:bfb5:416f:fa7c:79c9])
        by smtp.gmail.com with ESMTPSA id z7-20020a170903018700b0016188a4005asm9718211plg.122.2022.05.30.14.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 14:37:16 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Laurent Fasnacht <laurent.fasnacht@proton.ch>
Subject: [PATCH net] tcp: tcp_rtx_synack() can be called from process context
Date:   Mon, 30 May 2022 14:37:13 -0700
Message-Id: <20220530213713.601888-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Laurent reported the enclosed report [1]

This bug triggers with following coditions:

0) Kernel built with CONFIG_DEBUG_PREEMPT=y

1) A new passive FastOpen TCP socket is created.
   This FO socket waits for an ACK coming from client to be a complete
   ESTABLISHED one.
2) A socket operation on this socket goes through lock_sock()
   release_sock() dance.
3) While the socket is owned by the user in step 2),
   a retransmit of the SYN is received and stored in socket backlog.
4) At release_sock() time, the socket backlog is processed while
   in process context.
5) A SYNACK packet is cooked in response of the SYN retransmit.
6) -> tcp_rtx_synack() is called in process context.

Before blamed commit, tcp_rtx_synack() was always called from BH handler,
from a timer handler.

Fix this by using TCP_INC_STATS() & NET_INC_STATS()
which do not assume caller is in non preemptible context.

[1]
BUG: using __this_cpu_add() in preemptible [00000000] code: epollpep/2180
caller is tcp_rtx_synack.part.0+0x36/0xc0
CPU: 10 PID: 2180 Comm: epollpep Tainted: G           OE     5.16.0-0.bpo.4-amd64 #1  Debian 5.16.12-1~bpo11+1
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

Fixes: 168a8f58059a ("tcp: TCP Fast Open Server - main code path")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Laurent Fasnacht <laurent.fasnacht@proton.ch>
---
 net/ipv4/tcp_output.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index b4b2284ed4a2c9e2569bd945e3b4e023c5502f25..1c054431e358328fe3849f5a45aaa88308a1e1c8 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -4115,8 +4115,8 @@ int tcp_rtx_synack(const struct sock *sk, struct request_sock *req)
 	res = af_ops->send_synack(sk, NULL, &fl, req, NULL, TCP_SYNACK_NORMAL,
 				  NULL);
 	if (!res) {
-		__TCP_INC_STATS(sock_net(sk), TCP_MIB_RETRANSSEGS);
-		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNRETRANS);
+		TCP_INC_STATS(sock_net(sk), TCP_MIB_RETRANSSEGS);
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNRETRANS);
 		if (unlikely(tcp_passive_fastopen(sk)))
 			tcp_sk(sk)->total_retrans++;
 		trace_tcp_retransmit_synack(sk, req);
-- 
2.36.1.255.ge46751e96f-goog

