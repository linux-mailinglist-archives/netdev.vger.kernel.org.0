Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB58489DF2
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 17:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237445AbiAJQ7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 11:59:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237327AbiAJQ7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 11:59:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58270C06173F;
        Mon, 10 Jan 2022 08:59:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 457F461341;
        Mon, 10 Jan 2022 16:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D50C36AE3;
        Mon, 10 Jan 2022 16:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641833980;
        bh=dL5sJz14KH/MnFm5LiWq3OK9TibKvIP5py+qchPUekA=;
        h=From:To:Cc:Subject:Date:From;
        b=RDraMqr7XGnCR4woIVwGa1WdQQQwyYNS1cCiaqmGtWhWfe4/HCgvzb6GDiHK1vUuQ
         GoRLtJGFjk+a2DOwby5nTgvxOjLVGlSTI3N6TyP1Su6A6kg7+ZDEKbvLSzy+FYXX2A
         +kjSm2N/OomoHMcSLUyhPk1aiknBe8g5eSzKgX0VodiAJVhGsk/jnY5ku1G3OuOwxd
         Re5mTP75shNx1VpiEqTgyI0YtLcDK+iaK/6q4IDkBxIsyTpTdNJxrB/1OgTc0su7Rx
         aiXcQh2I2n+hCUetVHfe10aNDFXaZDyKgi1GfkKJ218OgVTbLbkrjlbFBW94WPGf1O
         etzmbZQfVquIw==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tong Tiangen <tongtiangen@huawei.com>
Subject: [PATCH riscv-next] riscv: bpf: Fix eBPF's exception tables
Date:   Tue, 11 Jan 2022 00:52:08 +0800
Message-Id: <20220110165208.1826-1-jszhang@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

eBPF's exception tables needs to be modified to relative synchronously.

Suggested-by: Tong Tiangen <tongtiangen@huawei.com>
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
 arch/riscv/net/bpf_jit_comp64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index 69bab7e28f91..44c97535bc15 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -498,7 +498,7 @@ static int add_exception_handler(const struct bpf_insn *insn,
 	offset = pc - (long)&ex->insn;
 	if (WARN_ON_ONCE(offset >= 0 || offset < INT_MIN))
 		return -ERANGE;
-	ex->insn = pc;
+	ex->insn = offset;
 
 	/*
 	 * Since the extable follows the program, the fixup offset is always
-- 
2.34.1

