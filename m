Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5715B0902
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiIGPqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbiIGPpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:45:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0307B6AA0F
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 08:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662565547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q/RYCLcFxWXVg4sepSF6T1VgsBBx9ixyS2xZVokLGcw=;
        b=Z+NyGw3CaZzzBnCi3a1SlposuQ7934n+o8WgEuEWeiqK5+rlHgHfgQWlrkdRJ9rY0j+oeb
        1ijNECQJu5Zv3KOpPCVMa8gamBV+Fg0FYrLP4KlXCKlwyNDwRBsHxLqPKCLlJSEyVY2mNZ
        zLLRzLtRR9ldjFHRlyyWMzpGUjFgNxM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-375-DEwJ5IVyMXKGQHQ4fK2TUA-1; Wed, 07 Sep 2022 11:45:44 -0400
X-MC-Unique: DEwJ5IVyMXKGQHQ4fK2TUA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 46F98101A58E;
        Wed,  7 Sep 2022 15:45:43 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DBCC6403167;
        Wed,  7 Sep 2022 15:45:42 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 199C530721A6C;
        Wed,  7 Sep 2022 17:45:41 +0200 (CEST)
Subject: [PATCH RFCv2 bpf-next 08/18] i40e: refactor i40e_rx_checksum with
 helper
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Date:   Wed, 07 Sep 2022 17:45:41 +0200
Message-ID: <166256554106.1434226.11099369196515014657.stgit@firesoul>
In-Reply-To: <166256538687.1434226.15760041133601409770.stgit@firesoul>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No functional change, this is in preparation for later patches.

The helper function does not depend on skb, which will be used in later
patches.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c |   66 ++++++++++++++++-----------
 1 file changed, 40 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index f6ba97a0166e..a7a896321880 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1751,45 +1751,38 @@ bool i40e_alloc_rx_buffers(struct i40e_ring *rx_ring, u16 cleaned_count)
 	return true;
 }
 
-/**
- * i40e_rx_checksum - Indicate in skb if hw indicated a good cksum
- * @vsi: the VSI we care about
- * @skb: skb currently being received and modified
- * @rx_desc: the receive descriptor
- **/
-static inline void i40e_rx_checksum(struct i40e_vsi *vsi,
-				    struct sk_buff *skb,
-				    union i40e_rx_desc *rx_desc)
+struct i40e_rx_checksum_ret {
+	u16 ip_summed;
+	u16 csum_level;
+};
+
+static inline struct i40e_rx_checksum_ret
+_i40e_rx_checksum(struct i40e_vsi *vsi,
+		  u64 qword,
+		  struct i40e_rx_ptype_decoded decoded)
 {
-	struct i40e_rx_ptype_decoded decoded;
+	struct i40e_rx_checksum_ret ret = {};
 	u32 rx_error, rx_status;
 	bool ipv4, ipv6;
-	u8 ptype;
-	u64 qword;
 
-	qword = le64_to_cpu(rx_desc->wb.qword1.status_error_len);
-	ptype = (qword & I40E_RXD_QW1_PTYPE_MASK) >> I40E_RXD_QW1_PTYPE_SHIFT;
 	rx_error = (qword & I40E_RXD_QW1_ERROR_MASK) >>
 		   I40E_RXD_QW1_ERROR_SHIFT;
 	rx_status = (qword & I40E_RXD_QW1_STATUS_MASK) >>
 		    I40E_RXD_QW1_STATUS_SHIFT;
-	decoded = decode_rx_desc_ptype(ptype);
 
-	skb->ip_summed = CHECKSUM_NONE;
-
-	skb_checksum_none_assert(skb);
+	ret.ip_summed = CHECKSUM_NONE;
 
 	/* Rx csum enabled and ip headers found? */
 	if (!(vsi->netdev->features & NETIF_F_RXCSUM))
-		return;
+		return ret;
 
 	/* did the hardware decode the packet and checksum? */
 	if (!(rx_status & BIT(I40E_RX_DESC_STATUS_L3L4P_SHIFT)))
-		return;
+		return ret;
 
 	/* both known and outer_ip must be set for the below code to work */
 	if (!(decoded.known && decoded.outer_ip))
-		return;
+		return ret;
 
 	ipv4 = (decoded.outer_ip == I40E_RX_PTYPE_OUTER_IP) &&
 	       (decoded.outer_ip_ver == I40E_RX_PTYPE_OUTER_IPV4);
@@ -1805,7 +1798,7 @@ static inline void i40e_rx_checksum(struct i40e_vsi *vsi,
 	if (ipv6 &&
 	    rx_status & BIT(I40E_RX_DESC_STATUS_IPV6EXADD_SHIFT))
 		/* don't increment checksum err here, non-fatal err */
-		return;
+		return ret;
 
 	/* there was some L4 error, count error and punt packet to the stack */
 	if (rx_error & BIT(I40E_RX_DESC_ERROR_L4E_SHIFT))
@@ -1816,30 +1809,51 @@ static inline void i40e_rx_checksum(struct i40e_vsi *vsi,
 	 * the csum.
 	 */
 	if (rx_error & BIT(I40E_RX_DESC_ERROR_PPRS_SHIFT))
-		return;
+		return ret;
 
 	/* If there is an outer header present that might contain a checksum
 	 * we need to bump the checksum level by 1 to reflect the fact that
 	 * we are indicating we validated the inner checksum.
 	 */
 	if (decoded.tunnel_type >= I40E_RX_PTYPE_TUNNEL_IP_GRENAT)
-		skb->csum_level = 1;
+		ret.csum_level = 1;
 
 	/* Only report checksum unnecessary for TCP, UDP, or SCTP */
 	switch (decoded.inner_prot) {
 	case I40E_RX_PTYPE_INNER_PROT_TCP:
 	case I40E_RX_PTYPE_INNER_PROT_UDP:
 	case I40E_RX_PTYPE_INNER_PROT_SCTP:
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
+		ret.ip_summed = CHECKSUM_UNNECESSARY;
 		fallthrough;
 	default:
 		break;
 	}
 
-	return;
+	return ret;
 
 checksum_fail:
 	vsi->back->hw_csum_rx_error++;
+	return ret;
+}
+
+/**
+ * i40e_rx_checksum - Indicate in skb if hw indicated a good cksum
+ * @vsi: the VSI we care about
+ * @skb: skb currently being received and modified
+ * @rx_desc: the receive descriptor
+ **/
+static inline void i40e_rx_checksum(struct i40e_vsi *vsi,
+				    struct sk_buff *skb,
+				    union i40e_rx_desc *rx_desc)
+{
+	struct i40e_rx_checksum_ret ret;
+	u64 qword = le64_to_cpu(rx_desc->wb.qword1.status_error_len);
+	u8 ptype = (qword & I40E_RXD_QW1_PTYPE_MASK) >> I40E_RXD_QW1_PTYPE_SHIFT;
+	struct i40e_rx_ptype_decoded decoded = decode_rx_desc_ptype(ptype);
+
+	ret = _i40e_rx_checksum(vsi, qword, decoded);
+	skb->ip_summed  = ret.ip_summed;
+	skb->csum_level = ret.csum_level;
 }
 
 /**


