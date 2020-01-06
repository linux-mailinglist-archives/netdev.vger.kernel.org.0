Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1D281315B4
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 17:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgAFQHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 11:07:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726945AbgAFQHp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 11:07:45 -0500
Received: from quaco.ghostprotocols.net (unknown [179.97.35.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 995CE20848;
        Mon,  6 Jan 2020 16:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578326865;
        bh=+bP/ptlSmJSO82qQTP0/FgN73UUbcDYZmeD0+TwlNZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Il7nXo9CytiaNTDU2a5xvVwMIrv15W9ZsliwdD+7CLLQQka9PCWVnpIHmORggBdWV
         Wzo9/sz3jE9hc8PcCvjhapJGNo8gaihi+3eSEeRlIrmROAEH9p2R/RZ+rQ4OEsY8+3
         PzvjLU+aLmrGHpBAbo2PXh67whOokf3NwOq0Enfo=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Andrey Zhizhikin <andrey.z@gmail.com>,
        Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>,
        Petr Mladek <pmladek@suse.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/20] tools lib api fs: Fix gcc9 stringop-truncation compilation error
Date:   Mon,  6 Jan 2020 13:06:53 -0300
Message-Id: <20200106160705.10899-9-acme@kernel.org>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200106160705.10899-1-acme@kernel.org>
References: <20200106160705.10899-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrey Zhizhikin <andrey.z@gmail.com>

GCC9 introduced string hardening mechanisms, which exhibits the error
during fs api compilation:

error: '__builtin_strncpy' specified bound 4096 equals destination size
[-Werror=stringop-truncation]

This comes when the length of copy passed to strncpy is is equal to
destination size, which could potentially lead to buffer overflow.

There is a need to mitigate this potential issue by limiting the size of
destination by 1 and explicitly terminate the destination with NULL.

Signed-off-by: Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andriin@fb.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: bpf@vger.kernel.org
Cc: netdev@vger.kernel.org
Link: http://lore.kernel.org/lkml/20191211080109.18765-1-andrey.zhizhikin@leica-geosystems.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/api/fs/fs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/lib/api/fs/fs.c b/tools/lib/api/fs/fs.c
index 11b3885e833e..027b18f7ed8c 100644
--- a/tools/lib/api/fs/fs.c
+++ b/tools/lib/api/fs/fs.c
@@ -210,6 +210,7 @@ static bool fs__env_override(struct fs *fs)
 	size_t name_len = strlen(fs->name);
 	/* name + "_PATH" + '\0' */
 	char upper_name[name_len + 5 + 1];
+
 	memcpy(upper_name, fs->name, name_len);
 	mem_toupper(upper_name, name_len);
 	strcpy(&upper_name[name_len], "_PATH");
@@ -219,7 +220,8 @@ static bool fs__env_override(struct fs *fs)
 		return false;
 
 	fs->found = true;
-	strncpy(fs->path, override_path, sizeof(fs->path));
+	strncpy(fs->path, override_path, sizeof(fs->path) - 1);
+	fs->path[sizeof(fs->path) - 1] = '\0';
 	return true;
 }
 
-- 
2.21.1

