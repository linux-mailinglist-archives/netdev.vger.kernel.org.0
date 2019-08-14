Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 879218C60C
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727862AbfHNCM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:12:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727049AbfHNCMZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:12:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B143E208C2;
        Wed, 14 Aug 2019 02:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748744;
        bh=yzdK0cpATKfDgE266QK3LkS15A5pMnjiRaPV3/oLKK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HIs12VncSQZzDwaziPUuf8ieOi2wuBWDLiq6XiNX8+AM+c4IAQi9vhD5IuQmokLC7
         pjPcKcvXfZgGCubr2yWiGIveKGITN4CJI7vj50JELfypyJQannTHRtaaoJxcoWAmau
         5evEpKglcvt91d/AnMr6IbeMYG2+qDxvzX6mWyiY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 042/123] libbpf: silence GCC8 warning about string truncation
Date:   Tue, 13 Aug 2019 22:09:26 -0400
Message-Id: <20190814021047.14828-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit cb8ffde5694ae5fffb456eae932aac442aa3a207 ]

Despite a proper NULL-termination after strncpy(..., ..., IFNAMSIZ - 1),
GCC8 still complains about *expected* string truncation:

  xsk.c:330:2: error: 'strncpy' output may be truncated copying 15 bytes
  from a string of length 15 [-Werror=stringop-truncation]
    strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ - 1);

This patch gets rid of the issue altogether by using memcpy instead.
There is no performance regression, as strncpy will still copy and fill
all of the bytes anyway.

v1->v2:
- rebase against bpf tree.

Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/xsk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 8e03b65830da0..fa948c5445ecf 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -336,7 +336,7 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
 		return -errno;
 
 	ifr.ifr_data = (void *)&channels;
-	strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ - 1);
+	memcpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ - 1);
 	ifr.ifr_name[IFNAMSIZ - 1] = '\0';
 	err = ioctl(fd, SIOCETHTOOL, &ifr);
 	if (err && errno != EOPNOTSUPP) {
@@ -561,7 +561,7 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 		err = -errno;
 		goto out_socket;
 	}
-	strncpy(xsk->ifname, ifname, IFNAMSIZ - 1);
+	memcpy(xsk->ifname, ifname, IFNAMSIZ - 1);
 	xsk->ifname[IFNAMSIZ - 1] = '\0';
 
 	err = xsk_set_xdp_socket_config(&xsk->config, usr_config);
-- 
2.20.1

