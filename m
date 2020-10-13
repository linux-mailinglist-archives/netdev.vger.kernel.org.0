Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B759328CE98
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 14:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbgJMMof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 08:44:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57621 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727997AbgJMMoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 08:44:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602593073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ck6+Am9W1EuayWHCkPDoXqwtaZRm0o4xLKaqnT4Ptj4=;
        b=LMoe7LYuf8bUlQRD1iW56Y9Dkk5MFvc+JMUmwjLM3SvmgwBZZavf95HkmtFS75mMazASoh
        vhLRZoeODTkQnKc/zIJLqG6DU+7u37tQv9tKbupox5WICJPyt3PuzFak50fRxWfxiKYBEc
        nz0CCNltE9PKk4C+Nnn8i/6otOndAqI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-cqd1ECAQMdWmUycE_xKjKg-1; Tue, 13 Oct 2020 08:44:28 -0400
X-MC-Unique: cqd1ECAQMdWmUycE_xKjKg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83593101963A;
        Tue, 13 Oct 2020 12:44:26 +0000 (UTC)
Received: from ebuild.redhat.com (ovpn-115-99.ams2.redhat.com [10.36.115.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6850576643;
        Tue, 13 Oct 2020 12:44:24 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        pabeni@redhat.com, pshelar@ovn.org, jlelli@redhat.com,
        bigeasy@linutronix.de
Subject: [PATCH net-next] net: openvswitch: fix to make sure flow_lookup() is not preempted
Date:   Tue, 13 Oct 2020 14:44:19 +0200
Message-Id: <160259304349.181017.7492443293310262978.stgit@ebuild>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The flow_lookup() function uses per CPU variables, which must not be
preempted. However, this is fine in the general napi use case where
the local BH is disabled. But, it's also called in the netlink
context, which is preemptible. The below patch makes sure that even
in the netlink path, preemption is disabled.

Fixes: eac87c413bf9 ("net: openvswitch: reorder masks array based on usage")
Reported-by: Juri Lelli <jlelli@redhat.com>
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
 net/openvswitch/flow_table.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 87c286ad660e..16289386632b 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -850,9 +850,17 @@ struct sw_flow *ovs_flow_tbl_lookup(struct flow_table *tbl,
 	struct mask_array *ma = rcu_dereference_ovsl(tbl->mask_array);
 	u32 __always_unused n_mask_hit;
 	u32 __always_unused n_cache_hit;
+	struct sw_flow *flow;
 	u32 index = 0;
 
-	return flow_lookup(tbl, ti, ma, key, &n_mask_hit, &n_cache_hit, &index);
+	/* This function gets called trough the netlink interface and therefore
+	 * is preemptible. However, flow_lookup() function needs to be called
+	 * with preemption disabled due to CPU specific variables.
+	 */
+	preempt_disable();
+	flow = flow_lookup(tbl, ti, ma, key, &n_mask_hit, &n_cache_hit, &index);
+	preempt_enable();
+	return flow;
 }
 
 struct sw_flow *ovs_flow_tbl_lookup_exact(struct flow_table *tbl,

