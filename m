Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E57AB168329
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 17:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbgBUQVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 11:21:34 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:54642 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbgBUQVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 11:21:34 -0500
Received: by mail-pj1-f67.google.com with SMTP id dw13so952118pjb.4;
        Fri, 21 Feb 2020 08:21:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=JyA56Sz4rDYUzhUKZvP6bdIvgdElbbaajnOFHJnaXLc=;
        b=DE+SrDBPDDTb1TICMcYIxzYdqSDYAiveqSaQQvK4xYbNYQrkmkO3WErz1+/yhArJPk
         ZzWT7gaLw2np4/JB9+AZDLNiYB+ohDTEJhXPjkXUHmxJ5b/QhbAjMchUAQmJLJ03wuMo
         FMoSfPkDz5CscZa217W/Qk9bjgHhYDniErdBHlGDZJS1p555vqsMg/rRpsK3N0PG8WCN
         ZZh2aDcsREILdE753ELtLSyt+pye1kQ0+mL4v7N0cMIAYEi5mZL3NDlCcZ7JcBGpQezL
         JGyZJd8jQf97o6Qd7kGLc/T5e3F2847OD23UKX20gkd4EqMgXd9CFDX/VO2dkqEVMQVr
         856A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JyA56Sz4rDYUzhUKZvP6bdIvgdElbbaajnOFHJnaXLc=;
        b=tesQURX3KVk8pZn7qDSMF9cEEYyAsyC/bFqtfpliAtlCqFRxeikTgPZ/Q1ZUY43wor
         m+4Q4dE+/2NAOneAbfi1maHfXD3vnD0vgd+TkAVVAUaYNju66o/haG2IpbvUojvwuy+i
         A6FdbT2hFZjbDNlZsldt2Xz5suffjOwQ89Mw4EpNl83i794XHBZOD4+9Qj64edgOE/Xh
         jm8tjVytq+Y7ZudbfBEOimJBFLd2toUBQwHYp95faV+9IkIWkopQ7z2tW+8O+cgIPUNK
         o03xmjAb0QLeN8hqzBJ+X9HExepQ9ESqZaD8RO9Dm40oQndbZAVIGMwedr9+uY2J8lgI
         2WIQ==
X-Gm-Message-State: APjAAAWusyH9lO9/cDOGzFbm/NXl8VL1PDEIcxF3T08590ElinlhGz7O
        Bjo7i7TsxeklkJ5lhvu3tQ==
X-Google-Smtp-Source: APXvYqwXCzQMECdVFGJVUJX++W20f3DOsoPhx7ymDk5W84p9+jpmBSJLZBPQFXOtSP4alzuXmkRpHA==
X-Received: by 2002:a17:90a:5d97:: with SMTP id t23mr3957136pji.61.1582302093578;
        Fri, 21 Feb 2020 08:21:33 -0800 (PST)
Received: from madhuparna-HP-Notebook.nitk.ac.in ([2402:3a80:1ee0:fe5e:d03d:769b:c838:c146])
        by smtp.gmail.com with ESMTPSA id j15sm2440183pga.11.2020.02.21.08.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 08:21:32 -0800 (PST)
From:   madhuparnabhowmik10@gmail.com
To:     davem@davemloft.net, gregkh@linuxfoundation.org,
        tglx@linutronix.de, allison@lohutok.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@joelfernandes.org, frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH] net: 802: psnap.c: Use built-in RCU list checking
Date:   Fri, 21 Feb 2020 21:49:47 +0530
Message-Id: <20200221161947.11536-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

list_for_each_entry_rcu() has built-in RCU and lock checking.

Pass cond argument to list_for_each_entry_rcu() to silence
false lockdep warning when CONFIG_PROVE_RCU_LIST is enabled
by default.

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 net/802/psnap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/802/psnap.c b/net/802/psnap.c
index 40ab2aea7b31..4492e8d7ad20 100644
--- a/net/802/psnap.c
+++ b/net/802/psnap.c
@@ -30,7 +30,7 @@ static struct datalink_proto *find_snap_client(const unsigned char *desc)
 {
 	struct datalink_proto *proto = NULL, *p;
 
-	list_for_each_entry_rcu(p, &snap_list, node) {
+	list_for_each_entry_rcu(p, &snap_list, node, lockdep_is_held(&snap_lock)) {
 		if (!memcmp(p->type, desc, 5)) {
 			proto = p;
 			break;
-- 
2.17.1

