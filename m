Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36AB6D7CF7
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 14:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235652AbjDEMxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 08:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbjDEMxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 08:53:14 -0400
Received: from mx.swemel.ru (mx.swemel.ru [95.143.211.150])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52251FFE;
        Wed,  5 Apr 2023 05:53:11 -0700 (PDT)
From:   Denis Arefev <arefev@swemel.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=swemel.ru; s=mail;
        t=1680699188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=8jSMehI3NmhiQSs4S6ALsvgGoTEzZsyVpigKpvyvIMQ=;
        b=FxLX8o09yM2S0bA/+HUGYBcyyZYWUad7hCBh69Sv0x0Mu25Y99ITwdHN6q4IR43mWhzWzT
        RSVuWFmWy47ZJYc9velx3Z9T7P7TU9NvGJ989bhBbiVKgOjwTHGFjJKyw4EUNNH2bGw12e
        hLhBYXLzmaZ3S9axo2drB/zYo19HNbk=
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, trufanov@swemel.ru, vfh@swemel.ru
Subject: [PATCH] net: Added security socket
Date:   Wed,  5 Apr 2023 15:53:08 +0300
Message-Id: <20230405125308.57821-1-arefev@swemel.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	Added security_socket_connect
	kernel_connect is in kernel space,
	but kernel_connect is used in RPC 
	requests (/net/sunrpc/xprtsock.c),  
	and the RPC protocol is used by the NFS server.
	This is how we protect the TCP connection 
	initiated by the client. 

Signed-off-by: Denis Arefev <arefev@swemel.ru>
---
 net/socket.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/socket.c b/net/socket.c
index 9c92c0e6c4da..9afa2b44a9e5 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3526,6 +3526,12 @@ EXPORT_SYMBOL(kernel_accept);
 int kernel_connect(struct socket *sock, struct sockaddr *addr, int addrlen,
 		   int flags)
 {
+	int err;
+
+	err = security_socket_connect(sock, (struct sockaddr *)addr, addrlen);
+	if (err)
+		return err;
+
 	return sock->ops->connect(sock, addr, addrlen, flags);
 }
 EXPORT_SYMBOL(kernel_connect);
-- 
2.25.1

