Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFF6A15E104
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404284AbgBNQQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:16:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:47392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392616AbgBNQQd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:16:33 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93C2524676;
        Fri, 14 Feb 2020 16:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696992;
        bh=7P2vlFybEQGvQnGZvdak6Xt5WNMRnhmHfVS2Glgdc78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cESJPItgrGwjm6V0ciDAxEe51wumZdjpHEpSzS8PiFrQRkN6SPV3CXgJJF5/GAYeh
         oYe/tj4iACRngHtA+qOSNBzU2KLbvAHmHashW6Z31bXAJ0Wb+AUl4ILQgJLCz0Nbjp
         G4gYKJ1NmnCEJ7Cr74ADiMKqvZ/yiun7qNVoXYhg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Averin <vvs@virtuozzo.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 226/252] bpf: map_seq_next should always increase position index
Date:   Fri, 14 Feb 2020 11:11:21 -0500
Message-Id: <20200214161147.15842-226-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 90435a7891a2259b0f74c5a1bc5600d0d64cba8f ]

If seq_file .next fuction does not change position index,
read after some lseek can generate an unexpected output.

See also: https://bugzilla.kernel.org/show_bug.cgi?id=206283

v1 -> v2: removed missed increment in end of function

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/eca84fdd-c374-a154-d874-6c7b55fc3bc4@virtuozzo.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index dc9d7ac8228db..c04815bb15cc1 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -198,6 +198,7 @@ static void *map_seq_next(struct seq_file *m, void *v, loff_t *pos)
 	void *key = map_iter(m)->key;
 	void *prev_key;
 
+	(*pos)++;
 	if (map_iter(m)->done)
 		return NULL;
 
@@ -210,8 +211,6 @@ static void *map_seq_next(struct seq_file *m, void *v, loff_t *pos)
 		map_iter(m)->done = true;
 		return NULL;
 	}
-
-	++(*pos);
 	return key;
 }
 
-- 
2.20.1

