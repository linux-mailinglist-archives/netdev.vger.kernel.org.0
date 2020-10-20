Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6FF294105
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 19:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395118AbgJTRCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 13:02:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395114AbgJTRCn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 13:02:43 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F5ED2177B;
        Tue, 20 Oct 2020 17:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603213362;
        bh=m41l1QG+vq5Iziw+pChnU5k9eeRD2kOnLqQuh+zyajI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MPUUZcD7/SZ5Gnsqg2dJF3fqM+sBe+F/qCP/lNGUkH3cyDpOnyauFxyWlDHxGGEWM
         Ei51994cuZI4Sj5iT0yQL0wtk/2ne2ognsuq0gp3neSnswxi9Uq9rHB90PUbmTRkgx
         yNB1TVPIZ+PANd2iACViUsm9Jl/IlqKOznI/6HpM=
Date:   Tue, 20 Oct 2020 10:02:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     zhudi <zhudi21@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <rose.chen@huawei.com>
Subject: Re: [PATCH v2] rtnetlink: fix data overflow in rtnl_calcit()
Message-ID: <20201020100240.5ab806ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201020055115.1268-1-zhudi21@huawei.com>
References: <20201020055115.1268-1-zhudi21@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 13:51:15 +0800 zhudi wrote:
> @@ -3735,7 +3735,7 @@ static u16 rtnl_calcit(struct sk_buff *skb, struct nlmsghdr *nlh)
>  	 */
>  	rcu_read_lock();
>  	for_each_netdev_rcu(net, dev) {
> -		min_ifinfo_dump_size = max_t(u16, min_ifinfo_dump_size,
> +		min_ifinfo_dump_size = max(min_ifinfo_dump_size,
>  					     if_nlmsg_size(dev,
>  						           ext_filter_mask));

Patch looks good, one trivial adjustment.

As checkpatch.pl points out you need to re-align the continuation lines:

CHECK: Alignment should match open parenthesis
#70: FILE: net/core/rtnetlink.c:3739:
+		min_ifinfo_dump_size = max(min_ifinfo_dump_size,
 					     if_nlmsg_size(dev,

In fact the second parameter should now fit on one line, like this:

		min_ifinfo_dump_size = max(min_ifinfo_dump_size,
					   if_nlmsg_size(dev, ext_filter_mask));
