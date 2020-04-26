Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB341B93E8
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 22:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgDZUZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 16:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726179AbgDZUZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 16:25:04 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8766DC061A0F
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 13:25:04 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x77so7816940pfc.0
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 13:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eO4crjTLwI6JVx+A0mzWtJlpBFRg/SfyBO+R32Th9B8=;
        b=FARyNrqvx7B2tYltgxLruFkehKvjca9M6/dmay0GNG7vqgGs9yufmIzBUazj0neKMk
         NsmffU1M31X2luambDFxnCCJkwzzan6s1E/kj7bh7FBse82bgeGWVzjc6T4ANLjPAi51
         Z7BhG3712A8kGaU/8Cj+Pp5zSzCGWE62ai+P4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eO4crjTLwI6JVx+A0mzWtJlpBFRg/SfyBO+R32Th9B8=;
        b=gzJcw/YDQdtBAjG2Tb7+GSE26iGR54sJku3bBKLB5bwngTVv/4JKZzYJ1c8746Mi2i
         Xk57svSuWrN6y4S6uJN1Ydrk7kIl6ZF5Q+PbzdClk6fvVObGhUvcfmGolLvOPFXn7AA3
         zSMOB+dQkogyk7oJZICZ6jCpP85oKnpbfQl/K3jopycJcDb8O01kK02Zg3mTjKpzK26/
         aN5qRpf0IZg1gx2HU/xvzQw3ZfvnaBWcPm+fcJ4kidW4V1XAfrPl1MJPAxJuX93xDVnQ
         9l6TvXVcvYbBAufwRWdMxZWT7byV+MI7nQIgCmqCqfWKW9U+qBxeJ21zrxELu/ZgAZtz
         yN+Q==
X-Gm-Message-State: AGi0PuYgTqjjrQsKPOyNah2LYV2D2jQlScOLUzmsfji90PNOhhRIoGZN
        oulJ61QTf6Fg5LjbRfQQfT8afV5cH/c=
X-Google-Smtp-Source: APiQypLq5BKwqGQArEj1JIVd2SmamsWNPBjnP6GcX2aYqyX1XViA/5Tla24ldYauwv+w57EKU9QgDA==
X-Received: by 2002:a63:5657:: with SMTP id g23mr19198525pgm.224.1587932704040;
        Sun, 26 Apr 2020 13:25:04 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a136sm10862103pfa.99.2020.04.26.13.25.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Apr 2020 13:25:03 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 1/5] bnxt_en: Fix VF anti-spoof filter setup.
Date:   Sun, 26 Apr 2020 16:24:38 -0400
Message-Id: <1587932682-1212-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587932682-1212-1-git-send-email-michael.chan@broadcom.com>
References: <1587932682-1212-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the logic that sets the enable/disable flag for the source MAC
filter according to firmware spec 1.7.1.

In the original firmware spec. before 1.7.1, the VF spoof check flags
were not latched after making the HWRM_FUNC_CFG call, so there was a
need to keep the func_flags so that subsequent calls would perserve
the VF spoof check setting.  A change was made in the 1.7.1 spec
so that the flags became latched.  So we now set or clear the anti-
spoof setting directly without retrieving the old settings in the
stored vf->func_flags which are no longer valid.  We also remove the
unneeded vf->func_flags.

Fixes: 8eb992e876a8 ("bnxt_en: Update firmware interface spec to 1.7.6.2.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h       |  1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c | 10 ++--------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index f2caa27..f6a3250 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1066,7 +1066,6 @@ struct bnxt_vf_info {
 #define BNXT_VF_LINK_FORCED	0x4
 #define BNXT_VF_LINK_UP		0x8
 #define BNXT_VF_TRUST		0x10
-	u32	func_flags; /* func cfg flags */
 	u32	min_tx_rate;
 	u32	max_tx_rate;
 	void	*hwrm_cmd_req_addr;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index 6ea3df6d..cea2f99 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -85,11 +85,10 @@ int bnxt_set_vf_spoofchk(struct net_device *dev, int vf_id, bool setting)
 	if (old_setting == setting)
 		return 0;
 
-	func_flags = vf->func_flags;
 	if (setting)
-		func_flags |= FUNC_CFG_REQ_FLAGS_SRC_MAC_ADDR_CHECK_ENABLE;
+		func_flags = FUNC_CFG_REQ_FLAGS_SRC_MAC_ADDR_CHECK_ENABLE;
 	else
-		func_flags |= FUNC_CFG_REQ_FLAGS_SRC_MAC_ADDR_CHECK_DISABLE;
+		func_flags = FUNC_CFG_REQ_FLAGS_SRC_MAC_ADDR_CHECK_DISABLE;
 	/*TODO: if the driver supports VLAN filter on guest VLAN,
 	 * the spoof check should also include vlan anti-spoofing
 	 */
@@ -98,7 +97,6 @@ int bnxt_set_vf_spoofchk(struct net_device *dev, int vf_id, bool setting)
 	req.flags = cpu_to_le32(func_flags);
 	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 	if (!rc) {
-		vf->func_flags = func_flags;
 		if (setting)
 			vf->flags |= BNXT_VF_SPOOFCHK;
 		else
@@ -228,7 +226,6 @@ int bnxt_set_vf_mac(struct net_device *dev, int vf_id, u8 *mac)
 	memcpy(vf->mac_addr, mac, ETH_ALEN);
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_CFG, -1, -1);
 	req.fid = cpu_to_le16(vf->fw_fid);
-	req.flags = cpu_to_le32(vf->func_flags);
 	req.enables = cpu_to_le32(FUNC_CFG_REQ_ENABLES_DFLT_MAC_ADDR);
 	memcpy(req.dflt_mac_addr, mac, ETH_ALEN);
 	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
@@ -266,7 +263,6 @@ int bnxt_set_vf_vlan(struct net_device *dev, int vf_id, u16 vlan_id, u8 qos,
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_CFG, -1, -1);
 	req.fid = cpu_to_le16(vf->fw_fid);
-	req.flags = cpu_to_le32(vf->func_flags);
 	req.dflt_vlan = cpu_to_le16(vlan_tag);
 	req.enables = cpu_to_le32(FUNC_CFG_REQ_ENABLES_DFLT_VLAN);
 	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
@@ -305,7 +301,6 @@ int bnxt_set_vf_bw(struct net_device *dev, int vf_id, int min_tx_rate,
 		return 0;
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_CFG, -1, -1);
 	req.fid = cpu_to_le16(vf->fw_fid);
-	req.flags = cpu_to_le32(vf->func_flags);
 	req.enables = cpu_to_le32(FUNC_CFG_REQ_ENABLES_MAX_BW);
 	req.max_bw = cpu_to_le32(max_tx_rate);
 	req.enables |= cpu_to_le32(FUNC_CFG_REQ_ENABLES_MIN_BW);
@@ -477,7 +472,6 @@ static void __bnxt_set_vf_params(struct bnxt *bp, int vf_id)
 	vf = &bp->pf.vf[vf_id];
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_CFG, -1, -1);
 	req.fid = cpu_to_le16(vf->fw_fid);
-	req.flags = cpu_to_le32(vf->func_flags);
 
 	if (is_valid_ether_addr(vf->mac_addr)) {
 		req.enables |= cpu_to_le32(FUNC_CFG_REQ_ENABLES_DFLT_MAC_ADDR);
-- 
2.5.1

