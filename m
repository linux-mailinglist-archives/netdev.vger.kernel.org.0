Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B090DFD230
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 02:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbfKOBEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 20:04:20 -0500
Received: from www62.your-server.de ([213.133.104.62]:50720 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727168AbfKOBEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 20:04:20 -0500
Received: from 57.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.57] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iVQ26-00080e-NK; Fri, 15 Nov 2019 02:04:18 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH rfc bpf-next 2/8] bpf: add bpf_prog_under_eviction helper
Date:   Fri, 15 Nov 2019 02:03:56 +0100
Message-Id: <0777572d53d1fe4a34384b5211dfcaac1261d035.1573779287.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1573779287.git.daniel@iogearbox.net>
References: <cover.1573779287.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25633/Thu Nov 14 10:50:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a small helper which can be used to check whether we're
currently tearing down a BPF program.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 include/linux/bpf.h  | 1 +
 kernel/bpf/syscall.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 562d9ade2926..0a20618fd8e2 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -774,6 +774,7 @@ struct bpf_prog * __must_check bpf_prog_add(struct bpf_prog *prog, int i);
 void bpf_prog_sub(struct bpf_prog *prog, int i);
 struct bpf_prog * __must_check bpf_prog_inc(struct bpf_prog *prog);
 struct bpf_prog * __must_check bpf_prog_inc_not_zero(struct bpf_prog *prog);
+bool bpf_prog_under_eviction(struct bpf_prog *prog);
 void bpf_prog_put(struct bpf_prog *prog);
 int __bpf_prog_charge(struct user_struct *user, u32 pages);
 void __bpf_prog_uncharge(struct user_struct *user, u32 pages);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index c88c815c2154..2a687cb9b0d2 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1482,6 +1482,11 @@ struct bpf_prog *bpf_prog_inc(struct bpf_prog *prog)
 }
 EXPORT_SYMBOL_GPL(bpf_prog_inc);
 
+bool bpf_prog_under_eviction(struct bpf_prog *prog)
+{
+	return atomic_read(&prog->aux->refcnt) == 0;
+}
+
 /* prog_idr_lock should have been held */
 struct bpf_prog *bpf_prog_inc_not_zero(struct bpf_prog *prog)
 {
-- 
2.21.0

