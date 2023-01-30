Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B605968156C
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 16:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237484AbjA3PqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 10:46:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237470AbjA3Ppn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 10:45:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62E73EFE6
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 07:44:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675093495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XRAqDvpdOweYOp5rKoRnwrLbtMo4U87gO0dmZD+DZl8=;
        b=ib9tmd6T81o6xquV7W+ysOD93QZv+L4/I2AIvxF9A4ubGdOOTWldamW2tNpST8s+spMYem
        P/WaVQCAzUosHp2ZyzyWBgL92fg4P44MGApDTRWMUdA4t91ZkLBPlJ2EC5J+sFdApr1Ly+
        T/027iLuDQUg8IYXB0vJUIiVG0hwMus=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-286-lk7k3plfM8aEsNCakOFP_g-1; Mon, 30 Jan 2023 10:44:53 -0500
X-MC-Unique: lk7k3plfM8aEsNCakOFP_g-1
Received: by mail-pl1-f197.google.com with SMTP id 5-20020a170902c20500b0019682a04155so1939004pll.19
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 07:44:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XRAqDvpdOweYOp5rKoRnwrLbtMo4U87gO0dmZD+DZl8=;
        b=WnPtDFAzhTYwX2wEQBph3Y+opN+DeHCdeynITiINSoOWlw2GblszTpVp5k7Xz5gw4d
         Z3rMhT7/Irjz3H4eq4VqrIe5Phps6Z4aw7rRx8jf/Oq+qhqCP56ZNRhFKogDPTC2hq6l
         U1mYXmnwgaXEwLHgf7LYUfschM/sauV63R/Lz9lUoxI4ptWhJsFxHd2qi7d0bPi1NfbR
         41PHguVJanS23tgAQLviauGII+VPfb3bn4ub08PtoB3xXyJnsvBl55SwCAuhrD/aawjL
         1VchjDkiZhn479YJCDyHFbLWjZgxM7HAEmm0KN8Df7SdCPUDj/D3pk9QfXa8AV8r2FeP
         sVHQ==
X-Gm-Message-State: AFqh2krXcsDMIuI13eX5ZAVOmIoYyv2dAXw9wUSyQ53u5fhFOrR8+R4w
        nsqvhaTLRkIFdPK2mOe65ESopqJ0aymzxuCZFhGvMve4EGFhLWLtohsZMTxhlKCoWfI5SYraUv3
        IzWdd9gvE2l0I92nR
X-Received: by 2002:a17:90b:390b:b0:22b:b1cd:cce with SMTP id ob11-20020a17090b390b00b0022bb1cd0ccemr38598612pjb.33.1675093492643;
        Mon, 30 Jan 2023 07:44:52 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtXwctu5LACNa72F0lwpciIsVwySMd32dCvIolLvbOZ/jRl4lPPEbtxzuPDUZIHh7zq20oeVg==
X-Received: by 2002:a17:90b:390b:b0:22b:b1cd:cce with SMTP id ob11-20020a17090b390b00b0022bb1cd0ccemr38598587pjb.33.1675093492345;
        Mon, 30 Jan 2023 07:44:52 -0800 (PST)
Received: from localhost.localdomain ([240d:1a:c0d:9f00:ca6:1aff:fead:cef4])
        by smtp.gmail.com with ESMTPSA id mp1-20020a17090b190100b002298e0641b6sm9654421pjb.27.2023.01.30.07.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 07:44:52 -0800 (PST)
From:   Shigeru Yoshida <syoshida@redhat.com>
To:     jchapman@katalix.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shigeru Yoshida <syoshida@redhat.com>
Subject: [PATCH] l2tp: Avoid possible recursive deadlock in l2tp_tunnel_register()
Date:   Tue, 31 Jan 2023 00:44:38 +0900
Message-Id: <20230130154438.1373750-1-syoshida@redhat.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a file descriptor of pppol2tp socket is passed as file descriptor
of UDP socket, a recursive deadlock occurs in l2tp_tunnel_register().
This situation is reproduced by the following program:

