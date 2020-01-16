Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13CB213F8E3
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437804AbgAPTV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:21:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:38204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729164AbgAPQx7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:53:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 500DC2464B;
        Thu, 16 Jan 2020 16:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193639;
        bh=mUz6qZrJgnd1j+6KAws1RtLn1Uq8ghUFLn08Z1tBoys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hVdeG6VHL4BSWLPGmSA0CUNj+AK2ctgOFfijsHNfdmV6QSa8NahQQ6aEeZKQ0F8D3
         0hFZMPEgVIOhQ4vmhglyuSNh1qmmmkoAPiIImCvRLcWTNSnpcXmcWMRVQm0uPZdImF
         w0H4Igg2ABAAdVdLeO29/iq4/iJS8MWi0WmSjm3s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 171/205] ice: fix stack leakage
Date:   Thu, 16 Jan 2020 11:42:26 -0500
Message-Id: <20200116164300.6705-171-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

[ Upstream commit 949375de945f7042df2b6488228a1a2b36e69f35 ]

In the case of an invalid virtchannel request the driver
would return uninitialized data to the VF from the PF stack
which is a bug.  Fix by initializing the stack variable
earlier in the function before any return paths can be taken.

Fixes: 1071a8358a28 ("ice: Implement virtchnl commands for AVF support")
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index c0637a0cbfe8..e92a00a61755 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1873,8 +1873,8 @@ static int ice_vc_get_stats_msg(struct ice_vf *vf, u8 *msg)
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
 	struct virtchnl_queue_select *vqs =
 		(struct virtchnl_queue_select *)msg;
+	struct ice_eth_stats stats = { 0 };
 	struct ice_pf *pf = vf->pf;
-	struct ice_eth_stats stats;
 	struct ice_vsi *vsi;
 
 	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
@@ -1893,7 +1893,6 @@ static int ice_vc_get_stats_msg(struct ice_vf *vf, u8 *msg)
 		goto error_param;
 	}
 
-	memset(&stats, 0, sizeof(struct ice_eth_stats));
 	ice_update_eth_stats(vsi);
 
 	stats = vsi->eth_stats;
-- 
2.20.1

