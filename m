Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49F9C12BA6E
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 19:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727592AbfL0SO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 13:14:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:39434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727503AbfL0SOz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 13:14:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CC1A20CC7;
        Fri, 27 Dec 2019 18:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577470495;
        bh=4qsaJPCsqdeGWjUH3Q5NHhiloyBEEgLcVzLHgGTZ9jQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRI/wfxZeSNv9eL3qnFDDVIvAzjpOBv0W2qGaqXeqBGc5ArhV7JL2g4V1dAZ5tb4d
         hpAtNXItrX3gIEcD9WJJ3bsA7dplOy/KLMo7REq187va7bF9wI3nAUT8ULFwQ+aplQ
         X/GLeulqi76wY5W9ccONvGNotZp/jDXCGvFdwhb8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 15/38] samples: bpf: Replace symbol compare of trace_event
Date:   Fri, 27 Dec 2019 13:14:12 -0500
Message-Id: <20191227181435.7644-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227181435.7644-1-sashal@kernel.org>
References: <20191227181435.7644-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Daniel T. Lee" <danieltimlee@gmail.com>

[ Upstream commit bba1b2a890253528c45aa66cf856f289a215bfbc ]

Previously, when this sample is added, commit 1c47910ef8013
("samples/bpf: add perf_event+bpf example"), a symbol 'sys_read' and
'sys_write' has been used without no prefixes. But currently there are
no exact symbols with these under kallsyms and this leads to failure.

This commit changes exact compare to substring compare to keep compatible
with exact symbol or prefixed symbol.

Fixes: 1c47910ef8013 ("samples/bpf: add perf_event+bpf example")
Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20191205080114.19766-2-danieltimlee@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/trace_event_user.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/trace_event_user.c b/samples/bpf/trace_event_user.c
index 9a130d31ecf2..6fbb5eb9daf3 100644
--- a/samples/bpf/trace_event_user.c
+++ b/samples/bpf/trace_event_user.c
@@ -33,9 +33,9 @@ static void print_ksym(__u64 addr)
 		return;
 	sym = ksym_search(addr);
 	printf("%s;", sym->name);
-	if (!strcmp(sym->name, "sys_read"))
+	if (!strstr(sym->name, "sys_read"))
 		sys_read_seen = true;
-	else if (!strcmp(sym->name, "sys_write"))
+	else if (!strstr(sym->name, "sys_write"))
 		sys_write_seen = true;
 }
 
-- 
2.20.1

