Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E97A3BCE77
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233723AbhGFL0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:26:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232968AbhGFLWT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:22:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEB3461CCF;
        Tue,  6 Jul 2021 11:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570272;
        bh=9oZV2sweLG7QNjxJq5lidgr3AufUJfafWyGDoLTwjao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQqPS8W+Jd7nHe7k1BuMziAnV5Ys9SxcLxb/1XmZIRqDEvUZvcLzlgUxaHTsggrux
         DDOXUIuDWv0jrNIWhirDfFSfPo58HDfRytzceZylLy3F/gUnj9dafm5qNoZnMgQ5gb
         2+pnrqscWtIZvHkZjhStySkhNLdEUTxlo1Fws4suCKuFXBDv6pQnVX/cKHqy929+dy
         1osbaf6KPBoVKYm7VYzVzHNCbJRqWzxT65PHZKT9Ciax3Jrauqmlp/ZOEMNF0WqfkD
         GEm0U81vwTE7MTt8Xv88WCnY3AnmJPJPiUKZT0zy+11YW9nNbquvTIoLCmxukCx5Hx
         caM7U1jUdxJYg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Young <sean@mess.org>, Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 166/189] media, bpf: Do not copy more entries than user space requested
Date:   Tue,  6 Jul 2021 07:13:46 -0400
Message-Id: <20210706111409.2058071-166-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Young <sean@mess.org>

[ Upstream commit 647d446d66e493d23ca1047fa8492b0269674530 ]

The syscall bpf(BPF_PROG_QUERY, &attr) should use the prog_cnt field to
see how many entries user space provided and return ENOSPC if there are
more programs than that. Before this patch, this is not checked and
ENOSPC is never returned.

Note that one lirc device is limited to 64 bpf programs, and user space
I'm aware of -- ir-keytable -- always gives enough space for 64 entries
already. However, we should not copy program ids than are requested.

Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20210623213754.632-1-sean@mess.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/bpf-lirc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/bpf-lirc.c b/drivers/media/rc/bpf-lirc.c
index 3fe3edd80876..afae0afe3f81 100644
--- a/drivers/media/rc/bpf-lirc.c
+++ b/drivers/media/rc/bpf-lirc.c
@@ -326,7 +326,8 @@ int lirc_prog_query(const union bpf_attr *attr, union bpf_attr __user *uattr)
 	}
 
 	if (attr->query.prog_cnt != 0 && prog_ids && cnt)
-		ret = bpf_prog_array_copy_to_user(progs, prog_ids, cnt);
+		ret = bpf_prog_array_copy_to_user(progs, prog_ids,
+						  attr->query.prog_cnt);
 
 unlock:
 	mutex_unlock(&ir_raw_handler_lock);
-- 
2.30.2

