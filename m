Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC141E94DA
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 03:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729543AbgEaBG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 21:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729356AbgEaBG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 21:06:57 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AC8C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 18:06:56 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jfCRD-000ghx-Do; Sun, 31 May 2020 01:06:55 +0000
Date:   Sun, 31 May 2020 02:06:55 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
Subject: [PATCH net-next] switch cmsghdr_from_user_compat_to_kern() to
 copy_from_user()
Message-ID: <20200531010655.GX23230@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

no point getting compat_cmsghdr field-by-field

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/net/compat.c b/net/compat.c
index afd7b444e0bf..5e3041a2c37d 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -183,20 +183,21 @@ int cmsghdr_from_user_compat_to_kern(struct msghdr *kmsg, struct sock *sk,
 	memset(kcmsg, 0, kcmlen);
 	ucmsg = CMSG_COMPAT_FIRSTHDR(kmsg);
 	while (ucmsg != NULL) {
-		if (__get_user(ucmlen, &ucmsg->cmsg_len))
+		struct compat_cmsghdr cmsg;
+		if (copy_from_user(&cmsg, ucmsg, sizeof(cmsg)))
 			goto Efault;
-		if (!CMSG_COMPAT_OK(ucmlen, ucmsg, kmsg))
+		if (!CMSG_COMPAT_OK(cmsg.cmsg_len, ucmsg, kmsg))
 			goto Einval;
-		tmp = ((ucmlen - sizeof(*ucmsg)) + sizeof(struct cmsghdr));
+		tmp = ((cmsg.cmsg_len - sizeof(*ucmsg)) + sizeof(struct cmsghdr));
 		if ((char *)kcmsg_base + kcmlen - (char *)kcmsg < CMSG_ALIGN(tmp))
 			goto Einval;
 		kcmsg->cmsg_len = tmp;
+		kcmsg->cmsg_level = cmsg.cmsg_level;
+		kcmsg->cmsg_type = cmsg.cmsg_type;
 		tmp = CMSG_ALIGN(tmp);
-		if (__get_user(kcmsg->cmsg_level, &ucmsg->cmsg_level) ||
-		    __get_user(kcmsg->cmsg_type, &ucmsg->cmsg_type) ||
-		    copy_from_user(CMSG_DATA(kcmsg),
+		if (copy_from_user(CMSG_DATA(kcmsg),
 				   CMSG_COMPAT_DATA(ucmsg),
-				   (ucmlen - sizeof(*ucmsg))))
+				   (cmsg.cmsg_len - sizeof(*ucmsg))))
 			goto Efault;
 
 		/* Advance. */
