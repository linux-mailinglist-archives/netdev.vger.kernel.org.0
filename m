Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9791A0284
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 02:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgDGAEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 20:04:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728256AbgDGACs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 20:02:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B428F20842;
        Tue,  7 Apr 2020 00:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217768;
        bh=8PpGL1xkqmeHJ2Vira44+EEkc2xrM5AF6XsNGJQaXU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lO2HwfB1XsxWXdrn9aASwDIDFJsRqDlwMnD/EFCiQ+l5rSfq6hX8s8+/fvlkOK8xs
         a5ejtmPHe66GvgQPpQkO84VoRP7d9lOq4hKTe6RutGC3ororGkHytaJ2c76LGkRvZ8
         IT9aPIY9OLQIP3S0eXv/cfVjW7fylgAZodeNIIpY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Raju Rangoju <rajur@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 11/13] cxgb4/ptp: pass the sign of offset delta in FW CMD
Date:   Mon,  6 Apr 2020 20:02:32 -0400
Message-Id: <20200407000234.17088-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000234.17088-1-sashal@kernel.org>
References: <20200407000234.17088-1-sashal@kernel.org>
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
index 9f9d6cae39d55..758f2b8363282 100644
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

