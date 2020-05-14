Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D1D1D3B52
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729435AbgENTBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:01:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729403AbgENSze (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 14:55:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20F2F206DC;
        Thu, 14 May 2020 18:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482533;
        bh=sKKycsNvZwdMi/ig82103IsNNPEMODqd4qw0y2HS1+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s9GcdBnYSNzElu/7Zdyf9AT7Shu4U6Cio8+64k7ZF/OUHgkd96zQhLO3mZfv6Y11G
         xZF+kzx2/3AS9NC76QFr84rqZ9CZ4JsYj90tHLJ6Ya1PKwbCkn7vgB9oC7HxBM34O1
         t3HuZ2jItExr6j2T/jA+Pxq0ttxv4HNH5katmetM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Scott Dial <scott@scottdial.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 27/39] net: macsec: preserve ingress frame ordering
Date:   Thu, 14 May 2020 14:54:44 -0400
Message-Id: <20200514185456.21060-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185456.21060-1-sashal@kernel.org>
References: <20200514185456.21060-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Scott Dial <scott@scottdial.com>

[ Upstream commit ab046a5d4be4c90a3952a0eae75617b49c0cb01b ]

MACsec decryption always occurs in a softirq context. Since
the FPU may not be usable in the softirq context, the call to
decrypt may be scheduled on the cryptd work queue. The cryptd
work queue does not provide ordering guarantees. Therefore,
preserving order requires masking out ASYNC implementations
of gcm(aes).

For instance, an Intel CPU with AES-NI makes available the
generic-gcm-aesni driver from the aesni_intel module to
implement gcm(aes). However, this implementation requires
the FPU, so it is not always available to use from a softirq
context, and will fallback to the cryptd work queue, which
does not preserve frame ordering. With this change, such a
system would select gcm_base(ctr(aes-aesni),ghash-generic).
While the aes-aesni implementation prefers to use the FPU, it
will fallback to the aes-asm implementation if unavailable.

By using a synchronous version of gcm(aes), the decryption
will complete before returning from crypto_aead_decrypt().
Therefore, the macsec_decrypt_done() callback will be called
before returning from macsec_decrypt(). Thus, the order of
calls to macsec_post_decrypt() for the frames is preserved.

While it's presumable that the pure AES-NI version of gcm(aes)
is more performant, the hybrid solution is capable of gigabit
speeds on modest hardware. Regardless, preserving the order
of frames is paramount for many network protocols (e.g.,
triggering TCP retries). Within the MACsec driver itself, the
replay protection is tripped by the out-of-order frames, and
can cause frames to be dropped.

This bug has been present in this code since it was added in
v4.6, however it may not have been noticed since not all CPUs
have FPU offload available. Additionally, the bug manifests
as occasional out-of-order packets that are easily
misattributed to other network phenomena.

When this code was added in v4.6, the crypto/gcm.c code did
not restrict selection of the ghash function based on the
ASYNC flag. For instance, x86 CPUs with PCLMULQDQ would
select the ghash-clmulni driver instead of ghash-generic,
which submits to the cryptd work queue if the FPU is busy.
However, this bug was was corrected in v4.8 by commit
b30bdfa86431afbafe15284a3ad5ac19b49b88e3, and was backported
all the way back to the v3.14 stable branch, so this patch
should be applicable back to the v4.6 stable branch.

Signed-off-by: Scott Dial <scott@scottdial.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 926e2eb528fd4..4a92160394c07 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1309,7 +1309,8 @@ static struct crypto_aead *macsec_alloc_tfm(char *key, int key_len, int icv_len)
 	struct crypto_aead *tfm;
 	int ret;
 
-	tfm = crypto_alloc_aead("gcm(aes)", 0, 0);
+	/* Pick a sync gcm(aes) cipher to ensure order is preserved. */
+	tfm = crypto_alloc_aead("gcm(aes)", 0, CRYPTO_ALG_ASYNC);
 
 	if (IS_ERR(tfm))
 		return tfm;
-- 
2.20.1

