Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69DBD579376
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 08:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbiGSGtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 02:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236867AbiGSGtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 02:49:02 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F034A26AF4
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 23:48:58 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id t3so18333922edd.0
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 23:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=44wys52ilsQ8VJ4uJwpgIac5uAf+oQNvEU1pnbpD+OQ=;
        b=WMtFYNdPvnO42hndcVui6N6xlX05up8lkAfT4Jj5EKxLldKLsB+ZI0FcgUthjZ+Gxx
         lbqzO7X6hzTLA3whccojhWRjoPQBdvH3Zhm65WcJWJ3N8n9bmtgdz/DSPxREIgBSOawn
         0stGnH/0DyCGdttH9EFEdKD/x0LMRYI82GHON387kecYaD/eRQ8elWjXgqQJCd+0Ps+L
         DUpLD8Xb0FR9+KY+RyQ2xVx4+ClevQUjFRyXJtEeq3kuNkQ4yJBZOGk7vyw/VrOQ/hiK
         lgGgwuDx9GUDWrcfq3cWCWAUjXSH+BqIUAK34yuwBMSWNkqa6Cf81iZ3Cy/FqWGP8YV5
         VbNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=44wys52ilsQ8VJ4uJwpgIac5uAf+oQNvEU1pnbpD+OQ=;
        b=HuTmCvRwR6KPSU9XOs4UPpU+mAi/kPo0F80nOgsIAvtxqCsPhNP6XZ/BdE5jkzC4oN
         nDnvJn0XDxVca83gm7mx+FQYRUzDkIRV7RL/pFCl48f+c9VGuhK2aSn1uf6GzWmrhZUm
         o1LlqgHYduzoV36NIj/yA+qAlfJdD2VBephv335c596Q55Ny8sl3YJFQmSm0XP3qhuY4
         5cJR2/VQ2MBfKeJ3aGf+Sor+TpEiXm76NFgBpcAdT+U2UtCPBACgOgtBmXRCENPoUlOM
         VO4pmrpkQy9w3hufzpM8xBJ1SKGYVDRaJkJa7At9vteAJNipRJtWFzGJ+QvaideA0Sx2
         f9uA==
X-Gm-Message-State: AJIora9jyBZspdhQhg8YuuueUNCEoQe7eyneo/Kt0PZExOTJ5oQeSzfT
        SC2gOvvq95Y0B/2w/y5aqH+40FLLr9FqH3fHmrU=
X-Google-Smtp-Source: AGRyM1uZMbCh0HgHuhBJdwtqh4dYgmt6lJ7GqHGRULiNGv5mNhOx7m1Jr3wKgyBBotRAS0LCuGMqjA==
X-Received: by 2002:a05:6402:348e:b0:43a:953d:ade8 with SMTP id v14-20020a056402348e00b0043a953dade8mr42457032edc.135.1658213337529;
        Mon, 18 Jul 2022 23:48:57 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id w13-20020aa7cb4d000000b0043a5004e714sm9889626edt.64.2022.07.18.23.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 23:48:57 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v2 06/12] mlxsw: reg: Extend MDDQ by device_info
Date:   Tue, 19 Jul 2022 08:48:41 +0200
Message-Id: <20220719064847.3688226-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220719064847.3688226-1-jiri@resnulli.us>
References: <20220719064847.3688226-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 17ce28e65464..76caf06b17d6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -11297,7 +11297,11 @@ MLXSW_ITEM32(reg, mddq, sie, 0x00, 31, 1);
 
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
@@ -11311,6 +11315,28 @@ MLXSW_ITEM32(reg, mddq, query_type, 0x00, 16, 8);
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
@@ -11397,6 +11423,61 @@ mlxsw_reg_mddq_slot_info_unpack(const char *payload, u8 *p_slot_index,
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

