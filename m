Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0093D1F2ECD
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732257AbgFIApA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:45:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729008AbgFHXLy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:11:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79EE820C56;
        Mon,  8 Jun 2020 23:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657914;
        bh=NxAJsTGELpCsWIQyrpwGz1O0iqdSozOGgaX3qe3alLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jy1vcd0Eo6Lc4swo5/oWRIvdhu98ZjZbANPilov7WG8NEyRhL4u1YtWTe8BsnhkvQ
         1fgNx9jdTNfJwLygc0CgQCL2nyhCSL56PhNqynmsAiO8mIvdWyuRZDOzq0haWociCx
         a3eBn/I6zOzV6hhm5u+sqksuM2PE92VK3pMo/Lfw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eelco Chaudron <echaudro@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 265/274] libbpf: Fix perf_buffer__free() API for sparse allocs
Date:   Mon,  8 Jun 2020 19:05:58 -0400
Message-Id: <20200608230607.3361041-265-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eelco Chaudron <echaudro@redhat.com>

[ Upstream commit 601b05ca6edb0422bf6ce313fbfd55ec7bbbc0fd ]

In case the cpu_bufs are sparsely allocated they are not all
free'ed. These changes will fix this.

Fixes: fb84b8224655 ("libbpf: add perf buffer API")
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/159056888305.330763.9684536967379110349.stgit@ebuild
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index cd53204d33f0..0c5b4fb553fb 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7809,9 +7809,12 @@ void perf_buffer__free(struct perf_buffer *pb)
 	if (!pb)
 		return;
 	if (pb->cpu_bufs) {
-		for (i = 0; i < pb->cpu_cnt && pb->cpu_bufs[i]; i++) {
+		for (i = 0; i < pb->cpu_cnt; i++) {
 			struct perf_cpu_buf *cpu_buf = pb->cpu_bufs[i];
 
+			if (!cpu_buf)
+				continue;
+
 			bpf_map_delete_elem(pb->map_fd, &cpu_buf->map_key);
 			perf_buffer__free_cpu_buf(pb, cpu_buf);
 		}
-- 
2.25.1

