Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4CE8106134
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 06:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbfKVFw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 00:52:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:58868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727521AbfKVFw4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:52:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D42A2071B;
        Fri, 22 Nov 2019 05:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401975;
        bh=aEig3xLJ0ayeEDQUT+Zv0DbOuIHBjOVxj1yI+WpZ7DI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vmsAQMm2y+oZPVsr+Yy5XevbpNZaK7/X7VWtBPD0gb7KzeiU7m3dbAnSvsntG4Trn
         LdTlyIEjMI31FhrD7hq1ti6O5OUFN4JuHACFXlUirFlz80Lmo6vlHIZGfn0joI8mFD
         5YSLwM4VngliGfiH4zerBqhQmhDoAwuR1lZw3oEM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peng Sun <sironhide0null@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 195/219] bpf: decrease usercnt if bpf_map_new_fd() fails in bpf_map_get_fd_by_id()
Date:   Fri, 22 Nov 2019 00:48:47 -0500
Message-Id: <20191122054911.1750-188-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
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
index 6e544e364821e..90bb0c05c10e9 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1887,7 +1887,7 @@ static int bpf_map_get_fd_by_id(const union bpf_attr *attr)
 
 	fd = bpf_map_new_fd(map, f_flags);
 	if (fd < 0)
-		bpf_map_put(map);
+		bpf_map_put_with_uref(map);
 
 	return fd;
 }
-- 
2.20.1

