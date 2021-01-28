Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6741630787C
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 15:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbhA1Opl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 09:45:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:49384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231997AbhA1Oot (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 09:44:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A56D60C41;
        Thu, 28 Jan 2021 14:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611845048;
        bh=jDMMsAKifOUnOm189K/HKkFjMlf59U21gNrYCXhkBpw=;
        h=From:To:Cc:Subject:Date:From;
        b=j8gr8+i0bBDydU9aVyfZx21Tq3sD17c9Fs6PzH5CDATsQRYTGgey+yJTF0/VZd6UX
         ycXG73Evh/o2KPYjXjSOLqrSdZyNbiZ5IpvONfKYBhNntpGvH5AvAnVDU+XRSffRi3
         hBYj1mJSPUY0A/rrBekKv3IxliTP/VCy4dNGwwPNRQnV77vkIPVrZXYhxW9FlMeHP7
         kPvlZgyZVC/TdB0guaTDbbBkpOOXSitZCD+16xHY7ozG7rGUYTPyTfroyzrztHGL5r
         LHCFV0lxtUmWRdQKou3RWYoc7vIegVwJqNE7g2i6x5aCCvRcuGFrBbJ24AM970/Ew8
         O9kkE2qHaY3ng==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 00/11] net: xps: improve the xps maps handling
Date:   Thu, 28 Jan 2021 15:43:54 +0100
Message-Id: <20210128144405.4157244-1-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

A small series moving the xps cpus/rxqs retrieval logic in net-sysfs was
sent[1] and while there was no comments asking for modifications in the
patches themselves, we had discussions about other xps related reworks.
In addition to the patches sent in the previous series[1] (included),
this series has extra patches introducing the modifications we
discussed.

The main change is moving dev->num_tc and dev->nr_ids in the xps maps, to
avoid out-of-bound accesses as those two fields can be updated after the
maps have been allocated. This allows further reworks, to improve the
xps code readability and allow to stop taking the rtnl lock when
reading the maps in sysfs.

Finally, the maps are moved to an array in net_device, which simplifies
the code a lot.

One future improvement may be to remove the use of xps_map_mutex from
net/core/dev.c, but that may require extra care.

Thanks!
Antoine

[1] https://lore.kernel.org/netdev/20210106180428.722521-1-atenart@kernel.org/

Antoine Tenart (11):
  net-sysfs: convert xps_cpus_show to bitmap_zalloc
  net-sysfs: store the return of get_netdev_queue_index in an unsigned
    int
  net-sysfs: move the xps cpus/rxqs retrieval in a common function
  net: embed num_tc in the xps maps
  net: add an helper to copy xps maps to the new dev_maps
  net: improve queue removal readability in __netif_set_xps_queue
  net: xps: embed nr_ids in dev_maps
  net: assert the rtnl lock is held when calling __netif_set_xps_queue
  net: remove the xps possible_mask
  net-sysfs: remove the rtnl lock when accessing the xps maps
  net: move the xps maps to an array

 drivers/net/virtio_net.c  |   2 +-
 include/linux/netdevice.h |  27 ++++-
 net/core/dev.c            | 233 +++++++++++++++++++-------------------
 net/core/net-sysfs.c      | 168 +++++++++++----------------
 4 files changed, 202 insertions(+), 228 deletions(-)

-- 
2.29.2

