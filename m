Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16E0488BB4
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 19:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236548AbiAISl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 13:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiAISl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 13:41:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5F0C06173F
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 10:41:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85A73B80972
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 18:41:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB456C36AE3;
        Sun,  9 Jan 2022 18:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641753714;
        bh=1EuyKRHEdzaJhuoMNSPeeWtgWcDybm1uJfxGcCWntgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HyPQ6s/0TI2CJsHvZmh1klFysE9kI/q9bKRLIOFstcL0BhJSeFg8UC3F4fQw1Ckxg
         OpIFwEvaZCpWWktNjwj40y2ZYnrAt1XKCV9uoT5a1wjKYDt6aU5vgX1ayJ7rPmYRse
         CTxyAxTtGpIIGwsjd1O0PKR/tFna2VmLrQEVuxLx9+ZYFT6dO82em5ChX8Zk504D6J
         zIitJ1A3vk+rZwA+d6KSH5c6iJBFrBYV1SxRa80KOqjenTExBrruB8JcDpDbWZkl55
         xyiyiry0JfVfxmxqRhY6Rf3kN5Y/ed35EaMcooiVwxrYvgEmhdlBRKxzHyiSH05XPg
         0jYjE/Un1PJRQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 2/2] rdma: Don't allocate sparse array
Date:   Sun,  9 Jan 2022 20:41:39 +0200
Message-Id: <563d48b520713634b633bc859a8f87b73181a043.1641753491.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1641753491.git.leonro@nvidia.com>
References: <cover.1641753491.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The addition of driver QP type with index 0xFF caused to the following
clang compilation error:

res.c:152:10: warning: result of comparison of constant 256 with expression of type 'uint8_t' (aka 'unsigned char') is always true [-Wtautological-constant-out-of-range-compare]
        if (idx < ARRAY_SIZE(qp_types_str) && qp_types_str[idx])
            ~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~

Instead of allocating very sparse array, simply create separate check
for the driver QP type.

Fixes: 39307384cea7 ("rdma: Add driver QP type string")
Reported-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 rdma/res.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/rdma/res.c b/rdma/res.c
index 9aae5d4b..21fef9bd 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -146,12 +146,12 @@ const char *qp_types_to_str(uint8_t idx)
 						     "RAW_ETHERTYPE",
 						     "UNKNOWN", "RAW_PACKET",
 						     "XRC_INI", "XRC_TGT",
-						     [0xFF] = "DRIVER",
 	};
 
-	if (idx < ARRAY_SIZE(qp_types_str) && qp_types_str[idx])
+	if (idx < ARRAY_SIZE(qp_types_str))
 		return qp_types_str[idx];
-	return "UNKNOWN";
+
+	return (idx == 0xFF) ? "DRIVER" : "UNKNOWN";
 }
 
 void print_comm(struct rd *rd, const char *str, struct nlattr **nla_line)
-- 
2.33.1

