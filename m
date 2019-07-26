Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD2376A56
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 15:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbfGZN6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 09:58:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387575AbfGZNkx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 09:40:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1D5B22BEF;
        Fri, 26 Jul 2019 13:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148452;
        bh=b8v1s0/Nhsc9bXPHePJK13Qv88Pa349rf1WKvsM3Ge0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a7pldTrY4cJrA8iHQ+jAceYnj4V7yfSqrvscA4vLuYkm6UDGzXS9bjc6fcnbfGMNf
         qCAThAeR+rZinjFBqdjfEt5KxLKFLgU1+xyiwa6YL2o9ahD0QjGjEtZMAe58Jyy0DA
         xhxFr8kGtFenwQv3OgQTIwFvUH75tCxcgzsNHnt0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 48/85] libbpf: fix another GCC8 warning for strncpy
Date:   Fri, 26 Jul 2019 09:38:58 -0400
Message-Id: <20190726133936.11177-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit 763ff0e7d9c72e7094b31e7fb84a859be9325635 ]

Similar issue was fixed in cdfc7f888c2a ("libbpf: fix GCC8 warning for
strncpy") already. This one was missed. Fixing now.

Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/xsk.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 38667b62f1fe..aa37005209aa 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -561,7 +561,8 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 		err = -errno;
 		goto out_socket;
 	}
-	strncpy(xsk->ifname, ifname, IFNAMSIZ);
+	strncpy(xsk->ifname, ifname, IFNAMSIZ - 1);
+	xsk->ifname[IFNAMSIZ - 1] = '\0';
 
 	err = xsk_set_xdp_socket_config(&xsk->config, usr_config);
 	if (err)
-- 
2.20.1

