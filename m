Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE2B212BC3
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 12:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbfECKn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 06:43:58 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35734 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727555AbfECKn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 06:43:57 -0400
Received: by mail-wr1-f67.google.com with SMTP id h15so1552558wrb.2
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 03:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HU+XJURX+8gtKclVt6Ec6skvPc1Pkhc0cIYSbM/6vbA=;
        b=fRdx0czfVcJxvB2gIvOCStJVxS67PoTg91xuQlYyBckvBX18vpyGBwBZ3Q2Actzft9
         ChopHPQyueqV/t4hNsQk/6+rRHngHXxTl5xTxj8LvXAJx2fWZHy4+lOLIRFWNKdoVuE+
         +2TfnRK+TBJFU38KEsHsBVdbNWQBAko3MAHyvtHXNxqoqOMxyiYw6vuCIcetSQFsmR+b
         bP9sJ64UbNcLjsqcsvGo4DjLQuze6X29kVFs36eEl3TlDWN8QSbOmwuCIUt/FDrD9hVV
         7hTC7ndWNvtticzqMgJYRb/HGA7glFeLtrHD6wBaKO+0IMUoHxrmdR53k/HN0YCximWm
         176A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HU+XJURX+8gtKclVt6Ec6skvPc1Pkhc0cIYSbM/6vbA=;
        b=EhNAKWTTKSih9J8h/B4Wruq5SkV7EgkzdwIedWI8RJa8egrgrbSJsE5IjWrWj/3w8x
         LnBlSEXuZUSnxntO8pIvXrbqt+tyQ/2147LTKCRq6fOVvl6qeC98FpFM+jkcZAQueLht
         nAWU498t9qL3TQE1lG5fcPHl0VEFUbRFJPv6qFY0e1h2hxYhdnRv/XwWa4gkIGsSsl9B
         uDuIpk9znKWgqFNwiVnogLKxrg5ArXBXT2dw3c2nvoTT0/BrOT2mTXM5VmV1TsSCT6GC
         UM1Rloo8vMYJqC7iLNP7To3cQLMHYiQ1pqSUQiqE4GorvHQtTQFypKPW0+UrYCYg1Yax
         oE9A==
X-Gm-Message-State: APjAAAVIfl+mnjlWVxP9IblOHfnNIeyIpO6DGaTeCubXJ3UyKYbAXD41
        hPVrZh9/OdCGNWy0xZXRD/+sQQ==
X-Google-Smtp-Source: APXvYqwBxZloFdoUpSfEvnOWBCiaBQk2oLSm0bHBCEIEU9v7oS+ou3mgMDolY+DiyFQwhEJ0QnWiuQ==
X-Received: by 2002:a5d:548d:: with SMTP id h13mr6704471wrv.218.1556880236018;
        Fri, 03 May 2019 03:43:56 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id r29sm1716999wra.56.2019.05.03.03.43.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 03 May 2019 03:43:55 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>
Subject: [PATCH v6 bpf-next 12/17] powerpc: bpf: eliminate zero extension code-gen
Date:   Fri,  3 May 2019 11:42:39 +0100
Message-Id: <1556880164-10689-13-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com>
References: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com>
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
index 21a1dcd..9fef73dc 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -557,9 +557,15 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
 				goto bpf_alu32_trunc;
 			break;
 
+		/*
+		 * ZEXT
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

