Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80DBE10E2C9
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 18:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbfLARlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 12:41:37 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35893 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727167AbfLARlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 12:41:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575222095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cu37UqlX9bUxjwjE4ETNiVqbbu7EyK7rWdl0NhQOf/k=;
        b=Qf95t7Xc3V1ighYbveG+a6TudD7zTPcHbHZPIqAxK49xEbLnlCOSvqPmaEmH8NbKJuU7P8
        6TOqwWWnI16x4Om9D3E0WS5OyxedBQgKHMlE5gKAh8kOOBC0bJahcb2zqWI1VI16HnFoQE
        k00AG9SzXAjReLeGfKvybHjbMeOAZCM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-MEUVtzQYO2iIDPqddlC0vQ-1; Sun, 01 Dec 2019 12:41:34 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92D3F1800D55;
        Sun,  1 Dec 2019 17:41:33 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-204-56.brq.redhat.com [10.40.204.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D84B600C8;
        Sun,  1 Dec 2019 17:41:32 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: [PATCH net v2 2/2] openvswitch: remove another BUG_ON()
Date:   Sun,  1 Dec 2019 18:41:25 +0100
Message-Id: <66e3531bb9e53b50bf9c58de6bd3a92a8c7ca79c.1575221237.git.pabeni@redhat.com>
In-Reply-To: <cover.1575221237.git.pabeni@redhat.com>
References: <cover.1575221237.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: MEUVtzQYO2iIDPqddlC0vQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we can't build the flow del notification, we can simply delete
the flow, no need to crash the kernel. Still keep a WARN_ON to
preserve debuggability.

Note: the BUG_ON() predates the Fixes tag, but this change
can be applied only after the mentioned commit.

v1 -> v2:
 - do not leak an skb on error

Fixes: aed067783e50 ("openvswitch: Minimize ovs_flow_cmd_del critical secti=
on.")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/openvswitch/datapath.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 8cab3435d8da..1047e8043084 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1372,7 +1372,10 @@ static int ovs_flow_cmd_del(struct sk_buff *skb, str=
uct genl_info *info)
 =09=09=09=09=09=09     OVS_FLOW_CMD_DEL,
 =09=09=09=09=09=09     ufid_flags);
 =09=09=09rcu_read_unlock();
-=09=09=09BUG_ON(err < 0);
+=09=09=09if (WARN_ON_ONCE(err < 0)) {
+=09=09=09=09kfree_skb(reply);
+=09=09=09=09goto out_free;
+=09=09=09}
=20
 =09=09=09ovs_notify(&dp_flow_genl_family, reply, info);
 =09=09} else {
@@ -1380,6 +1383,7 @@ static int ovs_flow_cmd_del(struct sk_buff *skb, stru=
ct genl_info *info)
 =09=09}
 =09}
=20
+out_free:
 =09ovs_flow_free(flow, true);
 =09return 0;
 unlock:
--=20
2.21.0

