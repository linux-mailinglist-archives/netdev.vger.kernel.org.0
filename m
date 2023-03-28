Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF676CC057
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 15:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbjC1NNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 09:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232952AbjC1NNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 09:13:05 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1268A62;
        Tue, 28 Mar 2023 06:13:04 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E146221A25;
        Tue, 28 Mar 2023 13:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680009182; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YW7EQFAaSbV1XiZ+rWOC33Mh7NdDO+nn7h2JPqjxGsU=;
        b=O/kjrp9uwhaX0UHcxnMEsib0oNTmVBstScUxSKkHjVOFyAM6ud1RCyuekMkZ36jQpPD1ZR
        DM6toj/Ixa4HrtnnqRELqKdV5fzFX7Xh5gXJKbQgznCMyUK/eCvzYBpBmemN5d0MS02eho
        LyrmFwNOmbYVjCPAQEH2c0kPLjUJMZE=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 98ADC1390D;
        Tue, 28 Mar 2023 13:13:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id bIYXJN7nImRBTgAAMHmgww
        (envelope-from <jgross@suse.com>); Tue, 28 Mar 2023 13:13:02 +0000
From:   Juergen Gross <jgross@suse.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        xen-devel@lists.xenproject.org, Jan Beulich <jbeulich@suse.com>
Subject: [PATCH v2 2/3] xen/netback: remove not needed test in xenvif_tx_build_gops()
Date:   Tue, 28 Mar 2023 15:12:32 +0200
Message-Id: <20230328131233.2534-3-jgross@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230328131047.2440-1-jgross@suse.com>
References: <20230328131047.2440-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tests for the number of grant mapping or copy operations reaching
the array size of the operations buffer at the end of the main loop in
xenvif_tx_build_gops() isn't needed.

The loop can handle at maximum MAX_PENDING_REQS transfer requests, as
XEN_RING_NR_UNCONSUMED_REQUESTS() is taking unsent responses into
consideration, too.

Remove the tests.

Suggested-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Paul Durrant <paul@xen.org>
---
 drivers/net/xen-netback/netback.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 54c76af90233..9ca4b69d3b39 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1084,10 +1084,6 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 		__skb_queue_tail(&queue->tx_queue, skb);
 
 		queue->tx.req_cons = idx;
-
-		if ((*map_ops >= ARRAY_SIZE(queue->tx_map_ops)) ||
-		    (*copy_ops >= ARRAY_SIZE(queue->tx_copy_ops)))
-			break;
 	}
 
 	return;
-- 
2.35.3

