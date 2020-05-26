Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCC71DC3F6
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 02:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgEUAhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 20:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728026AbgEUAh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 20:37:28 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3EB7C08C5C6;
        Wed, 20 May 2020 17:37:26 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jbZDB-00CgfT-5l; Thu, 21 May 2020 00:37:25 +0000
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 19/19] atm: switch do_atmif_sioc() to direct use of atm_dev_ioctl()
Date:   Thu, 21 May 2020 01:37:21 +0100
Message-Id: <20200521003721.3023783-19-viro@ZenIV.linux.org.uk>
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

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/atm/ioctl.c | 25 ++++---------------------
 1 file changed, 4 insertions(+), 21 deletions(-)

diff --git a/net/atm/ioctl.c b/net/atm/ioctl.c
index 52f2c77e656f..838ebf0cabbf 100644
--- a/net/atm/ioctl.c
+++ b/net/atm/ioctl.c
@@ -286,30 +286,13 @@ static int do_atm_iobuf(struct socket *sock, unsigned int cmd,
 static int do_atmif_sioc(struct socket *sock, unsigned int cmd,
 			 unsigned long arg)
 {
-	struct atmif_sioc __user *sioc;
-	struct compat_atmif_sioc __user *sioc32;
+	struct compat_atmif_sioc __user *sioc32 = compat_ptr(arg);
+	int number;
 	u32 data;
-	void __user *datap;
-	int err;
 
-	sioc = compat_alloc_user_space(sizeof(*sioc));
-	sioc32 = compat_ptr(arg);
-
-	if (copy_in_user(&sioc->number, &sioc32->number, 2 * sizeof(int)) ||
-	    get_user(data, &sioc32->arg))
-		return -EFAULT;
-	datap = compat_ptr(data);
-	if (put_user(datap, &sioc->arg))
+	if (get_user(data, &sioc32->arg) || get_user(number, &sioc32->number))
 		return -EFAULT;
-
-	err = do_vcc_ioctl(sock, cmd, (unsigned long) sioc, 0);
-
-	if (!err) {
-		if (copy_in_user(&sioc32->length, &sioc->length,
-				 sizeof(int)))
-			err = -EFAULT;
-	}
-	return err;
+	return atm_dev_ioctl(cmd, compat_ptr(data), &sioc32->length, number, 0);
 }
 
 static int do_atm_ioctl(struct socket *sock, unsigned int cmd32,
-- 
2.11.0

