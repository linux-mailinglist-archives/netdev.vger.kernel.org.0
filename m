Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36B54564A2
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 10:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbfFZIbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 04:31:49 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46231 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfFZIbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 04:31:49 -0400
Received: by mail-pl1-f196.google.com with SMTP id e5so1020208pls.13;
        Wed, 26 Jun 2019 01:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zdrESw8iHIgjHmeOWFycSHyaMdMBE1SNNEGcPhV8D1A=;
        b=Xi4Bd96cy12wWlgGJ291hDlZv/V8QajY0PR0GoSThZSEzM4RFFZhIiYF0QSIKxaNTk
         a7A7JNip4MNJ9DBOzCZDazrssnBpSpgMuAanWvPAOP7acG6IwGzzJySmC+5TY67bRmaM
         nhj9PEsfGlPTPRkcpVge8nZQOvlEoMMoggm9UMNPKuClLoz2DmfmlEqkEe3xfH3UES24
         ZyJ8538LYnzM2IsyTevk961jPtt6pENPdzyYvYUSiqR18TO7bfhdRcuvun2Ycj4xeE2r
         HWnRAqMVL+NBpovGcYETTfrdbAa91BogjPvLVaNTe8Vssgoijgcc7mdvjcg/U5mXok8+
         yKVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zdrESw8iHIgjHmeOWFycSHyaMdMBE1SNNEGcPhV8D1A=;
        b=lky8Tvqw/OJyy96OLBWxspx9B66ykzyO2GeDR6d3ZHPeFT6IhDNbP+R+G/5dYvFPaJ
         5DwE3nMJl5xa2N3DxnwoVzRlU2EdSCFtqSr5Co+aH50HzrmRw6QuAiu8DZV8TpcemFaZ
         XMqXDllGF9HFF1dCXI59MgCB62JgtwsC9F74TMwygxirZT5DGQh0GcQcgSx9u85foXYJ
         /9BjIXhcoWV4+g6HUUhuh0MOig4aGYOx8f5J/yddfxmKTAeSgKE/VJeOF6z5lcVCHvE+
         WBdDzs3t6dIC7a9xStXu35EAGEGXWCJZhVp48ZzaoQHuQsskCtZy3AoMBUI8rN9hREiG
         WNgA==
X-Gm-Message-State: APjAAAV8UpzGUuD+/Dn4OFrB3QQd6sm7T9KyEw2pHpOV12Gr5aXAizVY
        USpEMEicYsaxR4DmNUlr1h6LC9QU
X-Google-Smtp-Source: APXvYqwGegYBbfgse3C9sKCGqkX8HINLf9J6ZFrs1aqmz0KIg4YcSe1TEl5okq8RHHC2EmGTyy/ixQ==
X-Received: by 2002:a17:902:be0a:: with SMTP id r10mr3830691pls.51.1561537908280;
        Wed, 26 Jun 2019 01:31:48 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f186sm18236813pfb.5.2019.06.26.01.31.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 01:31:47 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        syzkaller-bugs@googlegroups.com
Subject: [PATCH net] sctp: not bind the socket in sctp_connect
Date:   Wed, 26 Jun 2019 16:31:39 +0800
Message-Id: <35a0e4f6ca68185117c6e5517d8ac924cc2f9d05.1561537899.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now when sctp_connect() is called with a wrong sa_family, it binds
to a port but doesn't set bp->port, then sctp_get_af_specific will
return NULL and sctp_connect() returns -EINVAL.

Then if sctp_bind() is called to bind to another port, the last
port it has bound will leak due to bp->port is NULL by then.

sctp_connect() doesn't need to bind ports, as later __sctp_connect
will do it if bp->port is NULL. So remove it from sctp_connect().
While at it, remove the unnecessary sockaddr.sa_family len check
as it's already done in sctp_inet_connect.

Fixes: 644fbdeacf1d ("sctp: fix the issue that flags are ignored when using kernel_connect")
Reported-by: syzbot+079bf326b38072f849d9@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 39ea0a3..f33aa9e 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4816,35 +4816,17 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 static int sctp_connect(struct sock *sk, struct sockaddr *addr,
 			int addr_len, int flags)
 {
-	struct inet_sock *inet = inet_sk(sk);
 	struct sctp_af *af;
-	int err = 0;
+	int err = -EINVAL;
 
 	lock_sock(sk);
-
 	pr_debug("%s: sk:%p, sockaddr:%p, addr_len:%d\n", __func__, sk,
 		 addr, addr_len);
 
-	/* We may need to bind the socket. */
-	if (!inet->inet_num) {
-		if (sk->sk_prot->get_port(sk, 0)) {
-			release_sock(sk);
-			return -EAGAIN;
-		}
-		inet->inet_sport = htons(inet->inet_num);
-	}
-
 	/* Validate addr_len before calling common connect/connectx routine. */
-	af = addr_len < offsetofend(struct sockaddr, sa_family) ? NULL :
-		sctp_get_af_specific(addr->sa_family);
-	if (!af || addr_len < af->sockaddr_len) {
-		err = -EINVAL;
-	} else {
-		/* Pass correct addr len to common routine (so it knows there
-		 * is only one address being passed.
-		 */
+	af = sctp_get_af_specific(addr->sa_family);
+	if (af && addr_len >= af->sockaddr_len)
 		err = __sctp_connect(sk, addr, af->sockaddr_len, flags, NULL);
-	}
 
 	release_sock(sk);
 	return err;
-- 
2.1.0

