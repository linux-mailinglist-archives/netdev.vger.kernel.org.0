Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82CB36526B7
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 20:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbiLTTAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 14:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234012AbiLTTAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 14:00:20 -0500
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B60C1DF39
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 11:00:11 -0800 (PST)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-1445ca00781so16546308fac.1
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 11:00:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JXYLTDkptpPzYOrGeGF4jhqPDZLV+o0bhBUVOjDZSsg=;
        b=pxW2qrad7LK/jLVrTk4AYMqzTPaxs5aGJAEdNvhoIOE1AgjiRdGsHgh8cedV8aW7de
         dnXAAyaPgKaQgSG0lS9SKAGrwS4h2jo/bxG1a4RWijZ4EqkeqUFEWsBN0Q/CmQuudGUi
         lA4et4hM1rIHh50Oznu5fMHelWe/drgH3SvPQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JXYLTDkptpPzYOrGeGF4jhqPDZLV+o0bhBUVOjDZSsg=;
        b=0G5PMo/pxNYl5EpdhEEahbRUNUDUE7fiCZWTD0VCr+DZKZiZh/HQc5V1o7dX1VkfVC
         1ezds8vbo4AxGd/2WkZQ2FOQ0BZ6ZPyoz8wFz61YwRdCo/cYuJktno74elLl775IysbM
         m5Yim6+M+6Q3EaF4nkoAMULRcri3VkaMeSlcIrBi8uRX04qJ9oYvaqQYChAAdG8aMocW
         4Vi9vsGsgNFyrDDfT3UCLTRy+wE0IBwuKwI0dK55o3h4AKsXT+XyEq3P6wRr3Wu89Iek
         YEcinnzYHcNi8ps4AHVxb6npbrQwF+JRwfDW3Crq/YK0SwAykL+L7XUNz1QgCdRMZv3L
         7LNw==
X-Gm-Message-State: ANoB5pmis3enJrEkd9IVKhgptwiHtIZkDpAn5v5obWFuoY2zn+JK/+zH
        m/rA+9givG6dr3Tb6NzqgpN1iQ==
X-Google-Smtp-Source: AA0mqf7wIvQPmpVJgp1NF721D7EsiJnRJvoP98EoiFJU+6lKd376dW5acXZRl7qHG4BwDonwQEmLQQ==
X-Received: by 2002:a05:6870:f59d:b0:141:f39c:bd2a with SMTP id eh29-20020a056870f59d00b00141f39cbd2amr24434823oab.21.1671562810567;
        Tue, 20 Dec 2022 11:00:10 -0800 (PST)
Received: from sbohrer-cf-dell.. ([24.28.97.120])
        by smtp.gmail.com with ESMTPSA id s8-20020a4adb88000000b0049f3f5afcbasm5331103oou.13.2022.12.20.11.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 11:00:09 -0800 (PST)
From:   Shawn Bohrer <sbohrer@cloudflare.com>
To:     magnus.karlsson@gmail.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, bjorn@kernel.org,
        kernel-team@cloudflare.com, davem@davemloft.net,
        Shawn Bohrer <sbohrer@cloudflare.com>
Subject: [PATCH] veth: Fix race with AF_XDP exposing old or uninitialized descriptors
Date:   Tue, 20 Dec 2022 12:59:03 -0600
Message-Id: <20221220185903.1105011-1-sbohrer@cloudflare.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <Y5pO+XL54ZlzZ7Qe@sbohrer-cf-dell>
References: <Y5pO+XL54ZlzZ7Qe@sbohrer-cf-dell>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When AF_XDP is used on on a veth interface the RX ring is updated in two
steps.  veth_xdp_rcv() removes packet descriptors from the FILL ring
fills them and places them in the RX ring updating the cached_prod
pointer.  Later xdp_do_flush() syncs the RX ring prod pointer with the
cached_prod pointer allowing user-space to see the recently filled in
descriptors.  The rings are intended to be SPSC, however the existing
order in veth_poll allows the xdp_do_flush() to run concurrently with
another CPU creating a race condition that allows user-space to see old
or uninitialized descriptors in the RX ring.  This bug has been observed
in production systems.

To summarize, we are expecting this ordering:

CPU 0 __xsk_rcv_zc()
CPU 0 __xsk_map_flush()
CPU 2 __xsk_rcv_zc()
CPU 2 __xsk_map_flush()

But we are seeing this order:

CPU 0 __xsk_rcv_zc()
CPU 2 __xsk_rcv_zc()
CPU 0 __xsk_map_flush()
CPU 2 __xsk_map_flush()

This occurs because we rely on NAPI to ensure that only one napi_poll
handler is running at a time for the given veth receive queue.
napi_schedule_prep() will prevent multiple instances from getting
scheduled. However calling napi_complete_done() signals that this
napi_poll is complete and allows subsequent calls to
napi_schedule_prep() and __napi_schedule() to succeed in scheduling a
concurrent napi_poll before the xdp_do_flush() has been called.  For the
veth driver a concurrent call to napi_schedule_prep() and
__napi_schedule() can occur on a different CPU because the veth xmit
path can additionally schedule a napi_poll creating the race.

The fix as suggested by Magnus Karlsson, is to simply move the
xdp_do_flush() call before napi_complete_done().  This syncs the
producer ring pointers before another instance of napi_poll can be
scheduled on another CPU.  It will also slightly improve performance by
moving the flush closer to when the descriptors were placed in the
RX ring.

Fixes: d1396004dd86 ("veth: Add XDP TX and REDIRECT")
Suggested-by: Magnus Karlsson <magnus.karlsson@gmail.com>
Signed-off-by: Shawn Bohrer <sbohrer@cloudflare.com>
---
 drivers/net/veth.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index ac7c0653695f..dfc7d87fad59 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -974,6 +974,9 @@ static int veth_poll(struct napi_struct *napi, int budget)
 	xdp_set_return_frame_no_direct();
 	done = veth_xdp_rcv(rq, budget, &bq, &stats);
 
+	if (stats.xdp_redirect > 0)
+		xdp_do_flush();
+
 	if (done < budget && napi_complete_done(napi, done)) {
 		/* Write rx_notify_masked before reading ptr_ring */
 		smp_store_mb(rq->rx_notify_masked, false);
@@ -987,8 +990,6 @@ static int veth_poll(struct napi_struct *napi, int budget)
 
 	if (stats.xdp_tx > 0)
 		veth_xdp_flush(rq, &bq);
-	if (stats.xdp_redirect > 0)
-		xdp_do_flush();
 	xdp_clear_return_frame_no_direct();
 
 	return done;
-- 
2.38.1

