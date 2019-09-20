Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E501B8B9F
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 09:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437515AbfITHgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 03:36:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:58752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437511AbfITHgS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 03:36:18 -0400
Received: from localhost (unknown [89.205.140.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2DE720882;
        Fri, 20 Sep 2019 07:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568964977;
        bh=H6ouQjqr2XxrN24f+ltvt/OqwmUqSWyTn66raHrndfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KmVpWpURBNjc6U7rb0KEvRhDnrJH77kc2mh0eVP1GubUh47hICKYcs045kHUQ1riF
         bom2Tf1WXSoihJ0wSMToDU2Nr5LbFvwnnRdujP8kPiLj6ua0w6tuOWfnCaW+hydXa2
         v25LDc0GJJ1BaixZUOhdjwp2lTeJ3flaPWvL2ba0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     isdn@linux-pingi.de, jreuter@yaina.de, ralf@linux-mips.org,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        orinimron123@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4/5] ieee802154: enforce CAP_NET_RAW for raw sockets
Date:   Fri, 20 Sep 2019 09:35:48 +0200
Message-Id: <20190920073549.517481-5-gregkh@linuxfoundation.org>
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

When creating a raw AF_IEEE802154 socket, CAP_NET_RAW needs to be
checked first.

Signed-off-by: Ori Nimron <orinimron123@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ieee802154/socket.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index badc5cfe4dc6..d93d4531aa9b 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -1008,6 +1008,9 @@ static int ieee802154_create(struct net *net, struct socket *sock,
 
 	switch (sock->type) {
 	case SOCK_RAW:
+		rc = -EPERM;
+		if (!capable(CAP_NET_RAW))
+			goto out;
 		proto = &ieee802154_raw_prot;
 		ops = &ieee802154_raw_ops;
 		break;
-- 
2.23.0

