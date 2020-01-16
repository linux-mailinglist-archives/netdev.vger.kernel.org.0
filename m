Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECBD113F3D3
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391808AbgAPSpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:45:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:49164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729290AbgAPRKh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:10:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45CD42468B;
        Thu, 16 Jan 2020 17:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194637;
        bh=UjDRz+2jQ+4DGwwvu1ypOz4jh6xd6EedOG9bfUkItyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yECtWdrdobRuWl9m/oCXb3Y8K7z7SQK5FKGcOHjXHOBy35uQ2e8vS6DICpiFp9MZH
         FSSiGD64YnbtsxIirrHSddkJI5yREx8g7Y/rBROmt76qh6JHPsGqbs6EiMwPItJokd
         WoCCvtEihKsdmI4ixgEJxTH3lXfKuSRm3EPYqZRs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quentin Monnet <quentin.monnet@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 495/671] tools: bpftool: fix format strings and arguments for jsonw_printf()
Date:   Thu, 16 Jan 2020 12:02:13 -0500
Message-Id: <20200116170509.12787-232-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Quentin Monnet <quentin.monnet@netronome.com>

[ Upstream commit 22c349e8db89df86804d3ba23cef037ccd44a8bf ]

There are some mismatches between format strings and arguments passed to
jsonw_printf() in the BTF dumper for bpftool, which seems harmless but
may result in warnings if the "__printf()" attribute is used correctly
for jsonw_printf(). Let's fix relevant format strings and type cast.

Fixes: b12d6ec09730 ("bpf: btf: add btf print functionality")
Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/btf_dumper.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
index e4e6e2b3fd84..ff0cc3c17141 100644
--- a/tools/bpf/bpftool/btf_dumper.c
+++ b/tools/bpf/bpftool/btf_dumper.c
@@ -26,9 +26,9 @@ static void btf_dumper_ptr(const void *data, json_writer_t *jw,
 			   bool is_plain_text)
 {
 	if (is_plain_text)
-		jsonw_printf(jw, "%p", *(unsigned long *)data);
+		jsonw_printf(jw, "%p", data);
 	else
-		jsonw_printf(jw, "%u", *(unsigned long *)data);
+		jsonw_printf(jw, "%lu", *(unsigned long *)data);
 }
 
 static int btf_dumper_modifier(const struct btf_dumper *d, __u32 type_id,
@@ -129,7 +129,7 @@ static int btf_dumper_int(const struct btf_type *t, __u8 bit_offset,
 	switch (BTF_INT_ENCODING(*int_type)) {
 	case 0:
 		if (BTF_INT_BITS(*int_type) == 64)
-			jsonw_printf(jw, "%lu", *(__u64 *)data);
+			jsonw_printf(jw, "%llu", *(__u64 *)data);
 		else if (BTF_INT_BITS(*int_type) == 32)
 			jsonw_printf(jw, "%u", *(__u32 *)data);
 		else if (BTF_INT_BITS(*int_type) == 16)
@@ -142,7 +142,7 @@ static int btf_dumper_int(const struct btf_type *t, __u8 bit_offset,
 		break;
 	case BTF_INT_SIGNED:
 		if (BTF_INT_BITS(*int_type) == 64)
-			jsonw_printf(jw, "%ld", *(long long *)data);
+			jsonw_printf(jw, "%lld", *(long long *)data);
 		else if (BTF_INT_BITS(*int_type) == 32)
 			jsonw_printf(jw, "%d", *(int *)data);
 		else if (BTF_INT_BITS(*int_type) == 16)
-- 
2.20.1

