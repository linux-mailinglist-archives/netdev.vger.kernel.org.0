Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560AF3745E1
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236298AbhEERIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 13:08:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236902AbhEERDn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 13:03:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C378D61A3E;
        Wed,  5 May 2021 16:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232914;
        bh=RoA7G0ZmY5hKYB+MBB4C21QqDWguMEVxPPx+ofxXPxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZygQNfW+VyrpAvUsr3I6dg9G/c/yFQ2SbG233vwzf5WCZ7ouHjEIYHj6I4Z+148gH
         rFjse0ZAi/3IlE5yr4u0+jT68cgyocjuTbpt0EOkv+OgE6ytpbo/Dbc/85qm6WUOua
         k4B1VLiL2y1t5xTsOt0usFs8zNLUQg5t2LMmA7bHPMu12YD4herGYoVjn8AB9U05sO
         hlZeQ/b/trA5GKqsVoG2YQe4yYK1TL80uZQK/eURnHfQe36JiPhgYBGR+ZgOX7CGhF
         Hnt5Tbr0dZxph3pKitMEtmxI7o8V0pC1X93U2EqJ20kq00pf1JsYnUBKSrLYh7crjG
         Qrhl/Id9m3lXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yaqi Chen <chendotjs@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 17/22] samples/bpf: Fix broken tracex1 due to kprobe argument change
Date:   Wed,  5 May 2021 12:41:24 -0400
Message-Id: <20210505164129.3464277-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505164129.3464277-1-sashal@kernel.org>
References: <20210505164129.3464277-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yaqi Chen <chendotjs@gmail.com>

[ Upstream commit 137733d08f4ab14a354dacaa9a8fc35217747605 ]

>From commit c0bbbdc32feb ("__netif_receive_skb_core: pass skb by
reference"), the first argument passed into __netif_receive_skb_core
has changed to reference of a skb pointer.

This commit fixes by using bpf_probe_read_kernel.

Signed-off-by: Yaqi Chen <chendotjs@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20210416154803.37157-1-chendotjs@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/tracex1_kern.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/tracex1_kern.c b/samples/bpf/tracex1_kern.c
index 107da148820f..9c74b45c5720 100644
--- a/samples/bpf/tracex1_kern.c
+++ b/samples/bpf/tracex1_kern.c
@@ -20,7 +20,7 @@
 SEC("kprobe/__netif_receive_skb_core")
 int bpf_prog1(struct pt_regs *ctx)
 {
-	/* attaches to kprobe netif_receive_skb,
+	/* attaches to kprobe __netif_receive_skb_core,
 	 * looks for packets on loobpack device and prints them
 	 */
 	char devname[IFNAMSIZ];
@@ -29,7 +29,7 @@ int bpf_prog1(struct pt_regs *ctx)
 	int len;
 
 	/* non-portable! works for the given kernel only */
-	skb = (struct sk_buff *) PT_REGS_PARM1(ctx);
+	bpf_probe_read_kernel(&skb, sizeof(skb), (void *)PT_REGS_PARM1(ctx));
 	dev = _(skb->dev);
 	len = _(skb->len);
 
-- 
2.30.2

