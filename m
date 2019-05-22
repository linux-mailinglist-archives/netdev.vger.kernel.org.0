Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3F8C270C5
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729841AbfEVUVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 16:21:23 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51806 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729679AbfEVUVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 16:21:23 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DF13B61706; Wed, 22 May 2019 20:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558556480;
        bh=EYAzGoVUf8AWTf32k+lAUyEBKf4l8OQNm2fLWDi/DvQ=;
        h=From:To:Cc:Subject:Date:From;
        b=SdHIzjdmG5xoE4DOBD16O2pNUl0DZYNktQ4RjFueCobPgks2OAT/wnKQfPyOJH/Ul
         o2l4Q2qlLAB4Ct7WRXtMvUiHx6eWZqWRWvum+emT+ygFUVo3zkPE++I/VPBbaK5Qmi
         z6KrCysy1B54XY1i2W4f4Sc5xen3eq062WDBfaZ4=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 10B5D616F5;
        Wed, 22 May 2019 20:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558556478;
        bh=EYAzGoVUf8AWTf32k+lAUyEBKf4l8OQNm2fLWDi/DvQ=;
        h=From:To:Cc:Subject:Date:From;
        b=dlcWdePs04IjdJ2vx/g9bzaB0+q2rT50hTMeLcj0rGhnPahXMh8nQQVys6zH8lnVk
         CPw/jRgbQ4TpSR9iesFYgk3lYxmuLqol/pbHot32cDFmU5fJLAIoK/z6iuPYVK/pU7
         aDcZD0fJZ/Npbq+Ej3UjJquefTjhzb9d/cvsXEHU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 10B5D616F5
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=subashab@codeaurora.org
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     elder@linaro.org, bjorn.andersson@linaro.org, arnd@arndb.de,
        davem@davemloft.net, netdev@vger.kernel.org
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH net-next] net: qualcomm: rmnet: Move common struct definitions to include
Date:   Wed, 22 May 2019 14:21:07 -0600
Message-Id: <1558556467-12007-1-git-send-email-subashab@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create if_rmnet.h and move the rmnet MAP packet structs to this
common include file. To account for portablity, add little and
big endian bitfield definitions similar to the ip & tcp headers.

The definitions in the headers can now be re-used by the
upcoming ipa driver series as well as qmi_wwan.

Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
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
index 0000000..b4f5403
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
-- 
1.9.1

