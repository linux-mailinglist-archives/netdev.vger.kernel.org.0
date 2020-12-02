Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442772CBD10
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 13:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgLBMed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 07:34:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbgLBMec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 07:34:32 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E72C0617A6
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 04:33:51 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id y7so3449129lji.8
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 04:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SVmt+GWAAS453za5ilhaeU0BZnA9BWz5PpoRw2DQf2Y=;
        b=Bgnn4URqfgQy/94ScHtMyRvU2rIAsuUSZqIDXFx88FqFFqB6fTFjyDJWiLF6jOfmU+
         J8I845lpnN9Q9NbbCA0eP7s7tMyZjcNxlW53FOAdCMNscD3yXlJOZNj532hFjYQ/8rQM
         cGCgneJHsrwtanNY/gUROC8CnL6P1FQeHHp2GeSeqWqIBNOnvDScWJrKTP3wZCh5mgsU
         qYPYoPwK0xPlseEuqqX1s3Y5n22oBdE407b/5vL0J7oixM8/gE7mxYzccf99Og8zA+FE
         61EUvffRxboYXIXtQC1nlhNVM7f/oR507POvL8OuAEw36yq5DYsC8PmuBL5ZWYUSncnM
         Ivqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SVmt+GWAAS453za5ilhaeU0BZnA9BWz5PpoRw2DQf2Y=;
        b=EK/fJbEpAs2XhpEW82VmFF4V4KcHUdp9NHOb/kFY7Ucg6VhwS/PSnA7rmP3CJaeJzB
         1myjHtZw1s9Mw3liIxY5/OznG1cvG4j1kGyfc+V9GnyIyfMZ5HEFuCwTYQdCjGEJSwf8
         0e/Z4JrK3jz6McU4aMtEqZJ3Gthg46bChgbIx2LS+SuFkg5LamTEQ2995LJBSsn1vSXn
         Lx5ZlGyXtXwfyjokGzmA6Tgg17M8xVMLuvWGSCn81KVAYM9Mg3q944DM8rTLh/n8Pccf
         MtDtNe3DqBU4aM7CXZ4xwiSrGtEFqCry6Jf16klxyY4Bmnudmo4AHgZ4Y4C1d6F1rD9/
         7SaA==
X-Gm-Message-State: AOAM5329m8C7zePtyJqjhrsInCBDK/8tkXpEO3o+YOOpLu/tYWFKq+oo
        8nYzWwb0K7RaBByZ39Q/KvRcABRyLa7V+A==
X-Google-Smtp-Source: ABdhPJy8Lo8G4zb9qAziKdmKUVejyu5SF6n5pwYC3JUd41dLIOCnAQd34JzDpM8mlF3qgocZ1oTm9w==
X-Received: by 2002:a2e:b0c8:: with SMTP id g8mr1093904ljl.331.1606912430296;
        Wed, 02 Dec 2020 04:33:50 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id m7sm439230ljb.8.2020.12.02.04.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 04:33:49 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     netdev@vger.kernel.org, pablo@netfilter.org
Cc:     laforge@gnumonks.org, Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH 3/5] gtp: really check namespaces before xmit
Date:   Wed,  2 Dec 2020 13:33:43 +0100
Message-Id: <20201202123345.565657-3-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201202123345.565657-1-jonas@norrbonn.se>
References: <20201202123345.565657-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Blindly assuming that packet transmission crosses namespaces results in
skb marks being lost in the single namespace case.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---
 drivers/net/gtp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 096aaf1c867e..e053f86f43f3 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -592,7 +592,9 @@ static netdev_tx_t gtp_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 				    ip4_dst_hoplimit(&pktinfo.rt->dst),
 				    0,
 				    pktinfo.gtph_port, pktinfo.gtph_port,
-				    true, false);
+				    !net_eq(sock_net(pktinfo.pctx->sk),
+					    dev_net(dev)),
+				    false);
 		break;
 	}
 
-- 
2.27.0

