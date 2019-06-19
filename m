Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9EE14B9FA
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 15:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729947AbfFSNbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 09:31:36 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:38789 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbfFSNbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 09:31:35 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MvKL3-1iUrtQ41zN-00rI0D; Wed, 19 Jun 2019 15:31:30 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Shalom Toledo <shalomt@mellanox.com>,
        Petr Machata <petrm@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mlxsw: spectrum_ptp: fix 32-bit build
Date:   Wed, 19 Jun 2019 15:31:20 +0200
Message-Id: <20190619133128.2259960-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:1TWk/Z00tbKqf5RqEcaX5nccgV/fe9V9aNFZmpdUUYBakGdbGvV
 C+8I324XtE3JT/iwJHKTqKf1+NU7h1FM9RiZJoUaisjO1vKrymmldWMUctjLMLiZLcCGIix
 YYekoaHxNiKne20tF5Y62n7BA7XD4z5k5uDEobwOxEdN8dPVjfGTQs90R+yRoynQ4/1W6Ev
 Ygo3OIn9RDZA4vrnpVGUw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:hijGal6cEgc=:RGWiW7YwuVIpQI4lNop8tf
 R1vbjyIRNCvZb9IH8qwZaAtofbWWx2zA+vrPrTxI9C4+4oEI8Rwrcpkv8jtfM3tAtbjDN/ZoG
 rwrga+kU4m97DPnxFvVxxXJXNUTgIngENLbgegyonF8Qe6Xj8H5vLSz9Mu8OKY/F63iT1OGGv
 n8iaA5fGA8yJ3Eb9ZNpYE+4Tz66SbauxsYhrkVrydCY7Xm00UfpJeHoAkKo/9T6irlfkHwEAN
 /v2hHCn2bjZCWrY6R6K/LKuDu9zQmzZh8mtQcvzOMG0MOr+JYS9iGygAXR7YdalOAPmhePqE6
 t2XEfMUYsEQSV6KWQpw6mB/itCX1jrurN9SzA/uGcpxuPtKKqc3SaD2kGllf4ELGiUEO3/Ck3
 NNVfq5rV/Co/hAbB8AmDhsqM97ufmDR8IZhUMqymqt21nzher4HYghw+SvnGBfppllbUVL2wd
 SrlIR8KuKjyIKBmIFHLIgTpnMusbdZqsfShztCjRXQYeJJXXhuaoAGv0RryxX/UYRK+E/JOb5
 QtL5feupo7TwWfLmSoaVIc+YtZ1abfFRgOhYIYIe3WUrOIa8vHthCHq324GTo9JWxHOAVmzkQ
 UwYI0u6D5G44bvKQ+yQkKdh4fjr5R2iiyc8unWCG+4EHXI7FuwgNoiInhCXEZRuq+2EOrobc1
 zcKb82PdwCk91FEhFSk5D3sL1pnXTDy+UFNd1E1Tf5YBwwabk39lLJiszyuc5+1Hk4XW0xNZu
 fWKIg9P+u3Wb2uxHysiODn/4KxZlcDN2rpPqmQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 32-bit architectures, we cannot easily device 64-bit numbers:

ERROR: "__aeabi_uldivmod" [drivers/net/ethernet/mellanox/mlxsw/mlxsw_spectrum.ko] undefined!

Use do_div() to annotate the fact that we know this is an
expensive operation.

Fixes: 992aa864dca0 ("mlxsw: spectrum_ptp: Add implementation for physical hardware clock operations")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 2a9bbc90225e..618e329e1490 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -87,7 +87,7 @@ mlxsw_sp1_ptp_phc_settime(struct mlxsw_sp_ptp_clock *clock, u64 nsec)
 	u32 next_sec;
 	int err;
 
-	next_sec = nsec / NSEC_PER_SEC + 1;
+	next_sec = div_u64(nsec, NSEC_PER_SEC) + 1;
 	next_sec_in_nsec = next_sec * NSEC_PER_SEC;
 
 	spin_lock(&clock->lock);
-- 
2.20.0

