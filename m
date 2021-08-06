Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E9A3E2D0D
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 17:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242357AbhHFPAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 11:00:17 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33704 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241958AbhHFPAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 11:00:16 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 214CF60038;
        Fri,  6 Aug 2021 16:59:21 +0200 (CEST)
Date:   Fri, 6 Aug 2021 16:59:54 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH net 3/9] netfilter: conntrack: collect all entries in one
 cycle
Message-ID: <20210806145954.GA1405@salvia>
References: <20210806115207.2976-1-pablo@netfilter.org>
 <20210806115207.2976-4-pablo@netfilter.org>
 <20210806062759.2acb5a47@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <20210806062759.2acb5a47@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Fri, Aug 06, 2021 at 06:27:59AM -0700, Jakub Kicinski wrote:
> On Fri,  6 Aug 2021 13:52:01 +0200 Pablo Neira Ayuso wrote:
> >  		rcu_read_lock();
> >  
> >  		nf_conntrack_get_ht(&ct_hash, &hashsz);
> >  		if (i >= hashsz)
> > -			i = 0;
> > +			break;
> 
> Sparse says there is a missing rcu_read_unlock() here.
> Please follow up on this one.

Right.

I can squash this fix and send another PR or send a follow up patch.

Let me know your preference.

--pf9I7BMVVzbSWLtt
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 3fdcf251ec1f..d31dbccbe7bd 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1377,8 +1377,10 @@ static void gc_worker(struct work_struct *work)
 		rcu_read_lock();
 
 		nf_conntrack_get_ht(&ct_hash, &hashsz);
-		if (i >= hashsz)
+		if (i >= hashsz) {
+			rcu_read_unlock();
 			break;
+		}
 
 		hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[i], hnnode) {
 			struct nf_conntrack_net *cnet;

--pf9I7BMVVzbSWLtt--
