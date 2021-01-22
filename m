Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B61430098F
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 18:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbhAVQyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 11:54:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729386AbhAVQnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 11:43:46 -0500
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37CCC061794;
        Fri, 22 Jan 2021 08:43:09 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4DMlS919QJzQlYs;
        Fri, 22 Jan 2021 17:43:05 +0100 (CET)
Authentication-Results: spamfilter06.heinlein-hosting.de (amavisd-new);
        dkim=pass (2048-bit key) reason="pass (just generated, assumed good)"
        header.d=mailbox.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        content-transfer-encoding:mime-version:message-id:date:date
        :subject:subject:from:from:received; s=mail20150812; t=
        1611333777; bh=Lh2xfkUbit1Y/Lo9qAlrk6Bt3Nw0IkInj3l415cJVDA=; b=l
        l1gvic6Z5Mm26JDD4PeFolt+OHTiOCKNObJRwAQRy+M2OcNIj/3jbUGxetb/P4xR
        U1actvoCYj6kajYCJh+JAqDINbkCOCw7PZa8uGW3zPY4hsA6zu+VVEJ/5DR89VFA
        SiaDAeQ/eI7642d6xK2Bae6wuWNgH8dBWfNMxz4m75EA7s1xMPgKN8HAAEF/N9oL
        ehxDP4ksrmbPhX517eNHxOJJlLFKnD5Xxz4NtcZs1O3hjcimvwzEQcNjpw0CtpF/
        lqOlZoanipoVgq/hiGlEEtg/MxCai+w+/3J7hnU064I88uZDjyK2LPE0XYBUKLcK
        UBFTD7LFPPN5zSf4GbXog==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125]) (amavisd-new, port 10030)
        with ESMTP id KUGvmkt91g7F; Fri, 22 Jan 2021 17:42:57 +0100 (CET)
From:   Loris Reiff <loris.reiff@liblor.ch>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        Loris Reiff <loris.reiff@liblor.ch>
Subject: [PATCH 1/2] bpf: cgroup: Fix optlen WARN_ON_ONCE toctou
Date:   Fri, 22 Jan 2021 17:42:31 +0100
Message-Id: <20210122164232.61770-1-loris.reiff@liblor.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 1.80 / 15.00 / 15.00
X-Rspamd-Queue-Id: C547C186B
X-Rspamd-UID: 3024cb
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A toctou issue in `__cgroup_bpf_run_filter_getsockopt` can trigger a
WARN_ON_ONCE in a check of `copy_from_user`.
`*optlen` is checked to be non-negative in the individual getsockopt
functions beforehand. Changing `*optlen` in a race to a negative value
will result in a `copy_from_user(ctx.optval, optval, ctx.optlen)` with
`ctx.optlen` being a negative integer.

Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
Signed-off-by: Loris Reiff <loris.reiff@liblor.ch>
---
 kernel/bpf/cgroup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 96555a8a2..6ec8f02f4 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1442,6 +1442,11 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 			goto out;
 		}
 
+		if (ctx.optlen < 0) {
+			ret = -EFAULT;
+			goto out;
+		}
+
 		if (copy_from_user(ctx.optval, optval,
 				   min(ctx.optlen, max_optlen)) != 0) {
 			ret = -EFAULT;
-- 
2.29.2

