Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07EB5175B6E
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 14:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgCBNUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 08:20:21 -0500
Received: from correo.us.es ([193.147.175.20]:44136 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727578AbgCBNUV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 08:20:21 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D8EFA118466
        for <netdev@vger.kernel.org>; Mon,  2 Mar 2020 14:20:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C5E99DA3A4
        for <netdev@vger.kernel.org>; Mon,  2 Mar 2020 14:20:06 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C2FABDA7B2; Mon,  2 Mar 2020 14:20:06 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 82818DA7B6;
        Mon,  2 Mar 2020 14:20:04 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 02 Mar 2020 14:20:04 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4545A42EF9E0;
        Mon,  2 Mar 2020 14:20:04 +0100 (CET)
Date:   Mon, 2 Mar 2020 14:20:16 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        saeedm@mellanox.com, leon@kernel.org, michael.chan@broadcom.com,
        vishal@chelsio.com, jeffrey.t.kirsher@intel.com,
        idosch@mellanox.com, aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, ecree@solarflare.com, mlxsw@mellanox.com,
        netfilter-devel@vger.kernel.org
Subject: Re: [patch net-next v2 01/12] flow_offload: Introduce offload of HW
 stats type
Message-ID: <20200302132016.trhysqfkojgx2snt@salvia>
References: <20200228172505.14386-1-jiri@resnulli.us>
 <20200228172505.14386-2-jiri@resnulli.us>
 <20200229192947.oaclokcpn4fjbhzr@salvia>
 <20200301084443.GQ26061@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200301084443.GQ26061@nanopsycho>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 01, 2020 at 09:44:43AM +0100, Jiri Pirko wrote:
> Sat, Feb 29, 2020 at 08:29:47PM CET, pablo@netfilter.org wrote:
> >On Fri, Feb 28, 2020 at 06:24:54PM +0100, Jiri Pirko wrote:
[...]
> >> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> >> index 4e864c34a1b0..eee1cbc5db3c 100644
> >> --- a/include/net/flow_offload.h
> >> +++ b/include/net/flow_offload.h
> >> @@ -154,6 +154,10 @@ enum flow_action_mangle_base {
> >>  	FLOW_ACT_MANGLE_HDR_TYPE_UDP,
> >>  };
> >>  
> >> +enum flow_action_hw_stats_type {
> >> +	FLOW_ACTION_HW_STATS_TYPE_ANY,
> >> +};
> >> +
> >>  typedef void (*action_destr)(void *priv);
> >>  
> >>  struct flow_action_cookie {
> >> @@ -168,6 +172,7 @@ void flow_action_cookie_destroy(struct flow_action_cookie *cookie);
> >>  
> >>  struct flow_action_entry {
> >>  	enum flow_action_id		id;
> >> +	enum flow_action_hw_stats_type	hw_stats_type;
> >>  	action_destr			destructor;
> >>  	void				*destructor_priv;
> >>  	union {
> >> @@ -228,6 +233,7 @@ struct flow_action_entry {
> >>  };
> >>  
> >>  struct flow_action {
> >> +	bool				mixed_hw_stats_types;
> >
> >Why do you want to place this built-in into the struct flow_action as
> >a boolean?
> 
> Because it is convenient for the driver to know if multiple hw_stats_type
> values are used for multiple actions.
> 
> >You can express the same thing through a new FLOW_ACTION_COUNTER.
[...]
> >Please, explain me why it would be a problem from the driver side to
> >provide a separated counter action.
> 
> I don't see any point in doing that. The action itself implies that has
> stats, you don't need a separate action for that for the flow_offload
> abstraction layer. What you would end up with is:
> counter_action1, actual_action1, counter_action2, actual_action2,...
> 
> What is the point of that?

Yes, it's a bit more work for tc to generate counter action + actual
action.

However, netfilter has two ways to use counters:

1) per-rule counter, in this case the counter is updated after rule
   matching, right before calling the action. This is the legacy mode.

2) explicit counter action, in this case the user specifies explicitly
   that it needs a counter in a given position of the rule. This
   counter might come before or after the actual action.

ethtool does not have counters yet. Now there is a netlink interface
for it, there might be counters there at some point.

I'm suggesting a model that would work for the existing front-ends
using the flow_action API.
