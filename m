Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABD4A123A61
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 00:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfLQXAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 18:00:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59068 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725886AbfLQXAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 18:00:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576623643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AM1+Y/pOYljbKa3FUEoscsdFmXyBzx44eqDa9R4ZE/o=;
        b=CKoLyxhkQHyc0VeKdqzNxycQDXLmVl6ZGYUEewFdibd41yA3rBwS505QS1BXtcvsx2Q2Kj
        ZyXj+1O5h37idPVpZw5J5OdFd36EhH4D9+DB5s+GVkNSVEpDFlj/sNEXdtY5KF31SoZZNK
        j2m85ggRWOm4hGp9RApAguaJrMtC/mY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-PINQKwByNMyu0Z439F6ohA-1; Tue, 17 Dec 2019 18:00:41 -0500
X-MC-Unique: PINQKwByNMyu0Z439F6ohA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18F4E800596;
        Tue, 17 Dec 2019 23:00:40 +0000 (UTC)
Received: from new-host-5.redhat.com (ovpn-204-91.brq.redhat.com [10.40.204.91])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AFF3660C18;
        Tue, 17 Dec 2019 23:00:37 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Vlad Buslov <vladbu@mellanox.com>, Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net 1/2] net/sched: cls_u32: fix refcount leak in the error path of u32_change()
Date:   Wed, 18 Dec 2019 00:00:04 +0100
Message-Id: <ae83c6dc89f8642166dc32debc6ea7444eb3671d.1576623250.git.dcaratti@redhat.com>
In-Reply-To: <cover.1576623250.git.dcaratti@redhat.com>
References: <cover.1576623250.git.dcaratti@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

when users replace cls_u32 filters with new ones having wrong parameters,
so that u32_change() fails to validate them, the kernel doesn't roll-back
correctly, and leaves semi-configured rules.

Fix this in u32_walk(), avoiding a call to the walker function on filters
that don't have a match rule connected. The side effect is, these "empty"
filters are not even dumped when present; but that shouldn't be a problem
as long as we are restoring the original behaviour, where semi-configured
filters were not even added in the error path of u32_change().

Fixes: 6676d5e416ee ("net: sched: set dedicated tcf_walker flag when tp i=
s empty")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/cls_u32.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index a0e6fac613de..66c6bcec16cb 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -1108,10 +1108,33 @@ static int u32_change(struct net *net, struct sk_=
buff *in_skb,
 	return err;
 }
=20
+static bool u32_hnode_empty(struct tc_u_hnode *ht, bool *non_root_ht)
+{
+	int i;
+
+	if (!ht)
+		return true;
+	if (!ht->is_root) {
+		*non_root_ht =3D true;
+		return false;
+	}
+	if (*non_root_ht)
+		return false;
+	if (ht->refcnt < 2)
+		return true;
+
+	for (i =3D 0; i <=3D ht->divisor; i++) {
+		if (rtnl_dereference(ht->ht[i]))
+			return false;
+	}
+	return true;
+}
+
 static void u32_walk(struct tcf_proto *tp, struct tcf_walker *arg,
 		     bool rtnl_held)
 {
 	struct tc_u_common *tp_c =3D tp->data;
+	bool non_root_ht =3D false;
 	struct tc_u_hnode *ht;
 	struct tc_u_knode *n;
 	unsigned int h;
@@ -1124,6 +1147,8 @@ static void u32_walk(struct tcf_proto *tp, struct t=
cf_walker *arg,
 	     ht =3D rtnl_dereference(ht->next)) {
 		if (ht->prio !=3D tp->prio)
 			continue;
+		if (u32_hnode_empty(ht, &non_root_ht))
+			return;
 		if (arg->count >=3D arg->skip) {
 			if (arg->fn(tp, ht, arg) < 0) {
 				arg->stop =3D 1;
--=20
2.23.0

