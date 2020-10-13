Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A7828D2C1
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 19:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbgJMRBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 13:01:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:36496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726772AbgJMRBl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 13:01:41 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB02725308;
        Tue, 13 Oct 2020 17:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602608501;
        bh=PKihPMmQ1m8LaEsGQL+qYDCaZl4PBUFRA/mO5rSV4OQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xdc3amrycsVM5bhtncOyHPJOjI6lsmZJUUDqdmpJGqZT2o+GIT2WyJ/wVIBDF03WO
         ++/S2frRuN/eBt0V2Zo/TJXoW0bIV0iRypuBp2hB0MORAMXzD2TGS+juNB+NKHUEod
         v+sTTJPldySAh65tPQaopqSyvUwximF6kyhNwvYI=
Date:   Tue, 13 Oct 2020 10:01:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Reji Thomas <rejithomas@juniper.net>
Cc:     david.lebrun@uclouvain.be, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rejithomas.d@gmail.com
Subject: Re: [PATCH] IPv6: sr: Fix End.X nexthop to use oif.
Message-ID: <20201013100138.18af2d5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201013120151.9777-1-rejithomas@juniper.net>
References: <20201013120151.9777-1-rejithomas@juniper.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Oct 2020 17:31:51 +0530 Reji Thomas wrote:
> Currently End.X action doesn't consider the outgoing interface
> while looking up the nexthop.This breaks packet path functionality
> specifically while using link local address as the End.X nexthop.
> The patch fixes this by enforcing End.X action to have both nh6 and
> oif and using oif in lookup.It seems this is a day one issue.
> 
> Fixes: 140f04c33bbc ("implement several seg6local actions")
> 
> Signed-off-by: Reji Thomas <rejithomas@juniper.net>

You need to respin to add the missing 'static' kbuild bot pointed out.

When you do please also edit the fixes tag to include the full subject,
it should look like this:

Fixes: 140f04c33bbc ("ipv6: sr: implement several seg6local actions")

and remove the empty line between the fixes tag and your signoff. 

> @@ -239,6 +249,8 @@ static int input_action_end(struct sk_buff *skb, struct seg6_local_lwt *slwt)
>  static int input_action_end_x(struct sk_buff *skb, struct seg6_local_lwt *slwt)
>  {
>  	struct ipv6_sr_hdr *srh;
> +	struct net *net = dev_net(skb->dev);
> +	struct net_device *odev;

Please sort the variable declarations longest to shortest.
