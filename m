Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F048517EDF8
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgCJBXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:23:04 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:51875 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgCJBXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 21:23:04 -0400
Received: by mail-pl1-f201.google.com with SMTP id 71so6420533plb.18
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 18:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Odi1b1kcfprvgPApD7rImBTYP/YrBqpqjTFcFnfSFUA=;
        b=TAgYtrIzD7syhlsknvpT/O2zgT0QR1hpJZ0U2F0cr2NpbFliRP6tDnJvLxOm555H5w
         5lzWM8lSuHcuf3u7s3imuWzFcFcI8V5ikhP8MaXoeSlk6iZwo+9WH4BvcVOqM36BjJhH
         ccbt+Cp3MtUlqgj/3WSu5EflcETqU5c+zxzDWNqKrTz8m8fmFGOpMPi7MPVCI2zxcPml
         nXWIr+RT7CJ2EvbETZud0yMiG2vM1gJU2+2cctxytNM7jeNpDY1fQw4gE6wTjtg+WL7B
         21OKZr+pBvdjszirnSr3VF3AA+yZPzPixkmgvvTAUNhgZdaVEvyuEfj2i3jnBIXrH5i3
         5NyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Odi1b1kcfprvgPApD7rImBTYP/YrBqpqjTFcFnfSFUA=;
        b=N8XEyKt+/2DGfNeyoRZOTAF7rUIwTZBsHta4lIi9rsV3Gf0MczKQEks/GGZnpg42Wg
         TGrszlGalt0TrxiIfGhdpOSc1Q8gL0Pwx4nHWYpN/IM4N+kR8BMM6AHLCAhurM4iEpZ8
         uea998OrAStdgdx/EaG/8SSWsaQ9t1Lji83evwgZktDlfa4VFXUo+4R/qb6vligA1T2U
         zvkUTWNXaLyyiA992eAw3uvmKI0YtOWIz5P/xHi6eQDUajno8qjFDDV1P0HCpVbudfHt
         TEl9p1QknX+FhW0MP+KEA9p9vq+P64rePPmEqysG8GSG8u24Aznhpdacveh4OSN9iB9M
         UtYw==
X-Gm-Message-State: ANhLgQ3UFqnJo0kaRr/DV207GJklssgbmnEQd4jXEOdfcaQz9aa+Cxnl
        fbIJ9/62BQfubn4buPRTkaJVebjlN4KYpQ==
X-Google-Smtp-Source: ADFU+vuUD3CJ6dA2nyQKU3moV0E/T8suEWYllI81U+buXv5kUZiyALNYJlHiKfvJxcnrbbb2WgKbR3VT0YaX4A==
X-Received: by 2002:a17:90a:fb4d:: with SMTP id iq13mr2099080pjb.165.1583803383094;
 Mon, 09 Mar 2020 18:23:03 -0700 (PDT)
Date:   Mon,  9 Mar 2020 18:22:58 -0700
Message-Id: <20200310012258.196797-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH net] ipvlan: do not use cond_resched_rcu() in ipvlan_process_multicast()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit e18b353f102e ("ipvlan: add cond_resched_rcu() while
processing muticast backlog") added a cond_resched_rcu() in a loop
using rcu protection to iterate over slaves.

This is breaking rcu rules, so lets instead use cond_resched()
at a point we can reschedule

Fixes: e18b353f102e ("ipvlan: add cond_resched_rcu() while processing muticast backlog")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Mahesh Bandewar <maheshb@google.com>
---
 drivers/net/ipvlan/ipvlan_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index 5759e91dec7105cb6d27ce8b4e47eae26f711ad5..8801d093135c3e72ca22643a8fbc7bf896727e4b 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -277,7 +277,6 @@ void ipvlan_process_multicast(struct work_struct *work)
 			}
 			ipvlan_count_rx(ipvlan, len, ret == NET_RX_SUCCESS, true);
 			local_bh_enable();
-			cond_resched_rcu();
 		}
 		rcu_read_unlock();
 
@@ -294,6 +293,7 @@ void ipvlan_process_multicast(struct work_struct *work)
 		}
 		if (dev)
 			dev_put(dev);
+		cond_resched();
 	}
 }
 
-- 
2.25.1.481.gfbce0eb801-goog

