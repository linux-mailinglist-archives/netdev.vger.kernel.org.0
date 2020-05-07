Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B60C1C9533
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 17:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgEGPg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 11:36:28 -0400
Received: from correo.us.es ([193.147.175.20]:56432 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725969AbgEGPg2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 11:36:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 61F4CEB46E
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 17:36:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 52EB01158F3
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 17:36:26 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 46EA71158ED; Thu,  7 May 2020 17:36:26 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 46DB911540B;
        Thu,  7 May 2020 17:36:24 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 07 May 2020 17:36:24 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2402D42EF4E0;
        Thu,  7 May 2020 17:36:24 +0200 (CEST)
Date:   Thu, 7 May 2020 17:36:23 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, jiri@resnulli.us, kuba@kernel.org
Subject: Re: [RFC PATCH net] net: flow_offload: simplify hw stats check
 handling
Message-ID: <20200507153623.GA10305@salvia>
References: <49176c41-3696-86d9-f0eb-c20207cd6d23@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49176c41-3696-86d9-f0eb-c20207cd6d23@solarflare.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 07, 2020 at 03:59:09PM +0100, Edward Cree wrote:
[...]
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
> index 890b078851c9..1f0caeae24e1 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
> @@ -30,14 +30,14 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
>  		return -EOPNOTSUPP;
>  
>  	act = flow_action_first_entry_get(flow_action);
> -	if (act->hw_stats == FLOW_ACTION_HW_STATS_ANY ||
> -	    act->hw_stats == FLOW_ACTION_HW_STATS_IMMEDIATE) {
> +	if (act->hw_stats & FLOW_ACTION_HW_STATS_DISABLED) {
> +		/* Nothing to do */

What if the driver does not support to disable counters?

It will have to check for _DONT_CARE here.

And _DISABLED implies "bail out if you cannot disable".

You cannot assume _DISABLE != _DONT_CARE, it's the driver that decides
this.
