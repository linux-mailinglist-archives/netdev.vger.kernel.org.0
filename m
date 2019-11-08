Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86DF6F4918
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390553AbfKHLnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:43:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:58396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390548AbfKHLnp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:43:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE3312245A;
        Fri,  8 Nov 2019 11:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213424;
        bh=Cdus/gAvNXvi3IDL1oBXL6KZRkw3aCvgjmB2QuoDHTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bgZtcsAX1rDO+7N7yQ8EeQAw41H+NYCaReo/17vrUTlfHip5faZ7Q4qg3G8V8sCEf
         noczX3+XvOwO8U+0ZietqswJKJopFI0VCsqb5hZfqEW83o5s+4MNq++/y6GH9qyF+8
         0ikwzB0hPLxnpkzhSSy2geueVZ+SRNRX5sUGKTqA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Patryk=20Ma=C5=82ek?= <patryk.malek@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 026/103] i40e: Prevent deleting MAC address from VF when set by PF
Date:   Fri,  8 Nov 2019 06:41:51 -0500
Message-Id: <20191108114310.14363-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114310.14363-1-sashal@kernel.org>
References: <20191108114310.14363-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Patryk Małek <patryk.malek@intel.com>

[ Upstream commit 5907cf6c5bbe78be2ed18b875b316c6028b20634 ]

To prevent VF from deleting MAC address that was assigned by the
PF we need to check for that scenario when we try to delete a MAC
address from a VF.

Signed-off-by: Patryk Małek <patryk.malek@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index bdb7523216000..b3307b1b3aac1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2177,6 +2177,16 @@ static int i40e_vc_del_mac_addr_msg(struct i40e_vf *vf, u8 *msg, u16 msglen)
 			ret = I40E_ERR_INVALID_MAC_ADDR;
 			goto error_param;
 		}
+
+		if (vf->pf_set_mac &&
+		    ether_addr_equal(al->list[i].addr,
+				     vf->default_lan_addr.addr)) {
+			dev_err(&pf->pdev->dev,
+				"MAC addr %pM has been set by PF, cannot delete it for VF %d, reset VF to change MAC addr\n",
+				vf->default_lan_addr.addr, vf->vf_id);
+			ret = I40E_ERR_PARAM;
+			goto error_param;
+		}
 	}
 	vsi = pf->vsi[vf->lan_vsi_idx];
 
-- 
2.20.1

