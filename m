Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775CA26E4FA
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 21:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgIQTDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 15:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbgIQS7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 14:59:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C44DC06174A;
        Thu, 17 Sep 2020 11:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Date:Message-ID:Subject:From:Cc:To:Sender:Reply-To:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=dCb3Mw8emqdBD/1nF+oUHT3U3i0WT8UHhM2aFDWS07g=; b=a6AAAWT6OpuM+kWcatw3TlS2JP
        +8IS6npgj/d5gENj7cfht68AdE18jEyqNklaqeTUkp7d2dLDMsPPi+veQLTosycBB0vDYDd4A8Yyr
        tznRa1dqP11vzU13o+w8+NI0S2IwbKOxHAR6RHTudrhQhOFeRLJxOB8d7iUlNyWiPZPONYGOMMtMO
        jMNj7kl01I7FnTNmILeOSFXO2K+G4obIYF76n4aWfGHU+4d/ez4I1+WdKfY8QkAIoHxTzeSrtMWgD
        979WzHnWW1wU6ehSV+WMb0E8LWmwYqMzX9Jd9A+0HqijmAVIwP9BMmj4KuLIubgEiqvd+S9pNQk99
        Y9x+AIAw==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIz7L-0000LU-Rs; Thu, 17 Sep 2020 18:58:52 +0000
To:     LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH -next] vdpa: mlx5: select VHOST to fix build errors
Message-ID: <f47e2bab-c19c-fab5-cfb9-e2b5ba1be69a@infradead.org>
Date:   Thu, 17 Sep 2020 11:58:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

drivers/vdpa/mlx5/ uses vhost_iotlb*() interfaces, so select
VHOST to eliminate build errors.

ld: drivers/vdpa/mlx5/core/mr.o: in function `add_direct_chain':
mr.c:(.text+0x106): undefined reference to `vhost_iotlb_itree_first'
ld: mr.c:(.text+0x1cf): undefined reference to `vhost_iotlb_itree_next'
ld: mr.c:(.text+0x30d): undefined reference to `vhost_iotlb_itree_first'
ld: mr.c:(.text+0x3e8): undefined reference to `vhost_iotlb_itree_next'
ld: drivers/vdpa/mlx5/core/mr.o: in function `_mlx5_vdpa_create_mr':
mr.c:(.text+0x908): undefined reference to `vhost_iotlb_itree_first'
ld: mr.c:(.text+0x9e6): undefined reference to `vhost_iotlb_itree_next'
ld: drivers/vdpa/mlx5/core/mr.o: in function `mlx5_vdpa_handle_set_map':
mr.c:(.text+0xf1d): undefined reference to `vhost_iotlb_itree_first'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: virtualization@lists.linux-foundation.org
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: netdev@vger.kernel.org
---
Note: This patch may not be the right thing, but it fixes the build errors.

 drivers/vdpa/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20200917.orig/drivers/vdpa/Kconfig
+++ linux-next-20200917/drivers/vdpa/Kconfig
@@ -32,6 +32,7 @@ config IFCVF
 config MLX5_VDPA
 	bool "MLX5 VDPA support library for ConnectX devices"
 	depends on MLX5_CORE
+	select VHOST
 	default n
 	help
 	  Support library for Mellanox VDPA drivers. Provides code that is

