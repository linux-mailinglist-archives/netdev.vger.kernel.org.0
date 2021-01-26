Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835C83030C9
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 01:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732288AbhAZAEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 19:04:25 -0500
Received: from novek.ru ([213.148.174.62]:49886 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732226AbhAZADN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 19:03:13 -0500
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 936AA502FBF;
        Tue, 26 Jan 2021 03:03:45 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 936AA502FBF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1611619427; bh=Hpl3vvXSctVQsOC+wnRnkZuV7ld0LLU65By0tjiD9Sk=;
        h=From:To:Cc:Subject:Date:From;
        b=bATEXdUG4WSXnf5I0Q0/KA80Lx0F6w3CPSwrdG9Tf3mI2+ViJEsij+fuAHZDWtYc7
         oIkvTqeFQO3dSbRHj6V8qJcYvvjeSeEjzyuJvU9lvXS8pKBqCsfeLxyRoHjeH1R2zD
         KYqItzEXAlNxSFDRsbsdNW8f+KzqLFyKnZ+yxIfg=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Gaurav Singh <gaurav1086@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>,
        linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [net] net: decnet: fix netdev refcount leaking on error path
Date:   Tue, 26 Jan 2021 03:02:14 +0300
Message-Id: <1611619334-20955-1-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On building the route there is an assumption that the destination
could be local. In this case loopback_dev is used to get the address.
If the address is still cannot be retrieved dn_route_output_slow
returns EADDRNOTAVAIL with loopback_dev reference taken.

Cannot find hash for the fixes tag because this code was introduced
long time ago. I don't think that this bug has ever fired but the
patch is done just to have a consistent code base.

Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 net/decnet/dn_route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
index 4cac31d..2193ae5 100644
--- a/net/decnet/dn_route.c
+++ b/net/decnet/dn_route.c
@@ -1035,7 +1035,7 @@ static int dn_route_output_slow(struct dst_entry **pprt, const struct flowidn *o
 			fld.saddr = dnet_select_source(dev_out, 0,
 						       RT_SCOPE_HOST);
 			if (!fld.daddr)
-				goto out;
+				goto done;
 		}
 		fld.flowidn_oif = LOOPBACK_IFINDEX;
 		res.type = RTN_LOCAL;
-- 
1.8.3.1

