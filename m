Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631044F6289
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 17:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235475AbiDFPFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235586AbiDFPFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:05:17 -0400
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9380F8443
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 04:55:56 -0700 (PDT)
Received: by mail-pg1-f170.google.com with SMTP id d185so1963746pgc.13
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 04:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4++eNCxtKqRX8gh1V4vVECxQ8shO4YyrKKIugHCp4UM=;
        b=buI0RaeJ8PPKpYmzACr+RSufvG5aoBJOYMUYukXKVc+wNnf9TXxtskyCmYHV6CLmKP
         i6mHoyXaeS2FPlddjMrmFxd81ifI46qaMtJaCma35GBdSTwLUPV1SMozY8ftxiW7Uo1T
         ia5M7Yhoj+MdoGBR2/eiiL8gzxDdyIWE8//Sr0ElM5IXZNT87JYM1EQMcLBx9GsNEneB
         Fq6TjJHRcfYBWeDg3ZCay/gxcwr0I+vXOyUMnC+4RAENt3gkwQ5bnL1aeYaVTx7PH6Bw
         7TNiVy6wo5c9x9bCzaKAacbZ/T/GAoRiK0OzBDiuxY4h/YPizmbPwwELg+u1T2foLLMc
         fteQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4++eNCxtKqRX8gh1V4vVECxQ8shO4YyrKKIugHCp4UM=;
        b=JrlxsxAHKFODkPWxSW/+dWZ8B1vXAkac53GU6B1H4bOcvfRMdqcIMYHJ8gArHLi2xv
         zsl0Xyxxo+wDmtRL1QAD2TcBV8fmJU3MG7lNKW347/V12+TJvoAs86W6nvrsqFPjoejh
         FTP32U9ff+W+ZFZF9blnCU6zU9AAMvF8RNsULICvX7Nn6WozaYVj5XyfSC6I6qPTQTXs
         prMfl0hxLDATKIuHUuQuxBhbYTiHr/pc7X8AJ/A8AAqDDp30juZi238LMZByfGNZWDm6
         r46nc+gPvuBZoN7PqNZ43aILmhdwnbqQeefVPCl6016Me9MG43zBLIqI3UEW0+wonjtK
         ob+w==
X-Gm-Message-State: AOAM533GJvkq2WcsfLh0+zKmr7CK7kNf4+qbbhP3FMJz8E5GT/cbL/zz
        Ks9B9l2stXAMya7jE9DdBKw=
X-Google-Smtp-Source: ABdhPJzgJ7s88d9M9teatbRe2jj1m6kMIbq7KctuSswjwg7mHtSJ/OhxkTTrv9nIJSo6AZpgitT98g==
X-Received: by 2002:a63:b555:0:b0:398:4ca1:4be0 with SMTP id u21-20020a63b555000000b003984ca14be0mr6721514pgo.294.1649245767758;
        Wed, 06 Apr 2022 04:49:27 -0700 (PDT)
Received: from localhost.localdomain ([223.104.68.74])
        by smtp.gmail.com with ESMTPSA id j2-20020a17090a588200b001ca37c215aasm5477689pji.2.2022.04.06.04.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 04:49:27 -0700 (PDT)
From:   lianglixue <lixue.liang5086@gmail.com>
X-Google-Original-From: lianglixue <lianglixue@greatwall.com.cn>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     edumazet@google.com, pablo@netfilter.org, rsanger@wand.net.nz,
        yajun.deng@linux.dev, jiapeng.chong@linux.alibaba.com,
        netdev@vger.kernel.org, lianglixue <lianglixue@greatwall.com.cn>
Subject: [PATCH] af_packet: fix efficiency issues in packet_read_pending
Date:   Wed,  6 Apr 2022 11:48:07 +0000
Message-Id: <20220406114807.1803-1-lianglixue@greatwall.com.cn>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In packet_read_pengding, even if the pending_refcnt of the first CPU
is not 0, the pending_refcnt of all CPUs will be traversed,
and the long delay of cross-cpu access in NUMA significantly reduces
the performance of packet sending; especially in tpacket_destruct_skb.

When pending_refcnt is not 0, it returns without counting the number of
all pending packets, which significantly reduces the traversal time.

Signed-off-by: lianglixue <lianglixue@greatwall.com.cn>
---
 net/packet/af_packet.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index c39c09899fd0..c04f49e44a33 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1210,17 +1210,18 @@ static void packet_dec_pending(struct packet_ring_buffer *rb)
 
 static unsigned int packet_read_pending(const struct packet_ring_buffer *rb)
 {
-	unsigned int refcnt = 0;
 	int cpu;
 
 	/* We don't use pending refcount in rx_ring. */
 	if (rb->pending_refcnt == NULL)
 		return 0;
 
-	for_each_possible_cpu(cpu)
-		refcnt += *per_cpu_ptr(rb->pending_refcnt, cpu);
+	for_each_possible_cpu(cpu) {
+		if (*per_cpu_ptr(rb->pending_refcnt, cpu) != 0)
+			return 1;
+	}
 
-	return refcnt;
+	return 0;
 }
 
 static int packet_alloc_pending(struct packet_sock *po)
-- 
2.27.0

