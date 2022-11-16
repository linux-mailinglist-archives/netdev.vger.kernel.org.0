Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 519BC62B2C7
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 06:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiKPFeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 00:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiKPFeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 00:34:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E0312ADB
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 21:34:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73DFFB81BE2
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 05:34:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA01C433D6;
        Wed, 16 Nov 2022 05:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668576872;
        bh=6Tr2gP+WeaC5Djemtg9TPN+puZd3jqVUJNkoih7KBEQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ipbKdC9gZD/T38UO5fZxn4cYz4KiL/V9uWIxJELWrOP49kkAySn03sLXcFolZiwEB
         GvbqnXMr4PmJ6ez+XP3MXSgYc3aEUUKB+tPkcrTNhdX97wg82+NZt0L7YdqvBqP4UM
         h/e7O53CEvBszsX2q04nvx8Dfnf9ac8AsLKYamqkY24Z/bPoKJ8VQlh+pBtFHKJcQs
         dt87EwhNOUwozY52VjOt9rcigMAfx3+EYiE0olKACWOqR3ggxZMdYYoTIivtic5MG3
         vX23qcKoHxNwJ0I+m/OA6dsK7Hx4ePz0lYFM8Gr53iYI2LxLWzeid7SSsUcBesRlIO
         IWReuAejBiMPQ==
Date:   Tue, 15 Nov 2022 21:34:23 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jeroen de Borst <jeroendb@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jesse.brandeburg@intel.com
Subject: Re: [PATCH net-next v3 1/2] gve: Adding a new AdminQ command to
 verify driver
Message-ID: <Y3R2X0C15iNTCo8D@x130.lan>
References: <20221114233514.1913116-1-jeroendb@google.com>
 <20221114233514.1913116-2-jeroendb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221114233514.1913116-2-jeroendb@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14 Nov 15:35, Jeroen de Borst wrote:
