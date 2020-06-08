Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F156D1F3021
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbgFIA4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:56:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728315AbgFHXJE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:09:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48858208C9;
        Mon,  8 Jun 2020 23:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657744;
        bh=TZrUG0c+bqLjBayBmaG07PdziZ3fDMuG7ttxZs3ZcfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WiO8QZiOI3Ynh2+DZ4bUY5Ztma6D67bJ8l6uGYfHfxU0x4762+TSZ6giP2AYjbOOr
         IM9bhDI6rWoRBpVdxapEJgmFj9jdG6d+aMJtetVvp/jhcxqA+CWjma/YHjB/k65S0i
         lY4rOEYn6EhaVNhVxSWQ7so43sIQpQHAaq0d6yfo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 132/274] selftests/bpf: Fix invalid memory reads in core_relo selftest
Date:   Mon,  8 Jun 2020 19:03:45 -0400
Message-Id: <20200608230607.3361041-132-sashal@kernel.org>
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

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit 13c908495e5d51718a6da84ae925fa2aac056380 ]

Another one found by AddressSanitizer. input_len is bigger than actually
initialized data size.

Fixes: c7566a69695c ("selftests/bpf: Add field existence CO-RE relocs tests")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200429012111.277390-8-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/core_reloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index 31e177adbdf1..084ed26a7d78 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -392,7 +392,7 @@ static struct core_reloc_test_case test_cases[] = {
 		.input = STRUCT_TO_CHAR_PTR(core_reloc_existence___minimal) {
 			.a = 42,
 		},
-		.input_len = sizeof(struct core_reloc_existence),
+		.input_len = sizeof(struct core_reloc_existence___minimal),
 		.output = STRUCT_TO_CHAR_PTR(core_reloc_existence_output) {
 			.a_exists = 1,
 			.b_exists = 0,
-- 
2.25.1

