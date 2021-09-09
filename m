Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A539B404AD6
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 13:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237455AbhIILtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 07:49:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240920AbhIILqa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 07:46:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96E8D61221;
        Thu,  9 Sep 2021 11:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187776;
        bh=A33ZE4HeJ81mvg4rDozVtPu2IpO5dLLYONnXglNKX0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QJ6tfh84d4QyUNjRQwM+DUsVJt0gvY1BNYOzwwl9iWuef79EjMB1z1hwnM7vneig/
         5gJb73yZNPpTjUF1bb7rYK35U9rmvppmvLu4wfyfn/ycLMif2LtPiEVjfXQhf6jhou
         PmdF5ToKvxoZQgN81FYTDp00ot6f8WWRJL+Va74BA9sAsxIoK283RAHl9PXc2Z3gc2
         oPJqpb1EXYvEHHos3U/pnP+3Q9vGNP+Odny9VsFVZ9y+zfzBohQ9IKNA/9qSPiS9Sn
         +BhZbL27EkFJXoJOx63IhinuT6xLD2sSJ4gkdoIkrTileee4+l28YZnynRTiyWE5bc
         iQVfZ8tlHMqLw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martynas Pumputis <m@lambda.lt>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 086/252] libbpf: Fix race when pinning maps in parallel
Date:   Thu,  9 Sep 2021 07:38:20 -0400
Message-Id: <20210909114106.141462-86-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martynas Pumputis <m@lambda.lt>

[ Upstream commit 043c5bb3c4f43670ab4fea0b847373ab42d25f3e ]

When loading in parallel multiple programs which use the same to-be
pinned map, it is possible that two instances of the loader will call
bpf_object__create_maps() at the same time. If the map doesn't exist
when both instances call bpf_object__reuse_map(), then one of the
instances will fail with EEXIST when calling bpf_map__pin().

Fix the race by retrying reusing a map if bpf_map__pin() returns
EEXIST. The fix is similar to the one in iproute2: e4c4685fd6e4 ("bpf:
Fix race condition with map pinning").

Before retrying the pinning, we don't do any special cleaning of an
internal map state. The closer code inspection revealed that it's not
required:

    - bpf_object__create_map(): map->inner_map is destroyed after a
      successful call, map->fd is closed if pinning fails.
    - bpf_object__populate_internal_map(): created map elements is
      destroyed upon close(map->fd).
    - init_map_slots(): slots are freed after their initialization.

Signed-off-by: Martynas Pumputis <m@lambda.lt>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210726152001.34845-1-m@lambda.lt
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 4a30a788d7c8..0306cd6d280a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4658,10 +4658,13 @@ bpf_object__create_maps(struct bpf_object *obj)
 	char *cp, errmsg[STRERR_BUFSIZE];
 	unsigned int i, j;
 	int err;
+	bool retried;
 
 	for (i = 0; i < obj->nr_maps; i++) {
 		map = &obj->maps[i];
 
+		retried = false;
+retry:
 		if (map->pin_path) {
 			err = bpf_object__reuse_map(map);
 			if (err) {
@@ -4669,6 +4672,12 @@ bpf_object__create_maps(struct bpf_object *obj)
 					map->name);
 				goto err_out;
 			}
+			if (retried && map->fd < 0) {
+				pr_warn("map '%s': cannot find pinned map\n",
+					map->name);
+				err = -ENOENT;
+				goto err_out;
+			}
 		}
 
 		if (map->fd >= 0) {
@@ -4702,9 +4711,13 @@ bpf_object__create_maps(struct bpf_object *obj)
 		if (map->pin_path && !map->pinned) {
 			err = bpf_map__pin(map, NULL);
 			if (err) {
+				zclose(map->fd);
+				if (!retried && err == -EEXIST) {
+					retried = true;
+					goto retry;
+				}
 				pr_warn("map '%s': failed to auto-pin at '%s': %d\n",
 					map->name, map->pin_path, err);
-				zclose(map->fd);
 				goto err_out;
 			}
 		}
-- 
2.30.2

