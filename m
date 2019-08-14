Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E93058CA92
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 07:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbfHNFO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 01:14:56 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:37629 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726888AbfHNFO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 01:14:56 -0400
Received: by mail-yb1-f194.google.com with SMTP id t5so7330080ybt.4;
        Tue, 13 Aug 2019 22:14:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lD7K7srnZm3/fJdQ4MMUb4Yt0W08MUzcITPyxwLfAmA=;
        b=F/2y41XZ9wTXeFlGtw9NZKW9mcDwUSKNEY4So/EHnzZXTmpvq5UBcLxYXEooiufna+
         VUUKZaqnbwCQ4HUsw+0ssTAAwiqVDL3XOizKNuW8RuqV95IrEqmLnyND1ClfhBP5ECC6
         hqBMkW8ys7zXKeTCVXO/Zbt8FBgBa0mHztSQbEUz7q84EDUgvaH99ysA0fBgo1FLq4QU
         U3C93pogha4C78ySDpd7e4qOQeo+ATb/IM4jxdR6paFAkn2Y6Y+AyWTIdwSZbBa24lay
         LrnAFTTxMFTDcQzQ56myfZVsSXiev9FySbHDVytXzqJHREHP1zxW6dTdJ/q/7u7SrTxG
         dnIA==
X-Gm-Message-State: APjAAAXcGCp9yUCtJcfU1cTcDYweyVO9BP7XHV1FhH1ygAt/BlemwPl+
        uVHTdvqLRkBRtPvI4I6+MMB6eyZuKij8Tg==
X-Google-Smtp-Source: APXvYqzT8hE17MvfcP5XewY94v3FyRcPTNoIlWorGPihtOeX+s/REcCAdX4DnuyIGSuxwUxOY6zUkQ==
X-Received: by 2002:a25:9345:: with SMTP id g5mr1981247ybo.394.1565759695426;
        Tue, 13 Aug 2019 22:14:55 -0700 (PDT)
Received: from localhost.localdomain (24-158-240-219.dhcp.smyr.ga.charter.com. [24.158.240.219])
        by smtp.gmail.com with ESMTPSA id z6sm25581704ywg.40.2019.08.13.22.14.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 13 Aug 2019 22:14:54 -0700 (PDT)
From:   Wenwen Wang <wenwen@cs.uga.edu>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org (open list:CAVIUM LIQUIDIO NETWORK DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] liquidio: add cleanup in octeon_setup_iq()
Date:   Wed, 14 Aug 2019 00:14:49 -0500
Message-Id: <1565759689-5941-1-git-send-email-wenwen@cs.uga.edu>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If oct->fn_list.enable_io_queues() fails, no cleanup is executed, leading
to memory/resource leaks. To fix this issue, invoke
octeon_delete_instr_queue() before returning from the function.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
---
 drivers/net/ethernet/cavium/liquidio/request_manager.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/request_manager.c b/drivers/net/ethernet/cavium/liquidio/request_manager.c
index 0322241..6dd65f9 100644
--- a/drivers/net/ethernet/cavium/liquidio/request_manager.c
+++ b/drivers/net/ethernet/cavium/liquidio/request_manager.c
@@ -237,8 +237,10 @@ int octeon_setup_iq(struct octeon_device *oct,
 	}
 
 	oct->num_iqs++;
-	if (oct->fn_list.enable_io_queues(oct))
+	if (oct->fn_list.enable_io_queues(oct)) {
+		octeon_delete_instr_queue(oct, iq_no);
 		return 1;
+	}
 
 	return 0;
 }
-- 
2.7.4

