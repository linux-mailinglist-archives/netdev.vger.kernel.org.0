Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E79FC2BB824
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 22:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbgKTVMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 16:12:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:46678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727170AbgKTVMa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 16:12:30 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC1BC2224E;
        Fri, 20 Nov 2020 21:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605906750;
        bh=IW/0CqYx7CjcxKIxYFcqbCGZrF/sWhZlxknCCzqWq2Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pJGYauThBox6wrZGaIrmijJ4ugNLPpa7pdhpwIjXjU+qhqGGEbgcmcbvg2ondl+si
         tO9jl22r1+W2Prd3+o6wv0zM424lk33ruoUbpvAP3cPiUZpH+mYf7Gmawk1JyVs3Zu
         gFtaJOtbEWVVdw+4QRkXI1u1U3RB+Pa0M7Vwil8w=
Date:   Fri, 20 Nov 2020 13:12:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org,
        pshelar@ovn.org, bindiyakurle@gmail.com, i.maximets@ovn.org,
        mcroce@linux.microsoft.com
Subject: Re: [PATCH net] net: openvswitch: fix TTL decrement action netlink
 message format
Message-ID: <20201120131228.489c3b52@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <160577663600.7755.4779460826621858224.stgit@wsfd-netdev64.ntdv.lab.eng.bos.redhat.com>
References: <160577663600.7755.4779460826621858224.stgit@wsfd-netdev64.ntdv.lab.eng.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 04:04:04 -0500 Eelco Chaudron wrote:
> Currently, the openvswitch module is not accepting the correctly formated
> netlink message for the TTL decrement action. For both setting and getting
> the dec_ttl action, the actions should be nested in the
> OVS_DEC_TTL_ATTR_ACTION attribute as mentioned in the openvswitch.h uapi.

IOW this change will not break any known user space, correct?

But existing OvS user space already expects it to work like you 
make it work now?

What's the harm in leaving it as is?

> Fixes: 744676e77720 ("openvswitch: add TTL decrement action")
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

Can we get a review from OvS folks? Matteo looks good to you (as the
original author)?

> -	err = __ovs_nla_copy_actions(net, attr, key, sfa, eth_type,
> +	err = __ovs_nla_copy_actions(net, actions, key, sfa, eth_type,
>  				     vlan_tci, mpls_label_count, log);
>  	if (err)
>  		return err;

You're not canceling any nests on error, I assume this is normal.

> +	add_nested_action_end(*sfa, action_start);
>  	add_nested_action_end(*sfa, start);
>  	return 0;
>  }

