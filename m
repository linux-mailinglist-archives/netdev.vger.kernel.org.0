Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70588B8BA1
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 09:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437525AbfITHgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 03:36:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437511AbfITHgY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 03:36:24 -0400
Received: from localhost (unknown [89.205.140.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A61920B7C;
        Fri, 20 Sep 2019 07:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568964983;
        bh=K17LGXzzk4QNV6vN+lSnmKznG9LRxMNsypg5Johj0g0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RNkb2MaggirkF/EttG1tKln3V8V6MqNVfLnmgVaZEyanAoel1YjtpW1hojJDEbbj5
         Q7ix65HCmdScXZmY4gCD6B1t3Zj7LVoBE5bz8NmBu6y8UEKViUeUtj3SeEjSrD+mBo
         rRpoLTd2LVq6aJp21Cic/gHCC/+n0jciHVT1p3P4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     isdn@linux-pingi.de, jreuter@yaina.de, ralf@linux-mips.org,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        orinimron123@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 3/5] ax25: enforce CAP_NET_RAW for raw sockets
Date:   Fri, 20 Sep 2019 09:35:47 +0200
Message-Id: <20190920073549.517481-4-gregkh@linuxfoundation.org>
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

When creating a raw AF_AX25 socket, CAP_NET_RAW needs to be checked
first.

Signed-off-by: Ori Nimron <orinimron123@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ax25/af_ax25.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index ca5207767dc2..bb222b882b67 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -855,6 +855,8 @@ static int ax25_create(struct net *net, struct socket *sock, int protocol,
 		break;
 
 	case SOCK_RAW:
+		if (!capable(CAP_NET_RAW))
+			return -EPERM;
 		break;
 	default:
 		return -ESOCKTNOSUPPORT;
-- 
2.23.0

