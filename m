Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB891BFCCE
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 16:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbgD3OI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 10:08:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728317AbgD3NwL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 09:52:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 141B021775;
        Thu, 30 Apr 2020 13:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254730;
        bh=gBtNDQXdaXS05+OQzYYBgspwu9dzhN1yFmBlNEUpzzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kICHDVOm8rbibokC1jHPF4nxF+L77tND3HsJtk2bTpqTw/sVXeOgoe9T+RUK/eqlh
         3R+yu505R2WkX16gVvySSW7OiEJwIXyAsxaWz+FnvUgAyoO6UwxevBYFginXAKEmGB
         kSxe23qEF4kOr8nS79rBVqOoTBwwFYxP2ihAwzG4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 77/79] bpf: Propagate expected_attach_type when verifying freplace programs
Date:   Thu, 30 Apr 2020 09:50:41 -0400
Message-Id: <20200430135043.19851-77-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 03f87c0b45b177ba5f6b4a9bbe9f95e4aba31026 ]

For some program types, the verifier relies on the expected_attach_type of
the program being verified in the verification process. However, for
freplace programs, the attach type was not propagated along with the
verifier ops, so the expected_attach_type would always be zero for freplace
programs.

This in turn caused the verifier to sometimes make the wrong call for
freplace programs. For all existing uses of expected_attach_type for this
purpose, the result of this was only false negatives (i.e., freplace
functions would be rejected by the verifier even though they were valid
programs for the target they were replacing). However, should a false
positive be introduced, this can lead to out-of-bounds accesses and/or
crashes.

The fix introduced in this patch is to propagate the expected_attach_type
to the freplace program during verification, and reset it after that is
done.

Fixes: be8704ff07d2 ("bpf: Introduce dynamic program extensions")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/158773526726.293902.13257293296560360508.stgit@toke.dk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1381913cb10ba..1c53ccbd5b5d6 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9892,6 +9892,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 				return -EINVAL;
 			}
 			env->ops = bpf_verifier_ops[tgt_prog->type];
+			prog->expected_attach_type = tgt_prog->expected_attach_type;
 		}
 		if (!tgt_prog->jited) {
 			verbose(env, "Can attach to only JITed progs\n");
@@ -10225,6 +10226,13 @@ err_release_maps:
 		 * them now. Otherwise free_used_maps() will release them.
 		 */
 		release_maps(env);
+
+	/* extension progs temporarily inherit the attach_type of their targets
+	   for verification purposes, so set it back to zero before returning
+	 */
+	if (env->prog->type == BPF_PROG_TYPE_EXT)
+		env->prog->expected_attach_type = 0;
+
 	*prog = env->prog;
 err_unlock:
 	if (!is_priv)
-- 
2.20.1

