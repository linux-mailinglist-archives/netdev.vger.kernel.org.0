Return-Path: <netdev+bounces-10499-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6139872EBD6
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:23:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12EBD280FA1
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:23:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17DDE3AE62;
	Tue, 13 Jun 2023 19:23:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099B81ED40
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 19:23:17 +0000 (UTC)
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352D01A5;
	Tue, 13 Jun 2023 12:23:14 -0700 (PDT)
Received: from fpc.intra.ispras.ru (unknown [10.10.165.7])
	by mail.ispras.ru (Postfix) with ESMTPSA id 4AFEC40737DA;
	Tue, 13 Jun 2023 19:23:09 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 4AFEC40737DA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1686684189;
	bh=hIRs6Uzx3zjkKCTmplY/Pi+dHaV4Bk/epLmdjrJuCpU=;
	h=From:To:Cc:Subject:Date:From;
	b=gk5PMbPcjnyrxDmuuKVB1Jfl6MY4re3uzov615Wm4y+5VHIIZjhshadNqXpi2PaQS
	 qgNE+00grlAlcoepwp3VpOZgku5iOaibXnSIX1FOZ8sAP+BuxoSuvW7PMWHaV2/GRj
	 WtvS7APzt8bZZ8lUjigxkcDuaK9WBi2l9O/mv5AA=
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: "David S. Miller" <davem@davemloft.net>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Raed Salem <raeds@nvidia.com>,
	Lior Nahmanson <liorna@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Hannes Frederic Sowa <hannes@stressinduktion.org>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	lvc-project@linuxtesting.org
Subject: [PATCH] net: macsec: fix double free of percpu stats
Date: Tue, 13 Jun 2023 22:22:20 +0300
Message-Id: <20230613192220.159407-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Inside macsec_add_dev() we free percpu macsec->secy.tx_sc.stats and
macsec->stats on some of the memory allocation failure paths. However, the
net_device is already registered to that moment: in macsec_newlink(), just
before calling macsec_add_dev(). This means that during unregister process
its priv_destructor - macsec_free_netdev() - will be called and will free
the stats again.

Remove freeing percpu stats inside macsec_add_dev() because
macsec_free_netdev() will correctly free the already allocated ones. The
pointers to unallocated stats stay NULL, and free_percpu() treats that
correctly.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 0a28bfd4971f ("net/macsec: Add MACsec skb_metadata_dst Tx Data path support")
Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 drivers/net/macsec.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 3427993f94f7..984dfa5d6c11 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3997,17 +3997,15 @@ static int macsec_add_dev(struct net_device *dev, sci_t sci, u8 icv_len)
 		return -ENOMEM;
 
 	secy->tx_sc.stats = netdev_alloc_pcpu_stats(struct pcpu_tx_sc_stats);
-	if (!secy->tx_sc.stats) {
-		free_percpu(macsec->stats);
+	if (!secy->tx_sc.stats)
 		return -ENOMEM;
-	}
 
 	secy->tx_sc.md_dst = metadata_dst_alloc(0, METADATA_MACSEC, GFP_KERNEL);
-	if (!secy->tx_sc.md_dst) {
-		free_percpu(secy->tx_sc.stats);
-		free_percpu(macsec->stats);
+	if (!secy->tx_sc.md_dst)
+		/* macsec and secy percpu stats will be freed when unregistering
+		 * net_device in macsec_free_netdev()
+		 */
 		return -ENOMEM;
-	}
 
 	if (sci == MACSEC_UNDEF_SCI)
 		sci = dev_to_sci(dev, MACSEC_PORT_ES);
-- 
2.34.1


