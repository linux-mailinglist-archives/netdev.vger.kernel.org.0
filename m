Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E8E3BD300
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235946AbhGFLr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:47:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237242AbhGFLgC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E7B861ED8;
        Tue,  6 Jul 2021 11:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570784;
        bh=5+gQWr/yUf/ad/b9w3djbtGAt44Gg7Xp0cfmZQse++Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nV/i5M/vFzMohMGNJ3ycSjTlgtjpEkQAV22VTTKT+Ji6l9E9o+XmLT9QJ6RlKEyRK
         zOqxXN06molmzF5YVA7HM+TPktN1PCPA5Ozh+n6m/Xaa+O7asimgqQOCdwBIoy/IEv
         gmfh+Dk7jIn/cQ2GjOxF0YFnPaiwajaF21Qk2j3jNez0CCORi2wyecQGGWX2KmOVEp
         7YDMgfumACHsq/S9heKoxcp8PdLBXKVknRTJW8EKRCiu7SqHhUmB8zaZF8a1AzPcDL
         fX0geepjWR0ldHJDDvjplq8B6qmcsZQLxt8r9uxyvqsRVn49/5WTxmIH8r+KT8by0y
         P0VDl1TXXjsvg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Young <sean@mess.org>, Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 64/74] media, bpf: Do not copy more entries than user space requested
Date:   Tue,  6 Jul 2021 07:24:52 -0400
Message-Id: <20210706112502.2064236-64-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
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
index 0a0ce620e4a2..d5f839fdcde7 100644
--- a/drivers/media/rc/bpf-lirc.c
+++ b/drivers/media/rc/bpf-lirc.c
@@ -329,7 +329,8 @@ int lirc_prog_query(const union bpf_attr *attr, union bpf_attr __user *uattr)
 	}
 
 	if (attr->query.prog_cnt != 0 && prog_ids && cnt)
-		ret = bpf_prog_array_copy_to_user(progs, prog_ids, cnt);
+		ret = bpf_prog_array_copy_to_user(progs, prog_ids,
+						  attr->query.prog_cnt);
 
 unlock:
 	mutex_unlock(&ir_raw_handler_lock);
-- 
2.30.2

