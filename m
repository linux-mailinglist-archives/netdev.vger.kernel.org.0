Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C52373912
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 13:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232845AbhEELLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 07:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbhEELLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 07:11:34 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701F1C061574;
        Wed,  5 May 2021 04:10:26 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1leFPx-0002TT-22; Wed, 05 May 2021 13:10:13 +0200
Date:   Wed, 5 May 2021 13:10:13 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
Cc:     fw@strlen.de, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v3] netfilter: nf_conntrack: Add conntrack helper for
 ESP/IPsec
Message-ID: <20210505111013.GB12364@breakpoint.cc>
References: <20210426123743.GB975@breakpoint.cc>
 <20210503010646.11111-1-Cole.Dishington@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210503010646.11111-1-Cole.Dishington@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cole Dishington <Cole.Dishington@alliedtelesis.co.nz> wrote:
> +/* esp hdr info to tuple */
> +bool esp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
> +		      struct net *net, struct nf_conntrack_tuple *tuple)
> +{
[..]

> +	tuple->dst.u.esp.id = esp_entry->esp_id;
> +	tuple->src.u.esp.id = esp_entry->esp_id;
> +	return true;
> +}

Did not consider this before, and doesn't matter if we'd follow this
approach or expectation-based solution:

Do we need to be mindful about hole-punching?

The above will automatically treat the incoming (never-seen-before)
ESP packet as being part of the outgoing one, i.e. this will match
ESTABLISHED rule, not NEW.

With expectation based approach, this will auto-match a RELATED rule.

With normal expectations as used by helpers (ftp, sip and so on),
we nowadays don't do such auto-accept schemes anymore but instead
require explicit configuation, e.g. something like

iptables -t raw -p tcp -A PREROUTING -s $allowed  -d $ftpserver -j CT --helper "ftp"

... to make it explicit that the kernel may automatically permit
incoming connection requests to $allowed from $ftpserver.

Do we need to worry about this for ESP too?

If the expectation-based route is taken, another patch could be piled on
top that adds a fake ESP helper, whose only function is to let
esp_pkt_to_tuple() check if the 'outgoing/seen-before' ESP connection
has been configured with the "esp" helper, and then allow the expectation
(or, not allow it in case the existing esp ct doesn't have the esp helper).
