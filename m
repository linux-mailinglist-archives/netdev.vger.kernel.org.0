Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE13639BB97
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 17:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbhFDPUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 11:20:02 -0400
Received: from mail.zx2c4.com ([104.131.123.232]:54988 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230366AbhFDPUB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 11:20:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1622819889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8N0Fk94XQEKy2fk7aF/Vhnx+Uu/pat84MbHqxv22CaE=;
        b=XDtvQcg+bjXtf8pgWiLbyiYgq0WB64kVllnsnS55AemklCOhibeV2Ne5TSZPEovBf5bREe
        ac4cMk6XcBsXUa5Oz1NsYWm5WWfs5ACfKzERFOFZuejYmSwObk23TwVJAH1Xa+3XaG6bmh
        Xbn/g/wLECyxPEhWI/G07XitG51II3o=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 82391298 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 4 Jun 2021 15:18:08 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: [PATCH net 6/9] wireguard: allowedips: initialize list head in selftest
Date:   Fri,  4 Jun 2021 17:17:35 +0200
Message-Id: <20210604151738.220232-7-Jason@zx2c4.com>
In-Reply-To: <20210604151738.220232-1-Jason@zx2c4.com>
References: <20210604151738.220232-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The randomized trie tests weren't initializing the dummy peer list head,
resulting in a NULL pointer dereference when used. Fix this by
initializing it in the randomized trie test, just like we do for the
static unit test.

While we're at it, all of the other strings like this have the word
"self-test", so add it to the missing place here.

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/selftest/allowedips.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireguard/selftest/allowedips.c b/drivers/net/wireguard/selftest/allowedips.c
index 846db14cb046..0d2a43a2d400 100644
--- a/drivers/net/wireguard/selftest/allowedips.c
+++ b/drivers/net/wireguard/selftest/allowedips.c
@@ -296,6 +296,7 @@ static __init bool randomized_test(void)
 			goto free;
 		}
 		kref_init(&peers[i]->refcount);
+		INIT_LIST_HEAD(&peers[i]->allowedips_list);
 	}
 
 	mutex_lock(&mutex);
@@ -333,7 +334,7 @@ static __init bool randomized_test(void)
 			if (wg_allowedips_insert_v4(&t,
 						    (struct in_addr *)mutated,
 						    cidr, peer, &mutex) < 0) {
-				pr_err("allowedips random malloc: FAIL\n");
+				pr_err("allowedips random self-test malloc: FAIL\n");
 				goto free_locked;
 			}
 			if (horrible_allowedips_insert_v4(&h,
-- 
2.31.1

