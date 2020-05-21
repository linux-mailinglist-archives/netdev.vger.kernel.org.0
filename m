Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438141DC3FA
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 02:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgEUAho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 20:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728018AbgEUAh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 20:37:26 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74644C061A0F;
        Wed, 20 May 2020 17:37:26 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jbZDA-00CgfF-Kl; Thu, 21 May 2020 00:37:24 +0000
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 17/19] atm: switch do_atm_iobuf() to direct use of atm_getnames()
Date:   Thu, 21 May 2020 01:37:19 +0100
Message-Id: <20200521003721.3023783-17-viro@ZenIV.linux.org.uk>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200521003721.3023783-1-viro@ZenIV.linux.org.uk>
References: <20200521003657.GE23230@ZenIV.linux.org.uk>
 <20200521003721.3023783-1-viro@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

... and sod the compat_alloc_user_space() with its complications

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/atm/ioctl.c | 25 +++----------------------
 1 file changed, 3 insertions(+), 22 deletions(-)

diff --git a/net/atm/ioctl.c b/net/atm/ioctl.c
index e239cebf48da..fdd0e3434523 100644
--- a/net/atm/ioctl.c
+++ b/net/atm/ioctl.c
@@ -251,32 +251,13 @@ static struct {
 static int do_atm_iobuf(struct socket *sock, unsigned int cmd,
 			unsigned long arg)
 {
-	struct atm_iobuf __user *iobuf;
-	struct compat_atm_iobuf __user *iobuf32;
+	struct compat_atm_iobuf __user *iobuf32 = compat_ptr(arg);
 	u32 data;
-	void __user *datap;
-	int len, err;
-
-	iobuf = compat_alloc_user_space(sizeof(*iobuf));
-	iobuf32 = compat_ptr(arg);
 
-	if (get_user(len, &iobuf32->length) ||
-	    get_user(data, &iobuf32->buffer))
-		return -EFAULT;
-	datap = compat_ptr(data);
-	if (put_user(len, &iobuf->length) ||
-	    put_user(datap, &iobuf->buffer))
+	if (get_user(data, &iobuf32->buffer))
 		return -EFAULT;
 
-	err = do_vcc_ioctl(sock, cmd, (unsigned long) iobuf, 0);
-
-	if (!err) {
-		if (copy_in_user(&iobuf32->length, &iobuf->length,
-				 sizeof(int)))
-			err = -EFAULT;
-	}
-
-	return err;
+	return atm_getnames(&iobuf32->length, compat_ptr(data));
 }
 
 static int do_atmif_sioc(struct socket *sock, unsigned int cmd,
-- 
2.11.0

