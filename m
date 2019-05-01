Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 321F41094F
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 16:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbfEAOo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 10:44:26 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40158 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbfEAOoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 10:44:23 -0400
Received: by mail-wr1-f68.google.com with SMTP id h4so24826134wre.7
        for <netdev@vger.kernel.org>; Wed, 01 May 2019 07:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lgTpFSyNNSuuA9gXSMlYavP/PQMNAfd6tBhbx53xg9k=;
        b=EiFqgfeT5acF+oM5XLjLRWFLHQH+MlX1bcXe1qtmoC1qIiRJCr36IfQiFGjBBX1NTJ
         4+5e2cGP0MM6tuED5Dl8alCSFm7Yq371KRV0XXw3vDrT9owlmtPjcpHx6aQUXIPko3aF
         ihNxrC3POV3/PdeCHxHlJ759+Gx4we3w+sJAHijth7qkw9qf6+PLIwH9h0Nj85GpYcaU
         +4jGg8grZWlG03s/twteKWNUWsexNqXry/xNykdRk/FkhUjcGAELpPJiZ6QC98/tETd3
         QZdYtsgbtEW5/ZInII1Vx1lJ0bifT1SdxuPE17E/4PuSXnSllj35wdxErVxdF/CHGIbA
         iARA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lgTpFSyNNSuuA9gXSMlYavP/PQMNAfd6tBhbx53xg9k=;
        b=M78oQ8nRJP+DH/orHIH7R4lJzSUs1LTItMSfnejnJ/ta3s7Uwh4gYEQ2RPaK0c+1V0
         wWT2Mta4LjYYgdWkR0fwXrMD99TSSXlFiY40c98+heEtinIfuNhTkG/Pja7bbJUstQIi
         EDrE6AggJX8KEqcOD3n1mlvLKuH/yphc3cP9/fmWJFAejtxhTwq1v1Jp+WJptVY7sscB
         v2wwzuglyL0u/35kQYNfyvXGnVcRBuZ/3fE+PzAjp0vmb//bY0PYNd1PEQjS66VCRVFj
         Sq2eNnFnMGB/xrS4uqJjLjuuhSlnDfUaMI1RobmizS3e79yOMaDTksqu+gYU9V6cafe0
         gwzg==
X-Gm-Message-State: APjAAAXgcAWZMop7YKu2FYl/IJlJHpNHv0WxVyFcHarlkmg0WsUQA8RO
        bkk+VvkISesdrYEUEzeHbKbXZQ==
X-Google-Smtp-Source: APXvYqwJ7J7IoF/x7199HmYneckyAeBAGR9XAcn9+M1xW8u+Mr7HLh+/WNxoKmD0qSsJskUwcYAzGw==
X-Received: by 2002:a5d:54c7:: with SMTP id x7mr1736639wrv.253.1556721862535;
        Wed, 01 May 2019 07:44:22 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id g10sm36164976wrq.2.2019.05.01.07.44.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 01 May 2019 07:44:21 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>
Subject: [PATCH v5 bpf-next 12/17] powerpc: bpf: eliminate zero extension code-gen
Date:   Wed,  1 May 2019 15:43:57 +0100
Message-Id: <1556721842-29836-13-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556721842-29836-1-git-send-email-jiong.wang@netronome.com>
References: <1556721842-29836-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cc: Naveen N. Rao <naveen.n.rao@linux.ibm.com>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 arch/powerpc/net/bpf_jit_comp64.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index 21a1dcd..2266c7c 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -557,9 +557,15 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
 				goto bpf_alu32_trunc;
 			break;
 
+		/*
+		 * ZEXT, does low 32-bit zero extension unconditionally
+		 */
+		case BPF_ALU | BPF_ZEXT:
+			PPC_RLWINM(dst_reg, dst_reg, 0, 0, 31);
+			break;
 bpf_alu32_trunc:
 		/* Truncate to 32-bits */
-		if (BPF_CLASS(code) == BPF_ALU)
+		if (BPF_CLASS(code) == BPF_ALU && !fp->aux->verifier_zext)
 			PPC_RLWINM(dst_reg, dst_reg, 0, 0, 31);
 		break;
 
@@ -1046,6 +1052,11 @@ struct powerpc64_jit_data {
 	struct codegen_context ctx;
 };
 
+bool bpf_jit_hardware_zext(void)
+{
+	return false;
+}
+
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 {
 	u32 proglen;
-- 
2.7.4

