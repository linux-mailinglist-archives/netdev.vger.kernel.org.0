Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7D047CB97
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 04:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242101AbhLVDQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 22:16:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242087AbhLVDQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 22:16:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC342C06173F
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 19:16:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88C0861853
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 03:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F208C36AEB;
        Wed, 22 Dec 2021 03:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640142971;
        bh=ifc8PY2lWsyQ1x6cN/ZGu860rsfTHXZ2qcxOHJ6wVHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K1lJPpzHr6g8xO+sHG3kafCqBAMoF32r5SrlED7MIyC+NDfJ8Ii/wfskPBkGVB+Km
         8Zs261L9dF4MxpdFQ8jT1BYSyokeyORA23JcZBpP620iZAVoSkgGzLoEwlFaTuzIBe
         NFYe+rnvO/sLMJgH0GZXkXt0RfIKXLx/uuxdzMg6nlBuWs/xuHVGalA1WOudNpYU9q
         Mg2LIou6BQH0fwyFhvIbMvIuTx2v2o1DwztPS756nXKt5UD2fK3mYbMZK4RgmlhOdZ
         UQ2I6Ytw0ffeeHi+xpoMe4OrtNOXqyGn8z0Y5aQY3WB8CpbC3Wl7KUhyFrOWsIdITE
         vyUxaP18QiqAw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 01/14] devlink: Add new "io_eq_size" generic device param
Date:   Tue, 21 Dec 2021 19:15:51 -0800
Message-Id: <20211222031604.14540-2-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211222031604.14540-1-saeed@kernel.org>
References: <20211222031604.14540-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Add new device generic parameter to determine the size of the
I/O completion EQs.

For example, to reduce I/O EQ size to 64, execute:
$ devlink dev param set pci/0000:06:00.0 \
              name io_eq_size value 64 cmode driverinit
$ devlink dev reload pci/0000:06:00.0

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 Documentation/networking/devlink/devlink-params.rst | 3 +++
 include/net/devlink.h                               | 4 ++++
 net/core/devlink.c                                  | 5 +++++
 3 files changed, 12 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index b7dfe693a332..547c0b430c9e 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -129,3 +129,6 @@ own name.
        will NACK any attempt of other host to reset the device. This parameter
        is useful for setups where a device is shared by different hosts, such
        as multi-host setup.
+   * - ``io_eq_size``
+     - u32
+     - Control the size of I/O completion EQs.
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 3276a29f2b81..b5f4acd0e0cd 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -459,6 +459,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_RDMA,
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_VNET,
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_IWARP,
+	DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -511,6 +512,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_ENABLE_IWARP_NAME "enable_iwarp"
 #define DEVLINK_PARAM_GENERIC_ENABLE_IWARP_TYPE DEVLINK_PARAM_TYPE_BOOL
 
+#define DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_NAME "io_eq_size"
+#define DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_TYPE DEVLINK_PARAM_TYPE_U32
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 0a9349a02cad..e2e38b8872c8 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4466,6 +4466,11 @@ static const struct devlink_param devlink_param_generic[] = {
 		.name = DEVLINK_PARAM_GENERIC_ENABLE_IWARP_NAME,
 		.type = DEVLINK_PARAM_GENERIC_ENABLE_IWARP_TYPE,
 	},
+	{
+		.id = DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
+		.name = DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_NAME,
+		.type = DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_TYPE,
+	},
 };
 
 static int devlink_param_generic_verify(const struct devlink_param *param)
-- 
2.33.1

