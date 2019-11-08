Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEB1DF46F3
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 12:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731965AbfKHLqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:46:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:33748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733307AbfKHLqJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:46:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA0C020656;
        Fri,  8 Nov 2019 11:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213568;
        bh=fp4JUvyBejBKU6QRe+D7+l2nCEkoKaaJfl7XBKfJXvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K+9lT1rKiw0p9hf0RTqgOd5efxYuioNFDBT5odLP9g/FQhiu0ll+qWnTHIzxT3KLJ
         Xgv3X9Li2PYA5T8So4xsFRI9fqkkulQRBIUlCB409GuPOjIsfvOsH0ig7RRo2ndPlA
         3uto4XuMUt9eq/ftHcUu2+fhu20U69TdA9oi4oFY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Patryk=20Ma=C5=82ek?= <patryk.malek@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 16/64] i40e: Prevent deleting MAC address from VF when set by PF
Date:   Fri,  8 Nov 2019 06:44:57 -0500
Message-Id: <20191108114545.15351-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114545.15351-1-sashal@kernel.org>
References: <20191108114545.15351-1-sashal@kernel.org>
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
index 54b8ee2583f14..7484ad3c955db 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2000,6 +2000,16 @@ static int i40e_vc_del_mac_addr_msg(struct i40e_vf *vf, u8 *msg, u16 msglen)
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

