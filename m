Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 168F94D7435
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 11:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbiCMKY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 06:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbiCMKYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 06:24:25 -0400
Received: from eidolon.nox.tf (eidolon.nox.tf [IPv6:2a07:2ec0:2185::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039A22DA97
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 03:23:17 -0700 (PDT)
Received: from [178.197.200.96] (helo=areia)
        by eidolon.nox.tf with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <equinox@diac24.net>)
        id 1nTLHz-003JVp-GB; Sun, 13 Mar 2022 11:17:27 +0100
Received: from equinox by areia with local (Exim 4.95)
        (envelope-from <equinox@diac24.net>)
        id 1nTL1s-001aBP-BC;
        Sun, 13 Mar 2022 11:00:48 +0100
From:   David Lamparter <equinox@diac24.net>
To:     netdev@vger.kernel.org
Cc:     David Lamparter <equinox@diac24.net>
Subject: [PATCH net-next 2/2] net/packet: use synchronize_net_expedited()
Date:   Sun, 13 Mar 2022 11:00:33 +0100
Message-Id: <20220313100033.343442-3-equinox@diac24.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220313100033.343442-1-equinox@diac24.net>
References: <20220313100033.343442-1-equinox@diac24.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since these locations don't have RTNL held, synchronize_net() uses
synchronize_rcu(), which takes its time.  Unfortunately, this is user
visible on bind() and close() calls from userspace.  With a good amount
of network interfaces, this sums up to Wireshark (dumpcap) taking
several seconds to start for no good reason.

Signed-off-by: David Lamparter <equinox@diac24.net>
---
 net/packet/af_packet.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 1b93ce1a5600..559e72149110 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -379,7 +379,7 @@ static void __unregister_prot_hook(struct sock *sk, bool sync)
 
 	if (sync) {
 		spin_unlock(&po->bind_lock);
-		synchronize_net();
+		synchronize_net_expedited();
 		spin_lock(&po->bind_lock);
 	}
 }
@@ -1578,7 +1578,7 @@ static void __fanout_set_data_bpf(struct packet_fanout *f, struct bpf_prog *new)
 	spin_unlock(&f->lock);
 
 	if (old) {
-		synchronize_net();
+		synchronize_net_expedited();
 		bpf_prog_destroy(old);
 	}
 }
@@ -3137,7 +3137,7 @@ static int packet_release(struct socket *sock)
 
 	f = fanout_release(sk);
 
-	synchronize_net();
+	synchronize_net_expedited();
 
 	kfree(po->rollover);
 	if (f) {
@@ -4453,7 +4453,7 @@ static int packet_set_ring(struct sock *sk, union tpacket_req_u *req_u,
 	}
 	spin_unlock(&po->bind_lock);
 
-	synchronize_net();
+	synchronize_net_expedited();
 
 	err = -EBUSY;
 	mutex_lock(&po->pg_vec_lock);
-- 
2.35.1

