Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8188A16814
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 18:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfEGQm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 12:42:28 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33380 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbfEGQm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 12:42:28 -0400
Received: by mail-wm1-f66.google.com with SMTP id s18so6764wmh.0
        for <netdev@vger.kernel.org>; Tue, 07 May 2019 09:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ibbhwKSFu7h0i6Chxa22oQdwwgqTaH3G7w5lqVgNsEY=;
        b=cd5VhGby/NKuAEhK3xO6v4Q1r9lm6oRw53CCiZap5fHlOp+9w8NCPbnfweVB5wrTGD
         FrlsKZBEkwVqNslqPhLYL3VHYGSrNjLJAmk9XhYupu6zXcZehLFUvw2EabrQSGpeABTX
         Gqun7QCRYsui3NsoufBYJ4Bk8jkbJ8m26CONlrNuQ75gijF5wEhYvVrjbdxda3woaWDl
         yqf8/PaMdxak2ofvyc8HQg/NS4lEkGOA8ALcY2lH4Pl+JraPwcaYqqVUcYQkZjoZhkvt
         Edy2qdF+QyrOuMaWRPwr5lh0cfW8sjg6EVJZN9d3d/brP5pHKRq755xKdkT0YpID5ZWg
         ru6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ibbhwKSFu7h0i6Chxa22oQdwwgqTaH3G7w5lqVgNsEY=;
        b=TCaE2AeGk717KqT4ELXU8gddjRo0cwYNESHSUw1IYuBd053gwlW1DJaBBMlT0Sn6lg
         9wk6GknZcmaiRVhca1Qkq1e0lCfxUcHlzqCEbtL+BEI0uVfX4iHglG+Jsfnln/mOr6tx
         yAIASuMeh8lsIVPUzpQKuQd/vaHcSie13eoSe8IrmhIwkFxO5H4SR3X1WvHr/VUYV0Ib
         0gabtp/D0D0WPbOl8GzRECQ4PIGAq4BSulDpSRj0r0piWzHQRGKLrPI6Ys1VMGiH+vs3
         G3JVKu3uXplXDyhAuthIyRBggyLq6BDFu70ZLlJiW49B5s72+VWrQtoPtfRqADmflBOw
         S1jQ==
X-Gm-Message-State: APjAAAVNPGXQqDDMl85cPCibu/KaCE18q0y6QPPd+Eaz+so0jA8vFock
        hRynWXC03RvWcClwdrYch4l0huy20rk=
X-Google-Smtp-Source: APXvYqzBHnK1umI+xXbIAlEUpGLzvcM2Mxiy9IA3EN9LgbXQ1crZ6rseGWq2D74gSwcu8U+bLqJOag==
X-Received: by 2002:a1c:6342:: with SMTP id x63mr21911958wmb.58.1557247345859;
        Tue, 07 May 2019 09:42:25 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id w7sm19034022wmm.16.2019.05.07.09.42.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 07 May 2019 09:42:25 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     oleksandr@natalenko.name, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH bpf] nfp: bpf: fix static check error through tightening shift amount adjustment
Date:   Tue,  7 May 2019 17:41:30 +0100
Message-Id: <1557247291-9686-1-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NFP shift instruction has something special. If shift direction is left
then shift amount of 1 to 31 is specified as 32 minus the amount to shift.

But no need to do this for indirect shift which has shift amount be 0. Even
after we do this subtraction, shift amount 0 will be turned into 32 which
will eventually be encoded the same as 0 because only low 5 bits are
encoded, but shift amount be 32 will fail the FIELD_PREP check done later
on shift mask (0x1f), due to 32 is out of mask range. Such error has been
observed when compiling nfp/bpf/jit.c using gcc 8.3 + O3.

This issue has started when indirect shift support added after which the
incoming shift amount to __emit_shf could be 0, therefore it is at that
time shift amount adjustment inside __emit_shf should have been tightened.

Fixes: 991f5b3651f6 ("nfp: bpf: support logic indirect shifts (BPF_[L|R]SH | BPF_X)")
Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Reported-by: Pablo Cascón <pablo.cascon@netronome.com
Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/bpf/jit.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/bpf/jit.c b/drivers/net/ethernet/netronome/nfp/bpf/jit.c
index f272247..d4bf0e6 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/jit.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/jit.c
@@ -328,7 +328,18 @@ __emit_shf(struct nfp_prog *nfp_prog, u16 dst, enum alu_dst_ab dst_ab,
 		return;
 	}
 
-	if (sc == SHF_SC_L_SHF)
+	/* NFP shift instruction has something special. If shift direction is
+	 * left then shift amount of 1 to 31 is specified as 32 minus the amount
+	 * to shift.
+	 *
+	 * But no need to do this for indirect shift which has shift amount be
+	 * 0. Even after we do this subtraction, shift amount 0 will be turned
+	 * into 32 which will eventually be encoded the same as 0 because only
+	 * low 5 bits are encoded, but shift amount be 32 will fail the
+	 * FIELD_PREP check done later on shift mask (0x1f), due to 32 is out of
+	 * mask range.
+	 */
+	if (sc == SHF_SC_L_SHF && shift)
 		shift = 32 - shift;
 
 	insn = OP_SHF_BASE |
-- 
2.7.4

