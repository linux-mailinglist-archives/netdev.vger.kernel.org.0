Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE2D34CC0B
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 11:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbhC2IzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 04:55:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236019AbhC2Iwb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 04:52:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE54961879;
        Mon, 29 Mar 2021 08:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617007951;
        bh=BJZeUY+q7qbna2guyT/0bs9MCyIHO+8bIlDqf5xYcqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NT6E5jbOD6Hy/huwpGM6A9FdNUAgKuVvuWdw1Fg24R7DIHtVuYXYAHoc0ii/pbAal
         khugwLfZYdHKeATNrssxbWV9AzbwCjLO595AIrLSakVszm6VORyO0hPUtTW4nY9A22
         lyfllMFFRxI2Fw8xeAv7tPLLYtHHvgjZ3EN33DeThaGfv3ZS4WRsFbZ87/UrkdOJ1x
         Hzqign5nmcv8xN4KK5f+xRjOov0xf0oCi9W52+/aWKnpz9qrC50POonjfMJ+pztf0i
         S+P8i1zwsycFNvBAwrm4hmA0SdrzQt5WG/ia7mODEGupLuy3jspGZ5uz8ZMhpyUwP0
         CeyJ9V2Srd+lA==
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
Subject: [PATCH rdma-next v1 1/5] RDMA/bnxt_re: Depend on bnxt ethernet driver and not blindly select it
Date:   Mon, 29 Mar 2021 11:52:08 +0300
Message-Id: <20210329085212.257771-2-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210329085212.257771-1-leon@kernel.org>
References: <20210329085212.257771-1-leon@kernel.org>
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

