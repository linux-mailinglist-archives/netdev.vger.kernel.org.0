Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3CF530A08
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 10:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbiEWHjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 03:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiEWHjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 03:39:07 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D818F13DF9;
        Mon, 23 May 2022 00:39:04 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w200so12924942pfc.10;
        Mon, 23 May 2022 00:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FDKEez4LL/T5vz5sGrr37Im2D5hBP4Hr0638TS/hH4w=;
        b=qWlHQua1NGt2HLFYqYJKMsocOeNT5XL7JjMoe7VhhejqbWyffuDbiIez8cPfKAxmM9
         zDzEZFcT2zR4bCq+EWZsWu1QtweEij42nIPNEFCbFcGVcQWCXteZnFWG395yQ+qTUkW7
         fyPoux3wi9J8M0JJ5ASaZx/VXgyGTNvg6xcuVt59pyFzXc0O5pXG0PlSEONemYH2Q8zI
         fHZk8/2mkBkogsgh1+hEcGkBr8jlGLOOsNSkS/YQicDZEEkucvUvaO0qY1ckiB4qUmF+
         p+MyyiacObjIhVqW82sEBPtfXxNe7XF3RPLShb3OKc/hzDIrX/oHw/nzHDqYnWxOHtSN
         ARZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FDKEez4LL/T5vz5sGrr37Im2D5hBP4Hr0638TS/hH4w=;
        b=jAq0E6xaiOxYu+DrCX6bwVPp03TEfMWW47RToubd/jJBJGx5BXGhsqO5gH1dV1Em3Q
         YQacqGneqVE8a3meBbQUzdKzHywA/RR87nz89TbSZBxfAECBIgoxLLfZJrMadlUFIVZq
         KdqhcKUNzmBPAGeDLIFXJ4hPeMGYTdKBJEZUEGx/uMRqhznUMUtWRKqpv+6k6j0qT49d
         C0fxMshEoYO2ZE/OWeM8yb2vyp71oyIb3uOf9p5V57nMZ0fh4e1bMWn8FQtGD+HuU/i4
         oNWasB9vNRQSFlWy9jqWHChKGKwbnz3yYrSj7eVTTBhRELOj4VfhBY1LXHeZGkyhHX0S
         wRnw==
X-Gm-Message-State: AOAM5333lIvDZZ+1nwZVS7WRUjdVh10mbRaXk6ODaSkqnozKEPgSQzAG
        +MqKjtKv59XjNKkioDjlM/o=
X-Google-Smtp-Source: ABdhPJxFCqI8Rwlcssa1BNjfxrK8HpuSbbIopph7tby9Jp/NcYLy0dbo9U6k2v/Tq/lyxQUdkq/4xA==
X-Received: by 2002:a63:e017:0:b0:3f2:543b:8402 with SMTP id e23-20020a63e017000000b003f2543b8402mr19085100pgh.209.1653291544335;
        Mon, 23 May 2022 00:39:04 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.21])
        by smtp.gmail.com with ESMTPSA id d13-20020a170902e14d00b0015e8d4eb204sm4360048pla.78.2022.05.23.00.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 00:39:03 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Menglong Dong <imagedong@tencent.com>,
        Jiang Biao <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
Subject: [PATCH] bpf: fix probe read error in ___bpf_prog_run()
Date:   Mon, 23 May 2022 15:37:32 +0800
Message-Id: <20220523073732.296247-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

I think there is something wrong with BPF_PROBE_MEM in ___bpf_prog_run()
in big-endian machine. Let's make a test and see what will happen if we
want to load a 'u16' with BPF_PROBE_MEM.

Let's make the src value '0x0001', the value of dest register will become
0x0001000000000000, as the value will be loaded to the first 2 byte of
DST with following code:

  bpf_probe_read_kernel(&DST, SIZE, (const void *)(long) (SRC + insn->off));

Obviously, the value in DST is not correct. In fact, we can compare
BPF_PROBE_MEM with LDX_MEM_H:

  DST = *(SIZE *)(unsigned long) (SRC + insn->off);

If the memory load is done by LDX_MEM_H, the value in DST will be 0x1 now.

And I think this error results in the test case 'test_bpf_sk_storage_map'
failing:

  test_bpf_sk_storage_map:PASS:bpf_iter_bpf_sk_storage_map__open_and_load 0 nsec
  test_bpf_sk_storage_map:PASS:socket 0 nsec
  test_bpf_sk_storage_map:PASS:map_update 0 nsec
  test_bpf_sk_storage_map:PASS:socket 0 nsec
  test_bpf_sk_storage_map:PASS:map_update 0 nsec
  test_bpf_sk_storage_map:PASS:socket 0 nsec
  test_bpf_sk_storage_map:PASS:map_update 0 nsec
  test_bpf_sk_storage_map:PASS:attach_iter 0 nsec
  test_bpf_sk_storage_map:PASS:create_iter 0 nsec
  test_bpf_sk_storage_map:PASS:read 0 nsec
  test_bpf_sk_storage_map:FAIL:ipv6_sk_count got 0 expected 3
  $10/26 bpf_iter/bpf_sk_storage_map:FAIL

The code of the test case is simply, it will load sk->sk_family to the
register with BPF_PROBE_MEM and check if it is AF_INET6. With this patch,
now the test case 'bpf_iter' can pass:

  $10  bpf_iter:OK

Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 kernel/bpf/core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 13e9dbeeedf3..09e3f374739a 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1945,14 +1945,15 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 	LDST(W,  u32)
 	LDST(DW, u64)
 #undef LDST
-#define LDX_PROBE(SIZEOP, SIZE)							\
+#define LDX_PROBE(SIZEOP, SIZE, TYPE)						\
 	LDX_PROBE_MEM_##SIZEOP:							\
 		bpf_probe_read_kernel(&DST, SIZE, (const void *)(long) (SRC + insn->off));	\
+		DST = *((TYPE *)&DST);						\
 		CONT;
-	LDX_PROBE(B,  1)
-	LDX_PROBE(H,  2)
-	LDX_PROBE(W,  4)
-	LDX_PROBE(DW, 8)
+	LDX_PROBE(B,  1, u8)
+	LDX_PROBE(H,  2, u16)
+	LDX_PROBE(W,  4, u32)
+	LDX_PROBE(DW, 8, u64)
 #undef LDX_PROBE
 
 #define ATOMIC_ALU_OP(BOP, KOP)						\
-- 
2.36.1

