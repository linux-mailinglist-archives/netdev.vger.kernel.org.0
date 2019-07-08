Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30682626C2
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389806AbfGHQ7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:59:49 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46508 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbfGHQ7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:59:49 -0400
Received: by mail-pl1-f193.google.com with SMTP id c2so7008852plz.13;
        Mon, 08 Jul 2019 09:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=M3r77HPoR75nODznb59FunQ4r0tjo8oLCP/b83AxrN8=;
        b=KatOOtnQGpKUP1iSy6HoQEZiDXZESM2WHSTXHadmTzY1H8QGTiL9VVVFjI1tjvMiz1
         2WO37JzpdM1TeYEXRYD9iSV/6nnOh6pZTrBhXKRpePJQ3m/5q0BYfhSMwlCv3JYiPjXG
         7mNiRfaHf8xC7vH7XNrvcNy1oTCPIZgv4yuD+HmyFBaMdD9w93OGh0sjAhJUnZuEbGwZ
         Jn/pKvY9l1Ovy0t2G61W/GtQsyvO/3UhMOtXgkKxp9XVwk2rQ4iDJbXlnIkTxy1IOPmk
         1EUMAaoLpDgEBeqwADNX0iS21kdLUI/uIHMinQ9vIU84aiplU8V5xgmYaA7Q7Fr6KBg9
         EzxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=M3r77HPoR75nODznb59FunQ4r0tjo8oLCP/b83AxrN8=;
        b=Qx2baKIt5/b6IBrNhxqT/Qv6lR9ql+PUA8X8s5MZOwYY6aungbFkG/l/HARQ8E8hVg
         ul6yFA+Ilp8M4HlvN7ESrNMigMZwHCxGvmO2J3Y2awjYlC20COXlhEt+Wvwq/xDZpO1V
         MZ34nvZjO59fHf/WgPHVVO/KmvR0+S5Ei6UOcEHVXRwzc8z9jkaOSZkrITnPsU/iPfim
         dYnBILkBCfMHBjOu0BHqNFd+Vilin1GDF135rTx4ly4HluhJxczpyKAQuc6wOXk64jvx
         3iiNdmMxboD0eNPcX9UBuLoRpDQ1s3hJ7RqCZ9p17sBnu/gs4wg4TNLsQ49Bkp4nQVBg
         qpXQ==
X-Gm-Message-State: APjAAAVCKPzPq1+09eEo4bnrtx0v8DqXVTniNDvocGL7nSOHVeHl3WaQ
        yzMlXNYKQWd4i1yelFbN64S9qx2B
X-Google-Smtp-Source: APXvYqz31oFz+kNkpvekPG2+xOVZ5P8s1+SRRSrFsyqztXR7nq3WT3o6m4wy7Dl/FoR2BqV6E97ZsA==
X-Received: by 2002:a17:902:9041:: with SMTP id w1mr26810654plz.132.1562605188327;
        Mon, 08 Jul 2019 09:59:48 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n17sm18357948pfq.182.2019.07.08.09.59.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 09:59:47 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next] sctp: remove rcu_read_lock from sctp_bind_addr_state
Date:   Tue,  9 Jul 2019 00:59:40 +0800
Message-Id: <30ff9e8a45fa0c64d1c71bc13e217f3374f6120e.1562605180.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sctp_bind_addr_state() is called either in packet rcv path or
by sctp_copy_local_addr_list(), which are under rcu_read_lock.
So there's no need to call it again in sctp_bind_addr_state().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/bind_addr.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
index f54333c..53bc615 100644
--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -393,24 +393,19 @@ int sctp_bind_addr_state(const struct sctp_bind_addr *bp,
 {
 	struct sctp_sockaddr_entry *laddr;
 	struct sctp_af *af;
-	int state = -1;
 
 	af = sctp_get_af_specific(addr->sa.sa_family);
 	if (unlikely(!af))
-		return state;
+		return -1;
 
-	rcu_read_lock();
 	list_for_each_entry_rcu(laddr, &bp->address_list, list) {
 		if (!laddr->valid)
 			continue;
-		if (af->cmp_addr(&laddr->a, addr)) {
-			state = laddr->state;
-			break;
-		}
+		if (af->cmp_addr(&laddr->a, addr))
+			return laddr->state;
 	}
-	rcu_read_unlock();
 
-	return state;
+	return -1;
 }
 
 /* Find the first address in the bind address list that is not present in
-- 
2.1.0

