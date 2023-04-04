Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6246D6268
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 15:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234236AbjDDNNQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 4 Apr 2023 09:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234131AbjDDNNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 09:13:15 -0400
Received: from us-smtp-delivery-44.mimecast.com (unknown [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F74D1BE9
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 06:13:14 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-185-9Yy5kL4CO_KUkcEJ8XrD7g-1; Tue, 04 Apr 2023 09:12:55 -0400
X-MC-Unique: 9Yy5kL4CO_KUkcEJ8XrD7g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E962803525;
        Tue,  4 Apr 2023 13:12:54 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.192.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A220B40C83AC;
        Tue,  4 Apr 2023 13:12:53 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Christian Langrock <christian.langrock@secunet.com>,
        Antony Antony <antony.antony@secunet.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH ipsec] xfrm: don't check the default policy if the policy allows the packet
Date:   Tue,  4 Apr 2023 15:12:16 +0200
Message-Id: <0cafbebeba54747b04a72d0fc06aa2ad569f3739.1680613644.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=0.6 required=5.0 tests=RCVD_IN_DNSWL_LOW,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current code doesn't let a simple "allow" policy counteract a
default policy blocking all incoming packets:

    ip x p setdefault in block
    ip x p a src 192.168.2.1/32 dst 192.168.2.2/32 dir in action allow

At this stage, we have an allow policy (with or without transforms)
for this packet. It doesn't matter what the default policy says, since
the policy we looked up lets the packet through. The case of a
blocking policy is already handled separately, so we can remove this
check.

Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/xfrm/xfrm_policy.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 5c61ec04b839..62be042f2ebc 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3712,12 +3712,6 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		}
 		xfrm_nr = ti;
 
-		if (net->xfrm.policy_default[dir] == XFRM_USERPOLICY_BLOCK &&
-		    !xfrm_nr) {
-			XFRM_INC_STATS(net, LINUX_MIB_XFRMINNOSTATES);
-			goto reject;
-		}
-
 		if (npols > 1) {
 			xfrm_tmpl_sort(stp, tpp, xfrm_nr, family);
 			tpp = stp;
-- 
2.38.1

