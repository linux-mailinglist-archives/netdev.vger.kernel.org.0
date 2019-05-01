Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB21F10950
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 16:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfEAOo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 10:44:29 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46786 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbfEAOo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 10:44:26 -0400
Received: by mail-wr1-f67.google.com with SMTP id r7so5089818wrr.13
        for <netdev@vger.kernel.org>; Wed, 01 May 2019 07:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cpJcaWaaRJR9UUNz1Oo6/KygWux0OYpdbhwpNjnS0cg=;
        b=mz+QdhU4webAzko2ZfT3tj6I7SJVN2Bs7Bmo8errz3aK5Mip20LN5jRlbZmVoW6Tbv
         hlieKq90+gt3p/NFeQey64tYsnqiSBafCWj5SRUuklRnUEgg7cGIZ7gaUQnCxf834uXS
         Cww4yIH055e2MkIlSzXOAxKjI0U6/9p5uanznbIHyseITS84yY2yKXP4KdQWQKqAWY6X
         Ey9Bu7lF92P2QChhKY8dGBwCH+TtNtSKWbY3XO7a2lBVadpD9dxO9XBJxhiGCGrHMY8A
         9MFPYXNH2Q0PxmzdvcY9iXi+t7VfyHLRmC9KEIByOBiHu8sVN6Mbdz8vu7Ks9A8XPebH
         O6Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cpJcaWaaRJR9UUNz1Oo6/KygWux0OYpdbhwpNjnS0cg=;
        b=FGDdg1oOoTYdZ1wooXb9l6oe+a3zkrYAIVpq3fT82lIZVb4sWQrayfxnXA23dIpd5T
         vS6RCuym0i4PXIyDg4r5GHUdbwoGJcBYYG0JlBeMd6nUhPO/pnmJjBmD9q8TZhyCH/jA
         mkJ6dcqKO7Pe5mh9wlNpUes6/JXXONW8KEu3c6UJ61g1L6C+NCAQdonYSOchP1aQrdZk
         zOEYUsa5yFrfq+RaAdP/MeBr5cdOrVEKPkvA2f9qDrlo9ySVsFBoGselRiZrMD3rV1+p
         BL/0wBl+EJZ+sg697g427HeYhHDBzrqxEp1CBIJFLFGbv28UdkaHQ1mcPzyJnS+V8pG+
         t74g==
X-Gm-Message-State: APjAAAVjuLrNZ49UOjq3JeqcCodD7nqoKMHS7seok+7DLg/3IO/TseUR
        +Zz7PMHeEWSWnL5AkN0ET4J5OVTeUFw=
X-Google-Smtp-Source: APXvYqyENJXIxXGkZNmGeufy+y7QIvTLEJbnfgqWH4KAdWoZ/qnkvg79bjHSXF8sL9Ip63UdVUKBZQ==
X-Received: by 2002:adf:df85:: with SMTP id z5mr11530155wrl.127.1556721864736;
        Wed, 01 May 2019 07:44:24 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id g10sm36164976wrq.2.2019.05.01.07.44.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 01 May 2019 07:44:24 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH v5 bpf-next 14/17] sparc: bpf: eliminate zero extension code-gen
Date:   Wed,  1 May 2019 15:43:59 +0100
Message-Id: <1556721842-29836-15-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556721842-29836-1-git-send-email-jiong.wang@netronome.com>
References: <1556721842-29836-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 arch/sparc/net/bpf_jit_comp_64.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/sparc/net/bpf_jit_comp_64.c b/arch/sparc/net/bpf_jit_comp_64.c
index 65428e7..8318d3a 100644
--- a/arch/sparc/net/bpf_jit_comp_64.c
+++ b/arch/sparc/net/bpf_jit_comp_64.c
@@ -905,6 +905,10 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 		ctx->saw_frame_pointer = true;
 
 	switch (code) {
+	/* explicit zero extension */
+	case BPF_ALU | BPF_ZEXT:
+		emit_alu_K(SRL, dst, 0, ctx);
+		break;
 	/* dst = src */
 	case BPF_ALU | BPF_MOV | BPF_X:
 		emit_alu3_K(SRL, src, 0, dst, ctx);
@@ -1144,7 +1148,8 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 		break;
 
 	do_alu32_trunc:
-		if (BPF_CLASS(code) == BPF_ALU)
+		if (BPF_CLASS(code) == BPF_ALU &&
+		    !ctx->prog->aux->verifier_zext)
 			emit_alu_K(SRL, dst, 0, ctx);
 		break;
 
@@ -1432,6 +1437,11 @@ static void jit_fill_hole(void *area, unsigned int size)
 		*ptr++ = 0x91d02005; /* ta 5 */
 }
 
+bool bpf_jit_hardware_zext(void)
+{
+	return false;
+}
+
 struct sparc64_jit_data {
 	struct bpf_binary_header *header;
 	u8 *image;
-- 
2.7.4

