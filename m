Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 451A81698D2
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 18:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbgBWRUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 12:20:25 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41910 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgBWRUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 12:20:24 -0500
Received: by mail-pl1-f195.google.com with SMTP id t14so3013393plr.8;
        Sun, 23 Feb 2020 09:20:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xM5ras975p0Tzn0AuQOvcenknUI3u0IBL1jh0ZA+WuQ=;
        b=cNzhGR+x91SUFBvtXojwfDzu/7qK3SG6d+HdeMkmTDaOCAeTuN/7OrYOWaJ5TNp3jv
         nxH8krORBX1l+0cI2mTSjCpqLGxuBmaOvfoi2eNHIE2sWnFgqhv8V+BZmmd6HJ6HtW5A
         7lrRptjJNIo9aCxh+dRgWonVLM8JmvES0w0G5obacQzr5y7hVuJx5YbxUarmb6Ity/Am
         J2vjWDjxKOilrz2sDExP2gLmkC/aRHhLputa1s2dKuGJUCdke4Qq8MJwngpedGOfMUIU
         MRC3bnah4NLrS1LC/jzDXN0PqPCCYG6AlNfXlG5723V/RGkiZoEe32cMqpwRxcEvL5eR
         B/CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xM5ras975p0Tzn0AuQOvcenknUI3u0IBL1jh0ZA+WuQ=;
        b=XgkWafjbG8qgxHVFNEnDup14R78eMYjqUuOzYDTHSSFjUxI+IuleR0SvVwdt4/u0Ca
         mWxrB4bZ0bgUDWSo5+vxkCdhpCYSF07CIRrC7h7KjC7kFflfwsHRZhbpTsTfmX0Mbtk6
         LKm4R65Z37mhcqL5FERMCiIp3k3uSwtP+TI+55hmMVQtu3DpjKKmmEFgUp/fvmA1ZBQI
         b3oYoUVmjjGp5aIbfgeyJGi8NZgSWXTBMc9AR5vgTfQ5VEZeTH4EeeqyJrrxeOGRNhXv
         pMQ3ElcZQH1lXETjcCP0obWMiVCMbdt43t0fbwJBfsRP0VfFz9DU9ixplJOaVeMYEbdD
         fFPQ==
X-Gm-Message-State: APjAAAVuV8BkSiSuWJesEQd4xVWV1r+nlTPQRlw2DaSmp4tGpX0V5TPO
        tuTY75BLie9Fqd7LBerYDrM=
X-Google-Smtp-Source: APXvYqxDhCPLqPA5RnVmZfA4rmg+IVQHA0vM8maBAyDA85AuIvnSjzr1DyVrQYqi6zUsbOcwQ2uD/w==
X-Received: by 2002:a17:902:463:: with SMTP id 90mr48781720ple.213.1582478423623;
        Sun, 23 Feb 2020 09:20:23 -0800 (PST)
Received: from localhost.localdomain ([103.87.57.33])
        by smtp.googlemail.com with ESMTPSA id 13sm9505424pfj.68.2020.02.23.09.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 09:20:23 -0800 (PST)
From:   Amol Grover <frextrite@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Amol Grover <frextrite@gmail.com>
Subject: [PATCH 2/2] netfilter: Pass lockdep expression to instance_lookup traversal
Date:   Sun, 23 Feb 2020 22:49:46 +0530
Message-Id: <20200223171945.11391-2-frextrite@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200223171945.11391-1-frextrite@gmail.com>
References: <20200223171945.11391-1-frextrite@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

q->instance_table[] may be traversed outside an RCU read-side
critical section but under the protection of q->instances_lock.

Hence, add the corresponding lockdep expression to silence
false-positive lockdep warnings.

Signed-off-by: Amol Grover <frextrite@gmail.com>
---
 net/netfilter/nfnetlink_queue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index feabdfb22920..5aef41847774 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -105,7 +105,8 @@ instance_lookup(struct nfnl_queue_net *q, u_int16_t queue_num)
 	struct nfqnl_instance *inst;
 
 	head = &q->instance_table[instance_hashfn(queue_num)];
-	hlist_for_each_entry_rcu(inst, head, hlist) {
+	hlist_for_each_entry_rcu(inst, head, hlist,
+				 lockdep_is_held(&q->instances_lock)) {
 		if (inst->queue_num == queue_num)
 			return inst;
 	}
-- 
2.24.1

