Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01293B8BA0
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 09:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437520AbfITHgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 03:36:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437511AbfITHgV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 03:36:21 -0400
Received: from localhost (unknown [89.205.140.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D41C0208C0;
        Fri, 20 Sep 2019 07:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568964980;
        bh=nzhgttOSPXQ3oeiv/D97eXaK7/HXlb3JCh5T8wct42w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HkoYZGnylmfdHl6aw4A6Rac9rbHWS7Ac039nZ2OWGrL2kkr7vj3+2FmbkAPAAiHhi
         mMfpC3449C0RkwuQTIPE3LexA8j92ZQ9sSR3BM3FZxBztsVnuIKg1InwsUhxlhmo84
         lPIoJDuwuhyCIL6eryaGqXqcHrJ24oFALpsc9wSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     isdn@linux-pingi.de, jreuter@yaina.de, ralf@linux-mips.org,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        orinimron123@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5/5] nfc: enforce CAP_NET_RAW for raw sockets
Date:   Fri, 20 Sep 2019 09:35:49 +0200
Message-Id: <20190920073549.517481-6-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190920073549.517481-1-gregkh@linuxfoundation.org>
References: <20190920073549.517481-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ori Nimron <orinimron123@gmail.com>

When creating a raw AF_NFC socket, CAP_NET_RAW needs to be checked
first.

Signed-off-by: Ori Nimron <orinimron123@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/llcp_sock.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 9b8742947aff..8dfea26536c9 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -1004,10 +1004,13 @@ static int llcp_sock_create(struct net *net, struct socket *sock,
 	    sock->type != SOCK_RAW)
 		return -ESOCKTNOSUPPORT;
 
-	if (sock->type == SOCK_RAW)
+	if (sock->type == SOCK_RAW) {
+		if (!capable(CAP_NET_RAW))
+			return -EPERM;
 		sock->ops = &llcp_rawsock_ops;
-	else
+	} else {
 		sock->ops = &llcp_sock_ops;
+	}
 
 	sk = nfc_llcp_sock_alloc(sock, sock->type, GFP_ATOMIC, kern);
 	if (sk == NULL)
-- 
2.23.0

