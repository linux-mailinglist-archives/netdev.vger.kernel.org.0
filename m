Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA273129FB8
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 10:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfLXJbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 04:31:31 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25271 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726091AbfLXJbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 04:31:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577179890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bf2SB/a1lkCEn2kxthRUiG32D7dOq2K7DVTLpzbVdIo=;
        b=YiezOs9TjbSqefIJ81ZHI4WTrmLdzoY0C7rgoSX/UgaFI/4agZ/hFF3ZT8KhxdK/PoIx58
        uoDDC9zXIMJJ6ughUQj3mQV5vwaW9yW1/YOq6fZQ6+0af8rPFM0kal2QGu9dnpuvWbahBv
        FDMDZ4dWKYNGVw2NHFfHS2FC+zoQbZs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-3DQtRYZdNgW3zbFDX5K95A-1; Tue, 24 Dec 2019 04:31:26 -0500
X-MC-Unique: 3DQtRYZdNgW3zbFDX5K95A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9865F10054E3;
        Tue, 24 Dec 2019 09:31:25 +0000 (UTC)
Received: from wlan-180-229.mxp.redhat.com (wlan-180-229.mxp.redhat.com [10.32.180.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 94F6C10018FF;
        Tue, 24 Dec 2019 09:31:24 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net 1/2] Revert "net/sched: cls_u32: fix refcount leak in the error path of u32_change()"
Date:   Tue, 24 Dec 2019 10:30:52 +0100
Message-Id: <bc101339ed7c9b6c09946d3d74e089846dae3366.1577179314.git.dcaratti@redhat.com>
In-Reply-To: <cover.1577179314.git.dcaratti@redhat.com>
References: <cover.1577179314.git.dcaratti@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A more generic fix, that preserves the semantic of rule dumping, has been
proposed.

This reverts commit 275c44aa194b7159d1191817b20e076f55f0e620.

Suggested-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/cls_u32.c | 25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 66c6bcec16cb..a0e6fac613de 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -1108,33 +1108,10 @@ static int u32_change(struct net *net, struct sk_=
buff *in_skb,
 	return err;
 }
=20
-static bool u32_hnode_empty(struct tc_u_hnode *ht, bool *non_root_ht)
-{
-	int i;
-
-	if (!ht)
-		return true;
-	if (!ht->is_root) {
-		*non_root_ht =3D true;
-		return false;
-	}
-	if (*non_root_ht)
-		return false;
-	if (ht->refcnt < 2)
-		return true;
-
-	for (i =3D 0; i <=3D ht->divisor; i++) {
-		if (rtnl_dereference(ht->ht[i]))
-			return false;
-	}
-	return true;
-}
-
 static void u32_walk(struct tcf_proto *tp, struct tcf_walker *arg,
 		     bool rtnl_held)
 {
 	struct tc_u_common *tp_c =3D tp->data;
-	bool non_root_ht =3D false;
 	struct tc_u_hnode *ht;
 	struct tc_u_knode *n;
 	unsigned int h;
@@ -1147,8 +1124,6 @@ static void u32_walk(struct tcf_proto *tp, struct t=
cf_walker *arg,
 	     ht =3D rtnl_dereference(ht->next)) {
 		if (ht->prio !=3D tp->prio)
 			continue;
-		if (u32_hnode_empty(ht, &non_root_ht))
-			return;
 		if (arg->count >=3D arg->skip) {
 			if (arg->fn(tp, ht, arg) < 0) {
 				arg->stop =3D 1;
--=20
2.24.1

