Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4B2716C1F3
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 14:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730389AbgBYNSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 08:18:04 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:32854 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729386AbgBYNSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 08:18:04 -0500
Received: by mail-pg1-f196.google.com with SMTP id 6so6897398pgk.0;
        Tue, 25 Feb 2020 05:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=djeXvgDX1dzPvkbFDL9oeL1hgiy4iMfslVEDwCPbhX8=;
        b=H2XBe6KHWh6J9Xj1yhLiU4JxY/ymRM7WHmVlQPgaKXfZTq+w9vv6WUKrnPWVWQ2iku
         EOHTt8zH2Q3iFRKI2oGz5xYqJQNLd8xpcTVZprVIddn0/NfOro7dhvRsFjrAeqkfh3Bm
         rtXTWdajE2f8cshEC/JB+YusWRnlD4sQpELYNAX8ziXxMm+zr1TuRJhtktdRuAlqJTf1
         WWPpqGq9vDjDezjJS+KXJzmlZmYTIsdWKOvQpqaN9QcXJ0ggI6oDuTr6pd7TaWOqGITd
         rugHlTWFQ1FFXqSmemh1mlAP0Uwo6HP7V/GdIZVPIF8cX0mQEwnr/5XqwVAb109Ev5u3
         4xOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=djeXvgDX1dzPvkbFDL9oeL1hgiy4iMfslVEDwCPbhX8=;
        b=WYm2R5OMVhyjQjX0BZTAS9xSptJ76Bnc5LXvdGsKjwujKrovt75pmhXgO4INUj/P9/
         6nEljEX/kDfvIEWMzZ5Nvwa+DSlO44n/SBuCFU+2ChNljIgK8205aXQpvkoiet0TuZy3
         27CBc0nrIVJe3NDEIG03M9r0LmuaWWGR/CdFFPBYHbWsrpCTIH4haGMivaguoBXYXmwT
         VdOliYK/g/E7CL+TokrLw4DHnVbEXWH6WalEvG/ierln2G2KzyOIxa2+uV7UhPElYGdI
         Ql2CJ9Rix6wdLxl+46LSab+qX1W4n0Dckz6HZIUy3m9UB4+BhRidoHTkW2WNvi6kUQ/c
         sxvQ==
X-Gm-Message-State: APjAAAXRZSpNsEI5juZpwQB26cVVRI7m01ulz3yzCzB4z3TOZ2fOyBq+
        P03GitmlFO/H+QZk8ZIYLw==
X-Google-Smtp-Source: APXvYqyZWQbaPcpdmLzEFwfknc0aITQXNKV0KYUx6HCyo9h2Nn+noGbHX128va9+iOz5v+N0ts+zSw==
X-Received: by 2002:aa7:8717:: with SMTP id b23mr57736952pfo.53.1582636683296;
        Tue, 25 Feb 2020 05:18:03 -0800 (PST)
Received: from madhuparna-HP-Notebook.nitk.ac.in ([2402:3a80:1ee1:f355:dcbb:6353:6580:5d41])
        by smtp.gmail.com with ESMTPSA id m12sm17057416pfh.37.2020.02.25.05.17.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 05:18:02 -0800 (PST)
From:   madhuparnabhowmik10@gmail.com
To:     marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        frextrite@gmail.com, paulmck@kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH] net: bluetooth: hci_core: Use list_for_each_entry_rcu() to traverse RCU list in RCU read-side CS
Date:   Tue, 25 Feb 2020 18:47:53 +0530
Message-Id: <20200225131753.690-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

In function hci_is_blocked_key() RCU list is traversed with
list_for_each_entry() in RCU read-side CS.
Use list_for_each_entry_rcu() instead.

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 net/bluetooth/hci_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 8ddd1bea02be..4e6d61a95b20 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2327,7 +2327,7 @@ bool hci_is_blocked_key(struct hci_dev *hdev, u8 type, u8 val[16])
 	struct blocked_key *b;
 
 	rcu_read_lock();
-	list_for_each_entry(b, &hdev->blocked_keys, list) {
+	list_for_each_entry_rcu(b, &hdev->blocked_keys, list) {
 		if (b->type == type && !memcmp(b->val, val, sizeof(b->val))) {
 			blocked = true;
 			break;
-- 
2.17.1