>Check whether the driver is compatible with the device
>presented.
>
>Signed-off-by: Jeroen de Borst <jeroendb@google.com>
>Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
>---
> drivers/net/ethernet/google/gve/gve.h        |  1 +
> drivers/net/ethernet/google/gve/gve_adminq.c | 19 +++++++
> drivers/net/ethernet/google/gve/gve_adminq.h | 49 ++++++++++++++++++
> drivers/net/ethernet/google/gve/gve_main.c   | 52 ++++++++++++++++++++
> 4 files changed, 121 insertions(+)
>
>diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
>index 5655da9cd236..64eb0442c82f 100644
>--- a/drivers/net/ethernet/google/gve/gve.h
>+++ b/drivers/net/ethernet/google/gve/gve.h
>@@ -563,6 +563,7 @@ struct gve_priv {
> 	u32 adminq_report_stats_cnt;
> 	u32 adminq_report_link_speed_cnt;
> 	u32 adminq_get_ptype_map_cnt;
>+	u32 adminq_verify_driver_compatibility_cnt;
>
> 	/* Global stats */
> 	u32 interface_up_cnt; /* count of times interface turned up since last reset */
>diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
>index f7621ab672b9..6a12b30a9f87 100644
>--- a/drivers/net/ethernet/google/gve/gve_adminq.c
>+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
>@@ -407,6 +407,9 @@ static int gve_adminq_issue_cmd(struct gve_priv *priv,
> 	case GVE_ADMINQ_GET_PTYPE_MAP:
> 		priv->adminq_get_ptype_map_cnt++;
> 		break;
>+	case GVE_ADMINQ_VERIFY_DRIVER_COMPATIBILITY:
>+		priv->adminq_verify_driver_compatibility_cnt++;
>+		break;
> 	default:
> 		dev_err(&priv->pdev->dev, "unknown AQ command opcode %d\n", opcode);
> 	}
>@@ -878,6 +881,22 @@ int gve_adminq_report_stats(struct gve_priv *priv, u64 stats_report_len,
> 	return gve_adminq_execute_cmd(priv, &cmd);
> }
>
>+int gve_adminq_verify_driver_compatibility(struct gve_priv *priv,
>+					   u64 driver_info_len,
>+					   dma_addr_t driver_info_addr)
>+{
>+	union gve_adminq_command cmd;
>+
>+	memset(&cmd, 0, sizeof(cmd));
>+	cmd.opcode = cpu_to_be32(GVE_ADMINQ_VERIFY_DRIVER_COMPATIBILITY);
>+	cmd.verify_driver_compatibility = (struct gve_adminq_verify_driver_compatibility) {
>+		.driver_info_len = cpu_to_be64(driver_info_len),
>+		.driver_info_addr = cpu_to_be64(driver_info_addr),
>+	};
>+
>+	return gve_adminq_execute_cmd(priv, &cmd);
>+}
>+
> int gve_adminq_report_link_speed(struct gve_priv *priv)
> {
> 	union gve_adminq_command gvnic_cmd;
>diff --git a/drivers/net/ethernet/google/gve/gve_adminq.h b/drivers/net/ethernet/google/gve/gve_adminq.h
>index 83c0b40cd2d9..b9ee8be73f96 100644
>--- a/drivers/net/ethernet/google/gve/gve_adminq.h
>+++ b/drivers/net/ethernet/google/gve/gve_adminq.h
>@@ -24,6 +24,7 @@ enum gve_adminq_opcodes {
> 	GVE_ADMINQ_REPORT_STATS			= 0xC,
> 	GVE_ADMINQ_REPORT_LINK_SPEED		= 0xD,
> 	GVE_ADMINQ_GET_PTYPE_MAP		= 0xE,
>+	GVE_ADMINQ_VERIFY_DRIVER_COMPATIBILITY	= 0xF,
> };
>
> /* Admin queue status codes */
>@@ -146,6 +147,49 @@ enum gve_sup_feature_mask {
>
> #define GVE_DEV_OPT_LEN_GQI_RAW_ADDRESSING 0x0
>
>+#define GVE_VERSION_STR_LEN 128
>+
>+enum gve_driver_capbility {
>+	gve_driver_capability_gqi_qpl = 0,
>+	gve_driver_capability_gqi_rda = 1,
>+	gve_driver_capability_dqo_qpl = 2, /* reserved for future use */
>+	gve_driver_capability_dqo_rda = 3,
>+};
>+
>+#define GVE_CAP1(a) BIT((int)a)
>+#define GVE_CAP2(a) BIT(((int)a) - 64)
>+#define GVE_CAP3(a) BIT(((int)a) - 128)
>+#define GVE_CAP4(a) BIT(((int)a) - 192)
>+
>+#define GVE_DRIVER_CAPABILITY_FLAGS1 \
>+	(GVE_CAP1(gve_driver_capability_gqi_qpl) | \
>+	 GVE_CAP1(gve_driver_capability_gqi_rda) | \
>+	 GVE_CAP1(gve_driver_capability_dqo_rda))
>+
>+#define GVE_DRIVER_CAPABILITY_FLAGS2 0x0
>+#define GVE_DRIVER_CAPABILITY_FLAGS3 0x0
>+#define GVE_DRIVER_CAPABILITY_FLAGS4 0x0
>+
>+struct gve_driver_info {
>+	u8 os_type;	/* 0x01 = Linux */
>+	u8 driver_major;
>+	u8 driver_minor;
>+	u8 driver_sub;
>+	__be32 os_version_major;
>+	__be32 os_version_minor;
>+	__be32 os_version_sub;
>+	__be64 driver_capability_flags[4];
>+	u8 os_version_str1[GVE_VERSION_STR_LEN];
>+	u8 os_version_str2[GVE_VERSION_STR_LEN];
>+};
>+
>+struct gve_adminq_verify_driver_compatibility {
>+	__be64 driver_info_len;
>+	__be64 driver_info_addr;
>+};
>+
>+static_assert(sizeof(struct gve_adminq_verify_driver_compatibility) == 16);
>+
> struct gve_adminq_configure_device_resources {
> 	__be64 counter_array;
> 	__be64 irq_db_addr;
>@@ -345,6 +389,8 @@ union gve_adminq_command {
> 			struct gve_adminq_report_stats report_stats;
> 			struct gve_adminq_report_link_speed report_link_speed;
> 			struct gve_adminq_get_ptype_map get_ptype_map;
>+			struct gve_adminq_verify_driver_compatibility
>+						verify_driver_compatibility;
> 		};
> 	};
> 	u8 reserved[64];
>@@ -372,6 +418,9 @@ int gve_adminq_unregister_page_list(struct gve_priv *priv, u32 page_list_id);
> int gve_adminq_set_mtu(struct gve_priv *priv, u64 mtu);
> int gve_adminq_report_stats(struct gve_priv *priv, u64 stats_report_len,
> 			    dma_addr_t stats_report_addr, u64 interval);
>+int gve_adminq_verify_driver_compatibility(struct gve_priv *priv,
>+					   u64 driver_info_len,
>+					   dma_addr_t driver_info_addr);
> int gve_adminq_report_link_speed(struct gve_priv *priv);
>
> struct gve_ptype_lut;
>diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
>index 5a229a01f49d..5b40f9c53196 100644
>--- a/drivers/net/ethernet/google/gve/gve_main.c
>+++ b/drivers/net/ethernet/google/gve/gve_main.c
>@@ -12,6 +12,8 @@
> #include <linux/sched.h>
> #include <linux/timer.h>
> #include <linux/workqueue.h>
>+#include <linux/utsname.h>
>+#include <linux/version.h>
> #include <net/sch_generic.h>
> #include "gve.h"
> #include "gve_dqo.h"
>@@ -30,6 +32,49 @@
> const char gve_version_str[] = GVE_VERSION;
> static const char gve_version_prefix[] = GVE_VERSION_PREFIX;
>
>+static int gve_verify_driver_compatibility(struct gve_priv *priv)
>+{
>+	int err;
>+	struct gve_driver_info *driver_info;
>+	dma_addr_t driver_info_bus;
>+
>+	driver_info = dma_alloc_coherent(&priv->pdev->dev,
>+					 sizeof(struct gve_driver_info),
>+					 &driver_info_bus, GFP_KERNEL);
>+	if (!driver_info)
>+		return -ENOMEM;
>+
>+	*driver_info = (struct gve_driver_info) {
>+		.os_type = 1, /* Linux */
>+		.os_version_major = cpu_to_be32(LINUX_VERSION_MAJOR),
>+		.os_version_minor = cpu_to_be32(LINUX_VERSION_SUBLEVEL),
>+		.os_version_sub = cpu_to_be32(LINUX_VERSION_PATCHLEVEL),
>+		.driver_capability_flags = {
>+			cpu_to_be64(GVE_DRIVER_CAPABILITY_FLAGS1),
>+			cpu_to_be64(GVE_DRIVER_CAPABILITY_FLAGS2),
>+			cpu_to_be64(GVE_DRIVER_CAPABILITY_FLAGS3),
>+			cpu_to_be64(GVE_DRIVER_CAPABILITY_FLAGS4),
>+		},
>+	};
>+	strscpy(driver_info->os_version_str1, utsname()->release,
>+		sizeof(driver_info->os_version_str1));
>+	strscpy(driver_info->os_version_str2, utsname()->version,
>+		sizeof(driver_info->os_version_str2));
>+
>+	err = gve_adminq_verify_driver_compatibility(priv,
>+						     sizeof(struct gve_driver_info),
>+						     driver_info_bus);
>+
>+	/* It's ok if the device doesn't support this */
>+	if (err == -EOPNOTSUPP)
>+		err = 0;
>+
I always find these exception interesting so i had to attempt and chase this
error code down to the source and couldn't find it. 
I think you meant -ENOTSUPP: which comes from gve_adminq_parse_err()

case GVE_ADMINQ_COMMAND_ERROR_UNIMPLEMENTED:
		return -ENOTSUPP;

because there isn't any path in the code that returns -EOPNOTSUPP;

but isn't there any capability that could tell if driver version
compatibility command is supported by device, prior to issuing the command,
so the code can be more explicit.

