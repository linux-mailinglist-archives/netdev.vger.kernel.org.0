Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3BC649171E
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344857AbiARChh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:37:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245652AbiARCdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:33:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E682C061796;
        Mon, 17 Jan 2022 18:32:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33B28B81243;
        Tue, 18 Jan 2022 02:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80FE8C36AE3;
        Tue, 18 Jan 2022 02:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473139;
        bh=Adkz8tW47vbwofh7NrAPeUglOkNTCxORjd0loYPv954=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dRyh79iGAnN2/4K3b30xfxJkZrp7/mh+SxxU6wFcOmJVRu96PWSFexEJ88C7uG/S+
         B1nk9sCVHR5IzGPdL4WytiJujOqKK+zZ6Ap8qQc6c3fEqJvr4QS5uFDPvhFtbcW1lU
         AENhUuvylNJYjPcAy2peSOQ1gwwGq4HAKz6ZtkuWGfxJAzMM5yrLR13zO2MTTcnfEM
         JvTrU/GYJZKZgGZqiRbJLFHfdbn0CbcuTg3zWvGXja1NSZaN3dOTUhVA8dzKSKIsXx
         hpxZl4nBU7EHcrPL+DTafmVKVZmQIGl6Fvc1rCxk8EyOIEY99wQTexuP8k1Ado3kSW
         +qICaVywWMVlg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Hengqi Chen <hengqi.chen@gmail.com>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        daniel@iogearbox.net, davemarchevsky@fb.com, kafai@fb.com,
        ntspring@fb.com, vfedorenko@novek.ru,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 010/188] selftests/bpf: Fix bpf_object leak in skb_ctx selftest
Date:   Mon, 17 Jan 2022 21:28:54 -0500
Message-Id: <20220118023152.1948105-10-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 8c7a95520184b6677ca6075e12df9c208d57d088 ]

skb_ctx selftest didn't close bpf_object implicitly allocated by
bpf_prog_test_load() helper. Fix the problem by explicitly calling
bpf_object__close() at the end of the test.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Hengqi Chen <hengqi.chen@gmail.com>
Link: https://lore.kernel.org/bpf/20211107165521.9240-10-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/skb_ctx.c b/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
index fafeddaad6a99..23915be6172d6 100644
--- a/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
+++ b/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
@@ -105,4 +105,6 @@ void test_skb_ctx(void)
 		   "ctx_out_mark",
 		   "skb->mark == %u, expected %d\n",
 		   skb.mark, 10);
+
+	bpf_object__close(obj);
 }
-- 
2.34.1

