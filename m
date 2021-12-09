Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E5046E945
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 14:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238088AbhLINpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 08:45:31 -0500
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:36020
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236160AbhLINpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 08:45:31 -0500
Received: from localhost.localdomain (1.general.cascardo.us.vpn [10.172.70.58])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id E80E23F201;
        Thu,  9 Dec 2021 13:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639057316;
        bh=i1jP1+ZaX/5WXknNixW4Y4I1is+B5h6in/9wvfOdRQo=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=V7vWy+F2zXBBnNxh6uTpcY6r4cGFApJ/cpdVpWgScW9fLOXlz6la6L5LNFnaZQuFN
         ORhDxrFegXTnK/YbKxS7869/xCzx8ii8HZTngKrZTVNGRtbT6LyIqRkHm/8v26zsLk
         xwuP1Qc5MJGdoJM8qyNlAVZKu4pqjLb6qgHkg7s7AYXX5IdEwDsOOPXHD/cqvbQl6n
         Tp3paVMN+24hRUBFtSaLKf0ObHk3Osa9qau6Jw1QdzMLxlGxYlXe2SKoq0ryj8cqwi
         YkwkCk633fB9/b11IiUPVXlyBLbibA9l2zuxbCwIVrxCeGZxERHiZuSj01Slb9Na5B
         3xveGPw0vKY2A==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH] bpf: return EOPNOTSUPP when JIT is needed and not possible
Date:   Thu,  9 Dec 2021 10:40:38 -0300
Message-Id: <20211209134038.41388-1-cascardo@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a CBPF program is JITed and CONFIG_BPF_JIT_ALWAYS_ON is enabled, and
the JIT fails, it would return ENOTSUPP, which is not a valid userspace
error code.  Instead, EOPNOTSUPP should be returned.

Fixes: 290af86629b2 ("bpf: introduce BPF_JIT_ALWAYS_ON config")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 kernel/bpf/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index de3e5bc6781f..5c89bae0d6f9 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1931,7 +1931,7 @@ struct bpf_prog *bpf_prog_select_runtime(struct bpf_prog *fp, int *err)
 		fp = bpf_int_jit_compile(fp);
 		bpf_prog_jit_attempt_done(fp);
 		if (!fp->jited && jit_needed) {
-			*err = -ENOTSUPP;
+			*err = -EOPNOTSUPP;
 			return fp;
 		}
 	} else {
-- 
2.32.0

