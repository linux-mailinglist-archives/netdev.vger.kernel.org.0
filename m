Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A752547CB98
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 04:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242105AbhLVDQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 22:16:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44970 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242089AbhLVDQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 22:16:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B041C617B3
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 03:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4058C36AEE;
        Wed, 22 Dec 2021 03:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640142972;
        bh=E/g9XZn5cw8F0mT+RT0BZBMJARU0YHRe+QlRvTgwdxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DZE/UuE4atgjzHnMhM3QzxH3jyt80P4JhaFsUX1s7eNSkyQNt9qZJMAI0YI9ES61L
         5RMFNmtQok+pC5AWjTZIV2eVvcyJgdvCfl5irCU9oBlvbtD+1IIHjLZghh7R7K7ZoN
         DVAjqwYjJHN34w0520PkTAupWvZzP2mgnULW67zYzqeiGriFkVzWFmG/b50fDqlBIS
         5TA2rlUCc9Xf/z632BqDyv/NcptKmBD+SRFYFpDIn11/ZLx6Y5wlnGyiofM9VGT6AY
         xTr25geNz9zlqIvSyutwb3wcZoKE58p+ef+y44rkeJQ3LEz8A+JjLaWLKf/FIoa9v8
         ByCN5MtlkEJvg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 03/14] devlink: Add new "event_eq_size" generic device param
Date:   Tue, 21 Dec 2021 19:15:53 -0800
Message-Id: <20211222031604.14540-4-saeed@kernel.org>
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
asynchronous control events EQ.

For example, to reduce event EQ size to 64, execute:
$ devlink dev param set pci/0000:06:00.0 \
              name event_eq_size value 64 cmode driverinit
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
index 547c0b430c9e..da0b5e7f8eec 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -132,3 +132,6 @@ own name.
    * - ``io_eq_size``
      - u32
      - Control the size of I/O completion EQs.
+   * - ``event_eq_size``
+     - u32
+     - Control the size of asynchronous control events EQ.
diff --git a/include/net/devlink.h b/include/net/devlink.h
index b5f4acd0e0cd..8d5349d2fb68 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -460,6 +460,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_VNET,
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_IWARP,
 	DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
+	DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -515,6 +516,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_NAME "io_eq_size"
 #define DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_TYPE DEVLINK_PARAM_TYPE_U32
 
+#define DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_NAME "event_eq_size"
+#define DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_TYPE DEVLINK_PARAM_TYPE_U32
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/core/devlink.c b/net/core/devlink.c
index e2e38b8872c8..6366ce324dce 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4471,6 +4471,11 @@ static const struct devlink_param devlink_param_generic[] = {
 		.name = DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_NAME,
 		.type = DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_TYPE,
 	},
+	{
+		.id = DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
+		.name = DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_NAME,
+		.type = DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_TYPE,
+	},
 };
 
 static int devlink_param_generic_verify(const struct devlink_param *param)
-- 
2.33.1

