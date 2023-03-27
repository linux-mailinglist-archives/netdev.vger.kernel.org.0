Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F290A6C9E51
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 10:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232704AbjC0IlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 04:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233152AbjC0Ikf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 04:40:35 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1FE6A76;
        Mon, 27 Mar 2023 01:37:01 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8FDA81F8A8;
        Mon, 27 Mar 2023 08:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1679906220; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BYwAGMe1PfAGydSVqlgv0hiTKV8LxJz7Cfr4pQvks4M=;
        b=pnRmRrpElIfOGh45HyDbGyTLv5HE1XJiCA+hgB75qnV0jL4KSVd4BTS/HMLMTgZ6vr5c/q
        EW2BxF/x9H47o/NyMlbMwkvnqPLcy3SN0f4vddtVKFgShfc+EvOgYvcl9QnYQkD2CuiNrS
        8JiD6T2Fu41dFmCAKBsZ2kYeG2PvttU=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3D0B913329;
        Mon, 27 Mar 2023 08:37:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id rNmIDaxVIWS+SAAAMHmgww
        (envelope-from <jgross@suse.com>); Mon, 27 Mar 2023 08:37:00 +0000
From:   Juergen Gross <jgross@suse.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        xen-devel@lists.xenproject.org, Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 2/2] xen/netback: remove not needed test in xenvif_tx_build_gops()
Date:   Mon, 27 Mar 2023 10:36:46 +0200
Message-Id: <20230327083646.18690-3-jgross@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230327083646.18690-1-jgross@suse.com>
References: <20230327083646.18690-1-jgross@suse.com>
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
---
 drivers/net/xen-netback/netback.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 111c179f161b..4943be4fd99d 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1082,10 +1082,6 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
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

