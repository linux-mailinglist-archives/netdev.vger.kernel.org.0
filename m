Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400B91CD934
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgEKL7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 07:59:47 -0400
Received: from correo.us.es ([193.147.175.20]:36582 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729909AbgEKL7n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 07:59:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AC9E818CDC5
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 13:59:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9BB081158E3
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 13:59:41 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 91272115416; Mon, 11 May 2020 13:59:41 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8D021520FB;
        Mon, 11 May 2020 13:59:39 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 11 May 2020 13:59:39 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6EBB342EF52A;
        Mon, 11 May 2020 13:59:39 +0200 (CEST)
Date:   Mon, 11 May 2020 13:59:39 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Oz Shlomo <ozsh@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: flowtable: Add pending bit for offload
 work
Message-ID: <20200511115939.GA19979@salvia>
References: <1588764279-12166-1-git-send-email-paulb@mellanox.com>
 <20200510221434.GA11226@salvia>
 <9dff92fe-15cd-348d-ff1c-7a102ea9263c@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9dff92fe-15cd-348d-ff1c-7a102ea9263c@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 11:32:36AM +0300, Paul Blakey wrote:
> On 5/11/2020 1:14 AM, Pablo Neira Ayuso wrote:
[...]
> >> @@ -831,9 +832,14 @@ static void flow_offload_queue_work(struct flow_offload_work *offload)
> >>  {
> >>  	struct flow_offload_work *offload;
> >>  
> >> +	if (test_and_set_bit(NF_FLOW_HW_PENDING, &flow->flags))
> >> +		return NULL;
> > In case of stats, it's fine to lose work.
> >
> > But how does this work for the deletion case? Does this falls back to
> > the timeout deletion?
> 
> We get to nf_flow_table_offload_del (delete) in these cases:
> 
> >-------if (nf_flow_has_expired(flow) || nf_ct_is_dying(flow->ct) ||
> >-------    test_bit(NF_FLOW_TEARDOWN, &flow->flags) {
> >------->-------   ....
> >------->-------    nf_flow_offload_del(flow_table, flow);
> 
> Which are all persistent once set but the nf_flow_has_expired(flow). So we will
> try the delete
> again and again till pending flag is unset or the flow is 'saved' by the already
> queued stats updating the timeout.
> A pending stats update can't save the flow once it's marked for teardown or
> (flow->ct is dying), only delay it.

Thanks for explaining.

> We didn't mention flush, like in table free. I guess we need to flush the
> hardware workqueue
> of any pending stats work, then queue the deletion, and flush again:
> Adding nf_flow_table_offload_flush(flow_table), after
> cancel_delayed_work_sync(&flow_table->gc_work);

The "flush" makes sure that stats work runs before the deletion, to
ensure no races happen for in-transit work objects, right?

We might use alloc_ordered_workqueue() and let the workqueue handle
this problem?
