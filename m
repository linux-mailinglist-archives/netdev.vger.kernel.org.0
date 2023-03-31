Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6156D215C
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 15:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbjCaNSw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 31 Mar 2023 09:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbjCaNSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 09:18:48 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D84C16D
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 06:18:46 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-272-LTg7wiazNiK55hJVLLO6Uw-1; Fri, 31 Mar 2023 09:18:42 -0400
X-MC-Unique: LTg7wiazNiK55hJVLLO6Uw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 003A73C0F239;
        Fri, 31 Mar 2023 13:18:42 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.192.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1978D2166B33;
        Fri, 31 Mar 2023 13:18:40 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        Sabrina Dubroca <sd@queasysnail.net>, nicolas.dichtel@6wind.com
Subject: [PATCH iproute2] ip-xfrm: accept "allow" as action in ip xfrm policy setdefault
Date:   Fri, 31 Mar 2023 15:18:25 +0200
Message-Id: <dc8c3fcd81a212e47547ae59ee6857ce25048ddd.1680268153.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-0.7 required=5.0 tests=RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The help text claims that setdefault takes ACTION values, ie block |
allow. In reality, xfrm_str_to_policy takes block | accept.

We could also fix that by changing the help text/manpage, but then
it'd be frustrating to have multiple ACTION with similar values used
in different subcommands.

I'm not changing the output in xfrm_policy_to_str because some
userspace somewhere probably depends on the "accept" value.

Fixes: 76b30805f9f6 ("xfrm: enable to manage default policies")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 ip/xfrm_policy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ip/xfrm_policy.c b/ip/xfrm_policy.c
index be2235ca949d..8687ced35a25 100644
--- a/ip/xfrm_policy.c
+++ b/ip/xfrm_policy.c
@@ -1141,7 +1141,8 @@ static int xfrm_str_to_policy(char *name, uint8_t *policy)
 	if (strcmp(name, "block") == 0) {
 		*policy = XFRM_USERPOLICY_BLOCK;
 		return 0;
-	} else if (strcmp(name, "accept") == 0) {
+	} else if (strcmp(name, "accept") == 0 ||
+		   strcmp(name, "allow") == 0) {
 		*policy = XFRM_USERPOLICY_ACCEPT;
 		return 0;
 	}
-- 
2.38.1

