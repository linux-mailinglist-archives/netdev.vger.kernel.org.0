Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1DF1095D
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 16:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbfEAOoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 10:44:37 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42885 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727000AbfEAOoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 10:44:25 -0400
Received: by mail-wr1-f67.google.com with SMTP id l2so9174939wrb.9
        for <netdev@vger.kernel.org>; Wed, 01 May 2019 07:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=joNuxe7IewAhULLQxwVh9/tfbzqOYrkKWgT6M7s6hWk=;
        b=QcXKkEk0C4gWttQJGTofhFx0XEn2bA0RK9lob1vQz1K0o6rowmPOzx8uU9n5AWXWir
         wqXGn9O2XYry0oW7U4lHOykGVGsutCBaqjlV/BHs4O2kpc1o1+P8ZbZIlLnFL4NFvI3q
         dW7XOg7VVdxktkcm0Q+dRBJMvtQYiP6f+vte41RS6soeXvQfJ6MIHlTGRR2HP/5/gjPj
         XSzd/zZ8fEIW5AqXlHvMYvy9SI9BbKObVTs4b9ZEG1tGMMEnmrxGaTijEKOPQdgFEPiu
         p4Pw9pVRPBmWOTjFlm3sT9BcouR1TjwFk16pL/2q+LPHEHcEyuYmhlRAWeeutqzVPsii
         bWyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=joNuxe7IewAhULLQxwVh9/tfbzqOYrkKWgT6M7s6hWk=;
        b=sDoaQqfO/X+1CN+jHEv6KtxmZRxNfy29Sy/E9TtUe/dOs4NeXc3h8MZsMJlP2L5V+e
         nDpoMRuezMOyHXwBOu7cMnB4+hyFe8QB7rQs/Yp7f9LDl0++CMI8d3EiM5sFEICnuF8W
         9c1xlD0dj/k1cdeHcFSSW6GvI7t/We1HPDTXvtVvMNcEbruOCxNEWgJPyNEeqFFXnCXP
         mpeYb+zYxiwGlfXzZW3cnYot3k3cagFR2y9poMnjR3HHelDLE0JgggCIrqV5iElQJIMB
         /TvCTPph42Z8NXNPVnS7vFpjOkydfparYfiyIKNRlweFYv1MQ+8l8SmQ+xGeLDtSTj8L
         j5fQ==
X-Gm-Message-State: APjAAAXrznxleBqYXKoXiVVHBhAorpWttvv2Y6Dx/R1Z+7UJsUcK4cmJ
        vqhKBde5apETW4YJegJIoMjDUw==
X-Google-Smtp-Source: APXvYqx8ZLu7wJtWde+/8xzoJIbmHWNWdoJ77LX5n9ZJaPpf0NXW0HRohj8XZPpmyKhK+7LVhTztyw==
X-Received: by 2002:adf:b64e:: with SMTP id i14mr26853964wre.72.1556721863633;
        Wed, 01 May 2019 07:44:23 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id g10sm36164976wrq.2.2019.05.01.07.44.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 01 May 2019 07:44:22 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH v5 bpf-next 13/17] s390: bpf: eliminate zero extension code-gen
Date:   Wed,  1 May 2019 15:43:58 +0100
Message-Id: <1556721842-29836-14-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556721842-29836-1-git-send-email-jiong.wang@netronome.com>
References: <1556721842-29836-1-git-send-email-jiong.wang@netronome.com>
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
index 51dd026..45ee379 100644
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
+	case BPF_ALU | BPF_ZEXT: /* dst = (u32) src + always does zext */
+		/* llgfr %dst,%dst (zero extend to 64 bit) */
+		EMIT4(0xb9160000, b1, b1);
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

