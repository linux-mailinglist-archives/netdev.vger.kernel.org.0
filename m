Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B28CC176CAF
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 03:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbgCCCsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 21:48:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:43680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728320AbgCCCsK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:48:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2363524684;
        Tue,  3 Mar 2020 02:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203689;
        bh=Ho1cPRcKntrvSArDkTbaHQDH8u9RrePjTmWNe/XsDv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ve+RIeFhbI4X0ST2nrcqYzNmFa0LXf72rlqkBwi6qLlPBrg8aHDUet71Babfs/Mex
         +PD/UOSbeD+4sL6ppNb0UaGWokCr6Ntcg/nGboZaxDS6xEzSuD13LEBatleMF00siJ
         k6Ia64zppnCx1waDopExP6X0tBNyWBV8drwtQnPc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Bogdanov <dbogdanov@marvell.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 24/58] net: atlantic: fix out of range usage of active_vlans array
Date:   Mon,  2 Mar 2020 21:47:06 -0500
Message-Id: <20200303024740.9511-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024740.9511-1-sashal@kernel.org>
References: <20200303024740.9511-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

[ Upstream commit 5a292c89a84d49b598f8978f154bdda48b1072c0 ]

fix static checker warning:
 drivers/net/ethernet/aquantia/atlantic/aq_filters.c:166 aq_check_approve_fvlan()
 error: passing untrusted data to 'test_bit()'

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 7975d2aff5af: ("net: aquantia: add support of rx-vlan-filter offload")
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_filters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_filters.c b/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
index aee827f07c160..01af0f028693d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
@@ -158,7 +158,7 @@ aq_check_approve_fvlan(struct aq_nic_s *aq_nic,
 	}
 
 	if ((aq_nic->ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER) &&
-	    (!test_bit(be16_to_cpu(fsp->h_ext.vlan_tci),
+	    (!test_bit(be16_to_cpu(fsp->h_ext.vlan_tci) & VLAN_VID_MASK,
 		       aq_nic->active_vlans))) {
 		netdev_err(aq_nic->ndev,
 			   "ethtool: unknown vlan-id specified");
-- 
2.20.1

