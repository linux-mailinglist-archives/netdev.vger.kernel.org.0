Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5891302B2
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 15:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgADOdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 09:33:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:46648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725924AbgADOdP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Jan 2020 09:33:15 -0500
Received: from localhost.localdomain (unknown [194.230.155.149])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB4C524650;
        Sat,  4 Jan 2020 14:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578148394;
        bh=YeNEiLUWQA87Z0m6j5gu6gXNwNO93yKxXGJ9/FGVlQQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=YdKu57Wytfnm3qTlKA0BW018kdDOc4IF0EzgA9r2Fh3gMYpM7rpCnWCqsMGLKYE/I
         h9BSfDIJi820i5bQCMNu2W3DL2Cqd6QSB5BoZ4dtBmLGugqXKVm0mVx8vrOGePZD5q
         RwhqAy3rkgvwlbFaRPtgkroxITpDa1NgaqaCPY98=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzk@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] net: ethernet: ni65: Fix cast from pointer to integer of different size
Date:   Sat,  4 Jan 2020 15:33:06 +0100
Message-Id: <20200104143306.21210-2-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200104143306.21210-1-krzk@kernel.org>
References: <20200104143306.21210-1-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"buffer" array is unsigned long so casting of pointer to u32 causes
warning (compile testing on alpha architecture):

    drivers/net/ethernet/amd/ni65.c: In function ‘ni65_stop_start’:
    drivers/net/ethernet/amd/ni65.c:751:16: warning:
        cast from pointer to integer of different size [-Wpointer-to-int-cast]

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

---

Only compile tested
---
 drivers/net/ethernet/amd/ni65.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/ni65.c b/drivers/net/ethernet/amd/ni65.c
index c38edf6f03a3..60c194680bdf 100644
--- a/drivers/net/ethernet/amd/ni65.c
+++ b/drivers/net/ethernet/amd/ni65.c
@@ -748,7 +748,7 @@ static void ni65_stop_start(struct net_device *dev,struct priv *p)
 #ifdef XMT_VIA_SKB
 			skb_save[i] = p->tmd_skb[i];
 #endif
-			buffer[i] = (u32) isa_bus_to_virt(tmdp->u.buffer);
+			buffer[i] = (unsigned long)isa_bus_to_virt(tmdp->u.buffer);
 			blen[i] = tmdp->blen;
 			tmdp->u.s.status = 0x0;
 		}
-- 
2.17.1

