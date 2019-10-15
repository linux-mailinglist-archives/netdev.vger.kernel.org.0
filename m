Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B84ED7DEA
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 19:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731586AbfJORgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 13:36:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37456 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727523AbfJORgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 13:36:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E46CA150470EE;
        Tue, 15 Oct 2019 10:36:11 -0700 (PDT)
Date:   Tue, 15 Oct 2019 10:36:09 -0700 (PDT)
Message-Id: <20191015.103609.86962935874616520.davem@davemloft.net>
To:     maheshb@google.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, weiwan@google.com,
        mahesh@bandewar.net
Subject: Re: [PATCHv3 next] blackhole_netdev: fix syzkaller reported issue
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191012011455.211242-1-maheshb@google.com>
References: <20191012011455.211242-1-maheshb@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 10:36:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mahesh Bandewar <maheshb@google.com>
Date: Fri, 11 Oct 2019 18:14:55 -0700

> While invalidating the dst, we assign backhole_netdev instead of
> loopback device. However, this device does not have idev pointer
> and hence no ip6_ptr even if IPv6 is enabled. Possibly this has
> triggered the syzbot reported crash.
> 
> The syzbot report does not have reproducer, however, this is the
> only device that doesn't have matching idev created.
> 
> Crash instruction is :
> 
> static inline bool ip6_ignore_linkdown(const struct net_device *dev)
> {
>         const struct inet6_dev *idev = __in6_dev_get(dev);
> 
>         return !!idev->cnf.ignore_routes_with_linkdown; <= crash
> }
> 
> Also ipv6 always assumes presence of idev and never checks for it
> being NULL (as does the above referenced code). So adding a idev
> for the blackhole_netdev to avoid this class of crashes in the future.
> 
> ---
 ...
> Fixes: 8d7017fd621d ("blackhole_netdev: use blackhole_netdev to invalidate dst entries")
> Signed-off-by: Mahesh Bandewar <maheshb@google.com>

Applied and queued up for -stable, thanks.
