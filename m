Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9B7533BE1
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 13:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236371AbiEYLkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 07:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiEYLkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 07:40:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00C1A0D25;
        Wed, 25 May 2022 04:40:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B98F615CC;
        Wed, 25 May 2022 11:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893B1C385B8;
        Wed, 25 May 2022 11:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653478810;
        bh=O0hkzNHe+K8erPlb8cYEygQJ5Yo50JHcvp2+lT7xKqQ=;
        h=From:To:Cc:Subject:Date:From;
        b=cwNgzXX/TBzWJG2oHp17Bb6hIYlMskSuLhIwIwYnzqtMHjloxjL2rrQbxPaMbgK68
         U0zeuS0tLlai0daNUWF/spWe22Gm72escZ3+XfxsRBXF5TvoSYTX3Qucw4UR5WlP7Y
         8bPXXMa08hwZ9ycH7qpOrm0WbNeB673ie1vhVl8Tg34dNs9x0o8y4vPnnr22vTRA8u
         62x1THdfMe5yW1pY01BBoRdq8LOUD3SYmPS+WySoXLITE93KsjEKrWavxuO2kTbB6R
         oP9+QCKv4bA4hwMKqkjX3ImV3+N6s5XsZvwoafqdhrkaNTsi7meQCu7C9qltsuFQK5
         dGfigBBNbgR1g==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [RFC bpf-next] bpf: Use prog->active instead of bpf_prog_active for kprobe_multi
Date:   Wed, 25 May 2022 13:40:03 +0200
Message-Id: <20220525114003.61890-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
Alexei suggested to use prog->active instead global bpf_prog_active
for programs attached with kprobe multi [1].

AFAICS this will bypass bpf_disable_instrumentation, which seems to be
ok for some places like hash map update, but I'm not sure about other
places, hence this is RFC post.

I'm not sure how are kprobes different to trampolines in this regard,
because trampolines use prog->active and it's not a problem.

thoughts?

thanks,
jirka


[1] https://lore.kernel.org/bpf/20220316185333.ytyh5irdftjcklk6@ast-mbp.dhcp.thefacebook.com/
---
 kernel/trace/bpf_trace.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 10b157a6d73e..7aec39ae0a1c 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2385,8 +2385,8 @@ static u64 bpf_kprobe_multi_entry_ip(struct bpf_run_ctx *ctx)
 }
 
 static int
-kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
-			   unsigned long entry_ip, struct pt_regs *regs)
+__kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
+			     unsigned long entry_ip, struct pt_regs *regs)
 {
 	struct bpf_kprobe_multi_run_ctx run_ctx = {
 		.link = link,
@@ -2395,21 +2395,28 @@ kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
 	struct bpf_run_ctx *old_run_ctx;
 	int err;
 
-	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
-		err = 0;
-		goto out;
-	}
-
-	migrate_disable();
-	rcu_read_lock();
 	old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
 	err = bpf_prog_run(link->link.prog, regs);
 	bpf_reset_run_ctx(old_run_ctx);
+	return err;
+}
+
+static int
+kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
+			   unsigned long entry_ip, struct pt_regs *regs)
+{
+	struct bpf_prog *prog = link->link.prog;
+	int err = 0;
+
+	migrate_disable();
+	rcu_read_lock();
+
+	if (likely(__this_cpu_inc_return(*(prog->active)) == 1))
+		err = __kprobe_multi_link_prog_run(link, entry_ip, regs);
+
+	__this_cpu_dec(*(prog->active));
 	rcu_read_unlock();
 	migrate_enable();
-
- out:
-	__this_cpu_dec(bpf_prog_active);
 	return err;
 }
 
-- 
2.35.3

