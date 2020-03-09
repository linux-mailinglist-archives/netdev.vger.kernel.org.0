Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1909517E73E
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 19:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbgCISdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 14:33:31 -0400
Received: from correo.us.es ([193.147.175.20]:33388 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727334AbgCISda (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 14:33:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 607054A7069
        for <netdev@vger.kernel.org>; Mon,  9 Mar 2020 19:33:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 527D2DA3AE
        for <netdev@vger.kernel.org>; Mon,  9 Mar 2020 19:33:08 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 473F3DA38D; Mon,  9 Mar 2020 19:33:08 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6E3A8DA3A9;
        Mon,  9 Mar 2020 19:33:06 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 09 Mar 2020 19:33:06 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4FB1042EE38E;
        Mon,  9 Mar 2020 19:33:06 +0100 (CET)
Date:   Mon, 9 Mar 2020 19:33:25 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: Re: [patch net-next] flow_offload: use flow_action_for_each in
 flow_action_mixed_hw_stats_types_check()
Message-ID: <20200309183325.yw2c4swbwv7xqlm2@salvia>
References: <20200309174447.6352-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309174447.6352-1-jiri@resnulli.us>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 09, 2020 at 06:44:47PM +0100, Jiri Pirko wrote:
> Instead of manually iterating over entries, use flow_action_for_each
> helper. Move the helper and wrap it to fit to 80 cols on the way.
> 
> Signed-off-by: Jiri Pirko <jiri@resnulli.us>
> ---
>  include/net/flow_offload.h | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 64807aa03cee..7b7bd9215156 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -256,6 +256,11 @@ static inline bool flow_offload_has_one_action(const struct flow_action *action)
>  	return action->num_entries == 1;
>  }
>  
> +#define flow_action_for_each(__i, __act, __actions)			\
> +        for (__i = 0, __act = &(__actions)->entries[0];			\
> +	     __i < (__actions)->num_entries;				\
> +	     __act = &(__actions)->entries[++__i])
> +
>  static inline bool
>  flow_action_mixed_hw_stats_types_check(const struct flow_action *action,
>  				       struct netlink_ext_ack *extack)
> @@ -267,7 +272,7 @@ flow_action_mixed_hw_stats_types_check(const struct flow_action *action,
>  	if (flow_offload_has_one_action(action))
>  		return true;
>  
> -	for (i = 0; i < action->num_entries; i++) {
> +	flow_action_for_each(i, action_entry, action) {
>  		action_entry = &action->entries[i];
                ^^^

action_entry is set twice, right? One from flow_action_for_each() and
again here. You can probably remove this line too.
