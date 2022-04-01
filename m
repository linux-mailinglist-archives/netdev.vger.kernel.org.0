Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB0A94EF641
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345795AbiDAPcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 11:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348399AbiDAO4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:56:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D874AC337D;
        Fri,  1 Apr 2022 07:44:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4581B8240E;
        Fri,  1 Apr 2022 14:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338C7C3410F;
        Fri,  1 Apr 2022 14:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824239;
        bh=H9GmwK+B63pcrmYuNjENxKmlouwAu7ZViJydwDwFh7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fkMR5sRuJzYJF8Ybo0bg1p7pd9nd5FEGnEBMYvkZSaXR+foOdZplA049OLB3H4zr4
         ss4jT05rClIm7YPRh7m/IFXRWoySkAhxSX9aO6iYESJ2gBzvNoEQdNoMTbjhRAsHgc
         D/vkK5x+RXYQBYGdpuvT0EBxnBFbdDS556QQI/yOBAhFdiQHHbvwVBTXgpUW3ofOvr
         /Lw5fKuwSipNmnIfBaJ1G11ulJkdSZC/zoznjdnEADJKdFqLxRzJ/xxNG0qBxDrsgx
         k5hEeKGLHyZuIUHq2qH0P79JRwFNDt5/qzoPE9d6EF/BMBfkvr2Xa7c40+qx/DhyL6
         bd91z1/vUElHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 46/65] Bluetooth: Fix not checking for valid hdev on bt_dev_{info,warn,err,dbg}
Date:   Fri,  1 Apr 2022 10:41:47 -0400
Message-Id: <20220401144206.1953700-46-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144206.1953700-1-sashal@kernel.org>
References: <20220401144206.1953700-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 9b392e0e0b6d026da5a62bb79a08f32e27af858e ]

This fixes attemting to print hdev->name directly which causes them to
print an error:

kernel: read_version:367: (efault): sock 000000006a3008f2

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/bluetooth.h | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
index 9125effbf448..3fecc4a411a1 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -180,19 +180,21 @@ void bt_err_ratelimited(const char *fmt, ...);
 #define BT_DBG(fmt, ...)	pr_debug(fmt "\n", ##__VA_ARGS__)
 #endif
 
+#define bt_dev_name(hdev) ((hdev) ? (hdev)->name : "null")
+
 #define bt_dev_info(hdev, fmt, ...)				\
-	BT_INFO("%s: " fmt, (hdev)->name, ##__VA_ARGS__)
+	BT_INFO("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
 #define bt_dev_warn(hdev, fmt, ...)				\
-	BT_WARN("%s: " fmt, (hdev)->name, ##__VA_ARGS__)
+	BT_WARN("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
 #define bt_dev_err(hdev, fmt, ...)				\
-	BT_ERR("%s: " fmt, (hdev)->name, ##__VA_ARGS__)
+	BT_ERR("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
 #define bt_dev_dbg(hdev, fmt, ...)				\
-	BT_DBG("%s: " fmt, (hdev)->name, ##__VA_ARGS__)
+	BT_DBG("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
 
 #define bt_dev_warn_ratelimited(hdev, fmt, ...)			\
-	bt_warn_ratelimited("%s: " fmt, (hdev)->name, ##__VA_ARGS__)
+	bt_warn_ratelimited("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
 #define bt_dev_err_ratelimited(hdev, fmt, ...)			\
-	bt_err_ratelimited("%s: " fmt, (hdev)->name, ##__VA_ARGS__)
+	bt_err_ratelimited("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
 
 /* Connection and socket states */
 enum {
-- 
2.34.1

