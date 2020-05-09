Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A45211CBE61
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 09:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbgEIHYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 03:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725822AbgEIHYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 03:24:06 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C174EC061A0C;
        Sat,  9 May 2020 00:24:06 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id n11so1971073pgl.9;
        Sat, 09 May 2020 00:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O6NOWgkJuVNBzcRIWQKK+1L2R6ELyCXl3BZEpc2cyyg=;
        b=KUc+DAyxbo/FIS+4ZMWHTtwo6Scti9M6yahWtKDsNxEMlPDPUR2gzIMoGEdEJszrYh
         yTljj1+PVG4Fy6LZ9x2kjiHQnC2qaotowIAdSHDX9LBsHeBkobPRtDapevkpz/D47TKt
         BR+X3l9qhCILE3KscM+h8IXp2Rrug8V+6hjbFY8O9s2D0ROHxnLLLlRDXM0k4X5OqYOX
         fp1LQgIGNHScNVR9h6q2t0tvkeiAjw61Rm+/vdQhKpluCNGdrDoQjZgJpsopz2L5Zrk/
         Ddfxg1DflK9NwFWtiA0KDnOGZIiNN/MBy3m0zx+tYPSMiP7YKzgdy9YSg8UOqo0gdN2L
         PzZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O6NOWgkJuVNBzcRIWQKK+1L2R6ELyCXl3BZEpc2cyyg=;
        b=lGNzmU4R2IhaVTub2SG/x9EWAEIuRNZR9yLIIYHM/eWBQ665Fh7H2FsT7ugsT4snAw
         MjQQtqyQiuo+aXQFBJQT53FORfIUXm/sFgMiW7oQLohg+eN+3l77Q12PqhLq2z0LBXz1
         0Xr5TZxBrx/ANpa9rdlg8gg+a3KF9UAeLs+hCSAGqTaB6hYFtpEhviPk+cwG6akDGxgG
         t20gSqcL5dY3vwGYzmJIU+ab/Ia1OdglAATY3gn9q/dXHvnUGEgNPwnbL4dU1v9Zc4SK
         24b1FvL8r5KJOkGn+Eemjp0Ojp52zvpHrMEUeUEZzXQ1kmYrdBHkObXuyr3k4BHiknt1
         rcXw==
X-Gm-Message-State: AGi0PuYzqGo2qvRq0NQIsiAZ5K/HQGVgcAXhlbDHwQswp+YvhkmHjrG5
        lYweykLiUBWT2pKtz+0tSAo=
X-Google-Smtp-Source: APiQypLTU3XMkvl0Nz44wwzDblB4tt49h2bt3Qv4UGrAIw0pZYdRRFVUWDJLSt6+VdFXVmRMfm3pag==
X-Received: by 2002:aa7:9148:: with SMTP id 8mr7084252pfi.154.1589009046017;
        Sat, 09 May 2020 00:24:06 -0700 (PDT)
Received: from localhost.localdomain ([103.87.56.89])
        by smtp.googlemail.com with ESMTPSA id f74sm14024249pje.3.2020.05.09.00.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2020 00:24:05 -0700 (PDT)
From:   Amol Grover <frextrite@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Amol Grover <frextrite@gmail.com>
Subject: [PATCH net 1/2 RESEND] ipmr: Fix RCU list debugging warning
Date:   Sat,  9 May 2020 12:52:43 +0530
Message-Id: <20200509072243.3141-1-frextrite@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ipmr_for_each_table() macro uses list_for_each_entry_rcu()
for traversing outside of an RCU read side critical section
but under the protection of rtnl_mutex. Hence, add the
corresponding lockdep expression to silence the following
false-positive warning at boot:

[    4.319347] =============================
[    4.319349] WARNING: suspicious RCU usage
[    4.319351] 5.5.4-stable #17 Tainted: G            E
[    4.319352] -----------------------------
[    4.319354] net/ipv4/ipmr.c:1757 RCU-list traversed in non-reader section!!

Signed-off-by: Amol Grover <frextrite@gmail.com>
---
 net/ipv4/ipmr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 6e68def66822..99c864eb6e34 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -110,7 +110,8 @@ static void ipmr_expire_process(struct timer_list *t);
 
 #ifdef CONFIG_IP_MROUTE_MULTIPLE_TABLES
 #define ipmr_for_each_table(mrt, net) \
-	list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list)
+	list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list, \
+				lockdep_rtnl_is_held())
 
 static struct mr_table *ipmr_mr_table_iter(struct net *net,
 					   struct mr_table *mrt)
-- 
2.24.1

