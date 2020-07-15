Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE1E22116A
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 17:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgGOPnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 11:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbgGOPnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 11:43:11 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA0CC08C5DB;
        Wed, 15 Jul 2020 08:43:11 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id y18so1302807lfh.11;
        Wed, 15 Jul 2020 08:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tEdKCVDLZGVZ3tN0zkYKOC8QapxBfjEj8eJsemdKTfg=;
        b=DgQlUqkljUuMfbPQAmuG3IecWH11NjaKMWqu08MskNX2cT8b+TB7ie4HcPaRE0USo/
         IIZJhzJfL/a491GQkRAjdUlmNKq5qxHKY53lUkV1fmILnAOvFc6/2H15zrRACD6VXnYW
         VxGa7EJIrPJMQ49C4jLCj5SX38tl/hGsuGtmhy1csZr9+vFfZhUR7PujGXBhAtSUHvYC
         jb4itMb6Bkcqjw/OFJjs8h2EwEP/CE8XjyFGWX6q9wLH0HNlO64zUOof6EBvlbw7YVTO
         df3aiU7AL208w+nnr1JBZ47Qf7u5iJsl9NQjR2i1bNOKCbcBE6t1+OEz/jTrbRpIQW+4
         Vggw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tEdKCVDLZGVZ3tN0zkYKOC8QapxBfjEj8eJsemdKTfg=;
        b=pWhYBSjaU5cWrj/ZX/JsDZihvnh+VUPMs+G6bE758Xm9sxY8oxAjvb+rkGR6wz26g5
         qX4hoxDQg9PNrJs6mBzyNxK461thlvCLdpHEnIPiYbJhhgNQoC7UgLZEz+BrAZKSjcHg
         2gEFkEOwDkkXIOr4oCEIEtSyRjjZ4IKr0zTqC+6IHRPltIuu/YYnZY8CbBLY4GVKSubl
         KtXvFAKSQZrd0TzW2UucaemMyWohBkTL9cBlfQuDJp9fqPZZaybbdcEa4BZHviecRaqA
         XgIWioXq1WYPBRvZSAoy2x9oAhgYplKcrRRCm/BKT5e738ELtr34mDL2mWGnDIhZnH0/
         8WMg==
X-Gm-Message-State: AOAM533S3UDPOkLqi8p6cjNembDJZmTydvXt9ck/jS9ILY0PmF+tmUSP
        ToysDVyQnDa4HBMU5Lrvzz58MU+E
X-Google-Smtp-Source: ABdhPJxq6AXbsDOZg5EvR7C0cm2ePDQrho3VnBJFzK+arlpMFNitMlsICk/7WoMlwkkpdDJ9a7yTaw==
X-Received: by 2002:a19:e93:: with SMTP id 141mr5099508lfo.107.1594827789804;
        Wed, 15 Jul 2020 08:43:09 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id c6sm563955lff.77.2020.07.15.08.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 08:43:09 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sergey Organov <sorganov@gmail.com>
Subject: [PATCH net-next v2 3/4] net: fec: get rid of redundant code in fec_ptp_set()
Date:   Wed, 15 Jul 2020 18:42:59 +0300
Message-Id: <20200715154300.13933-4-sorganov@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200715154300.13933-1-sorganov@gmail.com>
References: <20200706142616.25192-1-sorganov@gmail.com>
 <20200715154300.13933-1-sorganov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Code of the form "if(x) x = 0" replaced with "x = 0".

Code of the form "if(x == a) x = a" removed.

Acked-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Sergey Organov <sorganov@gmail.com>
---
 drivers/net/ethernet/freescale/fec_ptp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 4bec7e66a39b..0c8c56bdd7ac 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -473,9 +473,7 @@ int fec_ptp_set(struct net_device *ndev, struct ifreq *ifr)
 
 	switch (config.rx_filter) {
 	case HWTSTAMP_FILTER_NONE:
-		if (fep->hwts_rx_en)
-			fep->hwts_rx_en = 0;
-		config.rx_filter = HWTSTAMP_FILTER_NONE;
+		fep->hwts_rx_en = 0;
 		break;
 
 	default:
-- 
2.10.0.1.g57b01a3

