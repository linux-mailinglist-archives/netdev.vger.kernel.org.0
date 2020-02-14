Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 288CE15EB60
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405022AbgBNRUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 12:20:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:36432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391140AbgBNQKi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:10:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCD0E2468C;
        Fri, 14 Feb 2020 16:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696637;
        bh=kxTg842rKPYYI0+Z1PfQ8eFsHAo/dHjWgz+J9Sx9eRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JdWT97oolY/oKZn8bUwGcgdrygYFX5IJSy1/c47rvU2coOyH34vOAArJhv/EzEgAE
         y7fDYbuHSj/dlieOKu1FB7LJkSfOJxxinNpTdQ7otxnUwXaOpnV4VDUPsSrKkc79Gw
         EKDDdipCO5BTSW1zAQwXQI5EHW5xixSeg3iql0s4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Averin <vvs@virtuozzo.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 415/459] bpf: map_seq_next should always increase position index
Date:   Fri, 14 Feb 2020 11:01:05 -0500
Message-Id: <20200214160149.11681-415-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
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
index a70f7209cda3f..218c09ff6a273 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -196,6 +196,7 @@ static void *map_seq_next(struct seq_file *m, void *v, loff_t *pos)
 	void *key = map_iter(m)->key;
 	void *prev_key;
 
+	(*pos)++;
 	if (map_iter(m)->done)
 		return NULL;
 
@@ -208,8 +209,6 @@ static void *map_seq_next(struct seq_file *m, void *v, loff_t *pos)
 		map_iter(m)->done = true;
 		return NULL;
 	}
-
-	++(*pos);
 	return key;
 }
 
-- 
2.20.1

