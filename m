Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F27DB4F1B10
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 23:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379436AbiDDVTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 17:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379997AbiDDSgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 14:36:45 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E5331376
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 11:34:48 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id p8so9767413pfh.8
        for <netdev@vger.kernel.org>; Mon, 04 Apr 2022 11:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6E+LuVWoR/m+zq5OzXcyqecGJDZnw/wsfo8Bv+qUwSQ=;
        b=dCgZ0Eq3UN6XUvwyMNWL4ealHOGlp1wK3kSXkbFKtUg/d3E2CQoXJ77GtGdm7Or8Ez
         hY15DqTLhQ22xozw1fb3kkEDSeRQmoPcaUQQNDJ12xvwwun60np0Dm6jL5H9qnZbVM4z
         fwQwtt+Cr47wIpFMn7bpWdbyig5zHC1mZ2vUforVjcC6RrdMRx9V2cSAU0VWPMa6Ue6b
         fNyufCC1qPbeAB4T2KBrDMa5peblmffi6JmI8TL1kVFrQ5E4omuM7GqjJF9XLeeapiXO
         OHU3VeW7y8w1BRFKBH5/FIclUW28mw29rQeKFNF3p7Pb0Wb1BOrTnuamPIiHv86p/thk
         nVrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6E+LuVWoR/m+zq5OzXcyqecGJDZnw/wsfo8Bv+qUwSQ=;
        b=xN2l2FlULEA3TB1znWTkCxSPFVlQqumOKVa/EgWuRIhih9iuhRJfo8tH/EpssMvYOM
         bRhsqTmLixWsyGI6yxmlupRAIIHRwYyfU1/avppLwplfhkmw0LuV9+F2AZgjLN5RIZYS
         vaJ960/CNjVHAyZh43JF7UkLagLakvREdWivrBJbIOqqZrBGrsiKz+PiU/+OD9izazn1
         S9X/OC2U+lamK35/wNYnd6jJGND101NEAQ328EzWxyMNO5l17wISyqNbyfXcXvUZmLp7
         vzJ4akgHFnIuGcxjIK6gjTCFH6I6BwQntJArc3nGFeXZUjXigbaz/ppHEUvoLAzCN75k
         WYLA==
X-Gm-Message-State: AOAM530iP1WScl3ujBbmznJE1cL+Dll38gv0oUa/Rb93xrwx1b34hFSK
        Ff6t1LQ07DP+l5ddK5XReyA=
X-Google-Smtp-Source: ABdhPJwU5ZbCGEqxOvEOEUixSGnFadbQezHJmP4ZHQgoUS2ttqZa95GUTKzhQkzcMQXno7wjRAZ00g==
X-Received: by 2002:aa7:9f9c:0:b0:4fa:7ffa:7cc7 with SMTP id z28-20020aa79f9c000000b004fa7ffa7cc7mr1353393pfr.43.1649097287851;
        Mon, 04 Apr 2022 11:34:47 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4b47:a761:2ad5:a61c])
        by smtp.gmail.com with ESMTPSA id u18-20020a056a00125200b004fb112ee9b7sm11858533pfi.75.2022.04.04.11.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 11:34:46 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] rxrpc: fix a race in rxrpc_exit_net()
Date:   Mon,  4 Apr 2022 11:34:39 -0700
Message-Id: <20220404183439.3537837-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
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

Current code can lead to the following race:

CPU0                                                 CPU1

rxrpc_exit_net()
                                                     rxrpc_peer_keepalive_worker()
                                                       if (rxnet->live)

  rxnet->live = false;
  del_timer_sync(&rxnet->peer_keepalive_timer);

                                                             timer_reduce(&rxnet->peer_keepalive_timer, jiffies + delay);

  cancel_work_sync(&rxnet->peer_keepalive_work);

rxrpc_exit_net() exits while peer_keepalive_timer is still armed,
leading to use-after-free.

syzbot report was:

ODEBUG: free active (active state 0) object type: timer_list hint: rxrpc_peer_keepalive_timeout+0x0/0xb0
WARNING: CPU: 0 PID: 3660 at lib/debugobjects.c:505 debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Modules linked in:
CPU: 0 PID: 3660 Comm: kworker/u4:6 Not tainted 5.17.0-syzkaller-13993-g88e6c0207623 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd 00 1c 26 8a 4c 89 ee 48 c7 c7 00 10 26 8a e8 b1 e7 28 05 <0f> 0b 83 05 15 eb c5 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffc9000353fb00 EFLAGS: 00010082
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: ffff888029196140 RSI: ffffffff815efad8 RDI: fffff520006a7f52
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815ea4ae R11: 0000000000000000 R12: ffffffff89ce23e0
R13: ffffffff8a2614e0 R14: ffffffff816628c0 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe1f2908924 CR3: 0000000043720000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __debug_check_no_obj_freed lib/debugobjects.c:992 [inline]
 debug_check_no_obj_freed+0x301/0x420 lib/debugobjects.c:1023
 kfree+0xd6/0x310 mm/slab.c:3809
 ops_free_list.part.0+0x119/0x370 net/core/net_namespace.c:176
 ops_free_list net/core/net_namespace.c:174 [inline]
 cleanup_net+0x591/0xb00 net/core/net_namespace.c:598
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>

Fixes: ace45bec6d77 ("rxrpc: Fix firewall route keepalive")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Marc Dionne <marc.dionne@auristor.com>
Cc: linux-afs@lists.infradead.org
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/rxrpc/net_ns.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/net_ns.c b/net/rxrpc/net_ns.c
index 25bbc4cc8b1359f7b895f181dad227de088ed31d..f15d6942da45306e4fa15399473044281dcbfed9 100644
--- a/net/rxrpc/net_ns.c
+++ b/net/rxrpc/net_ns.c
@@ -113,8 +113,8 @@ static __net_exit void rxrpc_exit_net(struct net *net)
 	struct rxrpc_net *rxnet = rxrpc_net(net);
 
 	rxnet->live = false;
-	del_timer_sync(&rxnet->peer_keepalive_timer);
 	cancel_work_sync(&rxnet->peer_keepalive_work);
+	del_timer_sync(&rxnet->peer_keepalive_timer);
 	rxrpc_destroy_all_calls(rxnet);
 	rxrpc_destroy_all_connections(rxnet);
 	rxrpc_destroy_all_peers(rxnet);
-- 
2.35.1.1094.g7c7d902a7c-goog

