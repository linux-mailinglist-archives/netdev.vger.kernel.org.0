Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E689B8B9E
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 09:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403959AbfITHgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 03:36:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730493AbfITHgO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 03:36:14 -0400
Received: from localhost (unknown [89.205.140.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FEAE207FC;
        Fri, 20 Sep 2019 07:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568964974;
        bh=CTTZtX6AxA076NKL6BVqHwg/gxozWHMsOn7UROYNgLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ftaALDX7aZt2gwmAIl7/XM6xOuXkbeUWOUzYQKgGxh1/veWuDuKkC9rTIJ1X5UUV9
         9B/Id6j0Cb7CF9Q0ezxQaQ/51spX4dTgziPfZJTWUZTpK45QNBfhUcEo80iuVqw+8V
         c51FphdX0haoR4ssSVR2fZvsx/UmPliyiLe+U9vg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     isdn@linux-pingi.de, jreuter@yaina.de, ralf@linux-mips.org,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        orinimron123@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 2/5] appletalk: enforce CAP_NET_RAW for raw sockets
Date:   Fri, 20 Sep 2019 09:35:46 +0200
Message-Id: <20190920073549.517481-3-gregkh@linuxfoundation.org>
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

When creating a raw AF_APPLETALK socket, CAP_NET_RAW needs to be checked
first.

Signed-off-by: Ori Nimron <orinimron123@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/appletalk/ddp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index 4072e9d394d6..b41375d4d295 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1023,6 +1023,11 @@ static int atalk_create(struct net *net, struct socket *sock, int protocol,
 	 */
 	if (sock->type != SOCK_RAW && sock->type != SOCK_DGRAM)
 		goto out;
+
+	rc = -EPERM;
+	if (sock->type == SOCK_RAW && !kern && !capable(CAP_NET_RAW))
+		goto out;
+
 	rc = -ENOMEM;
 	sk = sk_alloc(net, PF_APPLETALK, GFP_KERNEL, &ddp_proto, kern);
 	if (!sk)
-- 
2.23.0

