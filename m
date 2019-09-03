Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8D2DA6612
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 11:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbfICJxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 05:53:22 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41890 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbfICJxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 05:53:22 -0400
Received: by mail-pf1-f194.google.com with SMTP id b13so3815878pfo.8
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 02:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=BePgudw6S48xyntlSwy9Nj/he6DorpRJE5qzChHU8Xs=;
        b=VW4o87nN0bEwEzS1voUk452RV06jx5ikn0sJgdRnVIZ1qtUueE3q+d+Zy8ggvKmduf
         fzLFdiX0qu6mlCS18Gv456izQVe8ISD/d5Z/qLmWneRcy0lKL7pGbqRaXv9Fq167+LHy
         AMU0i5uEJVmRBNcLJpg4JcMKjnc8qrvxhUaD+u0+vmSq6/n4K7K+uolkqy9MovQVnPmg
         10NAt+wYMfmNpWx/2jBVVyPmJXcvPetUblHlfV7MPptAKNurjCxwtRs0dwbRr1tvIgUk
         TlrJWKcm+41J+qKCiM/pSaR7Mvp4YCHSQWpyQ1HI7+6kXwSN22NAgxDP7ZEXHOuoGUwS
         nkWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BePgudw6S48xyntlSwy9Nj/he6DorpRJE5qzChHU8Xs=;
        b=LgNG1SlzgeTtTyAqevCQkDKgG1jplvU8pZOqmLdmHGOVeGaFhFMxo34Fel1pwyVKDR
         WMLP7yb47ZIBe1DCWNC9QQ+p2vWHciy5Ewu7sgZ04M7sm+AsgwEQ+IAC+cWGc4gGx23a
         oTiHsHJ65UyaOqag+s5glyl/lk7MCsEnvlhwydP9UD8OL5U1WTLXGEtJURaA1sa2ploh
         84yQTF5WPWqqG18mdGOMdaB96RZK85w3fHpHI+UeLe8iXS0IaZO7eVhkAhJSKuI2Box4
         P9mt+CzPBwTLBbtudkAuuerSudyS5OBfGiyAEc5Cla5kJiZXVNSK8HP0AfATrFPTGiKG
         k1fQ==
X-Gm-Message-State: APjAAAXXAikibm/KiaQQalHHbvopKa9Mza67VFvMsl9gBZF1hhVzdI5C
        aWyLcLOBhbA9yurdej6nlLq1kcie
X-Google-Smtp-Source: APXvYqwCnuLa+PjLeqQcRsi+2sd7mzCwizuwAW7cdNsjEV2M50hD+b/XUiPfJSrHaEvzw+qAVQkRNg==
X-Received: by 2002:a63:5920:: with SMTP id n32mr28406516pgb.352.1567504400939;
        Tue, 03 Sep 2019 02:53:20 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t9sm17604225pgj.89.2019.09.03.02.53.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Sep 2019 02:53:20 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH net] tipc: add NULL pointer check before calling kfree_rcu
Date:   Tue,  3 Sep 2019 17:53:12 +0800
Message-Id: <f42a6270d821baf1445b5fa40dc201f7c9c5ebd0.1567504392.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlike kfree(p), kfree_rcu(p, rcu) won't do NULL pointer check. When
tipc_nametbl_remove_publ returns NULL, the panic below happens:

   BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
   RIP: 0010:__call_rcu+0x1d/0x290
   Call Trace:
    <IRQ>
    tipc_publ_notify+0xa9/0x170 [tipc]
    tipc_node_write_unlock+0x8d/0x100 [tipc]
    tipc_node_link_down+0xae/0x1d0 [tipc]
    tipc_node_check_dest+0x3ea/0x8f0 [tipc]
    ? tipc_disc_rcv+0x2c7/0x430 [tipc]
    tipc_disc_rcv+0x2c7/0x430 [tipc]
    ? tipc_rcv+0x6bb/0xf20 [tipc]
    tipc_rcv+0x6bb/0xf20 [tipc]
    ? ip_route_input_slow+0x9cf/0xb10
    tipc_udp_recv+0x195/0x1e0 [tipc]
    ? tipc_udp_is_known_peer+0x80/0x80 [tipc]
    udp_queue_rcv_skb+0x180/0x460
    udp_unicast_rcv_skb.isra.56+0x75/0x90
    __udp4_lib_rcv+0x4ce/0xb90
    ip_local_deliver_finish+0x11c/0x210
    ip_local_deliver+0x6b/0xe0
    ? ip_rcv_finish+0xa9/0x410
    ip_rcv+0x273/0x362

Fixes: 97ede29e80ee ("tipc: convert name table read-write lock to RCU")
Reported-by: Li Shuang <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/name_distr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
index 44abc8e..241ed22 100644
--- a/net/tipc/name_distr.c
+++ b/net/tipc/name_distr.c
@@ -223,7 +223,8 @@ static void tipc_publ_purge(struct net *net, struct publication *publ, u32 addr)
 		       publ->key);
 	}
 
-	kfree_rcu(p, rcu);
+	if (p)
+		kfree_rcu(p, rcu);
 }
 
 /**
-- 
2.1.0

