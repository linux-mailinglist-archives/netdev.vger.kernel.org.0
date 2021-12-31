Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE34482156
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 02:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242521AbhLaBvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 20:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbhLaBvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 20:51:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1476C061574;
        Thu, 30 Dec 2021 17:51:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26972B81CAC;
        Fri, 31 Dec 2021 01:51:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A009C36AEA;
        Fri, 31 Dec 2021 01:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640915473;
        bh=8vV2ntWsxAMI4LUZUz37RY2L27n0/eHDGuCzH6LNyes=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UqR5bl2juY11+3jNRk3br7Wy2+MtUY/apKNKlBq/FtRyEwpIc7kmgs1bapJguNfGM
         qKOz60t9iuVhbgy5Q1mks0UrzQyMKNhHA+gi6uF7RUc69NbSul8I9bWG00A/t51Zg/
         TPV48kyz3VY2VwLzHguODmk2UpIeUYihQiCyTKaZPWxF7ZJpbAL2ODenpsXOgLbdOn
         BWDXvFLD45xjDZfTzSY2cTpojddZo7CxxrbF1tbgI0pIsdDmvhuWD+wTH/1PNj7Fdu
         1W4F/5oVPLPyW2/siP2nB+YlH4cQoyNlGNHw2cLa5URaT998ensyalAIM5qF26pRgU
         PE+1JhYmn0jfQ==
Date:   Thu, 30 Dec 2021 17:51:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gagan Kumar <gagan1kumar.cs@gmail.com>, jk@codeconstruct.com.au
Cc:     matt@codeconstruct.com.au, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mctp: Remove only static neighbour on RTM_DELNEIGH
Message-ID: <20211230175112.7daeb74e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211228130956.8553-1-gagan1kumar.cs@gmail.com>
References: <20211228130956.8553-1-gagan1kumar.cs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Dec 2021 18:39:56 +0530 Gagan Kumar wrote:
> Add neighbour source flag in mctp_neigh_remove(...) to allow removal of
> only static neighbours.

Which are the only ones that exist today right?

Can you clarify the motivation and practical impact of the change 
in the commit message to make it clear? AFAICT this is a no-op / prep
for some later changes, right Jeremy?

> diff --git a/net/mctp/neigh.c b/net/mctp/neigh.c
> index 5cc042121493..a90723ae66d7 100644
> --- a/net/mctp/neigh.c
> +++ b/net/mctp/neigh.c
> @@ -85,8 +85,8 @@ void mctp_neigh_remove_dev(struct mctp_dev *mdev)
>  	mutex_unlock(&net->mctp.neigh_lock);
>  }
>  
> -// TODO: add a "source" flag so netlink can only delete static neighbours?
> -static int mctp_neigh_remove(struct mctp_dev *mdev, mctp_eid_t eid)
> +static int mctp_neigh_remove(struct mctp_dev *mdev, mctp_eid_t eid,
> +			     enum mctp_neigh_source source)
>  {
>  	struct net *net = dev_net(mdev->dev);
>  	struct mctp_neigh *neigh, *tmp;
> @@ -94,7 +94,7 @@ static int mctp_neigh_remove(struct mctp_dev *mdev, mctp_eid_t eid)
>  
>  	mutex_lock(&net->mctp.neigh_lock);
>  	list_for_each_entry_safe(neigh, tmp, &net->mctp.neighbours, list) {
> -		if (neigh->dev == mdev && neigh->eid == eid) {
> +		if (neigh->dev == mdev && neigh->eid == eid && neigh->source == source) {
>  			list_del_rcu(&neigh->list);
>  			/* TODO: immediate RTM_DELNEIGH */
>  			call_rcu(&neigh->rcu, __mctp_neigh_free);
> @@ -202,7 +202,7 @@ static int mctp_rtm_delneigh(struct sk_buff *skb, struct nlmsghdr *nlh,
>  	if (!mdev)
>  		return -ENODEV;
>  
> -	return mctp_neigh_remove(mdev, eid);
> +	return mctp_neigh_remove(mdev, eid, MCTP_NEIGH_STATIC);
>  }
>  
>  static int mctp_fill_neigh(struct sk_buff *skb, u32 portid, u32 seq, int event,

