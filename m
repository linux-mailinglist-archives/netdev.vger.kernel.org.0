Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2BA2A9ABF
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 18:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbgKFR1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 12:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgKFR1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 12:27:14 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6C7C0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Nov 2020 09:27:11 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id p22so2203878wmg.3
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 09:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BgPP+PukmIJeeeHpQyjf3pHwgKSum317O3/VfpxC1MA=;
        b=PCxq6VGtA8PPqFwrkym2E0+cW+qNLImrumBJDfB7bkthicxGoX3WEvi238fnON0555
         iiHq8KqTIZVackziDqMJwYEa/bEmKC1JvZ9Zgr7LdjRLUu48ug8D0o2ceuK8/kZExZWb
         Dm+viBidjQZDtGG7e/IlpXbQQ9j+Yr3mtao/gh7ufA8MCE4R8L52befy8HWayFoXkEzX
         636uu0CzaneWbeMYu8T8Ljt2HuurBPRYpoW96Wac7oY8JS0yTRZJgapVHRI/X9ppq9jz
         dqJFyHqzHL+DpuhdVujc0Jcrp26AwfLSqxaji/qI1tRXnsRIYeMyBllH3vlvDGXolCPA
         k42w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BgPP+PukmIJeeeHpQyjf3pHwgKSum317O3/VfpxC1MA=;
        b=Fo/ixeyr7yD3Lotc2is7lXNr30F9YQvUrkwBOEOPJwE0/0I9CpUNCxBi64V3UX72ji
         kZB0j31fxkD8jF8mWr7fZCzPclMlX1iSVH2ag4F+WPVn2aKUVNOdRtBlzA0zt0XMny+l
         sTK3OHNQCehmL0To2F/HGvf985N7000TJfZuuYL/Gj5JKJSLIGygZZXpNLDBa5PpgsiQ
         z4CZyRixy6NeRoo5XiudXMvNruUwv3A1l7VMJBEibozaBsB617sMBvQWtItB2pZ+yKUF
         UD0Q22d8KURCLDiVgsdwiy1d+s+Vdt0L15hMj/JI3z7bV22eIiBBd0sDiCGqmo9fAvfu
         159w==
X-Gm-Message-State: AOAM531Pyz5vEjY7O/1gvA+Q+7vzcjnqfisaCPGSjh3rRPuFaOn2gr6B
        Cob1JRSIwFwsxS2tzdnk0Li4kA==
X-Google-Smtp-Source: ABdhPJx41FdGIOJgR944UCLGCJWWX6zG8g1E/l7kbLfrTtwLnQqy36dA8KOcG0NPx0hwrSGx5/nuHw==
X-Received: by 2002:a1c:1c1:: with SMTP id 184mr735400wmb.16.1604683630682;
        Fri, 06 Nov 2020 09:27:10 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id z191sm3183266wme.30.2020.11.06.09.27.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Nov 2020 09:27:10 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, manivannan.sadhasivam@linaro.org,
        cjhuang@codeaurora.org, netdev@vger.kernel.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH v2 4/5] net: qrtr: Add GFP flags parameter to qrtr_alloc_ctrl_packet
Date:   Fri,  6 Nov 2020 18:33:29 +0100
Message-Id: <1604684010-24090-5-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604684010-24090-1-git-send-email-loic.poulain@linaro.org>
References: <1604684010-24090-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will be requested for allocating control packet in atomic context.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 net/qrtr/qrtr.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 1d12408..a05d01e 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -526,18 +526,20 @@ EXPORT_SYMBOL_GPL(qrtr_endpoint_post);
 /**
  * qrtr_alloc_ctrl_packet() - allocate control packet skb
  * @pkt: reference to qrtr_ctrl_pkt pointer
+ * @flags: the type of memory to allocate
  *
  * Returns newly allocated sk_buff, or NULL on failure
  *
  * This function allocates a sk_buff large enough to carry a qrtr_ctrl_pkt and
  * on success returns a reference to the control packet in @pkt.
  */
-static struct sk_buff *qrtr_alloc_ctrl_packet(struct qrtr_ctrl_pkt **pkt)
+static struct sk_buff *qrtr_alloc_ctrl_packet(struct qrtr_ctrl_pkt **pkt,
+					      gfp_t flags)
 {
 	const int pkt_len = sizeof(struct qrtr_ctrl_pkt);
 	struct sk_buff *skb;
 
-	skb = alloc_skb(QRTR_HDR_MAX_SIZE + pkt_len, GFP_KERNEL);
+	skb = alloc_skb(QRTR_HDR_MAX_SIZE + pkt_len, flags);
 	if (!skb)
 		return NULL;
 
@@ -606,7 +608,7 @@ void qrtr_endpoint_unregister(struct qrtr_endpoint *ep)
 	mutex_unlock(&node->ep_lock);
 
 	/* Notify the local controller about the event */
-	skb = qrtr_alloc_ctrl_packet(&pkt);
+	skb = qrtr_alloc_ctrl_packet(&pkt, GFP_KERNEL);
 	if (skb) {
 		pkt->cmd = cpu_to_le32(QRTR_TYPE_BYE);
 		qrtr_local_enqueue(NULL, skb, QRTR_TYPE_BYE, &src, &dst);
@@ -663,7 +665,7 @@ static void qrtr_port_remove(struct qrtr_sock *ipc)
 	to.sq_node = QRTR_NODE_BCAST;
 	to.sq_port = QRTR_PORT_CTRL;
 
-	skb = qrtr_alloc_ctrl_packet(&pkt);
+	skb = qrtr_alloc_ctrl_packet(&pkt, GFP_KERNEL);
 	if (skb) {
 		pkt->cmd = cpu_to_le32(QRTR_TYPE_DEL_CLIENT);
 		pkt->client.node = cpu_to_le32(ipc->us.sq_node);
@@ -987,7 +989,7 @@ static int qrtr_send_resume_tx(struct qrtr_cb *cb)
 	if (!node)
 		return -EINVAL;
 
-	skb = qrtr_alloc_ctrl_packet(&pkt);
+	skb = qrtr_alloc_ctrl_packet(&pkt, GFP_KERNEL);
 	if (!skb)
 		return -ENOMEM;
 
-- 
2.7.4

