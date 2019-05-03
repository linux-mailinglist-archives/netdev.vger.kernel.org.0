Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 075BE12BB8
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 12:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbfECKoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 06:44:02 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35425 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727556AbfECKn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 06:43:59 -0400
Received: by mail-wm1-f66.google.com with SMTP id y197so6165326wmd.0
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 03:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=E1uglxRyFecLZ4+8so4GbOenEokaEEM+HAxuo+s+1vc=;
        b=lGuseTtRRTcHSSPfpFgHZOyTSY1+fUabWrvLqxaF3wYYvI1DidnNCrtmLmSQIvxfsT
         vgf60AEAVmvHnXm5qwFZrMghi172CPBT/TlqQdsgk03voaYCXpcRjlH9HbhC8rWEwoGb
         bK+b4qvWOEcfsM6JkCM9HeO+RefC05YfVi+iHMndMN+KXlp+wiVVDEV9n3YhnDTHNSl8
         g7OtF1vp5WugCtWi2hO7dsYOqpeOaS7rglLtxsvFQ1/zJIREpnk/gJ9ww29TLc3x24jD
         MSADvs3v7l6X1jDvQwS4LEvnGiClVBMzeGw/wy/XRGuRzknfufQMrrkEo+9HUqzizyOm
         Q9yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=E1uglxRyFecLZ4+8so4GbOenEokaEEM+HAxuo+s+1vc=;
        b=jfI8T8pqSUTqQm+VjJjSz1790f9Wqk6d0YQB9D7edQ9x38Ix5uzSWOrBWkrpfQTjlT
         NolD9I3o2RHOY8zoXxUXcIO/iPtlm2L2sLNq5wAYqJbVPR16iZA2sEdAROCDXTPgOOTy
         QcfRu/oOdoHbWsVCaP6oBfa/RXxveYi0t/tptj7Tboz2rkFMdU/p/X6UIJHPZTcBCU6X
         ouIHzWFERw2l48lJa1y14+OgylcfUsS1DZ5Ev4yVBQy9ydSHXYpR/aNEpJsmYMCsqd/L
         Ft02jAD1Rx6STJzq3CbAsm/GXB++/FXolvB7PYp0YNWQ8wgLFuyOJPqDlaIM8YKkY5jG
         zp5Q==
X-Gm-Message-State: APjAAAVy5wxYXUbXlBtQylfqaN04Bcf860Hq86fpHg6tbPTTWebuwK3h
        nnxD/KdqfVu1k+kkOytw0h/ENA==
X-Google-Smtp-Source: APXvYqzh2ofhMr072gDqrU/ulHXAnV5cagPt/km9f+/WPDKMYJKne/DiRcd38ypS/lGyhm+CyV4qNQ==
X-Received: by 2002:a7b:c5c7:: with SMTP id n7mr6001889wmk.9.1556880237144;
        Fri, 03 May 2019 03:43:57 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id r29sm1716999wra.56.2019.05.03.03.43.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 03 May 2019 03:43:56 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH v6 bpf-next 13/17] s390: bpf: eliminate zero extension code-gen
Date:   Fri,  3 May 2019 11:42:40 +0100
Message-Id: <1556880164-10689-14-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com>
References: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 arch/s390/net/bpf_jit_comp.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index 51dd026..8315b2e 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -299,9 +299,11 @@ static inline void reg_set_seen(struct bpf_jit *jit, u32 b1)
 
 #define EMIT_ZERO(b1)						\
 ({								\
-	/* llgfr %dst,%dst (zero extend to 64 bit) */		\
-	EMIT4(0xb9160000, b1, b1);				\
-	REG_SET_SEEN(b1);					\
+	if (!fp->aux->verifier_zext) {				\
+		/* llgfr %dst,%dst (zero extend to 64 bit) */	\
+		EMIT4(0xb9160000, b1, b1);			\
+		REG_SET_SEEN(b1);				\
+	}							\
 })
 
 /*
@@ -515,6 +517,13 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp, int i
 		jit->seen |= SEEN_REG_AX;
 	switch (insn->code) {
 	/*
+	 * BPF_ZEXT
+	 */
+	case BPF_ALU | BPF_ZEXT: /* dst = (u32) dst */
+		/* llgfr %dst,%dst */
+		EMIT4(0xb9160000, dst_reg, dst_reg);
+		break;
+	/*
 	 * BPF_MOV
 	 */
 	case BPF_ALU | BPF_MOV | BPF_X: /* dst = (u32) src */
@@ -1282,6 +1291,11 @@ static int bpf_jit_prog(struct bpf_jit *jit, struct bpf_prog *fp)
 	return 0;
 }
 
+bool bpf_jit_hardware_zext(void)
+{
+	return false;
+}
+
 /*
  * Compile eBPF program "fp"
  */
-- 
2.7.4

