Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAC9F1685BC
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 18:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgBUR55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 12:57:57 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42869 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgBUR54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 12:57:56 -0500
Received: by mail-pg1-f195.google.com with SMTP id w21so1336445pgl.9;
        Fri, 21 Feb 2020 09:57:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/D8p3umAJnu2Rmie5wIDoJw/XtMw5bg4kYLl7SwrZqU=;
        b=Ww5wf2M+U9Q9PdbDPXvGrX8xRuaMm0OJNS0dg5taavKaGzja/6wQ3vcI5viCda1hJs
         lT90s9PxizSUnPh3GM6n7qW+L3P2b19jUVhx2RfEwGHYN5izqrmRByIp/87hBfNltO8L
         2SUidAyZB5hV0u7D/3L+t/gBL0725j/KTFVW8YciNMCupa5X8m0xJpz+hBaOwEDO3j0M
         D70mPvxlyGYUSS7hCu9AF9eReMfQR1OCoJub8D0zPtzVxw+LsuGB5Bqdx0sjEpijjpN+
         Zt7HxKVu/v4sDrpVaLWN+j95T8BCuWMRsMOScR551d1agjYGg6MXaD679cRGftp+HHcn
         VkOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/D8p3umAJnu2Rmie5wIDoJw/XtMw5bg4kYLl7SwrZqU=;
        b=g3ISJIYU0QssCYzAPuPadxvkhJQvylD5d3uWNq7bUToMpDcAubfYdXmImlGOZwidyX
         X3GETyP+v40RxOADWxt8lqfc3p1mSPOY1YsdG9/JForiHXAWLRph88mka226dEl5rf1W
         /Fw6ZTHy2+1hfCholCE8S3CC4Ug696lW/gWx9zA1+nUWiAciiVvwl/uwTWsiJomqOReF
         fCiII/1PmhbUVNzp4PfnEYH8WsRvZ7QMn9TJ6NALGMBtJzDywpHRIfulAKQOrZ0vGWzp
         +7mhG2b5S3Wk/7CyZqwPXdgoSrUkmMK+C/cckrkSbnKtRjiMpCm+QKbdXtdU2qC7ULR9
         W3Sw==
X-Gm-Message-State: APjAAAU03dEkT5YSc2c6973jKLZ7xDzMeaQeigXoeLi5aqIHTo+d+c9T
        7it20/THd2JAL7BDF2l7uCU=
X-Google-Smtp-Source: APXvYqyuPt2CUyWo6GMoDeY5O469l5MPv7Qd2vF+TA+kyd9ggfinqj2ZrCDRKtEIY+r/Ko20/RKbnA==
X-Received: by 2002:a63:cd03:: with SMTP id i3mr40862108pgg.257.1582307874467;
        Fri, 21 Feb 2020 09:57:54 -0800 (PST)
Received: from localhost.localdomain ([103.87.57.170])
        by smtp.googlemail.com with ESMTPSA id t19sm3128544pgg.23.2020.02.21.09.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 09:57:54 -0800 (PST)
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
Subject: [PATCH] tcp: ipv4: Pass lockdep expression to RCU lists
Date:   Fri, 21 Feb 2020 23:27:14 +0530
Message-Id: <20200221175713.2112-1-frextrite@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

md5sig->head maybe traversed using hlist_for_each_entry_rcu
outside an RCU read-side critical section but under the protection
of socket lock.

Hence, add corresponding lockdep expression to silence false-positive
warnings, and harden RCU lists.

Signed-off-by: Amol Grover <frextrite@gmail.com>
---
 net/ipv4/tcp_ipv4.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 1c7326e04f9b..6519429f32cd 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1000,7 +1000,8 @@ struct tcp_md5sig_key *__tcp_md5_do_lookup(const struct sock *sk,
 	if (!md5sig)
 		return NULL;
 
-	hlist_for_each_entry_rcu(key, &md5sig->head, node) {
+	hlist_for_each_entry_rcu(key, &md5sig->head, node,
+				 lockdep_sock_is_held(sk)) {
 		if (key->family != family)
 			continue;
 
@@ -1043,7 +1044,8 @@ static struct tcp_md5sig_key *tcp_md5_do_lookup_exact(const struct sock *sk,
 	if (family == AF_INET6)
 		size = sizeof(struct in6_addr);
 #endif
-	hlist_for_each_entry_rcu(key, &md5sig->head, node) {
+	hlist_for_each_entry_rcu(key, &md5sig->head, node,
+				 lockdep_sock_is_held(sk)) {
 		if (key->family != family)
 			continue;
 		if (!memcmp(&key->addr, addr, size) &&
-- 
2.24.1

