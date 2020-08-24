Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95F425052C
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 19:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgHXRMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 13:12:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:41066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728022AbgHXQhx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 12:37:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66EE522CB1;
        Mon, 24 Aug 2020 16:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598287026;
        bh=3wKM+eofZ9MBJ6+Q56FyXiwsjGuqFNmK8dy1L010v3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xSFHHUwcaaYww2gTxGdok27s6qgj43vY5bCN3eY8e9mNljCJqef3g9OeOAv2t1dhM
         u+5zTyk326tT0nMhXYUYq1KIeN4EaoE5U8nJUtRuC7Y1JVQaIQfccrWHd5x45uhNgS
         hhfWV2D1KPBqx66wbgUpWR3htbIr7eorYkeJyoos=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 23/54] libbpf: Prevent overriding errno when logging errors
Date:   Mon, 24 Aug 2020 12:36:02 -0400
Message-Id: <20200824163634.606093-23-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163634.606093-1-sashal@kernel.org>
References: <20200824163634.606093-1-sashal@kernel.org>
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

[ Upstream commit 23ab656be263813acc3c20623757d3cd1496d9e1 ]

Turns out there were a few more instances where libbpf didn't save the
errno before writing an error message, causing errno to be overridden by
the printf() return and the error disappearing if logging is enabled.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/20200813142905.160381-1-toke@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index c417cff2cdaf4..3e53bfcba2b1a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3210,10 +3210,11 @@ bpf_object__probe_global_data(struct bpf_object *obj)
 
 	map = bpf_create_map_xattr(&map_attr);
 	if (map < 0) {
-		cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
+		ret = -errno;
+		cp = libbpf_strerror_r(ret, errmsg, sizeof(errmsg));
 		pr_warn("Error in %s():%s(%d). Couldn't create simple array map.\n",
-			__func__, cp, errno);
-		return -errno;
+			__func__, cp, -ret);
+		return ret;
 	}
 
 	insns[0].imm = map;
@@ -5508,9 +5509,10 @@ int bpf_program__pin_instance(struct bpf_program *prog, const char *path,
 	}
 
 	if (bpf_obj_pin(prog->instances.fds[instance], path)) {
-		cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
+		err = -errno;
+		cp = libbpf_strerror_r(err, errmsg, sizeof(errmsg));
 		pr_warn("failed to pin program: %s\n", cp);
-		return -errno;
+		return err;
 	}
 	pr_debug("pinned program '%s'\n", path);
 
-- 
2.25.1

