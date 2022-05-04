Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C9A51A44B
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 17:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351876AbiEDPod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 11:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352613AbiEDPoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 11:44:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604A01DA49
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 08:40:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE7D361C4F
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 15:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69D5C385A4;
        Wed,  4 May 2022 15:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651678842;
        bh=vZJWW+UQ2LSymVfWINkFy+JQFvnUFYk+IbiZu81Ftz4=;
        h=From:To:Cc:Subject:Date:From;
        b=ipAyFpvqF2W/Nmdy+8gdwJB51P48/TnY7mAVQYA7L9K0FCs6JyJ4UNJScrkJpmFQY
         3ML/fLU0Nh2oM5JPtmJHviugIee/iFFNO8aqX2uS5MrOMfej8VpQjuLwiLqua1ew8N
         jbKpniLpJ7TvPTIe6gAy+TD3dHkK97A7DVJ8lOx6LH3JT0WR75cfEJ70CeVRifnp8b
         QWqTZZ2UY5X30JURGgArLqVj9mz5ddK/ybXwr4zHY/JrZw2AcsP3E3+yexxWymSb4w
         n0dOdWHtAbjhozzfe8OskwuhEjA476/ou35Djp2HwpsUr6jpe26QOeaaKRFUTSYJY6
         5YbnGyfwu8fxA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        jiri@nvidia.com, idosch@nvidia.com, andrew@lunn.ch,
        dsahern@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] Revert "Merge branch 'mlxsw-line-card-model'"
Date:   Wed,  4 May 2022 08:40:37 -0700
Message-Id: <20220504154037.539442-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
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

This reverts commit 5e927a9f4b9f29d78a7c7d66ea717bb5c8bbad8e, reversing
changes made to cfc1d91a7d78cf9de25b043d81efcc16966d55b3.

The discussion is still ongoing so let's remove the uAPI
until the discussion settles.

Link: https://lore.kernel.org/all/20220425090021.32e9a98f@kernel.org/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../networking/devlink/devlink-linecard.rst   |   4 -
 Documentation/networking/devlink/mlxsw.rst    |  33 --
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   1 -
 .../ethernet/mellanox/mlxsw/core_linecards.c  | 237 +-------------
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  87 +----
 include/net/devlink.h                         |  18 +-
 include/uapi/linux/devlink.h                  |   5 -
 net/core/devlink.c                            | 303 +-----------------
 .../drivers/net/mlxsw/devlink_linecard.sh     |  61 ----
 9 files changed, 10 insertions(+), 739 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-linecard.rst b/Documentation/networking/devlink/devlink-linecard.rst
index a98b468ad479..6c0b8928bc13 100644
--- a/Documentation/networking/devlink/devlink-linecard.rst
+++ b/Documentation/networking/devlink/devlink-linecard.rst
@@ -14,7 +14,6 @@ line cards that serve as a detachable PHY modules for modular switch
   * Get a list of supported line card types.
   * Provision of a slot with specific line card type.
   * Get and monitor of line card state and its change.
-  * Get information about line card versions and devices.
 
 Line card according to the type may contain one or more gearboxes
 to mux the lanes with certain speed to multiple ports with lanes
@@ -121,6 +120,3 @@ Example usage
 
     # Set slot 8 to be unprovisioned:
     $ devlink lc set pci/0000:01:00.0 lc 8 notype
-
-    # Set info for slot 8:
-    $ devlink lc info pci/0000:01:00.0 lc 8
diff --git a/Documentation/networking/devlink/mlxsw.rst b/Documentation/networking/devlink/mlxsw.rst
index 0af345680510..cf857cb4ba8f 100644
--- a/Documentation/networking/devlink/mlxsw.rst
+++ b/Documentation/networking/devlink/mlxsw.rst
@@ -58,39 +58,6 @@ The ``mlxsw`` driver reports the following versions
      - running
      - Three digit firmware version
 
-Line card info versions
-=======================
-
-The ``mlxsw`` driver reports the following versions for line cards
-
-.. list-table:: devlink line card info versions implemented
-   :widths: 5 5 90
-
-   * - Name
-     - Type
-     - Description
-   * - ``hw.revision``
-     - fixed
-     - The hardware revision for this line card
-   * - ``ini.version``
-     - running
-     - Version of line card INI loaded
-
-Line card device info versions
-==============================
-
-The ``mlxsw`` driver reports the following versions for line card devices
-
-.. list-table:: devlink line card device info versions implemented
-   :widths: 5 5 90
-
-   * - Name
-     - Type
-     - Description
-   * - ``fw.version``
-     - running
-     - Three digit firmware version
-
 Driver-specific Traps
 =====================
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index d008282d7f2e..c2a891287047 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -581,7 +581,6 @@ struct mlxsw_linecard {
 	   active:1;
 	u16 hw_revision;
 	u16 ini_version;
-	struct list_head device_list;
 };
 
 struct mlxsw_linecard_types_info;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
index 2abd31a62776..5c9869dcf674 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
@@ -87,191 +87,11 @@ static const char *mlxsw_linecard_type_name(struct mlxsw_linecard *linecard)
 	return linecard->name;
 }
 
