Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B29B217062C
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 18:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgBZRfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 12:35:15 -0500
Received: from sym2.noone.org ([178.63.92.236]:53262 "EHLO sym2.noone.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbgBZRfO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 12:35:14 -0500
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Feb 2020 12:35:14 EST
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 48SN8x1tdRzvjc1; Wed, 26 Feb 2020 18:29:53 +0100 (CET)
From:   Tobias Klauser <tklauser@distanz.ch>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Kirill Tkhai <ktkhai@virtuozzo.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] unix: define and set show_fdinfo only if procfs is enabled
Date:   Wed, 26 Feb 2020 18:29:53 +0100
Message-Id: <20200226172953.16471-1-tklauser@distanz.ch>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follow the pattern used with other *_show_fdinfo functions and only
define unix_show_fdinfo and set it in proto_ops if CONFIG_PROCFS
is set.

Fixes: 3c32da19a858 ("unix: Show number of pending scm files of receive queue in fdinfo")
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 net/unix/af_unix.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 62c12cb5763e..aa6e2530e1ec 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -682,6 +682,7 @@ static int unix_set_peek_off(struct sock *sk, int val)
 	return 0;
 }
 
+#ifdef CONFIG_PROCFS
 static void unix_show_fdinfo(struct seq_file *m, struct socket *sock)
 {
 	struct sock *sk = sock->sk;
@@ -692,6 +693,9 @@ static void unix_show_fdinfo(struct seq_file *m, struct socket *sock)
 		seq_printf(m, "scm_fds: %u\n", READ_ONCE(u->scm_stat.nr_fds));
 	}
 }
+#else
+#define unix_show_fdinfo NULL
+#endif
 
 static const struct proto_ops unix_stream_ops = {
 	.family =	PF_UNIX,
-- 
2.25.0

