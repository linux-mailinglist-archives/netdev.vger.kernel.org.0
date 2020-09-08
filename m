Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34F82621BA
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 23:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730168AbgIHVK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 17:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728164AbgIHVK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 17:10:58 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C21C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 14:10:57 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id r22so420992qtc.9
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 14:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=GPaBf0EdEfuJtTZLM2NbFAw5WZeCLyyF0GA/Tg5bxBA=;
        b=OpT36Sm72K1j4+gPSsMMZGFtmng/ft+axKpLI5Ha+MLjf5yzxW3pzRpbnZOOkNseKT
         EB38FvJTA2acfUSuD5C375xbxZabEqJIw2pB6eAbabcK4/ziUaLbLWvfHuCbAP9+OQwA
         +sUX1sWzEQUY1IOBB3w4kkI4AEuqWz3CU/Mf2sXsy/mV3nBKajA3N5m18xJLTMuj9Wqv
         oxiity1sWgk5j7f4MRWhvE1MdSokVYWl3cpTOBwj9ZiOpuaaVlq1kOcFTSTHTOipb5RG
         9xbalh3dipl5XPF4DjVHGTCdPgFe/9o24PW+3AxNTEViGE2UBGPqzlbmvaJ43WYUQ+Cg
         raEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=GPaBf0EdEfuJtTZLM2NbFAw5WZeCLyyF0GA/Tg5bxBA=;
        b=sgOwFDsh3sBBfFw/2nkpHYdPNIKP0tRaAkJJfi+sg9o6Id1bf6layyafqO+CJOekSL
         R2D8aNA9KBIt6oO9ABt7vJbH6+3ODIoaDq71IFAFOt1VWEk9cHG3/hsAnbZ8IyAiHsE6
         Dr/swbBT6FwqxTJnlheeDkb98wFPEss4BcWSIPTl1YYggd9jNqqXz0kmilYpdDHNKx4L
         T/lnyTH9xJhChdtmzNux3/uTsofQasHSCk/EfMmNQfYul2veT4EkcAygK+h/I7hLf1x5
         bcf/F8C+RvPYU4/8pZ5YsH+vQM8nTkLUB3w4Xld7aojK2maN5RgNyt/4Bf8L2fp1JHWH
         iIoA==
X-Gm-Message-State: AOAM533wSHLlloPO2N/Bx1MG5DdZ+mDCz4lqjYxAmYrAQuZaLEKWzahs
        28jbyrGr8AsSg9gXJwfChhK8P36K8h4=
X-Google-Smtp-Source: ABdhPJyFcdiBiIxTSZBdTyS2GU6EhPIizJug57FfRaTl4vmqhVJQtyeB/L5jarWB9YKh2W/BYjrck8rqzgA=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a0c:e904:: with SMTP id a4mr1072742qvo.21.1599599456071;
 Tue, 08 Sep 2020 14:10:56 -0700 (PDT)
Date:   Tue,  8 Sep 2020 14:09:34 -0700
Message-Id: <20200908210934.3418765-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH net] ip: fix tos reflection in ack and reset packets
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wei Wang <weiwan@google.com>, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, in tcp_v4_reqsk_send_ack() and tcp_v4_send_reset(), we
echo the TOS value of the received packets in the response.
However, we do not want to echo the lower 2 ECN bits in accordance
with RFC 3168 6.1.5 robustness principles.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

Signed-off-by: Wei Wang <weiwan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/ip_output.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 61f802d5350c..e6f2ada9e7d5 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -74,6 +74,7 @@
 #include <net/icmp.h>
 #include <net/checksum.h>
 #include <net/inetpeer.h>
+#include <net/inet_ecn.h>
 #include <net/lwtunnel.h>
 #include <linux/bpf-cgroup.h>
 #include <linux/igmp.h>
@@ -1703,7 +1704,7 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
 	if (IS_ERR(rt))
 		return;
 
-	inet_sk(sk)->tos = arg->tos;
+	inet_sk(sk)->tos = arg->tos & ~INET_ECN_MASK;
 
 	sk->sk_protocol = ip_hdr(skb)->protocol;
 	sk->sk_bound_dev_if = arg->bound_dev_if;
-- 
2.28.0.526.ge36021eeef-goog

