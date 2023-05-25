Return-Path: <netdev+bounces-5338-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2645710E21
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:19:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 625261C20ECC
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:19:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF06F11C9D;
	Thu, 25 May 2023 14:19:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70283101E4
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61CAC433EF;
	Thu, 25 May 2023 14:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685024363;
	bh=3jOIJADSMaj767haeBuW7tG2pkAWHCO/ya9AobVrfls=;
	h=From:Date:Subject:To:Cc:From;
	b=U1HbooIqhrEtr/vJLGU7H1tZjRhEQFxQyl3pmfCtX7UyHLFnajaRMF03Y9lovRseI
	 oh3SUhmCqUFuCnZVGNY7Se3Hv9d+4q/9NLBltfEQAh9g4m43l6zoO7ejzqhZO6J18y
	 s/krbfZ2xfDgF053ixAF/Ndw3Qu2vhI74DZlztzFPK6Mj774sHYiXt07d8YLZ5CuIz
	 N3yMJRng7Dyu6aEsYRSFgZceXGUt4RfQr4AhbL8kLhe9V7g7Rd7+tEs7BVTz/2rgwq
	 SMw6z0bSIYuiVGK35CgWcuGyWg9g5kZoT/FeEwxAfBnRUyGA8VGMv4U+/YRzqXjVsv
	 juahWJdo5L9bw==
From: Simon Horman <horms@kernel.org>
Date: Thu, 25 May 2023 16:19:13 +0200
Subject: [PATCH RFC net-next] net: ethernet: mtk_eth_soc: don't convert
 byte order of etype
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230525-mtk_eth_soc-etype-endianness-v1-1-b5da9258ed86@kernel.org>
X-B4-Tracking: v=1; b=H4sIAGBub2QC/x2NwQqDMBAFf0X23AWNKLTXQj+gVymSxNcaalfJp
 sUi/ntDjzOHmY0UMUDpVGwU8QkaZslQHQryo5UHOAyZyZSmLhvT8Cs9e6Sx19kz0ncBQ4ZgRaD
 KdeuOlfdt62AoJ5xVsItW/Jgj8p6mLJeIe1j/z46ul3MhSCxYE932/Qc3tZmzkQAAAA==
To: Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>, 
 Sean Wang <sean.wang@mediatek.com>, Mark Lee <Mark-MC.Lee@mediatek.com>, 
 Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Paolo Abeni <pabeni@redhat.com>, Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org
X-Mailer: b4 0.12.2

*** This will change the value exposed by debugfs. ***
*** I am unsure if that counts as UABI breakage.   ***
*** If so, this patch should be rejected.          ***

The type of the etype field of struct mtk_foe_mac_info is u16.
And it is always used to store values on host byte order.
So there is no need to convert it from network to host byte order
when formatting in a string.

Flagged by sparse:
  .../mtk_ppe_debugfs.c:161:46: warning: cast to restricted __be16

Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c b/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
index 316fe2e70fea..7e4213241cc1 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
@@ -158,9 +158,9 @@ mtk_ppe_debugfs_foe_show(struct seq_file *m, void *private, bool bind)
 		seq_printf(m, " eth=%pM->%pM etype=%04x"
 			      " vlan=%d,%d ib1=%08x ib2=%08x"
 			      " packets=%llu bytes=%llu\n",
-			   h_source, h_dest, ntohs(l2->etype),
-			   l2->vlan1, l2->vlan2, entry->ib1, ib2,
-			   acct ? acct->packets : 0, acct ? acct->bytes : 0);
+			   h_source, h_dest, l2->etype, l2->vlan1, l2->vlan2,
+			   entry->ib1, ib2, acct ? acct->packets : 0,
+			   acct ? acct->bytes : 0);
 	}
 
 	return 0;


