Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 670D43AF4CC
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbhFUSUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbhFUSUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 14:20:24 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 155A0C0617AD
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 11:02:48 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id 69so9020266plc.5
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 11:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x5vL0hXqWZZf60uemI16GeWC+IwzDwNFQEbRqPSDdoU=;
        b=d8vqNzG30OHqklFlW++nSN0qtTT3AdsePBgy9NdSsPaTp+85jc5bwg3gc4YSXKEZld
         p1Kwc9OomNRfYVMgrmZLRopk1qyIdTuTUsLU+ZgMFEi/Fwj3NnyUuofE0l/TgXlGB5F3
         Rr+2fRY8/Zi2wylgmoKsevdYrZvNFbru9Y+fNnvTuitnaGMGZRDvK21NAAtTGVCNYYI5
         1ZtbToukP+SOTK1MR0ys9Lxux3APNGZTM9WoH1CbJyWDQkJfdeiIs12RK9q7Py6fWf9n
         1rLFBWBpYf/D8TmBlSC+sfAc2aEEeUrSSCb41ChjqIWaYK+txABN4MGMvZofT9gO9qtU
         X+SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x5vL0hXqWZZf60uemI16GeWC+IwzDwNFQEbRqPSDdoU=;
        b=D8LuY33ddkefUSbt4+VvnjPdjvwhVIRu3KUYzCVD1ls9NkRrCU6wkj3p2/wla1gUOn
         rs5SpX5RH47Sg6hedDoH40VlRXZaH6KzVTWwyGRbjrxaqDB6AtmSUY94zI6FdC6NeFYF
         JiKhhOOrJiFLmdpa5fMynZOvgXMqDU3znDG9v+S/4ja7FySnCKUCB0H5KLrQUS3B2OFw
         uQCkqnKbbYSDmIhW8/E3S0Xd/1ckLcEfshuMPsMg6VRmj6dj5dya8HftQziprcMLpjRJ
         ahhBkdKcfF5god/eZSHmNeQvFepFw/aE6UrgYp+JJE05aKw7nlwbsMARyTdBF7uU9IlE
         AE3w==
X-Gm-Message-State: AOAM530RTG0HGN+HeDzSig08KyG18fuoIgLo7j3BTeeCjOzhEr5enPT3
        aUsC63ouotr5Dx68L28cvQ0=
X-Google-Smtp-Source: ABdhPJxpmkD+pGV4eGXVxzIpgrITQ71KL4WDboA/ld3jxSgx4CM4ES7AEuV7CxWCOQ1llRhLwQ3mDg==
X-Received: by 2002:a17:90a:4404:: with SMTP id s4mr39953699pjg.218.1624298567661;
        Mon, 21 Jun 2021 11:02:47 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:21de:f864:55d7:2d0])
        by smtp.gmail.com with ESMTPSA id g6sm16566918pfq.110.2021.06.21.11.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 11:02:47 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] ieee802154: hwsim: avoid possible crash in hwsim_del_edge_nl()
Date:   Mon, 21 Jun 2021 11:02:44 -0700
Message-Id: <20210621180244.882076-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Both MAC802154_HWSIM_ATTR_RADIO_ID and MAC802154_HWSIM_ATTR_RADIO_EDGE
must be present to avoid a crash.

Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Alexander Aring <alex.aring@gmail.com>
Cc: Stefan Schmidt <stefan@datenfreihafen.org>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index da9135231c079d4ecc0783aa62f2fec07c3f86e6..d5e8b5a067fc6c044dac5dbe3544f4a768f78a76 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -480,7 +480,7 @@ static int hwsim_del_edge_nl(struct sk_buff *msg, struct genl_info *info)
 	struct hwsim_edge *e;
 	u32 v0, v1;
 
-	if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] &&
+	if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] ||
 	    !info->attrs[MAC802154_HWSIM_ATTR_RADIO_EDGE])
 		return -EINVAL;
 
-- 
2.32.0.288.g62a8d224e6-goog

