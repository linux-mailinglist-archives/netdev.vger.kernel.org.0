Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4657D9BEA4
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 17:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbfHXPnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 11:43:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57116 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727505AbfHXPnF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 11:43:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wKVhvBHkSBQUzo55ImuojKexwOxVSkw08f8JXXuc+oQ=; b=VETwUw/4SQ9FQjxMk7/tZcfKfu
        RQHaDs1uHPX3cAeTun9XY+B42kcsH5AspcSjmPxqy7nJyAB2juHeGgH1LDnGEK/Zq2ybfYxCdMZy6
        nqcOdyJlZbl1VzjtUG+suiTynE8DKkwXEYNMMP/4TvvmrVMc7t1zFAu+zzJswZ3MCsoU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i1YBy-0002Tk-MW; Sat, 24 Aug 2019 17:43:02 +0200
Date:   Sat, 24 Aug 2019 17:43:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH RFC net-next 1/3] net: dsa: allow for multiple CPU ports
Message-ID: <20190824154302.GB8251@lunn.ch>
References: <20190824024251.4542-1-marek.behun@nic.cz>
 <20190824024251.4542-2-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190824024251.4542-2-marek.behun@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int dsa_tree_setup_default_cpus(struct dsa_switch_tree *dst)
>  {
>  	struct dsa_switch *ds;
>  	struct dsa_port *dp;
> -	int device, port;
> +	int device, port, i;
>  
> -	/* DSA currently only supports a single CPU port */
> -	dst->cpu_dp = dsa_tree_find_first_cpu(dst);
> -	if (!dst->cpu_dp) {
> +	dsa_tree_fill_cpu_ports(dst);
> +	if (!dst->num_cpu_dps) {
>  		pr_warn("Tree has no master device\n");
>  		return -EINVAL;
>  	}
>  
> -	/* Assign the default CPU port to all ports of the fabric */
> +	/* Assign the default CPU port to all ports of the fabric in a round
> +	 * robin way. This should work nicely for all sane switch tree designs.
> +	 */
> +	i = 0;
> +
>  	for (device = 0; device < DSA_MAX_SWITCHES; device++) {
>  		ds = dst->ds[device];
>  		if (!ds)
> @@ -238,18 +249,20 @@ static int dsa_tree_setup_default_cpu(struct dsa_switch_tree *dst)
>  		for (port = 0; port < ds->num_ports; port++) {
>  			dp = &ds->ports[port];
>  
> -			if (dsa_port_is_user(dp) || dsa_port_is_dsa(dp))
> -				dp->cpu_dp = dst->cpu_dp;
> +			if (dsa_port_is_user(dp) || dsa_port_is_dsa(dp)) {
> +				dp->cpu_dp = dst->cpu_dps[i++];
> +				if (i == dst->num_cpu_dps)
> +					i = 0;
> +			}

Hi Marek

For a single switch, i think this is O.K, but when you have a cluster,
maybe a different allocation should be considered? If this switch has
a local CPU port, use it. Only round robing between remote CPU ports
when there is no local CPU port?

For a two switch setup and each switch having its own CPU port, your
allocation will cause half the CPU traffic to go across the DSA link
between the two switches. But we really want to keep the DSA link for
traffic between user ports on different switches.

But i don't know if it is worth the effort. I've never seen a D in DSA
setup with multiple CPUs ports. I've only ever seen an single switch
with multiple CPU ports.

