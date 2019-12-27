Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B55812B9F7
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 19:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbfL0SPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 13:15:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:40064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727902AbfL0SPQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 13:15:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C98E21582;
        Fri, 27 Dec 2019 18:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577470516;
        bh=XyKOjQslPdTHlWPxGpQ+P5WzATKnm4hOAEZiiYEXo9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xa0/YQLL1iHqJKnOL4nMZg9OwLUUMmbYAdf3qF+U+JbcAecjkhoa8NG26wQW71AQy
         T46DP/KWWJE+7jtCR0daALtBl4zHuw6GnBRq+I7gnZl2tRuj1bdnSuFVO9MrNGN519
         IMpBNLBNcdlX/6jrqZk8apLpg+0cIksI7bJdRuxU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Lobakin <alobakin@dlink.ru>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 33/38] net, sysctl: Fix compiler warning when only cBPF is present
Date:   Fri, 27 Dec 2019 13:14:30 -0500
Message-Id: <20191227181435.7644-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227181435.7644-1-sashal@kernel.org>
References: <20191227181435.7644-1-sashal@kernel.org>
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
index a6fc82704f0c..b4318c1b5b96 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -255,6 +255,7 @@ static int proc_dointvec_minmax_bpf_enable(struct ctl_table *table, int write,
 	return ret;
 }
 
+# ifdef CONFIG_HAVE_EBPF_JIT
 static int
 proc_dointvec_minmax_bpf_restricted(struct ctl_table *table, int write,
 				    void __user *buffer, size_t *lenp,
@@ -265,6 +266,7 @@ proc_dointvec_minmax_bpf_restricted(struct ctl_table *table, int write,
 
 	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 }
+# endif /* CONFIG_HAVE_EBPF_JIT */
 
 static int
 proc_dolongvec_minmax_bpf_restricted(struct ctl_table *table, int write,
-- 
2.20.1

