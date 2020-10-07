Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACED82858C2
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 08:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbgJGGkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 02:40:18 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:10169 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgJGGkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 02:40:17 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7d62650000>; Tue, 06 Oct 2020 23:38:29 -0700
Received: from mtl-vdi-166.wap.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 7 Oct
 2020 06:40:15 +0000
Date:   Wed, 7 Oct 2020 09:40:11 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <saeedm@nvidia.com>, <elic@nvidia.com>
Subject: [PATCH] vdpa/mlx5: Fix dependency on MLX5_CORE
Message-ID: <20201007064011.GA50074@mtl-vdi-166.wap.labs.mlnx>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602052709; bh=vnyinnQREiRArIfp9ytJFBUdYLsYXb3A1DrGRuaZsM4=;
        h=Date:From:To:CC:Subject:Message-ID:MIME-Version:Content-Type:
         Content-Disposition:User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=fSu6d00xpIVylKDqerp4ILMfXST/wTc2zMCzjFsmRs7EbfzdKVGNNriu53B+tNuha
         Q/oWXt5CPbLcW9tB7vJKMyPJW0SrgIEEtqVI3m8dw7AktszlKM6NB5eF8KMppYdb+V
         9ZfNTtuNZfZvdY14rNwOs2MQlHrOwFcjSy+xdfvJMEqr1IO3PsPyHPpsO47J+L2qgL
         wrUmvoHpLJ9gdcoKhCuJiQDNNDRopGM2mlexTZmoAT48GaI0tcmWfAsHNzBj/BRVkl
         9QMjoPARinmOOrjUaOLvgBqhn2RvpUuE+Kzz0kyuLzYgob/fVRCQmC+ySWSsn/uzpa
         T4rmHQl+HH5HA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove propmt for selecting MLX5_VDPA by the user and modify
MLX5_VDPA_NET to select MLX5_VDPA. Also modify MLX5_VDPA_NET to depend
on mlx5_core.

This fixes an issue where configuration sets 'y' for MLX5_VDPA_NET while
MLX5_CORE is compiled as a module causing link errors.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 device")s
Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 drivers/vdpa/Kconfig | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
index a8c7607fdc90..1872dff1d3c6 100644
--- a/drivers/vdpa/Kconfig
+++ b/drivers/vdpa/Kconfig
@@ -29,9 +29,7 @@ config IFCVF
 	  be called ifcvf.
 
 config MLX5_VDPA
-	bool "MLX5 VDPA support library for ConnectX devices"
-	depends on MLX5_CORE
-	default n
+	bool
 	help
 	  Support library for Mellanox VDPA drivers. Provides code that is
 	  common for all types of VDPA drivers. The following drivers are planned:
@@ -39,7 +37,8 @@ config MLX5_VDPA
 
 config MLX5_VDPA_NET
 	tristate "vDPA driver for ConnectX devices"
-	depends on MLX5_VDPA
+	select MLX5_VDPA
+	depends on MLX5_CORE
 	default n
 	help
 	  VDPA network driver for ConnectX6 and newer. Provides offloading
-- 
2.28.0

