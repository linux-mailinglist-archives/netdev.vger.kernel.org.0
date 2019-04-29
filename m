Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF9A1E616
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 17:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbfD2PVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 11:21:33 -0400
Received: from mail.us.es ([193.147.175.20]:34836 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728253AbfD2PVc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 11:21:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DB3FC1878A0
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 17:21:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CACE7DA712
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 17:21:30 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BF01EDA70E; Mon, 29 Apr 2019 17:21:30 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AA2A2DA702;
        Mon, 29 Apr 2019 17:21:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 29 Apr 2019 17:21:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 844EA4265A32;
        Mon, 29 Apr 2019 17:21:28 +0200 (CEST)
Date:   Mon, 29 Apr 2019 17:21:28 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: TC stats / hw offload question
Message-ID: <20190429152128.4mbqyipjv25jiiko@salvia>
References: <26f0cfc9-3bef-8579-72cc-aa6c5ccecd43@solarflare.com>
 <4cb765dd-453f-3139-bce6-6e0b31167aec@mojatatu.com>
 <ec4092a6-196d-7eca-04be-0654e762c0b2@solarflare.com>
 <20190424141139.5c5vhihie5mryxlt@salvia>
 <26afcaaf-abdf-42ad-1715-5af9c6f3c2ef@solarflare.com>
 <58c74d0f-b92e-31f9-9828-24fb04129534@solarflare.com>
 <20190425223346.zqfadtphmhuj7ohp@salvia>
 <e09faf92-c947-5b98-78d3-a37a28c0fc59@solarflare.com>
 <20190426184943.idewf2rqebvslcva@salvia>
 <97133878-8e78-287b-9854-431b116b0788@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <97133878-8e78-287b-9854-431b116b0788@solarflare.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 03:11:06PM +0100, Edward Cree wrote:
> On 26/04/2019 19:49, Pablo Neira Ayuso wrote:
> > On Fri, Apr 26, 2019 at 01:13:41PM +0100, Edward Cree wrote:
> >> Thus if (and only if) two TC actions have the same tcfa_index, they will
> >>  share a single counter in the HW.
> >> I gathered from a previous conversation with Jamal[1] that that was the
> >>  correct behaviour:
> >>> Note, your counters should also be shareable; example, count all
> >>> the drops in one counter across multiple flows as in the following
> >>> case where counter index 1 is used.
> >>>
> >>> tc flower match foo action drop index 1
> >>> tc flower match bar action drop index 1
> > The flow_action_entry structure needs a new 'counter_index' field to
> > store this. The tc_setup_flow_action() function needs to be updated
> > for this for the FLOW_ACTION_{ACCEPT,DROP,REDIRECT,MIRRED} cases to
> > set this entry->counter_index field to tcfa_index, so the driver has
> > access to this.
> Hmm, I'm still not sure this solves everything.
> Before, we could write
> tc flower match foo \
>     action mirred egress mirror eth1 index 1 \
>     action mirred egress redirect eth2 index 2
> and have two distinct HW counters (one of which might e.g. be shared
>  with another rule).  But when reading those counters, under
>  fl_hw_update_stats(), the driver only gets to return one set of flow
>  stats for both actions.
> Previously, the driver's TC_CLSFLOWER_STATS handler was updating the
>  action stats directly, so was able to do something different for each
>  action, but that's not possible in 5.1.  At stats gathering time, the
>  driver doesn't even have access to anything that's per-action and
>  thus could have a flow_stats member shoved in it.
> AFAICT, the only reason this isn't a regression is that existing
>  drivers didn't implement the old semantics correctly.
>
> This is a bit of a mess; the best idea I've got is for the
>  TC_CLSFLOWER_STATS call to include a tcfa_index.  Then the driver
>  returns counter stats for that index, and tcf_exts_stats_update()
>  only updates those actions whose index matches.  But then
>  fl_hw_update_stats() would have to iterate over all the indices in
>  f->exts.  What do you think?

You could extend struct flow_stats to pass an array of stats to the
driver, including one stats per action and the counter index. Then,
tcf_exts_stats_update() uses this array of stats to update per-action
stats.

struct flow_action_stats {
        u32     counter_index;
        u64     pkts;
        u64     bytes;
        u64     lastused;
};

struct flow_stats {
        struct flow_action_stats        *stats[];
        u32                             num_actions;
};

As you mentioned, no driver supports for tcfa_index so far, probably
it would be a good idea to return -EOPNOTSUPP in such case by now.
