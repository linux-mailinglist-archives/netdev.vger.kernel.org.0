Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB74023B249
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 03:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgHDBar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 21:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgHDBaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 21:30:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D38C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 18:30:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 73B041278BB2D;
        Mon,  3 Aug 2020 18:14:00 -0700 (PDT)
Date:   Mon, 03 Aug 2020 18:30:45 -0700 (PDT)
Message-Id: <20200803.183045.2051223193100039727.davem@davemloft.net>
To:     lkp@intel.com
Cc:     ecree@solarflare.com, linux-net-drivers@solarflare.com,
        kbuild-all@lists.01.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 11/11] sfc_ef100: add nic-type for VFs, and
 bind to them
From:   David Miller <davem@davemloft.net>
In-Reply-To: <202008040935.VN2uKoeZ%lkp@intel.com>
References: <56e8d601-1dbd-f49e-369c-6cbed4d896bf@solarflare.com>
        <202008040935.VN2uKoeZ%lkp@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 18:14:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: kernel test robot <lkp@intel.com>
Date: Tue, 4 Aug 2020 09:16:30 +0800

>    drivers/net/ethernet/sfc/ef100_nic.c:835:3: error: 'const struct efx_nic_type' has no member named 'filter_rfs_expire_one'
>      835 |  .filter_rfs_expire_one = efx_mcdi_filter_rfs_expire_one,
>          |   ^~~~~~~~~~~~~~~~~~~~~
>>> drivers/net/ethernet/sfc/ef100_nic.c:835:27: error: initialization of 'void (*)(struct efx_nic *, u32)' {aka 'void (*)(struct efx_nic *, unsigned int)'} from incompatible pointer type 'bool (*)(struct efx_nic *, u32,  unsigned int)' {aka '_Bool (*)(struct efx_nic *, unsigned int,  unsigned int)'} [-Werror=incompatible-pointer-types]
>      835 |  .filter_rfs_expire_one = efx_mcdi_filter_rfs_expire_one,
>          |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

I fixed this in my tree as follows:

====================
From da7955405fb25c11a541234b32d06d9c09f81be6 Mon Sep 17 00:00:00 2001
From: "David S. Miller" <davem@davemloft.net>
Date: Mon, 3 Aug 2020 18:29:39 -0700
Subject: [PATCH] sfc: Fix build with CONFIG_RFS_ACCEL disabled.

   drivers/net/ethernet/sfc/ef100_nic.c:835:3: error: 'const struct efx_nic_type' has no member named 'filter_rfs_expire_one'
     835 |  .filter_rfs_expire_one = efx_mcdi_filter_rfs_expire_one,
         |   ^~~~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/sfc/ef100_nic.c:835:27: error: initialization of 'void (*)(struct efx_nic *, u32)' {aka 'void (*)(struct efx_nic *, unsigned int)'} from incompatible pointer type 'bool (*)(struct efx_nic *, u32,  unsigned int)' {aka '_Bool (*)(struct efx_nic *, unsigned int,  unsigned int)'} [-Werror=incompatible-pointer-types]
     835 |  .filter_rfs_expire_one = efx_mcdi_filter_rfs_expire_one,
         |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 8a2126fec078..36598d0542ed 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -832,7 +832,9 @@ const struct efx_nic_type ef100_vf_nic_type = {
 	.filter_count_rx_used = efx_mcdi_filter_count_rx_used,
 	.filter_get_rx_id_limit = efx_mcdi_filter_get_rx_id_limit,
 	.filter_get_rx_ids = efx_mcdi_filter_get_rx_ids,
+#ifdef CONFIG_RFS_ACCEL
 	.filter_rfs_expire_one = efx_mcdi_filter_rfs_expire_one,
+#endif
 
 	.rx_prefix_size = ESE_GZ_RX_PKT_PREFIX_LEN,
 	.rx_hash_offset = ESF_GZ_RX_PREFIX_RSS_HASH_LBN / 8,
-- 
2.26.2

