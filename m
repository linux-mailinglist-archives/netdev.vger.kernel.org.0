Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7982585A
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 21:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbfEUTfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 15:35:18 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59188 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727319AbfEUTfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 15:35:18 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9A68560FE9; Tue, 21 May 2019 19:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558467316;
        bh=wVobRjqDk2Ra3DtSo7PlSEXF1UyFgnb7C0immKka05A=;
        h=From:To:Cc:Subject:Date:From;
        b=UHM6DjrlDTFNCZvLjWRQW/TB95EJ+1Rze5djZ6vLKVddrcwkDn41vFsqB6KPh5jpJ
         3m45wGzj8rKNUytXhQ95xI+25cR2c0+fTUGpvjPWqPM3ZGMLIyC1AzFMdCBCpN8efR
         mFJo/fuZBwm/x+1mmCKLYcJpJj1ENSoLCascVoaA=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from subashab-lnx.qualcomm.com (unknown [129.46.15.92])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: subashab@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 22B2E60E7A;
        Tue, 21 May 2019 19:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558467315;
        bh=wVobRjqDk2Ra3DtSo7PlSEXF1UyFgnb7C0immKka05A=;
        h=From:To:Cc:Subject:Date:From;
        b=dpsJ3RpBE6SkjLcJgV7XL/1Q0VN6s2RUDgZDjV0Rl9Vm6ZIJN2ATyXOcP4+mDYItY
         rDNEITO8S2vETRKbHa7fcPI2TbYQAleYgEaoCy7f6xZjd6dQfcgYbNRPhg4GBk4vUc
         YkVaftPYsAWFC04zzLt8ja9bAwX7HCpu4y3P/HsQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 22B2E60E7A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=subashab@codeaurora.org
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     elder@linaro.org, bjorn.andersson@linaro.org, arnd@arndb.de,
        davem@davemloft.net, netdev@vger.kernel.org
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH RFC] net: qualcomm: rmnet: Move common struct definitions to include
Date:   Tue, 21 May 2019 13:35:02 -0600
Message-Id: <1558467302-17072-1-git-send-email-subashab@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create if_rmnet.h and move the rmnet MAP packet structs to this
common include file. To account for portability, add little and
big endian bitfield definitions similar to the ip & tcp headers.

The definitions in the headers can now be re-used by the
upcoming ipa driver series as well as qmi_wwan.

Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
This patch is an alternate implementation of the series posted by Elder.
This eliminates the changes needed in the rmnet packet parsing
while maintaining portability.
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h | 25 +----------
 include/linux/if_rmnet.h                        | 55 +++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 24 deletions(-)
 create mode 100644 include/linux/if_rmnet.h

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
index 884f1f5..991d7e2 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
@@ -12,6 +12,7 @@
 
 #ifndef _RMNET_MAP_H_
 #define _RMNET_MAP_H_
+#include <linux/if_rmnet.h>
 
 struct rmnet_map_control_command {
 	u8  command_name;
@@ -39,30 +40,6 @@ enum rmnet_map_commands {
 	RMNET_MAP_COMMAND_ENUM_LENGTH
 };
 
-struct rmnet_map_header {
-	u8  pad_len:6;
-	u8  reserved_bit:1;
-	u8  cd_bit:1;
-	u8  mux_id;
-	__be16 pkt_len;
-}  __aligned(1);
-
-struct rmnet_map_dl_csum_trailer {
-	u8  reserved1;
-	u8  valid:1;
-	u8  reserved2:7;
-	u16 csum_start_offset;
-	u16 csum_length;
-	__be16 csum_value;
-} __aligned(1);
-
-struct rmnet_map_ul_csum_header {
-	__be16 csum_start_offset;
-	u16 csum_insert_offset:14;
-	u16 udp_ip4_ind:1;
-	u16 csum_enabled:1;
-} __aligned(1);
-
 #define RMNET_MAP_GET_MUX_ID(Y) (((struct rmnet_map_header *) \
 				 (Y)->data)->mux_id)
 #define RMNET_MAP_GET_CD_BIT(Y) (((struct rmnet_map_header *) \
diff --git a/include/linux/if_rmnet.h b/include/linux/if_rmnet.h
new file mode 100644
index 0000000..852a1f68
--- /dev/null
+++ b/include/linux/if_rmnet.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ * Copyright (c) 2013-2019, The Linux Foundation. All rights reserved.
+ */
+
+#ifndef _LINUX_IF_RMNET_H_
+#define _LINUX_IF_RMNET_H_
+
+struct rmnet_map_header {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	u8  pad_len:6;
+	u8  reserved_bit:1;
+	u8  cd_bit:1;
+#elif defined (__BIG_ENDIAN_BITFIELD)
+	u8  cd_bit:1;
+	u8  reserved_bit:1;
+	u8  pad_len:6;
+#else
+#error	"Please fix <asm/byteorder.h>"
+#endif
+	u8  mux_id;
+	__be16 pkt_len;
+}  __aligned(1);
+
+struct rmnet_map_dl_csum_trailer {
+	u8  reserved1;
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	u8  valid:1;
+	u8  reserved2:7;
+#elif defined (__BIG_ENDIAN_BITFIELD)
+	u8  reserved2:7;
+	u8  valid:1;
+#else
+#error	"Please fix <asm/byteorder.h>"
+#endif
+	u16 csum_start_offset;
+	u16 csum_length;
+	__be16 csum_value;
+} __aligned(1);
+
+struct rmnet_map_ul_csum_header {
+	__be16 csum_start_offset;
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	u16 csum_insert_offset:14;
+	u16 udp_ip4_ind:1;
+	u16 csum_enabled:1;
+#elif defined (__BIG_ENDIAN_BITFIELD)
+	u16 csum_enabled:1;
+	u16 udp_ip4_ind:1;
+	u16 csum_insert_offset:14;
+#else
+#error	"Please fix <asm/byteorder.h>"
+#endif
+} __aligned(1);
+
+#endif /* !(_LINUX_IF_RMNET_H_) */
\ No newline at end of file
-- 
1.9.1

