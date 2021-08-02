Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6743DCF2B
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 06:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbhHBENe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 00:13:34 -0400
Received: from lpdvsmtp11.broadcom.com ([192.19.166.231]:46084 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229988AbhHBENY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 00:13:24 -0400
Received: from dhcp-10-123-153-22.dhcp.broadcom.net (bgccx-dev-host-lnx2.bec.broadcom.net [10.123.153.22])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id D4B71EB;
        Sun,  1 Aug 2021 21:06:53 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com D4B71EB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1627877215;
        bh=uR5Gfzea/cNgnPj6GMAdEmQmjzid2r27Yttfv2940xM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q2OTgtVcpEMYGT1OBMnFOBTlg0g4LJLYKTGolkBFrgZoPSQycdI9a8mKz60BIHFEI
         ZG+KOjNYt4uGV5utdlIaFwRRa3mHDtVDweDUy5tAWfPX0Zi4qMET88UCkA16AWaS0H
         R3PmOo5EWdBtGt9q2u8my8B6RQfa3lNm7VTtdynU=
From:   Kalesh A P <kalesh-anakkur.purayil@broadcom.com>
To:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com
Cc:     netdev@vger.kernel.org, edwin.peer@broadcom.com,
        michael.chan@broadcom.com
Subject: [PATCH net-next 1/2] devlink: add device capability reporting to devlink info API
Date:   Mon,  2 Aug 2021 09:57:39 +0530
Message-Id: <20210802042740.10355-2-kalesh-anakkur.purayil@broadcom.com>
X-Mailer: git-send-email 2.10.1
In-Reply-To: <20210802042740.10355-1-kalesh-anakkur.purayil@broadcom.com>
References: <20210802042740.10355-1-kalesh-anakkur.purayil@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

It may be useful if we expose the device capabilities
to the user through devlink info API.
Add a new devlink API to allow retrieving device capabilities.

Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
---
 Documentation/networking/devlink/devlink-info.rst |  3 +++
 include/net/devlink.h                             |  2 ++
 include/uapi/linux/devlink.h                      |  3 +++
 net/core/devlink.c                                | 25 +++++++++++++++++++++++
 4 files changed, 33 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-info.rst b/Documentation/networking/devlink/devlink-info.rst
index 7572bf6..b9b32dc 100644
--- a/Documentation/networking/devlink/devlink-info.rst
+++ b/Documentation/networking/devlink/devlink-info.rst
@@ -78,6 +78,9 @@ versions is generally discouraged - here, and via any other Linux API.
        ``stored`` versions when new software is flashed, it must not report
        them.
 
+   * - ``capabilities``
+     - Group for device capabilities.
+
 Each version can be reported at most once in each version group. Firmware
 components stored on the flash should feature in both the ``running`` and
 ``stored`` sections, if device is capable of reporting ``stored`` versions
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 08f4c61..e06d781 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1687,6 +1687,8 @@ int devlink_info_version_stored_put(struct devlink_info_req *req,
 int devlink_info_version_running_put(struct devlink_info_req *req,
 				     const char *version_name,
 				     const char *version_value);
+int devlink_info_device_capability_put(struct devlink_info_req *req,
+				       const char *capability_name);
 
 int devlink_fmsg_obj_nest_start(struct devlink_fmsg *fmsg);
 int devlink_fmsg_obj_nest_end(struct devlink_fmsg *fmsg);
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 32f53a00..f61a59ae 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -551,6 +551,9 @@ enum devlink_attr {
 	DEVLINK_ATTR_RATE_NODE_NAME,		/* string */
 	DEVLINK_ATTR_RATE_PARENT_NODE_NAME,	/* string */
 
+	DEVLINK_ATTR_INFO_DEVICE_CAPABILITY_LIST,	/* nested */
+	DEVLINK_ATTR_INFO_DEVICE_CAPABILITY_NAME,	/* string */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 8fa0153..4f1ce03 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5850,6 +5850,31 @@ int devlink_info_version_running_put(struct devlink_info_req *req,
 }
 EXPORT_SYMBOL_GPL(devlink_info_version_running_put);
 
+int devlink_info_device_capability_put(struct devlink_info_req *req,
+				       const char *capability_name)
+{
+	struct nlattr *nest;
+	int err;
+
+	nest = nla_nest_start(req->msg, DEVLINK_ATTR_INFO_DEVICE_CAPABILITY_LIST);
+	if (!nest)
+		return -EMSGSIZE;
+
+	err = nla_put_string(req->msg, DEVLINK_ATTR_INFO_DEVICE_CAPABILITY_NAME,
+			     capability_name);
+	if (err)
+		goto nla_put_failure;
+
+	nla_nest_end(req->msg, nest);
+
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(req->msg, nest);
+	return err;
+}
+EXPORT_SYMBOL_GPL(devlink_info_device_capability_put);
+
 static int
 devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
 		     enum devlink_command cmd, u32 portid,
-- 
2.10.1

