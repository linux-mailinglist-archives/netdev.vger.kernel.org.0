Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8A339A6C5
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhFCRJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:09:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230333AbhFCRJ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:09:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 809F2613DE;
        Thu,  3 Jun 2021 17:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740061;
        bh=27kYeqCQHC+7oB//+3h8Rl8uVvRD+9U76fLMbkQRlsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CqTVKze93Vgeq3OA+NL8bli3d2jPLOMNlfv2VC33pBPKxt/QzFdMElrrnPsfZfLtV
         pLbMCmaruE3lYL8skMAgNlwQDfYwOo4bwf4dCILIJ6RcY7RggrFfByp2FJnRzyc7fU
         a9wlCD1KGEwN6/GQVNkjIWuYuvXNE9cDjZQIupnpFMEqPQnyYYM8zSz/8DphLm5lWP
         V7fX31HJDsPA+pSPDUboGHPk+LU9Xn68dYc+bUZG7FogIIjt5fDT6zNp5IJbiuxE2C
         3Z4MIfIOc/dhuLfmIIR5NARxV7QP816+ahECz+EmhEZO2kgCZnQbJKKdO1+mvm6vff
         VUuSeXzmfi/fw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 05/43] bpf: Forbid trampoline attach for functions with variable arguments
Date:   Thu,  3 Jun 2021 13:06:55 -0400
Message-Id: <20210603170734.3168284-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170734.3168284-1-sashal@kernel.org>
References: <20210603170734.3168284-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 31379397dcc364a59ce764fabb131b645c43e340 ]

We can't currently allow to attach functions with variable arguments.
The problem is that we should save all the registers for arguments,
which is probably doable, but if caller uses more than 6 arguments,
we need stack data, which will be wrong, because of the extra stack
frame we do in bpf trampoline, so we could crash.

Also currently there's malformed trampoline code generated for such
functions at the moment as described in:

  https://lore.kernel.org/bpf/20210429212834.82621-1-jolsa@kernel.org/

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210505132529.401047-1-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index b1a76fe046cb..6bd003568fa5 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5126,6 +5126,12 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
 	m->ret_size = ret;
 
 	for (i = 0; i < nargs; i++) {
+		if (i == nargs - 1 && args[i].type == 0) {
+			bpf_log(log,
+				"The function %s with variable args is unsupported.\n",
+				tname);
+			return -EINVAL;
+		}
 		ret = __get_type_size(btf, args[i].type, &t);
 		if (ret < 0) {
 			bpf_log(log,
@@ -5133,6 +5139,12 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
 				tname, i, btf_kind_str[BTF_INFO_KIND(t->info)]);
 			return -EINVAL;
 		}
+		if (ret == 0) {
+			bpf_log(log,
+				"The function %s has malformed void argument.\n",
+				tname);
+			return -EINVAL;
+		}
 		m->arg_size[i] = ret;
 	}
 	m->nr_args = nargs;
-- 
2.30.2

