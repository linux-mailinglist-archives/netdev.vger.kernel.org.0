Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E151F2B58
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730436AbgFIAOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:14:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728767AbgFHXTI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:19:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D326920823;
        Mon,  8 Jun 2020 23:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658348;
        bh=JhpQfRsModk5sQ9aL2T3NULoav7X7hkWKs2gzjta+OE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rpFbyzgNNmH4LspWHtunhToYT4EegV9c64u/IgjnBBcozllYp17ZHKoUEPd0BeDC8
         Cg1toVKMQFAvDL1NZ1UAgtmjtbcyPdrdlHMiv19JOnJuzrnFciIrd08G27Ql5SOVim
         x6N5BQy/9daRoLFkT2OzMc+qyj88eozW8iovi4Lg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>, Alston Tang <alston64@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 016/175] libbpf: Fix memory leak and possible double-free in hashmap__clear
Date:   Mon,  8 Jun 2020 19:16:09 -0400
Message-Id: <20200608231848.3366970-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit 229bf8bf4d910510bc1a2fd0b89bd467cd71050d ]

Fix memory leak in hashmap_clear() not freeing hashmap_entry structs for each
of the remaining entries. Also NULL-out bucket list to prevent possible
double-free between hashmap__clear() and hashmap__free().

Running test_progs-asan flavor clearly showed this problem.

Reported-by: Alston Tang <alston64@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200429012111.277390-5-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/hashmap.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/lib/bpf/hashmap.c b/tools/lib/bpf/hashmap.c
index 6122272943e6..9ef9f6201d8b 100644
--- a/tools/lib/bpf/hashmap.c
+++ b/tools/lib/bpf/hashmap.c
@@ -56,7 +56,14 @@ struct hashmap *hashmap__new(hashmap_hash_fn hash_fn,
 
 void hashmap__clear(struct hashmap *map)
 {
+	struct hashmap_entry *cur, *tmp;
+	int bkt;
+
+	hashmap__for_each_entry_safe(map, cur, tmp, bkt) {
+		free(cur);
+	}
 	free(map->buckets);
+	map->buckets = NULL;
 	map->cap = map->cap_bits = map->sz = 0;
 }
 
-- 
2.25.1

