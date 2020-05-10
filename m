Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 156851CCE8A
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 00:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbgEJW0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 18:26:44 -0400
Received: from correo.us.es ([193.147.175.20]:41784 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729284AbgEJW0o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 18:26:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C77C281409
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 00:26:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B61E996208
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 00:26:42 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AB70C21FE3; Mon, 11 May 2020 00:26:42 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A179BDA736;
        Mon, 11 May 2020 00:26:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 11 May 2020 00:26:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8407342EF4E0;
        Mon, 11 May 2020 00:26:40 +0200 (CEST)
Date:   Mon, 11 May 2020 00:26:40 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Oz Shlomo <ozsh@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: flowtable: Fix expired flow not being
 deleted from software
Message-ID: <20200510222640.GA11645@salvia>
References: <1588764449-12706-1-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <1588764449-12706-1-git-send-email-paulb@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 06, 2020 at 02:27:29PM +0300, Paul Blakey wrote:
> Once a flow is considered expired, it is marked as DYING, and
> scheduled a delete from hardware. The flow will be deleted from
> software, in the next gc_step after hardware deletes the flow
> (and flow is marked DEAD). Till that happens, the flow's timeout
> might be updated from a previous scheduled stats, or software packets
> (refresh). This will cause the gc_step to no longer consider the flow
> expired, and it will not be deleted from software.
> 
> Fix that by looking at the DYING flag as in deciding
> a flow should be deleted from software.

Would this work for you?

The idea is to skip the refresh if this has already expired.

Thanks.

--7JfCtLOvnd9MIVvH
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="expired.patch"

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 4344e572b7f9..862efa7c606d 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -252,10 +252,18 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 }
 EXPORT_SYMBOL_GPL(flow_offload_add);
 
+static inline bool nf_flow_has_expired(const struct flow_offload *flow)
+{
+	return nf_flow_timeout_delta(flow->timeout) <= 0;
+}
+
 void flow_offload_refresh(struct nf_flowtable *flow_table,
 			  struct flow_offload *flow)
 {
-	flow->timeout = nf_flowtable_time_stamp + NF_FLOW_TIMEOUT;
+	if (!nf_flow_has_expired(flow)) {
+		flow->timeout = nf_flowtable_time_stamp + NF_FLOW_TIMEOUT;
+		return;
+	}
 
 	if (likely(!nf_flowtable_hw_offload(flow_table) ||
 		   !test_and_clear_bit(NF_FLOW_HW_REFRESH, &flow->flags)))
@@ -265,11 +273,6 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
 }
 EXPORT_SYMBOL_GPL(flow_offload_refresh);
 
-static inline bool nf_flow_has_expired(const struct flow_offload *flow)
-{
-	return nf_flow_timeout_delta(flow->timeout) <= 0;
-}
-
 static void flow_offload_del(struct nf_flowtable *flow_table,
 			     struct flow_offload *flow)
 {

--7JfCtLOvnd9MIVvH--
