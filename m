Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9E6F473C
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 12:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391730AbfKHLsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:48:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:37392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389985AbfKHLsW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:48:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 565A4222CE;
        Fri,  8 Nov 2019 11:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213702;
        bh=xEv4H0IgVHYmb74M4fjlkD9XU6PYj9n5CKOA9uGY6UY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fQCc0olz/1T/5MXoBgSmzm1qUqXiivcoXlGvF/q1Lf1U4DBOmAVoyVf8rMScnSrrs
         6tnO6ZwYT9nOCeTM+Ge9chQAGuDiQRQcG9eQzg1JWL9ka9gSEzURECKu6mPBqV+vFl
         pp1/rY2Z7c5Pu1x4ExFRVpyCPAOdIqCXKmvVV7WY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ganesh Goudar <ganeshgr@chelsio.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 41/44] cxgb4: Fix endianness issue in t4_fwcache()
Date:   Fri,  8 Nov 2019 06:47:17 -0500
Message-Id: <20191108114721.15944-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114721.15944-1-sashal@kernel.org>
References: <20191108114721.15944-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ganesh Goudar <ganeshgr@chelsio.com>

[ Upstream commit 0dc235afc59a226d951352b0adf4a89b532a9d13 ]

Do not put host-endian 0 or 1 into big endian feild.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Ganesh Goudar <ganeshgr@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index de23f23b41de6..832ad1bd1f29b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -3482,7 +3482,7 @@ int t4_fwcache(struct adapter *adap, enum fw_params_param_dev_fwcache op)
 	c.param[0].mnem =
 		cpu_to_be32(FW_PARAMS_MNEM_V(FW_PARAMS_MNEM_DEV) |
 			    FW_PARAMS_PARAM_X_V(FW_PARAMS_PARAM_DEV_FWCACHE));
-	c.param[0].val = (__force __be32)op;
+	c.param[0].val = cpu_to_be32(op);
 
 	return t4_wr_mbox(adap, adap->mbox, &c, sizeof(c), NULL);
 }
-- 
2.20.1

