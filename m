Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B167D300916
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 17:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729659AbhAVQy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 11:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729390AbhAVQnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 11:43:46 -0500
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3D6C061797;
        Fri, 22 Jan 2021 08:43:09 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4DMlSB6qB8zQlYw;
        Fri, 22 Jan 2021 17:43:06 +0100 (CET)
Authentication-Results: gerste.heinlein-support.de (amavisd-new);
        dkim=pass (2048-bit key) reason="pass (just generated, assumed good)"
        header.d=mailbox.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        content-transfer-encoding:mime-version:references:in-reply-to
        :message-id:date:date:subject:subject:from:from:received; s=
        mail20150812; t=1611333783; bh=EXY5UBekWmdLcrCcU6mcp7T2dzDQIdcDp
        LiEPkUlz70=; b=tS/5HHjEMv9zxzMEvWCn4JcH1ftjmJL+vAZNfkrBkP3DhjYGt
        Oj7S8pKnGBt6I6l8GAcKc3txaW/vhylwDnSYvUYHQjxFkIfgK1+gOvrgPAJZBtK5
        i4rRBbXh2I5PpAQ6a8mU4Moc1AsMBgwAh0DfniazS7tgeQJzxKlUy18Bj5WEY9GP
        8WiCcJJst3Zwkis5esmfbYJ61QbfaShuyTu/VKYr9GhZYe+crSCSIZe9Lh1e8Q6c
        664/metpOM9xksdq2Whwp5rjHBsnxhrNUSqNiCdRsFDzR3q3jdMpVKqqocYH+U7Z
        gYEDFb5nVUDXqSfo9w/pD3r43/AF3gZtMOkXQ==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id KqCf4o-Nc0xX; Fri, 22 Jan 2021 17:43:03 +0100 (CET)
From:   Loris Reiff <loris.reiff@liblor.ch>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        Loris Reiff <loris.reiff@liblor.ch>
Subject: [PATCH 2/2] bpf: cgroup: Fix problematic bounds check
Date:   Fri, 22 Jan 2021 17:42:32 +0100
Message-Id: <20210122164232.61770-2-loris.reiff@liblor.ch>
In-Reply-To: <20210122164232.61770-1-loris.reiff@liblor.ch>
References: <20210122164232.61770-1-loris.reiff@liblor.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 1.80 / 15.00 / 15.00
X-Rspamd-Queue-Id: DFC9117BA
X-Rspamd-UID: 65af45
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since ctx.optlen is signed, a larger value than max_value could be
passed, as it is later on used as unsigned, which causes a WARN_ON_ONCE
in the copy_to_user.

Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
Signed-off-by: Loris Reiff <loris.reiff@liblor.ch>
---
 kernel/bpf/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 6ec8f02f4..6aa9e10c6 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1464,7 +1464,7 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 		goto out;
 	}
 
-	if (ctx.optlen > max_optlen) {
+	if (ctx.optlen > max_optlen || ctx.optlen < 0) {
 		ret = -EFAULT;
 		goto out;
 	}
-- 
2.29.2

