Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9003D12B723
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbfL0Roz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:44:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:43250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728128AbfL0Roy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:44:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7E0D206F4;
        Fri, 27 Dec 2019 17:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468693;
        bh=ZmekE+k1PgyuB6/a4NtSTGrTldWGFVwuQzAQvua1n2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LOwhL4RmPqCJPSLe0YPC8fbIxbWGSF9SxdfqrDxA+J1FiPAFdtQmGnAjOLjBwDHkE
         uE8n82/kDqwtcOYBWryNwNq9vlscpragl32f5Rw4m3o0DbL2s3wsFJ23eT6cwcVPXW
         GbkmBP2e4A4n1s3n0exH/zke6e1iqCXLl5iHd+Eg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manish Chopra <manishc@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 50/84] bnx2x: Fix logic to get total no. of PFs per engine
Date:   Fri, 27 Dec 2019 12:43:18 -0500
Message-Id: <20191227174352.6264-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174352.6264-1-sashal@kernel.org>
References: <20191227174352.6264-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manish Chopra <manishc@marvell.com>

[ Upstream commit ee699f89bdbaa19c399804504241b5c531b48888 ]

Driver doesn't calculate total number of PFs configured on a
given engine correctly which messed up resources in the PFs
loaded on that engine, leading driver to exceed configuration
of resources (like vlan filters etc.) beyond the limit per
engine, which ended up with asserts from the firmware.

Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
index ee5159ef837e..df5e8c2e8eaf 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
@@ -1113,7 +1113,7 @@ static inline u8 bnx2x_get_path_func_num(struct bnx2x *bp)
 		for (i = 0; i < E1H_FUNC_MAX / 2; i++) {
 			u32 func_config =
 				MF_CFG_RD(bp,
-					  func_mf_config[BP_PORT(bp) + 2 * i].
+					  func_mf_config[BP_PATH(bp) + 2 * i].
 					  config);
 			func_num +=
 				((func_config & FUNC_MF_CFG_FUNC_HIDE) ? 0 : 1);
-- 
2.20.1

