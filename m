Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B278469771E
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 08:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233683AbjBOHHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 02:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232704AbjBOHG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 02:06:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE80C3526B;
        Tue, 14 Feb 2023 23:06:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D607AB81F80;
        Wed, 15 Feb 2023 07:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7201C433EF;
        Wed, 15 Feb 2023 07:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676444782;
        bh=zKOEhuFSWo1zV4mRo8HYCnMM9HZkXqk9xsu6VmUYgsU=;
        h=From:To:Cc:Subject:Date:From;
        b=KrFfhXjaZkW1buPnqW7LLv4l1pcBRkCJqp2zdBIurLJIcWqwy3lmo6MJvBmM0rYV8
         KovbfGVI9OexliS/YSniRXEkO0jLNn2AzKK/wfILw3llWylKA/rlZtSFOhCrWMmN1m
         wyLtoPUIgSBhbovW6NDArVfI3eqRrGobOoWMp/UQnbNe1lWer2S/LASEqX+/qtuu4w
         xzKcQScaTKde4VWPLpi86dtHtviadIBA8Y6xLxlj8YAFhkvLPd3Z4xbQIXC+ILr1sc
         IJuNPWa9L6P5iDaMFP3dkzWc5hIKXPlOGisGF8PTTwXAUncRLX3n45Br/prwHQVMB6
         /d4axh3PUgQJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Kelley <mikelley@microsoft.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, davem@davemloft.net, edumazet@google.com,
        Tianyu.Lan@microsoft.com, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 01/93] hv_netvsc: Allocate memory in netvsc_dma_map() with GFP_ATOMIC
Date:   Wed, 15 Feb 2023 02:04:48 -0500
Message-Id: <20230215070620.2718851-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Kelley <mikelley@microsoft.com>

commit c6aa9d3b43cd11ac13a8220368a3b0483c6751d4 upstream.

Memory allocations in the network transmit path must use GFP_ATOMIC
so they won't sleep.

Reported-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/lkml/8a4d08f94d3e6fe8b6da68440eaa89a088ad84f9.camel@redhat.com/
Fixes: 846da38de0e8 ("net: netvsc: Add Isolation VM support for netvsc driver")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/1675714317-48577-1-git-send-email-mikelley@microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hyperv/netvsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index e02d1e3ef672a..79f4e13620a46 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -1034,7 +1034,7 @@ static int netvsc_dma_map(struct hv_device *hv_dev,
 
 	packet->dma_range = kcalloc(page_count,
 				    sizeof(*packet->dma_range),
-				    GFP_KERNEL);
+				    GFP_ATOMIC);
 	if (!packet->dma_range)
 		return -ENOMEM;
 
-- 
2.39.0

