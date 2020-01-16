Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21EBE13E201
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 17:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730518AbgAPQwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:52:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:36192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730461AbgAPQwv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:52:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 053702081E;
        Thu, 16 Jan 2020 16:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193570;
        bh=18TLQobk9WamORS6tuASBwCzT2OWcQr0TMc4s4k2JGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvTYi7ctg6VrDJKuVJmP/GdHCunO57X0/7pEtlHAonfYK8KENfSugscQO8hqZbxAk
         x3XZ3/ztrHvlRZnq/uMfr8VXlxhYz+Na/P9YUTapZZ0Q9dERhRz0s6kJZEv2BIj/og
         FDRTpdzGo5lgAlicWU3sMqejVxAsJxIsgLAUUNcU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 114/205] libbpf: Make btf__resolve_size logic always check size error condition
Date:   Thu, 16 Jan 2020 11:41:29 -0500
Message-Id: <20200116164300.6705-114-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit 994021a7e08477f7e51285920aac99fc967fae8a ]

Perform size check always in btf__resolve_size. Makes the logic a bit more
robust against corrupted BTF and silences LGTM/Coverity complaining about
always true (size < 0) check.

Fixes: 69eaab04c675 ("btf: extract BTF type size calculation")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20191107020855.3834758-5-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 1aa189a9112a..d606a358480d 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -269,10 +269,9 @@ __s64 btf__resolve_size(const struct btf *btf, __u32 type_id)
 		t = btf__type_by_id(btf, type_id);
 	}
 
+done:
 	if (size < 0)
 		return -EINVAL;
-
-done:
 	if (nelems && size > UINT32_MAX / nelems)
 		return -E2BIG;
 
-- 
2.20.1

