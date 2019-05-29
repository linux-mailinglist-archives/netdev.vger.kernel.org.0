Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40A7A2D3A0
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 04:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbfE2COc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 22:14:32 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34168 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfE2COb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 22:14:31 -0400
Received: by mail-pf1-f193.google.com with SMTP id n19so554884pfa.1;
        Tue, 28 May 2019 19:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=eibd82PDYGzjDHcvf9kKMO0L4SQdQbd6quNdYGpibfM=;
        b=k72j/tM5Giqi+1CvS28Pmto4rtL65GYTAyQZaiQiVZociIrgV+4rhYE61LAQS/5BF0
         ji+2cmQ5YRlE5icSR75OU0T40TdrlkF75HLZhh7Q0KHABeQWpP2aHNEMgqVt+ag7Gka8
         slw/FuY0VootE8uzvDnC4KlZgD+C1+CXjOVmzXIfKOQ8dY6IDeSsvVzJpodNup+Yb9PF
         68ZkLM8obhQz4+Je0pCLTZKiG1MUvltPN9OhYaLl7BhjoAHuaY18Hijr+DhKa2e8ynaR
         iZgzmK1vh0iezrfEVm9AAWJlBnnkP1CM23ybK5f7WHDfThOjfcIpjHB9ZodKkwE1fCVu
         zcpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=eibd82PDYGzjDHcvf9kKMO0L4SQdQbd6quNdYGpibfM=;
        b=djN+MKLDTZkiRCKzX1S+Sx04uEcKra+FrGVn9OiNY8Y5hUW3Paj2QvKlz++0C2xdY0
         Q+rJmV7Etu7SZpvWdl/89XVzz+bASd3eFHtl2w6toWOWZEk7Wvfj9hBbJlZKeBXt8L12
         qO/m5E75eMkQ9O9nJKZDt4AewlavYHhTVSxIWD/ipKUTyq0dGsLr4a9F8KSbypWdOcJU
         BtpnKu5n/tpxe65pjn1NvMNqjskBfNJZTppZeVu4B16GIuiBtwTwly3TAgKDL0Y5iEws
         S0f3szAttC8/QB1sALs+rnSA5CETZJaBoytSp0JYrzljcxudKyIzcUnJEfmz+g5AiEPs
         wSxg==
X-Gm-Message-State: APjAAAUq5h/7ZQQPZMRJehbKvXMPmw7DcF7Iui6Cxx/xMYl45jK4xZAw
        owustf9D3nX+mdLNmxB1XUc=
X-Google-Smtp-Source: APXvYqyBsBONvrPCzpGFfP8/a/GfBRbtaVlnB6/6M9FXkCxG7un0Wp+FJI4Bj9fcqaSzr5Hl9EDQDw==
X-Received: by 2002:a63:1b0e:: with SMTP id b14mr25084443pgb.365.1559096071272;
        Tue, 28 May 2019 19:14:31 -0700 (PDT)
Received: from xy-data.openstacklocal (ecs-159-138-22-150.compute.hwclouds-dns.com. [159.138.22.150])
        by smtp.gmail.com with ESMTPSA id e8sm4738669pgj.2.2019.05.28.19.14.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 28 May 2019 19:14:30 -0700 (PDT)
From:   Young Xiao <92siuyang@gmail.com>
To:     ecree@solarflare.com, mhabets@solarflare.com, davem@davemloft.net,
        fw@strlen.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Young Xiao <92siuyang@gmail.com>
Subject: [PATCH] falcon: pass valid pointer from ef4_enqueue_unwind.
Date:   Wed, 29 May 2019 10:15:39 +0800
Message-Id: <1559096139-25698-1-git-send-email-92siuyang@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bytes_compl and pkts_compl pointers passed to ef4_dequeue_buffers
cannot be NULL. Add a paranoid warning to check this condition and fix
the one case where they were NULL.

Signed-off-by: Young Xiao <92siuyang@gmail.com>
---
 drivers/net/ethernet/sfc/falcon/tx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/falcon/tx.c b/drivers/net/ethernet/sfc/falcon/tx.c
index c5059f4..ed89bc6 100644
--- a/drivers/net/ethernet/sfc/falcon/tx.c
+++ b/drivers/net/ethernet/sfc/falcon/tx.c
@@ -69,6 +69,7 @@ static void ef4_dequeue_buffer(struct ef4_tx_queue *tx_queue,
 	}
 
 	if (buffer->flags & EF4_TX_BUF_SKB) {
+		EF4_WARN_ON_PARANOID(!pkts_compl || !bytes_compl);
 		(*pkts_compl)++;
 		(*bytes_compl) += buffer->skb->len;
 		dev_consume_skb_any((struct sk_buff *)buffer->skb);
@@ -271,12 +272,14 @@ static int ef4_tx_map_data(struct ef4_tx_queue *tx_queue, struct sk_buff *skb)
 static void ef4_enqueue_unwind(struct ef4_tx_queue *tx_queue)
 {
 	struct ef4_tx_buffer *buffer;
+	unsigned int bytes_compl = 0;
+	unsigned int pkts_compl = 0;
 
 	/* Work backwards until we hit the original insert pointer value */
 	while (tx_queue->insert_count != tx_queue->write_count) {
 		--tx_queue->insert_count;
 		buffer = __ef4_tx_queue_get_insert_buffer(tx_queue);
-		ef4_dequeue_buffer(tx_queue, buffer, NULL, NULL);
+		ef4_dequeue_buffer(tx_queue, buffer, &pkts_compl, &bytes_compl);
 	}
 }
 
-- 
2.7.4

