Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1626C572F96
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 09:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234898AbiGMHs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 03:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234872AbiGMHsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 03:48:37 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F35D1A6
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 00:48:32 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4A5DB1FF64;
        Wed, 13 Jul 2022 07:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1657698507; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=0CGUbRqbAXCelWKPuWFUYe6GAN1O07JgHKbKoC7xYHQ=;
        b=Y3ZpLT2lCpW1dP6yPmM2DmZPeTqeyduPSIW9j7irvcpEF7hscExLoibMTUTOBjlVYa6RAN
        MAaMEJuj4PpJQ4LNdRt3ptF4g7VnicAhhhBm76Zc3eTHt/e4GiPFYnOVq6BvrNbHoVFjJD
        0e6RHrT4QQt2etZ/ByOKjGOcAQDVyeM=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EC05313AAD;
        Wed, 13 Jul 2022 07:48:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ueYpOMp4zmKUJQAAMHmgww
        (envelope-from <jgross@suse.com>); Wed, 13 Jul 2022 07:48:26 +0000
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH] xen/netback: handle empty rx queue in xenvif_rx_next_skb()
Date:   Wed, 13 Jul 2022 09:48:23 +0200
Message-Id: <20220713074823.5679-1-jgross@suse.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xenvif_rx_next_skb() is expecting the rx queue not being empty, but
in case the loop in xenvif_rx_action() is doing multiple iterations,
the availability of another skb in the rx queue is not being checked.

This can lead to crashes:

[40072.537261] BUG: unable to handle kernel NULL pointer dereference at 0000000000000080
[40072.537407] IP: xenvif_rx_skb+0x23/0x590 [xen_netback]
[40072.537534] PGD 0 P4D 0
[40072.537644] Oops: 0000 [#1] SMP NOPTI
[40072.537749] CPU: 0 PID: 12505 Comm: v1-c40247-q2-gu Not tainted 4.12.14-122.121-default #1 SLE12-SP5
[40072.537867] Hardware name: HP ProLiant DL580 Gen9/ProLiant DL580 Gen9, BIOS U17 11/23/2021
[40072.537999] task: ffff880433b38100 task.stack: ffffc90043d40000
[40072.538112] RIP: e030:xenvif_rx_skb+0x23/0x590 [xen_netback]
[40072.538217] RSP: e02b:ffffc90043d43de0 EFLAGS: 00010246
[40072.538319] RAX: 0000000000000000 RBX: ffffc90043cd7cd0 RCX: 00000000000000f7
[40072.538430] RDX: 0000000000000000 RSI: 0000000000000006 RDI: ffffc90043d43df8
[40072.538531] RBP: 000000000000003f R08: 000077ff80000000 R09: 0000000000000008
[40072.538644] R10: 0000000000007ff0 R11: 00000000000008f6 R12: ffffc90043ce2708
[40072.538745] R13: 0000000000000000 R14: ffffc90043d43ed0 R15: ffff88043ea748c0
[40072.538861] FS: 0000000000000000(0000) GS:ffff880484600000(0000) knlGS:0000000000000000
[40072.538988] CS: e033 DS: 0000 ES: 0000 CR0: 0000000080050033
[40072.539088] CR2: 0000000000000080 CR3: 0000000407ac8000 CR4: 0000000000040660
[40072.539211] Call Trace:
[40072.539319] xenvif_rx_action+0x71/0x90 [xen_netback]
[40072.539429] xenvif_kthread_guest_rx+0x14a/0x29c [xen_netback]

Fix that by stopping the loop in case the rx queue becomes empty.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/net/xen-netback/rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/xen-netback/rx.c b/drivers/net/xen-netback/rx.c
index dbac4c03d21a..a0335407be42 100644
--- a/drivers/net/xen-netback/rx.c
+++ b/drivers/net/xen-netback/rx.c
@@ -495,6 +495,7 @@ void xenvif_rx_action(struct xenvif_queue *queue)
 	queue->rx_copy.completed = &completed_skbs;
 
 	while (xenvif_rx_ring_slots_available(queue) &&
+	       !skb_queue_empty(&queue->rx_queue) &&
 	       work_done < RX_BATCH_SIZE) {
 		xenvif_rx_skb(queue);
 		work_done++;
-- 
2.35.3

