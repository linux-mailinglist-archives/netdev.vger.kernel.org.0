Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 303071718CA
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 14:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729202AbgB0Neq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 08:34:46 -0500
Received: from sym2.noone.org ([178.63.92.236]:49774 "EHLO sym2.noone.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729076AbgB0Neq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 08:34:46 -0500
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 48Stv73m9xzvjcZ; Thu, 27 Feb 2020 14:34:43 +0100 (CET)
From:   Tobias Klauser <tklauser@distanz.ch>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Kirill Tkhai <ktkhai@virtuozzo.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net v1] unix: define and set show_fdinfo only if procfs is enabled
Date:   Thu, 27 Feb 2020 14:34:42 +0100
Message-Id: <20200227133442.18728-1-tklauser@distanz.ch>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200226172953.16471-1-tklauser@distanz.ch>
References: <20200226172953.16471-1-tklauser@distanz.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follow the pattern used with other *_show_fdinfo functions and only
define unix_show_fdinfo and set it in proto_ops if CONFIG_PROC_FS
is set.

Fixes: 3c32da19a858 ("unix: Show number of pending scm files of receive queue in fdinfo")
Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
v1:
 - s/CONFIG_PROCFS/CONFIG_PROC_FS/

 net/unix/af_unix.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 62c12cb5763e..68debcb28fa4 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -682,6 +682,7 @@ static int unix_set_peek_off(struct sock *sk, int val)
 	return 0;
 }
 
+#ifdef CONFIG_PROC_FS
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

