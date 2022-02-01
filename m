Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00104A5536
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 03:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbiBACYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 21:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiBACYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 21:24:02 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C87C061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 18:24:02 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id o11so15754669pjf.0
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 18:24:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PqdkSLIPHKG09rij8095Neto1Dybiy5A9lBeuZ993bo=;
        b=VrBSLvE1hSsWMvlIa8i7Mp0VTizmgVtcXabNODqPDnaTPx8mudYYQrqvPNDxUv+XiD
         a8A7NHtlx0BPLz3phDVwTMgXolOezYZjnrpNfCaW/wfWM1HcM6NyBhQXr0mTtmP9JaeH
         W7D1PdvZxfS2xB/IA3rs3DLi6P0Z921Vxl6YXmz4RnWHkLY8kd2NJeCzTLsEzIIhyPQ6
         KiXvJV3xjzUfJBU53kEbtDcNEJKi6ooiM/2orrUjH2nw6f14znNXcfeF74nc5ia9Gt5l
         Y1xXEIBfQ2o55/V0lwg268G94H0Eqiahx9gIOOjEjlw4CugjpEBox4JUU3/2zx/htG22
         YAHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PqdkSLIPHKG09rij8095Neto1Dybiy5A9lBeuZ993bo=;
        b=IZzREvqPmUT5HcUi+GqDs0fyUekAR7OL+VHRoQPcHgTCWQ3J5j2TQ8F7E8kfwc2mHf
         OQp4lggg8nNxqaImURqhBMLcaeRArtNjjfJCiMD1k8Vi0IAU+zPgg39QUtTVPfqoEjeX
         glYfZuRj7kBoWJp/ftVVNqwsC4bAEPHwtgcOZUn9jzhYUXRnuaEukLZCnUtF2OucS3GG
         j2ainDkuWe2+LfLmUIMgQZrXewpyexsTOOEiQ2sqWERx/+2pvIqdOZ85TPYEp5IK8yNu
         G6Z7h3BCQroHg1dzvBYdpUe03go5Q+ZEGv2tm5jBb6vl1UYmwYEsRMu2rxSvSqHwFwWL
         pGMw==
X-Gm-Message-State: AOAM531M2wsAiP3nCKn+G7x3m/FT6ExdLPirj6JR64ili1ppKtfGkjKl
        6PkkfpkLUp1A+CMLFnGuYgY=
X-Google-Smtp-Source: ABdhPJxD1ajD3/e+1W7C4PinraCK5ijZmQDPpm5a9e6V4vev/Occ2jUYTwFLuohYKErn9/ZyP+QChg==
X-Received: by 2002:a17:903:28c:: with SMTP id j12mr23491294plr.6.1643682241790;
        Mon, 31 Jan 2022 18:24:01 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4c2d:864b:dd30:3c5e])
        by smtp.gmail.com with ESMTPSA id pi9sm617626pjb.46.2022.01.31.18.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 18:24:01 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] af_packet: fix data-race in packet_setsockopt / packet_setsockopt
Date:   Mon, 31 Jan 2022 18:23:58 -0800
Message-Id: <20220201022358.330621-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

When packet_setsockopt( PACKET_FANOUT_DATA ) reads po->fanout,
no lock is held, meaning that another thread can change po->fanout.

Given that po->fanout can only be set once during the socket lifetime
(it is only cleared from fanout_release()), we can use
READ_ONCE()/WRITE_ONCE() to document the race.

BUG: KCSAN: data-race in packet_setsockopt / packet_setsockopt

write to 0xffff88813ae8e300 of 8 bytes by task 14653 on cpu 0:
 fanout_add net/packet/af_packet.c:1791 [inline]
 packet_setsockopt+0x22fe/0x24a0 net/packet/af_packet.c:3931
 __sys_setsockopt+0x209/0x2a0 net/socket.c:2180
 __do_sys_setsockopt net/socket.c:2191 [inline]
 __se_sys_setsockopt net/socket.c:2188 [inline]
 __x64_sys_setsockopt+0x62/0x70 net/socket.c:2188
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff88813ae8e300 of 8 bytes by task 14654 on cpu 1:
 packet_setsockopt+0x691/0x24a0 net/packet/af_packet.c:3935
 __sys_setsockopt+0x209/0x2a0 net/socket.c:2180
 __do_sys_setsockopt net/socket.c:2191 [inline]
 __se_sys_setsockopt net/socket.c:2188 [inline]
 __x64_sys_setsockopt+0x62/0x70 net/socket.c:2188
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x0000000000000000 -> 0xffff888106f8c000

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 14654 Comm: syz-executor.3 Not tainted 5.16.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 47dceb8ecdc1 ("packet: add classic BPF fanout mode")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/packet/af_packet.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 85ea7ddb48db6a50228ae2b9a255bd161d5b12ed..ab87f22cc7ecde517ba4cd0b3804a28c3cccfc85 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1789,7 +1789,10 @@ static int fanout_add(struct sock *sk, struct fanout_args *args)
 		err = -ENOSPC;
 		if (refcount_read(&match->sk_ref) < match->max_num_members) {
 			__dev_remove_pack(&po->prot_hook);
-			po->fanout = match;
+
+			/* Paired with packet_setsockopt(PACKET_FANOUT_DATA) */
+			WRITE_ONCE(po->fanout, match);
+
 			po->rollover = rollover;
 			rollover = NULL;
 			refcount_set(&match->sk_ref, refcount_read(&match->sk_ref) + 1);
@@ -3934,7 +3937,8 @@ packet_setsockopt(struct socket *sock, int level, int optname, sockptr_t optval,
 	}
 	case PACKET_FANOUT_DATA:
 	{
-		if (!po->fanout)
+		/* Paired with the WRITE_ONCE() in fanout_add() */
+		if (!READ_ONCE(po->fanout))
 			return -EINVAL;
 
 		return fanout_set_data(po, optval, optlen);
-- 
2.35.0.rc2.247.g8bbb082509-goog

