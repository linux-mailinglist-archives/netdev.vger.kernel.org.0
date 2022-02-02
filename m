Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0104A6B2D
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 06:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbiBBFGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 00:06:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49004 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbiBBFGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 00:06:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 634DE6170E
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 05:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30563C340EC;
        Wed,  2 Feb 2022 05:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643778392;
        bh=bLmKLgx3S8OMPZbedIBppLyFJg0CnPI11XlzmLHIoyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NhePesjSNRFVPL+cCCyyNUyo/ZBP4SS6/8Ysbmz+K0ZiusJYQQ8yDuJXeUptqSyOQ
         NC1Etp0RPGkbkv3om1NxAJuNOXSWkwa94tQgkC9XljyLYSIVrUPTCW0edzkQen6YM5
         QYskokHVa2lUaogsKREQavURF1j56AYZyL4hOTOWQltTdb7OCtwH86Y383yHMDaPaQ
         Dqd/9snjK+uy8CdPhOQcGriSM8BmZxkqZU7SWzGnKmX//tDBExrDen3qeDj3cpNB6/
         tRKT5M9gGx/1KgUSWZw0oZsir2Ahtqykxk/N21yJdYE8qEoyG4w9cGafcz2RXw++Va
         fb6cymeP6erbw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        kernel test robot <lkp@intel.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 02/18] net/mlx5: Bridge, ensure dev_name is null-terminated
Date:   Tue,  1 Feb 2022 21:03:48 -0800
Message-Id: <20220202050404.100122-3-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220202050404.100122-1-saeed@kernel.org>
References: <20220202050404.100122-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Even though net_device->name is guaranteed to be null-terminated string of
size<=IFNAMSIZ, the test robot complains that return value of netdev_name()
can be larger:

In file included from include/trace/define_trace.h:102,
                    from drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h:113,
                    from drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c:12:
   drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h: In function 'trace_event_raw_event_mlx5_esw_bridge_fdb_template':
>> drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h:24:29: warning: 'strncpy' output may be truncated copying 16 bytes from a string of length 20 [-Wstringop-truncation]
      24 |                             strncpy(__entry->dev_name,
         |                             ^~~~~~~~~~~~~~~~~~~~~~~~~~
      25 |                                     netdev_name(fdb->dev),
         |                                     ~~~~~~~~~~~~~~~~~~~~~~
      26 |                                     IFNAMSIZ);
         |                                     ~~~~~~~~~

This is caused by the fact that default value of IFNAMSIZ is 16, while
placeholder value that is returned by netdev_name() for unnamed net devices
is larger than that.

The offending code is in a tracing function that is only called for mlx5
representors, so there is no straightforward way to reproduce the issue but
let's fix it for correctness sake by replacing strncpy() with strscpy() to
ensure that resulting string is always null-terminated.

Fixes: 9724fd5d9c2a ("net/mlx5: Bridge, add tracepoints")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h    | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h
index 3401188e0a60..51ac24e6ec3c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h
@@ -21,7 +21,7 @@ DECLARE_EVENT_CLASS(mlx5_esw_bridge_fdb_template,
 			    __field(unsigned int, used)
 			    ),
 		    TP_fast_assign(
-			    strncpy(__entry->dev_name,
+			    strscpy(__entry->dev_name,
 				    netdev_name(fdb->dev),
 				    IFNAMSIZ);
 			    memcpy(__entry->addr, fdb->key.addr, ETH_ALEN);
-- 
2.34.1

