Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46DB19B779
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 21:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392258AbfHWT4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 15:56:45 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43084 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387919AbfHWT4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 15:56:44 -0400
Received: by mail-qk1-f193.google.com with SMTP id m2so9227689qkd.10
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 12:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=vTaAshi9pluGjENrrfftMicTMpjOrhGopwZB6hzguXI=;
        b=XmdnQ3XPOSwrLu3tByxh+ZVBCu+8gf4v3QrEQR7MLi6j6hCE30XvsnJlLL3xDZlsdg
         V1QEtfzdpAf2+cNrL+4PWXQ1bkdi4NPtQUY21KiBJBxJjlLTYKtN1Ev401gmS8S9+QBa
         rrse08tR0y5CdeiPpQM5Lr6s/vZBeJS0OcSoV0Zcn+GSOtvQmMs4JWZz2HzJ5oNt6S0e
         SLjINAoTnzuj3cLyU+aKUhFN9ity7DDqvCICkoz9933SUyRY5JR1DTyKatCz8RQMw8Zr
         8KoaRwTw14XZYst0RkajkIELjTnq6a7JkugjoJ37Y9ZCFdWmqih+POIn4bBq7NMGOT8Y
         o7OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vTaAshi9pluGjENrrfftMicTMpjOrhGopwZB6hzguXI=;
        b=t0TLuykDBn6RdEzJuG5dMBHF5qUFqKkTGbyOeK6MokNo7oxnYG7El5OtjlfbULbXDY
         4BA4ixPPLbSvx7QzOPeI6tKHKT7FbnFCLTbH8TAPQKruzYGPYH4GMSlZRz2uIXwKdt9K
         DegfQiD0ROlu5jmv6tvvDGCLZIXUwR8j3yKweA+DW2Ut0gnvT5ZNE15CT3Ekk80YQQLG
         aCSlmLhZrMTgrdoUZ6HQeUIlamdbh7AaRtp8NgDwx70kNV5YK+qxF6+xC1YS2YUeGys/
         Wy+fs8/Siynn9oZJwMi5XxqCTt1SWrF0kPqxYgD79VC2y9ME7qHN8Wv5qzXfueEizRFb
         r9eQ==
X-Gm-Message-State: APjAAAXQ5WD6Nhz9jskk9Xis34oa6+MHVpXzuMOjktKAZ2jTOnE0dyKV
        LdPugIDFyomiAsaQiicKpGfoUg==
X-Google-Smtp-Source: APXvYqxgf5wgeiL6ufbZ334VqWwMQGezy5CWWm0nzrMhCFpi0O8GIzGoB/gmIFkF6u6wtWR6LRzjFQ==
X-Received: by 2002:a37:9c88:: with SMTP id f130mr5826483qke.494.1566590203704;
        Fri, 23 Aug 2019 12:56:43 -0700 (PDT)
Received: from qcai.nay.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id n21sm2159771qtc.70.2019.08.23.12.56.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Aug 2019 12:56:42 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
To:     saeedm@mellanox.com
Cc:     leon@kernel.org, davem@davemloft.net, moshe@mellanox.com,
        ferasda@mellanox.com, eranbe@mellanox.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qian Cai <cai@lca.pw>
Subject: [PATCH] net/mlx5: fix a -Wstringop-truncation warning
Date:   Fri, 23 Aug 2019 15:56:23 -0400
Message-Id: <1566590183-9898-1-git-send-email-cai@lca.pw>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In file included from ./arch/powerpc/include/asm/paca.h:15,
                 from ./arch/powerpc/include/asm/current.h:13,
                 from ./include/linux/thread_info.h:21,
                 from ./include/asm-generic/preempt.h:5,
                 from ./arch/powerpc/include/generated/asm/preempt.h:1,
                 from ./include/linux/preempt.h:78,
                 from ./include/linux/spinlock.h:51,
                 from ./include/linux/wait.h:9,
                 from ./include/linux/completion.h:12,
                 from ./include/linux/mlx5/driver.h:37,
                 from
drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h:6,
                 from
drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c:33:
In function 'strncpy',
    inlined from 'mlx5_fw_tracer_save_trace' at
drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c:549:2,
    inlined from 'mlx5_tracer_print_trace' at
drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c:574:2:
./include/linux/string.h:305:9: warning: '__builtin_strncpy' output may
be truncated copying 256 bytes from a string of length 511
[-Wstringop-truncation]
  return __builtin_strncpy(p, q, size);
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fix it by using the new strscpy_pad() since the commit 458a3bf82df4
("lib/string: Add strscpy_pad() function") which will always
NUL-terminate the string, and avoid possibly leak data through the ring
buffer where non-admin account might enable these events through perf.

Fixes: fd1483fe1f9f ("net/mlx5: Add support for FW reporter dump")
Signed-off-by: Qian Cai <cai@lca.pw>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index 8a4930c8bf62..2011eaf15cc5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -546,7 +546,7 @@ static void mlx5_fw_tracer_save_trace(struct mlx5_fw_tracer *tracer,
 	trace_data->timestamp = timestamp;
 	trace_data->lost = lost;
 	trace_data->event_id = event_id;
-	strncpy(trace_data->msg, msg, TRACE_STR_MSG);
+	strscpy_pad(trace_data->msg, msg, TRACE_STR_MSG);
 
 	tracer->st_arr.saved_traces_index =
 		(tracer->st_arr.saved_traces_index + 1) & (SAVED_TRACES_NUM - 1);
-- 
1.8.3.1

