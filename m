Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C89374442
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234462AbhEEQ4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:56:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236274AbhEEQxp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:53:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9D156144C;
        Wed,  5 May 2021 16:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232702;
        bh=l6JtpswOXURGtwYZ5hYYWOergdQEDDoc8UI/xd6dLdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LO66ZT1+/TqspL+18Ww1izAav2PND+pAJLYO7tIx+JoNzEZtC6o5/YVaFKDvXpCJc
         +riZ2Nif0Ny52hKKgn6aVVt4QGqaie02e5XSc5YtSJKMF+BzBIK4oVg/NXqf2P2zS2
         a/MLySyxhnHRZQGAMNZjc6uHB/+jGIyw7kcbwA0HfrNvoTUY1+gxBWpbsKyP/1tnKQ
         N/NYUKkhVwj5yZODzxMK3i2R6VOhvWOfZBmUcQzW7PP5OLaGz6voCCYeb22mPizHGq
         eJxOYjcZln9rLtQm2+qeN/6Fi2ffQsYV0bMqlmuqdNGKB335qnAZbrk5Vva6yIcSjT
         HKef1qlNZo0tw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yaqi Chen <chendotjs@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 64/85] samples/bpf: Fix broken tracex1 due to kprobe argument change
Date:   Wed,  5 May 2021 12:36:27 -0400
Message-Id: <20210505163648.3462507-64-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
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
index 3f4599c9a202..ef30d2b353b0 100644
--- a/samples/bpf/tracex1_kern.c
+++ b/samples/bpf/tracex1_kern.c
@@ -26,7 +26,7 @@
 SEC("kprobe/__netif_receive_skb_core")
 int bpf_prog1(struct pt_regs *ctx)
 {
-	/* attaches to kprobe netif_receive_skb,
+	/* attaches to kprobe __netif_receive_skb_core,
 	 * looks for packets on loobpack device and prints them
 	 */
 	char devname[IFNAMSIZ];
@@ -35,7 +35,7 @@ int bpf_prog1(struct pt_regs *ctx)
 	int len;
 
 	/* non-portable! works for the given kernel only */
-	skb = (struct sk_buff *) PT_REGS_PARM1(ctx);
+	bpf_probe_read_kernel(&skb, sizeof(skb), (void *)PT_REGS_PARM1(ctx));
 	dev = _(skb->dev);
 	len = _(skb->len);
 
-- 
2.30.2

