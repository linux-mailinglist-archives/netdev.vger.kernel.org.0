Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5EE466D1D
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 23:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377435AbhLBWpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 17:45:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377333AbhLBWpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 17:45:45 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C894CC06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 14:42:22 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id z6so976340pfe.7
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 14:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZqLCHCq3ElFYJfr/YjWjRUYKiB+GTa+FYdLrZR8qFYg=;
        b=hdzyyrudf97FMGw5mkuyGqPS+cp1uh089FzGrrb8mV9NWu9egjALT3iNsxclroElSr
         LFPlJ2CMfopXw1S7dY5sOpljyK5gdCNajBHw89LbQc71A6MNdCNDz8jfspd25w5wrabI
         4I0Lk26K0c/PWG6rUuHU+pjF5+MdrI25KV9DHG4rvNo5DXFBwTzYWR1PTtjguhSTS825
         pAzpHPeaYN/nSzuGah/hNLV19iBTgA518LwXtzBpf1fbdekhCzUgz2Znqp+iV8UEM1hZ
         rvanIxipcE9WNPig6oLVmK2wUNAUtv4V/95H3lwhTmO56V5lFQvZIYJpbzL5zVbkBs3a
         ez2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZqLCHCq3ElFYJfr/YjWjRUYKiB+GTa+FYdLrZR8qFYg=;
        b=0oPK8+N5b6CClPEuDkcrTz6nzMHduoLV3vnM3s+NckAPxiM7GSRrBXXf8NYxT6cvAT
         OkTYq1T4CCAUEYQlwmKJmGJrLLtgxOVqxdLovZqhQw/r4YPbfEOs8yAF40zb/N0EJGJs
         tZRtawOXE32Dk+FyYwyHcqlvXs3UZyS6/6AZvM1L9bJ4mkxJM/8FIe09/b9H29RQdj0X
         BtTqjJaJACBd4ub0IgJVZSCbNzFielCzhCtLkos26L/I5v260gdqG5J6ddVyme7lHgM9
         FhbLpBpM2wg+wfMlGr5us5DwZ8ee1Frp4DD00re3IV/WcZvveOsn/XcEVkvusGtsK43+
         dgtg==
X-Gm-Message-State: AOAM531Lu8YxghVd95PI6AwoqI7lJSyn9wstHDLhkUSdEeIp9AZYPAex
        QEhI+wgF7muFvF4tRMsppuE=
X-Google-Smtp-Source: ABdhPJzs6lV5W5GNuSbpuxau2RC1vGkPtBp7hFa78pEjzhmJPrEBjZCATGbraNndLDyzmhsxYqGmNA==
X-Received: by 2002:a05:6a00:2387:b0:49f:af00:d5d0 with SMTP id f7-20020a056a00238700b0049faf00d5d0mr15597565pfc.1.1638484942406;
        Thu, 02 Dec 2021 14:42:22 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6c4b:c5cb:ac63:1ebf])
        by smtp.gmail.com with ESMTPSA id d15sm760560pfl.126.2021.12.02.14.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 14:42:21 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] inet: use #ifdef CONFIG_SOCK_RX_QUEUE_MAPPING consistently
Date:   Thu,  2 Dec 2021 14:42:18 -0800
Message-Id: <20211202224218.269441-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Since commit 4e1beecc3b58 ("net/sock: Add kernel config
SOCK_RX_QUEUE_MAPPING"),
sk_rx_queue_mapping access is guarded by CONFIG_SOCK_RX_QUEUE_MAPPING.

Fixes: 54b92e841937 ("tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Tariq Toukan <tariqt@nvidia.com>
---
 net/ipv4/inet_connection_sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index f7fea3a7c5e64b92ca9c6b56293628923649e58c..62a67fdc344cd21505a84c905c1e2c05cc0ff866 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -721,7 +721,7 @@ static struct request_sock *inet_reqsk_clone(struct request_sock *req,
 
 	sk_node_init(&nreq_sk->sk_node);
 	nreq_sk->sk_tx_queue_mapping = req_sk->sk_tx_queue_mapping;
-#ifdef CONFIG_XPS
+#ifdef CONFIG_SOCK_RX_QUEUE_MAPPING
 	nreq_sk->sk_rx_queue_mapping = req_sk->sk_rx_queue_mapping;
 #endif
 	nreq_sk->sk_incoming_cpu = req_sk->sk_incoming_cpu;
-- 
2.34.1.400.ga245620fadb-goog

