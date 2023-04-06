Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 836706D9549
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 13:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237833AbjDFLcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 07:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237835AbjDFLcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 07:32:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266899EFA;
        Thu,  6 Apr 2023 04:32:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F3756465C;
        Thu,  6 Apr 2023 11:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B761BC433A1;
        Thu,  6 Apr 2023 11:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680780726;
        bh=JYv8anrELkRS2InyKfowv6LTjAw5NsWku3VF0hOAG1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TUm3KHk747drsNPz+Z0buQynVuBAz2heVtesdzfxaXkIilPM390GQsjsEQQar30ZB
         CNCgSIoeD8xdqL9Ptpi/m60PXAzEVIDOdjEV4rgEAZxtOTqsXSjkEctqcb9uyLfMRY
         /bh6sQBcU2s2YuSPjOe8PMgqeJx8VWahD+5g/ne6SB8eV2QusDK4uYU8Fif1rugSU9
         r59twVqy81k//UBRHBqdJCVcNW5InJt3pERxGFSPFclXtCxXh6LNuldlFVn2vtX00S
         g6NukxvPyIGQJYs9UQqgEQL0pEM4bSynpaC3EEZkvy83W2H39DiCJ0F+p0x4ra7/dk
         MjVFjEZpQH22Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Jan Beulich <jbeulich@suse.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, wei.liu@kernel.org,
        paul@xen.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 14/17] xen/netback: use same error messages for same errors
Date:   Thu,  6 Apr 2023 07:31:28 -0400
Message-Id: <20230406113131.648213-14-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113131.648213-1-sashal@kernel.org>
References: <20230406113131.648213-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 2eca98e5b24d01c02b46c67be05a5f98cc9789b1 ]

Issue the same error message in case an illegal page boundary crossing
has been detected in both cases where this is tested.

Suggested-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Link: https://lore.kernel.org/r/20230329080259.14823-1-jgross@suse.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netback/netback.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 5c266062c08f0..c35c085dbc877 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -996,10 +996,8 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 
 		/* No crossing a page as the payload mustn't fragment. */
 		if (unlikely((txreq.offset + txreq.size) > XEN_PAGE_SIZE)) {
-			netdev_err(queue->vif->dev,
-				   "txreq.offset: %u, size: %u, end: %lu\n",
-				   txreq.offset, txreq.size,
-				   (unsigned long)(txreq.offset&~XEN_PAGE_MASK) + txreq.size);
+			netdev_err(queue->vif->dev, "Cross page boundary, txreq.offset: %u, size: %u\n",
+				   txreq.offset, txreq.size);
 			xenvif_fatal_tx_err(queue->vif);
 			break;
 		}
-- 
2.39.2

