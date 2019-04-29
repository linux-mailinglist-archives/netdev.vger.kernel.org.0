Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97124E6D6
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 17:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbfD2PrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 11:47:00 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:46930 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728438AbfD2PrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 11:47:00 -0400
Received: by mail-qt1-f193.google.com with SMTP id i31so3698531qti.13
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 08:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rnkflQ/XJBeFPevILnXmOM3g6zUIFFQHb+nxA0Gu9XI=;
        b=Ap/fhL6z0c30bMuCM5TgIe6xDSQb9NdzEkQsfgw0OxsJIjczqMMZs1gxyjMIk9yzoB
         8lsECOtkBKS3z+vKlj2RMOijho0x4T8v/cukaPi/za9Ktjt5KRDfCnPU0ojNH1xAzUVA
         NyQQoZ0LGgOxM/N2VwyQZfTpglMVYMvjvWcKwPuUpHsXE+azamo34aEvT0Q0wGKtd335
         bAyjjl934mWer3I3bjE+NTSpsH6zNhbjwsRh2UccuNaalVVKsHfKObWpXPhJSxyoimVv
         nrtvhY3thsm+CKgvhR6xIgt2P/+IArwE/tTlBEVown65mr76hJOjTYk+TR8sQ9TB1er2
         4L9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rnkflQ/XJBeFPevILnXmOM3g6zUIFFQHb+nxA0Gu9XI=;
        b=GBWGDWuPRv//SSOUk7pkD7z9l1Hxt59nq4LpBKLbFCQON2kXM6dozCib8zwZjfa6MH
         Ao/M6oq5Dp1UoETbiJfV7kgfPjWor+Al/1KFColVMnKmUWqFsPUUYmY2BNmHi64wismC
         fWE10EtYg7J0ZrM2lMx8nu7MZqMARn/k7wzTu1+vTPDywMTue9IEf1aZ1C2yAxIwNHqt
         s6iAICxRCrCB8RqdcjtNfRX+FOhiCunvUlbbAHu5/SP9ENU13UBTrwz+eMgQgUZ+W0AE
         s5R6aBGUAfU7dKdyOxs+4133NSuwL7peVXCYsdZ6++XXgAc+4Fw4pCTgjLEQ+p8qv2dF
         EypQ==
X-Gm-Message-State: APjAAAWqL3yDQInguz9OO5ykkKMgNZhkdFRkumLMx53xcz5/Xqwwfot2
        T3CcFZWSe1spVKvEc8YF+q3OX/Cf
X-Google-Smtp-Source: APXvYqyrSzsYDAXoiVm9/KgPPfj7P5rYQXuRk7L8KARxHH0hV/eGvThGqhwHXKE654BwMjDGqVzH6Q==
X-Received: by 2002:ac8:2f08:: with SMTP id j8mr41204884qta.184.1556552819086;
        Mon, 29 Apr 2019 08:46:59 -0700 (PDT)
Received: from willemb1.nyc.corp.google.com ([2620:0:1003:315:3fa1:a34c:1128:1d39])
        by smtp.gmail.com with ESMTPSA id n66sm15862160qkc.36.2019.04.29.08.46.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 08:46:58 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, David.Laight@aculab.com,
        ebiederm@xmission.com, Willem de Bruijn <willemb@google.com>
Subject: [PATCH net v2] packet: in recvmsg msg_name return at least sizeof sockaddr_ll
Date:   Mon, 29 Apr 2019 11:46:55 -0400
Message-Id: <20190429154655.9141-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Packet send checks that msg_name is at least sizeof sockaddr_ll.
Packet recv must return at least this length, so that its output
can be passed unmodified to packet send.

This ceased to be true since adding support for lladdr longer than
sll_addr. Since, the return value uses true address length.

Always return at least sizeof sockaddr_ll, even if address length
is shorter. Zero the padding bytes.

Change v1->v2: do not overwrite zeroed padding again. use copy_len.

Fixes: 0fb375fb9b93 ("[AF_PACKET]: Allow for > 8 byte hardware addresses.")
Suggested-by: David Laight <David.Laight@aculab.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 net/packet/af_packet.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index e726aaba73b9f..5fe3d75b6212d 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3348,20 +3348,29 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	sock_recv_ts_and_drops(msg, sk, skb);
 
 	if (msg->msg_name) {
+		int copy_len;
+
 		/* If the address length field is there to be filled
 		 * in, we fill it in now.
 		 */
 		if (sock->type == SOCK_PACKET) {
 			__sockaddr_check_size(sizeof(struct sockaddr_pkt));
 			msg->msg_namelen = sizeof(struct sockaddr_pkt);
+			copy_len = msg->msg_namelen;
 		} else {
 			struct sockaddr_ll *sll = &PACKET_SKB_CB(skb)->sa.ll;
 
 			msg->msg_namelen = sll->sll_halen +
 				offsetof(struct sockaddr_ll, sll_addr);
+			copy_len = msg->msg_namelen;
+			if (msg->msg_namelen < sizeof(struct sockaddr_ll)) {
+				memset(msg->msg_name +
+				       offsetof(struct sockaddr_ll, sll_addr),
+				       0, sizeof(sll->sll_addr));
+				msg->msg_namelen = sizeof(struct sockaddr_ll);
+			}
 		}
-		memcpy(msg->msg_name, &PACKET_SKB_CB(skb)->sa,
-		       msg->msg_namelen);
+		memcpy(msg->msg_name, &PACKET_SKB_CB(skb)->sa, copy_len);
 	}
 
 	if (pkt_sk(sk)->auxdata) {
-- 
2.21.0.593.g511ec345e18-goog

