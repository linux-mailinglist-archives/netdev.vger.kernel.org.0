Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7C27665E67
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 15:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbjAKOvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 09:51:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234594AbjAKOv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 09:51:27 -0500
Received: from wizmail.org (wizmail.org [85.158.153.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2E1249
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 06:51:26 -0800 (PST)
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
        d=wizmail.org; s=e202001; h=Content-Transfer-Encoding:MIME-Version:References
        :In-Reply-To:Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive:
        Autocrypt; bh=rqf6agDvqwajDbQa2zKXlIfGae4IljppVypyX2Wm74o=; b=xWqJpmgs/n5uVs8
        gG2eTg4VlUlz6jVmaHS4aVsTB63I6JkEimTVaviyVEmgousrW0OYNvLqvpj6gPuKcqF0QDg==;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=wizmail.org
        ; s=r202001; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive:
        Autocrypt; bh=rqf6agDvqwajDbQa2zKXlIfGae4IljppVypyX2Wm74o=; b=adsRGNnyNLbhXZY
        cN8KvBp6mN0AYzmhk9QYNYCoDwP4fxLbYVGhzkRPK+0NwepRaBMLt1xOvmcQKb2qSBimSwtgrn5kr
        jaziC610tt8Q/sEFU/zZ8M4CcMblt/fZLP0pDzXX/LPKCLF12HMlSvxshNmV7wwxgA6F7EmgkWsHq
        kBSBKSEKplZXQrAWtheKxHz6cFGxKErroQv0r5FfzrxHva6asDSir6kZG5hcMANqAsgGTHTXP7Qwp
        9W2TQt3luGPyCNiY/sROZR51EcadmmB9nrsSmM3T/E1ibh+gyX0GlTsFc+mhaqcHdjkvkwnGKLtxM
        YG18+4/HkYisBstUtSg==;
Authentication-Results: wizmail.org;
        local=pass (non-smtp, wizmail.org) u=root
Received: from root
        by [] (Exim 4.96.108)
        with local
        id 1pFcBW-004jFX-28
        (return-path <root@w81.gulag.org.uk>);
        Wed, 11 Jan 2023 14:34:34 +0000
From:   jgh@redhat.com
To:     netdev@vger.kernel.org
Cc:     Jeremy Harris <jgh@redhat.com>
Subject: [RFC PATCH 5/7] drivers: net: bnx2x: NIC driver Rx ring ECN
Date:   Wed, 11 Jan 2023 14:34:25 +0000
Message-Id: <20230111143427.1127174-6-jgh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230111143427.1127174-1-jgh@redhat.com>
References: <20230111143427.1127174-1-jgh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Harris <jgh@redhat.com>

Sample NIC driver support.
This is a less-preferred model, which will throttle based on the NAPI
budget rather than the receive ring fill level.

Signed-off-by: Jeremy Harris <jgh@redhat.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 145e338487b6..62fff8f3499b 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -881,6 +881,7 @@ void bnx2x_csum_validate(struct sk_buff *skb, union eth_rx_cqe *cqe,
 static int bnx2x_rx_int(struct bnx2x_fastpath *fp, int budget)
 {
 	u16 bd_cons, bd_prod, bd_prod_fw, comp_ring_cons;
+	int congestion_level = budget * 7 / 8;
 	struct eth_fast_path_rx_cqe *cqe_fp;
 	u16 sw_comp_cons, sw_comp_prod;
 	struct bnx2x *bp = fp->bp;
@@ -1089,6 +1090,11 @@ static int bnx2x_rx_int(struct bnx2x_fastpath *fp, int budget)
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
 					       le16_to_cpu(cqe_fp->vlan_tag));
 
+		/* We are congested if the napi budget is approached
+		 */
+		if (unlikely(rx_pkt > congestion_level))
+			skb->congestion_experienced = true;
+
 		napi_gro_receive(&fp->napi, skb);
 next_rx:
 		rx_buf->data = NULL;
-- 
2.39.0

