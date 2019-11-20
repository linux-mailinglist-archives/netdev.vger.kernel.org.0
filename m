Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06502103A52
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 13:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbfKTMvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 07:51:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27059 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727644AbfKTMvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 07:51:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574254264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hGSsru7r/Yt0kdvDUif5Q+0imbkrme7kaYWVOm1idJM=;
        b=OJbHKrM+vAS+iKPnfAU/Y0gnbgGmE1ydk9p17WXc3C4+cJnluvCBYu1NSIpB64zspl02pm
        PxyehFWjHxc9kz3jXIQleSz0bSX+qPbjDMffHLEfa3r3c2IqNqdNUBGXzkkDquxvPIfdnl
        XXf4g/biew8HqAnZR8EieBhPCDEVI7U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-I6XeLJhON5OEBep-CLlEhA-1; Wed, 20 Nov 2019 07:48:06 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 844A1803422;
        Wed, 20 Nov 2019 12:48:05 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-117-23.ams2.redhat.com [10.36.117.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 195DB2CA76;
        Wed, 20 Nov 2019 12:48:03 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next v4 4/5] ipv4: move fib4_has_custom_rules() helper to public header
Date:   Wed, 20 Nov 2019 13:47:36 +0100
Message-Id: <33bda5a0251f1a95a5d730b412f7f3f9fd137d03.1574252982.git.pabeni@redhat.com>
In-Reply-To: <cover.1574252982.git.pabeni@redhat.com>
References: <cover.1574252982.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: I6XeLJhON5OEBep-CLlEhA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So that we can use it in the next patch.
Additionally constify the helper argument.

Suggested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/ip_fib.h    | 10 ++++++++++
 net/ipv4/fib_frontend.c | 10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 52b2406a5dfc..b9cba41c6d4f 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -311,6 +311,11 @@ static inline int fib_lookup(struct net *net, const st=
ruct flowi4 *flp,
 =09return err;
 }
=20
+static inline bool fib4_has_custom_rules(const struct net *net)
+{
+=09return false;
+}
+
 static inline bool fib4_rule_default(const struct fib_rule *rule)
 {
 =09return true;
@@ -378,6 +383,11 @@ static inline int fib_lookup(struct net *net, struct f=
lowi4 *flp,
 =09return err;
 }
=20
+static inline bool fib4_has_custom_rules(const struct net *net)
+{
+=09return net->ipv4.fib_has_custom_rules;
+}
+
 bool fib4_rule_default(const struct fib_rule *rule);
 int fib4_rules_dump(struct net *net, struct notifier_block *nb,
 =09=09    struct netlink_ext_ack *extack);
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 71c78d223dfd..577db1d50a24 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -70,11 +70,6 @@ static int __net_init fib4_rules_init(struct net *net)
 =09fib_free_table(main_table);
 =09return -ENOMEM;
 }
-
-static bool fib4_has_custom_rules(struct net *net)
-{
-=09return false;
-}
 #else
=20
 struct fib_table *fib_new_table(struct net *net, u32 id)
@@ -131,11 +126,6 @@ struct fib_table *fib_get_table(struct net *net, u32 i=
d)
 =09}
 =09return NULL;
 }
-
-static bool fib4_has_custom_rules(struct net *net)
-{
-=09return net->ipv4.fib_has_custom_rules;
-}
 #endif /* CONFIG_IP_MULTIPLE_TABLES */
=20
 static void fib_replace_table(struct net *net, struct fib_table *old,
--=20
2.21.0

