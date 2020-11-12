Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0681E2B03A2
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbgKLLPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgKLLO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 06:14:59 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FA9C0613D1;
        Thu, 12 Nov 2020 03:14:59 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id o15so5574391wru.6;
        Thu, 12 Nov 2020 03:14:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BdT6UiNPeuKqH8weoNwVCRBG/yR7CRLpN9ozhwUo2p4=;
        b=CWvGy/v/GU7OHushkVvX56H3IaS6FKG8pyx/X+YqcOp9oaaezrCjjLasjjH1D35+9m
         MilQAHvGkyk8HKcOaqWHs3wpfXrSWwyIu/jGGx4wTfYBYMuyII5yyjZpljpe/ro2xM/u
         W/2M5nxFK/XE38eaU4xPIbHM6IKHJomulVEG94/yKSozBrTUzA1ehI3hrQ3KFs2nnMfk
         NOcqeqDlX5t41Q9Pso0a+oVTv8b9yrG3SgW7w3XPkI7cy/wD8eGFRhuZKTuGjkbfR37b
         hhO8WM5LBXDvYV8D0w6hDfxndE9/B+Ct70PGgciubZmT/vi4lSEP+uMIgYj3CZk7tVTG
         Yt3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BdT6UiNPeuKqH8weoNwVCRBG/yR7CRLpN9ozhwUo2p4=;
        b=sfD5rtBCY597MEO5PgJKwZU/sSe3Yjpj0xePrYhD6N/gd1f4HLSEm5p1ySS1N3UCyz
         AuJnbxmS/FLTVCp9CCq41Fx2Et5+oNtidTgPxEsaN3SapryrD1nUKp88ubd3ia4ahi0q
         sLdIQHJJZVZhN346qxxYM1CHvKHb3X8Yr4AxbWM3gGXsWfe/eBu7Ip76Uxlw9rzOjBNR
         F/Arc+XzLf7NglDxKiWDGwvkxV3KT66H8pdRM8A1cKhuLa0uS19zaB5ewFYhQKUkUpcA
         i3ZBB7DlTKjHNqd7yAAqJyOTX55GX6jI6CTTuSEqaiT5pR779/TRIoGaRbny5AZjgG52
         mnzw==
X-Gm-Message-State: AOAM5309A0CaelQF8ESQU81HIV/9ktXlAFZHTyrNHVv5YFwlqqgipo0J
        N02HR6dHYPyDjwuEU7gz3iU=
X-Google-Smtp-Source: ABdhPJz9bzrYPVImLOUskADu1QXasfhmiyDcSxG6xGnDivt9jOIZvucLKrnJuRp6aVBlonjaCnUzKg==
X-Received: by 2002:adf:fec5:: with SMTP id q5mr22107443wrs.245.1605179698195;
        Thu, 12 Nov 2020 03:14:58 -0800 (PST)
Received: from ubux1.panoulu.local ([2a00:1d50:3:0:1cd1:d2e:7b13:dc30])
        by smtp.gmail.com with ESMTPSA id t13sm6563447wru.67.2020.11.12.03.14.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 03:14:57 -0800 (PST)
From:   Lev Stipakov <lstipakov@gmail.com>
X-Google-Original-From: Lev Stipakov <lev@openvpn.net>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Lev Stipakov <lev@openvpn.net>
Subject: [PATCH 3/3] net: xfrm: use core API for updating TX stats
Date:   Thu, 12 Nov 2020 13:13:45 +0200
Message-Id: <20201112111345.34625-1-lev@openvpn.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit d3fd65484c781 ("net: core: add dev_sw_netstats_tx_add") has added
function "dev_sw_netstats_tx_add()" to update net device per-cpu TX
stats.

Use this function instead of own code.

Signed-off-by: Lev Stipakov <lev@openvpn.net>
---
 net/xfrm/xfrm_interface.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 9b8e292a7c6a..43ee4c5a6fa9 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -319,12 +319,7 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 
 	err = dst_output(xi->net, skb->sk, skb);
 	if (net_xmit_eval(err) == 0) {
-		struct pcpu_sw_netstats *tstats = this_cpu_ptr(dev->tstats);
-
-		u64_stats_update_begin(&tstats->syncp);
-		tstats->tx_bytes += length;
-		tstats->tx_packets++;
-		u64_stats_update_end(&tstats->syncp);
+		dev_sw_netstats_tx_add(dev, 1, length);
 	} else {
 		stats->tx_errors++;
 		stats->tx_aborted_errors++;
-- 
2.25.1

