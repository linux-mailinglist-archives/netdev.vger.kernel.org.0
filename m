Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B54F164136
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 11:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgBSKG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 05:06:27 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:36112 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgBSKG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 05:06:26 -0500
Received: by mail-pj1-f65.google.com with SMTP id gv17so2329209pjb.1;
        Wed, 19 Feb 2020 02:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GVRdPNZo5d7eI2NxNW1l7GKKSA1O3A8YX4K6fJNiyFY=;
        b=j0baOwT4MtNLCJOeh0o5lSqPQB90+Rp/h2KSZs0EGIBpTIb0AtoyvA9Om1n5YFIChN
         kteaGHD0cop5owLYIfi7ILHZFl/vUjEP8PP4z5tDqAuta7CFnOTHkXjeGdoceEfQY4XO
         +Ebx9VrVptRX/UV81DTLEQDt6kUPYlRyDJtljGmiWE6bAj0ohSZlDqigr+O8baB1TD7n
         IXCxhV5e35GbRm/8inLkz6r+6idv2be0yxk/GyBL3pGxrBw/DpTlWvPXiJBj6ZrPuQ81
         RyptQrK4Rp5tDRTw1lnJo2YOWDKA4Y202Di+Cqnuq/xTMh9naiEzvBzwJ+IaZfs+Hup8
         yNSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GVRdPNZo5d7eI2NxNW1l7GKKSA1O3A8YX4K6fJNiyFY=;
        b=hN73Fn4ZbR7speJsfuqEwK1Vz+++ntnk+yoVJzE15mZhA5BoHAeeioaG0I0Pzb5I4a
         /WWEdl2dQtE8rE3/9kXJ0BDXNIp78ysXVEWM57hdDDdl7Q2OpnzdEm8VsHEdxAhWCouo
         UcTqdAJ/SKAFFtTQp+PXMZfzrZoXa8iutTJjfkbgnQt1dcqmLHe8oFxQvKKMAN4vbMkl
         zgxtp4XyGudUPOMRHnMUHCVsGIKhOJMgVUwLboFVSmV8R1+nWzAyVSMRkS4p8QIruDri
         OxJzn34KtY+BuV/4iLlPPVGZVED886hlAhpr5Zhe64epBBwjDyAnE308SLATT0nWKfK2
         Wguw==
X-Gm-Message-State: APjAAAWMZecFY/2cH+wMUkV14sNmkCbbHAP2tJFQ0QONnQMlwTMuRS/3
        QpciQOIErzEbiKdWskGuqZ0=
X-Google-Smtp-Source: APXvYqzBjjlOD+j8XLKGMCJFZ0gJV4hY7IPslrCb7PxPpQVZPaaNPRR0FsXbdorABRNjPsdeAx5FPQ==
X-Received: by 2002:a17:902:7c85:: with SMTP id y5mr24648684pll.227.1582106786018;
        Wed, 19 Feb 2020 02:06:26 -0800 (PST)
Received: from localhost.localdomain ([146.196.37.220])
        by smtp.googlemail.com with ESMTPSA id w14sm2097754pgi.22.2020.02.19.02.06.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 02:06:25 -0800 (PST)
From:   Amol Grover <frextrite@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>, netdev@vger.kernel.org,
        Amol Grover <frextrite@gmail.com>
Subject: [PATCH] tcp: Pass lockdep expression to RCU lists
Date:   Wed, 19 Feb 2020 15:35:46 +0530
Message-Id: <20200219100545.27397-1-frextrite@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_cong_list is traversed using list_for_each_entry_rcu
outside an RCU read-side critical section but under the protection
of tcp_cong_list_lock.

Hence, add corresponding lockdep expression to silence false-positive
warnings, and harden RCU lists.

Signed-off-by: Amol Grover <frextrite@gmail.com>
---
 net/ipv4/tcp_cong.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index 3737ec096650..8d4446ed309e 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -25,7 +25,8 @@ static struct tcp_congestion_ops *tcp_ca_find(const char *name)
 {
 	struct tcp_congestion_ops *e;
 
-	list_for_each_entry_rcu(e, &tcp_cong_list, list) {
+	list_for_each_entry_rcu(e, &tcp_cong_list, list,
+				lockdep_is_held(&tcp_cong_list_lock)) {
 		if (strcmp(e->name, name) == 0)
 			return e;
 	}
@@ -55,7 +56,8 @@ struct tcp_congestion_ops *tcp_ca_find_key(u32 key)
 {
 	struct tcp_congestion_ops *e;
 
-	list_for_each_entry_rcu(e, &tcp_cong_list, list) {
+	list_for_each_entry_rcu(e, &tcp_cong_list, list,
+				lockdep_is_held(&tcp_cong_list_lock)) {
 		if (e->key == key)
 			return e;
 	}
@@ -317,7 +319,8 @@ int tcp_set_allowed_congestion_control(char *val)
 	}
 
 	/* pass 2 clear old values */
-	list_for_each_entry_rcu(ca, &tcp_cong_list, list)
+	list_for_each_entry_rcu(ca, &tcp_cong_list, list,
+				lockdep_is_held(&tcp_cong_list_lock))
 		ca->flags &= ~TCP_CONG_NON_RESTRICTED;
 
 	/* pass 3 mark as allowed */
-- 
2.24.1

