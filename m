Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70BAFCE0ED
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 13:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbfJGLwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 07:52:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46688 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727467AbfJGLwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 07:52:47 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iHRZA-0008VF-4y; Mon, 07 Oct 2019 11:52:40 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        oss-drivers@netronome.com
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] nfp: bpf: make array exp_mask static, makes object smaller
Date:   Mon,  7 Oct 2019 12:52:39 +0100
Message-Id: <20191007115239.1742-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the array exp_mask on the stack but instead make it
static. Makes the object code smaller by 224 bytes.

Before:
   text	   data	    bss	    dec	    hex	filename
  77832	   2290	      0	  80122	  138fa	ethernet/netronome/nfp/bpf/jit.o

After:
   text	   data	    bss	    dec	    hex	filename
  77544	   2354	      0	  79898	  1381a	ethernet/netronome/nfp/bpf/jit.o

(gcc version 9.2.1, amd64)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/netronome/nfp/bpf/jit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/bpf/jit.c b/drivers/net/ethernet/netronome/nfp/bpf/jit.c
index 5afcb3c4c2ef..c80bb83c8ac9 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/jit.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/jit.c
@@ -3952,7 +3952,7 @@ static void nfp_bpf_opt_neg_add_sub(struct nfp_prog *nfp_prog)
 static void nfp_bpf_opt_ld_mask(struct nfp_prog *nfp_prog)
 {
 	struct nfp_insn_meta *meta1, *meta2;
-	const s32 exp_mask[] = {
+	static const s32 exp_mask[] = {
 		[BPF_B] = 0x000000ffU,
 		[BPF_H] = 0x0000ffffU,
 		[BPF_W] = 0xffffffffU,
-- 
2.20.1

