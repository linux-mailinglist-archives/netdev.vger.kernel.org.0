Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2E153800C
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238852AbiE3N6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239505AbiE3N4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:56:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0859729B;
        Mon, 30 May 2022 06:38:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABB4B60F1F;
        Mon, 30 May 2022 13:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFB6C341C5;
        Mon, 30 May 2022 13:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917916;
        bh=EI6kyMEv2r+oMfMB12oZQKomnwfH3xTNuKb7+f/Swr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BOsNKdFY7jfwDdDDIK85pLfJL7Kuz9BJ+vXanGbTYYle/exZh+8590zCoc+H9DUqZ
         YV0q8sTlLnPM+/Gszd8529/WmsIXMd1ev65xwgyJmfP/0RcQvCVC/s5HXx3uHiGbs9
         f4SAh0AE0o2B/wSrzs23+xSi0I0hd9Yji169aGR96sy4ERoZV0x6PGntVgEy3ABBCn
         mNEZ7yYEhL+DOGmmZ0Kk7zEnyWA9DZ1/YXqprdrFNzkph1EPbjgv1HLr9rWo86EIHu
         X55Mi33JRPXdiNAUFBx7q9Z70N3zKdiB98KaYs7LP4OGTHSEwX9Yvl99VqgnUf2qso
         RhYc6PJ6hWegA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 004/109] selftests/bpf: Fix vfs_link kprobe definition
Date:   Mon, 30 May 2022 09:36:40 -0400
Message-Id: <20220530133825.1933431-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
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

From: Nikolay Borisov <nborisov@suse.com>

[ Upstream commit e299bcd4d16ff86f46c48df1062c8aae0eca1ed8 ]

Since commit 6521f8917082 ("namei: prepare for idmapped mounts")
vfs_link's prototype was changed, the kprobe definition in
profiler selftest in turn wasn't updated. The result is that all
argument after the first are now stored in different registers. This
means that self-test has been broken ever since. Fix it by updating the
kprobe definition accordingly.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220331140949.1410056-1-nborisov@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/profiler.inc.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/profiler.inc.h b/tools/testing/selftests/bpf/progs/profiler.inc.h
index 4896fdf816f7..92331053dba3 100644
--- a/tools/testing/selftests/bpf/progs/profiler.inc.h
+++ b/tools/testing/selftests/bpf/progs/profiler.inc.h
@@ -826,8 +826,9 @@ int kprobe_ret__do_filp_open(struct pt_regs* ctx)
 
 SEC("kprobe/vfs_link")
 int BPF_KPROBE(kprobe__vfs_link,
-	       struct dentry* old_dentry, struct inode* dir,
-	       struct dentry* new_dentry, struct inode** delegated_inode)
+	       struct dentry* old_dentry, struct user_namespace *mnt_userns,
+	       struct inode* dir, struct dentry* new_dentry,
+	       struct inode** delegated_inode)
 {
 	struct bpf_func_stats_ctx stats_ctx;
 	bpf_stats_enter(&stats_ctx, profiler_bpf_vfs_link);
-- 
2.35.1

