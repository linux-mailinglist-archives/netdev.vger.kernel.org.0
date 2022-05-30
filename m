Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8E45382D7
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239267AbiE3O2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 10:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240302AbiE3OZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 10:25:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332E4A88AA;
        Mon, 30 May 2022 06:50:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3155E60FDC;
        Mon, 30 May 2022 13:50:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 761D1C3411C;
        Mon, 30 May 2022 13:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918652;
        bh=btq8rGeFsERr+agkyBJfvYQq6qyKxnfz/CGUWhG9Irs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h5ztGshOZ7zHYhAg7mdNGbFvn3hktYOXMAamSYagYhVzgD9tBK07c6WMj+o62lH/z
         9G3f8SXvEF4FG0UpgNzorarvWq5gJQoL899fRRDRdS9/nNuP9V+Y7KpSdzVHnuTj4S
         LUO6lK812UsjQeSrHwgI8T8gd07r2vUI9NV4OAi7JfWYtLkKbNpMZEtal49Y6gWQJm
         zE3ziqWOSMPa6O77LGeb3M1iJwN4zv+mLiwvgl4Q6IA1xZk6+XFpE8qnOKcA7NeO8S
         GEuu4vd7GogRuX2/dtx+s6Fwd5qqXQjm2GvbKFtc+qLIVzEOTHcGBhipY12JZbhT4Z
         WRFNjfpoypryQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 37/38] rxrpc: Return an error to sendmsg if call failed
Date:   Mon, 30 May 2022 09:49:23 -0400
Message-Id: <20220530134924.1936816-37-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134924.1936816-1-sashal@kernel.org>
References: <20220530134924.1936816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 4ba68c5192554876bd8c3afd904e3064d2915341 ]

If at the end of rxrpc sendmsg() or rxrpc_kernel_send_data() the call that
was being given data was aborted remotely or otherwise failed, return an
error rather than returning the amount of data buffered for transmission.

The call (presumably) did not complete, so there's not much point
continuing with it.  AF_RXRPC considers it "complete" and so will be
unwilling to do anything else with it - and won't send a notification for
it, deeming the return from sendmsg sufficient.

Not returning an error causes afs to incorrectly handle a StoreData
operation that gets interrupted by a change of address due to NAT
reconfiguration.

This doesn't normally affect most operations since their request parameters
tend to fit into a single UDP packet and afs_make_call() returns before the
server responds; StoreData is different as it involves transmission of a
lot of data.

This can be triggered on a client by doing something like:

	dd if=/dev/zero of=/afs/example.com/foo bs=1M count=512

at one prompt, and then changing the network address at another prompt,
e.g.:

	ifconfig enp6s0 inet 192.168.6.2 && route add 192.168.6.1 dev enp6s0

Tracing packets on an Auristor fileserver looks something like:

192.168.6.1 -> 192.168.6.3  RX 107 ACK Idle  Seq: 0  Call: 4  Source Port: 7000  Destination Port: 7001
192.168.6.3 -> 192.168.6.1  AFS (RX) 1482 FS Request: Unknown(64538) (64538)
192.168.6.3 -> 192.168.6.1  AFS (RX) 1482 FS Request: Unknown(64538) (64538)
192.168.6.1 -> 192.168.6.3  RX 107 ACK Idle  Seq: 0  Call: 4  Source Port: 7000  Destination Port: 7001
<ARP exchange for 192.168.6.2>
192.168.6.2 -> 192.168.6.1  AFS (RX) 1482 FS Request: Unknown(0) (0)
192.168.6.2 -> 192.168.6.1  AFS (RX) 1482 FS Request: Unknown(0) (0)
192.168.6.1 -> 192.168.6.2  RX 107 ACK Exceeds Window  Seq: 0  Call: 4  Source Port: 7000  Destination Port: 7001
192.168.6.1 -> 192.168.6.2  RX 74 ABORT  Seq: 0  Call: 4  Source Port: 7000  Destination Port: 7001
192.168.6.1 -> 192.168.6.2  RX 74 ABORT  Seq: 29321  Call: 4  Source Port: 7000  Destination Port: 7001

The Auristor fileserver logs code -453 (RXGEN_SS_UNMARSHAL), but the abort
code received by kafs is -5 (RX_PROTOCOL_ERROR) as the rx layer sees the
condition and generates an abort first and the unmarshal error is a
consequence of that at the application layer.

Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-afs@lists.infradead.org
Link: http://lists.infradead.org/pipermail/linux-afs/2021-December/004810.html # v1
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/sendmsg.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index edd76c41765f..0220a2935002 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -440,6 +440,12 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 
 success:
 	ret = copied;
+	if (READ_ONCE(call->state) == RXRPC_CALL_COMPLETE) {
+		read_lock_bh(&call->state_lock);
+		if (call->error < 0)
+			ret = call->error;
+		read_unlock_bh(&call->state_lock);
+	}
 out:
 	call->tx_pending = skb;
 	_leave(" = %d", ret);
-- 
2.35.1

