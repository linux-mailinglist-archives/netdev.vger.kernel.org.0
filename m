Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6F523228E
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgG2QYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbgG2QYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 12:24:02 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F298C061794;
        Wed, 29 Jul 2020 09:24:02 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id s21so19913910ilk.5;
        Wed, 29 Jul 2020 09:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=7mspG0WZtlpayxZAvSRWhUtx2g4C/aKYZtflAJKxjDM=;
        b=BDKgD/rTyQUcgl1kYoXHWOFTkYEjCqGfN5jrA4aQK5VHmnzWchjim4i+FA1ds7nh1K
         yy3BGW5+y+d5ayzxNJiwYgFHlGnduvNyLPhMHgPGgb2oMMXlr73i/GapqLHWCwZV1al6
         ki7u/DlriEtzVN05xCf1VSySXc6saWeTpIC5yMN6ZTfJFU8abk4RlhjZf6Pkw/DKi8bB
         4XVxsqkk5cfcILjmApnMfRtTqlqem6Hg4XOdjnXBu14YEIGNot4Pn66VdnSM1rkvnEGn
         RGiYcHWMo0M9vluVd/MDkGPv2KUx4aRLwx2LO4d97d1Csd9Jnt9TD/HE8pItgxaK2o2I
         y1ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=7mspG0WZtlpayxZAvSRWhUtx2g4C/aKYZtflAJKxjDM=;
        b=iR/ZYqqrNQpiakyQhnDuY+ehi7/IKItVk50KssmvBjp0cndAjXyLGJLw0hzb0imziV
         msk8upU4d1/guMa4Z3IR8xBjzQucwPVf+i2G93ukLiJ4NLZbJBJV+eJiGhzFydD2rX7k
         MxqJcaPhuzBep5yD+lXCpdu5JOERIk/r1QdJZeFm0KKH70xqCWT/HqaUwRe60/HBvtOL
         8U5aMpHWSc1jzr0mIa4sRSXnTFdJjwneaUKV7gbEOkSiaH/UtAssmiYMoF4Ee8MNL1yV
         38ALN5i+PoRkn3+LYQ627+gFzY7Spyx84qq9IiC3Tull1zuCQgmOoqnPh5QjoocO1oPJ
         zY9Q==
X-Gm-Message-State: AOAM532l6cvHNaK1cSro7RQjLh52W8qAxUhzgvSnUOiOQHM7cYys6j9q
        WqLHL+4zfmmT3lvNcvumoI8A3DES
X-Google-Smtp-Source: ABdhPJw39Ny+chYW+mnKIh2DexdzndJqJD1D3dqYWJJStkM7U8gFP12F5EzteZ0izbA1Cd6kGxBkbQ==
X-Received: by 2002:a92:bb4d:: with SMTP id w74mr21647526ili.161.1596039841674;
        Wed, 29 Jul 2020 09:24:01 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id m4sm1397646ilj.70.2020.07.29.09.23.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jul 2020 09:24:01 -0700 (PDT)
Subject: [bpf PATCH v2 4/5] bpf,
 selftests: Add tests for sock_ops load with r9, r8.r7 registers
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, kafai@fb.com, daniel@iogearbox.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Wed, 29 Jul 2020 09:23:50 -0700
Message-ID: <159603983037.4454.12599156913109163942.stgit@john-Precision-5820-Tower>
In-Reply-To: <159603940602.4454.2991262810036844039.stgit@john-Precision-5820-Tower>
References: <159603940602.4454.2991262810036844039.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Loads in sock_ops case when using high registers requires extra logic to
ensure the correct temporary value is used. We need to ensure the temp
register does not use either the src_reg or dst_reg. Lets add an asm
test to force the logic is triggered.

The xlated code is here,

  30: (7b) *(u64 *)(r9 +32) = r7
  31: (61) r7 = *(u32 *)(r9 +28)
  32: (15) if r7 == 0x0 goto pc+2
  33: (79) r7 = *(u64 *)(r9 +0)
  34: (63) *(u32 *)(r7 +916) = r8
  35: (79) r7 = *(u64 *)(r9 +32)

Notice r9 and r8 are not used for temp registers and r7 is chosen.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../testing/selftests/bpf/progs/test_tcpbpf_kern.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
index f8b13682..6420b61 100644
--- a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
@@ -75,6 +75,13 @@ int bpf_testcb(struct bpf_sock_ops *skops)
 		: [skops] "r"(skops)
 		:);
 
+	asm volatile (
+		"r9 = %[skops];\n"
+		"r8 = *(u32 *)(r9 +164);\n"
+		"*(u32 *)(r9 +164) = r8;\n"
+		:: [skops] "r"(skops)
+		: "r9", "r8");
+
 	op = (int) skops->op;
 
 	update_event_map(op);

