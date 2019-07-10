Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBA6646C3
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 15:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfGJNGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 09:06:48 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:38051 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfGJNGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 09:06:48 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1M3D7V-1hm2JW3OeL-003g8Z; Wed, 10 Jul 2019 15:06:39 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH] [net-next] net/mlx5e: avoid uninitialized variable use
Date:   Wed, 10 Jul 2019 15:06:25 +0200
Message-Id: <20190710130638.1846846-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:OagwmaqadWf3LLlQrhjJSVaeSjbS3TmtJcZ3CrnuAX5DMD8ITzm
 ktDnEOx8Fav3TkBNgGmRuBDQcd+O3uMS/DPb2l7nlkQq5APDDTOu0xhxM/FosKfuEiwQ3FX
 esCE9oodv/0lVTx8ELKsL5sepuUzlb3hNy3apL9fStL50eDfVCFs7TawPDuvRFZoDD0Hizj
 i8NqlXEBkMxuxPLUImkdw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:oIx5To/fs4o=:lfiVVCDpGws6UHS6mAlZTB
 jEFGRZpVp2MJvuVB+0yviZaF37r7+EmQuWVHNU1N1L7/TEKw5kfsCgDL/f8LSoii/cFfdVDaA
 7ASsNalRexdaRr8JTNNPlJ4ZbpZaP8vjlzUIeQZfGUbL8g7OOKPhHEUi+PNNWYkQkHwcn9eet
 56ONXWrSxn4J6vQJhzPysXJHBg5Ek0Ez6EFpL418qaKMF8ML0qbOQa6Vqt1AyHeFzfjnrjyE1
 xH5Ry0K2d5F95OWo3Xotiq+CTS59LoNXRM/NH8BsU5DIRXcaILh4epHgKBd+DcI3a69V1NuSC
 RIPyB3YAOVnfijM8JWyjGoMUXtNs7FDImBLCT7dg+nOWLtjd8n6noZUCWSgwmDbsEmIDIM+Jd
 vJbEhl4WdIVsENmwCl/Nv+/yxooqpizffGwd6P1vB5jC5ru04Ejz4YAQWPFdi/8bjKkasWRPK
 +oUFIYM78QYVgZqey5MguGbG6C4m6dyxZdv0lVWoQLCjznBCpXPuc1aNTa8pRhkSTtjHcAaf/
 wa5vFC3AAS21irUkxEPtwpxztJxU8w34SNIRDaTBzMFA0Rg3VAb4Y6ongwXEyof8075tmG794
 PqRQVYh2sBew32Z+Z85umbqN42uM9QmEv6idXzARiXxM75EnxTyeczOhKOq3gGvhAO0nKxwNn
 lYyeaXbGC6rUms044EuYhd2QcppJqJ2Pc4jAbg/E1aWhijn+dbShVYLmo1mXA9D/WMcv3cYYl
 il78i9PP1ey995GCxW3PltDZ64R40fUG1g1VMA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang points to a variable being used in an unexpected
code path:

drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c:251:2: warning: variable 'rec_seq_sz' is used uninitialized whenever switch default is taken [-Wsometimes-uninitialized]
        default:
        ^~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c:255:46: note: uninitialized use occurs here
        skip_static_post = !memcmp(rec_seq, &rn_be, rec_seq_sz);
                                                    ^~~~~~~~~~

From looking at the function logic, it seems that there is no
sensible way to continue here, so just return early and hope
for the best.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 3f5f4317a22b..5c08891806f0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -250,6 +250,7 @@ tx_post_resync_params(struct mlx5e_txqsq *sq,
 	}
 	default:
 		WARN_ON(1);
+		return;
 	}
 
 	skip_static_post = !memcmp(rec_seq, &rn_be, rec_seq_sz);
-- 
2.20.0

