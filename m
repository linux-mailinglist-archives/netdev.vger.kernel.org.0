Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1D722C948
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 17:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgGXPcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 11:32:10 -0400
Received: from mail.katalix.com ([3.9.82.81]:56780 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726731AbgGXPcI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 11:32:08 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 3B7638AD91;
        Fri, 24 Jul 2020 16:32:06 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595604726; bh=UGdcFcBcExYebN3wgku6Bb9sSHP4xnNyokr++4TslJs=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=209/9]=20l2tp:=20WARN_ON=20rathe
         r=20than=20BUG_ON=20in=20l2tp_session_free|Date:=20Fri,=2024=20Jul
         =202020=2016:31:57=20+0100|Message-Id:=20<20200724153157.9366-10-t
         parkin@katalix.com>|In-Reply-To:=20<20200724153157.9366-1-tparkin@
         katalix.com>|References:=20<20200724153157.9366-1-tparkin@katalix.
         com>;
        b=UBmw4oidZcilTRIxl9b3BRBGqyeWwSxnHq4Xd/kmZCxXKtHbDvrPifRw+p6qYM96J
         pl+e2bVR53o/jbdn9YFuf+UJxysEK+mnKvRFFl+9fElNpc7/858f/JzKVtpMRBoQrD
         RXL7+jJJGpyhyA2meYdljG7yrWDDpmjpd0c18m3XRsOyL0KMI4YMMIliP1/qFLvSBl
         sw29l4IePTxgBIq70ND/ccZMMM5LnP7RwWAotMkuew49kc4ZVVt9pI3D4FDRHNGXkt
         SJgxSGK3FWQWnLypgvKAFGLUqp7sCX4wsFrfTOqurC99jOutueLd1dYw5qUWAzlAfo
         exzJpn9EjwAAw==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 9/9] l2tp: WARN_ON rather than BUG_ON in l2tp_session_free
Date:   Fri, 24 Jul 2020 16:31:57 +0100
Message-Id: <20200724153157.9366-10-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200724153157.9366-1-tparkin@katalix.com>
References: <20200724153157.9366-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

l2tp_session_free called BUG_ON if the tunnel magic feather value wasn't
correct.  The intent of this was to catch lifetime bugs; for example
early tunnel free due to incorrect use of reference counts.

Since the tunnel magic feather being wrong indicates either early free
or structure corruption, we can avoid doing more damage by simply
leaving the tunnel structure alone.  If the tunnel refcount isn't
dropped when it should be, the tunnel instance will remain in the
kernel, resulting in the tunnel structure and socket leaking.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 50548c61b91e..e723828e458b 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1564,10 +1564,12 @@ void l2tp_session_free(struct l2tp_session *session)
 	struct l2tp_tunnel *tunnel = session->tunnel;
 
 	if (tunnel) {
-		BUG_ON(tunnel->magic != L2TP_TUNNEL_MAGIC);
+		if (WARN_ON(tunnel->magic != L2TP_TUNNEL_MAGIC))
+			goto out;
 		l2tp_tunnel_dec_refcount(tunnel);
 	}
 
+out:
 	kfree(session);
 }
 EXPORT_SYMBOL_GPL(l2tp_session_free);
-- 
2.17.1

