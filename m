Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23C6A554C0
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 18:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730108AbfFYQmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 12:42:09 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35702 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfFYQmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 12:42:09 -0400
Received: by mail-wr1-f68.google.com with SMTP id f15so8768399wrp.2
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 09:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=y5blvdusstoEBszUgmJKT0Yl0yITIrtN07M1rej+1qA=;
        b=pm5KKB2gxMITkFXmlF3pLA1hYYCw77ymmU7KI3JbTUquFS3ZdPgLivhXfe3HXP5aof
         M8EHBsOz1Gx9a10KEnptTht49VDbWaP4xccZ22zMiTpIBEpQ3Uv5Qf2+OO3DBrtKaocb
         8OPq1t6KVVC2NHX2iMjYASPuO9MPKe8/OK6KUNIsU6Il8cj0zJZM1pBnKI04DgcxJ5eu
         MP0FB5evyIYe9THR6oIdw9eE8c1IDuDFnTHRsKpx0ERwWeZYZxePKUhs1RPdNSmS4Xjt
         ei2nubD9mS+mDEZXvLIZ16WUNHMGqlhIl2Wc8gzFuf320mlUk1xVrX+cAH7Rg7yaI1dR
         6/UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=y5blvdusstoEBszUgmJKT0Yl0yITIrtN07M1rej+1qA=;
        b=uAIuSUcO5Lz8TsFWjuC+c/LHAlvS+bC5r4i8gv3ByBY7duWRfgXt3/qWXu+nlrnFAr
         kWX8vmn73Z4bZNI4yGpB8LXrWj19UEsr0FYWbASlj+6E7MCm+T5sJwmd//V9ZkYEaj7l
         P2lnJdApXme30s2jQz+pax9a0kweKLR70Ox2CQK8BqlJ6T5spDdsvMgzEtg5Zlib6qFi
         836z0oTO8TvhLTY8pceXowSOJPMxKs+MKBrvh2UPqKCnpG22+yyL1iT7wSq/Uty+nZn/
         HraflCj5FBcP6rOMpmDs2aCnpZ/J5pKtRPM5TWMd2uEKb+BSnJImVgHSc49PiS31T7fR
         ITow==
X-Gm-Message-State: APjAAAUwVH/sfIECHKyEzS7o9heo/fj/4gq0ZKuH/GpEUqjawRLv9swB
        g6O56L5LAUIOj0Z9BVMOCVzXvw==
X-Google-Smtp-Source: APXvYqz+TSK98tpYD63Jka2jQt+u1T0oI8V2xuLaa1GFP/8l+dgv0ouJwsKc6Drc4nVJ1rAxH4KkkA==
X-Received: by 2002:adf:fec9:: with SMTP id q9mr39325719wrs.241.1561480926959;
        Tue, 25 Jun 2019 09:42:06 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id r4sm22919836wra.96.2019.06.25.09.42.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 25 Jun 2019 09:42:06 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     yauheni.kaliuta@redhat.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH bpf] bpf: fix BPF_ALU32 | BPF_ARSH on BE arches
Date:   Tue, 25 Jun 2019 17:41:50 +0100
Message-Id: <1561480910-23543-1-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yauheni reported the following code do not work correctly on BE arches:

       ALU_ARSH_X:
               DST = (u64) (u32) ((*(s32 *) &DST) >> SRC);
               CONT;
       ALU_ARSH_K:
               DST = (u64) (u32) ((*(s32 *) &DST) >> IMM);
               CONT;

and are causing failure of test_verifier test 'arsh32 on imm 2' on BE
arches.

The code is taking address and interpreting memory directly, so is not
endianness neutral. We should instead perform standard C type casting on
the variable. A u64 to s32 conversion will drop the high 32-bit and reserve
the low 32-bit as signed integer, this is all we want.

Fixes: 2dc6b100f928 ("bpf: interpreter support BPF_ALU | BPF_ARSH")
Reported-by: Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 kernel/bpf/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 080e2bb..f2148db 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1364,10 +1364,10 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
 		insn++;
 		CONT;
 	ALU_ARSH_X:
-		DST = (u64) (u32) ((*(s32 *) &DST) >> SRC);
+		DST = (u64) (u32) (((s32) DST) >> SRC);
 		CONT;
 	ALU_ARSH_K:
-		DST = (u64) (u32) ((*(s32 *) &DST) >> IMM);
+		DST = (u64) (u32) (((s32) DST) >> IMM);
 		CONT;
 	ALU64_ARSH_X:
 		(*(s64 *) &DST) >>= SRC;
-- 
2.7.4

