Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B252350F9E
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 08:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233433AbhDAG5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 02:57:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232565AbhDAG5U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 02:57:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A7FA61057;
        Thu,  1 Apr 2021 06:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617260240;
        bh=JEptIBXOVTbHsZ8l9RD8OjfRbULoBcoiIlX48sw6icA=;
        h=From:To:Cc:Subject:Date:From;
        b=WRgAchBsoins3q8fUtZVHUt8fsfUC5rO8cVfQnibrUuY8IfuumWGGAB+W7iJy/5DZ
         pSh0QDXcMZZkEBK9RoqiEcPZSx1vQJWhfBLNcR6KYDGH02vnBYfYD89qOQC9G+rYjj
         4nvriqvOoWMQZdDHdywVE8RybFlAnqtci/JgPSy9OfCNdXROf26/cZcupWQy/JwAfx
         wqgvM/0wodVHrhlnjSShxyJg2A1Qt0izJ45NnHADVOwE2ELZG7n86F4+DDAD9m8CjO
         4oJy1c8RTZXWsucVRTcG/ckULLqDvcDCKDqIqzvTKnJ96Eh/20BwT3cRO7WQP9vpgo
         9VjsDmYIuKQIw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Michael Chan <michael.chan@broadcom.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        netdev@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Subject: [PATCH rdma-next v2 0/5] Get rid of custom made module dependency
Date:   Thu,  1 Apr 2021 09:57:10 +0300
Message-Id: <20210401065715.565226-1-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Changelog:
v2:
 * kbuild spotted that I didn't delete all code in patch #5, so deleted
   even more ulp_ops derefences.
v1: https://lore.kernel.org/linux-rdma/20210329085212.257771-1-leon@kernel.org
 * Go much deeper and removed useless ULP indirection
v0: https://lore.kernel.org/linux-rdma/20210324142524.1135319-1-leon@kernel.org
-----------------------------------------------------------------------

The following series fixes issue spotted in [1], where bnxt_re driver
messed with module reference counting in order to implement symbol
dependency of bnxt_re and bnxt modules. All of this is done, when in
upstream we have only one ULP user of that bnxt module. The simple
declaration of exported symbol would do the trick.

This series removes that custom module_get/_put, which is not supposed
to be in the driver from the beginning and get rid of nasty indirection
logic that isn't relevant for the upstream code.

Such small changes allow us to simplify the bnxt code and my hope that
Devesh will continue where I stopped and remove struct bnxt_ulp_ops too.

Thanks

[1] https://lore.kernel.org/linux-rdma/20210324142524.1135319-1-leon@kernel.org

Leon Romanovsky (5):
  RDMA/bnxt_re: Depend on bnxt ethernet driver and not blindly select it
  RDMA/bnxt_re: Create direct symbolic link between bnxt modules
  RDMA/bnxt_re: Get rid of custom module reference counting
  net/bnxt: Remove useless check of non-existent ULP id
  net/bnxt: Use direct API instead of useless indirection

 drivers/infiniband/hw/bnxt_re/Kconfig         |   4 +-
 drivers/infiniband/hw/bnxt_re/main.c          |  93 ++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 245 +++++++-----------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h |  32 +--
 6 files changed, 119 insertions(+), 260 deletions(-)

-- 
2.30.2

