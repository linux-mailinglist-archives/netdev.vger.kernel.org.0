Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9062410BE
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 21:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbgHJTcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 15:32:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728688AbgHJTJy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 15:09:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C5212224D;
        Mon, 10 Aug 2020 19:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086594;
        bh=k296qi7HxlZgUoe/DmXhlF3VYg7LH0YX2UM5pcMqG7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u//yaQ+NFLErxMbEvqSPHO5g8y/x57VZ0xuhBxUZXHy/1fz6sr1hz9F1GLV6ZnOGL
         j3S07WREztvSzkKCYUlgKxyHAk4zxnn2usDiV3FAIFuSJoYrVU3Q1LLRQmsSjmUUvt
         drGXW7dkjiz3olOGNbyEgSXWJ595bEUUT6PIv77w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenbo Zhang <ethercflow@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 40/64] bpf: Fix fds_example SIGSEGV error
Date:   Mon, 10 Aug 2020 15:08:35 -0400
Message-Id: <20200810190859.3793319-40-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810190859.3793319-1-sashal@kernel.org>
References: <20200810190859.3793319-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenbo Zhang <ethercflow@gmail.com>

[ Upstream commit eef8a42d6ce087d1c81c960ae0d14f955b742feb ]

The `BPF_LOG_BUF_SIZE`'s value is `UINT32_MAX >> 8`, so define an array
with it on stack caused an overflow.

Signed-off-by: Wenbo Zhang <ethercflow@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/20200710092035.28919-1-ethercflow@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/fds_example.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/samples/bpf/fds_example.c b/samples/bpf/fds_example.c
index d5992f7872328..59f45fef51109 100644
--- a/samples/bpf/fds_example.c
+++ b/samples/bpf/fds_example.c
@@ -30,6 +30,8 @@
 #define BPF_M_MAP	1
 #define BPF_M_PROG	2
 
+char bpf_log_buf[BPF_LOG_BUF_SIZE];
+
 static void usage(void)
 {
 	printf("Usage: fds_example [...]\n");
@@ -57,7 +59,6 @@ static int bpf_prog_create(const char *object)
 		BPF_EXIT_INSN(),
 	};
 	size_t insns_cnt = sizeof(insns) / sizeof(struct bpf_insn);
-	char bpf_log_buf[BPF_LOG_BUF_SIZE];
 	struct bpf_object *obj;
 	int prog_fd;
 
-- 
2.25.1

