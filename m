Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED7B926AD3
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730070AbfEVTVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:21:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730027AbfEVTVk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:21:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 671ED2177E;
        Wed, 22 May 2019 19:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558552900;
        bh=eykYNv6pdyHVJDIhpL5jl/+NPZPjsRX9ZsWonZ/WAVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hI9jma/XAUPPHLgo4yfxUsIntTtSC1WCsywj+Vlw5D0YNA9U+ZAc5JUxUEISrVG5M
         u/Ff/0IPwqthoRjzZ25iqjSOCUXwtNo9UNmmdtibFclqsXAlCL3wkGdjIj40v+JD2T
         XYdjwFmhYy6m/lYSb1kkt7PeVdHtv+hMhENFAKJ8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 018/375] ice: Preserve VLAN Rx stripping settings
Date:   Wed, 22 May 2019 15:15:18 -0400
Message-Id: <20190522192115.22666-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192115.22666-1-sashal@kernel.org>
References: <20190522192115.22666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>

[ Upstream commit e80e76db6c5bbc7a8f8512f3dc630a2170745b0b ]

When Tx insertion is set, we are not accounting for the state of Rx
stripping.  This causes Rx stripping to be enabled any time Tx
insertion is changed, even when it's supposed to be disabled.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index fa61203bee269..b710545cf7d1a 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1848,6 +1848,10 @@ int ice_vsi_manage_vlan_insertion(struct ice_vsi *vsi)
 	 */
 	ctxt->info.vlan_flags = ICE_AQ_VSI_VLAN_MODE_ALL;
 
+	/* Preserve existing VLAN strip setting */
+	ctxt->info.vlan_flags |= (vsi->info.vlan_flags &
+				  ICE_AQ_VSI_VLAN_EMOD_M);
+
 	ctxt->info.valid_sections = cpu_to_le16(ICE_AQ_VSI_PROP_VLAN_VALID);
 
 	status = ice_update_vsi(hw, vsi->idx, ctxt, NULL);
-- 
2.20.1

