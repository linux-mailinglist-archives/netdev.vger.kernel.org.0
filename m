Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF46B276DC9
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 11:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbgIXJsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 05:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727314AbgIXJsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 05:48:14 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46FCFC0613CE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 02:48:14 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id k18so2884605wmj.5
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 02:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=qiZHU813rW8xg+F+YCWBIt/KpRIOcYYppQ2O/7ZYftw=;
        b=OQ290OLyt539y9R1cpo2NlkpP1DwrY8lN/v3xhoy8ROoHGd25EckJx8GEvnBoIEQ2y
         uLX8ELe/Um1GMTUBq4s+/hAr460I/ch0hK56TweI49yydg9nJWP3yHBtZWBZvgA906lb
         AdPi8Kp8muZOMmdqC4GY72+tyB7jVDMTf2tPXJakVu+2f28Gi0GFvDt8tlckVMoat87O
         p196TuEYtLrDh5Jo1CrNj4T9pvIJPe0dn+6fASYW4mBTClR3B3hyN1LyBgHBcbg9jbrc
         oNtJcmp2ftQcG4G45A1UYiq/fbsCUO/3tYnHrh1K4jAkoiD/IjcdMyk8AmengbRsjeuh
         05dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qiZHU813rW8xg+F+YCWBIt/KpRIOcYYppQ2O/7ZYftw=;
        b=bBlh/GOQh5v0ja67hBdYV8mDavSad11MiNxwKYeNCAFJlNe5NUaud/kkfGdzJoCDS4
         2jGSBIDBT1v/Iw/E+RokdW6imCgHwVL7NXRNMRTe2v/e535YiWCPZ1lWO2TsAkcXjJV0
         P7xQ18XcO07C0rBGQ+bBxDc7cBSGREnO33FEJq7lCaLE3HTAlnTjFHRKFWGaYYmuY8br
         4vuNeFwYOpSWD9E9h0vH4cpdnqn0lDj8DtOnpceObfGKxfH4cxI5MUgFAtNVDHl4ABWl
         JRQ+vGolPcAdaopcW8GmfVU1WJCEK6D3SUq1DSkSwII2U9q4UUFQiDIan1ZSfSlpTdp9
         5yMQ==
X-Gm-Message-State: AOAM5311vA37IQ4OSH6OGFO8SChtkdlWpOBwmVDzmHt9kpmkLeKbk+lm
        SnX2SRvd5t8OkBxyeEIZ8LH7mw==
X-Google-Smtp-Source: ABdhPJzKFGbjfvw2rjA/4/do+owLiLDXBFpo9OCustuBGjkOoAf82koymELZrAeZJtcv1jdzih3XPw==
X-Received: by 2002:a7b:ca42:: with SMTP id m2mr3938931wml.145.1600940892915;
        Thu, 24 Sep 2020 02:48:12 -0700 (PDT)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id c4sm3039859wrp.85.2020.09.24.02.48.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Sep 2020 02:48:12 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     bjorn.andersson@linaro.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH] net: qrtr: Fix port ID for control messages
Date:   Thu, 24 Sep 2020 11:53:59 +0200
Message-Id: <1600941239-19435-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
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

