Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22FCF23C06A
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 22:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgHDUCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 16:02:53 -0400
Received: from correo.us.es ([193.147.175.20]:49468 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726360AbgHDUCt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 16:02:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 19752DA7FC
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 22:02:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0ED1DDA722
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 22:02:47 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F3C31DA8F6; Tue,  4 Aug 2020 22:02:46 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CCEF1DA874;
        Tue,  4 Aug 2020 22:02:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 04 Aug 2020 22:02:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (120.205.137.78.rev.vodafone.pt [78.137.205.120])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id ECBAB4265A32;
        Tue,  4 Aug 2020 22:02:43 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 5/5] netfilter: flowtable: Set offload timeout when adding flow
Date:   Tue,  4 Aug 2020 22:02:08 +0200
Message-Id: <20200804200208.18620-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200804200208.18620-1-pablo@netfilter.org>
References: <20200804200208.18620-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

On heavily loaded systems the GC can take time to go over all existing
conns and reset their timeout. At that time other calls like from
nf_conntrack_in() can call of nf_ct_is_expired() and see the conn as
expired. To fix this when we set the offload bit we should also reset
the timeout instead of counting on GC to finish first iteration over
all conns before the initial timeout.

Fixes: 90964016e5d3 ("netfilter: nf_conntrack: add IPS_OFFLOAD status bit")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index b1eb5272b379..4f7a567c536e 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -243,6 +243,8 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 		return err;
 	}
 
+	nf_ct_offload_timeout(flow->ct);
+
 	if (nf_flowtable_hw_offload(flow_table)) {
 		__set_bit(NF_FLOW_HW, &flow->flags);
 		nf_flow_offload_add(flow_table, flow);
-- 
2.20.1

