Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 186CB68DBC
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733275AbfGOOBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:01:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731326AbfGOOBN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:01:13 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 125A52083D;
        Mon, 15 Jul 2019 14:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199272;
        bh=Yf2R0tM/bEIm2s6ta7L7vGbzeVyOgOPjlCcPctN/KQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fwv++oL5V0EuBr5agcmvMIwP64BBBKR9Q/ptnmuLzQJrZHJwJcn8vhNobB6FluTR2
         zp/oD1l5l87sVoLtqjTWiSWDHyRFFIgHmYSI0aunMM/nprM10tNkw4R/368m0PQc5h
         IqXczvIfMONgopWUwsMLv5Hd+KCEhaj1izF5AM9Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 224/249] libbpf: fix GCC8 warning for strncpy
Date:   Mon, 15 Jul 2019 09:46:29 -0400
Message-Id: <20190715134655.4076-224-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit cdfc7f888c2a355b01308e97c6df108f1c2b64e8 ]

GCC8 started emitting warning about using strncpy with number of bytes
exactly equal destination size, which is generally unsafe, as can lead
to non-zero terminated string being copied. Use IFNAMSIZ - 1 as number
of bytes to ensure name is always zero-terminated.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Yonghong Song <yhs@fb.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/xsk.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 38667b62f1fe..8a7a05bc657d 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -337,7 +337,8 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
 
 	channels.cmd = ETHTOOL_GCHANNELS;
 	ifr.ifr_data = (void *)&channels;
-	strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ);
+	strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ - 1);
+	ifr.ifr_name[IFNAMSIZ - 1] = '\0';
 	err = ioctl(fd, SIOCETHTOOL, &ifr);
 	if (err && errno != EOPNOTSUPP) {
 		ret = -errno;
-- 
2.20.1

