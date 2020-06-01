Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D746A1EA887
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 19:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgFARn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 13:43:29 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:10494 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgFARn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 13:43:29 -0400
Received: from chumthang.blr.asicdesigners.com (chumthang.blr.asicdesigners.com [10.193.186.96])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 051HhBcC032125;
        Mon, 1 Jun 2020 10:43:23 -0700
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        manojmalviya@chelsio.com
Cc:     netdev@vger.kernel.org, Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH net-next V2 1/2] Crypto/chcr: Fixes compilations warnings
Date:   Mon,  1 Jun 2020 23:11:58 +0530
Message-Id: <20200601174159.9900-2-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.26.0.rc1.11.g30e9940
In-Reply-To: <20200601174159.9900-1-ayush.sawal@chelsio.com>
References: <20200601174159.9900-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the compilation warnings displayed by sparse tool for
chcr driver.

V1->V2

Avoid type casting by using get_unaligned_be32() and
put_unaligned_be16/32() functions.

The key which comes from stack is an u8 byte stream so we store it in
an unsigned char array(ablkctx->key). The function get_aes_decrypt_key()
is a used to calculate  the reverse round key for decryption, for this
operation the key has to be divided into 4 bytes, so to extract 4 bytes
from an u8 byte stream and store it in an u32 variable, get_aligned_be32()
is used. Similarly for copying back the key from u32 variable to the
original u8 key stream, put_aligned_be32() is used.

Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c  | 10 ++++------
 drivers/crypto/chelsio/chcr_ipsec.c |  2 +-
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index b8c1c4dd3ef0..94cf04e5aacf 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -256,7 +256,7 @@ static void get_aes_decrypt_key(unsigned char *dec_key,
 		return;
 	}
 	for (i = 0; i < nk; i++)
-		w_ring[i] = be32_to_cpu(*(u32 *)&key[4 * i]);
+		w_ring[i] = get_unaligned_be32(&key[i * 4]);
 
 	i = 0;
 	temp = w_ring[nk - 1];
@@ -275,7 +275,7 @@ static void get_aes_decrypt_key(unsigned char *dec_key,
 	}
 	i--;
 	for (k = 0, j = i % nk; k < nk; k++) {
-		*((u32 *)dec_key + k) = htonl(w_ring[j]);
+		put_unaligned_be32(w_ring[j], &dec_key[k * 4]);
 		j--;
 		if (j < 0)
 			j += nk;
@@ -2926,8 +2926,7 @@ static int ccm_format_packet(struct aead_request *req,
 		memcpy(ivptr, req->iv, 16);
 	}
 	if (assoclen)
-		*((unsigned short *)(reqctx->scratch_pad + 16)) =
-				htons(assoclen);
+		put_unaligned_be16(assoclen, &reqctx->scratch_pad[16]);
 
 	rc = generate_b0(req, ivptr, op_type);
 	/* zero the ctr value */
@@ -3201,8 +3200,7 @@ static struct sk_buff *create_gcm_wr(struct aead_request *req,
 	} else {
 		memcpy(ivptr, req->iv, GCM_AES_IV_SIZE);
 	}
-	*((unsigned int *)(ivptr + 12)) = htonl(0x01);
-
+	put_unaligned_be32(0x01, &ivptr[12]);
 	ulptx = (struct ulptx_sgl *)(ivptr + 16);
 
 	chcr_add_aead_dst_ent(req, phys_cpl, qid);
diff --git a/drivers/crypto/chelsio/chcr_ipsec.c b/drivers/crypto/chelsio/chcr_ipsec.c
index d25689837b26..3a10f51ad6fd 100644
--- a/drivers/crypto/chelsio/chcr_ipsec.c
+++ b/drivers/crypto/chelsio/chcr_ipsec.c
@@ -403,7 +403,7 @@ inline void *copy_esn_pktxt(struct sk_buff *skb,
 	xo = xfrm_offload(skb);
 
 	aadiv->spi = (esphdr->spi);
-	seqlo = htonl(esphdr->seq_no);
+	seqlo = ntohl(esphdr->seq_no);
 	seqno = cpu_to_be64(seqlo + ((u64)xo->seq.hi << 32));
 	memcpy(aadiv->seq_no, &seqno, 8);
 	iv = skb_transport_header(skb) + sizeof(struct ip_esp_hdr);
-- 
2.26.0.rc1.11.g30e9940

