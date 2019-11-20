Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C26DB103A4D
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 13:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbfKTMsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 07:48:06 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54659 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727656AbfKTMsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 07:48:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574254085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VSM0//zAQ6TtVcgk7AHWHddInkZkPfwcZtptjWUAQrg=;
        b=BxZ3gKZtypP+w9mRpyOt12skTO33HUnvTLMEAw/e/Uy8j5rlc2oDpB540TjYcEhO8e+bFa
        FKU57OuBv5VLkCFr7iEC4T2FUKwsPg3uz+h+XgTEkLwEE9FMcQ7oUwS9qAwXpPXuktQQu6
        6BjAFuWSUYwO9BKamvDI/92DJWiy4ec=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-GfvgCiYIMjytkV1ZBGooZA-1; Wed, 20 Nov 2019 07:48:01 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 335ED1883525;
        Wed, 20 Nov 2019 12:48:00 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-117-23.ams2.redhat.com [10.36.117.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD1112CA76;
        Wed, 20 Nov 2019 12:47:58 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next v4 1/5] ipv6: add fib6_has_custom_rules() helper
Date:   Wed, 20 Nov 2019 13:47:33 +0100
Message-Id: <a74feb96efb0d6bec9f1f2598f5773991aa39e26.1574252982.git.pabeni@redhat.com>
In-Reply-To: <cover.1574252982.git.pabeni@redhat.com>
References: <cover.1574252982.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: GfvgCiYIMjytkV1ZBGooZA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It wraps the namespace field with the same name, to easily
access it regardless of build options.

Suggested-by: David Ahern <dsahern@gmail.com>
Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/ip6_fib.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 5d1615463138..8ac3a59e5126 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -502,6 +502,11 @@ static inline bool fib6_metric_locked(struct fib6_info=
 *f6i, int metric)
 }
=20
 #ifdef CONFIG_IPV6_MULTIPLE_TABLES
+static inline bool fib6_has_custom_rules(const struct net *net)
+{
+=09return net->ipv6.fib6_has_custom_rules;
+}
+
 int fib6_rules_init(void);
 void fib6_rules_cleanup(void);
 bool fib6_rule_default(const struct fib_rule *rule);
@@ -527,6 +532,10 @@ static inline bool fib6_rules_early_flow_dissect(struc=
t net *net,
 =09return true;
 }
 #else
+static inline bool fib6_has_custom_rules(const struct net *net)
+{
+=09return false;
+}
 static inline int               fib6_rules_init(void)
 {
 =09return 0;
--=20
2.21.0

