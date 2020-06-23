Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46AB12050D8
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 13:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732517AbgFWLfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 07:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732501AbgFWLfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 07:35:21 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6930FC061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 04:35:20 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id g18so11100981wrm.2
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 04:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=so/eR9c8n/fC+sow3/DJAceBbVn03guIfZvf2Xc25l4=;
        b=Zdxa40+fm79tuktMzZLUj3oa4v35qq62K5NYA8PLO91VVV7PBe2kLoDj4PAWMh0IQF
         nPCquXBcHAhV4RhHcGUyk03sDFjU2PGB6aF1ohF2Ko8BBdLpvxGKFitqa8ohA/yE+z/b
         RuQMZSTk150YrGMJGQLh+WWc85V0Zn9/yNCas=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=so/eR9c8n/fC+sow3/DJAceBbVn03guIfZvf2Xc25l4=;
        b=plFwLGAgzmdpW9I3vQ757jCYmpKXD3rqxxsx0A2n++0F/t7xoMxPzABGZEAj1hp0rO
         /U5K2I6kOQn9CtCH5PZ1hMuYTgwk6bPf/41JaY/zLef7NEMkXYZFwMCpbI6iExfIKQRC
         G67r4Bfwq2shjfucnYCY7RJEGX2sOA+YbAxBanShu0N8KxRfF/8iuJXC0HWjFK47qMCR
         vacgHB8tB6G6IFyMDuSQPmAwKmtA0vb8jA4P4NoZus8d7ojPktGkbzvsKF5SiYp9K+ra
         rDhuM65yDtdklg2b9TVhrnsU68kQRDNLEfV1ENrRigOasWnN/DHUNl/n5tE1FHIjdPya
         zxYA==
X-Gm-Message-State: AOAM531l8xRdf6TFJM4kpm8V/tlEojtUtwCP7nNpBtSI1M0JAmvqv5s8
        WqM+6iT6s/hyBtOjChxyloh0rg==
X-Google-Smtp-Source: ABdhPJxUzTJSSQTvf9GbrbYbFw3QEgIBfeW89owiv5iDAixhXCrw1pheHxCmE8pZLyGwFBcweEKK0g==
X-Received: by 2002:adf:8b18:: with SMTP id n24mr25990780wra.372.1592912118841;
        Tue, 23 Jun 2020 04:35:18 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id r3sm2237604wrg.70.2020.06.23.04.35.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jun 2020 04:35:18 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com, kuba@kernel.org,
        jiri@mellanox.com, jiri@resnulli.us,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [RFC net-next] devlink: Add reset subcommand.
Date:   Tue, 23 Jun 2020 17:02:49 +0530
Message-Id: <1592911969-10611-1-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Advanced NICs support live reset of some of the hardware
components, that resets the device immediately with all the
host drivers loaded.

Add devlink reset subcommand to support live and deferred modes
of reset. It allows to reset the hardware components of the
entire device and supports the following fields:

component:
----------
1. MGMT : Management processor.
2. IRA : Interrupt requester.
3. DMA : DMA engine.
4. FILTER : Filtering/flow direction.
5. OFFLOAD : Protocol offload.
6. MAC : Media access controller.
7. PHY : Transceiver/PHY.
8. RAM : RAM shared between multiple components.
9. ROCE : RoCE management processor.
10. AP : Application processor.
11. All : All possible components.

Drivers are allowed to reset only a subset of requested components.

width:
------
1. single - Single function.
2. multi  - Multiple functions.

mode:
-----
1. deferred - Reset will happen after unloading all the host drivers
              on the device. This is be default reset type, if user
              does not specify the type.
2. live - Reset will happen immediately with all host drivers loaded
          in real time. If the live reset is not supported, driver
          will return the error.

This patch is a proposal in continuation to discussion to the
following thread:

"[PATCH v3 net-next 0/6] bnxt_en: Add 'enable_live_dev_reset' and 'allow_live_dev_reset' generic devlink params."

and here is the URL to the patch series:

https://patchwork.ozlabs.org/project/netdev/list/?series=180426&state=*

If the proposal looks good, I will re-send the whole patchset
including devlink changes and driver usage.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
---
 Documentation/networking/devlink/devlink-reset.rst | 56 ++++++++++++++
 include/net/devlink.h                              |  2 +
 include/uapi/linux/devlink.h                       | 56 ++++++++++++++
 net/core/devlink.c                                 | 85 ++++++++++++++++++++++
 4 files changed, 199 insertions(+)
 create mode 100644 Documentation/networking/devlink/devlink-reset.rst

