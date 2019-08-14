Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C48128C979
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbfHNCLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:11:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727410AbfHNCLZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:11:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B5F32084D;
        Wed, 14 Aug 2019 02:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748684;
        bh=Qxzn1GhQkt3VpBDtZ5IfDFsMDOoiGdj2MAiQd54afUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jSXTl9IseVqvzEksIssa5/qzWzmHbWYxMJGINlCEPhhnwznfTzQFVM/zf2l2YJoQ7
         qe+c5/G0XxLxMc+sClvo9znV0kmQXkMAkQlbWPd3Az1wKEdqWV0MjdLSZcHwxrdWIM
         El1ilb0Xb1WDgtQTerLfyZVTYv2r8UvTIc1c+dtU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 020/123] libbpf: sanitize VAR to conservative 1-byte INT
Date:   Tue, 13 Aug 2019 22:09:04 -0400
Message-Id: <20190814021047.14828-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit 1d4126c4e1190d2f7d3f388552f9bd17ae0c64fc ]

If VAR in non-sanitized BTF was size less than 4, converting such VAR
into an INT with size=4 will cause BTF validation failure due to
violationg of STRUCT (into which DATASEC was converted) member size.
Fix by conservatively using size=1.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 3865a5d272514..77e14d9954796 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1044,8 +1044,13 @@ static void bpf_object__sanitize_btf(struct bpf_object *obj)
 		if (!has_datasec && kind == BTF_KIND_VAR) {
 			/* replace VAR with INT */
 			t->info = BTF_INFO_ENC(BTF_KIND_INT, 0, 0);
-			t->size = sizeof(int);
-			*(int *)(t+1) = BTF_INT_ENC(0, 0, 32);
+			/*
+			 * using size = 1 is the safest choice, 4 will be too
+			 * big and cause kernel BTF validation failure if
+			 * original variable took less than 4 bytes
+			 */
+			t->size = 1;
+			*(int *)(t+1) = BTF_INT_ENC(0, 0, 8);
 		} else if (!has_datasec && kind == BTF_KIND_DATASEC) {
 			/* replace DATASEC with STRUCT */
 			struct btf_var_secinfo *v = (void *)(t + 1);
-- 
2.20.1

