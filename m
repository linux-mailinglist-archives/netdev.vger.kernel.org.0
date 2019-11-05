Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87ACFF08B2
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 22:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730043AbfKEVu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 16:50:26 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36381 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbfKEVuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 16:50:24 -0500
Received: by mail-wr1-f65.google.com with SMTP id w18so23303874wrt.3
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 13:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Kj6tObPlANZy3AIT+3KSFHW/LsU1ghNrAcg+aySdJ5U=;
        b=Z3qVc47cis60U2V8oYOc9dhHrgtCGqyp4ACES1XWTEZcXRzB6gAkQpiUxJfBe4npQM
         KGdTZBg3ykzDgTooacAhXnBP0P0CKdpOCrGfIKjmScyCsqESSrTyuk/gsRULQfbXJAYi
         Yn8k9ZMT1IbfgKz76jmvuBxnCPEqHF0VpFcBaVxWNykjcFjJ0bEaIGCOvOgL/Vye+DEj
         t+VYG8omsV267aNYI3zy4tq3j/8MgEgKhx6PXAmIQVw1i0Cgw76B/YQBPUdg6eMHp4Sr
         LDO3Cmj8nR5s/neRa/erF06HXedtkmzQuvwVOwJcc1LhIx2K/USWunePyyRt1TseAHc0
         xk6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Kj6tObPlANZy3AIT+3KSFHW/LsU1ghNrAcg+aySdJ5U=;
        b=Yn028HZiXqoBFn/wyITPkrxg54yRblSLzK/OrByyfYb/IgfnvtmI3tzm25SqiK2W2q
         9TerSxL5Y+uoPp3J8qVa4MOLSxCUbGTiarC3EOPt59HK78rOlza1wejmi0e8OSWntcKh
         vL5Yl0UW8ukLQTLSLlc7V2dzRwWFza5buZfAkOF7oJtAe5JCJR861pjMhgKPjXXRvIsB
         odzFU+oXX4+CClwxxcPTmbBOvodfvFEgDU/9lolZ16udLm6u/UoKFOnjaWixaW0TJEgs
         3u3SAwp62LMjZY3P1b/4vlJ7YClokjDUATHPAHvIuNMKNs3V6VlyvtiZRY3E7uu/++Ya
         u4AQ==
X-Gm-Message-State: APjAAAVl2uXB2Kmda9mkgjdq+/urVQddd/8Q/Oqq/dKOy24NlkclIa/m
        Jkeh9o2IZ8rkqLDRQYNeKKQ=
X-Google-Smtp-Source: APXvYqwQW+E59dn9HzhaeyEei0DBYLF3roDiwy5/BMJySs97ZV3oO9WN+1qYl5gCMpmZimZbfk3lPw==
X-Received: by 2002:adf:ebd2:: with SMTP id v18mr9499352wrn.71.1572990622525;
        Tue, 05 Nov 2019 13:50:22 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id r19sm25389732wrr.47.2019.11.05.13.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 13:50:22 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com,
        alexandre.belloni@bootlin.com, netdev@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 2/2] net: mscc: ocelot: fix NULL pointer on LAG slave removal
Date:   Tue,  5 Nov 2019 23:50:14 +0200
Message-Id: <20191105215014.12492-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191105215014.12492-1-olteanv@gmail.com>
References: <20191105215014.12492-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>

lag_upper_info may be NULL on slave removal.

Fixes: dc96ee3730fc ("net: mscc: ocelot: add bonding support")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index dbf09fcf61f1..672ea1342add 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1724,7 +1724,8 @@ static int ocelot_netdevice_event(struct notifier_block *unused,
 		struct netdev_lag_upper_info *lag_upper_info = info->upper_info;
 		struct netlink_ext_ack *extack;
 
-		if (lag_upper_info->tx_type != NETDEV_LAG_TX_TYPE_HASH) {
+		if (lag_upper_info &&
+		    lag_upper_info->tx_type != NETDEV_LAG_TX_TYPE_HASH) {
 			extack = netdev_notifier_info_to_extack(&info->info);
 			NL_SET_ERR_MSG_MOD(extack, "LAG device using unsupported Tx type");
 
-- 
2.17.1

