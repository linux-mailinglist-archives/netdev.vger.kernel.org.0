Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF991590383
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238294AbiHKQ1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238090AbiHKQ0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:26:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B229A953;
        Thu, 11 Aug 2022 09:08:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6822FB821A0;
        Thu, 11 Aug 2022 16:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFA6C433C1;
        Thu, 11 Aug 2022 16:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234080;
        bh=Uy+4mh7fq5s/fkmzB0vZON08Xp1y4tR+XeLs68k/4ZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rKGMx557PRQ8VUNtlP0T1tdMLyFYPZzo2oxwTU5jqv8dk4UvOZ0+5ugf4rI2yEGAY
         WP5q3nYAU4cCRHBWEbnSZLHVY22dt+CZiwZi8zvTUTOVIJy73PaHefa6Z/erYjpgvy
         /9dZ/TOGRe/etS6elHwV2unApoGSUhaMhivHuj9k0waTkrY3+K4sqkO0REQmiqvC9j
         OqMrlv1jLxu2iuDBmCGePfk4asmnaIMiMBJLj8Wr10Y9SuR+cY3hXH7Nwghx+3B4gX
         ZPALuizdwPvTKF96vFXA7u2aW4530Ezxy5rF79TJdHH7UgDQKYhG+0sLcAITwuf2GX
         SLzR3y00dtOZg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tamas Koczka <poprdi@google.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 39/46] Bluetooth: Collect kcov coverage from hci_rx_work
Date:   Thu, 11 Aug 2022 12:04:03 -0400
Message-Id: <20220811160421.1539956-39-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811160421.1539956-1-sashal@kernel.org>
References: <20220811160421.1539956-1-sashal@kernel.org>
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

From: Tamas Koczka <poprdi@google.com>

[ Upstream commit 9f30de9e0343da05ac621b5817e9b1ce303c6310 ]

Annotate hci_rx_work() with kcov_remote_start() and kcov_remote_stop()
calls, so remote KCOV coverage is collected while processing the rx_q
queue which is the main incoming Bluetooth packet queue.

Coverage is associated with the thread which created the packet skb.

The collected extra coverage helps kernel fuzzing efforts in finding
vulnerabilities.

This change only has effect if the kernel is compiled with CONFIG_KCOV,
otherwise kcov_ functions don't do anything.

Signed-off-by: Tamas Koczka <poprdi@google.com>
Tested-by: Aleksandr Nogikh <nogikh@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 2cb0cf035476..2661a2a7937b 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -29,6 +29,7 @@
 #include <linux/rfkill.h>
 #include <linux/debugfs.h>
 #include <linux/crypto.h>
+#include <linux/kcov.h>
 #include <linux/property.h>
 #include <linux/suspend.h>
 #include <linux/wait.h>
@@ -4909,7 +4910,14 @@ static void hci_rx_work(struct work_struct *work)
 
 	BT_DBG("%s", hdev->name);
 
-	while ((skb = skb_dequeue(&hdev->rx_q))) {
+	/* The kcov_remote functions used for collecting packet parsing
+	 * coverage information from this background thread and associate
+	 * the coverage with the syscall's thread which originally injected
+	 * the packet. This helps fuzzing the kernel.
+	 */
+	for (; (skb = skb_dequeue(&hdev->rx_q)); kcov_remote_stop()) {
+		kcov_remote_start_common(skb_get_kcov_handle(skb));
+
 		/* Send copy to monitor */
 		hci_send_to_monitor(hdev, skb);
 
-- 
2.35.1

