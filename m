Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9A705320C7
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 04:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbiEXCOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 22:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbiEXCOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 22:14:38 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11AC9CC8D;
        Mon, 23 May 2022 19:14:37 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id s14so14644260plk.8;
        Mon, 23 May 2022 19:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uzwsnZV7IYvElYAYzueM3EXJ6EeJbSeB2sRHju8p254=;
        b=fWvyRucWZfEPZPAAQBZKWIYhuLRSr/7FhizCutDbKdkqj8mBR0MRsFe6g9uwF75Euk
         w0QQjNQvCB9SU8DT4vigzB56AdeSi/2VMzwIN6TyPKfwBx0EwDu3UENnM5zUctvBR0UA
         9C1B9wRjnfKs8izidNgTDGsCUbIQ6o6//4jmOjtbQBbed+RK0Idjqn1zqMYwL0C7Xmay
         /rWzZGTVtHHUH8nwXKV9Dxv6GUMrhgfo8BftYLDiX5cdOVQaCzIU++XTr4T9+6VaL3Rf
         3oHu8jyWmXLBY9pgXmfHSMXeiTbypgGN2VQU44bh1eHcIerUb0WDAB6GJm285Ca2OtMp
         VbEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uzwsnZV7IYvElYAYzueM3EXJ6EeJbSeB2sRHju8p254=;
        b=rjafCmVRJw9OPaobm1Npg6mEqL7fyb21wEcV2Mqx2NdsmxlTLkYIkn4ML1DxDm8KZE
         KPv7uks0JNmn5kwJF6p63oYfTNZf6isRQsJhjAw0s3NcLdMlRddCAau/4gIkC2WJgtcH
         TWLXeO9s44NIu7J7JMpgGm5hjPW0YjMbNBQt3g80y1vhdeYqkUmXasrj09YSyYf9jnAj
         Z/ILTDT9BxVNsG4mBsumxf2otb5IhgaaKvN78tLY7RD0nYIunxhiOTXj2tj4eYLuQksE
         miZLgTQ43uzXPpMUexJev+GLaGlL1vKVP4y0zl/iZnIQ4yDOv0jX7E5YMRBVg3F2x6i5
         Hokw==
X-Gm-Message-State: AOAM532hXHs6G+o2OqZ1T3lvFFD76wDxORIUYBpAKrYk6W/NanenYJbJ
        qfJ4mvCeRbF96elfoSnEx+o=
X-Google-Smtp-Source: ABdhPJyKvHxAcYP2ZkvZvcjI48GbQJv4y2Xn1K3BOZjzwhRPhnq+75bMDc9RG2KrTgnbOj1B39ZwvA==
X-Received: by 2002:a17:903:28d:b0:162:1eae:bb0e with SMTP id j13-20020a170903028d00b001621eaebb0emr8908344plr.38.1653358477270;
        Mon, 23 May 2022 19:14:37 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.117])
        by smtp.gmail.com with ESMTPSA id i23-20020a056a00225700b005182deb6c1bsm7911181pfu.62.2022.05.23.19.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 19:14:36 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Menglong Dong <imagedong@tencent.com>,
        Jiang Biao <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
Subject: [PATCH bpf v2] bpf: fix probe read error in ___bpf_prog_run()
Date:   Tue, 24 May 2022 10:12:27 +0800
Message-Id: <20220524021228.533216-1-imagedong@tencent.com>
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

Fixes: 2a02759ef5f8 ("bpf: Add support for BTF pointers to interpreter")
Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v2:
- fold the code into LDST (Daniel Borkmann)
- add the 'Fixes' tag
---
 kernel/bpf/core.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 13e9dbeeedf3..81f814f31187 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1938,6 +1938,11 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 		CONT;							\
 	LDX_MEM_##SIZEOP:						\
 		DST = *(SIZE *)(unsigned long) (SRC + insn->off);	\
+		CONT;							\
+	LDX_PROBE_MEM_##SIZEOP:						\
+		bpf_probe_read_kernel(&DST, sizeof(SIZE),		\
+				      (const void *)(long) (SRC + insn->off));	\
+		DST = *((SIZE *)&DST);					\
 		CONT;
 
 	LDST(B,   u8)
@@ -1945,15 +1950,6 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 	LDST(W,  u32)
 	LDST(DW, u64)
 #undef LDST
-#define LDX_PROBE(SIZEOP, SIZE)							\
-	LDX_PROBE_MEM_##SIZEOP:							\
-		bpf_probe_read_kernel(&DST, SIZE, (const void *)(long) (SRC + insn->off));	\
-		CONT;
-	LDX_PROBE(B,  1)
-	LDX_PROBE(H,  2)
-	LDX_PROBE(W,  4)
-	LDX_PROBE(DW, 8)
-#undef LDX_PROBE
 
 #define ATOMIC_ALU_OP(BOP, KOP)						\
 		case BOP:						\
-- 
2.36.1

