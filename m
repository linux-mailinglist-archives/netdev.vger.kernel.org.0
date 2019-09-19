Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 950A0B8419
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 00:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393302AbfISWH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 18:07:56 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36272 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393296AbfISWHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 18:07:54 -0400
Received: by mail-pf1-f195.google.com with SMTP id y22so3183349pfr.3
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 15:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Le/BrydvMJpJj4rLQT2vERLtOe+gfIi9MPMZDbM+ABI=;
        b=EYV9Dh2ZKbWcVnahsqxfPEuJsZk+hnlYulJ9gvDyBWwokHv1LJ3ufnhDNLRT8+qjqK
         9wEkgoAdvfd3b/zi3p9M9Me6Wdcu71odUy70fF7q3bccjatltIOaqcfciD9Jd5IijQaU
         vc17baMcTtYxuSmpXDC/e8nNGrMuMzaHMdFWyDH4C8pUCTfeW/xDbPdc3I9rwtgZMeMq
         xTD/rAypIEa12yk5nW98BpmvSip9gy0SSY0zfjUsKzImcrhhCZCQN9tWVzRU3qCkJ0oa
         EZz6Hm6KLov7JGtfC4w7poAiuSxVnhRbaw1FusCez0wWuO/JNRAtgRxkn6WRQIwoxCJ3
         15ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=Le/BrydvMJpJj4rLQT2vERLtOe+gfIi9MPMZDbM+ABI=;
        b=Ygx45bXqjpjGwTcE0CXawjm8x8f3OuU0x91T9ZK9AfNrGIX5+i/7wynaC4Y/XQ7ne1
         Dc1uxiodam5dAoONYVdMr+QwrQozjGgC7CqHOKI43NbcQM3RxmC3lJnZcouEc7jC+dpj
         ia7fCuzq5B5yEgitOwV9ikHAHfKVRqnA3xPjUmLUi8oZdYg6Xg09OasK0yp/6iGtKLDT
         kGxugUJ+7Ye0MXhyz/LlQ8WAJjue3xUMa4r1oSKixy840xco98YVXqz83g7paEgGivba
         8HRVD8HDhOGkViejB1MkBHAlivhReQyPq10rEPvuljgJ5LtY1NcvWgZJnVYPtQLa05Jo
         2v9g==
X-Gm-Message-State: APjAAAXMiZ8TEnSZJvOlKhPHPXyHkvl/mZ8SI+RKm1HfYhbgFkstD1DT
        H8Xp/ubed+YAxdn1fDQ/PlFz2rmh
X-Google-Smtp-Source: APXvYqzqq9QKc0xNZiVz4SgO+m6rxO0NMSl9HD/U18PYHshQoZe/BoU3+IeEiL4yPwdKFTgTyyoxbw==
X-Received: by 2002:a63:c0d:: with SMTP id b13mr11233370pgl.420.1568930872579;
        Thu, 19 Sep 2019 15:07:52 -0700 (PDT)
Received: from allosaurus.monzoon.net ([99.0.85.34])
        by smtp.gmail.com with ESMTPSA id x68sm10834337pfd.183.2019.09.19.15.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 15:07:51 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCH iproute2 master] bpf: Fix race condition with map pinning
Date:   Thu, 19 Sep 2019 15:07:33 -0700
Message-Id: <20190919220733.31206-1-joe@wand.net.nz>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If two processes attempt to invoke bpf_map_attach() at the same time,
then they will both create maps, then the first will successfully pin
the map to the filesystem and the second will not pin the map, but will
continue operating with a reference to its own copy of the map. As a
result, the sharing of the same map will be broken from the two programs
that were concurrently loaded via loaders using this library.

Fix this by adding a retry in the case where the pinning fails because
the map already exists on the filesystem. In that case, re-attempt
opening a fd to the map on the filesystem as it shows that another
program already created and pinned a map at that location.

Signed-off-by: Joe Stringer <joe@wand.net.nz>
---
 lib/bpf.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/lib/bpf.c b/lib/bpf.c
index f64b58c3bb19..23eb8952cc28 100644
--- a/lib/bpf.c
+++ b/lib/bpf.c
@@ -1625,7 +1625,9 @@ static int bpf_map_attach(const char *name, struct bpf_elf_ctx *ctx,
 			  int *have_map_in_map)
 {
 	int fd, ifindex, ret, map_inner_fd = 0;
+	bool retried = false;
 
+probe:
 	fd = bpf_probe_pinned(name, ctx, map->pinning);
 	if (fd > 0) {
 		ret = bpf_map_selfcheck_pinned(fd, map, ext,
@@ -1674,7 +1676,11 @@ static int bpf_map_attach(const char *name, struct bpf_elf_ctx *ctx,
 	}
 
 	ret = bpf_place_pinned(fd, name, ctx, map->pinning);
-	if (ret < 0 && errno != EEXIST) {
+	if (ret < 0) {
+		if (!retried && errno == EEXIST) {
+			retried = true;
+			goto probe;
+		}
 		fprintf(stderr, "Could not pin %s map: %s\n", name,
 			strerror(errno));
 		close(fd);
-- 
2.20.1

