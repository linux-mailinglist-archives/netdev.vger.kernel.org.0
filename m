Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B98DF4AE353
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 23:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387151AbiBHWVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 17:21:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345032AbiBHWUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 17:20:52 -0500
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F734C0612B8;
        Tue,  8 Feb 2022 14:20:50 -0800 (PST)
Received: from localhost.localdomain (ip5f5aebc2.dynamic.kabel-deutschland.de [95.90.235.194])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 16BEA61E64846;
        Tue,  8 Feb 2022 23:20:47 +0100 (CET)
From:   Paul Menzel <pmenzel@molgen.mpg.de>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Revert "Bluetooth: Fix passing NULL to PTR_ERR"
Date:   Tue,  8 Feb 2022 23:19:10 +0100
Message-Id: <20220208221911.57058-1-pmenzel@molgen.mpg.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 266191aa8d14b84958aaeb5e96ee4e97839e3d87, so that
commit 81be03e026dc ("Bluetooth: RFCOMM: Replace use of memcpy_from_msg
with bt_skb_sendmmsg"), introducing a regression, can be reverted.

Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
---
 include/net/bluetooth/bluetooth.h | 2 +-
 net/bluetooth/rfcomm/sock.c       | 2 +-
 net/bluetooth/sco.c               | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
index 4b3d0b16c185..318df161e6d3 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -505,7 +505,7 @@ static inline struct sk_buff *bt_skb_sendmmsg(struct sock *sk,
 		struct sk_buff *tmp;
 
 		tmp = bt_skb_sendmsg(sk, msg, len, mtu, headroom, tailroom);
-		if (IS_ERR(tmp)) {
+		if (IS_ERR_OR_NULL(tmp)) {
 			kfree_skb(skb);
 			return tmp;
 		}
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 4bf4ea6cbb5e..5938af3e9936 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -583,7 +583,7 @@ static int rfcomm_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 
 	skb = bt_skb_sendmmsg(sk, msg, len, d->mtu, RFCOMM_SKB_HEAD_RESERVE,
 			      RFCOMM_SKB_TAIL_RESERVE);
-	if (IS_ERR(skb))
+	if (IS_ERR_OR_NULL(skb))
 		return PTR_ERR(skb);
 
 	sent = rfcomm_dlc_send(d, skb);
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 8eabf41b2993..7ebc9d294f0c 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -734,7 +734,7 @@ static int sco_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 		return -EOPNOTSUPP;
 
 	skb = bt_skb_sendmsg(sk, msg, len, len, 0, 0);
-	if (IS_ERR(skb))
+	if (IS_ERR_OR_NULL(skb))
 		return PTR_ERR(skb);
 
 	lock_sock(sk);
-- 
2.34.1

