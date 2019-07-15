Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62E28694EC
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391473AbfGOO1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:27:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391461AbfGOO1S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:27:18 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21861206B8;
        Mon, 15 Jul 2019 14:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200837;
        bh=Q2BeB/C8Xxr1+85qMCTF4SPOO4d/0Oqtv+BeqEcasWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a++xgf03EVv0XOHSaFA8j8BICeWvi4JuQOk2mEjT/z98f5WF61Q7S+vcK/BG3EEBU
         ZZphjPkVR37Qw22Q3sVy0k+7L7a/oKexkLEWNdBYx1BDVDxg4yJz1oGRUEkIjNTDpU
         cdUcwM2wrjk7Llerv/pVMuAYgAoBHesKUc507+NI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leo Yan <leo.yan@linaro.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 141/158] bpf, libbpf, smatch: Fix potential NULL pointer dereference
Date:   Mon, 15 Jul 2019 10:17:52 -0400
Message-Id: <20190715141809.8445-141-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715141809.8445-1-sashal@kernel.org>
References: <20190715141809.8445-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leo Yan <leo.yan@linaro.org>

[ Upstream commit 33bae185f74d49a0d7b1bfaafb8e959efce0f243 ]

Based on the following report from Smatch, fix the potential NULL
pointer dereference check:

  tools/lib/bpf/libbpf.c:3493
  bpf_prog_load_xattr() warn: variable dereferenced before check 'attr'
  (see line 3483)

  3479 int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
  3480                         struct bpf_object **pobj, int *prog_fd)
  3481 {
  3482         struct bpf_object_open_attr open_attr = {
  3483                 .file           = attr->file,
  3484                 .prog_type      = attr->prog_type,
                                         ^^^^^^
  3485         };

At the head of function, it directly access 'attr' without checking
if it's NULL pointer. This patch moves the values assignment after
validating 'attr' and 'attr->file'.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index bdb94939fd60..a350f97e3a1a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2293,10 +2293,7 @@ int bpf_prog_load(const char *file, enum bpf_prog_type type,
 int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 			struct bpf_object **pobj, int *prog_fd)
 {
-	struct bpf_object_open_attr open_attr = {
-		.file		= attr->file,
-		.prog_type	= attr->prog_type,
-	};
+	struct bpf_object_open_attr open_attr = {};
 	struct bpf_program *prog, *first_prog = NULL;
 	enum bpf_attach_type expected_attach_type;
 	enum bpf_prog_type prog_type;
@@ -2309,6 +2306,9 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 	if (!attr->file)
 		return -EINVAL;
 
+	open_attr.file = attr->file;
+	open_attr.prog_type = attr->prog_type;
+
 	obj = bpf_object__open_xattr(&open_attr);
 	if (IS_ERR_OR_NULL(obj))
 		return -ENOENT;
-- 
2.20.1

