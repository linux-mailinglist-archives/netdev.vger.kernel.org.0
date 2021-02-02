Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF9530B5ED
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 04:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbhBBDk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 22:40:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:43586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231301AbhBBDk4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 22:40:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B568B64ECE;
        Tue,  2 Feb 2021 03:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612237215;
        bh=157xivRWE34JnD9xrm9ExTqc5raqVVvSivU6mjfp4IE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N8XnY4noxkrklmQcGyEiIKQAzuL7r01pIKMObln8D4SQy2hhRxlyq9vyuAvagqzWv
         v2S1kOjnlyVRkmIYlo0/THBM+MCxAn/SL2LhNEBYz+qEBq3cI42VReg7jcdWeQ+XoK
         1YNKcKKSXOQd986vIFoVKENk4iWCyh1Qy1wtFS1Ju1C7KhDBnMxre75J98M5BNEc4n
         9PVQEKA+6TkRhis8rI+XgYeDSmF+cDymOxrgDiKfY9CEvkfAO6I3RW5kjOq5PJdkQK
         o0modW8UM64lBdCDSaoXsVeI1PNyLFZABpX7kGrLSW8NOZeXxMNV64ifTzaqXhRLES
         Zo0fJ0/5GQhaw==
Date:   Mon, 1 Feb 2021 19:40:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        "Gong, Sishuai" <sishuai@purdue.edu>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [Patch net-next v2] net: fix dev_ifsioc_locked() race condition
Message-ID: <20210201194014.1bffeb9e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210131022755.106005-1-xiyou.wangcong@gmail.com>
References: <20210131022755.106005-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 30 Jan 2021 18:27:55 -0800 Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> dev_ifsioc_locked() is called with only RCU read lock, so when
> there is a parallel writer changing the mac address, it could
> get a partially updated mac address, as shown below:
> 
> Thread 1			Thread 2
> // eth_commit_mac_addr_change()
> memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
> 				// dev_ifsioc_locked()
> 				memcpy(ifr->ifr_hwaddr.sa_data,
> 					dev->dev_addr,...);
> 
> Close this race condition by guarding them with a RW semaphore,
> like netdev_get_name(). The writers take RTNL anyway, so this
> will not affect the slow path. To avoid bothering existing
> dev_set_mac_address() callers in drivers, introduce a new wrapper
> just for user-facing callers in ioctl and rtnetlink.

Some of the drivers need to be update, tho, right? At a quick look at
least bond and tun seem to be making calls to dev_set_mac_address() 
on IOCTL paths.

> Fixes: 3710becf8a58 ("net: RCU locking for simple ioctl()")
> Reported-by: "Gong, Sishuai" <sishuai@purdue.edu>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  include/linux/netdevice.h |  3 +++
>  net/core/dev.c            | 40 +++++++++++++++++++++++++++++++++++++++
>  net/core/dev_ioctl.c      | 20 +++++++-------------
>  net/core/rtnetlink.c      |  2 +-
>  4 files changed, 51 insertions(+), 14 deletions(-)
