Return-Path: <netdev+bounces-9050-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A28E3726BB0
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:27:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D6A1281566
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:27:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C9383C08E;
	Wed,  7 Jun 2023 20:24:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38243B8CC
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 20:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE52C433AC;
	Wed,  7 Jun 2023 20:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686169452;
	bh=7lyOIoT/TBSgk3RDEI7BY/QIKUbWHOn8VZQiorQjwEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tLvyvQv6WSYYcKJTyF5PvXJNEGizO0fOZ+kFzjXzp8wvG9w3FrU/+MlaE68DqCwdt
	 VmlxgbM3woUUsmApGNb5rOZcPBHUo79COridMeBPp5hDMF30NLTwfVIu4aTkEFT5KM
	 SPe00qqGz3Z0SU3sAR22tS7pcKyUYhKF0o5eNpwK7nrNKTXTYa8Pk3frZxUhr7KVe6
	 de8PDgJQfAODZ2uRKRBCpQeLhjmkhFopWW53hOPSQmpzHcas/ZY9PltdPaeRAELJPL
	 3sSo4oGN4lwW691GSAIR8A8RYwvzMsFiPBFir2L1abuOFwuz+Dc3Zol5mU9glUhlel
	 vHlFXBgP2AwhQ==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	jiri@resnulli.us,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 11/11] tools: ynl: add sample for devlink
Date: Wed,  7 Jun 2023 13:24:03 -0700
Message-Id: <20230607202403.1089925-12-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230607202403.1089925-1-kuba@kernel.org>
References: <20230607202403.1089925-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a sample to show off how to issue basic devlink requests.
For added testing issue get requests while walking a dump.

$ ./devlink
netdevsim/netdevsim1:
    driver: netdevsim
    running fw:
        fw.mgmt: 10.20.30
    ...
netdevsim/netdevsim2:
    driver: netdevsim
    running fw:
        fw.mgmt: 10.20.30
    ...

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/samples/.gitignore |  1 +
 tools/net/ynl/samples/devlink.c  | 60 ++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+)
 create mode 100644 tools/net/ynl/samples/devlink.c

diff --git a/tools/net/ynl/samples/.gitignore b/tools/net/ynl/samples/.gitignore
index 7b1f5179cb54..a24678b67557 100644
--- a/tools/net/ynl/samples/.gitignore
+++ b/tools/net/ynl/samples/.gitignore
@@ -1 +1,2 @@
+devlink
 netdev
diff --git a/tools/net/ynl/samples/devlink.c b/tools/net/ynl/samples/devlink.c
new file mode 100644
index 000000000000..d2611d7ebab4
--- /dev/null
+++ b/tools/net/ynl/samples/devlink.c
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <stdio.h>
+#include <string.h>
+
+#include <ynl.h>
+
+#include "devlink-user.h"
+
+int main(int argc, char **argv)
+{
+	struct devlink_get_list *devs;
+	struct ynl_sock *ys;
+
+	ys = ynl_sock_create(&ynl_devlink_family, NULL);
+	if (!ys)
+		return 1;
+
+	devs = devlink_get_dump(ys);
+	if (!devs)
+		goto err_close;
+
+	ynl_dump_foreach(devs, d) {
+		struct devlink_info_get_req *info_req;
+		struct devlink_info_get_rsp *info_rsp;
+
+		printf("%s/%s:\n", d->bus_name, d->dev_name);
+
+		info_req = devlink_info_get_req_alloc();
+		devlink_info_get_req_set_bus_name(info_req, d->bus_name);
+		devlink_info_get_req_set_dev_name(info_req, d->dev_name);
+
+		info_rsp = devlink_info_get(ys, info_req);
+		devlink_info_get_req_free(info_req);
+		if (!info_rsp)
+			goto err_free_devs;
+
+		if (info_rsp->_present.info_driver_name_len)
+			printf("    driver: %s\n", info_rsp->info_driver_name);
+		if (info_rsp->n_info_version_running)
+			printf("    running fw:\n");
+		for (unsigned i = 0; i < info_rsp->n_info_version_running; i++)
+			printf("        %s: %s\n",
+			       info_rsp->info_version_running[i].info_version_name,
+			       info_rsp->info_version_running[i].info_version_value);
+		printf("    ...\n");
+		devlink_info_get_rsp_free(info_rsp);
+	}
+	devlink_get_list_free(devs);
+
+	ynl_sock_destroy(ys);
+
+	return 0;
+
+err_free_devs:
+	devlink_get_list_free(devs);
+err_close:
+	fprintf(stderr, "YNL: %s\n", ys->err.msg);
+	ynl_sock_destroy(ys);
+	return 2;
+}
-- 
2.40.1


