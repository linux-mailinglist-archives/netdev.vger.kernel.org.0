Return-Path: <netdev+bounces-5654-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C820712560
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 13:21:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CAF981C20FCC
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:21:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42F15742EB;
	Fri, 26 May 2023 11:21:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6BF742D9;
	Fri, 26 May 2023 11:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F60DC433EF;
	Fri, 26 May 2023 11:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685100074;
	bh=Mc6kybC+fpWNxrxERzGm8WrYbllfE0lyvj4/M0yt5BU=;
	h=From:To:Cc:Subject:Date:From;
	b=NGWgDQqQj4R4JwJ0pvRCHFComHmA06zEQA9VvkLhLtvU3TPxp21UJuM4VbDsql/8+
	 y2i705ve6zviaQ8L33HTJPbB0COZZM1pcrIe6H18EmzfIS6FupZ/fu+479B44MmlzM
	 kfkQIJVZT7HcarV6K8SP/SDXig9+MgiviUUMy0sNM+TLS6XW1BmWtgxhOuQVqWqL2q
	 Vv70WDo5+6BRhXjxiIbRQJ8k/ZDr1XIyCKanDE2HHuRxd5qn5oZCBjIG8+9mvXnmKW
	 kkFAYxSAmIKFtln4udmFVo1xe5X/cWTgpcwpnUvmB/RO9bfih/fs21UgoGLI7nVK+S
	 dzp1f6wQni7SQ==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: "David S . Miller" <davem@davemloft.net>
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH] net: use umd_cleanup_helper()
Date: Fri, 26 May 2023 14:21:02 +0300
Message-Id: <20230526112104.1044686-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bpfilter_umh_cleanup() is the same function as umd_cleanup_helper().
Drop the redundant function.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/bpfilter.h     |  1 -
 net/bpfilter/bpfilter_kern.c |  2 +-
 net/ipv4/bpfilter/sockopt.c  | 11 +----------
 3 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/include/linux/bpfilter.h b/include/linux/bpfilter.h
index 2ae3c8e1d83c..736ded4905e0 100644
--- a/include/linux/bpfilter.h
+++ b/include/linux/bpfilter.h
@@ -11,7 +11,6 @@ int bpfilter_ip_set_sockopt(struct sock *sk, int optname, sockptr_t optval,
 			    unsigned int optlen);
 int bpfilter_ip_get_sockopt(struct sock *sk, int optname, char __user *optval,
 			    int __user *optlen);
-void bpfilter_umh_cleanup(struct umd_info *info);
 
 struct bpfilter_umh_ops {
 	struct umd_info info;
diff --git a/net/bpfilter/bpfilter_kern.c b/net/bpfilter/bpfilter_kern.c
index 422ec6e7ccff..97e129e3f31c 100644
--- a/net/bpfilter/bpfilter_kern.c
+++ b/net/bpfilter/bpfilter_kern.c
@@ -21,7 +21,7 @@ static void shutdown_umh(void)
 	if (tgid) {
 		kill_pid(tgid, SIGKILL, 1);
 		wait_event(tgid->wait_pidfd, thread_group_exited(tgid));
-		bpfilter_umh_cleanup(info);
+		umd_cleanup_helper(info);
 	}
 }
 
diff --git a/net/ipv4/bpfilter/sockopt.c b/net/ipv4/bpfilter/sockopt.c
index 1b34cb9a7708..193bcc2acccc 100644
--- a/net/ipv4/bpfilter/sockopt.c
+++ b/net/ipv4/bpfilter/sockopt.c
@@ -12,15 +12,6 @@
 struct bpfilter_umh_ops bpfilter_ops;
 EXPORT_SYMBOL_GPL(bpfilter_ops);
 
-void bpfilter_umh_cleanup(struct umd_info *info)
-{
-	fput(info->pipe_to_umh);
-	fput(info->pipe_from_umh);
-	put_pid(info->tgid);
-	info->tgid = NULL;
-}
-EXPORT_SYMBOL_GPL(bpfilter_umh_cleanup);
-
 static int bpfilter_mbox_request(struct sock *sk, int optname, sockptr_t optval,
 				 unsigned int optlen, bool is_set)
 {
@@ -38,7 +29,7 @@ static int bpfilter_mbox_request(struct sock *sk, int optname, sockptr_t optval,
 	}
 	if (bpfilter_ops.info.tgid &&
 	    thread_group_exited(bpfilter_ops.info.tgid))
-		bpfilter_umh_cleanup(&bpfilter_ops.info);
+		umd_cleanup_helper(&bpfilter_ops.info);
 
 	if (!bpfilter_ops.info.tgid) {
 		err = bpfilter_ops.start();
-- 
2.39.2


