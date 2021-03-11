Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5F16336A09
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 03:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhCKCKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 21:10:30 -0500
Received: from m12-14.163.com ([220.181.12.14]:33349 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhCKCKF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 21:10:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=qyUs4
        6i2FA688vwg0k0f54ioff9WxpH9cOp5ivb9sgM=; b=So5eQYKGDWqD2yBVzCjV6
        AoXT5+5s7T+3AlCM9b9abvMRRl8cqaeZ9u5mtyST7o/AhFjX4/OtJ4KawsmX2YVo
        c3J7e8uDy6y4cpncE1I75GVq0OryOdDpqg9etBCSSZiFFB76XwWfaWswcKaCU4Pd
        ezlmDVuLngGrk5uiWiIuZs=
Received: from yangjunlin.ccdomain.com (unknown [119.137.52.39])
        by smtp10 (Coremail) with SMTP id DsCowABndY29e0lgQ14Qow--.17433S2;
        Thu, 11 Mar 2021 10:09:02 +0800 (CST)
From:   angkery <angkery@163.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Junlin Yang <yangjunlin@yulong.com>
Subject: [PATCH] esp6: remove a duplicative condition
Date:   Thu, 11 Mar 2021 10:07:56 +0800
Message-Id: <20210311020756.1570-1-angkery@163.com>
X-Mailer: git-send-email 2.24.0.windows.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DsCowABndY29e0lgQ14Qow--.17433S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZF1DtF47KFy5JFy5AryDGFg_yoWfGFc_CF
        4v9FWUGFW8J34vyw1ayFWrWw12yw18uFZakry2g3y8Gw15Ar1rXrs2qr98CFWqgr1xWrW2
        qF4DuFy8Jry29jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8V6wtUUUUU==
X-Originating-IP: [119.137.52.39]
X-CM-SenderInfo: 5dqjyvlu16il2tof0z/1tbiKx9SI1QHWr82iAAAsN
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Junlin Yang <yangjunlin@yulong.com>

Fixes coccicheck warnings:
./net/ipv6/esp6_offload.c:319:32-34:
WARNING !A || A && B is equivalent to !A || B

Signed-off-by: Junlin Yang <yangjunlin@yulong.com>
---
 net/ipv6/esp6_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 1ca516f..631c168 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -316,7 +316,7 @@ static int esp6_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features
 	esp.plen = esp.clen - skb->len - esp.tfclen;
 	esp.tailen = esp.tfclen + esp.plen + alen;
 
-	if (!hw_offload || (hw_offload && !skb_is_gso(skb))) {
+	if (!hw_offload || !skb_is_gso(skb)) {
 		esp.nfrags = esp6_output_head(x, skb, &esp);
 		if (esp.nfrags < 0)
 			return esp.nfrags;
-- 
1.9.1


