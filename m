Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4E1D6B11C5
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 20:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjCHTJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 14:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjCHTJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 14:09:22 -0500
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA8191B6C;
        Wed,  8 Mar 2023 11:08:50 -0800 (PST)
Received: by mail-wm1-f46.google.com with SMTP id l7-20020a05600c4f0700b003e79fa98ce1so1779391wmq.2;
        Wed, 08 Mar 2023 11:08:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678302467;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kJu5uWN4Vm4DxFmOs7QmxxPKXFfxw9DbCXPZAZPHQEI=;
        b=gb2Qzk+t4xmMA4IGelxaE04u9qBJP9Ao+kgf3F4qfgrNFk/7adHwaCVu9ZeMvfEJOs
         LdpeXdWThQmajxFE5gkn3gPcUCSz+O+sDe7USxBeg4zZlN3GVZ/67xLeu+wphn4MMJAD
         7Ehn/gNDKIsIrQC/zpeEal2xIZJyJbFdOe3R3oVy42x9uvlmaZOVY8U2HJO8EhtKXFvq
         Yrb3qlju9uvbpQu7LjS5+dYkS0NmpXsaENnkjLoBS4ftfbXg/JNH21fjq/fQ4fT//Pzw
         kJ7gTrlqRDp0kc2ALNZl7u9lgsR/N3Tq+3ZNNOkZIPb4Wu9ioFj5TjOROtDMO+wSIo0k
         i9nA==
X-Gm-Message-State: AO0yUKUf3grXdnPjU2u/k+IT4WzYtJaXs2bVxz0lnfYC+bx6WUYLjHDd
        9FEAfxRyDTxnhEFaxwXBNE8=
X-Google-Smtp-Source: AK7set87yhq3QCTE9bjMxefGVJRrsfedTwkEpAeIYDbAeJ655+yz0av/F0NeIex9lGG7DcULHRNX1w==
X-Received: by 2002:a05:600c:4e8c:b0:3e2:dba:7155 with SMTP id f12-20020a05600c4e8c00b003e20dba7155mr16138469wmq.20.1678302467503;
        Wed, 08 Mar 2023 11:07:47 -0800 (PST)
Received: from localhost (fwdproxy-cln-119.fbsv.net. [2a03:2880:31ff:77::face:b00c])
        by smtp.gmail.com with ESMTPSA id q20-20020a1cf314000000b003db06224953sm229637wmq.41.2023.03.08.11.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 11:07:47 -0800 (PST)
From:   Breno Leitao <leitao@debian.org>
To:     edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, laurent.fasnacht@proton.ch,
        hkchu@google.com, leit@meta.com, linux-kernel@vger.kernel.org
Subject: [PATCH] tcp: tcp_make_synack() can be called from process context
Date:   Wed,  8 Mar 2023 11:07:45 -0800
Message-Id: <20230308190745.780221-1-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_rtx_synack() now could be called in process context as explained in
0a375c822497 ("tcp: tcp_rtx_synack() can be called from process
context").

tcp_rtx_synack() might call tcp_make_synack(), which will touch per-CPU
variables with preemption enabled. This causes the following BUG:

    BUG: using __this_cpu_add() in preemptible [00000000] code: ThriftIO1/5464
    caller is tcp_make_synack+0x841/0xac0
    Call Trace:
     <TASK>
     dump_stack_lvl+0x10d/0x1a0
     check_preemption_disabled+0x104/0x110
     tcp_make_synack+0x841/0xac0
     tcp_v6_send_synack+0x5c/0x450
     tcp_rtx_synack+0xeb/0x1f0
     inet_rtx_syn_ack+0x34/0x60
     tcp_check_req+0x3af/0x9e0
     tcp_rcv_state_process+0x59b/0x2030
     tcp_v6_do_rcv+0x5f5/0x700
     release_sock+0x3a/0xf0
     tcp_sendmsg+0x33/0x40
     ____sys_sendmsg+0x2f2/0x490
     __sys_sendmsg+0x184/0x230
     do_syscall_64+0x3d/0x90

Avoid calling __TCP_INC_STATS() with will touch per-cpu variables. Use
TCP_INC_STATS() which is safe to be called from context switch.

Fixes: 8336886f786f ("tcp: TCP Fast Open Server - support TFO listeners")
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 net/ipv4/tcp_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 71d01cf3c13e..ba839e441450 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3605,7 +3605,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	th->window = htons(min(req->rsk_rcv_wnd, 65535U));
 	tcp_options_write(th, NULL, &opts);
 	th->doff = (tcp_header_size >> 2);
-	__TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
+	TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
 
 #ifdef CONFIG_TCP_MD5SIG
 	/* Okay, we have all we need - do the md5 hash if needed */
-- 
2.34.1

