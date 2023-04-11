Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B96716DE5E0
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 22:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjDKUml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 16:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbjDKUme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 16:42:34 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036DB5241
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:42:26 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id hg25-20020a05600c539900b003f05a99a841so12941016wmb.3
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1681245745;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ThABOxRzB1jOSc6wyzWaQirUycxd5ifOhlieHpINE4U=;
        b=vfp9P0kk4rWxJMhykJb2fbP+oVEyogltUROSwdrkl7exUPWGjLd1FcFfF4pxPdTdC6
         JZoQ6VcCLAcKDvl5E6FJ2na+rtrkXFP8XvmvBnFp5RX95KgDurOKu+BTfNEE4UMYZQWX
         0D6FTm7/L6DMLs1abSASabUt+ezPGoBgs533paCgjt2anJjlYFyrp5QQ0A6s+gmtxW5s
         iQ5tjraZSKbG2Q6P3QhF4LnqoIdQpkFIT+FTMO197mJQ1pnWLgk6iz3OJYgiqdejnvbH
         NRTsc2hw97fi8SEWiddVlVsOXGmq7Ad5vtH8kRXjAV9e0RCBdggnBk7yG26qU1LbX5AL
         DNBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681245745;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ThABOxRzB1jOSc6wyzWaQirUycxd5ifOhlieHpINE4U=;
        b=JqQe/lqBZbAH2Z8JWBAoJn25Ttw3C9abIQZcJnPSnE0ZH0+hAS+gHTNQryN0qiEWFm
         JGuMxL+4Gs8Esa1S4dFZtuwgL3bTALS5oxlTXHPbdSdxDfzWMx9hMM1dE4lXgnYAGry5
         x4aVBdKn//GeWC8oP74xRuUdthe8BiGWdI1dTsBRsFnilEvlrzunLqtVR1zpAGb+DtzN
         FVrq/AhSDypfuRQacNNjGKXiw+Zkv0Hsz4T4c8rB26APJy06yT4jattVzXdTA+UwdmYc
         McsCt3sjh1hwUo2a1YG/oy6gpdkI+855l1rnFduBke/g+Fmx/idZjuArCp3zsDpKzhX+
         tuiw==
X-Gm-Message-State: AAQBX9fhbkaSVtb7IIag5N6vhLTc2ZLEaYg70aLMLoAg9+6FlZ0AoFS2
        73XL+44bkjMYcB1Ud+FtPWEKaA==
X-Google-Smtp-Source: AKy350YaAE8OeYg5muwH7x63CSEWe7p7/VwqyNevtW+epcooOR8ka+kGPDMpNIocSebB/6TGukRTew==
X-Received: by 2002:a7b:cd18:0:b0:3ed:ce50:435a with SMTP id f24-20020a7bcd18000000b003edce50435amr7701116wmj.10.1681245745475;
        Tue, 11 Apr 2023 13:42:25 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id p23-20020a1c7417000000b003f0824e8c92sm86887wmc.7.2023.04.11.13.42.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 13:42:25 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Tue, 11 Apr 2023 22:42:10 +0200
