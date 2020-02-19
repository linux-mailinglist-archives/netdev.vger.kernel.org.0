Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA9B164006
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 10:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgBSJMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 04:12:33 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33578 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgBSJMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 04:12:33 -0500
Received: by mail-pg1-f195.google.com with SMTP id 6so12419478pgk.0;
        Wed, 19 Feb 2020 01:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mn4zsjlzynntfOs5YFb07oY3dWpb5D0zaBJYwASVQWY=;
        b=G6gHGceS0yAmiHRQ/TMZbsluyMQ1XzeYXax7LBY7adHSvicxi2bo/GVfPp7ucUV/TS
         LyMb5uocPPTHdhXzuKMCff0rZI8EupnzAxxLE8h/rrp/k7yaj6Wl0WOA9pnVuBuW6vp4
         aNJ/sEFRM5pTwAlDWEcwnD8935Eupw7rX2OXFD1XOaZQsxliVpzCfUzSgZGrghz9uYOb
         +Gqgkll4YMjV9s8GQQAtbnxLrj2kaRdYec4FTp8H4hN49EYjKtjIneSIxvCqAzEyVWQV
         VU5TxIj93vH1Q4l5DWndMunaR1aWkNIBzz0sCRk9B+n4AozUTdy72qyCXUpXaWODLbcS
         ZPTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mn4zsjlzynntfOs5YFb07oY3dWpb5D0zaBJYwASVQWY=;
        b=aCyrPmvHV9hcN56TYWKqdBIhaHxT52+50eoju82wfGHvYAsFeKbr9E+okEpOktng1U
         t9g3Qy1A67N9gzwLBDytPh9qnHBix7HxYFMAo5Hgl1JpbswPDaafhKU7b3C7vfqznQnj
         SdfIrN24u3J760///MLtofXu0uVQAQTDdb0S/0+zgRx1MS9NFjXiLtJQNv4lzMxGeccm
         poJAhEX135nrPzG7dmdiJsi2oa2JNo8wGXBhM5p5fBxzeBNpHlA6Tglr0WZ+VKhSWh1Q
         cMsuZtoaLWFmreDcVgeCN9ANjhZ+b/slZupxqld7+tFTPU8j9Hpb0N20TPXm7TZduVF4
         C8oQ==
X-Gm-Message-State: APjAAAX4rg72YVasKgh7u/hDNpmDyJDBHKi/xqZvHDbsMKmFfUOl7wUC
        geKBIDZuXQxCyr/5qDWN5+0=
X-Google-Smtp-Source: APXvYqysCxVXMoTrskLDknj6A+zYSggTxDmnhSSnVmwhyNIO6fwm//kfNy0Yb6rVqHQj9Fsr5aKc2Q==
X-Received: by 2002:a65:5281:: with SMTP id y1mr26294515pgp.327.1582103552650;
        Wed, 19 Feb 2020 01:12:32 -0800 (PST)
Received: from localhost.localdomain ([146.196.37.220])
        by smtp.googlemail.com with ESMTPSA id b18sm2074688pfb.116.2020.02.19.01.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 01:12:32 -0800 (PST)
From:   Amol Grover <frextrite@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Amol Grover <frextrite@gmail.com>
Subject: [PATCH] cfg80211: Pass lockdep expression to RCU lists
Date:   Wed, 19 Feb 2020 14:41:04 +0530
Message-Id: <20200219091102.10709-1-frextrite@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rdev->sched_scan_req_list maybe traversed using list_for_each_entry_rcu
outside an RCU read-side critical section but under the protection
of rtnl_mutex.

Hence, add corresponding lockdep expression to silence false-positive
warnings, and harden RCU lists.

Signed-off-by: Amol Grover <frextrite@gmail.com>
---
 net/wireless/scan.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index aef240fdf8df..7f1af8f347b1 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -556,9 +556,8 @@ cfg80211_find_sched_scan_req(struct cfg80211_registered_device *rdev, u64 reqid)
 {
 	struct cfg80211_sched_scan_request *pos;
 
-	WARN_ON_ONCE(!rcu_read_lock_held() && !lockdep_rtnl_is_held());
-
-	list_for_each_entry_rcu(pos, &rdev->sched_scan_req_list, list) {
+	list_for_each_entry_rcu(pos, &rdev->sched_scan_req_list, list,
+				lockdep_rtnl_is_held()) {
 		if (pos->reqid == reqid)
 			return pos;
 	}
-- 
2.24.1

