Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B4D1B0626
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 12:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgDTKDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 06:03:45 -0400
Received: from correo.us.es ([193.147.175.20]:60534 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725865AbgDTKDp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 06:03:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F1C656DFE0
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 12:03:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E1B9252AED
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 12:03:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D2A90DA3C2; Mon, 20 Apr 2020 12:03:43 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E31A820675;
        Mon, 20 Apr 2020 12:03:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 20 Apr 2020 12:03:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C4C8B42EE393;
        Mon, 20 Apr 2020 12:03:41 +0200 (CEST)
Date:   Mon, 20 Apr 2020 12:03:41 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DISABLED
Message-ID: <20200420100341.6qehcgz66wq4ysax@salvia>
References: <20200419115338.659487-1-pablo@netfilter.org>
 <20200420080200.GA6581@nanopsycho.orion>
 <20200420090505.pr6wsunozfh7afaj@salvia>
 <20200420091302.GB6581@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420091302.GB6581@nanopsycho.orion>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 11:13:02AM +0200, Jiri Pirko wrote:
> Mon, Apr 20, 2020 at 11:05:05AM CEST, pablo@netfilter.org wrote:
> >On Mon, Apr 20, 2020 at 10:02:00AM +0200, Jiri Pirko wrote:
> >> Sun, Apr 19, 2020 at 01:53:38PM CEST, pablo@netfilter.org wrote:
> >> >If the frontend requests no stats through FLOW_ACTION_HW_STATS_DISABLED,
> >> >drivers that are checking for the hw stats configuration bail out with
> >> >EOPNOTSUPP.
> >>
> >> Wait, that was a point. Driver has to support stats disabling.
> >
> >Hm, some drivers used to accept FLOW_ACTION_HW_STATS_DISABLED, now
> >rulesets that used to work don't work anymore.
>
> How? This check is here since the introduction of hw stats types.

Netfilter is setting the counter support to
FLOW_ACTION_HW_STATS_DISABLED in this example below:

  table netdev filter {
        chain ingress {
                type filter hook ingress device eth0 priority 0; flags offload;

                tcp dport 22 drop
        }
  }

The user did not specify a counter in this case.

I think __flow_action_hw_stats_check() cannot work with
FLOW_ACTION_HW_STATS_DISABLED.

If check_allow_bit is false and FLOW_ACTION_HW_STATS_DISABLED is
specified, then this always evaluates true:

        if (!check_allow_bit &&
            action_entry->hw_stats != FLOW_ACTION_HW_STATS_ANY) {

Similarly:

        } else if (check_allow_bit &&
                   !(action_entry->hw_stats & BIT(allow_bit))) {

evaluates true for FLOW_ACTION_HW_STATS_DISABLED, assuming allow_bit is
set, which I think it is the intention.

Another suggestion: This is control plane code and this
__flow_action_hw_stats_check() function is relatively large, I'd suggest
to move it to net/core/flow_offload.c at some point.

Thank you!
