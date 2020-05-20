Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 483291DB721
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 16:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbgETOdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 10:33:37 -0400
Received: from correo.us.es ([193.147.175.20]:53526 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgETOdh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 10:33:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AAF4112082D
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 16:33:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E544DA70E
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 16:33:32 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 92F09DA710; Wed, 20 May 2020 16:33:32 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AA720DA703;
        Wed, 20 May 2020 16:33:30 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 20 May 2020 16:33:30 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8C0EE42EF42B;
        Wed, 20 May 2020 16:33:30 +0200 (CEST)
Date:   Wed, 20 May 2020 16:33:30 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, jiri@resnulli.us, kuba@kernel.org
Subject: Re: [PATCH net-next v2] net: flow_offload: simplify hw stats check
 handling
Message-ID: <20200520143330.GA23050@salvia>
References: <cf0d731d-cb34-accd-ff40-6be013dd9972@solarflare.com>
 <20200519171923.GA16785@salvia>
 <6013b7ce-48c9-7169-c945-01b2226638e4@solarflare.com>
 <20200519173508.GA17141@salvia>
 <dc732572-6f69-6cbe-5df1-ca4d6e6ed131@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dc732572-6f69-6cbe-5df1-ca4d6e6ed131@solarflare.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 07:26:42PM +0100, Edward Cree wrote:
> On 19/05/2020 18:35, Pablo Neira Ayuso wrote:
[...]
> > Netfilter is a client of this flow offload API, you have to test that
> > your core updates do not break any of existing clients.
>
> Okay, but can we distinguish between "this needs to be tested with
>  netfilter before it can be merged" and "this is breaking netfilter"?
> Or do you have a specific reason why you think this is broken, beyond
>  merely 'it isn't tested'?

This breaks netfilter in two ways !

#1 Drivers calling flow_action_hw_stats_check() fall within the
second branch (check_allow_bit is set on).

        } else if (check_allow_bit &&

@@ -340,11 +342,9 @@ __flow_action_hw_stats_check(const struct flow_action *action,
                return false;

        action_entry = flow_action_first_entry_get(action);
-       if (action_entry->hw_stats == FLOW_ACTION_HW_STATS_DONT_CARE)
-               return true;

        if (!check_allow_bit &&
-           action_entry->hw_stats != FLOW_ACTION_HW_STATS_ANY) {
+           ~action_entry->hw_stats & FLOW_ACTION_HW_STATS_ANY) {
                NL_SET_ERR_MSG_MOD(extack, "Driver supports only default HW stats type \"any\"");
                return false;
        } else if (check_allow_bit &&         <------ HERE

These drivers are not honoring the _DONT_CARE bit,
__flow_action_hw_stats_check() with check_allow_bit set on does not
honor the _DONT_CARE bit.

#2 Your patch needs to update Netfilter to set hw_stats to
   FLOW_ACTION_HW_STATS_DONT_CARE explicitly.
