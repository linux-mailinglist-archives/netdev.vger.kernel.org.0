Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E573B890E
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 04:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394665AbfITCE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 22:04:56 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:36443 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390810AbfITCEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 22:04:55 -0400
Received: by mail-pl1-f173.google.com with SMTP id f19so2464658plr.3
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 19:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cLaiHASkCHFqmZBm9Gq5W/tMKYRNEIwnEvPja5U1W9c=;
        b=iSlPOoP6B8/pSvdlIg3ikoiRLg3qwG1TTIgypiXriLfXRAT8aObGTrC0uBPCxkOzoD
         0vZwLGJwCg8AHS3BeLqsTO1G2HgX6slapCWY0ePoFghJoZ4WO7WvfqXuUbtggMnNhGYv
         6MDXrryxfTop1zQtDfrs1gvkZ7q6WbnPHNBavgs6K7EwmC1e6Zv3i0KzNP/tmBw6aDr+
         9TImYnKO+r6fnBC2s+0M1DO68GWCFzuzPHZyqrv2lDj3fD8VTeAtTpSl7RQP03oZZnAq
         TXBozZ+cLMiWRYjHqQGQyVpqkhw5kPqxDq0/1CYzh8Y5roc9SD3WH4O1azlhOnB5wYbR
         ZehQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=cLaiHASkCHFqmZBm9Gq5W/tMKYRNEIwnEvPja5U1W9c=;
        b=m1pz6OnMjUk6ODu3B8CHxGCDi099xgb62u0KFHhtGyzZAoHYPxhd20RBoEEIGWYsY0
         8R1An26tyNQIy+FL6wGAAlLtzS5Xb6PD4aF6poe/ESgdjEVkJrb4tX7q2eHxd1OYXMT8
         bB7lw7VqA6sswcPtHRhxUCi7rTRfJ21AH9lMtPGNwqkSuJLYekBgC62fzDfU1lN/BTYO
         +sMlreZM3hadq+S6kqyJicJHmB/m7DHF0ZgUg1dc59qdB7gO3t7PgBJIqfcqe7L4T1X1
         82on7ptjfINte5nuuXuQ63Gqp5eEZ71NtrJTvNeOBeEUa8BU1KSVfHjWhFEi8OoUBDYT
         No+A==
X-Gm-Message-State: APjAAAUjLIQwYUxAjmbAPDQEsw9PQEcsvwk+puM+0iTR8/5x/SN/sIKG
        QH7Q7yJYKmn4fIfdIAoEomcwrsx7
X-Google-Smtp-Source: APXvYqzT55nmRpPQg2z1t1kYEmpbVngkI8o0UjQQjs/cP5vUBU5WhjqW9W66Kiso/p7VU5KEudbJ1w==
X-Received: by 2002:a17:902:76c2:: with SMTP id j2mr13805197plt.304.1568945093697;
        Thu, 19 Sep 2019 19:04:53 -0700 (PDT)
Received: from allosaurus.monzoon.net (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id c14sm319821pfm.179.2019.09.19.19.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 19:04:52 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCHv2 iproute2 master] bpf: Fix race condition with map pinning
Date:   Thu, 19 Sep 2019 19:04:47 -0700
Message-Id: <20190920020447.29119-1-joe@wand.net.nz>
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
v2: Fix close of created map in the EEXIST case.
v1: Original patch
---
 lib/bpf.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/lib/bpf.c b/lib/bpf.c
index 01152b26e54a..86ab0698660f 100644
--- a/lib/bpf.c
+++ b/lib/bpf.c
@@ -1707,7 +1707,9 @@ static int bpf_map_attach(const char *name, struct bpf_elf_ctx *ctx,
 			  int *have_map_in_map)
 {
 	int fd, ifindex, ret, map_inner_fd = 0;
+	bool retried = false;
 
+probe:
 	fd = bpf_probe_pinned(name, ctx, map->pinning);
 	if (fd > 0) {
 		ret = bpf_map_selfcheck_pinned(fd, map, ext,
@@ -1756,10 +1758,14 @@ static int bpf_map_attach(const char *name, struct bpf_elf_ctx *ctx,
 	}
 
 	ret = bpf_place_pinned(fd, name, ctx, map->pinning);
-	if (ret < 0 && errno != EEXIST) {
+	if (ret < 0) {
+		close(fd);
+		if (!retried && errno == EEXIST) {
+			retried = true;
+			goto probe;
+		}
 		fprintf(stderr, "Could not pin %s map: %s\n", name,
 			strerror(errno));
-		close(fd);
 		return ret;
 	}
 
-- 
2.20.1

