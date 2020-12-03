Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659412CD315
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 11:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729500AbgLCKAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 05:00:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35296 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726082AbgLCKA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 05:00:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606989542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ktRkwU2U6GmjQEu4bll+UnvkpciZyl284XcL4tg/7oM=;
        b=aThkmQwXMhjaU0TbsM9CPKEzqL6Stjvvt/ljCq37nZleum9A4d/ggkai1vMecUEmBMj1wE
        sSmwqJ7l7ZbflIO2y2QVgZurzhM0OVe0YWkuQ1CwesMQMgd7l3suKfibL3JOl3Ze66jzzv
        zCWclJ4/R5u48mEI2nzUP1o4nywBs0U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-PaW4KHSPORyp0UUnnsM19A-1; Thu, 03 Dec 2020 04:58:59 -0500
X-MC-Unique: PaW4KHSPORyp0UUnnsM19A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BE1356BF4;
        Thu,  3 Dec 2020 09:58:47 +0000 (UTC)
Received: from new-host-6.station (unknown [10.40.192.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE48510013C0;
        Thu,  3 Dec 2020 09:58:45 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     gnault@redhat.com, marcelo.leitner@gmail.com,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net] net: skbuff: ensure LSE is pullable before decrementing the MPLS ttl
Date:   Thu,  3 Dec 2020 10:58:21 +0100
Message-Id: <53659f28be8bc336c113b5254dc637cc76bbae91.1606987074.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb_mpls_dec_ttl() reads the LSE without ensuring that it is contained in
the skb "linear" area. Fix this calling pskb_may_pull() before reading the
current ttl.

Found by code inspection.

Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/core/skbuff.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 06c526e0d810..e578544b2cc7 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5786,6 +5786,9 @@ int skb_mpls_dec_ttl(struct sk_buff *skb)
 	if (unlikely(!eth_p_mpls(skb->protocol)))
 		return -EINVAL;
 
+	if (!pskb_may_pull(skb, skb_network_offset(skb) + MPLS_HLEN))
+		return -ENOMEM;
+
 	lse = be32_to_cpu(mpls_hdr(skb)->label_stack_entry);
 	ttl = (lse & MPLS_LS_TTL_MASK) >> MPLS_LS_TTL_SHIFT;
 	if (!--ttl)
-- 
2.28.0

