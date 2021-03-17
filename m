Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2EE33E699
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 03:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhCQCHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 22:07:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27019 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230021AbhCQCGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 22:06:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615946814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XjCWkQIaoS3JdUbqmwBPAeXB1RAlDOQU5gRE42HRk9s=;
        b=e/gWXmB8vRzH+TLTdOYs8k9eY8mpmEsSLauSPntlkUbuiGVhgrTorUEdKViWhu+z5DMn3A
        cy9xfzevmwBY6PrR8DtJbShDC3Ob63RMMtFGvxWgFL0cLpdwCwp98+SLSD3X0Oo0QcbraC
        y+/phHu+jc/qzrxYTMVjqc05g0LMNGc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-CO7mr4LDPnWvannnIptdeA-1; Tue, 16 Mar 2021 22:06:46 -0400
X-MC-Unique: CO7mr4LDPnWvannnIptdeA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 022BB100C618;
        Wed, 17 Mar 2021 02:06:45 +0000 (UTC)
Received: from fenrir.redhat.com (ovpn-118-76.rdu2.redhat.com [10.10.118.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE4695C1A1;
        Wed, 17 Mar 2021 02:06:43 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net-next 12/16] tipc: simplify signature of tipc_service_find_range()
Date:   Tue, 16 Mar 2021 22:06:19 -0400
Message-Id: <20210317020623.1258298-13-jmaloy@redhat.com>
In-Reply-To: <20210317020623.1258298-1-jmaloy@redhat.com>
References: <20210317020623.1258298-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

We simplify the signatures of the functions tipc_service_create_range()
and tipc_service_find_range().

Signed-off-by: Jon Maloy <jmaloy@redhat.com>
Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Hoang Le <hoang.h.le@dektech.com.au>
Acked-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Acked-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/name_table.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index 1ce65cbce672..f6a1b78a807e 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -275,13 +275,13 @@ static struct tipc_service *tipc_service_create(u32 type, struct hlist_head *hd)
 /*  tipc_service_find_range - find service range matching publication parameters
  */
 static struct service_range *tipc_service_find_range(struct tipc_service *sc,
-						     u32 lower, u32 upper)
+						     struct tipc_uaddr *ua)
 {
 	struct service_range *sr;
 
-	service_range_foreach_match(sr, sc, lower, upper) {
+	service_range_foreach_match(sr, sc, ua->sr.lower, ua->sr.upper) {
 		/* Look for exact match */
-		if (sr->lower == lower && sr->upper == upper)
+		if (sr->lower == ua->sr.lower && sr->upper == ua->sr.upper)
 			return sr;
 	}
 
@@ -289,10 +289,12 @@ static struct service_range *tipc_service_find_range(struct tipc_service *sc,
 }
 
 static struct service_range *tipc_service_create_range(struct tipc_service *sc,
-						       u32 lower, u32 upper)
+						       struct publication *p)
 {
 	struct rb_node **n, *parent = NULL;
 	struct service_range *sr;
+	u32 lower = p->sr.lower;
+	u32 upper = p->sr.upper;
 
 	n = &sc->ranges.rb_node;
 	while (*n) {
@@ -332,7 +334,7 @@ static bool tipc_service_insert_publ(struct net *net,
 	bool res = false;
 
 	spin_lock_bh(&sc->lock);
-	sr = tipc_service_create_range(sc, p->sr.lower, p->sr.upper);
+	sr = tipc_service_create_range(sc, p);
 	if (!sr)
 		goto  exit;
 
@@ -513,7 +515,7 @@ struct publication *tipc_nametbl_remove_publ(struct net *net,
 		return NULL;
 
 	spin_lock_bh(&sc->lock);
-	sr = tipc_service_find_range(sc, lower, upper);
+	sr = tipc_service_find_range(sc, ua);
 	if (!sr)
 		goto exit;
 	p = tipc_service_remove_publ(sr, sk, key);
-- 
2.29.2

