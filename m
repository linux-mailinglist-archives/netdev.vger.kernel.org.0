Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 768F31A033D
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 02:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbgDGAH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 20:07:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727149AbgDGABh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 20:01:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B1ED207FF;
        Tue,  7 Apr 2020 00:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217696;
        bh=jO0bfRACoDqbJtxtvsGKsvpEltAHBXHauexTK0lbnSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iKy1Mfdtd9AXZq8p1jKT/a2Sgs0mGsB2vyC9j4J1dlLyjxkPH3q2T4DhNncPMlbgH
         3O+1NFcWja3glfSunvkaukaHULcJS3835rATG2QqJOJYPqDAmT9zf0co39weKNdJlx
         T2Jv18pkqgV11Yawu1r3VVg65pRENW/Y8dMvWEhE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Raju Rangoju <rajur@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 30/35] cxgb4/ptp: pass the sign of offset delta in FW CMD
Date:   Mon,  6 Apr 2020 20:00:52 -0400
Message-Id: <20200407000058.16423-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000058.16423-1-sashal@kernel.org>
References: <20200407000058.16423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raju Rangoju <rajur@chelsio.com>

[ Upstream commit 50e0d28d3808146cc19b0d5564ef4ba9e5bf3846 ]

cxgb4_ptp_fineadjtime() doesn't pass the signedness of offset delta
in FW_PTP_CMD. Fix it by passing correct sign.

Signed-off-by: Raju Rangoju <rajur@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
index 58a039c3224ad..af1f40cbccc88 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
@@ -246,6 +246,9 @@ static int  cxgb4_ptp_fineadjtime(struct adapter *adapter, s64 delta)
 			     FW_PTP_CMD_PORTID_V(0));
 	c.retval_len16 = cpu_to_be32(FW_CMD_LEN16_V(sizeof(c) / 16));
 	c.u.ts.sc = FW_PTP_SC_ADJ_FTIME;
+	c.u.ts.sign = (delta < 0) ? 1 : 0;
+	if (delta < 0)
+		delta = -delta;
 	c.u.ts.tm = cpu_to_be64(delta);
 
 	err = t4_wr_mbox(adapter, adapter->mbox, &c, sizeof(c), NULL);
-- 
2.20.1

