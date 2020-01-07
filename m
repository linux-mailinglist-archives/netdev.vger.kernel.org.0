Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D82981334F3
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 22:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgAGVg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 16:36:29 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:34075 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgAGVg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 16:36:29 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MavF5-1jR1ID2Ix9-00cSPq; Tue, 07 Jan 2020 22:36:14 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Kirill Tkhai <ktkhai@virtuozzo.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
        Willem de Bruijn <willemb@google.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Pedro Tammela <pctammela@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [net-next] socket: fix unused-function warning
Date:   Tue,  7 Jan 2020 22:35:59 +0100
Message-Id: <20200107213609.520236-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:xEoGOL0czNPv+y4dyPxEzaMNgC6/Rl0M6RDahYvzpaflqzA6cEh
 p30gfSVBamuHOgTSXu9xjokRctzM5/SYzgtjEFENNLcGRaqyxR6x0v2fRlNtEWeOTeBDdQY
 FQ2wowZiqBgZMyqdhaBbIJhGhyN45twv6vTJdzO1MI0NrNiPi3xBvhGKmp9EY5qtNXpmEka
 OLaTS/PmCAP8H4RE7BeDg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:834qxc/9MuQ=:iEE6j5Wfh7DL5R7l/qWWUN
 UgqwURNYuFoFkODPhjgRkOOX93k/aBD4ME+PfFE71XFkJ/5dVcb/NzNZiF+zVb1IWm8PN91zV
 O/ru+Pt0KXBYGxIA9/CqCXTQpgcMfPm9y94ArkRDnlzx9rXDH+R8KA5lrcFrWjXgjWYA71uS+
 cxN5ZrPcQlk8Cf7utqJ5ctUnxAcfWjFtBaQT64v0p9YZ6CrZJkF63eJNc1RAVRoBE5eVfUYdi
 bnxz0mRu/pPEoRJ9cZPAl6Bm1Gj3PeLg9WJvHwRxwq75mdqJg9PIEcY7oiBAE0uvxTWs6K0xp
 2TT9Pbo38s/7RbM2rm7OpNeeg5TFpqD5g0MSTrpBA75mgZ3NR+DgpXFKNuB3dd150OwOJFBHb
 T0GPQrmLn7z0hEiTm0gJ7rwNASRyZtaCVD/DfIGsK7WyN36qpem7c/nhD3ynkdD2YEYynksv3
 S53zEJMFfbLuqykyKUE4qIKkhzoLUJwVVkkDUm1U9l6S/R9emgvGm3GIRLKqshSQvwBa5HYTG
 2J40JWtMaQN7QzizEykCfvNDklKjaOnUH28CLaX+TiCso1yJO3UeoRGBrmyMushGE6S1iSFfv
 UxS5hYeOXC+vUarE8MrLmpcosqiQWjPgBbCmd3gsX8DotbE2wPa+VYYIQeUvnJCDVMaHyP/hx
 DI89KZkkP7Pa0/IWcwrqGJvtAJiGJSQJC8BphXyQK7D/WxcYR7e6TL4z2+aqlJt3wnTGld0cg
 p67kgcy9ZgFF4oDyYoy8uYfLlcpvrb+RKeGA0WH68CMRaDFlY1poA4rWHyZ7xx4TcIeNjZYKd
 O+Zd5n57IHRxzXFpuPqnFJnpGIZxdlVln9Nkp4V42dw7nap0eNVHbBtrvesaU3F2rcHW3Y9JO
 4fuAL/9gZDd6PZyVHj5A==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When procfs is disabled, the fdinfo code causes a harmless
warning:

net/socket.c:1000:13: error: 'sock_show_fdinfo' defined but not used [-Werror=unused-function]
 static void sock_show_fdinfo(struct seq_file *m, struct file *f)

Change the preprocessor conditional to a compiler conditional
to avoid the warning and let the compiler throw away the
function itself.

Fixes: b4653342b151 ("net: Allow to show socket-specific information in /proc/[pid]/fdinfo/[fd]")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/socket.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 5230c9e1bdec..444a617819f0 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -151,9 +151,7 @@ static const struct file_operations socket_file_ops = {
 	.sendpage =	sock_sendpage,
 	.splice_write = generic_splice_sendpage,
 	.splice_read =	sock_splice_read,
-#ifdef CONFIG_PROC_FS
-	.show_fdinfo =	sock_show_fdinfo,
-#endif
+	.show_fdinfo =	IS_ENABLED(CONFIG_PROC_FS) ? sock_show_fdinfo : NULL,
 };
 
 /*
-- 
2.20.0

