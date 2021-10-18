Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924DC4327B2
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 21:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbhJRTde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 15:33:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232659AbhJRTd3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 15:33:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C68BB6128B;
        Mon, 18 Oct 2021 19:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634585477;
        bh=kL+xvgtJucVN4cFRoEIBRAEL92uNVUroLxqy6YYCqFE=;
        h=From:To:Cc:Subject:Date:From;
        b=Zwf9r/8UZz6gNf2WZx2ZtEDDZxD6hhqa7tf+X5YVgqhSzDKboXg+OEL0sBsjy7HZh
         YxCy1HQaFDKXUEHEr5JNNIoZOrLjScbSXvdWkjiX7EHZzc2M7Wz741RgL4n6axrXT3
         RiyxwIETKFqOdBCqcoqHk2tPVYrSCYPZz4BHXL2LMf+Op5stL7WhmJxP0k8sVvkukh
         zoD6kI6BzDp2XNgim1i3Y5x68gj6KVRMdi6Vt4sceyxqcIZP8xatc8bwHuusX1xLtJ
         W5pLwJI5C1pQWBb+ymmst3p2WDsEyOMe/llZdbWY9SESUoJCYxIu55D4VPTwUXUMW8
         xJWZyMn/m8qXA==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        oss-drivers@corigine.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] nfp: bpf: Fix bitwise vs. logical OR warning
Date:   Mon, 18 Oct 2021 12:31:01 -0700
Message-Id: <20211018193101.2340261-1-nathan@kernel.org>
X-Mailer: git-send-email 2.33.1.637.gf443b226ca
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A new warning in clang points out two places in this driver where
boolean expressions are being used with a bitwise OR instead of a
logical one:

drivers/net/ethernet/netronome/nfp/nfp_asm.c:199:20: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
        reg->src_lmextn = swreg_lmextn(lreg) | swreg_lmextn(rreg);
                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                             ||
drivers/net/ethernet/netronome/nfp/nfp_asm.c:199:20: note: cast one or both operands to int to silence this warning
drivers/net/ethernet/netronome/nfp/nfp_asm.c:280:20: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
        reg->src_lmextn = swreg_lmextn(lreg) | swreg_lmextn(rreg);
                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                             ||
drivers/net/ethernet/netronome/nfp/nfp_asm.c:280:20: note: cast one or both operands to int to silence this warning
2 errors generated.

The motivation for the warning is that logical operations short circuit
while bitwise operations do not. In this case, it does not seem like
short circuiting is harmful so implement the suggested fix of changing
to a logical operation to fix the warning.

Link: https://github.com/ClangBuiltLinux/linux/issues/1479
Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_asm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_asm.c b/drivers/net/ethernet/netronome/nfp/nfp_asm.c
index 2643ea5948f4..154399c5453f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_asm.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_asm.c
@@ -196,7 +196,7 @@ int swreg_to_unrestricted(swreg dst, swreg lreg, swreg rreg,
 	}
 
 	reg->dst_lmextn = swreg_lmextn(dst);
-	reg->src_lmextn = swreg_lmextn(lreg) | swreg_lmextn(rreg);
+	reg->src_lmextn = swreg_lmextn(lreg) || swreg_lmextn(rreg);
 
 	return 0;
 }
@@ -277,7 +277,7 @@ int swreg_to_restricted(swreg dst, swreg lreg, swreg rreg,
 	}
 
 	reg->dst_lmextn = swreg_lmextn(dst);
-	reg->src_lmextn = swreg_lmextn(lreg) | swreg_lmextn(rreg);
+	reg->src_lmextn = swreg_lmextn(lreg) || swreg_lmextn(rreg);
 
 	return 0;
 }

base-commit: 041c61488236a5a84789083e3d9f0a51139b6edf
-- 
2.33.1.637.gf443b226ca

