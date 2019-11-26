Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD3B5109D95
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 13:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbfKZMKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 07:10:49 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28019 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728249AbfKZMKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 07:10:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574770248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yJ1e0U3GFthJRu3GcyqgiNG7PI5JMmiM2pHw+itKE78=;
        b=YHXr0fH4GfGkpcAqU8bRxSv8hZqjYGvn+EMHyXpMo/w9FnRQ7Qu9GltzGYeq/pG08bgCNJ
        zcmLTzW6nSrPFniZGCWTYaV0RMWrmOom6DiaBK9rcEWnCp67jW/vHZOClRIyg3/NjlZxqg
        u9EcojC9gJ0VGz05Kk0pYBeBR1A7lTk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-Q676K3BbNMKS-NcKU8VGzw-1; Tue, 26 Nov 2019 07:10:45 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF0DE1800D6A;
        Tue, 26 Nov 2019 12:10:43 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-191.ams2.redhat.com [10.36.116.191])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C3C35D9CA;
        Tue, 26 Nov 2019 12:10:42 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Pravin B Shelar <pshelar@ovn.org>
Subject: [PATCH net 2/2] openvswitch: remove another BUG_ON()
Date:   Tue, 26 Nov 2019 13:10:30 +0100
Message-Id: <ce4855580a312e982f9394fee6762a31663bbf5e.1574769406.git.pabeni@redhat.com>
In-Reply-To: <cover.1574769406.git.pabeni@redhat.com>
References: <cover.1574769406.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: Q676K3BbNMKS-NcKU8VGzw-1
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

Fixes: aed067783e50 ("openvswitch: Minimize ovs_flow_cmd_del critical secti=
on.")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/openvswitch/datapath.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index e94f675794f1..50656e807c8c 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1346,7 +1346,8 @@ static int ovs_flow_cmd_del(struct sk_buff *skb, stru=
ct genl_info *info)
 =09=09=09=09=09=09     OVS_FLOW_CMD_DEL,
 =09=09=09=09=09=09     ufid_flags);
 =09=09=09rcu_read_unlock();
-=09=09=09BUG_ON(err < 0);
+=09=09=09if (WARN_ON_ONCE(err < 0))
+=09=09=09=09goto out_free;
=20
 =09=09=09ovs_notify(&dp_flow_genl_family, reply, info);
 =09=09} else {
@@ -1354,6 +1355,7 @@ static int ovs_flow_cmd_del(struct sk_buff *skb, stru=
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

