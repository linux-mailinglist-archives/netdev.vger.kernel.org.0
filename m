Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8292E1CD42B
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 10:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbgEKImt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 04:42:49 -0400
Received: from correo.us.es ([193.147.175.20]:37968 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728471AbgEKImt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 04:42:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E88E4EBAE8
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 10:42:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D814D1158E8
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 10:42:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D48461158E3; Mon, 11 May 2020 10:42:45 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 495A34EA8F;
        Mon, 11 May 2020 10:42:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 11 May 2020 10:42:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2995242EF42D;
        Mon, 11 May 2020 10:42:44 +0200 (CEST)
Date:   Mon, 11 May 2020 10:42:43 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Oz Shlomo <ozsh@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: flowtable: Fix expired flow not being
 deleted from software
Message-ID: <20200511084243.GA18188@salvia>
References: <1588764449-12706-1-git-send-email-paulb@mellanox.com>
 <20200510222640.GA11645@salvia>
 <a420c22a-9d52-c314-cf9b-ee19831e15a7@mellanox.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <a420c22a-9d52-c314-cf9b-ee19831e15a7@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 11, 2020 at 10:24:44AM +0300, Paul Blakey wrote:
> 
> 
> On 5/11/2020 1:26 AM, Pablo Neira Ayuso wrote:
> > On Wed, May 06, 2020 at 02:27:29PM +0300, Paul Blakey wrote:
> >> Once a flow is considered expired, it is marked as DYING, and
> >> scheduled a delete from hardware. The flow will be deleted from
> >> software, in the next gc_step after hardware deletes the flow
> >> (and flow is marked DEAD). Till that happens, the flow's timeout
> >> might be updated from a previous scheduled stats, or software packets
> >> (refresh). This will cause the gc_step to no longer consider the flow
> >> expired, and it will not be deleted from software.
> >>
> >> Fix that by looking at the DYING flag as in deciding
> >> a flow should be deleted from software.
> > Would this work for you?
> >
> > The idea is to skip the refresh if this has already expired.
> >
> > Thanks.
> 
> The idea is ok, but timeout check + update isn't atomic (need atomic_inc_unlesss
> or something like that), and there is also
> the hardware stats which if comes too late (after gc finds it expired) might
> bring a flow back to life.

Right. Once the entry has expired, there should not be a way turning
back.

I'm attaching a new sketch, it's basically using the teardown state to
specify that the gc already made the decision to remove this entry.

Thanks.

--ZPt4rx8FFjLCG7dd
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 4344e572b7f9..42da6e337276 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -284,7 +284,7 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 
 	if (nf_flow_has_expired(flow))
 		flow_offload_fixup_ct(flow->ct);
-	else if (test_bit(NF_FLOW_TEARDOWN, &flow->flags))
+	else
 		flow_offload_fixup_ct_timeout(flow->ct);
 
 	flow_offload_free(flow);
@@ -361,8 +361,10 @@ static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
 {
 	struct nf_flowtable *flow_table = data;
 
-	if (nf_flow_has_expired(flow) || nf_ct_is_dying(flow->ct) ||
-	    test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
+	if (nf_flow_has_expired(flow) || nf_ct_is_dying(flow->ct))
+		set_bit(NF_FLOW_TEARDOWN, &flow->flags);
+
+	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
 		if (test_bit(NF_FLOW_HW, &flow->flags)) {
 			if (!test_bit(NF_FLOW_HW_DYING, &flow->flags))
 				nf_flow_offload_del(flow_table, flow);

--ZPt4rx8FFjLCG7dd--
