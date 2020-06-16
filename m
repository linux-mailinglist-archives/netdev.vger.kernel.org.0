Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4631FA579
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 03:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgFPBPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 21:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgFPBPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 21:15:41 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1DCC061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 18:15:39 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id g12so7621510pll.10
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 18:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=HqJBbPbWWSx9P4wmOssng/k8oo4LDSf9SOjeX9SpCrI=;
        b=ddODq+xdQCng+JDzRiTmCAay6ZM/H8e9Me8tGmJhHfh9k1wgW+K5jVwVffuySAIrQI
         zc22mnZThvzk1vW/ciVXI6IF5SENyaZ8UOj7+oTp9fNrDhwbvYG36hbCiu7sL+9JYlxy
         uWhhiczVdDx0AM3QYpAUxFwWrt1kv/208/V1BM2fZzYTL9/wraIn2mOYmCSgPZMtHy/N
         KhwKXsq3sJ/N5avamh/TQnj18fPmoDu0/mHjblVSv0EYLJjMelKLpObzAN0LSEqC8Euc
         t+HF9SLeON9sn2cmJ9YzWQiCk3Mb54XKUKpqS+luO58+D7Pal7l+fHszni9IPw6U/oiL
         mz0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HqJBbPbWWSx9P4wmOssng/k8oo4LDSf9SOjeX9SpCrI=;
        b=tR7svHmvG+kGW+CHUIu72yD4vvlR3lwE9Wc97aIW20aH9odj545nFyk/m/L04h/UW0
         nAoFefe+wPMQ6oGpPIeRS6dZCq8MpELi14j2KhIUCdNBrLwSZnTtroiy9BiuHM7UL20Y
         7AW50g3bSn7oFwRxpaTu97jnpZuPYE1wWfGhgQxeuCjPHhP8I3cl73VqDFyR4cYyCYhD
         CS2fVHuD/wlYNaw23WJCBEsZGVkWEZKPBbc8fh8HM80cJuO0R1oPeNN+e8eDE55v2Ct/
         Lxrl4ZUfL+UObVNGoHSUrOEGnytz4p4YuHNKPsK4b4UB1hpO3tfngujTonmSCQrl+A3G
         cUxQ==
X-Gm-Message-State: AOAM533nLYM1Dfmd6CENKZvK/mir+zxUNOPw9MXcdsuxpoBxi9g/X6P+
        8bMFKe34DlufT4IXpq+JPbwpCbirtYM=
X-Google-Smtp-Source: ABdhPJyiKuPXYNI+nfBhAqOy9+eAqwCuCZzrb+WmQSUQZv6a4mFxssFYO5cFsCwWVHLrsv5z+T+gnA==
X-Received: by 2002:a17:902:507:: with SMTP id 7mr524958plf.115.1592270138927;
        Mon, 15 Jun 2020 18:15:38 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id x4sm14876646pfx.87.2020.06.15.18.15.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jun 2020 18:15:38 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net] ionic: no link check while resetting queues
Date:   Mon, 15 Jun 2020 18:14:59 -0700
Message-Id: <20200616011459.30966-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the driver is busy resetting queues after a change in
MTU or queue parameters, don't bother checking the link,
wait until the next watchdog cycle.

Fixes: 987c0871e8ae ("ionic: check for linkup in watchdog")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 9d8c969f21cb..bfadc4934702 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -96,7 +96,8 @@ static void ionic_link_status_check(struct ionic_lif *lif)
 	u16 link_status;
 	bool link_up;
 
-	if (!test_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state))
+	if (!test_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state) ||
+	    test_bit(IONIC_LIF_F_QUEUE_RESET, lif->state))
 		return;
 
 	link_status = le16_to_cpu(lif->info->status.link_status);
-- 
2.17.1