-struct mlxsw_linecard_device_info {
-	u16 fw_major;
-	u16 fw_minor;
-	u16 fw_sub_minor;
-};
-
-struct mlxsw_linecard_device {
-	struct list_head list;
-	u8 index;
-	struct mlxsw_linecard *linecard;
-	struct devlink_linecard_device *devlink_device;
-	struct mlxsw_linecard_device_info info;
-};
-
-static struct mlxsw_linecard_device *
-mlxsw_linecard_device_lookup(struct mlxsw_linecard *linecard, u8 index)
-{
-	struct mlxsw_linecard_device *device;
-
-	list_for_each_entry(device, &linecard->device_list, list)
-		if (device->index == index)
-			return device;
-	return NULL;
-}
-
-static int mlxsw_linecard_device_attach(struct mlxsw_core *mlxsw_core,
-					struct mlxsw_linecard *linecard,
-					u8 device_index, bool flash_owner)
-{
-	struct mlxsw_linecard_device *device;
-	int err;
-
-	device = kzalloc(sizeof(*device), GFP_KERNEL);
-	if (!device)
-		return -ENOMEM;
-	device->index = device_index;
-	device->linecard = linecard;
-
-	device->devlink_device = devlink_linecard_device_create(linecard->devlink_linecard,
-								device_index, device);
-	if (IS_ERR(device->devlink_device)) {
-		err = PTR_ERR(device->devlink_device);
-		goto err_devlink_linecard_device_attach;
-	}
-
-	list_add_tail(&device->list, &linecard->device_list);
-	return 0;
-
-err_devlink_linecard_device_attach:
-	kfree(device);
-	return err;
-}
-
-static void mlxsw_linecard_device_detach(struct mlxsw_core *mlxsw_core,
-					 struct mlxsw_linecard *linecard,
-					 struct mlxsw_linecard_device *device)
-{
-	list_del(&device->list);
-	devlink_linecard_device_destroy(linecard->devlink_linecard,
-					device->devlink_device);
-	kfree(device);
-}
-
-static void mlxsw_linecard_devices_detach(struct mlxsw_linecard *linecard)
-{
-	struct mlxsw_core *mlxsw_core = linecard->linecards->mlxsw_core;
-	struct mlxsw_linecard_device *device, *tmp;
-
-	list_for_each_entry_safe(device, tmp, &linecard->device_list, list)
-		mlxsw_linecard_device_detach(mlxsw_core, linecard, device);
-}
-
-static int mlxsw_linecard_devices_attach(struct mlxsw_linecard *linecard)
-{
-	struct mlxsw_core *mlxsw_core = linecard->linecards->mlxsw_core;
-	u8 msg_seq = 0;
-	int err;
-
-	do {
-		char mddq_pl[MLXSW_REG_MDDQ_LEN];
-		bool flash_owner;
-		bool data_valid;
-		u8 device_index;
-
-		mlxsw_reg_mddq_device_info_pack(mddq_pl, linecard->slot_index,
-						msg_seq);
-		err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mddq), mddq_pl);
-		if (err)
-			return err;
-		mlxsw_reg_mddq_device_info_unpack(mddq_pl, &msg_seq,
-						  &data_valid, &flash_owner,
-						  &device_index, NULL,
-						  NULL, NULL);
-		if (!data_valid)
-			break;
-		err = mlxsw_linecard_device_attach(mlxsw_core, linecard,
-						   device_index, flash_owner);
-		if (err)
-			goto rollback;
-	} while (msg_seq);
-
-	return 0;
-
-rollback:
-	mlxsw_linecard_devices_detach(linecard);
-	return err;
-}
-
-static void mlxsw_linecard_device_update(struct mlxsw_linecard *linecard,
-					 u8 device_index,
-					 struct mlxsw_linecard_device_info *info)
-{
-	struct mlxsw_linecard_device *device;
-
-	device = mlxsw_linecard_device_lookup(linecard, device_index);
-	if (!device)
-		return;
-	device->info = *info;
-}
-
-static int mlxsw_linecard_devices_update(struct mlxsw_linecard *linecard)
-{
-	struct mlxsw_core *mlxsw_core = linecard->linecards->mlxsw_core;
-	u8 msg_seq = 0;
-
-	do {
-		struct mlxsw_linecard_device_info info;
-		char mddq_pl[MLXSW_REG_MDDQ_LEN];
-		bool data_valid;
-		u8 device_index;
-		int err;
-
-		mlxsw_reg_mddq_device_info_pack(mddq_pl, linecard->slot_index,
-						msg_seq);
-		err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mddq), mddq_pl);
-		if (err)
-			return err;
-		mlxsw_reg_mddq_device_info_unpack(mddq_pl, &msg_seq,
-						  &data_valid, NULL,
-						  &device_index,
-						  &info.fw_major,
-						  &info.fw_minor,
-						  &info.fw_sub_minor);
-		if (!data_valid)
-			break;
-		mlxsw_linecard_device_update(linecard, device_index, &info);
-	} while (msg_seq);
-
-	return 0;
-}
-
-static int
-mlxsw_linecard_device_info_get(struct devlink_linecard_device *devlink_linecard_device,
-			       void *priv, struct devlink_info_req *req,
-			       struct netlink_ext_ack *extack)
-{
-	struct mlxsw_linecard_device *device = priv;
-	struct mlxsw_linecard_device_info *info;
-	struct mlxsw_linecard *linecard;
-	char buf[32];
-
-	linecard = device->linecard;
-	mutex_lock(&linecard->lock);
-	if (!linecard->active) {
-		mutex_unlock(&linecard->lock);
-		return 0;
-	}
-
-	info = &device->info;
-
-	sprintf(buf, "%u.%u.%u", info->fw_major, info->fw_minor,
-		info->fw_sub_minor);
-	mutex_unlock(&linecard->lock);
-
-	return devlink_info_version_running_put(req,
-						DEVLINK_INFO_VERSION_GENERIC_FW,
-						buf);
-}
-
 static void mlxsw_linecard_provision_fail(struct mlxsw_linecard *linecard)
 {
 	linecard->provisioned = false;
 	linecard->ready = false;
 	linecard->active = false;
-	mlxsw_linecard_devices_detach(linecard);
 	devlink_linecard_provision_fail(linecard->devlink_linecard);
 }
 
