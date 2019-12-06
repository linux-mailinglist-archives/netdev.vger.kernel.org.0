Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9762111569D
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 18:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbfLFRil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 12:38:41 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:43317 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfLFRil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 12:38:41 -0500
Received: by mail-pj1-f73.google.com with SMTP id b23so3978668pjz.10
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 09:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Vd5KbYjsiE1EtZVMNSeHzigBzJq8TAQZuGFlb+8G3b8=;
        b=OZMDl0dUbNauHdvrfwR2yLtAP+z7tlBcQot4LIPI+YLtbcnyAF2LnvofuehMpRxZly
         4e6e+kbWST8hgfl9TRAJx7sTrUDnRBv96/ES4htzD5NfkLKOFFZOHKwsE3j0JfYwvqrH
         VtsRKPsSp+i7bg6wWzAO58h4vT9iHHF4lYxTPRrgt+8wH3ADe44gicez0DL99GqWb6s1
         vx+SzJHezyRrFbLheJ6yhpLhD2VBgj01ov2X8CkIPe3fPhXSi7kmJixIzOQB1PdW9YTy
         Z5pLOSR1JJAflfMfGsFamFiGXjmen7HSm4sbAIUS52jTCMoUUWugXPSDVfMqKIQCXkVs
         03Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Vd5KbYjsiE1EtZVMNSeHzigBzJq8TAQZuGFlb+8G3b8=;
        b=LuoPSXNvjSwU7chc5r04H0UMuEImXsEecH9nAGYRDAiTKvNLWyw8TL3JpZLP2qEgdA
         pGMaBxUgerlRiMmZRS/6ToEl1kz+cN4rgtw+cRky96spS5W8ZKH9faX5Tph8FAvzJeCA
         dRxtQaGz+Kg6OTF52MttrXDCcrWlItLQwH7ZqxT2gHJqb4nv5D9OsUg4I4Mh2EGK0nN1
         XLYxsUNiDHM78WioMHWlADDP01ClJeRmXF0jujB9wfvEtNEfb9r/hnP9lR2M9S/b6yEp
         3TQMNs6FVXHEyoax/sCljiCKLJWAtkvcciJHyvijD6ZAjzvXz4qU8YC/y7Ay0dztCVyT
         cTpQ==
X-Gm-Message-State: APjAAAVQWACydWIHDcItjedGilkVf+RjYypiazK/5dVmAWXinuI5m0tg
        yZKpGOJ2eSLc2SUw0/xsB8xusu6L3Qhn0w==
X-Google-Smtp-Source: APXvYqwb6gPjfb8TQu/jBy/TXXOXj1+RJfxa9d4Xm6wW0E1H7DZCH+GR2erbctEfBrZKOO5jae46zCaxpb5etg==
X-Received: by 2002:a63:fd0a:: with SMTP id d10mr4548283pgh.197.1575653920241;
 Fri, 06 Dec 2019 09:38:40 -0800 (PST)
Date:   Fri,  6 Dec 2019 09:38:36 -0800
Message-Id: <20191206173836.34294-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH net] net: avoid an indirect call in ____sys_recvmsg()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CONFIG_RETPOLINE=y made indirect calls expensive.

gcc seems to add an indirect call in ____sys_recvmsg().

Rewriting the code slightly makes sure to avoid this indirection.

Alternative would be to not call sock_recvmsg() and instead
use security_socket_recvmsg() and sock_recvmsg_nosec(),
but this is less readable IMO.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: David Laight <David.Laight@aculab.com>
---
 net/socket.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/socket.c b/net/socket.c
index ea28cbb9e2e7a7180ee63de2d09a81aacb001ab7..5af84d71cbc2f731def460b70aa7f68533a90b16 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2559,7 +2559,12 @@ static int ____sys_recvmsg(struct socket *sock, struct msghdr *msg_sys,
 
 	if (sock->file->f_flags & O_NONBLOCK)
 		flags |= MSG_DONTWAIT;
-	err = (nosec ? sock_recvmsg_nosec : sock_recvmsg)(sock, msg_sys, flags);
+
+	if (unlikely(nosec))
+		err = sock_recvmsg_nosec(sock, msg_sys, flags);
+	else
+		err = sock_recvmsg(sock, msg_sys, flags);
+
 	if (err < 0)
 		goto out;
 	len = err;
-- 
2.24.0.393.g34dc348eaf-goog

