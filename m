Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2F186458C
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 13:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfGJLDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 07:03:35 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:54917 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727030AbfGJLDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 07:03:34 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 10 Jul 2019 14:03:30 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x6AB3US0020650;
        Wed, 10 Jul 2019 14:03:30 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, moshe@mellanox.com, ayal@mellanox.com,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH iproute2 master 2/3] devlink: Fix binary values print
Date:   Wed, 10 Jul 2019 14:03:20 +0300
Message-Id: <1562756601-19171-3-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562756601-19171-1-git-send-email-tariqt@mellanox.com>
References: <1562756601-19171-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Fix function pr_out_binary_value() to start printing the binary buffer
from offset 0 instead of offset 1. Remove redundant new line at the
beginning of the output

Example:
With patch:
 mlx5e_txqsq:
   05 00 00 00 05 00 00 00 01 00 00 00 00 00 00 00
   00 00 00 00 00 00 00 00 8e 6e 3a 13 07 00 00 00
   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
   c0
Without patch
  mlx5e_txqsq:

  00 00 00 05 00 00 00 01 00 00 00 00 00 00 00 00
  00 00 00 00 00 00 00 8e 6e 3a 13 07 00 00 00 00
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 c0

Fixes: 844a61764c6f ("devlink: Add helper functions for name and value separately")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 devlink/devlink.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index e3e1e27ab312..4bced4e60ae8 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -1779,29 +1779,31 @@ static void pr_out_uint64_value(struct dl *dl, uint64_t value)
 		pr_out(" %"PRIu64, value);
 }
 
+static bool is_binary_eol(int i)
+{
+	return !(i%16);
+}
+
 static void pr_out_binary_value(struct dl *dl, uint8_t *data, uint32_t len)
 {
-	int i = 1;
+	int i = 0;
 
 	if (dl->json_output)
 		jsonw_start_array(dl->jw);
-	else
-		pr_out("\n");
 
 	while (i < len) {
-		if (dl->json_output) {
+		if (dl->json_output)
 			jsonw_printf(dl->jw, "%d", data[i]);
-		} else {
-			pr_out(" %02x", data[i]);
-			if (!(i % 16))
-				pr_out("\n");
-		}
+		else
+			pr_out("%02x ", data[i]);
 		i++;
+		if (!dl->json_output && is_binary_eol(i))
+			__pr_out_newline();
 	}
 	if (dl->json_output)
 		jsonw_end_array(dl->jw);
-	else if ((i - 1) % 16)
-		pr_out("\n");
+	else if (!is_binary_eol(i))
+		__pr_out_newline();
 }
 
 static void pr_out_str_value(struct dl *dl, const char *value)
-- 
1.8.3.1

