Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F04F195AD3
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 17:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbgC0QPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 12:15:52 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:44189 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgC0QPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 12:15:52 -0400
Received: from localhost.localdomain ([93.22.151.104])
        by mwinf5d49 with ME
        id KUFj2200S2FPlbR03UFkmY; Fri, 27 Mar 2020 17:15:48 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 27 Mar 2020 17:15:48 +0100
X-ME-IP: 93.22.151.104
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     bfields@fieldses.org, chuck.lever@oracle.com,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        davem@davemloft.net, kuba@kernel.org, neilb@suse.de,
        tom@opengridcomputing.com, gnb@sgi.com
Cc:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH V2] SUNRPC: Fix a potential buffer overflow in 'svc_print_xprts()'
Date:   Fri, 27 Mar 2020 17:15:39 +0100
Message-Id: <20200327161539.21554-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'maxlen' is the total size of the destination buffer. There is only one
caller and this value is 256.

When we compute the size already used and what we would like to add in
the buffer, the trailling NULL character is not taken into account.
However, this trailling character will be added by the 'strcat' once we
have checked that we have enough place.

So, there is a off-by-one issue and 1 byte of the stack could be
erroneously overwridden.

Take into account the trailling NULL, when checking if there is enough
place in the destination buffer.


While at it, also replace a 'sprintf' by a safer 'snprintf', check for
output truncation and avoid a superfluous 'strlen'.

Fixes: dc9a16e49dbba ("svc: Add /proc/sys/sunrpc/transport files")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
V2: add a doxygen comment to clarify the goal of the function
    merge previous 2 patches into a single one
    keep strcat for clarity, this function being just a slow path anyway

Doc being most of the time a matter of taste, please adjust the description
as needed.
---
 net/sunrpc/svc_xprt.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index de3c077733a7..e0f61a8c1965 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -104,8 +104,17 @@ void svc_unreg_xprt_class(struct svc_xprt_class *xcl)
 }
 EXPORT_SYMBOL_GPL(svc_unreg_xprt_class);
 
-/*
- * Format the transport list for printing
+/**
+ * svc_print_xprts - Format the transport list for printing
+ * @buf: target buffer for formatted address
+ * @maxlen: length of target buffer
+ *
+ * Fills in @buf with a string containing a list of transport names, each name
+ * terminated with '\n'. If the buffer is too small, some entries may be
+ * missing, but it is guaranteed that the line in the output buffer are
+ * complete.
+ *
+ * Returns positive length of the filled-in string.
  */
 int svc_print_xprts(char *buf, int maxlen)
 {
@@ -118,9 +127,9 @@ int svc_print_xprts(char *buf, int maxlen)
 	list_for_each_entry(xcl, &svc_xprt_class_list, xcl_list) {
 		int slen;
 
-		sprintf(tmpstr, "%s %d\n", xcl->xcl_name, xcl->xcl_max_payload);
-		slen = strlen(tmpstr);
-		if (len + slen > maxlen)
+		slen = snprintf(tmpstr, sizeof(tmpstr), "%s %d\n",
+				xcl->xcl_name, xcl->xcl_max_payload);
+		if (slen >= sizeof(tmpstr) || len + slen >= maxlen)
 			break;
 		len += slen;
 		strcat(buf, tmpstr);
-- 
2.20.1

