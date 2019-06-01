Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFBF931F3A
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 15:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbfFANSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 09:18:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727804AbfFANSc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Jun 2019 09:18:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32EFB255FF;
        Sat,  1 Jun 2019 13:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395111;
        bh=EO/dkPdDUW+fy2N8DW/eKTgmTrgnAEjtpEC/X2yFuUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zxpHU9IGWcZS6hYw/r5ArGK7pkRYSUvdPqYv2Mb63+rUZnzSDajE++yFv7vo6je50
         ycPYnkAJOYn5dFNU46P0JuPJnD2s5HYe/rBJhvWA+3iW9mmIu4UtSkHkk2AluXvswb
         Kg9UA85uCfhsDedZLtLD+dH0atsI678YKY6er1TE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzesimir Nowak <krzesimir@kinvolk.io>,
        Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?q?Iago=20L=C3=B3pez=20Galeiras?= <iago@kinvolk.io>,
        Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 036/186] bpf: fix undefined behavior in narrow load handling
Date:   Sat,  1 Jun 2019 09:14:12 -0400
Message-Id: <20190601131653.24205-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131653.24205-1-sashal@kernel.org>
References: <20190601131653.24205-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Krzesimir Nowak <krzesimir@kinvolk.io>

[ Upstream commit e2f7fc0ac6957cabff4cecf6c721979b571af208 ]

Commit 31fd85816dbe ("bpf: permits narrower load from bpf program
context fields") made the verifier add AND instructions to clear the
unwanted bits with a mask when doing a narrow load. The mask is
computed with

  (1 << size * 8) - 1

where "size" is the size of the narrow load. When doing a 4 byte load
of a an 8 byte field the verifier shifts the literal 1 by 32 places to
the left. This results in an overflow of a signed integer, which is an
undefined behavior. Typically, the computed mask was zero, so the
result of the narrow load ended up being zero too.

Cast the literal to long long to avoid overflows. Note that narrow
load of the 4 byte fields does not have the undefined behavior,
because the load size can only be either 1 or 2 bytes, so shifting 1
by 8 or 16 places will not overflow it. And reading 4 bytes would not
be a narrow load of a 4 bytes field.

Fixes: 31fd85816dbe ("bpf: permits narrower load from bpf program context fields")
Reviewed-by: Alban Crequy <alban@kinvolk.io>
Reviewed-by: Iago López Galeiras <iago@kinvolk.io>
Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
Cc: Yonghong Song <yhs@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 09d5d972c9ff2..950fac024fbb1 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7296,7 +7296,7 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 									insn->dst_reg,
 									shift);
 				insn_buf[cnt++] = BPF_ALU64_IMM(BPF_AND, insn->dst_reg,
-								(1 << size * 8) - 1);
+								(1ULL << size * 8) - 1);
 			}
 		}
 
-- 
2.20.1

