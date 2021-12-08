Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA81046CE47
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 08:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244502AbhLHHYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 02:24:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244506AbhLHHYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 02:24:18 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F49C061574;
        Tue,  7 Dec 2021 23:20:47 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id y13so5037552edd.13;
        Tue, 07 Dec 2021 23:20:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7BIJQrNbvC3Sfrj3cs08TIKsWWE8pnsGwEpOQkIeNTQ=;
        b=iNgLrgO2lyyj6vxqeTpSAwlpYCUYwSlSjSTZS7GHEDo68M2k5PavylSd/HFXX+Z8Wi
         iNKzzTHmYo3QuUR5t1FkZD+SujxkppOIrWYv4L+MdrFekZvh6zMbiDqzmYsBqvV/yMFE
         LUw48epfCfSoRz3wPIs93n9PEigtayN4QoPHu5HBw/vS2hR5p3+DZE45wHhIuyHfK3+2
         wPhQOH3c42Qk+LxRQCfdpA+CW2uhkCll4xNy+2tXRyMdOTlMIdxnEzwyvdCzs9Yequud
         TmH0UcrcaXpPG/Z3vAN+N4DqLEkyPvkJL3NBDjndTnaB1gR9svnomEH9lRfQg8sxQUfc
         RhuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7BIJQrNbvC3Sfrj3cs08TIKsWWE8pnsGwEpOQkIeNTQ=;
        b=F8vbuh3dLJeTfmdaesx4Q8WJRjgLqmsegsBRwzeInQAR6qcLwxzAtlDGnQcx3p/QkD
         FkClLhPggpQ+Z8vfaOQz49hyuz0izRzT47Fh2QSbrqcY5l2Kvh+EKj3UbD6ZvTa/RUpl
         /mWW3gzd1SgJJX7elOH2VBx7qyrwpOO+Fn6mKjsPnwKPWm1Q2jBEIrRTd9niS69uGfkO
         VT2JhKxm4Ovd0QOcJb8Zm2PtmLkrfhZ8yFBiw/poR8j4YaG5FRfICqhIRCxXre6bb62i
         s7vwjsE173BlVe9H9bQ3uXV05dD1bHth5JZWqbo2LV/815Jo28wXMrw75U6rZxEBPDpI
         8yZA==
X-Gm-Message-State: AOAM532h+lXUXPu6yiFuvDMpKbL1Kc+i8IoTHCrUrY69o+TmmtAIVwiU
        exGQrS/LEWEmkbzPBEcIoGxRjdOBfmvJGg==
X-Google-Smtp-Source: ABdhPJxiwIWly/70RIrm2aHCk0z5clhMwpQt58wbrMPOxfwbm/6LcBBbKdD57wNoL0q9qLnPOA0euw==
X-Received: by 2002:a17:907:1b11:: with SMTP id mp17mr5290024ejc.374.1638948045764;
        Tue, 07 Dec 2021 23:20:45 -0800 (PST)
Received: from localhost ([81.17.18.62])
        by smtp.gmail.com with ESMTPSA id e1sm964969ejy.82.2021.12.07.23.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 23:20:45 -0800 (PST)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     ms@dev.tdt.de, davem@davemloft.net, kuba@kernel.org,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next] net: x25: drop harmless check of !more
Date:   Wed,  8 Dec 2021 00:20:25 -0700
Message-Id: <20211208024732.142541-5-sakiwit@gmail.com>
X-Mailer: git-send-email 2.32.0
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

'more' is checked first.  When !more is checked immediately after that,
it is always true.  We should drop this check.

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 net/x25/x25_in.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/x25/x25_in.c b/net/x25/x25_in.c
index e1c4197af468..b981a4828d08 100644
--- a/net/x25/x25_in.c
+++ b/net/x25/x25_in.c
@@ -41,7 +41,7 @@ static int x25_queue_rx_frame(struct sock *sk, struct sk_buff *skb, int more)
 		return 0;
 	}
 
-	if (!more && x25->fraglen > 0) {	/* End of fragment */
+	if (x25->fraglen > 0) {	/* End of fragment */
 		int len = x25->fraglen + skb->len;
 
 		if ((skbn = alloc_skb(len, GFP_ATOMIC)) == NULL){
