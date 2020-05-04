Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A921C34E4
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgEDIvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728266AbgEDIvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:51:04 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622A9C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 01:51:04 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id f8so6532027plt.2
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 01:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=URJDNd1lJ+QuNmxk9ITDFWobbJ2DGUF90uU6aEClO9M=;
        b=d5pnGWQyUeLUgstbibjALE0o5xy0DbF+6ZHZOHEIxcWaH3W8AKA6CIVr2Q8kyeVPEE
         gB/F+R9I6JNrHIf4ho+aWj6y9ZHbHSWU/R/H7RGhkhMgcbe5lhEfN12uTRF0SQcyo5fq
         Jw2izKxOFp4AKQxSP4cggZanST5gkP3Ik3YVA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=URJDNd1lJ+QuNmxk9ITDFWobbJ2DGUF90uU6aEClO9M=;
        b=WELj7hGGqUPhkBB2cHLAqrt/HHLiL7gGu+UwxfagG1FxXC5sH1GYq5Z3mnw/x9oSL5
         jW2y4D2WKJt/52X6cH8be5n+emlSfEy20wUDuyLZhzVZ0Xrn3pW36q/0EgXw4lkB1vNV
         N+JOgOm+ThZBL43owxAvyfmtE6AGmOdnRdHnlS36DCmz0+W33Rs9kJE1EcgXKMmIOP0e
         LD3yr3CwF83y/Q5rtISFmv3lDp/n3RG24cvb9D0DgEY+myJEpPfA9SgyMCzfknggg7aw
         i/3tUDUZGucW+djTwD6cQKBClWB2pTX1AUovm7b1x8EwPsew0K1DVYyUV6O+lQG/jydk
         KYTA==
X-Gm-Message-State: AGi0PubyNCV2sPZ5KurdhfBjJh3EFzGKaQe8D1F7ZPfK688dbM4z0/hG
        M6Z5S0Zrnw76oItkRZ60wQ3g9sLDSgA=
X-Google-Smtp-Source: APiQypKx+aI4tKB4IYUYnFzoTmnu0TMl+OMU2PCACS80tQ+25+M8iLAkQeHUwxNvRsj9RGadRET66Q==
X-Received: by 2002:a17:90a:f2ca:: with SMTP id gt10mr15633089pjb.160.1588582263848;
        Mon, 04 May 2020 01:51:03 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x193sm8754088pfd.54.2020.05.04.01.51.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 01:51:03 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 04/15] bnxt_en: Do not include ETH_FCS_LEN in the max packet length sent to fw.
Date:   Mon,  4 May 2020 04:50:30 -0400
Message-Id: <1588582241-31066-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
References: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

The firmware does not expect the CRC to be included in the length
passed from the driver.  The firmware always configures the chip
to strip out the CRC.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c       | 3 +--
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 0cf41a1..5919f72 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -5045,8 +5045,7 @@ int bnxt_hwrm_vnic_cfg(struct bnxt *bp, u16 vnic_id)
 	req.dflt_ring_grp = cpu_to_le16(bp->grp_info[grp_idx].fw_grp_id);
 	req.lb_rule = cpu_to_le16(0xffff);
 vnic_mru:
-	req.mru = cpu_to_le16(bp->dev->mtu + ETH_HLEN + ETH_FCS_LEN +
-			      VLAN_HLEN);
+	req.mru = cpu_to_le16(bp->dev->mtu + ETH_HLEN + VLAN_HLEN);
 
 	req.vnic_id = cpu_to_le16(vnic->fw_vnic_id);
 #ifdef CONFIG_BNXT_SRIOV
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index 6ea3df6d..c883e88 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -651,7 +651,7 @@ static int bnxt_hwrm_func_cfg(struct bnxt *bp, int num_vfs)
 				  FUNC_CFG_REQ_ENABLES_NUM_VNICS |
 				  FUNC_CFG_REQ_ENABLES_NUM_HW_RING_GRPS);
 
-	mtu = bp->dev->mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
+	mtu = bp->dev->mtu + ETH_HLEN + VLAN_HLEN;
 	req.mru = cpu_to_le16(mtu);
 	req.mtu = cpu_to_le16(mtu);
 
-- 
2.5.1

