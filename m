Return-Path: <netdev+bounces-5466-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E623071151A
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:46:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C7521C20F46
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:46:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9117723D7A;
	Thu, 25 May 2023 18:46:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B529C23D44
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C48FC43445;
	Thu, 25 May 2023 18:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685040376;
	bh=R2szygw8FMPBznQfFFea6pkYnXE8rPymtXIxPAxltKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O8kJ7J+as+sU3srh/Oqf/Rqz9BfI2T8gLuAgLeIGl6BNTigGmHDrjv3a1gOgHce16
	 2/E9bk+9FoQkuJYYsnW+nJ+4eRZ9Gkg55GsEkxXXLt+r8V6vgwbqciglsdjHcVCFNj
	 YpogpyKCy3k3W+68znVAZrhnPwhYz3uan1s07rj4T9uhi2dpG3+36zibKBnxcHY2QF
	 erK+1n8iZjTRePXILEBk47G8jHjPiuV0ZV8T6FJgg6EEsurH2s5j5mo3CePf7AnJHO
	 Goy4NuKnzJtcOp6in5AA9T/l582MeZaMyd5bp8hA7O9UdYjZGqO0KZfF70Q6aNaYXq
	 S9uuYIbvKFdKw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 19/20] atm: hide unused procfs functions
Date: Thu, 25 May 2023 14:45:15 -0400
Message-Id: <20230525184520.2004878-19-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230525184520.2004878-1-sashal@kernel.org>
References: <20230525184520.2004878-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit fb1b7be9b16c1f4626969ba4e95a97da2a452b41 ]

When CONFIG_PROC_FS is disabled, the function declarations for some
procfs functions are hidden, but the definitions are still build,
as shown by this compiler warning:

net/atm/resources.c:403:7: error: no previous prototype for 'atm_dev_seq_start' [-Werror=missing-prototypes]
net/atm/resources.c:409:6: error: no previous prototype for 'atm_dev_seq_stop' [-Werror=missing-prototypes]
net/atm/resources.c:414:7: error: no previous prototype for 'atm_dev_seq_next' [-Werror=missing-prototypes]

Add another #ifdef to leave these out of the build.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20230516194625.549249-2-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/atm/resources.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/atm/resources.c b/net/atm/resources.c
index bada395ecdb18..9389080224f87 100644
--- a/net/atm/resources.c
+++ b/net/atm/resources.c
@@ -447,6 +447,7 @@ int atm_dev_ioctl(unsigned int cmd, void __user *arg, int compat)
 	return error;
 }
 
+#ifdef CONFIG_PROC_FS
 void *atm_dev_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	mutex_lock(&atm_dev_mutex);
@@ -462,3 +463,4 @@ void *atm_dev_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	return seq_list_next(v, &atm_devs, pos);
 }
+#endif
-- 
2.39.2


