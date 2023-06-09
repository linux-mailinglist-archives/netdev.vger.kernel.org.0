Return-Path: <netdev+bounces-9736-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41C2572A58B
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 23:47:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 904581C211C1
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:47:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 857982A9D1;
	Fri,  9 Jun 2023 21:44:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61101294D9
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 21:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE66C433AE;
	Fri,  9 Jun 2023 21:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686347041;
	bh=radbuxDbJkbz7tX/WJDrIrre7v/NXhvOboGrPvRlRgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aN8XwXpucSAWoihOF6pNryI0UDTNCJ9r+MSwy8z5Vp7qjiEU5l+0/9dwrPk8D8YaP
	 2d/Ftx4Ink5l/gfh0h8KhhW/rGa+1uHZw84/ntJUQsesZaDWaslr7H9r7HCtTFHbOO
	 /JFof9pecaCwDKIKImyS9w9X1EC7+XFDWjxcWz6UjPCOAo8NB4z4QcvWoGeIi5LIs5
	 aovmhDrjYa7EPBG72dlY3jzBcrQZ3i51LK414IyVX3ofUiECawYUR/odJy8D8TY63e
	 zYn/vQEvKjMUClOKP/ejcNrKsX2eraXPORT8gZkP+si+36mOF+aqz9wxFfZA18g8y9
	 0DQb1bnB6EtKQ==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	sdf@google.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 12/12] tools: ynl: add sample for ethtool
Date: Fri,  9 Jun 2023 14:43:46 -0700
Message-Id: <20230609214346.1605106-13-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230609214346.1605106-1-kuba@kernel.org>
References: <20230609214346.1605106-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Configuring / reading ring sizes and counts is a fairly common
operation for ethtool netlink. Present a sample doing that with
YNL:

$ ./ethtool
Channels:
    enp1s0: combined 1
   eni1np1: combined 1
   eni2np1: combined 1
Rings:
    enp1s0: rx 256 tx 256
   eni1np1: rx 0 tx 0
   eni2np1: rx 0 tx 0

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/samples/.gitignore |  1 +
 tools/net/ynl/samples/ethtool.c  | 65 ++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)
 create mode 100644 tools/net/ynl/samples/ethtool.c

diff --git a/tools/net/ynl/samples/.gitignore b/tools/net/ynl/samples/.gitignore
index a24678b67557..2aae60c4829f 100644
--- a/tools/net/ynl/samples/.gitignore
+++ b/tools/net/ynl/samples/.gitignore
@@ -1,2 +1,3 @@
+ethtool
 devlink
 netdev
diff --git a/tools/net/ynl/samples/ethtool.c b/tools/net/ynl/samples/ethtool.c
new file mode 100644
index 000000000000..a7ebbd1b98db
--- /dev/null
+++ b/tools/net/ynl/samples/ethtool.c
@@ -0,0 +1,65 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <stdio.h>
+#include <string.h>
+
+#include <ynl.h>
+
+#include <net/if.h>
+
+#include "ethtool-user.h"
+
+int main(int argc, char **argv)
+{
+	struct ethtool_channels_get_req_dump creq = {};
+	struct ethtool_rings_get_req_dump rreq = {};
+	struct ethtool_channels_get_list *channels;
+	struct ethtool_rings_get_list *rings;
+	struct ynl_sock *ys;
+
+	ys = ynl_sock_create(&ynl_ethtool_family, NULL);
+	if (!ys)
+		return 1;
+
+	creq._present.header = 1; /* ethtool needs an empty nest, sigh */
+	channels = ethtool_channels_get_dump(ys, &creq);
+	if (!channels)
+		goto err_close;
+
+	printf("Channels:\n");
+	ynl_dump_foreach(channels, dev) {
+		printf("  %8s: ", dev->header.dev_name);
+		if (dev->_present.rx_count)
+			printf("rx %d ", dev->rx_count);
+		if (dev->_present.tx_count)
+			printf("tx %d ", dev->tx_count);
+		if (dev->_present.combined_count)
+			printf("combined %d ", dev->combined_count);
+		printf("\n");
+	}
+	ethtool_channels_get_list_free(channels);
+
+	rreq._present.header = 1; /* ethtool needs an empty nest.. */
+	rings = ethtool_rings_get_dump(ys, &rreq);
+	if (!rings)
+		goto err_close;
+
+	printf("Rings:\n");
+	ynl_dump_foreach(rings, dev) {
+		printf("  %8s: ", dev->header.dev_name);
+		if (dev->_present.rx)
+			printf("rx %d ", dev->rx);
+		if (dev->_present.tx)
+			printf("tx %d ", dev->tx);
+		printf("\n");
+	}
+	ethtool_rings_get_list_free(rings);
+
+	ynl_sock_destroy(ys);
+
+	return 0;
+
+err_close:
+	fprintf(stderr, "YNL (%d): %s\n", ys->err.code, ys->err.msg);
+	ynl_sock_destroy(ys);
+	return 2;
+}
-- 
2.40.1


