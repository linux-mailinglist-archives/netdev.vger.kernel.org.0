Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C48C59026A
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237445AbiHKQJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236038AbiHKQI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:08:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABED9BC126;
        Thu, 11 Aug 2022 08:54:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F22F1601BF;
        Thu, 11 Aug 2022 15:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66594C433D7;
        Thu, 11 Aug 2022 15:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233280;
        bh=Xg3DBDFRFXURZ+CgVCEjrxSz6WjnC3NCp6z6g6F19W8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oxRGqpnTyz3bEPP+GTTaynGWGt4AuC0lNLvlljU7cFBD9915+MsLB7Rmh3EQIK6cP
         3PbK//EEUldE7KOV+VK02h+vIwxIeiA11Qfr1UtY5slHHn6YYKm9Nn8E4YjKOrA6Zt
         uPnznInwUZeDnfo/hEYH4LRuwH2p3QOuVg7FgVImaDT+TtbBPZTSBSjk6nST+Xns63
         cKMja8S4BN+kpeOQm487hzpKpa+YRcVlYhZ0k2pcXgm6fGn1n7hNyYzsVKYcyHo3mX
         A38cy/GB6Aouy5DYoCbFVBzhICc7N9r3JKY9Jxej3kbinQC1KPzDd62rW/RKgJ5ufv
         d0InjaN5WKkeA==
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
Subject: [PATCH AUTOSEL 5.18 75/93] Bluetooth: Collect kcov coverage from hci_rx_work
Date:   Thu, 11 Aug 2022 11:42:09 -0400
Message-Id: <20220811154237.1531313-75-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
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
index 19df3905c5f8..a78f0ef7bbdc 100644
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
@@ -3780,7 +3781,14 @@ static void hci_rx_work(struct work_struct *work)
 
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

