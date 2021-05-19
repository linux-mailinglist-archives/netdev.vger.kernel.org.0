Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92534388ED0
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 15:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353566AbhESNS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 09:18:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38002 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353567AbhESNS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 09:18:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621430257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5xGoW0sQmN2+4AkZIpjJRvWuIAR8Jhtu1s2gRKZpOiA=;
        b=L75yHFm0H62/tRDNbEk6bM9HEETI7cB06kB/4G0LIen1IsOJDTM4VS5vCNv0rWGYKGtZVL
        sSUZHk/mGoiPWbtQZt45djcmjLvhWHbtFcbFr4pBxXMkkSmv5329oHkO5tKyrH1EhuSgeX
        KYse/U19OERytThsJTjiXWH0UJjAfzE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-NuURTXVTP4il-U8puveKhA-1; Wed, 19 May 2021 09:17:35 -0400
X-MC-Unique: NuURTXVTP4il-U8puveKhA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7DAE0107ACCA;
        Wed, 19 May 2021 13:17:33 +0000 (UTC)
Received: from dcaratti.users.ipa.redhat.com (unknown [10.40.195.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3BFC6E14A;
        Wed, 19 May 2021 13:17:31 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net-next] net/sched: cls_api: increase max_reclassify_loop
Date:   Wed, 19 May 2021 15:17:21 +0200
Message-Id: <3ab4c68503a3e3e1b4f11a0c0900b872cfc806f6.1621426820.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

modern userspace applications, like OVN, can configure the TC datapath to
"recirculate" packets several times. If more than 4 "recirculation" rules
are configured, packets can be dropped by __tcf_classify().
Changing the maximum number of reclassifications (from 4 to 16) should be
sufficient to prevent drops in most use cases, and guard against loops at
the same time.

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/cls_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 40fbea626dfd..75e3a288a7c8 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1531,7 +1531,7 @@ static inline int __tcf_classify(struct sk_buff *skb,
 				 u32 *last_executed_chain)
 {
 #ifdef CONFIG_NET_CLS_ACT
-	const int max_reclassify_loop = 4;
+	const int max_reclassify_loop = 16;
 	const struct tcf_proto *first_tp;
 	int limit = 0;
 
-- 
2.31.1

