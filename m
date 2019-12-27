Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A35912B928
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 19:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbfL0SDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 13:03:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:60610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728652AbfL0SDW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 13:03:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D7E3218AC;
        Fri, 27 Dec 2019 18:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577469802;
        bh=MTf0aAiPTOiajZujZI+wd/PHq0w7Fnm3cm7lguMSgSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dKZfcH/9/J5+c6U8UBlDcLlXzcY8e6sVt2qby9gGJG/0Vvg6bKJWNuP3df8jw2Kzr
         4duTQjYh0op4PbKbM2ffbiNb9jSyjGwI14WzMK0l18yp0kX0q7KtGsxVuszCb5Xbq4
         prqEvmxptjB4HUhjKJcHb7Ew/Hy+cslqGu+TDGo8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Lobakin <alobakin@dlink.ru>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 49/57] net, sysctl: Fix compiler warning when only cBPF is present
Date:   Fri, 27 Dec 2019 13:02:14 -0500
Message-Id: <20191227180222.7076-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227180222.7076-1-sashal@kernel.org>
References: <20191227180222.7076-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alobakin@dlink.ru>

[ Upstream commit 1148f9adbe71415836a18a36c1b4ece999ab0973 ]

proc_dointvec_minmax_bpf_restricted() has been firstly introduced
in commit 2e4a30983b0f ("bpf: restrict access to core bpf sysctls")
under CONFIG_HAVE_EBPF_JIT. Then, this ifdef has been removed in
ede95a63b5e8 ("bpf: add bpf_jit_limit knob to restrict unpriv
allocations"), because a new sysctl, bpf_jit_limit, made use of it.
Finally, this parameter has become long instead of integer with
fdadd04931c2 ("bpf: fix bpf_jit_limit knob for PAGE_SIZE >= 64K")
and thus, a new proc_dolongvec_minmax_bpf_restricted() has been
added.

With this last change, we got back to that
proc_dointvec_minmax_bpf_restricted() is used only under
CONFIG_HAVE_EBPF_JIT, but the corresponding ifdef has not been
brought back.

So, in configurations like CONFIG_BPF_JIT=y && CONFIG_HAVE_EBPF_JIT=n
since v4.20 we have:

  CC      net/core/sysctl_net_core.o
net/core/sysctl_net_core.c:292:1: warning: ‘proc_dointvec_minmax_bpf_restricted’ defined but not used [-Wunused-function]
  292 | proc_dointvec_minmax_bpf_restricted(struct ctl_table *table, int write,
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Suppress this by guarding it with CONFIG_HAVE_EBPF_JIT again.

Fixes: fdadd04931c2 ("bpf: fix bpf_jit_limit knob for PAGE_SIZE >= 64K")
Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20191218091821.7080-1-alobakin@dlink.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sysctl_net_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 144cd1acd7e3..069e3c4fcc44 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -274,6 +274,7 @@ static int proc_dointvec_minmax_bpf_enable(struct ctl_table *table, int write,
 	return ret;
 }
 
+# ifdef CONFIG_HAVE_EBPF_JIT
 static int
 proc_dointvec_minmax_bpf_restricted(struct ctl_table *table, int write,
 				    void __user *buffer, size_t *lenp,
@@ -284,6 +285,7 @@ proc_dointvec_minmax_bpf_restricted(struct ctl_table *table, int write,
 
 	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 }
+# endif /* CONFIG_HAVE_EBPF_JIT */
 
 static int
 proc_dolongvec_minmax_bpf_restricted(struct ctl_table *table, int write,
-- 
2.20.1

