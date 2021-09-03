Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E393FF91A
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 05:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346748AbhICDYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 23:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242941AbhICDYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 23:24:34 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1F7C061575;
        Thu,  2 Sep 2021 20:23:34 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id t9so3516264qtp.2;
        Thu, 02 Sep 2021 20:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5S0yh8cttWmglArpNLxzYf76csSVpKARM1NaNWL0GBs=;
        b=oQWWZyP30E0aHZRFdGfb1OHZ+nKzijseaPwgwjp1JbgRCSOSdj1BSAU1rqSzgOlKjq
         aigUrhJT2HD2MGz0rXbO5mJGuWENQrTlo0oHJAPJUaJDa6lUbjCOLPqtRb9HFDUegwEn
         FaSMShOYR9SATH/MXsvarvLKIN04nXGseLNRzvx9UwbQrE8JCqHGIkz4FTHOfCAL7Urm
         NVI4/Q7WhUw9aMHympmqEXgC3nSVqKMuSz1mvllwuyrlXp6WdimmyyhfNOMj0fMnphh2
         kd+xIlNykz/5b4QR40lP25mbfh48b4h1hT5d4vBm+ldIMw6yRVk9Y0POeVEdPCFlHLsr
         siTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5S0yh8cttWmglArpNLxzYf76csSVpKARM1NaNWL0GBs=;
        b=HN4Go3sBJKd6l60xINQfmdM8rVbOiXGfGIB0U0NiMi1nCrvtDTA6EJ6j4gBr9GxpYJ
         bwruRRh1vp6z3rynlFpFVLWodTQmWBqNqf+O1g6WkVhaWacqrezYunphImiI+A8pf4qS
         q+2z585EJR6k6/0sp+ZkjnZY+6VIg//lkedesu8ifskZ6FS4sj7NX4Z916iBRzMtnPYm
         J8KukYBTInBXD1H/B/0JJmaeVip7vR6ryqS6SKm0IOmi2sKTspUM61CV9rntOEz9vHaK
         WtW5fJw4qrmvwkwg60Cc5p7XytZ+jRqKxAKgW2/b+DdUKIx5a21DCOtLRhjKQBU1h3wo
         oBnw==
X-Gm-Message-State: AOAM531uRZWVZz1ykpmLS1Rs0kwLH9xIuZkCLvlB5BfYPt5gT+Uw0tdO
        CySCATS4Lc/k+qnyg+GuGxc=
X-Google-Smtp-Source: ABdhPJww0+/x/yCK6CPLni/Sb51oAxmWmREIIBENRcEu4cPbM9CxRbAGrPw5jw8a6tqaHfBXwCw3ow==
X-Received: by 2002:ac8:4618:: with SMTP id p24mr1789410qtn.205.1630639414168;
        Thu, 02 Sep 2021 20:23:34 -0700 (PDT)
Received: from localhost.localdomain (pool-72-82-21-11.prvdri.fios.verizon.net. [72.82.21.11])
        by smtp.gmail.com with ESMTPSA id v5sm2984729qkh.39.2021.09.02.20.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 20:23:33 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
Subject: [PATCH 1/2] Bluetooth: call sock_hold earlier in sco_conn_del
Date:   Thu,  2 Sep 2021 23:13:05 -0400
Message-Id: <20210903031306.78292-2-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210903031306.78292-1-desmondcheongzx@gmail.com>
References: <20210903031306.78292-1-desmondcheongzx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In sco_conn_del, conn->sk is read while holding on to the
sco_conn.lock to avoid races with a socket that could be released
concurrently.

However, in between unlocking sco_conn.lock and calling sock_hold,
it's possible for the socket to be freed, which would cause a
use-after-free write when sock_hold is finally called.

To fix this, the reference count of the socket should be increased
while the sco_conn.lock is still held.

Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
---
 net/bluetooth/sco.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index b62c91c627e2..4a057f99b60a 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -187,10 +187,11 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
 	/* Kill socket */
 	sco_conn_lock(conn);
 	sk = conn->sk;
+	if (sk)
+		sock_hold(sk);
 	sco_conn_unlock(conn);
 
 	if (sk) {
-		sock_hold(sk);
 		lock_sock(sk);
 		sco_sock_clear_timer(sk);
 		sco_chan_del(sk, err);
-- 
2.25.1

