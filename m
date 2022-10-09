Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96EAA5F901B
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbiJIWUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbiJIWTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:19:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368C73D59A;
        Sun,  9 Oct 2022 15:16:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AB9760D3F;
        Sun,  9 Oct 2022 22:14:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8225BC433C1;
        Sun,  9 Oct 2022 22:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353644;
        bh=f33ezdzKDOq2FUj87Tg0YqhnSXpQQOcpgP0oUn0mnp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cqkkkUJzdLpcQfRVBEYuXVlLKesew7qgabX8lrtu758U0doYChsgZ8OqEL8tMx2rj
         PMAWyv1N6HKaVKvWw3RQI2xBd+kLlLOhXY/n8k8je8tVVO+9sHIodQ2r1m/1W+cJkX
         lQx9BkeYT4pCUcK4CD2+DGP4If06EBhE+2hsCIRtVjkJcr0s2hGbYeiKnaVszkHGTV
         K7rMAjIFHKVojZic/ARFyjXNUxtKJXjEhTb77UErJ8DmcRgfWyjVA4/rMay1Y+bhOR
         Zr1Mue0BATLyhMRJoGYsGzi59ftT34FxcusHB/tuZu4LmBJD6rHDG0PLZvvbKMLs+D
         IblPgv6txibbQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        syzbot+a2c4601efc75848ba321@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 72/77] net: sched: cls_u32: Avoid memcpy() false-positive warning
Date:   Sun,  9 Oct 2022 18:07:49 -0400
Message-Id: <20221009220754.1214186-72-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009220754.1214186-1-sashal@kernel.org>
References: <20221009220754.1214186-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 7cba18332e3635aaae60e4e7d4e52849de50d91b ]

To work around a misbehavior of the compiler's ability to see into
composite flexible array structs (as detailed in the coming memcpy()
hardening series[1]), use unsafe_memcpy(), as the sizing,
bounds-checking, and allocation are all very tightly coupled here.
This silences the false-positive reported by syzbot:

  memcpy: detected field-spanning write (size 80) of single field "&n->sel" at net/sched/cls_u32.c:1043 (size 16)

[1] https://lore.kernel.org/linux-hardening/20220901065914.1417829-2-keescook@chromium.org

Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Reported-by: syzbot+a2c4601efc75848ba321@syzkaller.appspotmail.com
Link: https://lore.kernel.org/lkml/000000000000a96c0b05e97f0444@google.com/
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://lore.kernel.org/r/20220927153700.3071688-1-keescook@chromium.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_u32.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 4d27300c287c..5f33472aad36 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -1040,7 +1040,11 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 	}
 #endif
 
-	memcpy(&n->sel, s, sel_size);
+	unsafe_memcpy(&n->sel, s, sel_size,
+		      /* A composite flex-array structure destination,
+		       * which was correctly sized with struct_size(),
+		       * bounds-checked against nla_len(), and allocated
+		       * above. */);
 	RCU_INIT_POINTER(n->ht_up, ht);
 	n->handle = handle;
 	n->fshift = s->hmask ? ffs(ntohl(s->hmask)) - 1 : 0;
-- 
2.35.1

