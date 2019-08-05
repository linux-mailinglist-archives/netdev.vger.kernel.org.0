Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5B3826E5
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 23:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730969AbfHEV32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 17:29:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730827AbfHEV3N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 17:29:13 -0400
Received: from localhost (c-67-180-165-146.hsd1.ca.comcast.net [67.180.165.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 940BA216F4;
        Mon,  5 Aug 2019 21:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565040552;
        bh=u+3SYBPVgv/FEIxWu9RLECxDzTwrB/RGyZBZnMDQAec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jERS4ABosOx4Nh0Qu2Lfi1dqigzT8zM+tMPMVq2zw4+f7Z+9O1FXkt6rXMe23xDL+
         v+gizQCi+rDkwwvX6At/Am3eneEnSl9CoSiQfC37IPtAPtSPbDVW0kAaUT4b9ZNCq8
         N/hamxJdUghTGHeiSGCv1/60I3uA4e6UKmMySj1g=
From:   Andy Lutomirski <luto@kernel.org>
To:     LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Song Liu <songliubraving@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>
Subject: [WIP 4/4] bpf: Allow creating all program types without privilege
Date:   Mon,  5 Aug 2019 14:29:05 -0700
Message-Id: <9e77ae06243555a96a3fd5e854f61d24823110c9.1565040372.git.luto@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1565040372.git.luto@kernel.org>
References: <cover.1565040372.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This doesn't let you *run* the programs except in test mode, so it should
be safe.  Famous last words.

This assumes that the check-privilege-to-call-privileged-functions
patch actually catches all the cases and that there's nothing else
that should need privilege lurking in the type-specific verifiers.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 kernel/bpf/syscall.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 23f8f89d2a86..730afa2be786 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1649,8 +1649,7 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 	    attr->insn_cnt > (capable(CAP_SYS_ADMIN) ? BPF_COMPLEXITY_LIMIT_INSNS : BPF_MAXINSNS))
 		return -E2BIG;
 	if (type != BPF_PROG_TYPE_SOCKET_FILTER &&
-	    type != BPF_PROG_TYPE_CGROUP_SKB &&
-	    !capable(CAP_SYS_ADMIN))
+	    type != BPF_PROG_TYPE_CGROUP_SKB)
 		return -EPERM;
 
 	bpf_prog_load_fixup_attach_type(attr);
-- 
2.21.0