int main(void)
{
	int sock;
	struct sockaddr_pppol2tp addr;

	sock = socket(AF_PPPOX, SOCK_DGRAM, PX_PROTO_OL2TP);
	if (sock < 0) {
		perror("socket");
		return 1;
	}

	addr.sa_family = AF_PPPOX;
	addr.sa_protocol = PX_PROTO_OL2TP;
	addr.pppol2tp.pid = 0;
	addr.pppol2tp.fd = sock;
	addr.pppol2tp.addr.sin_family = PF_INET;
	addr.pppol2tp.addr.sin_port = htons(0);
	addr.pppol2tp.addr.sin_addr.s_addr = inet_addr("192.168.0.1");
	addr.pppol2tp.s_tunnel = 1;
	addr.pppol2tp.s_session = 0;
	addr.pppol2tp.d_tunnel = 0;
	addr.pppol2tp.d_session = 0;

	if (connect(sock, (const struct sockaddr *)&addr, sizeof(addr)) < 0) {
		perror("connect");
		return 1;
	}

	return 0;
}

This program causes the following lockdep warning:

 ============================================
 WARNING: possible recursive locking detected
 6.2.0-rc5-00205-gc96618275234 #56 Not tainted
 --------------------------------------------
 repro/8607 is trying to acquire lock:
 ffff8880213c8130 (sk_lock-AF_PPPOX){+.+.}-{0:0}, at: l2tp_tunnel_register+0x2b7/0x11c0

 but task is already holding lock:
 ffff8880213c8130 (sk_lock-AF_PPPOX){+.+.}-{0:0}, at: pppol2tp_connect+0xa82/0x1a30

 other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(sk_lock-AF_PPPOX);
   lock(sk_lock-AF_PPPOX);

  *** DEADLOCK ***

  May be due to missing lock nesting notation

 1 lock held by repro/8607:
  #0: ffff8880213c8130 (sk_lock-AF_PPPOX){+.+.}-{0:0}, at: pppol2tp_connect+0xa82/0x1a30

 stack backtrace:
 CPU: 0 PID: 8607 Comm: repro Not tainted 6.2.0-rc5-00205-gc96618275234 #56
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.1-2.fc37 04/01/2014
 Call Trace:
  <TASK>
  dump_stack_lvl+0x100/0x178
  __lock_acquire.cold+0x119/0x3b9
  ? lockdep_hardirqs_on_prepare+0x410/0x410
  lock_acquire+0x1e0/0x610
  ? l2tp_tunnel_register+0x2b7/0x11c0
  ? lock_downgrade+0x710/0x710
  ? __fget_files+0x283/0x3e0
  lock_sock_nested+0x3a/0xf0
  ? l2tp_tunnel_register+0x2b7/0x11c0
  l2tp_tunnel_register+0x2b7/0x11c0
  ? sprintf+0xc4/0x100
  ? l2tp_tunnel_del_work+0x6b0/0x6b0
  ? debug_object_deactivate+0x320/0x320
  ? lockdep_init_map_type+0x16d/0x7a0
  ? lockdep_init_map_type+0x16d/0x7a0
  ? l2tp_tunnel_create+0x2bf/0x4b0
  ? l2tp_tunnel_create+0x3c6/0x4b0
  pppol2tp_connect+0x14e1/0x1a30
  ? pppol2tp_put_sk+0xd0/0xd0
  ? aa_sk_perm+0x2b7/0xa80
  ? aa_af_perm+0x260/0x260
  ? bpf_lsm_socket_connect+0x9/0x10
  ? pppol2tp_put_sk+0xd0/0xd0
  __sys_connect_file+0x14f/0x190
  __sys_connect+0x133/0x160
  ? __sys_connect_file+0x190/0x190
  ? lockdep_hardirqs_on+0x7d/0x100
  ? ktime_get_coarse_real_ts64+0x1b7/0x200
  ? ktime_get_coarse_real_ts64+0x147/0x200
  ? __audit_syscall_entry+0x396/0x500
  __x64_sys_connect+0x72/0xb0
  do_syscall_64+0x38/0xb0
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

This patch fixes the issue by returning error when a pppol2tp socket
itself is passed.

Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
---
 net/l2tp/l2tp_ppp.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index db2e584c625e..88d1a339500b 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -702,11 +702,14 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 			struct l2tp_tunnel_cfg tcfg = {
 				.encap = L2TP_ENCAPTYPE_UDP,
 			};
+			int dummy = 0;
 
 			/* Prevent l2tp_tunnel_register() from trying to set up
-			 * a kernel socket.
+			 * a kernel socket.  Also, prevent l2tp_tunnel_register()
+			 * from trying to use pppol2tp socket itself.
 			 */
-			if (info.fd < 0) {
+			if (info.fd < 0 ||
+			    sock == sockfd_lookup(info.fd, &dummy)) {
 				error = -EBADF;
 				goto end;
 			}
-- 
2.39.0

