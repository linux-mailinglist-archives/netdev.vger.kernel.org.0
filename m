Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D313742D7
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235937AbhEEQsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:48:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236013AbhEEQp0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:45:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED52D6193E;
        Wed,  5 May 2021 16:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232575;
        bh=l6JtpswOXURGtwYZ5hYYWOergdQEDDoc8UI/xd6dLdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LxvdtkcEqNo3bPZMU3ZsZHXTUVf+cMqJogeq7zJT47sRDUIJYYlFhi8pEsZIBkqWn
         kuSpf9Ju//ficvmEnPySCj0wXR6M2RvuWDZVhMTAYvLo3ZhUIzhChI3IL2eDE19RT1
         Bm9ReAnZwUgieXR5wC0n4VFk8wgRw57uNQvN9Sxorev8sKFfAZu36hD3HKx/IuCjJE
         uu9cuEqzxb6wfzvqrxJfFfsX7mWE5icqxDp45iBPU+ui+f6tot2u0al1QOVRxQLaXh
         eEnTv2MrlOCi8ODLIYXJpylhd3jHPboRbpYcOgHJmRSvj+pGFmGIfgaYZVuRMCCUvx
         4y+N/ZqnfkPGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yaqi Chen <chendotjs@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 083/104] samples/bpf: Fix broken tracex1 due to kprobe argument change
Date:   Wed,  5 May 2021 12:33:52 -0400
Message-Id: <20210505163413.3461611-83-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
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

