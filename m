Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B4F51DE99
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 20:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389074AbiEFSHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 14:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388506AbiEFSHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 14:07:37 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C3962BEB
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 11:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651860233; x=1683396233;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FFRdkD01OAqMUzjDfEe0B6hvpla/i3VdUwggUbkuUY4=;
  b=XzVZuiX9kzr8cV04anypSPt8nvlap54bIOhCTZ5yOrGsSzKtHdiHG1jm
   Cl7IGDv2LkSCebRyU6Qxjgj98Y/tFc7D3TZuLQMbHF7MyVkSBRShTcEvT
   BfmwsbPzR1eZvyJ8/cKCrWKGoKd2WqOz5u87eC57wFf4moR62bTcbPdhb
   tecMxPNabdpL+Q1RrA95FSM1ZR+BV8W7k57caQh5L362iA8Osm6b1znC1
   p6DkAPhSXmub64npXZ7ZGYOrwlOHStrelytIMpLFnz+ConRZZntHg1AJw
   a3nAZPyS8OLYnwrxGhvOkDBsM9KnBrlnWPIzZ/AciwvLjYBTK5FAHfeJ9
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="354971159"
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="354971159"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 11:03:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="600670829"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 06 May 2022 11:03:49 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 1/2] ice: link representors to PCI device
Date:   Fri,  6 May 2022 11:00:51 -0700
Message-Id: <20220506180052.5256-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220506180052.5256-1-anthony.l.nguyen@intel.com>
References: <20220506180052.5256-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

Link port representors to parent PCI device to benefit from
systemd defined naming scheme.

Example from ip tool:
 - without linking:
  eth0 ...
 - with linking:
  eth0 ...
  altname enp24s0f0npf0vf0

The port representor name is being shown in altname, because the name is
longer than IFNAMSIZ (16) limit. Altname can be used in ip tool.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_repr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_repr.c b/drivers/net/ethernet/intel/ice/ice_repr.c
index a91b81c3088b..0dac67cd9c77 100644
--- a/drivers/net/ethernet/intel/ice/ice_repr.c
+++ b/drivers/net/ethernet/intel/ice/ice_repr.c
@@ -338,6 +338,7 @@ static int ice_repr_add(struct ice_vf *vf)
 	repr->netdev->min_mtu = ETH_MIN_MTU;
 	repr->netdev->max_mtu = ICE_MAX_MTU;
 
+	SET_NETDEV_DEV(repr->netdev, ice_pf_to_dev(vf->pf));
 	err = ice_repr_reg_netdev(repr->netdev);
 	if (err)
 		goto err_netdev;
-- 
2.35.1

