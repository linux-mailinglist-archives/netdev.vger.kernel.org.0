Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2D39B8B9A
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 09:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395109AbfITHgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 03:36:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393025AbfITHgB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 03:36:01 -0400
Received: from localhost (unknown [89.205.140.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B068207FC;
        Fri, 20 Sep 2019 07:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568964961;
        bh=+PPOrOvLe8rfiaGSPY3cPe8ZrbVFOI/MYrTa0M/ejCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DgPgvpnh9ku/UGmk04qzseXtOcIbu8fyeXpcxMlQdJrlr14BfHQrlVwNFyB/DhKG7
         qeGXKBTqh2Db0ADmeJLzGecfrvJUZvOU44NxFeJCNAWcOth+OOnoBxt1x6+WodrKA5
         NvfgT5Pp3Ut96NGJllyr9bhxSPmdPJLsv6G7fnmY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     isdn@linux-pingi.de, jreuter@yaina.de, ralf@linux-mips.org,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        orinimron123@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/5] mISDN: enforce CAP_NET_RAW for raw sockets
Date:   Fri, 20 Sep 2019 09:35:45 +0200
Message-Id: <20190920073549.517481-2-gregkh@linuxfoundation.org>
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

When creating a raw AF_ISDN socket, CAP_NET_RAW needs to be checked
first.

Signed-off-by: Ori Nimron <orinimron123@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/isdn/mISDN/socket.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/isdn/mISDN/socket.c b/drivers/isdn/mISDN/socket.c
index c6ba37df4b9d..dff4132b3702 100644
--- a/drivers/isdn/mISDN/socket.c
+++ b/drivers/isdn/mISDN/socket.c
@@ -754,6 +754,8 @@ base_sock_create(struct net *net, struct socket *sock, int protocol, int kern)
 
 	if (sock->type != SOCK_RAW)
 		return -ESOCKTNOSUPPORT;
+	if (!capable(CAP_NET_RAW))
+		return -EPERM;
 
 	sk = sk_alloc(net, PF_ISDN, GFP_KERNEL, &mISDN_proto, kern);
 	if (!sk)
-- 
2.23.0

