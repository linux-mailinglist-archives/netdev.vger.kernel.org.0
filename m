Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9C839A733
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbhFCRKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:10:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231783AbhFCRKV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:10:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E61D4613F6;
        Thu,  3 Jun 2021 17:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740116;
        bh=P2NiAcDDakW4b0/dW1SMWHEB1xRgaqQX6RaVY4jIeQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KbfDNx3efZpNMXFSgpCYdKavCkmj7zxQqun4s6ffOToqbicYFpPWfJoLsXN4JCb15
         aCwn3nKbwOe3ICCN3FKeIqQlyhcq/wNhyFCELzWJXGFsTK0v9cecW6E56WF1F1xHyn
         frqDinJyQicWNCgIb9utB7Vf+Dc1h63mH0VclVXVkIk7VW38z5md4lIACAqpAj6gCz
         GjFTIFS8IBhpLRp0rWkRBtWZgnxrQ0EgVe/wisjpDBTN2iFzXYLe7ZiCjJoWiYH+uV
         r/EjbbPMMSbngwkXcChZrQHMgYB+PM/Y5hYvFBom5qSZ71VsoIaoARzNnfbc66i7a/
         Gw0YVU9Zpc/4A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 05/39] bpf: Forbid trampoline attach for functions with variable arguments
Date:   Thu,  3 Jun 2021 13:07:55 -0400
Message-Id: <20210603170829.3168708-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170829.3168708-1-sashal@kernel.org>
References: <20210603170829.3168708-1-sashal@kernel.org>
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
index ed7d02e8bc93..aaf2fbaa0cc7 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4960,6 +4960,12 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
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
@@ -4967,6 +4973,12 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
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

