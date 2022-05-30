Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBB38537B9A
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 15:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236609AbiE3NZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236636AbiE3NY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:24:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B8A82157;
        Mon, 30 May 2022 06:24:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED04CB80DAF;
        Mon, 30 May 2022 13:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1885C3411C;
        Mon, 30 May 2022 13:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917087;
        bh=7R34usxBQu7eJg2cIGwm/1IcqRrI7YppV2uXmYDwZpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tijY0XGkYwOuYSSbIVHvWiq5kamQCHYeHieepIoc4zq0dplJdbqvEHjR6R1s/M4uW
         Grjk0jikPfN2Cza53LJXGW2FDUsLQUSb4j0Ft/6PCr4ZDV5n4ku6wy9A51+sJbAjKt
         ZwZXkmTpx3lKC8GQOye78htDcVlSrHbkiAeIut969HY79XCZhd4yPvqBVuElVCqWQj
         eLqlpEviAGMRQ6LnC4NaNZ7/7pdSuUyKxVoDWhFyLh98sA4ONrJhT8W5P8vBTOWqef
         lZF/yFVpaeqUN9LDavcUbW9uPu7pjg6igZYaKZKZvaebxCTeXFW19BeHfHTusLMpuq
         +yM3pNUn0SNrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yuntao Wang <ytcoode@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 009/159] selftests/bpf: Fix file descriptor leak in load_kallsyms()
Date:   Mon, 30 May 2022 09:21:54 -0400
Message-Id: <20220530132425.1929512-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuntao Wang <ytcoode@gmail.com>

[ Upstream commit 2d0df01974ce2b59b6f7d5bd3ea58d74f12ddf85 ]

Currently, if sym_cnt > 0, it just returns and does not close file, fix it.

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220405145711.49543-1-ytcoode@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/trace_helpers.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/trace_helpers.c b/tools/testing/selftests/bpf/trace_helpers.c
index 3d6217e3aff7..9c4be2cdb21a 100644
--- a/tools/testing/selftests/bpf/trace_helpers.c
+++ b/tools/testing/selftests/bpf/trace_helpers.c
@@ -25,15 +25,12 @@ static int ksym_cmp(const void *p1, const void *p2)
 
 int load_kallsyms(void)
 {
-	FILE *f = fopen("/proc/kallsyms", "r");
+	FILE *f;
 	char func[256], buf[256];
 	char symbol;
 	void *addr;
 	int i = 0;
 
-	if (!f)
-		return -ENOENT;
-
 	/*
 	 * This is called/used from multiplace places,
 	 * load symbols just once.
@@ -41,6 +38,10 @@ int load_kallsyms(void)
 	if (sym_cnt)
 		return 0;
 
+	f = fopen("/proc/kallsyms", "r");
+	if (!f)
+		return -ENOENT;
+
 	while (fgets(buf, sizeof(buf), f)) {
 		if (sscanf(buf, "%p %c %s", &addr, &symbol, func) != 3)
 			break;
-- 
2.35.1