@@ -412,7 +232,6 @@ mlxsw_linecard_provision_set(struct mlxsw_linecard *linecard, u8 card_type,
 {
 	struct mlxsw_linecards *linecards = linecard->linecards;
 	const char *type;
-	int err;
 
 	type = mlxsw_linecard_types_lookup(linecards, card_type);
 	mlxsw_linecard_status_event_done(linecard,
@@ -430,11 +249,6 @@ mlxsw_linecard_provision_set(struct mlxsw_linecard *linecard, u8 card_type,
 			return PTR_ERR(type);
 		}
 	}
-	err = mlxsw_linecard_devices_attach(linecard);
-	if (err) {
-		mlxsw_linecard_provision_fail(linecard);
-		return err;
-	}
 	linecard->provisioned = true;
 	linecard->hw_revision = hw_revision;
 	linecard->ini_version = ini_version;
@@ -447,7 +261,6 @@ static void mlxsw_linecard_provision_clear(struct mlxsw_linecard *linecard)
 	mlxsw_linecard_status_event_done(linecard,
 					 MLXSW_LINECARD_STATUS_EVENT_TYPE_UNPROVISION);
 	linecard->provisioned = false;
-	mlxsw_linecard_devices_detach(linecard);
 	devlink_linecard_provision_clear(linecard->devlink_linecard);
 }
 
@@ -479,18 +292,11 @@ static int mlxsw_linecard_ready_clear(struct mlxsw_linecard *linecard)
 	return 0;
 }
 
-static int mlxsw_linecard_active_set(struct mlxsw_linecard *linecard)
+static void mlxsw_linecard_active_set(struct mlxsw_linecard *linecard)
 {
-	int err;
-
-	err = mlxsw_linecard_devices_update(linecard);
-	if (err)
-		return err;
-
 	mlxsw_linecard_active_ops_call(linecard);
 	linecard->active = true;
 	devlink_linecard_activate(linecard->devlink_linecard);
-	return 0;
 }
 
 static void mlxsw_linecard_active_clear(struct mlxsw_linecard *linecard)
@@ -539,11 +345,8 @@ static int mlxsw_linecard_status_process(struct mlxsw_linecards *linecards,
 			goto out;
 	}
 
-	if (active && linecard->active != active) {
-		err = mlxsw_linecard_active_set(linecard);
-		if (err)
-			goto out;
-	}
+	if (active && linecard->active != active)
+		mlxsw_linecard_active_set(linecard);
 
 	if (!active && linecard->active != active)
 		mlxsw_linecard_active_clear(linecard);
@@ -934,44 +737,12 @@ static void mlxsw_linecard_types_get(struct devlink_linecard *devlink_linecard,
 	*type_priv = ini_file;
 }
 
