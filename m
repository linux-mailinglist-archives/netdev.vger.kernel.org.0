Return-Path: <netdev+bounces-534-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45C546F7F8E
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 11:07:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2FE3280FB8
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 09:07:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A11E86FBE;
	Fri,  5 May 2023 09:07:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961771FC9
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 09:07:29 +0000 (UTC)
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617BE19423;
	Fri,  5 May 2023 02:07:13 -0700 (PDT)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4QCPvL3lxxz5B15h;
	Fri,  5 May 2023 17:06:54 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 34596cX0093745;
	Fri, 5 May 2023 17:06:38 +0800 (+08)
	(envelope-from ye.xingchen@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid31;
	Fri, 5 May 2023 17:06:41 +0800 (CST)
Date: Fri, 5 May 2023 17:06:41 +0800 (CST)
X-Zmail-TransId: 2afa6454c7210c6-ea699
X-Mailer: Zmail v1.0
Message-ID: <202305051706416319733@zte.com.cn>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: <ye.xingchen@zte.com.cn>
To: <davem@davemloft.net>
Cc: <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBuZXQ6IHNvY2tldDogVXNlIGZkZ2V0KCkgYW5kIGZkcHV0KCk=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 34596cX0093745
X-Fangmail-Gw-Spam-Type: 0
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6454C72E.002/4QCPvL3lxxz5B15h
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Ye Xingchen <ye.xingchen@zte.com.cn>

By using the fdget function, the socket object, can be quickly obtained
from the process's file descriptor table without the need to obtain the
file descriptor first before passing it as a parameter to the fget
function.

Signed-off-by: Ye Xingchen <ye.xingchen@zte.com.cn>
---
 net/socket.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index a7b4b37d86df..84daba774432 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -528,19 +528,18 @@ EXPORT_SYMBOL(sock_from_file);

 struct socket *sockfd_lookup(int fd, int *err)
 {
-	struct file *file;
+	struct fd f = fdget(fd);
 	struct socket *sock;

-	file = fget(fd);
-	if (!file) {
+	if (!f.file) {
 		*err = -EBADF;
 		return NULL;
 	}

-	sock = sock_from_file(file);
+	sock = sock_from_file(f.file);
 	if (!sock) {
 		*err = -ENOTSOCK;
-		fput(file);
+		fdput(f);
 	}
 	return sock;
 }
-- 
2.25.1

