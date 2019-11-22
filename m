Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 417221061C7
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 06:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbfKVF7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 00:59:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:36520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729552AbfKVF5z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:57:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EA752072D;
        Fri, 22 Nov 2019 05:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402275;
        bh=QApcd85KJGu+VIAEdaq2EaYQKmtUl3gmpV+llI2BE+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nJ2Qr9+bAvxvAO0oFQ1F2MBQtPWRKzFBw249D79C5urEOrsbz8Nggn3BD3houF87A
         q8qyII7awP7Fitk4IRLKdUUoIWzn+trRc2HUtFizOXoPqg3lOv6BcDQIr7Oy6k6lab
         KK+skPq6aamV+Yqud3BPuCVtL7wUXKwPyi+5nyCo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peng Sun <sironhide0null@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 114/127] bpf: decrease usercnt if bpf_map_new_fd() fails in bpf_map_get_fd_by_id()
Date:   Fri, 22 Nov 2019 00:55:32 -0500
Message-Id: <20191122055544.3299-113-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Sun <sironhide0null@gmail.com>

[ Upstream commit 781e62823cb81b972dc8652c1827205cda2ac9ac ]

In bpf/syscall.c, bpf_map_get_fd_by_id() use bpf_map_inc_not_zero()
to increase the refcount, both map->refcnt and map->usercnt. Then, if
bpf_map_new_fd() fails, should handle map->usercnt too.

Fixes: bd5f5f4ecb78 ("bpf: Add BPF_MAP_GET_FD_BY_ID")
Signed-off-by: Peng Sun <sironhide0null@gmail.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 59d2e94ecb798..34110450a78f2 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1354,7 +1354,7 @@ static int bpf_map_get_fd_by_id(const union bpf_attr *attr)
 
 	fd = bpf_map_new_fd(map);
 	if (fd < 0)
-		bpf_map_put(map);
+		bpf_map_put_with_uref(map);
 
 	return fd;
 }
-- 
2.20.1

