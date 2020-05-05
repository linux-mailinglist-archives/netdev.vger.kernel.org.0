Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177701C6122
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 21:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbgEETgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 15:36:39 -0400
Received: from correo.us.es ([193.147.175.20]:36808 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728609AbgEETgj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 15:36:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E2FAED2DA17
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 21:36:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D5218115410
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 21:36:37 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CF1312135D; Tue,  5 May 2020 21:36:37 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D2A6C1158E2;
        Tue,  5 May 2020 21:36:35 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 05 May 2020 21:36:35 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B215942EE38E;
        Tue,  5 May 2020 21:36:35 +0200 (CEST)
Date:   Tue, 5 May 2020 21:36:35 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, ecree@solarflare.com,
        idosch@mellanox.com
Subject: Re: [PATCH net,v2] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DONT_CARE
Message-ID: <20200505193635.GA13114@salvia>
References: <20200505174736.29414-1-pablo@netfilter.org>
 <20200505183643.GI14398@nanopsycho.orion>
 <20200505114616.221fc9af@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505114616.221fc9af@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 11:46:16AM -0700, Jakub Kicinski wrote:
> On Tue, 5 May 2020 20:36:43 +0200 Jiri Pirko wrote:
> > Tue, May 05, 2020 at 07:47:36PM CEST, pablo@netfilter.org wrote:
> > >This patch adds FLOW_ACTION_HW_STATS_DONT_CARE which tells the driver
> > >that the frontend does not need counters, this hw stats type request
> > >never fails. The FLOW_ACTION_HW_STATS_DISABLED type explicitly requests
> > >the driver to disable the stats, however, if the driver cannot disable
> > >counters, it bails out.
> > >
> > >TCA_ACT_HW_STATS_* maintains the 1:1 mapping with FLOW_ACTION_HW_STATS_*
> > >except by disabled which is mapped to FLOW_ACTION_HW_STATS_DISABLED
> > >(this is 0 in tc). Add tc_act_hw_stats() to perform the mapping between
> > >TCA_ACT_HW_STATS_* and FLOW_ACTION_HW_STATS_*.
> > >
> > >Fixes: 319a1d19471e ("flow_offload: check for basic action hw stats type")
> > >Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>  
> > 
> > Looks great. Thanks!
> > 
> > Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> 
> Is this going to "just work" for mlxsw?
> 
>         act = flow_action_first_entry_get(flow_action);                         
>         if (act->hw_stats == FLOW_ACTION_HW_STATS_ANY ||                        
>             act->hw_stats == FLOW_ACTION_HW_STATS_IMMEDIATE) {                  
>                 /* Count action is inserted first */                            
>                 err = mlxsw_sp_acl_rulei_act_count(mlxsw_sp, rulei, extack);    
>                 if (err)                                                        
>                         return err;                                             
>         } else if (act->hw_stats != FLOW_ACTION_HW_STATS_DISABLED) {            
>                 NL_SET_ERR_MSG_MOD(extack, "Unsupported action HW stats type"); 
>                 return -EOPNOTSUPP;                                             
>         }
> 
> if hw_stats is 0 we'll get into the else and bail.
> 
> That doesn't deliver on the "don't care" promise, no?

I can send a v3 to handle the _DONT_CARE type from the mlxsw.

Thank you.
