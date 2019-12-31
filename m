Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F34D812D778
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 10:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbfLaJcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 04:32:53 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:34318 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725770AbfLaJcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Dec 2019 04:32:53 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1577784772; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=ClcdqW/NIWX8BzrOCLt7qizKBDk6kEpUK40BUI6Fl0M=; b=S50zf1GiU6AGJK/JFr64HelgzM6HhM//OG0gSf1Xh0gQQFsMWu+qkJfH4MtGiAAPsYowGHqh
 tRm3Im+tLCt6eXQMo3+Um6ANB8QfGaKon5HIC5gL2rpZhO69y1eRt0yMbecoUrm0zm7iwn7D
 mi0alH9lKXSOLo2W7c/1mmvQHXc=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e0b15c3.7f32760de618-smtp-out-n03;
 Tue, 31 Dec 2019 09:32:51 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 86616C433CB; Tue, 31 Dec 2019 09:32:50 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from wgong-HP-Z240-SFF-Workstation.qca.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: wgong)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 191A8C43383;
        Tue, 31 Dec 2019 09:32:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 191A8C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=wgong@codeaurora.org
From:   Wen Gong <wgong@codeaurora.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath11k@lists.infradead.org
Subject: [PATCH] net: qrtr: fix len of skb_put_padto in qrtr_node_enqueue
Date:   Tue, 31 Dec 2019 17:32:42 +0800
Message-Id: <20191231093242.6320-1-wgong@codeaurora.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Carl Huang <cjhuang@codeaurora.org>

The len used for skb_put_padto is wrong, it need to add len of hdr.

Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
Signed-off-by: Wen Gong <wgong@codeaurora.org>
---
 net/qrtr/qrtr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 88f98f27ad88..3d24d45be5f4 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -196,7 +196,7 @@ static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 	hdr->size = cpu_to_le32(len);
 	hdr->confirm_rx = 0;
 
-	skb_put_padto(skb, ALIGN(len, 4));
+	skb_put_padto(skb, ALIGN(len, 4) + sizeof(*hdr));
 
 	mutex_lock(&node->ep_lock);
 	if (node->ep)
-- 
2.23.0
