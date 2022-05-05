Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29E6351C503
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 18:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237625AbiEEQXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 12:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiEEQXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 12:23:31 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E9C5BD01
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 09:19:51 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id p6so4325747plr.12
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 09:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=itPhneO+7NdMMRENEcorA1vjpE/LeLFqaWFBtMLKiRM=;
        b=noHOwJ/Q8u+0EfpAXvXsEWWoTSU8ZywqlXHdnL+lWbEQPdBiiwTWS1JaI3GuK+IA75
         v9y5TUlK5KvAjwAUA+v9kU5Y/KLhAovTyk8sTLTzgCGakUl2zwkOuh9GZDB03lf+ppAr
         HWwBAYupn4nygDWr/M+Uev1aTFoa9dlHpur9F6RTifNPfjkGNgkXDkCt271AqID9AnJw
         idtDHJkvuzC4S9HLqCVUOTL39x3D2cfA/LeSjIEmR4GlRdXKA5iSjzTrVE9yUBl8zEdV
         qoQdCT7o97nZoXJE+N7TXqCGCs6FfFYVI5V5F9qzsWmSv2aL9sSp5gGzhxJQ8m70ArAm
         RDvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=itPhneO+7NdMMRENEcorA1vjpE/LeLFqaWFBtMLKiRM=;
        b=6bTpiucH8g2Jy9Vo0tIoHtxmBjkLo8idfzShWiOlc1042AUhUW2f/i5Toua/AEg4W9
         43GEvdKCkOZi6ZwugF+TqR33xi3aqJnv3KOz0A9NxQ359ZH03ZXct43DU6RhA39Q7xCe
         IubzHZeJBMdJq8qGEtCb1uIGmeuRNzYUWefZAL30k5fXod/M7ns142oxH7iOPdfM6sNg
         rXNR1Z6+/RFQKgs4ln5+krYtcr999GqQg7ynv/B+jNDb5e75FhrcDhMucqfR5YnSAsmp
         uNq8SMkVu+cSzaezEcYlAfiN8IU36sZP9v4Phf/4rx7QYFNCBdKKtUPb0ZZ8Ljv2AeyG
         ShEQ==
X-Gm-Message-State: AOAM532RCH0Zugc/TOEvS9A5LEt9d9PlMnl+8GUMWPonL+sZudocR79J
        A5WVzG3ccQCo9Waswesi8Vi5rY7sJvw=
X-Google-Smtp-Source: ABdhPJxZFAFoKDoRLxnNiagElTiHa+jY13qiP+wsaYImCrMXh8ZEvSugd3bnuNf0Mz3eC9haNWQBFA==
X-Received: by 2002:a17:903:244e:b0:15e:b3f7:9509 with SMTP id l14-20020a170903244e00b0015eb3f79509mr16126635pls.42.1651767591062;
        Thu, 05 May 2022 09:19:51 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:709e:d3d8:321b:df52])
        by smtp.gmail.com with ESMTPSA id u1-20020a17090341c100b0015e8d4eb257sm1794926ple.161.2022.05.05.09.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 09:19:50 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] netlink: do not reset transport header in netlink_recvmsg()
Date:   Thu,  5 May 2022 09:19:46 -0700
Message-Id: <20220505161946.2867638-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
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

netlink_recvmsg() does not need to change transport header.

If transport header was needed, it should have been reset
by the producer (netlink_dump()), not the consumer(s).

The following trace probably happened when multiple threads
were using MSG_PEEK.

BUG: KCSAN: data-race in netlink_recvmsg / netlink_recvmsg

write to 0xffff88811e9f15b2 of 2 bytes by task 32012 on cpu 1:
 skb_reset_transport_header include/linux/skbuff.h:2760 [inline]
 netlink_recvmsg+0x1de/0x790 net/netlink/af_netlink.c:1978
 sock_recvmsg_nosec net/socket.c:948 [inline]
 sock_recvmsg net/socket.c:966 [inline]
 __sys_recvfrom+0x204/0x2c0 net/socket.c:2097
 __do_sys_recvfrom net/socket.c:2115 [inline]
 __se_sys_recvfrom net/socket.c:2111 [inline]
 __x64_sys_recvfrom+0x74/0x90 net/socket.c:2111
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

write to 0xffff88811e9f15b2 of 2 bytes by task 32005 on cpu 0:
 skb_reset_transport_header include/linux/skbuff.h:2760 [inline]
 netlink_recvmsg+0x1de/0x790 net/netlink/af_netlink.c:1978
 ____sys_recvmsg+0x162/0x2f0
 ___sys_recvmsg net/socket.c:2674 [inline]
 __sys_recvmsg+0x209/0x3f0 net/socket.c:2704
 __do_sys_recvmsg net/socket.c:2714 [inline]
 __se_sys_recvmsg net/socket.c:2711 [inline]
 __x64_sys_recvmsg+0x42/0x50 net/socket.c:2711
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0xffff -> 0x0000

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 32005 Comm: syz-executor.4 Not tainted 5.18.0-rc1-syzkaller-00328-ge1f700ebd6be-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/netlink/af_netlink.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 05a3795eac8e9a7c8343460d9a41e0755a64c36e..73e9c0a9c187674cced15dbec079734489c3329f 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1975,7 +1975,6 @@ static int netlink_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		copied = len;
 	}
 
-	skb_reset_transport_header(data_skb);
 	err = skb_copy_datagram_msg(data_skb, 0, msg, copied);
 
 	if (msg->msg_name) {
-- 
2.36.0.512.ge40c2bad7a-goog

