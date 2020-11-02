Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6AA2A3495
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 20:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgKBTw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 14:52:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:38680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726860AbgKBTvZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 14:51:25 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA2D020731;
        Mon,  2 Nov 2020 19:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604346685;
        bh=8wheK2VVxJUMzUSmj16jrZa0I4gVnfsR85RI9adu3KQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eDHxJ2tKmahEB57DxD+ihqoIP3kKxC7Cg7L3hLsq0gxfqUTHMlusOo9tCcyekbfuP
         qU5micjrF8/UNG4hbw2QupGnchIOvB34vUjdGwPyRvAmGV3OkTAhE1xu1gq0I8GceU
         EINEAwpJSH0kA8zgRHCkxzfWcnXQdqhNRIvVkYsc=
Date:   Mon, 2 Nov 2020 11:51:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Eelco Chaudron" <echaudro@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org
Subject: Re: [PATCH net] net: openvswitch: silence suspicious RCU usage
 warning
Message-ID: <20201102115123.0f7460cc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <AFFC5913-5595-464B-9B1B-EB25E730C2E2@redhat.com>
References: <160398318667.8898.856205445259063348.stgit@ebuild>
        <20201030142852.7d41eecc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <AFFC5913-5595-464B-9B1B-EB25E730C2E2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 02 Nov 2020 09:52:19 +0100 Eelco Chaudron wrote:
> On 30 Oct 2020, at 22:28, Jakub Kicinski wrote:
> >> @@ -1695,6 +1695,9 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, 
> >> struct genl_info *info)
> >>  	if (err)
> >>  		goto err_destroy_ports;
> >>
> >> +	/* So far only local changes have been made, now need the lock. */
> >> +	ovs_lock();  
> >
> > Should we move the lock below assignments to param?
> >
> > Looks a little strange to protect stack variables with a global lock.  
> 
> You are right, I should have moved it down after the assignment. I will 
> send out a v2.
> 
> > Let's update the name of the label.  
> 
> Guess now it is, unlock and destroy meters, so what label are you 
> looking for?
> 
> err_unlock_and_destroy_meters: which looks a bit long, or just 
> err_unlock:

I feel like I saw some names like err_unlock_and_destroy_meters in OvS
code, but can't find them in this file right now.

I'd personally go for kist err_unlock, or maybe err_unlock_ovs as is
used in other functions in this file.

But as long as it starts with err_unlock it's fine by me :)
