Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 179F813F64D
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388807AbgAPTCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:02:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:34548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388757AbgAPRFf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:05:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EE39207FF;
        Thu, 16 Jan 2020 17:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194335;
        bh=oGGrABFoCE66QEGKz/t3ZELCjP6BGSRD8f8dFyHbJzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FtV9ru17zvXYaT2+yBSPgA9J6FVZubqqhapcYJQ/u+2gYC6NFg5VXsDNfWqM8cg8a
         SMVKc6xgPi+PDP5Uj6IZFQFI8UmUzJ8kKrG+HuVoaAe1CdnG4ZprbfXVtDKXIKaAuN
         u+AEt5v8d0jYE5tMU3QB7cwk+PP5LtvdKiQXMPX4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrey Ignatov <rdna@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 280/671] bpf: Add missed newline in verifier verbose log
Date:   Thu, 16 Jan 2020 11:58:38 -0500
Message-Id: <20200116170509.12787-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrey Ignatov <rdna@fb.com>

[ Upstream commit 1fbd20f8b77b366ea4aeb92ade72daa7f36a7e3b ]

check_stack_access() that prints verbose log is used in
adjust_ptr_min_max_vals() that prints its own verbose log and now they
stick together, e.g.:

  variable stack access var_off=(0xfffffffffffffff0; 0x4) off=-16
  size=1R2 stack pointer arithmetic goes out of range, prohibited for
  !root

Add missing newline so that log is more readable:
  variable stack access var_off=(0xfffffffffffffff0; 0x4) off=-16 size=1
  R2 stack pointer arithmetic goes out of range, prohibited for !root

Fixes: f1174f77b50c ("bpf/verifier: rework value tracking")
Signed-off-by: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9e72b2f8c3dd..0952049b5ff1 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1253,7 +1253,7 @@ static int check_stack_access(struct bpf_verifier_env *env,
 		char tn_buf[48];
 
 		tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
-		verbose(env, "variable stack access var_off=%s off=%d size=%d",
+		verbose(env, "variable stack access var_off=%s off=%d size=%d\n",
 			tn_buf, off, size);
 		return -EACCES;
 	}
-- 
2.20.1

