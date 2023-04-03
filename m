Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6793D6D451C
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 15:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbjDCNCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 09:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjDCNCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 09:02:00 -0400
X-Greylist: delayed 600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 03 Apr 2023 06:01:57 PDT
Received: from mx.swemel.ru (mx.swemel.ru [95.143.211.150])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D8840F0;
        Mon,  3 Apr 2023 06:01:57 -0700 (PDT)
From:   Denis Arefev <arefev@swemel.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=swemel.ru; s=mail;
        t=1680525803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dUaYZLv07SypYl8nCydRTmN/Q2SJe737WVxx8vmAUU8=;
        b=Kvdg1ABahF4SgBPJ5kqbEGQPNryeG/ddSiKECgNd6reuMnWi1e9MiMfA62Bs1yK2zmn0VF
        u0YY++ajXi5IEIpBi+aMswxlBL561UIl6zBI2FYlQ6rRUF346Ee/jh6p2ALoNOdqOg1k2O
        zJIeERocmXLh1fMmpXybX1K2G8pSTGA=
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, trufanov@swemel.ru, vfh@swemel.ru
Subject: [PATCH] net: Added security socket
Date:   Mon,  3 Apr 2023 15:43:23 +0300
Message-Id: <20230403124323.26961-1-arefev@swemel.ru>
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
	in kernel_connect

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

