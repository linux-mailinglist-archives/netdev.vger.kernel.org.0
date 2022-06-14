Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC5554B14F
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 14:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243407AbiFNMhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 08:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236681AbiFNMfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 08:35:48 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E344E3B8
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:33:36 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id o7so16895466eja.1
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ftTUQdWQygkzM3mVimTjsLVWTRYC3XiJQvXkTntLJtw=;
        b=hz2oXufWR36FzrXh0fz1iMWvWRKiENu4KAMgMmALI5/idj9Hz5wqALlX5uM3OmBs33
         Fk0Ij8GqKDhaABu6Bpn3SslSiJBNdRTb6Xc7vy0EKJ3raAoLN6UZA2YOX/fjvIOleK2b
         FZtCfTBT7/0tT2/BXQXSrAhBi18pXuAOOSqN5paIJqUSco2yYMKW8lZCeWSEz5v/JXYQ
         TT41JgE/Q+uFiM4c7MnmpIyfqJIt1yoIolScwr87Glp6N89m/tAolUWhy/BWhzEPUCc4
         OXIngA1XPMib3WinUQIp4VvRQCyaAXtUh3ykQX9+IqBUET7gGB0OtgFURyG5aWbDRYkA
         481Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ftTUQdWQygkzM3mVimTjsLVWTRYC3XiJQvXkTntLJtw=;
        b=quUjTcUwgMgshjXhiWJDUvtFes6VNuxSVJ/422+9LGKtqMIq7vQ/D4W2qAqZThVsDo
         /7gG56Ua+LCNdB9izv3wX25YguH9s4XjHUk1TMm76TR04VRclu+G7m3dKDm42Bi+J36G
         naOHOmF69hMrbQ0kolk9ITIAObP5QANpQkfgMUYJN8Yg/QmgR0d6eFgUffv9jsa+4RMn
         FyPMT+11x+agTRmEufqBKZUSRHFUf6haIPB+qjo5uR5oxjbet6UkkRRZccilHLY2TfI2
         ozj3GoCFWig8NuFp/fYscaXHDTwK/ZD2W0K8HmR1LU3+8j2W7W145qOuSaDBy5zzD5mX
         aZlg==
X-Gm-Message-State: AJIora9EJzvrSRfVz52nIKMf54CKX62WR+vppWNGWRlQXRN2hvZ/eRjX
        gJiz2/9rs2Gqpl+VLA1wtrZ/cRhwm2HUmiDwwto=
X-Google-Smtp-Source: AGRyM1uADIURyiwURNfZkj5efZkiiJgK3BACIQAs4PguwyflPE6HQ6TdQyhGcz/pZ7GB5D1vk/8RZQ==
X-Received: by 2002:a17:907:8d0a:b0:70e:aa82:8745 with SMTP id tc10-20020a1709078d0a00b0070eaa828745mr4198315ejc.550.1655210014923;
        Tue, 14 Jun 2022 05:33:34 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id l2-20020a1709067d4200b006f3ef214e27sm5052745ejp.141.2022.06.14.05.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:33:34 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
Subject: [patch net-next 05/11] mlxsw: reg: Extend MDDQ by device_info
Date:   Tue, 14 Jun 2022 14:33:20 +0200
Message-Id: <20220614123326.69745-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220614123326.69745-1-jiri@resnulli.us>
References: <20220614123326.69745-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Extend existing MDDQ register by possibility to query information about
devices residing on a line card.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 83 ++++++++++++++++++++++-
 1 file changed, 82 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 93af6c974ece..c8d526669522 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -11643,7 +11643,11 @@ MLXSW_ITEM32(reg, mddq, sie, 0x00, 31, 1);
 
 enum mlxsw_reg_mddq_query_type {
 	MLXSW_REG_MDDQ_QUERY_TYPE_SLOT_INFO = 1,
-	MLXSW_REG_MDDQ_QUERY_TYPE_SLOT_NAME = 3,
+	MLXSW_REG_MDDQ_QUERY_TYPE_DEVICE_INFO, /* If there are no devices
+						* on the slot, data_valid
+						* will be '0'.
+						*/
+	MLXSW_REG_MDDQ_QUERY_TYPE_SLOT_NAME,
 };
 
 /* reg_mddq_query_type
@@ -11657,6 +11661,28 @@ MLXSW_ITEM32(reg, mddq, query_type, 0x00, 16, 8);
  */
 MLXSW_ITEM32(reg, mddq, slot_index, 0x00, 0, 4);
 
