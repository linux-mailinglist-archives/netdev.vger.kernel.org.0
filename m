Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7D6F134F0F
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbgAHVpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:45:15 -0500
Received: from mout.kundenserver.de ([212.227.126.133]:40107 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgAHVpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 16:45:15 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MacjC-1jQHqL2fve-00c983; Wed, 08 Jan 2020 22:44:59 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Kirill Tkhai <ktkhai@virtuozzo.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Willem de Bruijn <willemb@google.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Pedro Tammela <pctammela@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [net-next] [v2] socket: fix unused-function warning
Date:   Wed,  8 Jan 2020 22:44:43 +0100
Message-Id: <20200108214454.3950090-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:cQbL1QogaNHrETb1/OAbt58mv61iwIwKD9mrjQznrq3KLaWutDU
 5cRv9sfKcaEK2OqWCOuRGzlQjyum2PzXcRKRlhqqLSpCkPPIiozyk/8MPrn4DbEj4xIzNnf
 s8s63hk65Ww+t2ndcsdxKmp63cTcUsOC7a7yxP3ntZ0/AzACmo9CcLkZrhN2UH02DF/a5aB
 89h7Rdrnblnm1AIW9mPiA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:0uzF1xxd2nI=:BXhLrEV5h8gz2y4OcIdemP
 8zRsmkIWy81bMd8/CaLHLg4nS6EtvbEpWjWTmNypHhlvR2FQ+eYCRarO5y+HsyPc4qW2eFwB2
 hfNJP5kWGnULqzr807+29vtAcqsK/4bNaM+Dzq6omjtdJauSMMsS1Qu3riPk3/wrWn/JzYVJh
 xK16sJ3aWTUNwxAhuMIVgcAWbtYEOEA2TZ7/eXJiolmz8edEVNFo7cSnwR3juPQfBM2kcAWYP
 WIupxlHCKWLmUctP/RST57Nmx2LeXzfb3TLN3/HziboGSspyTvvoQdBFK4KRogP+Hh/LJb/Vm
 Xegv2P8U6beksTIB8gkgvG54vM5NyyzxynS/Z2M/3kZG6qMZOdj4gY4YYVc2VGyXtjynhM9x0
 DEu8FQD1zxdIw0X/5LivNfBSmsW8tdHOUwKbjOhE3Wr0YsP+Ur5h5+fl8hmL7/BKUo+Whw3cq
 vNUdIw+UGgRR4ZvgiuxBWpWBF13pz57o81ZsLESL+rmN3KstoC3bzKzt4gECwstuk7FjJne6O
 Oj07Wl7s/3UjQ04l8SrCUKNVX0+0zb2StFL1koTIm/cf6OaXeum+SHAJI8xxm6ODbaTygvt06
 9vtWzuSo7xx0IglGlXkZa1aitiB7RDUZknDE2fNXvpgPLNYWy9RqO6ENjIEtcenOXCk7FfQGJ
 puqB8egTeHbwal4tHYZdgJ81PkuJQoFMa8cTxjMJHcglw0AqLJbHPYgxaO6KX8+SQv6v5tywn
 Wz7zxivJT6PI2mlxXggurRw5Pm20xH8K+8sSokUlZzcaZRJ31ZbHCFGNLVYdkI7CIk2XO8CSW
 67uaS1OaJfRoxrD+6yPta11DUBW09QSD2mmjbUfmkp1uR8hhalpDCIgHZCgJc2e18yUoDn/PN
 SOfM5Ypn1zIWofr1gnqg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When procfs is disabled, the fdinfo code causes a harmless
warning:

net/socket.c:1000:13: error: 'sock_show_fdinfo' defined but not used [-Werror=unused-function]
 static void sock_show_fdinfo(struct seq_file *m, struct file *f)

Move the function definition up so we can use a single #ifdef
around it.

Fixes: b4653342b151 ("net: Allow to show socket-specific information in /proc/[pid]/fdinfo/[fd]")
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: use an #ifdef instead of a ?: operator
---
 net/socket.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 5230c9e1bdec..f13b84e5c70d 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -128,7 +128,18 @@ static ssize_t sock_sendpage(struct file *file, struct page *page,
 static ssize_t sock_splice_read(struct file *file, loff_t *ppos,
 				struct pipe_inode_info *pipe, size_t len,
 				unsigned int flags);
-static void sock_show_fdinfo(struct seq_file *m, struct file *f);
+
+#ifdef CONFIG_PROC_FS
+static void sock_show_fdinfo(struct seq_file *m, struct file *f)
+{
+	struct socket *sock = f->private_data;
+
+	if (sock->ops->show_fdinfo)
+		sock->ops->show_fdinfo(m, sock);
+}
+#else
+#define sock_show_fdinfo NULL
+#endif
 
 /*
  *	Socket files have a set of 'special' operations as well as the generic file ones. These don't appear
@@ -151,9 +162,7 @@ static const struct file_operations socket_file_ops = {
 	.sendpage =	sock_sendpage,
 	.splice_write = generic_splice_sendpage,
 	.splice_read =	sock_splice_read,
-#ifdef CONFIG_PROC_FS
 	.show_fdinfo =	sock_show_fdinfo,
-#endif
 };
 
 /*
@@ -997,14 +1006,6 @@ static ssize_t sock_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	return res;
 }
 
-static void sock_show_fdinfo(struct seq_file *m, struct file *f)
-{
-	struct socket *sock = f->private_data;
-
-	if (sock->ops->show_fdinfo)
-		sock->ops->show_fdinfo(m, sock);
-}
-
 /*
  * Atomic setting of ioctl hooks to avoid race
  * with module unload.
-- 
2.20.0

