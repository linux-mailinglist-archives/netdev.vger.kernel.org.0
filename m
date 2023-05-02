Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9F356F48BA
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 18:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234064AbjEBQ6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 12:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233651AbjEBQ6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 12:58:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6C695;
        Tue,  2 May 2023 09:58:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5796562032;
        Tue,  2 May 2023 16:58:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFFDC433EF;
        Tue,  2 May 2023 16:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683046679;
        bh=U8AxR3Op0UshB19LCMR4iPqap4hs4SAkHoCkhdDAPSM=;
        h=From:To:Cc:Subject:Date:From;
        b=r7SH3CQFycqwpVAg10P3TcRQpv+yhxW0OxmeLWnHll3SxA1Hb0QA8KyRdL0jU8cBX
         QxeJTqDtiN9K0+f1R/BWXQoWNTwXnoaXyGmfSY3AwcuuEmm9WLLjikNj6aH4vf5YMx
         TTKuWZcoCn9vFWVMFl1+2PJA2bwcPEqe/iGkzW3yWeCy8bLKa2M7ypwwBLcJcipLmk
         0H/l3jRdTL5uMS2vLgp5OQI4TK/RxSfSrUN2U8hoDNrjYbCS80uFgPvrq2fNV89EnU
         eMP2yELOkL2TMcJGH65eZs21sXqij10HAIgcMditVraKc+sw4NxHa/QRewm6jML7d6
         o3K3gFsekzHOw==
From:   Will Deacon <will@kernel.org>
To:     bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Krzesimir Nowak <krzesimir@kinvolk.io>,
        Yonghong Song <yhs@fb.com>, Andrey Ignatov <rdna@fb.com>
Subject: [PATCH] bpf: Fix mask generation for 32-bit narrow loads of 64-bit fields
Date:   Tue,  2 May 2023 17:57:54 +0100
Message-Id: <20230502165754.16728-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A narrow load from a 64-bit context field results in a 64-bit load
followed potentially by a 64-bit right-shift and then a bitwise AND
operation to extract the relevant data.

In the case of a 32-bit access, an immediate mask of 0xffffffff is used
to construct a 64-bit BPP_AND operation which then sign-extends the mask
value and effectively acts as a glorified no-op.

Fix the mask generation so that narrow loads always perform a 32-bit AND
operation.

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Krzesimir Nowak <krzesimir@kinvolk.io>
Cc: Yonghong Song <yhs@fb.com>
Cc: Andrey Ignatov <rdna@fb.com>
Fixes: 31fd85816dbe ("bpf: permits narrower load from bpf program context fields")
Signed-off-by: Will Deacon <will@kernel.org>
---

I spotted this while playing around with the JIT on arm64. I can't
figure out why 31fd85816dbe special-cases 8-byte ctx fields in the
first place, so I fear I may be missing something...

 kernel/bpf/verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index fbcf5a4e2fcd..5871aa78d01a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -17033,7 +17033,7 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 					insn_buf[cnt++] = BPF_ALU64_IMM(BPF_RSH,
 									insn->dst_reg,
 									shift);
-				insn_buf[cnt++] = BPF_ALU64_IMM(BPF_AND, insn->dst_reg,
+				insn_buf[cnt++] = BPF_ALU32_IMM(BPF_AND, insn->dst_reg,
 								(1ULL << size * 8) - 1);
 			}
 		}
-- 
2.40.1.495.gc816e09b53d-goog