Subject: [PATCH net 2/4] mptcp: stricter state check in mptcp_worker
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230411-upstream-net-20230411-mptcp-fixes-v1-2-ca540f3ef986@tessares.net>
References: <20230411-upstream-net-20230411-mptcp-fixes-v1-0-ca540f3ef986@tessares.net>
In-Reply-To: <20230411-upstream-net-20230411-mptcp-fixes-v1-0-ca540f3ef986@tessares.net>
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Dmytro Shytyi <dmytro@shytyi.net>,
        Shuah Khan <shuah@kernel.org>,
        Mat Martineau <martineau@kernel.org>,
        Geliang Tang <geliang.tang@suse.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        stable@vger.kernel.org, Christoph Paasch <cpaasch@apple.com>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2953;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=J9zcdQyThTTtsTWaVj72ahLWvIQIgNH67+VqXIn1Uuo=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkNcYuEH/UqLGCEVfX4sXwfz++pATil6ANN409h
 KapHdhmnNGJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZDXGLgAKCRD2t4JPQmmg
 cxyhD/oDKk5lIhohbniVijmI9kVeFLo+mvcl2/XdEzTCT1KWG2v5P8h6odWGKLcPq+oVkozG78M
 8vK6c2kDXAuZCJzGccIiXoMyz9gIidrbVYaQMTy1rznD0Q9kFRM1pG8xQZatGzwdZIx8m3KIrWm
 MGSyDLLLJSNb/Ahdpi0kVZevSaMJ7m6ltA3/EgBrzfknJWXeQdsTkO663jaqEjap1Q2rFBafypN
 oPet/tcSyoznsvHCclLiQW2EeYW+jCYG+DOQJ/Cim2LBnGxH7TL5+RABmNHUWH//m0tp4fQQQ2y
 QBFFU+98X3wyzqE0ZrlgUF+tpu1KqH+adRMq/1zB0UB5py9pirKI5jjLwgS1jPgzPdNaSxudBXp
 QhBkAXK4qT1wMWr28cKQjUcXE9rHc9U1KEk60w5ucmZA7yH6F2b7PvtZPGyKTllxRwvyesI7H9s
 xsDoDuvUsaT7pCot2kpYmqG0kTzRP8sT9QiG8wZ2KMQD8Liy0AL2WmlWc+AaAt00ehyFdSojQLj
 eSo/0Mu3y+Yq14w0D58U91WubWL/cbyDjIEL6qKQyQEQ5N9Eoboq9S95/JfKESzJK7maq1nIkej
 eKyiE6kNPBSX9jEh3qe5A/AYIl98t4IvYpm6/IGZa8cJsFncyMODa8hyDQxSfS7fVs5u4z/oUqq
 2DJiXiAYkKtFoLA==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

As reported by Christoph, the mptcp protocol can run the
worker when the relevant msk socket is in an unexpected state:

connect()
// incoming reset + fastclose
// the mptcp worker is scheduled
mptcp_disconnect()
// msk is now CLOSED
listen()
mptcp_worker()

Leading to the following splat:

divide error: 0000 [#1] PREEMPT SMP
CPU: 1 PID: 21 Comm: kworker/1:0 Not tainted 6.3.0-rc1-gde5e8fd0123c #11
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7 04/01/2014
Workqueue: events mptcp_worker
RIP: 0010:__tcp_select_window+0x22c/0x4b0 net/ipv4/tcp_output.c:3018
RSP: 0018:ffffc900000b3c98 EFLAGS: 00010293
RAX: 000000000000ffd7 RBX: 000000000000ffd7 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff8214ce97 RDI: 0000000000000004
RBP: 000000000000ffd7 R08: 0000000000000004 R09: 0000000000010000
R10: 000000000000ffd7 R11: ffff888005afa148 R12: 000000000000ffd7
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88803ed00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000405270 CR3: 000000003011e006 CR4: 0000000000370ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 tcp_select_window net/ipv4/tcp_output.c:262 [inline]
 __tcp_transmit_skb+0x356/0x1280 net/ipv4/tcp_output.c:1345
 tcp_transmit_skb net/ipv4/tcp_output.c:1417 [inline]
 tcp_send_active_reset+0x13e/0x320 net/ipv4/tcp_output.c:3459
 mptcp_check_fastclose net/mptcp/protocol.c:2530 [inline]
 mptcp_worker+0x6c7/0x800 net/mptcp/protocol.c:2705
 process_one_work+0x3bd/0x950 kernel/workqueue.c:2390
 worker_thread+0x5b/0x610 kernel/workqueue.c:2537
 kthread+0x138/0x170 kernel/kthread.c:376
 ret_from_fork+0x2c/0x50 arch/x86/entry/entry_64.S:308
 </TASK>

This change addresses the issue explicitly checking for bad states
before running the mptcp worker.

Fixes: e16163b6e2b7 ("mptcp: refactor shutdown and close")
Cc: stable@vger.kernel.org
Reported-by: Christoph Paasch <cpaasch@apple.com>
Link: https://github.com/multipath-tcp/mptcp_net-next/issues/374
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Tested-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/protocol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 60b23b2716c4..06c5872e3b00 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2626,7 +2626,7 @@ static void mptcp_worker(struct work_struct *work)
 
 	lock_sock(sk);
 	state = sk->sk_state;
-	if (unlikely(state == TCP_CLOSE))
+	if (unlikely((1 << state) & (TCPF_CLOSE | TCPF_LISTEN)))
 		goto unlock;
 
 	mptcp_check_data_fin_ack(sk);

-- 
2.39.2