+/* reg_mddq_response_msg_seq
+ * Response message sequential number. For a specific request, the response
+ * message sequential number is the following one. In addition, the last
+ * message should be 0.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mddq, response_msg_seq, 0x04, 16, 8);
+
+/* reg_mddq_request_msg_seq
+ * Request message sequential number.
+ * The first message number should be 0.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, mddq, request_msg_seq, 0x04, 0, 8);
+
+/* reg_mddq_data_valid
+ * If set, the data in the data field is valid and contain the information
+ * for the queried index.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mddq, data_valid, 0x08, 31, 1);
+
 /* reg_mddq_slot_info_provisioned
  * If set, the INI file is applied and the card is provisioned.
  * Access: RO
@@ -11743,6 +11769,61 @@ mlxsw_reg_mddq_slot_info_unpack(const char *payload, u8 *p_slot_index,
 	*p_card_type = mlxsw_reg_mddq_slot_info_card_type_get(payload);
 }
 
+/* reg_mddq_device_info_flash_owner
+ * If set, the device is the flash owner. Otherwise, a shared flash
+ * is used by this device (another device is the flash owner).
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mddq, device_info_flash_owner, 0x10, 30, 1);
+
+/* reg_mddq_device_info_device_index
+ * Device index. The first device should number 0.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mddq, device_info_device_index, 0x10, 0, 8);
+
+/* reg_mddq_device_info_fw_major
+ * Major FW version number.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mddq, device_info_fw_major, 0x14, 16, 16);
+
+/* reg_mddq_device_info_fw_minor
+ * Minor FW version number.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mddq, device_info_fw_minor, 0x18, 16, 16);
+
+/* reg_mddq_device_info_fw_sub_minor
+ * Sub-minor FW version number.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mddq, device_info_fw_sub_minor, 0x18, 0, 16);
+
+static inline void
+mlxsw_reg_mddq_device_info_pack(char *payload, u8 slot_index,
+				u8 request_msg_seq)
+{
+	__mlxsw_reg_mddq_pack(payload, slot_index,
+			      MLXSW_REG_MDDQ_QUERY_TYPE_DEVICE_INFO);
+	mlxsw_reg_mddq_request_msg_seq_set(payload, request_msg_seq);
+}
+
+static inline void
+mlxsw_reg_mddq_device_info_unpack(const char *payload, u8 *p_response_msg_seq,
+				  bool *p_data_valid, bool *p_flash_owner,
+				  u8 *p_device_index, u16 *p_fw_major,
+				  u16 *p_fw_minor, u16 *p_fw_sub_minor)
+{
+	*p_response_msg_seq = mlxsw_reg_mddq_response_msg_seq_get(payload);
+	*p_data_valid = mlxsw_reg_mddq_data_valid_get(payload);
+	*p_flash_owner = mlxsw_reg_mddq_device_info_flash_owner_get(payload);
+	*p_device_index = mlxsw_reg_mddq_device_info_device_index_get(payload);
+	*p_fw_major = mlxsw_reg_mddq_device_info_fw_major_get(payload);
+	*p_fw_minor = mlxsw_reg_mddq_device_info_fw_minor_get(payload);
+	*p_fw_sub_minor = mlxsw_reg_mddq_device_info_fw_sub_minor_get(payload);
+}
+
 #define MLXSW_REG_MDDQ_SLOT_ASCII_NAME_LEN 20
 
 /* reg_mddq_slot_ascii_name
-- 
2.35.3

