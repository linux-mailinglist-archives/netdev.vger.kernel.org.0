Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0667B5379F7
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 13:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235873AbiE3LfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 07:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235902AbiE3LfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 07:35:05 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6288022E;
        Mon, 30 May 2022 04:35:03 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D410E21B63;
        Mon, 30 May 2022 11:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1653910501; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=VtWEzLh+t2xI23/ZsFZwEDqX/MxDCN5dV6zj7JYIqG0=;
        b=XehnlzPLjv36KTNOB9J4ShMSmsMYHbhrrdLdVbWTzeBLyw+C7WdzQRfn0FE4QjFefjXu+V
        9LpbUM5fdnYDbmN8XOeZr5O/vfu9gTM3n57PlUU7GaV/dDb35M/Sxs+tvFZQ772zKoJ726
        nP0Rlld/SRDHZdIltFFXqS4Qj1FkTfk=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 86F9213A84;
        Mon, 30 May 2022 11:35:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id NmJ9H+WrlGLPdQAAMHmgww
        (envelope-from <jgross@suse.com>); Mon, 30 May 2022 11:35:01 +0000
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH] xen/netback: fix incorrect usage of RING_HAS_UNCONSUMED_REQUESTS()
Date:   Mon, 30 May 2022 13:34:59 +0200
Message-Id: <20220530113459.20124-1-jgross@suse.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 6fac592cca60 ("xen: update ring.h") missed to fix one use case
of RING_HAS_UNCONSUMED_REQUESTS().

Reported-by: Jan Beulich <jbeulich@suse.com>
Fixes: 6fac592cca60 ("xen: update ring.h")
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/net/xen-netback/netback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 0f7fd159f0f2..d93814c14a23 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -828,7 +828,7 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 			break;
 		}
 
-		work_to_do = RING_HAS_UNCONSUMED_REQUESTS(&queue->tx);
+		work_to_do = XEN_RING_NR_UNCONSUMED_REQUESTS(&queue->tx);
 		if (!work_to_do)
 			break;
 
-- 
2.35.3

