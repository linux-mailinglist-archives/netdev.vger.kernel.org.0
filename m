Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5440A13E448
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389157AbgAPRHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:07:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:39006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389109AbgAPRHV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:07:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44BF921D56;
        Thu, 16 Jan 2020 17:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194440;
        bh=P6tLADLspSSeMaFKOgqI3Hqx8n+Ij3phNyn87HCQQao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2YRz/gR7h2547YagzxoOavDCvZrB9jcY9L/uK8YIYVF/mYR56ENf9yrRet1EQUwlq
         liyy+9sf1VOIEp70+nfOVsJWXbx23DqcmnNPn249eZDAtvY6RgA7ccTY2Xpo+swcsv
         4UBV8DTt/d1+YGCi5li2XqAZgONoxBt6ywrkPIfg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiong Wang <jiong.wang@netronome.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, oss-drivers@netronome.com
Subject: [PATCH AUTOSEL 4.19 353/671] nfp: bpf: fix static check error through tightening shift amount adjustment
Date:   Thu, 16 Jan 2020 11:59:51 -0500
Message-Id: <20200116170509.12787-90-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiong Wang <jiong.wang@netronome.com>

[ Upstream commit 69e168ebdcfcb87ce7252d4857d570f99996fa27 ]

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
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/bpf/jit.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/bpf/jit.c b/drivers/net/ethernet/netronome/nfp/bpf/jit.c
index 4e18d95e548f..c3ce0fb47a0f 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/jit.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/jit.c
@@ -326,7 +326,18 @@ __emit_shf(struct nfp_prog *nfp_prog, u16 dst, enum alu_dst_ab dst_ab,
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
2.20.1

