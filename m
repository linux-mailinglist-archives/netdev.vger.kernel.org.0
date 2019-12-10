Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 341D41198F0
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbfLJVlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:41:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:39322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729993AbfLJVeS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:34:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F487222C4;
        Tue, 10 Dec 2019 21:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013658;
        bh=8dqVDycVu9/yd5rdXpcZd6GnqUCGxWGKe+j9ZIZ9OrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rzi1SfKwSPAGQvTpB4KAasSTW9aP+lAZnn6P6NA1tTrjrx+iwDK5spfr0p7nZOMks
         O9UuKcEn3Cui6wpMNkp3SfRbeP/2qartEk1lXkb4W5YqISETeXCALO7bRvE193YiKW
         RH4Qar8Kd4Uo8wd2G6d/jqpffI2pkyyK3k4kcQjw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 096/177] libbpf: Fix error handling in bpf_map__reuse_fd()
Date:   Tue, 10 Dec 2019 16:31:00 -0500
Message-Id: <20191210213221.11921-96-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit d1b4574a4b86565325ef2e545eda8dfc9aa07c60 ]

bpf_map__reuse_fd() was calling close() in the error path before returning
an error value based on errno. However, close can change errno, so that can
lead to potentially misleading error messages. Instead, explicitly store
errno in the err variable before each goto.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/157269297769.394725.12634985106772698611.stgit@toke.dk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index a350f97e3a1a4..cd1890b51e021 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1071,16 +1071,22 @@ int bpf_map__reuse_fd(struct bpf_map *map, int fd)
 		return -errno;
 
 	new_fd = open("/", O_RDONLY | O_CLOEXEC);
-	if (new_fd < 0)
+	if (new_fd < 0) {
+		err = -errno;
 		goto err_free_new_name;
+	}
 
 	new_fd = dup3(fd, new_fd, O_CLOEXEC);
-	if (new_fd < 0)
+	if (new_fd < 0) {
+		err = -errno;
 		goto err_close_new_fd;
+	}
 
 	err = zclose(map->fd);
-	if (err)
+	if (err) {
+		err = -errno;
 		goto err_close_new_fd;
+	}
 	free(map->name);
 
 	map->fd = new_fd;
@@ -1099,7 +1105,7 @@ int bpf_map__reuse_fd(struct bpf_map *map, int fd)
 	close(new_fd);
 err_free_new_name:
 	free(new_name);
-	return -errno;
+	return err;
 }
 
 static int
-- 
2.20.1

