Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774AA1BFCFA
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 16:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729309AbgD3OJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 10:09:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728175AbgD3Nvp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 09:51:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEFF22137B;
        Thu, 30 Apr 2020 13:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254704;
        bh=VH3MrWqeXNoY1d7dlhcKWGe+53MwSL9WYC83oj3Q7Vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NIRc9vROXwziewuaw2YYCtauBArTxuYe6CcxZbBgWIFKjU/7GkkOfdWPYwh7LPvVk
         OAqRmYAHbAAEZU7u+RBaY3XDM4rEhN0VCVKHZWArvQwZWog8FEoBeI/DdChiW5nug2
         RleAP0CS0i0mmLz3Ytqz0K5ijwcLk42+2gAdfh6A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jann Horn <jannh@google.com>, Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 53/79] bpf: Fix handling of XADD on BTF memory
Date:   Thu, 30 Apr 2020 09:50:17 -0400
Message-Id: <20200430135043.19851-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jann Horn <jannh@google.com>

[ Upstream commit 8ff3571f7e1bf3f293cc5e3dc14f2943f4fa7fcf ]

check_xadd() can cause check_ptr_to_btf_access() to be executed with
atype==BPF_READ and value_regno==-1 (meaning "just check whether the access
is okay, don't tell me what type it will result in").
Handle that case properly and skip writing type information, instead of
indexing into the registers at index -1 and writing into out-of-bounds
memory.

Note that at least at the moment, you can't actually write through a BTF
pointer, so check_xadd() will reject the program after calling
check_ptr_to_btf_access with atype==BPF_WRITE; but that's after the
verifier has already corrupted memory.

This patch assumes that BTF pointers are not available in unprivileged
programs.

Fixes: 9e15db66136a ("bpf: Implement accurate raw_tp context access via BTF")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200417000007.10734-2-jannh@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e4357a301fb8f..1381913cb10ba 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2885,7 +2885,7 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 	if (ret < 0)
 		return ret;
 
-	if (atype == BPF_READ) {
+	if (atype == BPF_READ && value_regno >= 0) {
 		if (ret == SCALAR_VALUE) {
 			mark_reg_unknown(env, regs, value_regno);
 			return 0;
-- 
2.20.1

