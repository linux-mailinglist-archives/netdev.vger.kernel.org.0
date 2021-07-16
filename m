Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2D03CBEB6
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 23:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236935AbhGPVrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 17:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236817AbhGPVrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 17:47:07 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A162C061760
        for <netdev@vger.kernel.org>; Fri, 16 Jul 2021 14:44:11 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id u8-20020a7bcb080000b02901e44e9caa2aso6695175wmj.4
        for <netdev@vger.kernel.org>; Fri, 16 Jul 2021 14:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=05I6T4y1TAStE9/dQzJnO6wGH+WxC5k7nootATM77EE=;
        b=lQj6O3icJGzrCo7DAPwL2cjseX728QVZzqKkefKwU99+NpbDvglGWAGJvvvQQleWE3
         4HBkbDoDEKX8Cy+VFomIcqH+cNSaaLAcfdmp+gJf8ZPM2fMle26Gijb09b9Qm+ycczP7
         b6Ad0g3N/H5+Q3OmSuVjLn8OCqWFyKfFP1mHL6a9HKxfNfsm8BUbToOZ0UdkeOdfO9MW
         dAN7EdrTioYs80d0WsvfvtTgRuS4DE5oxXKMzWOOAgFgmu9oMDU+U6k0yl5RG1g6x4ke
         A9q+q5vWnYN083dRga2KNjCXHHObFE99eFysJfBULpEEYJLXAcg2JoeR7k2m5MUu0z1i
         NlDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=05I6T4y1TAStE9/dQzJnO6wGH+WxC5k7nootATM77EE=;
        b=CwMU/BqPfz0G5zZd4d6YXJzkOIMh/l6FPw/udi0e69woR/3R4StodjWwX3QArKK2Lw
         jK6XNGxc+JBsqj7t+bZkv86JhjDPFdoqEnPbwunqJBuoZKJ9HgVlIdCrtxe5DQpOR2fV
         cECAcGunxH+qdncKaxqoNxYdlLXYChLkZnBzewcymFPh7sWJLDuCUCr5LH3nreTiZnd5
         hRearrH3aK25rdZCTiczcpOuMYU7Gs8AjLL/YQ+59V3KCcp8DEfitd2JeOd2V1vq0mnJ
         JKETPDtgOFEDjW1wP4+YBRIWOr6E6jxLqVkzlSib69/R39pqEmDBWtom27diNmSXSY//
         MgsQ==
X-Gm-Message-State: AOAM5304m3yvzBCDUegq+g7wRs9qhu/+wAZlo1TzhVty1FvooAMYGUTv
        6A+imkE0PP5D9rgvNaCaUm1A+MeYKwA=
X-Google-Smtp-Source: ABdhPJxgfosGf0pxBJ76Ow+krBnHAp2Auo7cthzPyz/Wn3k/1N0WzZsEKDaDwrC2UKgRB02RhRUiTQ==
X-Received: by 2002:a1c:a9c6:: with SMTP id s189mr8028836wme.143.1626471849874;
        Fri, 16 Jul 2021 14:44:09 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id n7sm11496808wmq.37.2021.07.16.14.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jul 2021 14:44:09 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Jon Maloy <jmaloy@redhat.com>,
        tipc-discussion@lists.sourceforge.net
Cc:     Erin Shepherd <erin.shepherd@e43.eu>
Subject: [PATCH net-next] tipc: keep the skb in rcv queue until the whole data is read
Date:   Fri, 16 Jul 2021 17:44:07 -0400
Message-Id: <57cb295272cdeedec04ac2f920a1fd37446163c6.1626471847.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when userspace reads a datagram with a buffer that is
smaller than this datagram, the data will be truncated and only
part of it can be received by users. It doesn't seem right that
users don't know the datagram size and have to use a huge buffer
to read it to avoid the truncation.

This patch to fix it by keeping the skb in rcv queue until the
whole data is read by users. Only the last msg of the datagram
will be marked with MSG_EOR, just as TCP/SCTP does.

Note that this will work as above only when MSG_EOR is set in the
flags parameter of recvmsg(), so that it won't break any old user
applications.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
---
 net/tipc/socket.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 34a97ea36cc8..9b0b311c7ec1 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1880,6 +1880,7 @@ static int tipc_recvmsg(struct socket *sock, struct msghdr *m,
 	bool connected = !tipc_sk_type_connectionless(sk);
 	struct tipc_sock *tsk = tipc_sk(sk);
 	int rc, err, hlen, dlen, copy;
+	struct tipc_skb_cb *skb_cb;
 	struct sk_buff_head xmitq;
 	struct tipc_msg *hdr;
 	struct sk_buff *skb;
@@ -1903,6 +1904,7 @@ static int tipc_recvmsg(struct socket *sock, struct msghdr *m,
 		if (unlikely(rc))
 			goto exit;
 		skb = skb_peek(&sk->sk_receive_queue);
+		skb_cb = TIPC_SKB_CB(skb);
 		hdr = buf_msg(skb);
 		dlen = msg_data_sz(hdr);
 		hlen = msg_hdr_sz(hdr);
@@ -1922,18 +1924,33 @@ static int tipc_recvmsg(struct socket *sock, struct msghdr *m,
 
 	/* Capture data if non-error msg, otherwise just set return value */
 	if (likely(!err)) {
-		copy = min_t(int, dlen, buflen);
-		if (unlikely(copy != dlen))
-			m->msg_flags |= MSG_TRUNC;
-		rc = skb_copy_datagram_msg(skb, hlen, m, copy);
+		int offset = skb_cb->bytes_read;
+
+		copy = min_t(int, dlen - offset, buflen);
+		rc = skb_copy_datagram_msg(skb, hlen + offset, m, copy);
+		if (unlikely(rc))
+			goto exit;
+		if (unlikely(offset + copy < dlen)) {
+			if (flags & MSG_EOR) {
+				if (!(flags & MSG_PEEK))
+					skb_cb->bytes_read = offset + copy;
+			} else {
+				m->msg_flags |= MSG_TRUNC;
+				skb_cb->bytes_read = 0;
+			}
+		} else {
+			if (flags & MSG_EOR)
+				m->msg_flags |= MSG_EOR;
+			skb_cb->bytes_read = 0;
+		}
 	} else {
 		copy = 0;
 		rc = 0;
-		if (err != TIPC_CONN_SHUTDOWN && connected && !m->msg_control)
+		if (err != TIPC_CONN_SHUTDOWN && connected && !m->msg_control) {
 			rc = -ECONNRESET;
+			goto exit;
+		}
 	}
-	if (unlikely(rc))
-		goto exit;
 
 	/* Mark message as group event if applicable */
 	if (unlikely(grp_evt)) {
@@ -1956,9 +1973,10 @@ static int tipc_recvmsg(struct socket *sock, struct msghdr *m,
 		tipc_node_distr_xmit(sock_net(sk), &xmitq);
 	}
 
-	tsk_advance_rx_queue(sk);
+	if (!skb_cb->bytes_read)
+		tsk_advance_rx_queue(sk);
 
-	if (likely(!connected))
+	if (likely(!connected) || skb_cb->bytes_read)
 		goto exit;
 
 	/* Send connection flow control advertisement when applicable */
-- 
2.27.0

