Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA0242578A
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 18:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242627AbhJGQSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 12:18:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242626AbhJGQSt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 12:18:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D66D60200;
        Thu,  7 Oct 2021 16:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633623415;
        bh=nxfaGs2x9Z8zVs0SXd3slNawqUf8zXiVG0IkJDoWVIA=;
        h=From:To:Cc:Subject:Date:From;
        b=ciucAG0X+Ajvl9+2KDcbfrZuMQEgbJvrL+cbS34jNPlzhMgd7Zyx0ClOPM8OYRxvo
         BxG1bUvYJvO0IlA2xAGV5za5qBCvwWUebgKVq3+njOd6WF37ZinO/RpmYr3GNE+qZS
         X+rLptYL4z/oCFcmNW/eNhzjuFy8UtjZqbMXc7uOsBIVPANCCI+X8PP1jPI5KI3GYH
         tJ2mfq6erZDygVsf+SZJLZAs6dfJIFGGzuLnBzDoE8SNymJ5UPxWJisBo9rEKJxITi
         ZOA7U4w7r0EbK6Xc3zb+/hu6rbSTjZ7plzkb3QhNYyIJJU8AOs0FoDuKKmhk8Q9twe
         VUq42V76LVLOQ==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, pabeni@redhat.com,
        juri.lelli@redhat.com, mhocko@suse.com, netdev@vger.kernel.org
Subject: [PATCH net-next 0/3] net: introduce a function to check if a netdev name is in use
Date:   Thu,  7 Oct 2021 18:16:49 +0200
Message-Id: <20211007161652.374597-1-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This was initially part of an RFC series[1] but has value on its own;
hence the standalone report. (It will also help in not having a series
too large).

From patch 1:

"""
__dev_get_by_name is currently used to either retrieve a net device
reference using its name or to check if a name is already used by a
registered net device (per ns). In the later case there is no need to
return a reference to a net device.

Introduce a new helper, netdev_name_in_use, to check if a name is
currently used by a registered net device without leaking a reference
the corresponding net device. This helper uses netdev_name_node_lookup
instead of __dev_get_by_name as we don't need the extra logic retrieving
a reference to the corresponding net device.
"""

Two uses[2] of __dev_get_by_name weren't converted to this new function,
as they are really looking for a net device, not only checking if a net
device name is in use. While checking one or the other currently has
the same result, that might change if the initial RFC series moves
forward. I'll convert them later depending on the outcome of the initial
series.

Thanks,
Antoine

[1] https://lore.kernel.org/all/20210928125500.167943-1-atenart@kernel.org/
[2] drivers/net/Space.c:130 & drivers/nvme/host/tcp.c:2550

Antoine Tenart (3):
  net: introduce a function to check if a netdev name is in use
  bonding: use the correct function to check for netdev name collision
  ppp: use the correct function to check if a netdev name is in use

 drivers/net/bonding/bond_sysfs.c |  4 ++--
 drivers/net/ppp/ppp_generic.c    |  2 +-
 include/linux/netdevice.h        |  1 +
 net/core/dev.c                   | 14 ++++++++++----
 4 files changed, 14 insertions(+), 7 deletions(-)

-- 
2.31.1

