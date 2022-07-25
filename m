Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 046BC57FB59
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 10:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233960AbiGYI3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 04:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233904AbiGYI3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 04:29:40 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1108514003
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:29:38 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id z23so19052589eju.8
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D0wvSNQl0ZzJX1XDt2uhw6MCxkEXnXBDef+nVt1VOhc=;
        b=lokUb6q9Y0r4X2iqXinqZq0cSk1pKt5AXRrGIZq4I7NK2rnBejWqjT3xcj+RdR8c3Q
         B5X87IY4h/LNqyR/8OZmObnQrQaE5FYwR8KU+YsyKNB72vCdtwSPDv6sgUJ+uiPWLx0t
         USd8KqLMMlOgB9AIlyDR3DeUP4uMTEO5ivVOvg9OaxJjFWE9g3BA9NmutCp7DKv6SEtJ
         yJ+nKIFeUl5SeloLzfVmS/kYgQFn7nPmmiZGN0/gnLE/pnLwwC3UhyWI2uWj+Xo88Zx+
         0yOrpo2hTSPDhdptPeFeXz6JPdkIK7zRuRDYQ/VfqMZgyz/6ip4NcqRrOeiSkicHUh0K
         4JrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D0wvSNQl0ZzJX1XDt2uhw6MCxkEXnXBDef+nVt1VOhc=;
        b=5wDDNB//iNaEkaBPZoUltvB1hsck6q4G9+EtNMbc6bH0BNup5cunZpjjbRaqfXb/fH
         xkL4JMAkYhczrvHV2v6kUSEJm9SeKLZT0th+4BC+hYC+dTA0P/nRWbYp5IHbcpT4HZMs
         bGdsE9sspiPcl3YyxS7nZrOlVC+zYdYuvHG8ZnxBFnPP0mhmM+auGIEqVlM9cV478sih
         95Q97UydTTcx5SxImwL4T0QcYydYLXoULcy11RIG38BxJXDs1NbTKHjJuY55zuRqEimT
         Tb+d3CLpQFU1qS+iNNrbQShMc/H1lF2LAe4Y06yu6vmtN8nboV7DWkYETM2550dx1ZPa
         t2/g==
X-Gm-Message-State: AJIora9p/rhwGBghxAUzj/S+ebyDICyIuDpvXKaTh97MpzbxY7lsnZV6
        1QdHgk55GR6pwwwKag2Gaqg7lHRMt0C3YakanNQ=
X-Google-Smtp-Source: AGRyM1trY8kOeImqtAsQYLVBTtc/u8Z4dG1rebQDqbOFsoPmE4PA6bR8t3NXsKX3VFXuQlWGxzdSGw==
X-Received: by 2002:a17:907:3f92:b0:72b:5af8:b87d with SMTP id hr18-20020a1709073f9200b0072b5af8b87dmr8865778ejc.416.1658737776457;
        Mon, 25 Jul 2022 01:29:36 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id a11-20020a1709065f8b00b0072b51fb36f7sm5054409eju.196.2022.07.25.01.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 01:29:36 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v4 06/12] mlxsw: reg: Extend MDDQ by device_info
Date:   Mon, 25 Jul 2022 10:29:19 +0200
Message-Id: <20220725082925.366455-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220725082925.366455-1-jiri@resnulli.us>
References: <20220725082925.366455-1-jiri@resnulli.us>
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

