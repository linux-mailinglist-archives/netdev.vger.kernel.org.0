Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA6D1AA326
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 15:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505885AbgDONE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 09:04:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897129AbgDOLgP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 07:36:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B041020775;
        Wed, 15 Apr 2020 11:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950575;
        bh=L2mnsrtXI6WPK/FDKmAyKYl2fu/wyu8NGUz3KTMXS2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ltxFUR2j/tLVeD2QEO4tWaamLoXD2QcGQ/WdyV5zFvpjJfMlyMsPiIwDJaglZ1wWU
         uV3bpbi0IGIxUHIp1iWD+nRrFEuX1aGQ57O7KxNGflpL/csHrQ1GyaoCVdGBGPKwfs
         t7+cvMmq6tNrSuynHbf/5rxwMxRhclS6LlPK/txI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Davide Caratti <dcaratti@redhat.com>,
        syzbot+7022ab7c383875c17eff@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 076/129] macsec: fix NULL dereference in macsec_upd_offload()
Date:   Wed, 15 Apr 2020 07:33:51 -0400
Message-Id: <20200415113445.11881-76-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit aa81700cf2326e288c9ca1fe7b544039617f1fc2 ]

macsec_upd_offload() gets the value of MACSEC_OFFLOAD_ATTR_TYPE
without checking its presence in the request message, and this causes
a NULL dereference. Fix it rejecting any configuration that does not
include this attribute.

Reported-and-tested-by: syzbot+7022ab7c383875c17eff@syzkaller.appspotmail.com
Fixes: dcb780fb2795 ("net: macsec: add nla support for changing the offloading selection")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 92bc2b2df6603..3cd1b13dffe5f 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2398,6 +2398,9 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 		return PTR_ERR(dev);
 	macsec = macsec_priv(dev);
 
+	if (!tb_offload[MACSEC_OFFLOAD_ATTR_TYPE])
+		return -EINVAL;
+
 	offload = nla_get_u8(tb_offload[MACSEC_OFFLOAD_ATTR_TYPE]);
 	if (macsec->offload == offload)
 		return 0;
-- 
2.20.1