diff --git a/Documentation/networking/devlink/devlink-reset.rst b/Documentation/networking/devlink/devlink-reset.rst
new file mode 100644
index 0000000..0525e24
--- /dev/null
+++ b/Documentation/networking/devlink/devlink-reset.rst
@@ -0,0 +1,56 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
+.. _devlink_reset:
+
+=============
+Devlink reset
+=============
+
+The ``devlink-reset`` API allows reset the hardware components of the device.
+After the reset, it loads the pending updated firmware image.
+Example use::
+
+  $ devlink dev reset pci/0000:05:00.0 components mode
+
+Note that user can mention multiple components.
+
+================
+Reset components
+================
+
+List of available components::
+
+``DEVLINK_RESET_COMP_MGMT`` - Management processor.
+``DEVLINK_RESET_COMP_IRQ`` - Interrupt requester.
+``DEVLINK_RESET_COMP_DMA`` - DMA engine.
+``DEVLINK_RESET_COMP_FILTER`` - Filtering/flow direction.
+``DEVLINK_RESET_COMP_OFFLOAD`` - Protocol offload.
+``DEVLINK_RESET_COMP_MAC`` - Media access controller.
+``DEVLINK_RESET_COMP_PHY`` - Transceiver/PHY.
+``DEVLINK_RESET_COMP_RAM`` - RAM shared between multiple components.
+``DEVLINK_RESET_COMP_ROCE`` - RoCE management processor.
+``DEVLINK_RESET_COMP_AP``   - Application processor.
+``DEVLINK_RESET_COMP_ALL``  - All components.
+
+===========
+Reset width
+===========
+
+List of available widths::
+
+``DEVLINK_RESET_WIDTH_SINGLE`` - Single dedicated function.
+``DEVLINK_RESET_WIDTH_MULTI``  - Multiple functions.
+
+Note that if user specifies DEVLINK_RESET_WIDTH_SINGLE in a multi-host environment,
+driver returns error if it does not support resetting a single function.
+
+===========
+Reset modes
+===========
+
+List of available reset modes::
+
+``DEVLINK_RESET_MODE_DEFERRED``  - Reset happens after all host drivers are
+                                   unloaded on the device.
+``DEVLINK_RESET_MODE_LIVE``      - Reset happens immediately, with all loaded
+                                   host drivers in real time.
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 428f55f..a71c8f5 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1129,6 +1129,8 @@ struct devlink_ops {
 	int (*port_function_hw_addr_set)(struct devlink *devlink, struct devlink_port *port,
 					 const u8 *hw_addr, int hw_addr_len,
 					 struct netlink_ext_ack *extack);
+	int (*reset)(struct devlink *devlink, u32 *components, u8 width, u8 mode,
+		     struct netlink_ext_ack *extack);
 };
 
 static inline void *devlink_priv(struct devlink *devlink)
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 87c83a8..c9d9654 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -122,6 +122,9 @@ enum devlink_command {
 	DEVLINK_CMD_TRAP_POLICER_NEW,
 	DEVLINK_CMD_TRAP_POLICER_DEL,
 
+	DEVLINK_CMD_RESET,
+	DEVLINK_CMD_RESET_STATUS,	/* notification only */
+
 	/* add new commands above here */
 	__DEVLINK_CMD_MAX,
 	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
@@ -265,6 +268,54 @@ enum devlink_trap_type {
 	DEVLINK_TRAP_TYPE_CONTROL,
 };
 
+/**
+ * enum devlink_reset_component - Reset components.
+ * @DEVLINK_RESET_COMP_MGMT: Management processor.
+ * @DEVLINK_RESET_COMP_IRQ: Interrupt requester.
+ * @DEVLINK_RESET_COMP_DMA: DMA engine.
+ * @DEVLINK_RESET_COMP_FILTER: Filtering/flow direction.
+ * @DEVLINK_RESET_COMP_OFFLOAD: Protocol offload.
+ * @DEVLINK_RESET_COMP_MAC: Media access controller.
+ * @DEVLINK_RESET_COMP_PHY: Transceiver/PHY.
+ * @DEVLINK_RESET_COMP_RAM: RAM shared between multiple components.
+ * @DEVLINK_RESET_COMP_ROCE: RoCE management processor.
+ * @DEVLINK_RESET_COMP_AP: Application processor.
+ * @DEVLINK_RESET_COMP_ALL: All components.
+ */
+enum devlink_reset_component {
+	DEVLINK_RESET_COMP_MGMT		= (1 << 0),
+	DEVLINK_RESET_COMP_IRQ		= (1 << 1),
+	DEVLINK_RESET_COMP_DMA		= (1 << 2),
+	DEVLINK_RESET_COMP_FILTER	= (1 << 3),
+	DEVLINK_RESET_COMP_OFFLOAD	= (1 << 4),
+	DEVLINK_RESET_COMP_MAC		= (1 << 5),
+	DEVLINK_RESET_COMP_PHY		= (1 << 6),
+	DEVLINK_RESET_COMP_RAM		= (1 << 7),
+	DEVLINK_RESET_COMP_ROCE		= (1 << 8),
+	DEVLINK_RESET_COMP_AP		= (1 << 9),
+	DEVLINK_RESET_COMP_ALL		= 0xffffffff,
+};
+
+/**
+ * enum devlink_reset_width - Number of functions to be reset.
+ * @DEVLINK_RESET_WIDTH_SINGLE: Single dedicated function will be reset.
+ * @DEVLINK_RESET_WIDTH_MULTI: Multiple functions will be reset in a SLED.
+ */
+enum devlink_reset_width {
+	DEVLINK_RESET_WIDTH_SINGLE	= 0,
+	DEVLINK_RESET_WIDTH_MULTI	= 1,
+};
+
+/**
+ * enum devlink_reset_mode - Modes of reset.
+ * @DEVLINK_RESET_MODE_DEFERRED: Reset will happen after host drivers are unloaded.
+ * @DEVLINK_RESET_MODE_LIVE: All host drivers also will be reset without reloading manually.
+ */
+enum devlink_reset_mode {
+	DEVLINK_RESET_MODE_DEFERRED	= 0,
+	DEVLINK_RESET_MODE_LIVE		= 1,
+};
+
 enum {
 	/* Trap can report input port as metadata */
 	DEVLINK_ATTR_TRAP_METADATA_TYPE_IN_PORT,
@@ -455,6 +506,11 @@ enum devlink_attr {
 
 	DEVLINK_ATTR_INFO_BOARD_SERIAL_NUMBER,	/* string */
 
+	DEVLINK_ATTR_RESET_COMPONENTS,		/* u32 */
+	DEVLINK_ATTR_RESET_WIDTH,		/* u8 */
+	DEVLINK_ATTR_RESET_MODE,		/* u8 */
+	DEVLINK_ATTR_RESET_STATUS_MSG,		/* string */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 455998a..1567467 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6797,6 +6797,82 @@ static int devlink_nl_cmd_trap_policer_set_doit(struct sk_buff *skb,
 	return devlink_trap_policer_set(devlink, policer_item, info);
 }
 
+static int devlink_nl_reset_fill(struct sk_buff *msg, struct devlink *devlink,
+				 const char *status_msg, u32 components)
+{
+	void *hdr;
+
+	hdr = genlmsg_put(msg, 0, 0, &devlink_nl_family, 0, DEVLINK_CMD_RESET_STATUS);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (devlink_nl_put_handle(msg, devlink))
+		goto nla_put_failure;
+
+	if (status_msg && nla_put_string(msg, DEVLINK_ATTR_RESET_STATUS_MSG, status_msg))
+		goto nla_put_failure;
+
+	if (nla_put_u32(msg, DEVLINK_ATTR_RESET_COMPONENTS, components))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+	return 0;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
+static void __devlink_reset_notify(struct devlink *devlink, const char *status_msg, u32 components)
+{
+	struct sk_buff *msg;
+	int err;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	err = devlink_nl_reset_fill(msg, devlink, status_msg, components);
+	if (err)
+		goto out;
+
+	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink), msg, 0,
+				DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
+	return;
+
+out:
+	nlmsg_free(msg);
+}
+
+static int devlink_nl_cmd_reset(struct sk_buff *skb, struct genl_info *info)
+{
+	struct devlink *devlink = info->user_ptr[0];
+	u32 components, req_comps;
+	struct nlattr *nla_type;
+	u8 width, mode;
+	int err;
+
+	if (!devlink->ops->reset)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[DEVLINK_ATTR_RESET_COMPONENTS])
+		return -EINVAL;
+	components = nla_get_u32(info->attrs[DEVLINK_ATTR_RESET_COMPONENTS]);
+
+	nla_type = info->attrs[DEVLINK_ATTR_RESET_WIDTH];
+	width = nla_type ? nla_get_u8(nla_type) : DEVLINK_RESET_WIDTH_SINGLE;
+
+	nla_type = info->attrs[DEVLINK_ATTR_RESET_MODE];
+	mode = nla_type ? nla_get_u8(nla_type) : DEVLINK_RESET_MODE_DEFERRED;
+
+	req_comps = components;
+	__devlink_reset_notify(devlink, "Reset request", components);
+	err = devlink->ops->reset(devlink, &components, width, mode, info->extack);
+	__devlink_reset_notify(devlink, "Components reset", req_comps & ~components);
+
+	return err;
+}
+
 static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_UNSPEC] = { .strict_start_type =
 		DEVLINK_ATTR_TRAP_POLICER_ID },
@@ -6842,6 +6918,9 @@ static int devlink_nl_cmd_trap_policer_set_doit(struct sk_buff *skb,
 	[DEVLINK_ATTR_TRAP_POLICER_RATE] = { .type = NLA_U64 },
 	[DEVLINK_ATTR_TRAP_POLICER_BURST] = { .type = NLA_U64 },
 	[DEVLINK_ATTR_PORT_FUNCTION] = { .type = NLA_NESTED },
+	[DEVLINK_ATTR_RESET_COMPONENTS] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_RESET_WIDTH] = { .type = NLA_U8 },
+	[DEVLINK_ATTR_RESET_MODE] = { .type = NLA_U8 },
 };
 
 static const struct genl_ops devlink_nl_ops[] = {
@@ -7190,6 +7269,12 @@ static int devlink_nl_cmd_trap_policer_set_doit(struct sk_buff *skb,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 	},
+	{
+		.cmd = DEVLINK_CMD_RESET,
+		.doit = devlink_nl_cmd_reset,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
+	},
 };
 
 static struct genl_family devlink_nl_family __ro_after_init = {
-- 
1.8.3.1

