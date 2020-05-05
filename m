Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F40B91C5292
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 12:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbgEEKIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 06:08:18 -0400
Received: from correo.us.es ([193.147.175.20]:57810 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728422AbgEEKIS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 06:08:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2F9E21E2C8C
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 12:08:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1F6051158E8
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 12:08:17 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0FBB111540B; Tue,  5 May 2020 12:08:17 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EBE401158F6;
        Tue,  5 May 2020 12:08:14 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 05 May 2020 12:08:14 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CFA3142EF42D;
        Tue,  5 May 2020 12:08:14 +0200 (CEST)
Date:   Tue, 5 May 2020 12:08:14 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, ecree@solarflare.com
Subject: Re: [PATCH net] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DONT_CARE
Message-ID: <20200505100814.GA29299@salvia>
References: <20200505092159.27269-1-pablo@netfilter.org>
 <20200505094900.GF14398@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505094900.GF14398@nanopsycho.orion>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 11:49:00AM +0200, Jiri Pirko wrote:
> Tue, May 05, 2020 at 11:21:59AM CEST, pablo@netfilter.org wrote:
> >This patch adds FLOW_ACTION_HW_STATS_DONT_CARE which tells the driver
> >that the frontend does not need counters, this hw stats type request
> >never fails. The FLOW_ACTION_HW_STATS_DISABLED type explicitly requests
> >the driver to disable the stats, however, if the driver cannot disable
> >counters, it bails out.
> >
> >Remove BUILD_BUG_ON since TCA_ACT_HW_STATS_* don't map 1:1 with
> >FLOW_ACTION_HW_STATS_* anymore. Add tc_act_hw_stats() to perform the
> >mapping between TCA_ACT_HW_STATS_* and FLOW_ACTION_HW_STATS_*
> >
> >Fixes: 319a1d19471e ("flow_offload: check for basic action hw stats type")
> >Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> >---
> >This is a follow up after "net: flow_offload: skip hw stats check for
> >FLOW_ACTION_HW_STATS_DISABLED". This patch restores the netfilter hardware
> >offloads.
> >
> > include/net/flow_offload.h |  9 ++++++++-
> > net/sched/cls_api.c        | 23 +++++++++++++++++------
> > 2 files changed, 25 insertions(+), 7 deletions(-)
> >
> >diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> >index 3619c6acf60f..0c75163699f0 100644
> >--- a/include/net/flow_offload.h
> >+++ b/include/net/flow_offload.h
> >@@ -164,12 +164,15 @@ enum flow_action_mangle_base {
> > };
> > 
> > enum flow_action_hw_stats_bit {
> >+	FLOW_ACTION_HW_STATS_DISABLED_BIT,
> > 	FLOW_ACTION_HW_STATS_IMMEDIATE_BIT,
> > 	FLOW_ACTION_HW_STATS_DELAYED_BIT,
> > };
> > 
> > enum flow_action_hw_stats {
> >-	FLOW_ACTION_HW_STATS_DISABLED = 0,
> >+	FLOW_ACTION_HW_STATS_DONT_CARE = 0,
> >+	FLOW_ACTION_HW_STATS_DISABLED =
> >+		BIT(FLOW_ACTION_HW_STATS_DISABLED_BIT),
> > 	FLOW_ACTION_HW_STATS_IMMEDIATE =
> > 		BIT(FLOW_ACTION_HW_STATS_IMMEDIATE_BIT),
> > 	FLOW_ACTION_HW_STATS_DELAYED = BIT(FLOW_ACTION_HW_STATS_DELAYED_BIT),
> >@@ -325,7 +328,11 @@ __flow_action_hw_stats_check(const struct flow_action *action,
> > 		return true;
> > 	if (!flow_action_mixed_hw_stats_check(action, extack))
> > 		return false;
> >+
> > 	action_entry = flow_action_first_entry_get(action);
> >+	if (action_entry->hw_stats == FLOW_ACTION_HW_STATS_DONT_CARE)
> >+		return true;
> >+
> > 	if (!check_allow_bit &&
> > 	    action_entry->hw_stats != FLOW_ACTION_HW_STATS_ANY) {
> > 		NL_SET_ERR_MSG_MOD(extack, "Driver supports only default HW stats type \"any\"");
> >diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> >index 55bd1429678f..8ddc16a1ca68 100644
> >--- a/net/sched/cls_api.c
> >+++ b/net/sched/cls_api.c
> >@@ -3523,16 +3523,27 @@ static void tcf_sample_get_group(struct flow_action_entry *entry,
> > #endif
> > }
> > 
> >+static enum flow_action_hw_stats tc_act_hw_stats_array[] = {
> >+	[0]				= FLOW_ACTION_HW_STATS_DISABLED,
> >+	[TCA_ACT_HW_STATS_IMMEDIATE]	= FLOW_ACTION_HW_STATS_IMMEDIATE,
> >+	[TCA_ACT_HW_STATS_DELAYED]	= FLOW_ACTION_HW_STATS_DELAYED,
> >+	[TCA_ACT_HW_STATS_ANY]		= FLOW_ACTION_HW_STATS_ANY,
> 
> TCA_ACT_HW_* are bits. There can be a combination of those according
> to the user request. For 2 bits, it is not problem, but I have a
> patchset in pipes adding another type.
> Then you need to have 1:1 mapping in this array for all bit
> combinations. That is not right.
> 
> How about putting DISABLED to the at the end of enum
> flow_action_hw_stats? They you can just map 0 here to FLOW_ACTION_HW_STATS_DISABLED
> as an exception, but the bits you can take 1:1.

Another possibility is to remove this mapping code is to update tc
UAPI to get it aligned with this update.

This UAPI is only available in the few 5.7.0-rc kernel releases,
I think only developers are using this at this stage?
