Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389F124FFB6
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 16:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgHXOUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 10:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgHXOUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 10:20:53 -0400
Received: from sym2.noone.org (sym2.noone.org [IPv6:2a01:4f8:120:4161::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D20C061573;
        Mon, 24 Aug 2020 07:20:51 -0700 (PDT)
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 4BZvRg5Lbbzvjc1; Mon, 24 Aug 2020 16:20:47 +0200 (CEST)
From:   Tobias Klauser <tklauser@distanz.ch>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH bpf] bpf, sysctl: let bpf_stats_handler take a kernel pointer buffer
Date:   Mon, 24 Aug 2020 16:20:47 +0200
Message-Id: <20200824142047.22043-1-tklauser@distanz.ch>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 32927393dc1c ("sysctl: pass kernel pointers to ->proc_handler")
changed ctl_table.proc_handler to take a kernel pointer. Adjust the
signature of bpf_stats_handler to match ctl_table.proc_handler which
fixes the following sparse warning:

kernel/sysctl.c:226:49: warning: incorrect type in argument 3 (different address spaces)
kernel/sysctl.c:226:49:    expected void *
kernel/sysctl.c:226:49:    got void [noderef] __user *buffer
kernel/sysctl.c:2640:35: warning: incorrect type in initializer (incompatible argument 3 (different address spaces))
kernel/sysctl.c:2640:35:    expected int ( [usertype] *proc_handler )( ... )
kernel/sysctl.c:2640:35:    got int ( * )( ... )

Fixes: 32927393dc1c ("sysctl: pass kernel pointers to ->proc_handler")
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 kernel/sysctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 287862f91717..09e70ee2332e 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -204,8 +204,7 @@ static int max_extfrag_threshold = 1000;
 
 #if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_SYSCTL)
 static int bpf_stats_handler(struct ctl_table *table, int write,
-			     void __user *buffer, size_t *lenp,
-			     loff_t *ppos)
+			     void *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct static_key *key = (struct static_key *)table->data;
 	static int saved_val;
-- 
2.27.0

