Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0016413F951
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730493AbgAPQwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:52:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729387AbgAPQwu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:52:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFF48208C3;
        Thu, 16 Jan 2020 16:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193569;
        bh=HDJI+cWZbtRLZamgfp2m4CUDmGjhDhsihypHESYsrfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wzuu5CWEgBxMecjveow9Ruy+FceQig/qMovGFJYPOzPlBHwoW9cnu64eyyqExR7yG
         tZkY3hvGuyY93/fRTNVp+lw/LVA5BSHl322ZoCIUdP77bMSzwAwI8+zXTxhubtiOUg
         wtWel7Gpdh9csTAFupPK90t74hlB3Miq8OVY74w4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 113/205] libbpf: Fix another potential overflow issue in bpf_prog_linfo
Date:   Thu, 16 Jan 2020 11:41:28 -0500
Message-Id: <20200116164300.6705-113-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit dd3ab126379ec040b3edab8559f9c72de6ef9d29 ]

Fix few issues found by Coverity and LGTM.

Fixes: b053b439b72a ("bpf: libbpf: bpftool: Print bpf_line_info during prog dump")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20191107020855.3834758-4-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/bpf_prog_linfo.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/bpf_prog_linfo.c b/tools/lib/bpf/bpf_prog_linfo.c
index 8c67561c93b0..3ed1a27b5f7c 100644
--- a/tools/lib/bpf/bpf_prog_linfo.c
+++ b/tools/lib/bpf/bpf_prog_linfo.c
@@ -101,6 +101,7 @@ struct bpf_prog_linfo *bpf_prog_linfo__new(const struct bpf_prog_info *info)
 {
 	struct bpf_prog_linfo *prog_linfo;
 	__u32 nr_linfo, nr_jited_func;
+	__u64 data_sz;
 
 	nr_linfo = info->nr_line_info;
 
@@ -122,11 +123,11 @@ struct bpf_prog_linfo *bpf_prog_linfo__new(const struct bpf_prog_info *info)
 	/* Copy xlated line_info */
 	prog_linfo->nr_linfo = nr_linfo;
 	prog_linfo->rec_size = info->line_info_rec_size;
-	prog_linfo->raw_linfo = malloc(nr_linfo * prog_linfo->rec_size);
+	data_sz = (__u64)nr_linfo * prog_linfo->rec_size;
+	prog_linfo->raw_linfo = malloc(data_sz);
 	if (!prog_linfo->raw_linfo)
 		goto err_free;
-	memcpy(prog_linfo->raw_linfo, (void *)(long)info->line_info,
-	       nr_linfo * prog_linfo->rec_size);
+	memcpy(prog_linfo->raw_linfo, (void *)(long)info->line_info, data_sz);
 
 	nr_jited_func = info->nr_jited_ksyms;
 	if (!nr_jited_func ||
@@ -142,13 +143,12 @@ struct bpf_prog_linfo *bpf_prog_linfo__new(const struct bpf_prog_info *info)
 	/* Copy jited_line_info */
 	prog_linfo->nr_jited_func = nr_jited_func;
 	prog_linfo->jited_rec_size = info->jited_line_info_rec_size;
-	prog_linfo->raw_jited_linfo = malloc(nr_linfo *
-					     prog_linfo->jited_rec_size);
+	data_sz = (__u64)nr_linfo * prog_linfo->jited_rec_size;
+	prog_linfo->raw_jited_linfo = malloc(data_sz);
 	if (!prog_linfo->raw_jited_linfo)
 		goto err_free;
 	memcpy(prog_linfo->raw_jited_linfo,
-	       (void *)(long)info->jited_line_info,
-	       nr_linfo * prog_linfo->jited_rec_size);
+	       (void *)(long)info->jited_line_info, data_sz);
 
 	/* Number of jited_line_info per jited func */
 	prog_linfo->nr_jited_linfo_per_func = malloc(nr_jited_func *
-- 
2.20.1

