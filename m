Return-Path: <netdev+bounces-11354-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6432732B77
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 11:26:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB6321C20F89
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 09:26:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83B0115487;
	Fri, 16 Jun 2023 09:26:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C018F57;
	Fri, 16 Jun 2023 09:26:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05596C433C0;
	Fri, 16 Jun 2023 09:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686907611;
	bh=tARQMYG/aYeqmMUAJH7cbPA26P2Il2Rzs/1oa9c9qgk=;
	h=From:To:Cc:Subject:Date:From;
	b=CCgVGKytISv+fj1viUpOXb/VC4Og1rkCvfO1nGrZGtrr1hcPuZ0OGg72pWvzllRMt
	 B2i720ZfbsqDU3GVRmN6t7ig12mjc3aT0Fo+p3oR10Nv3yAlD4LtPlTSLUYfYeeg3B
	 bGj3FAUqVSldEwRGDSkJ7bujvfySd2/5hftnxzPLC8DhikYfFUna16dmx7UZzUNM4/
	 4pn4P/OsmywmiZ6cw+2KCP0P1V1hlCn42pdDJ//LUDJiUgy0ZD3nx8MtrDgqG2SO48
	 fmE0/zJZ8CLWyI8+9UTPddpKhqr8Ht40TYTI9yS8Kv/T85fISnMtqW5qcGxic477Hd
	 hB3qSJirhs9bQ==
From: Arnd Bergmann <arnd@kernel.org>
To: Igor Russkikh <irusskikh@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH] net: atlantic: fix ring buffer alignment
Date: Fri, 16 Jun 2023 11:26:32 +0200
Message-Id: <20230616092645.3384103-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

clang warns about conflicting packing annotations:

drivers/net/ethernet/aquantia/atlantic/aq_ring.h:72:2: error: field  within 'struct aq_ring_buff_s' is less aligned than 'union aq_ring_buff_s::(anonymous at drivers/net/ethernet/aquantia/atlantic/aq_ring.h:72:2)' and is usually due to 'struct aq_ring_buff_s' being packed, which can lead to unaligned accesses [-Werror,-Wunaligned-access]

This was originally intended to ensure the structure fits exactly into
32 bytes on 64-bit architectures, but apparently never did, and instead
just produced misaligned pointers as well as forcing byte-wise access
on hardware without unaligned load/store instructions.

Update the comment to more closely reflect the layout and remove the
broken __packed annotation.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 .../net/ethernet/aquantia/atlantic/aq_ring.h  | 26 +++++++++++--------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
index 0a6c34438c1d0..a9cc5a1c4c479 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
@@ -26,19 +26,23 @@ struct aq_rxpage {
 	unsigned int pg_off;
 };
 
-/*           TxC       SOP        DX         EOP
- *         +----------+----------+----------+-----------
- *   8bytes|len l3,l4 | pa       | pa       | pa
- *         +----------+----------+----------+-----------
- * 4/8bytes|len pkt   |len pkt   |          | skb
- *         +----------+----------+----------+-----------
- * 4/8bytes|is_gso    |len,flags |len       |len,is_eop
- *         +----------+----------+----------+-----------
+/*           TxC       SOP        DX         EOP	RX
+ *         +----------+----------+----------+----------+-------
+ *   8bytes|len l3,l4 | pa       | pa       | pa       | hash
+ *         +----------+----------+----------+----------+-------
+ * 4/8bytes|len pkt   |len pkt   |          | skb      | page
+ *         +----------+----------+----------+----------+-------
+ * 4/8bytes|is_gso    |len,flags |len       |len,is_eop| daddr
+ *         +----------+----------+----------+----------+-------
+ * 4/8bytes|          |          |          |          | order,pgoff
+ *         +----------+----------+----------+----------+-------
+ * 2bytes  |          |          |          |          | vlan_rx_tag
+ *         +----------+----------+----------+----------+-------
+ * 8bytes  +                   flags
+ *         +----------+----------+----------+----------+-------
  *
- *  This aq_ring_buff_s doesn't have endianness dependency.
- *  It is __packed for cache line optimizations.
  */
-struct __packed aq_ring_buff_s {
+struct aq_ring_buff_s {
 	union {
 		/* RX/TX */
 		dma_addr_t pa;
-- 
2.39.2


