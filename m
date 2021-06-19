Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3A53ADA40
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 15:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbhFSNzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 09:55:52 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:50548 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233286AbhFSNzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 09:55:51 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15JDqF68013080;
        Sat, 19 Jun 2021 13:53:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=g75dXg0RTXdq1T70ZxDW8H7ydrs7Wwy2Y+5H0s9vm6k=;
 b=SHHJQ8hWhZ4y6cz5IdLoFiNHkSfv9WDk3fPNeXeTB+dTq7dUVdZjLG0fTQ8Bn9l3w3ni
 Pp1/3PZ9brbtXszN5r8x6/BWVthgCmFX+q/2LcrugIbZMjyFo/1XJnTYy8jdCjU0Zmzp
 HDcZPz/utiryQcH75AZB/aH6gbO6xR3g59M87aEKdqP0n6U8kN1yn83MhJiJPHw248TP
 ys/FVJYhOyoEuG6ps6ehKBaG9nLqKiOz7+iw2foIxder1hxCFo0y47kNYyF4DEHubwHd
 AqOLnTA/QRYNn7Bbr8uKQQ+ERsbFl8qACXCk8PITtkyXMbPa4iyhWkHlqfb5hOzTg9n2 Ag== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3998f88ead-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 13:53:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15JDp1qZ125313;
        Sat, 19 Jun 2021 13:53:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3995psqsga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 13:53:36 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15JDrZmR127584;
        Sat, 19 Jun 2021 13:53:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3995psqsg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 13:53:35 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 15JDrYYx022697;
        Sat, 19 Jun 2021 13:53:34 GMT
Received: from mwanda (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 19 Jun 2021 06:53:34 -0700
Date:   Sat, 19 Jun 2021 16:53:26 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Simon Horman <simon.horman@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        oss-drivers@corigine.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] nfp: flower-ct: check for error in
 nfp_fl_ct_offload_nft_flow()
Message-ID: <YM321r7Enw8sGj0X@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-GUID: CHcqn9y5pOGdR3KzPNK-PGbN3CmbtTES
X-Proofpoint-ORIG-GUID: CHcqn9y5pOGdR3KzPNK-PGbN3CmbtTES
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The nfp_fl_ct_add_flow() function can fail so we need to check for
failure.

Fixes: 95255017e0a8 ("nfp: flower-ct: add nft flows to nft list")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/netronome/nfp/flower/conntrack.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index 9ea77bb3b69c..273d529d43c2 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -1067,6 +1067,8 @@ nfp_fl_ct_offload_nft_flow(struct nfp_fl_ct_zone_entry *zt, struct flow_cls_offl
 						    nfp_ct_map_params);
 		if (!ct_map_ent) {
 			ct_entry = nfp_fl_ct_add_flow(zt, NULL, flow, true, extack);
+			if (IS_ERR(ct_entry))
+				return PTR_ERR(ct_entry);
 			ct_entry->type = CT_TYPE_NFT;
 			list_add(&ct_entry->list_node, &zt->nft_flows_list);
 			zt->nft_flows_count++;
-- 
2.30.2

