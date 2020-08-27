Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8778A255118
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 00:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgH0WdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 18:33:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726953AbgH0WdN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 18:33:13 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F5832080C;
        Thu, 27 Aug 2020 22:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598567593;
        bh=+CIrDgdDkye3H5KyAO4tjJU03XWNTqZfgPKrajTglWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FIQBbd/xdlBXD0KQpN796prHD9FtQL6wnTs65xFgUrTFo+l5Zm1knqKv4KLypNgs4
         bQxyH5Zp+9/xlqj8oH5aJ3ZN6kvOHW79zQc6IZDZWZ8Lv6+hocU9W71RBPjHofaiYt
         CQzU4Ok91Z/wC1O5WG8/IqaCY95j63ZzF5a6cOMY=
From:   Jakub Kicinski <kuba@kernel.org>
To:     eric.dumazet@gmail.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC -next 0/3] Re: [PATCH net 1/2] net: disable netpoll on fresh napis
Date:   Thu, 27 Aug 2020 15:32:47 -0700
Message-Id: <20200827223250.2045503-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200827104753.29d836bb@kicinski-fedora-PC1C0HJN>
References: <20200827104753.29d836bb@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Aug 2020 10:47:53 -0700 Jakub Kicinski wrote:
> > Oh, I really thought list_for_each_entry_rcu() was only checking standard rcu.
> > 
> > I might have been confused because we do have hlist_for_each_entry_rcu_bh() helper.
> > 
> > Anyway, when looking at the patch I was not at ease because we do not have proper
> > rcu grace period when a napi is removed from dev->napi_list. A driver might
> > free the napi struct right after calling netif_napi_del()  
> 
> Ugh, you're right. I didn't look closely enough at netif_napi_del():
> 
> 	if (napi_hash_del(napi))
> 		synchronize_net();
> 	list_del_init(&napi->dev_list);
> 
> Looks like I can reorder these.. and perhaps make all dev->napi_list
> accesses RCU, for netpoll?

So I had a look and looks like some reshuffling may be required
to get out of this pickle. The objective is for drivers to observe
RCU grace period after netif_napi_del() not just napi_hash_del().

Sending as RFC because IDK if the churn vs improvement ratio
is acceptable here.

Jakub Kicinski (3):
  net: remove napi_hash_del() from driver-facing API
  net: manage napi add/del idempotence explicitly
  net: make sure napi_list is safe for RCU traversal

 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.h   |  8 ++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  5 ++-
 drivers/net/ethernet/cisco/enic/enic_main.c   | 12 ++++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  |  4 +--
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  5 ++-
 drivers/net/veth.c                            |  3 +-
 drivers/net/virtio_net.c                      |  7 ++--
 include/linux/netdevice.h                     | 36 +++++++++----------
 net/core/dev.c                                | 32 ++++++++---------
 net/core/netpoll.c                            |  2 +-
 10 files changed, 55 insertions(+), 59 deletions(-)

-- 
2.26.2

