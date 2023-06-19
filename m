Return-Path: <netdev+bounces-11866-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 31B26734F50
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:13:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 560951C2095A
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:13:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB33BBE6C;
	Mon, 19 Jun 2023 09:12:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4045250
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9ABC433C0;
	Mon, 19 Jun 2023 09:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687165963;
	bh=qxfUKz7rm5GuWEeyfp0weQ2JFwovXXhOCgww3LgVweQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VRznDpGmTl7br3LipdSczF4mjvDiVoU4H2w2jIJzeS2NRj6AyAwmHlptSVRvcDNws
	 MS/kogBoz3+GM69Yg/gzsaYVzgbvU3wj1NkYzX41lODZQyu4F9SGzuB+Al1FodFnMU
	 /BMOQGUCPcpsjORuvNY6D3TpKkbsaBCWzNHN790KzY37Z4+qrDwsS4ixfn1G74C2qq
	 uYVDCLqZQwTRZ2fWWOlQmZ3gf6rzj/tycq0H34Qom908ygXhnbKf/gePAR+LKkVD7p
	 vSrcHmoTHx21hnmhZS81Ee1PBuGjDLa1bx/rJkkpJxsV8nIYTUmPxy7d+23reaTtUu
	 S5g7ojolXdVnw==
From: Arnd Bergmann <arnd@kernel.org>
To: Edward Cree <ecree.xilinx@gmail.com>,
	Martin Habets <habetsm.xilinx@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	netdev@vger.kernel.org,
	linux-net-drivers@amd.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] sfc: selftest: fix struct packing
Date: Mon, 19 Jun 2023 11:12:11 +0200
Message-Id: <20230619091215.2731541-3-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230619091215.2731541-1-arnd@kernel.org>
References: <20230619091215.2731541-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

Three of the sfc drivers define a packed loopback_payload structure with an
ethernet header followed by an IP header. However, the kernel definition
of iphdr specifies that this is 4-byte aligned, causing a W=1 warning:

net/ethernet/sfc/siena/selftest.c:46:15: error: field ip within 'struct efx_loopback_payload' is less aligned than 'struct iphdr' and is usually due to 'struct efx_loopback_payload' being packed, which can lead to unaligned accesses [-Werror,-Wunaligned-access]
        struct iphdr ip;

As the iphdr packing is not easily changed without breaking other code,
change the three structures to use a local definition instead.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/sfc/falcon/selftest.c | 21 ++++++++++++++++++++-
 drivers/net/ethernet/sfc/selftest.c        | 21 ++++++++++++++++++++-
 drivers/net/ethernet/sfc/siena/selftest.c  | 21 ++++++++++++++++++++-
 3 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/falcon/selftest.c b/drivers/net/ethernet/sfc/falcon/selftest.c
index 6a454ac6f8763..fb7fcd27a33a5 100644
--- a/drivers/net/ethernet/sfc/falcon/selftest.c
+++ b/drivers/net/ethernet/sfc/falcon/selftest.c
@@ -40,7 +40,26 @@
  */
 struct ef4_loopback_payload {
 	struct ethhdr header;
-	struct iphdr ip;
+	struct {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+		__u8	ihl:4,
+			version:4;
+#elif defined (__BIG_ENDIAN_BITFIELD)
+		__u8	version:4,
+			ihl:4;
+#else
+#error	"Please fix <asm/byteorder.h>"
+#endif
+		__u8	tos;
+		__be16	tot_len;
+		__be16	id;
+		__be16	frag_off;
+		__u8	ttl;
+		__u8	protocol;
+		__sum16	check;
+		__be32	saddr;
+		__be32	daddr;
+	} __packed ip; /* unaligned struct iphdr */
 	struct udphdr udp;
 	__be16 iteration;
 	char msg[64];
diff --git a/drivers/net/ethernet/sfc/selftest.c b/drivers/net/ethernet/sfc/selftest.c
index 3c5227afd4977..440a57953779c 100644
--- a/drivers/net/ethernet/sfc/selftest.c
+++ b/drivers/net/ethernet/sfc/selftest.c
@@ -43,7 +43,26 @@
  */
 struct efx_loopback_payload {
 	struct ethhdr header;
-	struct iphdr ip;
+	struct {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+		__u8	ihl:4,
+			version:4;
+#elif defined (__BIG_ENDIAN_BITFIELD)
+		__u8	version:4,
+			ihl:4;
+#else
+#error	"Please fix <asm/byteorder.h>"
+#endif
+		__u8	tos;
+		__be16	tot_len;
+		__be16	id;
+		__be16	frag_off;
+		__u8	ttl;
+		__u8	protocol;
+		__sum16	check;
+		__be32	saddr;
+		__be32	daddr;
+	} __packed ip; /* unaligned struct iphdr */
 	struct udphdr udp;
 	__be16 iteration;
 	char msg[64];
diff --git a/drivers/net/ethernet/sfc/siena/selftest.c b/drivers/net/ethernet/sfc/siena/selftest.c
index 07715a3d6beab..b8a8b0495f661 100644
--- a/drivers/net/ethernet/sfc/siena/selftest.c
+++ b/drivers/net/ethernet/sfc/siena/selftest.c
@@ -43,7 +43,26 @@
  */
 struct efx_loopback_payload {
 	struct ethhdr header;
-	struct iphdr ip;
+	struct {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+		__u8	ihl:4,
+			version:4;
+#elif defined (__BIG_ENDIAN_BITFIELD)
+		__u8	version:4,
+			ihl:4;
+#else
+#error	"Please fix <asm/byteorder.h>"
+#endif
+		__u8	tos;
+		__be16	tot_len;
+		__be16	id;
+		__be16	frag_off;
+		__u8	ttl;
+		__u8	protocol;
+		__sum16	check;
+		__be32	saddr;
+		__be32	daddr;
+	} __packed ip; /* unaligned struct iphdr */
 	struct udphdr udp;
 	__be16 iteration;
 	char msg[64];
-- 
2.39.2


