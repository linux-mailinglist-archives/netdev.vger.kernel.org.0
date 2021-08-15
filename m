Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1F43EC7E5
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 09:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235891AbhHOHOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 03:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235569AbhHOHOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Aug 2021 03:14:09 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC8AC061764
        for <netdev@vger.kernel.org>; Sun, 15 Aug 2021 00:13:40 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id 22so6388960qkg.2
        for <netdev@vger.kernel.org>; Sun, 15 Aug 2021 00:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/ib3wWEROhd5UHEUAQkbVJo5eQ4Oa8CwrF9bgbAj9JI=;
        b=N93tpXaCJD+gvz1BiOtpdGgFtFz5+h9jjm6U9OUUfk2tPdSMCIuDxUWTRUuLJRSm9S
         sRfzbLZndKqpWc15EWPXfmrE86H6yXL1ATEIoB+pWVs0/F1VwJManz6DK4MsIfxW2LHj
         Ord6dg8Vjtwt1L9e3IL+9t9WUresKaUnRUgtP5q1sN8+GyqvQmFJmMGI4nUUs/lQUQCR
         Vksukt9LS4zXScRlpPSAouFzgUpYdhz2KOmd2yCH0sMo3AWOa7sw7evKiGIlGpFdzev8
         vqYImm6qhdVjQSEZC8qV6N/Ki3kRDAC+FZ7+i0xciszH3OtYEfSN3V/++iq8MOJUD8Cf
         Yhsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/ib3wWEROhd5UHEUAQkbVJo5eQ4Oa8CwrF9bgbAj9JI=;
        b=QcqKLFDEVfssB+fRQkaLDlvgygOzd4bTYShiWX7fwjj/cGD1XkhYElho1L4c7Pp+Fc
         HS70dxxgSWFzL040L9YKhQFBaySPH4WZhIkbjUBlrj920mxX1AArC7iK7faiCxJKYg5M
         6mB36InZvMgkf7bdQI7f3qhhjmn9yQinlFPTHQJ3E8jeQEH923ZZAY5dxG5dwhL0fw1P
         ttbfXwQCRMoSH9s9nQYxTZjEg9LbGGkgdMZe08kS9pAcQBfgBK5i/HxoneI/ezoQftLT
         ea0nif36WAS3fXvsIFXQAEj1f7IIi2ly9/MvlyJBwX0nGrZFsGBwiB0Gq9UX7zepxydr
         hKbw==
X-Gm-Message-State: AOAM5329tF4eDcsFo5Hckq56IX9cq07o99RoTlA0kTRmJ91Jc8BWY9jV
        BUPdmLIxY+Afd5kQtu5HjCy+1oHqQQY=
X-Google-Smtp-Source: ABdhPJy055qDm8GSCzL/CPbr2argWOTIQMLRvkdPSrAXBBX0G43UYb8J8uDRLcIqGrmqDs2bsJJARQ==
X-Received: by 2002:a05:620a:138c:: with SMTP id k12mr10381375qki.172.1629011619317;
        Sun, 15 Aug 2021 00:13:39 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 75sm4189702qko.100.2021.08.15.00.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 00:13:38 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, tipc-discussion@lists.sourceforge.net
Cc:     Jon Maloy <jmaloy@redhat.com>
Subject: [PATCH net] tipc: call tipc_wait_for_connect only when dlen is not 0
Date:   Sun, 15 Aug 2021 03:13:36 -0400
Message-Id: <7b0de7eba8cf97280106732f84800b55ff359604.1629011616.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__tipc_sendmsg() is called to send SYN packet by either tipc_sendmsg()
or tipc_connect(). The difference is in tipc_connect(), it will call
tipc_wait_for_connect() after __tipc_sendmsg() to wait until connecting
is done. So there's no need to wait in __tipc_sendmsg() for this case.

This patch is to fix it by calling tipc_wait_for_connect() only when dlen
is not 0 in __tipc_sendmsg(), which means it's called by tipc_connect().

Note this also fixes the failure in tipcutils/test/ptts/:

  # ./tipcTS &
  # ./tipcTC 9
  (hang)

Fixes: 36239dab6da7 ("tipc: fix implicit-connect for SYN+")
Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
---
 net/tipc/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 75b99b7eda22..8754bd885169 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1518,7 +1518,7 @@ static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
 
 	if (unlikely(syn && !rc)) {
 		tipc_set_sk_state(sk, TIPC_CONNECTING);
-		if (timeout) {
+		if (dlen && timeout) {
 			timeout = msecs_to_jiffies(timeout);
 			tipc_wait_for_connect(sock, &timeout);
 		}
-- 
2.27.0