-static int
-mlxsw_linecard_info_get(struct devlink_linecard *devlink_linecard, void *priv,
-			struct devlink_info_req *req,
-			struct netlink_ext_ack *extack)
-{
-	struct mlxsw_linecard *linecard = priv;
-	char buf[32];
-	int err;
-
-	mutex_lock(&linecard->lock);
-	if (!linecard->provisioned) {
-		err = 0;
-		goto unlock;
-	}
-
-	sprintf(buf, "%d", linecard->hw_revision);
-	err = devlink_info_version_fixed_put(req, "hw.revision", buf);
-	if (err)
-		goto unlock;
-
-	sprintf(buf, "%d", linecard->ini_version);
-	err = devlink_info_version_running_put(req, "ini.version", buf);
-	if (err)
-		goto unlock;
-
-unlock:
-	mutex_unlock(&linecard->lock);
-	return err;
-}
-
 static const struct devlink_linecard_ops mlxsw_linecard_ops = {
 	.provision = mlxsw_linecard_provision,
 	.unprovision = mlxsw_linecard_unprovision,
 	.same_provision = mlxsw_linecard_same_provision,
 	.types_count = mlxsw_linecard_types_count,
 	.types_get = mlxsw_linecard_types_get,
-	.info_get = mlxsw_linecard_info_get,
-	.device_info_get = mlxsw_linecard_device_info_get,
 };
 
 struct mlxsw_linecard_status_event {
@@ -1069,7 +840,6 @@ static int mlxsw_linecard_init(struct mlxsw_core *mlxsw_core,
 	linecard->slot_index = slot_index;
 	linecard->linecards = linecards;
 	mutex_init(&linecard->lock);
-	INIT_LIST_HEAD(&linecard->device_list);
 
 	devlink_linecard = devlink_linecard_create(priv_to_devlink(mlxsw_core),
 						   slot_index, &mlxsw_linecard_ops,
@@ -1115,7 +885,6 @@ static void mlxsw_linecard_fini(struct mlxsw_core *mlxsw_core,
 	mlxsw_core_flush_owq();
 	if (linecard->active)
 		mlxsw_linecard_active_clear(linecard);
-	mlxsw_linecard_devices_detach(linecard);
 	devlink_linecard_destroy(linecard->devlink_linecard);
 	mutex_destroy(&linecard->lock);
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 078e3aa04383..93af6c974ece 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -11643,11 +11643,7 @@ MLXSW_ITEM32(reg, mddq, sie, 0x00, 31, 1);
 
 enum mlxsw_reg_mddq_query_type {
 	MLXSW_REG_MDDQ_QUERY_TYPE_SLOT_INFO = 1,
-	MLXSW_REG_MDDQ_QUERY_TYPE_DEVICE_INFO, /* If there are no devices
-						* on the slot, data_valid
-						* will be '0'.
-						*/
-	MLXSW_REG_MDDQ_QUERY_TYPE_SLOT_NAME,
+	MLXSW_REG_MDDQ_QUERY_TYPE_SLOT_NAME = 3,
 };
 
 /* reg_mddq_query_type
@@ -11661,28 +11657,6 @@ MLXSW_ITEM32(reg, mddq, query_type, 0x00, 16, 8);
  */
 MLXSW_ITEM32(reg, mddq, slot_index, 0x00, 0, 4);
 
-/* reg_mddq_response_msg_seq
- * Response message sequential number. For a specific request, the response
- * message sequential number is the following one. In addition, the last
- * message should be 0.
- * Access: RO
- */
-MLXSW_ITEM32(reg, mddq, response_msg_seq, 0x04, 16, 8);
-
-/* reg_mddq_request_msg_seq
- * Request message sequential number.
- * The first message number should be 0.
- * Access: Index
- */
-MLXSW_ITEM32(reg, mddq, request_msg_seq, 0x04, 0, 8);
-
-/* reg_mddq_data_valid
- * If set, the data in the data field is valid and contain the information
- * for the queried index.
- * Access: RO
- */
-MLXSW_ITEM32(reg, mddq, data_valid, 0x08, 31, 1);
-
 /* reg_mddq_slot_info_provisioned
  * If set, the INI file is applied and the card is provisioned.
  * Access: RO
@@ -11769,65 +11743,6 @@ mlxsw_reg_mddq_slot_info_unpack(const char *payload, u8 *p_slot_index,
 	*p_card_type = mlxsw_reg_mddq_slot_info_card_type_get(payload);
 }
 
-/* reg_mddq_device_info_flash_owner
- * If set, the device is the flash owner. Otherwise, a shared flash
- * is used by this device (another device is the flash owner).
- * Access: RO
- */
-MLXSW_ITEM32(reg, mddq, device_info_flash_owner, 0x10, 30, 1);
-
-/* reg_mddq_device_info_device_index
- * Device index. The first device should number 0.
- * Access: RO
- */
-MLXSW_ITEM32(reg, mddq, device_info_device_index, 0x10, 0, 8);
-
-/* reg_mddq_device_info_fw_major
- * Major FW version number.
- * Access: RO
- */
-MLXSW_ITEM32(reg, mddq, device_info_fw_major, 0x14, 16, 16);
-
-/* reg_mddq_device_info_fw_minor
- * Minor FW version number.
- * Access: RO
- */
-MLXSW_ITEM32(reg, mddq, device_info_fw_minor, 0x18, 16, 16);
-
-/* reg_mddq_device_info_fw_sub_minor
- * Sub-minor FW version number.
- * Access: RO
- */
-MLXSW_ITEM32(reg, mddq, device_info_fw_sub_minor, 0x18, 0, 16);
-
-static inline void
-mlxsw_reg_mddq_device_info_pack(char *payload, u8 slot_index,
-				u8 request_msg_seq)
-{
-	__mlxsw_reg_mddq_pack(payload, slot_index,
-			      MLXSW_REG_MDDQ_QUERY_TYPE_DEVICE_INFO);
-	mlxsw_reg_mddq_request_msg_seq_set(payload, request_msg_seq);
-}
-
-static inline void
-mlxsw_reg_mddq_device_info_unpack(const char *payload, u8 *p_response_msg_seq,
-				  bool *p_data_valid, bool *p_flash_owner,
-				  u8 *p_device_index, u16 *p_fw_major,
-				  u16 *p_fw_minor, u16 *p_fw_sub_minor)
-{
-	*p_response_msg_seq = mlxsw_reg_mddq_response_msg_seq_get(payload);
-	*p_data_valid = mlxsw_reg_mddq_data_valid_get(payload);
-	if (p_flash_owner)
-		*p_flash_owner = mlxsw_reg_mddq_device_info_flash_owner_get(payload);
-	*p_device_index = mlxsw_reg_mddq_device_info_device_index_get(payload);
-	if (p_fw_major)
-		*p_fw_major = mlxsw_reg_mddq_device_info_fw_major_get(payload);
-	if (p_fw_minor)
-		*p_fw_minor = mlxsw_reg_mddq_device_info_fw_minor_get(payload);
-	if (p_fw_sub_minor)
-		*p_fw_sub_minor = mlxsw_reg_mddq_device_info_fw_sub_minor_get(payload);
-}
-
 #define MLXSW_REG_MDDQ_SLOT_ASCII_NAME_LEN 20
 
 /* reg_mddq_slot_ascii_name
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 062895973656..2a2a2a0c93f7 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -150,9 +150,6 @@ struct devlink_port_new_attrs {
 	   sfnum_valid:1;
 };
 
-struct devlink_info_req;
-struct devlink_linecard_device;
-
 /**
  * struct devlink_linecard_ops - Linecard operations
  * @provision: callback to provision the linecard slot with certain
@@ -171,8 +168,6 @@ struct devlink_linecard_device;
  *                  provisioned.
  * @types_count: callback to get number of supported types
  * @types_get: callback to get next type in list
- * @info_get: callback to get linecard info
- * @device_info_get: callback to get linecard device info
  */
 struct devlink_linecard_ops {
 	int (*provision)(struct devlink_linecard *linecard, void *priv,
@@ -187,12 +182,6 @@ struct devlink_linecard_ops {
 	void (*types_get)(struct devlink_linecard *linecard,
 			  void *priv, unsigned int index, const char **type,
 			  const void **type_priv);
-	int (*info_get)(struct devlink_linecard *linecard, void *priv,
-			struct devlink_info_req *req,
-			struct netlink_ext_ack *extack);
-	int (*device_info_get)(struct devlink_linecard_device *device,
-			       void *priv, struct devlink_info_req *req,
-			       struct netlink_ext_ack *extack);
 };
 
 struct devlink_sb_pool_info {
@@ -639,6 +628,7 @@ struct devlink_flash_update_params {
 #define DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK	BIT(1)
 
 struct devlink_region;
+struct devlink_info_req;
 
 /**
  * struct devlink_region_ops - Region operations
@@ -1588,12 +1578,6 @@ struct devlink_linecard *
 devlink_linecard_create(struct devlink *devlink, unsigned int linecard_index,
 			const struct devlink_linecard_ops *ops, void *priv);
 void devlink_linecard_destroy(struct devlink_linecard *linecard);
-struct devlink_linecard_device *
-devlink_linecard_device_create(struct devlink_linecard *linecard,
-			       unsigned int device_index, void *priv);
-void
-devlink_linecard_device_destroy(struct devlink_linecard *linecard,
-				struct devlink_linecard_device *linecard_device);
 void devlink_linecard_provision_set(struct devlink_linecard *linecard,
 				    const char *type);
 void devlink_linecard_provision_clear(struct devlink_linecard *linecard);
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index fb8c3864457f..b3d40a5d72ff 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -136,8 +136,6 @@ enum devlink_command {
 	DEVLINK_CMD_LINECARD_NEW,
 	DEVLINK_CMD_LINECARD_DEL,
 
-	DEVLINK_CMD_LINECARD_INFO_GET,		/* can dump */
-
 	/* add new commands above here */
 	__DEVLINK_CMD_MAX,
 	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
@@ -577,9 +575,6 @@ enum devlink_attr {
 	DEVLINK_ATTR_LINECARD_STATE,		/* u8 */
 	DEVLINK_ATTR_LINECARD_TYPE,		/* string */
 	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
-	DEVLINK_ATTR_LINECARD_DEVICE_LIST,	/* nested */
-	DEVLINK_ATTR_LINECARD_DEVICE,		/* nested */
-	DEVLINK_ATTR_LINECARD_DEVICE_INDEX,	/* u32 */
 
 	/* add new attributes above here, update the policy in devlink.c */
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 5f441a0e34f4..5cc88490f18f 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -83,11 +83,10 @@ struct devlink_linecard {
 	const struct devlink_linecard_ops *ops;
 	void *priv;
 	enum devlink_linecard_state state;
-	struct mutex state_lock; /* Protects state and device_list */
+	struct mutex state_lock; /* Protects state */
 	const char *type;
 	struct devlink_linecard_type *types;
 	unsigned int types_count;
-	struct list_head device_list;
 };
 
 /**
@@ -2059,56 +2058,6 @@ struct devlink_linecard_type {
 	const void *priv;
 };
 
-struct devlink_linecard_device {
-	struct list_head list;
-	unsigned int index;
-	void *priv;
-};
-
-static int
-devlink_nl_linecard_device_fill(struct sk_buff *msg,
-				struct devlink_linecard_device *linecard_device)
-{
-	struct nlattr *attr;
-
-	attr = nla_nest_start(msg, DEVLINK_ATTR_LINECARD_DEVICE);
-	if (!attr)
-		return -EMSGSIZE;
-	if (nla_put_u32(msg, DEVLINK_ATTR_LINECARD_DEVICE_INDEX,
-			linecard_device->index)) {
-		nla_nest_cancel(msg, attr);
-		return -EMSGSIZE;
-	}
-	nla_nest_end(msg, attr);
-
-	return 0;
-}
-
-static int devlink_nl_linecard_devices_fill(struct sk_buff *msg,
-					    struct devlink_linecard *linecard)
-{
-	struct devlink_linecard_device *linecard_device;
-	struct nlattr *attr;
-	int err;
-
-	if (list_empty(&linecard->device_list))
-		return 0;
-
-	attr = nla_nest_start(msg, DEVLINK_ATTR_LINECARD_DEVICE_LIST);
-	if (!attr)
-		return -EMSGSIZE;
-	list_for_each_entry(linecard_device, &linecard->device_list, list) {
-		err = devlink_nl_linecard_device_fill(msg, linecard_device);
-		if (err) {
-			nla_nest_cancel(msg, attr);
-			return err;
-		}
-	}
-	nla_nest_end(msg, attr);
-
-	return 0;
-}
-
 static int devlink_nl_linecard_fill(struct sk_buff *msg,
 				    struct devlink *devlink,
 				    struct devlink_linecard *linecard,
@@ -2119,7 +2068,6 @@ static int devlink_nl_linecard_fill(struct sk_buff *msg,
 	struct devlink_linecard_type *linecard_type;
 	struct nlattr *attr;
 	void *hdr;
-	int err;
 	int i;
 
 	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
@@ -2152,10 +2100,6 @@ static int devlink_nl_linecard_fill(struct sk_buff *msg,
 		nla_nest_end(msg, attr);
 	}
 
-	err = devlink_nl_linecard_devices_fill(msg, linecard);
-	if (err)
-		goto nla_put_failure;
-
 	genlmsg_end(msg, hdr);
 	return 0;
 
@@ -2425,191 +2369,6 @@ static int devlink_nl_cmd_linecard_set_doit(struct sk_buff *skb,
 	return 0;
 }
 
-struct devlink_info_req {
-	struct sk_buff *msg;
-};
-
-static int
-devlink_nl_linecard_device_info_fill(struct sk_buff *msg,
-				     struct devlink_linecard *linecard,
-				     struct devlink_linecard_device *linecard_device,
-				     struct netlink_ext_ack *extack)
-{
-	struct nlattr *attr;
-
-	attr = nla_nest_start(msg, DEVLINK_ATTR_LINECARD_DEVICE);
-	if (!attr)
-		return -EMSGSIZE;
-	if (nla_put_u32(msg, DEVLINK_ATTR_LINECARD_DEVICE_INDEX,
-			linecard_device->index)) {
-		nla_nest_cancel(msg, attr);
-		return -EMSGSIZE;
-	}
-	if (linecard->ops->device_info_get) {
-		struct devlink_info_req req;
-		int err;
-
-		req.msg = msg;
-		err = linecard->ops->device_info_get(linecard_device,
-						     linecard_device->priv,
-						     &req, extack);
-		if (err) {
-			nla_nest_cancel(msg, attr);
-			return err;
-		}
-	}
-	nla_nest_end(msg, attr);
-
-	return 0;
-}
-
-static int devlink_nl_linecard_devices_info_fill(struct sk_buff *msg,
-						 struct devlink_linecard *linecard,
-						 struct netlink_ext_ack *extack)
-{
-	struct devlink_linecard_device *linecard_device;
-	struct nlattr *attr;
-	int err;
-
-	if (list_empty(&linecard->device_list))
-		return 0;
-
-	attr = nla_nest_start(msg, DEVLINK_ATTR_LINECARD_DEVICE_LIST);
-	if (!attr)
-		return -EMSGSIZE;
-	list_for_each_entry(linecard_device, &linecard->device_list, list) {
-		err = devlink_nl_linecard_device_info_fill(msg, linecard,
-							   linecard_device,
-							   extack);
-		if (err) {
-			nla_nest_cancel(msg, attr);
-			return err;
-		}
-	}
-	nla_nest_end(msg, attr);
-
-	return 0;
-}
-
-static int
-devlink_nl_linecard_info_fill(struct sk_buff *msg, struct devlink *devlink,
-			      struct devlink_linecard *linecard,
-			      enum devlink_command cmd, u32 portid,
-			      u32 seq, int flags, struct netlink_ext_ack *extack)
-{
-	struct devlink_info_req req;
-	void *hdr;
-	int err;
-
-	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
-	if (!hdr)
-		return -EMSGSIZE;
-
-	err = -EMSGSIZE;
-	if (devlink_nl_put_handle(msg, devlink))
-		goto nla_put_failure;
-	if (nla_put_u32(msg, DEVLINK_ATTR_LINECARD_INDEX, linecard->index))
-		goto nla_put_failure;
-
-	req.msg = msg;
-	err = linecard->ops->info_get(linecard, linecard->priv, &req, extack);
-	if (err)
-		goto nla_put_failure;
-
-	err = devlink_nl_linecard_devices_info_fill(msg, linecard, extack);
-	if (err)
-		goto nla_put_failure;
-
-	genlmsg_end(msg, hdr);
-	return 0;
-
-nla_put_failure:
-	genlmsg_cancel(msg, hdr);
-	return err;
-}
-
-static int devlink_nl_cmd_linecard_info_get_doit(struct sk_buff *skb,
-						 struct genl_info *info)
-{
-	struct devlink_linecard *linecard = info->user_ptr[1];
-	struct devlink *devlink = linecard->devlink;
-	struct sk_buff *msg;
-	int err;
-
-	if (!linecard->ops->info_get)
-		return -EOPNOTSUPP;
-
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
-		return -ENOMEM;
-
-	mutex_lock(&linecard->state_lock);
-	err = devlink_nl_linecard_info_fill(msg, devlink, linecard,
-					    DEVLINK_CMD_LINECARD_INFO_GET,
-					    info->snd_portid, info->snd_seq, 0,
-					    info->extack);
-	mutex_unlock(&linecard->state_lock);
-	if (err) {
-		nlmsg_free(msg);
-		return err;
-	}
-
-	return genlmsg_reply(msg, info);
-}
-
-static int devlink_nl_cmd_linecard_info_get_dumpit(struct sk_buff *msg,
-						   struct netlink_callback *cb)
-{
-	struct devlink_linecard *linecard;
-	struct devlink *devlink;
-	int start = cb->args[0];
-	unsigned long index;
-	int idx = 0;
-	int err = 0;
-
-	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
-		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
-			goto retry;
-
-		mutex_lock(&devlink->linecards_lock);
-		list_for_each_entry(linecard, &devlink->linecard_list, list) {
-			if (idx < start || !linecard->ops->info_get) {
-				idx++;
-				continue;
-			}
-			mutex_lock(&linecard->state_lock);
-			err = devlink_nl_linecard_info_fill(msg, devlink, linecard,
-							    DEVLINK_CMD_LINECARD_INFO_GET,
-							    NETLINK_CB(cb->skb).portid,
-							    cb->nlh->nlmsg_seq,
-							    NLM_F_MULTI,
-							    cb->extack);
-			mutex_unlock(&linecard->state_lock);
-			if (err) {
-				mutex_unlock(&devlink->linecards_lock);
-				devlink_put(devlink);
-				goto out;
-			}
-			idx++;
-		}
-		mutex_unlock(&devlink->linecards_lock);
-retry:
-		devlink_put(devlink);
-	}
-out:
-	mutex_unlock(&devlink_mutex);
-
-	if (err != -EMSGSIZE)
-		return err;
-
-	cb->args[0] = idx;
-	return msg->len;
-}
-
 static int devlink_nl_sb_fill(struct sk_buff *msg, struct devlink *devlink,
 			      struct devlink_sb *devlink_sb,
 			      enum devlink_command cmd, u32 portid,
@@ -6602,6 +6361,10 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	return err;
 }
 
+struct devlink_info_req {
+	struct sk_buff *msg;
+};
+
 int devlink_info_driver_name_put(struct devlink_info_req *req, const char *name)
 {
 	return nla_put_string(req->msg, DEVLINK_ATTR_INFO_DRIVER_NAME, name);
@@ -9321,13 +9084,6 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_LINECARD,
 	},
-	{
-		.cmd = DEVLINK_CMD_LINECARD_INFO_GET,
-		.doit = devlink_nl_cmd_linecard_info_get_doit,
-		.dumpit = devlink_nl_cmd_linecard_info_get_dumpit,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_LINECARD,
-		/* can be retrieved by unprivileged users */
-	},
 	{
 		.cmd = DEVLINK_CMD_SB_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -10508,7 +10264,6 @@ devlink_linecard_create(struct devlink *devlink, unsigned int linecard_index,
 	linecard->priv = priv;
 	linecard->state = DEVLINK_LINECARD_STATE_UNPROVISIONED;
 	mutex_init(&linecard->state_lock);
-	INIT_LIST_HEAD(&linecard->device_list);
 
 	err = devlink_linecard_types_init(linecard);
 	if (err) {
@@ -10536,7 +10291,6 @@ void devlink_linecard_destroy(struct devlink_linecard *linecard)
 	struct devlink *devlink = linecard->devlink;
 
 	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_DEL);
-	WARN_ON(!list_empty(&linecard->device_list));
 	mutex_lock(&devlink->linecards_lock);
 	list_del(&linecard->list);
 	devlink_linecard_types_fini(linecard);
@@ -10545,52 +10299,6 @@ void devlink_linecard_destroy(struct devlink_linecard *linecard)
 }
 EXPORT_SYMBOL_GPL(devlink_linecard_destroy);
 
-/**
- *	devlink_linecard_device_create - Create a device on linecard
- *
- *	@linecard: devlink linecard
- *	@device_index: index of the linecard device
- *	@priv: user priv pointer
- *
- *	Return: Line card device structure or an ERR_PTR() encoded error code.
- */
-struct devlink_linecard_device *
-devlink_linecard_device_create(struct devlink_linecard *linecard,
-			       unsigned int device_index, void *priv)
-{
-	struct devlink_linecard_device *linecard_device;
-
-	linecard_device = kzalloc(sizeof(*linecard_device), GFP_KERNEL);
-	if (!linecard_device)
-		return ERR_PTR(-ENOMEM);
-	linecard_device->index = device_index;
-	linecard_device->priv = priv;
-	mutex_lock(&linecard->state_lock);
-	list_add_tail(&linecard_device->list, &linecard->device_list);
-	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
-	mutex_unlock(&linecard->state_lock);
-	return linecard_device;
-}
-EXPORT_SYMBOL_GPL(devlink_linecard_device_create);
-
-/**
- *	devlink_linecard_device_destroy - Destroy device on linecard
- *
- *	@linecard: devlink linecard
- *	@linecard_device: devlink linecard device
- */
-void
-devlink_linecard_device_destroy(struct devlink_linecard *linecard,
-				struct devlink_linecard_device *linecard_device)
-{
-	mutex_lock(&linecard->state_lock);
-	list_del(&linecard_device->list);
-	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
-	mutex_unlock(&linecard->state_lock);
-	kfree(linecard_device);
-}
-EXPORT_SYMBOL_GPL(devlink_linecard_device_destroy);
-
 /**
  *	devlink_linecard_provision_set - Set provisioning on linecard
  *
@@ -10623,7 +10331,6 @@ EXPORT_SYMBOL_GPL(devlink_linecard_provision_set);
 void devlink_linecard_provision_clear(struct devlink_linecard *linecard)
 {
 	mutex_lock(&linecard->state_lock);
-	WARN_ON(!list_empty(&linecard->device_list));
 	linecard->state = DEVLINK_LINECARD_STATE_UNPROVISIONED;
 	linecard->type = NULL;
 	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh
index 53a65f416770..08a922d8b86a 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh
@@ -152,7 +152,6 @@ unprovision_test()
 
 LC_16X100G_TYPE="16x100G"
 LC_16X100G_PORT_COUNT=16
-LC_16X100G_DEVICE_COUNT=4
 
 supported_types_check()
 {
@@ -178,42 +177,6 @@ supported_types_check()
 	check_err $? "16X100G not found between supported types of linecard $lc"
 }
 
-lc_info_check()
-{
-	local lc=$1
-	local fixed_hw_revision
-	local running_ini_version
-
-	fixed_hw_revision=$(devlink lc -v info $DEVLINK_DEV lc $lc -j | \
-			    jq -e -r '.[][][].versions.fixed."hw.revision"')
-	check_err $? "Failed to get linecard $lc fixed.hw.revision"
-	log_info "Linecard $lc fixed.hw.revision: \"$fixed_hw_revision\""
-	running_ini_version=$(devlink lc -v info $DEVLINK_DEV lc $lc -j | \
-			      jq -e -r '.[][][].versions.running."ini.version"')
-	check_err $? "Failed to get linecard $lc running.ini.version"
-	log_info "Linecard $lc running.ini.version: \"$running_ini_version\""
-}
-
-lc_devices_check()
-{
-	local lc=$1
-	local expected_device_count=$2
-	local device_count
-	local device
-
-	device_count=$(devlink lc show $DEVLINK_DEV lc $lc -j | \
-		       jq -e -r ".[][][].devices |length")
-	check_err $? "Failed to get linecard $lc device count"
-	[ $device_count != 0 ]
-	check_err $? "No device found on linecard $lc"
-	[ $device_count == $expected_device_count ]
-	check_err $? "Unexpected device count on linecard $lc (got $expected_device_count, expected $device_count)"
-	for (( device=0; device<device_count; device++ ))
-	do
-		log_info "Linecard $lc device $device"
-	done
-}
-
 ports_check()
 {
 	local lc=$1
@@ -243,8 +206,6 @@ provision_test()
 		unprovision_one $lc
 	fi
 	provision_one $lc $LC_16X100G_TYPE
-	lc_devices_check $lc $LC_16X100G_DEVICE_COUNT
-	lc_info_check $lc
 	ports_check $lc $LC_16X100G_PORT_COUNT
 	log_test "Provision"
 }
@@ -259,26 +220,6 @@ interface_check()
 	setup_wait
 }
 
-lc_devices_info_check()
-{
-	local lc=$1
-	local expected_device_count=$2
-	local device_count
-	local device
-	local running_device_fw
-
-	device_count=$(devlink lc info $DEVLINK_DEV lc $lc -j | \
-		       jq -e -r ".[][][].devices |length")
-	check_err $? "Failed to get linecard $lc device count"
-	for (( device=0; device<device_count; device++ ))
-	do
-		running_device_fw=$(devlink lc -v info $DEVLINK_DEV lc $lc -j | \
-				    jq -e -r ".[][][].devices[$device].versions.running.fw")
-		check_err $? "Failed to get linecard $lc device $device running fw version"
-		log_info "Linecard $lc device $device running.fw: \"$running_device_fw\""
-	done
-}
-
 activation_16x100G_test()
 {
 	RET=0
@@ -295,8 +236,6 @@ activation_16x100G_test()
 		$ACTIVATION_TIMEOUT)
 	check_err $? "Failed to get linecard $lc activated (timeout)"
 
-	lc_devices_info_check $lc $LC_16X100G_DEVICE_COUNT
-
 	interface_check
 
 	log_test "Activation 16x100G"
-- 
2.34.1

