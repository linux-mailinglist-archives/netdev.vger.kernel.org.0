Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD2257B952
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 17:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241267AbiGTPNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 11:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241183AbiGTPMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 11:12:55 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65595564C3
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:12:46 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id bu1so26553197wrb.9
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D0wvSNQl0ZzJX1XDt2uhw6MCxkEXnXBDef+nVt1VOhc=;
        b=AzYERC2tB53NtVvYWQxK8HTeMMuJb2qQF/8rHqe9DMULbhIc7EIKonirHiAE6sXT2B
         7RKRJ+fOkGBvGGb6FvmiDxSdurA5mWIEFOh9Cweo+29Q/TX9ENgTF7zoLaQnmo+gO0R1
         Mod3JX7AS12KizczFp6Ccvz1eD7q3RgjiU1rbNDsAIeb0sQTDeZkhO/8/aKZ2aheaDMf
         /m1AQFkHUOYlsD4ad80CNxs6XhzzmutHpW+kxpNbYkAY7zknceXNlZXuI+wcG8tllttU
         7fGiFURT9KSfPBeGXn1XC9anrwrhlnZbjuLFhS3wF8NLgO9TWvsezjkKLZgX2zG+CkAw
         7mGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D0wvSNQl0ZzJX1XDt2uhw6MCxkEXnXBDef+nVt1VOhc=;
        b=hkaiFl1een7GA/W0BzsUWRq0nN+3j73T51IoH17jnyZUjaccwT53l8vkQr21z/Qhn0
         pFPM7xu5MQI2PbZUBn/5g2ZorVg62x6FqEa0xAhuTUaMSXUYZxCU/RhjOq32Qxx/hRif
         vbZajQhs24iY+oeIGAs4aEswCjPXsvp0K6VDopTKqlL60YvUwTzUOrZWKI/Ut+WV8vb3
         1w9Rpo+5Mphayd1yoPhW+FAvuXMZt+akrmJzYSf+UH23CM+UyjLGmu/QGJWyqMblsx0O
         vBj2Mq09pSzFTdtmqDdBph0l4kRnwqYgrp8KZ/8hWCJ/d/YirGnI3illsMFX7NUCdwY1
         Fj/Q==
X-Gm-Message-State: AJIora9HlnnLtO/73isYETMmw+y6AAD0t12QzsdLvMdiQXhG+kTJ627d
        IY7KZbPm8bmnK1IKCh4seREgf7NocWJZaL3Ilcw=
X-Google-Smtp-Source: AGRyM1u7zfL3SfXgmWND3sFgMywsrRNPVG7HYjgQ8CIIbQbQWXM0RwAypk47/pbEZ06AfC4Vbkj7GQ==
X-Received: by 2002:a5d:47a1:0:b0:21d:a50e:b2d7 with SMTP id 1-20020a5d47a1000000b0021da50eb2d7mr32056532wrb.58.1658329965537;
        Wed, 20 Jul 2022 08:12:45 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id l20-20020a5d5274000000b0021dfacfdf0dsm10988461wrc.33.2022.07.20.08.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 08:12:45 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v3 05/11] mlxsw: reg: Extend MDDQ by device_info
Date:   Wed, 20 Jul 2022 17:12:28 +0200
Message-Id: <20220720151234.3873008-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220720151234.3873008-1-jiri@resnulli.us>
References: <20220720151234.3873008-1-jiri@resnulli.us>
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
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
v2->v3:
- added Ido's RWB tag
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

