Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 374F57077C
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 19:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbfGVRiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 13:38:18 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36729 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbfGVRiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 13:38:17 -0400
Received: by mail-pg1-f195.google.com with SMTP id l21so17999667pgm.3;
        Mon, 22 Jul 2019 10:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=4nTsJr0BJdt7hLDpJFRZ1Mt40a//R9eaBytHtJA1GjY=;
        b=ZG2cN7fL+KGqz6AQfwFdAFWx7oRwld8bfKwkz02/HfqceFgiqmJ6a592zOiUDcMrQA
         iuvl/haDdEF6ZnvYp8CusaufY47ohWbYa1TFBWS4ynNu82lkk2tb8ZEStniSKUIAXRcl
         G8/5vCBfwKvlWeKxAMvtgY3Fn6BWJNvPEX3gQmQHd8QrXPbrYqV9ukDFheC/6Z/MLWZV
         7bRTMSuvNnqcwA1H9Z3JiLV3KNCgCNJQzsRTQ76VO3+qWQCvVJYixvs5hIPFrFbwjEIL
         jbOevQkDdIO+pdYTEQyydfIKzkeMFkEKNR8/oqbWyWW9qmIcNArE64xSdlQzN4t2lDPA
         tfXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=4nTsJr0BJdt7hLDpJFRZ1Mt40a//R9eaBytHtJA1GjY=;
        b=gHp0iSbBgWj7EpwOFLYIQaijnikVxawXkyyXswztLIuj4hD4JRLnqKYby6Dbkdusz/
         LiTxtA8N634Djb4K/YfhzkUFeJfpveFYICflDpTXcRQtAOpib5FURl+tRNq5C97Ff6MD
         yes0gVRllJPF64iXE4vlb1OeCUqvOLOT87VuZW49TSA9SSvcAZ3Q8zQHyfp4pruopCKe
         j1yvyqcujWvufy5kzmgmSWx1c6srTrCc9Jq+Ot84o89Lzinq3VA56HVp6vforiwyVta2
         I9F7nleZ7FIgH1XOsyGp/Yr/IH9BsqQfmunZaV4gEyuWPHdRWM2FcpbFsritFkzFwYtF
         i9VA==
X-Gm-Message-State: APjAAAX6n9KVKKc6z0onzqNzLabhKaNMgjYV1xb+co0m6Hw+ygdWOVRn
        JZJrKEm7r4jkNqzaIuDU5BlJEqdv
X-Google-Smtp-Source: APXvYqxzXuhvxLy1iXL9jZDPlNtXygTKbXobBcdaK7T6eqerjS/kB/8gEwE4ZU8EWmm/4UZamIUGfQ==
X-Received: by 2002:a63:5452:: with SMTP id e18mr56328609pgm.232.1563817096899;
        Mon, 22 Jul 2019 10:38:16 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a3sm48852857pje.3.2019.07.22.10.38.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 10:38:16 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 1/4] sctp: check addr_size with sa_family_t size in __sctp_setsockopt_connectx
Date:   Tue, 23 Jul 2019 01:37:57 +0800
Message-Id: <c875aa0a5b2965636dc3da83398856627310b280.1563817029.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1563817029.git.lucien.xin@gmail.com>
References: <cover.1563817029.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1563817029.git.lucien.xin@gmail.com>
References: <cover.1563817029.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now __sctp_connect() is called by __sctp_setsockopt_connectx() and
sctp_inet_connect(), the latter has done addr_size check with size
of sa_family_t.

In the next patch to clean up __sctp_connect(), we will remove
addr_size check with size of sa_family_t from __sctp_connect()
for the 1st address.

So before doing that, __sctp_setsockopt_connectx() should do
this check first, as sctp_inet_connect() does.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index aa80cda..5f92e4a 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1311,7 +1311,7 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
 	pr_debug("%s: sk:%p addrs:%p addrs_size:%d\n",
 		 __func__, sk, addrs, addrs_size);
 
-	if (unlikely(addrs_size <= 0))
+	if (unlikely(addrs_size < sizeof(sa_family_t)))
 		return -EINVAL;
 
 	kaddrs = memdup_user(addrs, addrs_size);
-- 
2.1.0

