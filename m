Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74D8A5B0900
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiIGPpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiIGPpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:45:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07096C775
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 08:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662565541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sKfvlfICNlAsdN7VZEl9cExBvBRupUtsUYAWmXh19TA=;
        b=RJ5d1bkdh26irUK1Zv6KMlBZ8fF1aotGbde6sCv6FGvJUpH1xvF5dIcFugZfggsweziQMJ
        1qrX2qflxyOwBtlC+Yy+shYD6rq7N5k5JurpNVYYF2viHKzKIHktUvp66I3E4UYsxULZF4
        Kk07GJjKAG9pfaH6hIU5+48mTT/TORs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-isKiwfZUNPKBZ1SYdUw-Gw-1; Wed, 07 Sep 2022 11:45:38 -0400
X-MC-Unique: isKiwfZUNPKBZ1SYdUw-Gw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 664FA3800C2C;
        Wed,  7 Sep 2022 15:45:37 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0693740149B6;
        Wed,  7 Sep 2022 15:45:37 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 0E08030721A6C;
        Wed,  7 Sep 2022 17:45:36 +0200 (CEST)
Subject: [PATCH RFCv2 bpf-next 07/18] i40e: Refactor i40e_ptp_rx_hwtstamp
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
Date:   Wed, 07 Sep 2022 17:45:36 +0200
Message-ID: <166256553602.1434226.14564390707008322763.stgit@firesoul>
In-Reply-To: <166256538687.1434226.15760041133601409770.stgit@firesoul>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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

Introduce i40e_ptp_rx_hwtstamp_raw() that doesn't depend on skb pointer
as input. Keep i40e_ptp_rx_hwtstamp with same semantics as before.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h     |    1 +
 drivers/net/ethernet/intel/i40e/i40e_ptp.c |   36 +++++++++++++++++++++-------
 2 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index d86b6d349ea9..859e11f4e884 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -1262,6 +1262,7 @@ void i40e_ptp_rx_hang(struct i40e_pf *pf);
 void i40e_ptp_tx_hang(struct i40e_pf *pf);
 void i40e_ptp_tx_hwtstamp(struct i40e_pf *pf);
 void i40e_ptp_rx_hwtstamp(struct i40e_pf *pf, struct sk_buff *skb, u8 index);
+u64  i40e_ptp_rx_hwtstamp_raw(struct i40e_pf *pf, u8 index);
 void i40e_ptp_set_increment(struct i40e_pf *pf);
 int i40e_ptp_set_ts_config(struct i40e_pf *pf, struct ifreq *ifr);
 int i40e_ptp_get_ts_config(struct i40e_pf *pf, struct ifreq *ifr);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ptp.c b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
index 2d3533f38d7b..ec33d783f6ee 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ptp.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
@@ -808,18 +808,16 @@ void i40e_ptp_tx_hwtstamp(struct i40e_pf *pf)
 }
 
 /**
- * i40e_ptp_rx_hwtstamp - Utility function which checks for an Rx timestamp
+ * i40e_ptp_rx_hwtstamp_raw - Utility function which checks for an Rx timestamp
  * @pf: Board private structure
- * @skb: Particular skb to send timestamp with
  * @index: Index into the receive timestamp registers for the timestamp
  *
  * The XL710 receives a notification in the receive descriptor with an offset
- * into the set of RXTIME registers where the timestamp is for that skb. This
+ * into the set of RXTIME registers where the timestamp is for that pkt. This
  * function goes and fetches the receive timestamp from that offset, if a valid
- * one exists. The RXTIME registers are in ns, so we must convert the result
- * first.
+ * one exists, else zero is returned.
  **/
-void i40e_ptp_rx_hwtstamp(struct i40e_pf *pf, struct sk_buff *skb, u8 index)
+u64 i40e_ptp_rx_hwtstamp_raw(struct i40e_pf *pf, u8 index)
 {
 	u32 prttsyn_stat, hi, lo;
 	struct i40e_hw *hw;
@@ -829,7 +827,7 @@ void i40e_ptp_rx_hwtstamp(struct i40e_pf *pf, struct sk_buff *skb, u8 index)
 	 * doing Tx timestamping, check if Rx timestamping is configured.
 	 */
 	if (!(pf->flags & I40E_FLAG_PTP) || !pf->ptp_rx)
-		return;
+		return 0;
 
 	hw = &pf->hw;
 
@@ -841,7 +839,7 @@ void i40e_ptp_rx_hwtstamp(struct i40e_pf *pf, struct sk_buff *skb, u8 index)
 	/* TODO: Should we warn about missing Rx timestamp event? */
 	if (!(prttsyn_stat & BIT(index))) {
 		spin_unlock_bh(&pf->ptp_rx_lock);
-		return;
+		return 0;
 	}
 
 	/* Clear the latched event since we're about to read its register */
@@ -854,7 +852,27 @@ void i40e_ptp_rx_hwtstamp(struct i40e_pf *pf, struct sk_buff *skb, u8 index)
 
 	ns = (((u64)hi) << 32) | lo;
 
-	i40e_ptp_convert_to_hwtstamp(skb_hwtstamps(skb), ns);
+	return ns;
+}
+
+/**
+ * i40e_ptp_rx_hwtstamp - Utility function which checks for an Rx timestamp
+ * @pf: Board private structure
+ * @skb: Particular skb to send timestamp with
+ * @index: Index into the receive timestamp registers for the timestamp
+ *
+ * The XL710 receives a notification in the receive descriptor with an offset
+ * into the set of RXTIME registers where the timestamp is for that skb. This
+ * function goes and fetches the receive timestamp from that offset, if a valid
+ * one exists. The RXTIME registers are in ns, so we must convert the result
+ * first.
+ **/
+void i40e_ptp_rx_hwtstamp(struct i40e_pf *pf, struct sk_buff *skb, u8 index)
+{
+	u64 ns = i40e_ptp_rx_hwtstamp_raw(pf, index);
+
+	if (ns)
+		i40e_ptp_convert_to_hwtstamp(skb_hwtstamps(skb), ns);
 }
 
 /**


