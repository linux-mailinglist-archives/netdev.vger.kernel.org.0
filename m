Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1FE696D58
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 19:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbjBNSw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 13:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233135AbjBNSw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 13:52:26 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF1E6A65;
        Tue, 14 Feb 2023 10:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676400745; x=1707936745;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RXbhKY5wFfwHhh+TFY5YqxV+80c2QkNRiBo1yEzaKIk=;
  b=B9pH457mJGS/dnfKvLnKzAdmFGw/rd9wZ4Wj1BM3y0mBEg+OcbhBgTYB
   DS6oQwSUGz9JU8uuNtoVLXX+17g6ZbG1PjeGnfi0R1A+d/kVjPfarhILI
   xz7uxKkyCC2k5fbuCJR5SIen9fokKf5e6gXMyxheOyVLh7G7GCAMch5+Y
   bwrhLnPZl/Ds7k19I237o30ZHe6/FeWQu2UIXQu4qCkBwdIG9N5gEbzoO
   pZuflH2eNUG7SWHZL8sh+XW3ozDTBK+YpPRjWQ/Jqvi/sHXkG6bhJ/wG2
   ZHzm2kDtz2RaUazzcIzxaia7L3vBtBxQbd4hknBIn3gXhN+39bW5eLooi
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="329866056"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="329866056"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 10:52:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="619159899"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="619159899"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga003.jf.intel.com with ESMTP; 14 Feb 2023 10:52:23 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jason Xing <kernelxing@tencent.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        bjorn@kernel.org, Alexander Duyck <alexanderduyck@fb.com>,
        Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH net 2/3] i40e: add double of VLAN header when computing the max MTU
Date:   Tue, 14 Feb 2023 10:51:45 -0800
Message-Id: <20230214185146.1305819-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230214185146.1305819-1-anthony.l.nguyen@intel.com>
References: <20230214185146.1305819-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Xing <kernelxing@tencent.com>

Include the second VLAN HLEN into account when computing the maximum
MTU size as other drivers do.

Fixes: 0c8493d90b6b ("i40e: add XDP support for pass and drop actions")
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 4626d2a1af91..52eec0a50492 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -2921,7 +2921,7 @@ static int i40e_change_mtu(struct net_device *netdev, int new_mtu)
 	struct i40e_pf *pf = vsi->back;
 
 	if (i40e_enabled_xdp_vsi(vsi)) {
-		int frame_size = new_mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
+		int frame_size = new_mtu + I40E_PACKET_HDR_PAD;
 
 		if (frame_size > i40e_max_xdp_frame_size(vsi))
 			return -EINVAL;
-- 
2.38.1

