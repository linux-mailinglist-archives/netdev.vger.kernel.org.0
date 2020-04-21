Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B23CE1B1AB0
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 02:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgDUA2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 20:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726056AbgDUA2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 20:28:16 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140F7C061A0E
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 17:28:16 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a32so625187pje.5
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 17:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=from:to:cc:subject:date:message-id;
        bh=FMzj+KBAT9oKczxa74v3DQRv9Cfu8gbIxOZJWY/KwN4=;
        b=F5Ecnjii1wOD6Z8F6N/EQ+BJvmRcCDXykdLJXNecm3nPcHmSBK8LG/V4JXCAT7Cxqp
         2L9yQo5z9bM5Ftq6Sye8tV3ZsqCdsgQXBH3nSq0DSBdCoOXb9i8pPKoHRCmYHNiLy4T0
         E+RWpg//Wu7E6ucg7Vm0c4gvUqHngOsJU/um4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FMzj+KBAT9oKczxa74v3DQRv9Cfu8gbIxOZJWY/KwN4=;
        b=MG2Fnbn8A418mFix7ZGk02zxGia7jy27DJetmYGvJTMsEXIt7EbjfixlmG8OHeY2nv
         PzNobI/VHXyP9cUP637qLDJF7geaPY5O1E+z9SK3Tz5myDF50grMfmwJkpIO9+s3/VUj
         BBpAkSB9T2zt/MtgcMovf+nzBzZgVNsw/BGyk3XLqrQs3LhiITG17AD67B/MwyBh+ubg
         AoedzSU8LuKwJQPT2bdN1EtYAkS6lV9cZ9Zkqo3j4qdgtN4vyJztrag09Y4GSj73MiMz
         q2MYp7oUy7BczluP1bKmLSU0mS+N1eoMRvkvPav29xA9EI8d9A5t644HTpBVoGtC8gwF
         ih8g==
X-Gm-Message-State: AGi0PuYwnzlSpQmiSQrL6eRf1QZWrN9BpteHoZyqsLwIPmbzcHfdAy6/
        UlKH3a/7hk/Qba32U6IiGuLyhA==
X-Google-Smtp-Source: APiQypJfRL/P24IvYTwSBmOVCK9iHgVzsETnPpci6H5O5Yc64EM8WVFWpSkRtjhEl62+jhSjad3bFQ==
X-Received: by 2002:a17:90b:19c1:: with SMTP id nm1mr2367164pjb.73.1587428895331;
        Mon, 20 Apr 2020 17:28:15 -0700 (PDT)
Received: from localhost.localdomain (c-73-53-94-119.hsd1.wa.comcast.net. [73.53.94.119])
        by smtp.gmail.com with ESMTPSA id f2sm547247pju.32.2020.04.20.17.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 17:28:14 -0700 (PDT)
From:   Luke Nelson <lukenels@cs.washington.edu>
X-Google-Original-From: Luke Nelson <luke.r.nels@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Luke Nelson <luke.r.nels@gmail.com>, Xi Wang <xi.wang@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf] bpf, riscv: Fix tail call count off by one in RV32 BPF JIT
Date:   Mon, 20 Apr 2020 17:28:04 -0700
Message-Id: <20200421002804.5118-1-luke.r.nels@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes an off by one error in the RV32 JIT handling for BPF
tail call. Currently, the code decrements TCC before checking if it
is less than zero. This limits the maximum number of tail calls to 32
instead of 33 as in other JITs. The fix is to instead check the old
value of TCC before decrementing.

Fixes: 5f316b65e99f ("riscv, bpf: Add RV32G eBPF JIT")
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
---
 arch/riscv/net/bpf_jit_comp32.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp32.c b/arch/riscv/net/bpf_jit_comp32.c
index 302934177760..11083d4d5f2d 100644
--- a/arch/riscv/net/bpf_jit_comp32.c
+++ b/arch/riscv/net/bpf_jit_comp32.c
@@ -770,12 +770,13 @@ static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
 	emit_bcc(BPF_JGE, lo(idx_reg), RV_REG_T1, off, ctx);
 
 	/*
-	 * if ((temp_tcc = tcc - 1) < 0)
+	 * temp_tcc = tcc - 1;
+	 * if (tcc < 0)
 	 *   goto out;
 	 */
 	emit(rv_addi(RV_REG_T1, RV_REG_TCC, -1), ctx);
 	off = (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
-	emit_bcc(BPF_JSLT, RV_REG_T1, RV_REG_ZERO, off, ctx);
+	emit_bcc(BPF_JSLT, RV_REG_TCC, RV_REG_ZERO, off, ctx);
 
 	/*
 	 * prog = array->ptrs[index];
-- 
2.17.1

