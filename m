Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6E2350FA1
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 08:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbhDAG5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 02:57:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233345AbhDAG5Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 02:57:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC92C600EF;
        Thu,  1 Apr 2021 06:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617260243;
        bh=BJZeUY+q7qbna2guyT/0bs9MCyIHO+8bIlDqf5xYcqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uFMLTD7QVKsmAyiyeXeaEyZ84PvfxCJjmlzM1VTQcV/u5E2pqNpjdfQZLHPvCdzsr
         /J46khOqPdh4+DdWjsy0FhiQ/xbblQBYfPO+l1qjuWj3pjmHa9IFmr+I+nRgQst0Jn
         hZJv53AixkR8Q6fE5RJnJofdC9GIblJm7UmKEzWelKe3qVqoiQnvH1PT6c/8gRONRt
         DfpTVN3kNW8FJDA7Qq3vbV1dVpC+inIkpTf7Dvu+rba3qdCb9CxJIS4WLbbCFvYZ6M
         uVvPeE3PlBltAwSqwyGevbxWPweYqsihUqFoFoiN9Uq7EpHpB2Woch6UOxeqkVdJV/
         iXNYgIZTzRt2w==
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
Subject: [PATCH rdma-next v2 1/5] RDMA/bnxt_re: Depend on bnxt ethernet driver and not blindly select it
Date:   Thu,  1 Apr 2021 09:57:11 +0300
Message-Id: <20210401065715.565226-2-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210401065715.565226-1-leon@kernel.org>
References: <20210401065715.565226-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The "select" kconfig keyword provides reverse dependency, however it
doesn't check that selected symbol meets its own dependencies. Usually
"select" is used for non-visible symbols, so instead of trying to keep
dependencies in sync with BNXT ethernet driver, simply "depends on" it,
like Kconfig documentation suggest.

* CONFIG_PCI is already required by BNXT
* CONFIG_NETDEVICES and CONFIG_ETHERNET are needed to chose BNXT

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/bnxt_re/Kconfig | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/Kconfig b/drivers/infiniband/hw/bnxt_re/Kconfig
index 0feac5132ce1..6a17f5cdb020 100644
--- a/drivers/infiniband/hw/bnxt_re/Kconfig
+++ b/drivers/infiniband/hw/bnxt_re/Kconfig
@@ -2,9 +2,7 @@
 config INFINIBAND_BNXT_RE
 	tristate "Broadcom Netxtreme HCA support"
 	depends on 64BIT
-	depends on ETHERNET && NETDEVICES && PCI && INET && DCB
-	select NET_VENDOR_BROADCOM
-	select BNXT
+	depends on INET && DCB && BNXT
 	help
 	  This driver supports Broadcom NetXtreme-E 10/25/40/50 gigabit
 	  RoCE HCAs.  To compile this driver as a module, choose M here:
-- 
2.30.2

