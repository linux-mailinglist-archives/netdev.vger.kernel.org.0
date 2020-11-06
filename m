Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAAF2A9ABC
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 18:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbgKFR1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 12:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgKFR1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 12:27:09 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824CCC0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Nov 2020 09:27:08 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id c9so2203594wml.5
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 09:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qiZHU813rW8xg+F+YCWBIt/KpRIOcYYppQ2O/7ZYftw=;
        b=LIykX/LIcE/R0Q2p18YaAa2MWfP8VB0B7wUc7nG9ObZD+I+bnpnIKQE4r88G8WMa+A
         230e5yuBbqoj+o1yabVzpqfd/2L6Rdtue1peWWXAztY5CwlESD3HczBoEzvp+3SeOk7w
         tHEyT6bskbOMWSWizsxS8rnaJ+R+q1RDw6/ImL+6xUQ42mNbEXHMmGMm3/CzARCssW/f
         UlssTIssggeU2k3sHf1j/aqMgkadPA2awkvghqa0JtaO+Wa9HRqZEvDcCHH3glkM1a5f
         WpZRVCCQlyhEZ8Fw6YtX4qZKuByfDCQtXn6xG7e76/bdxZnzp6qt0BbpPnV/RJMa8QqC
         a+kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qiZHU813rW8xg+F+YCWBIt/KpRIOcYYppQ2O/7ZYftw=;
        b=duaetrH1nsz+OeMw0kxQcsABixh9fV0+ubonb3w2irmV8UHedGOpi902Ngnfo2ueYC
         L73UX7A4+Y5/lfKTAvUTnL6S8kKJ71oZ6rlHGGs9SVUHCCJC1xIcemdJHlogN6SCEiw3
         HnxT/nVP1Phi1fb7vJwYkZzhCFOgAFPhIGQO0tSJr0sdGFTDv8j3+lyw/8nOR2ctj/Ad
         AlkWS7cbUbaA/JTY+NT/PeNcy/DvU15ODHtS9YvgSfvpa6VHuK/0S3QYzj2TFhkXxVz3
         xi3pvuowaOh9T1k21WyAozMjkWLALUQzDtZeAhj6mUB+3O6amdEsLMgcPAqLVdFjsU9M
         N4FA==
X-Gm-Message-State: AOAM531TyXVJmlpWmX2n/x8yVKo4mVe8M9I4j6gQRXK8PSicbo2LgkD9
        nlX9r6fCjmcyImLY1MFfJyxshg==
X-Google-Smtp-Source: ABdhPJwuHV3mU/iAvV546pj2wtoFGCwdqdw/0u7tM/Q3SkZ4tuASc7hA7SvRy65G/qjLVh+FVO6/AQ==
X-Received: by 2002:a05:600c:22d3:: with SMTP id 19mr666424wmg.161.1604683627213;
        Fri, 06 Nov 2020 09:27:07 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id z191sm3183266wme.30.2020.11.06.09.27.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Nov 2020 09:27:06 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, manivannan.sadhasivam@linaro.org,
        cjhuang@codeaurora.org, netdev@vger.kernel.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH v2 1/5] net: qrtr: Fix port ID for control messages
Date:   Fri,  6 Nov 2020 18:33:26 +0100
Message-Id: <1604684010-24090-2-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604684010-24090-1-git-send-email-loic.poulain@linaro.org>
References: <1604684010-24090-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The port ID for control messages was uncorrectly set with broadcast
node ID value, causing message to be dropped on remote side since
not passing packet filtering (cb->dst_port != QRTR_PORT_CTRL).

Fixes: d27e77a3de28 ("net: qrtr: Reset the node and port ID of broadcast messages")
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 net/qrtr/qrtr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index b4c0db0..e09154b 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -348,7 +348,7 @@ static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 	hdr->src_port_id = cpu_to_le32(from->sq_port);
 	if (to->sq_port == QRTR_PORT_CTRL) {
 		hdr->dst_node_id = cpu_to_le32(node->nid);
-		hdr->dst_port_id = cpu_to_le32(QRTR_NODE_BCAST);
+		hdr->dst_port_id = cpu_to_le32(QRTR_PORT_CTRL);
 	} else {
 		hdr->dst_node_id = cpu_to_le32(to->sq_node);
 		hdr->dst_port_id = cpu_to_le32(to->sq_port);
-- 
2.7.4

