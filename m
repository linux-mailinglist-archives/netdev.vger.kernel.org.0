Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C43E52CEC3
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbfE1Se6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 14:34:58 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52540 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727860AbfE1Se5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 14:34:57 -0400
Received: by mail-wm1-f68.google.com with SMTP id y3so4073540wmm.2
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 11:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=uYaULYBE0EPgfrtNPGGDLcC6oDPFQtCpwrx2CXp6ATk=;
        b=aUBbiwsdG+wHhHM4hGN1svTuRH306jKpMZBCwIahQce9/CgvG4vwpKd2D61B9k4KHu
         xG6TMJ0Bg14uCfRnhOb6ukSG0k6CQ5CQdvP73kwgUE3qhtQEqOG30kZTixEk0N26ABdx
         qfQeBgvdOsiBhvPstyRivkdgseHWlSaJlGgb2IdasqcLQg4yAZXMFM5OCAbMDRYl8AX9
         6YIXusFj/oE4MiVLQbX97v8RRRCK/JQHc928X5RC+Qx7r1Rk6iKKe+h0AkR2ifPTa37z
         N+56k9LozuaqJ6c4cHBA19Fxf3sXg8bXlSc+PvEi1RAXVrt8QxocyoM4Cm+bjXNM9Spk
         7rNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uYaULYBE0EPgfrtNPGGDLcC6oDPFQtCpwrx2CXp6ATk=;
        b=gZolbzZ20/ZaNGl5zN2GzmLS75bYjSiC6Izfc3gnq4ZB89qAplOwLwm9T/p8hryeic
         baHgfertBp32VQMNiJ8APtAj2fjg9LmBaK3eNGS/a4LKeBfFVtLFoBB7Cq0DbDSU3FZl
         hQm3+IH49XnN3ZCoNYqpFqYVWVrXnRtegRrXaaTyUAQzfoFRu5rXL6nk32lM5c8/IjCN
         NeIwc58jogTlfBs6nTmpI8tth2o8qWNEEEwYAOZk8e6jsG/QjZv2Nc7vEVxxcd/ESIp5
         WRXBqk/rHoP52yfpAT6gqiNTae1KLJANV1e9F3xWQ6PsZ4g1MNhnFAqbc+5x9z+bBmIQ
         YajA==
X-Gm-Message-State: APjAAAU22GgSrZZyxwIC7bNCWkQ7p/fEoLeNlVjDeasBgXlP3miklx+d
        DK3BxXgp09W8Dg==
X-Google-Smtp-Source: APXvYqwPm45aujzgtWbDkp7FSTkB7dFiN5zvcXutyjKHFSD2/i1VTyFwh09ZxNKnAe+cDGdn2EU+HA==
X-Received: by 2002:a7b:c344:: with SMTP id l4mr4109087wmj.25.1559068495411;
        Tue, 28 May 2019 11:34:55 -0700 (PDT)
Received: from x-Inspiron-15-5568.fritz.box (ip-95-223-112-76.hsi16.unitymediagroup.de. [95.223.112.76])
        by smtp.gmail.com with ESMTPSA id 197sm4787313wma.36.2019.05.28.11.34.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 11:34:54 -0700 (PDT)
From:   Sergej Benilov <sergej.benilov@googlemail.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Cc:     Sergej Benilov <sergej.benilov@googlemail.com>
Subject: [PATCH] v3.19.8: tcp: re-enable high throughput for low pacing rate
Date:   Tue, 28 May 2019 20:34:25 +0200
Message-Id: <20190528183425.31691-1-sergej.benilov@googlemail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 605ad7f184b60cfaacbc038aa6c55ee68dee3c89 "tcp: refine TSO autosizing",
the TSQ limit is computed as the smaller of
sysctl_tcp_limit_output_bytes and max(2 * skb->truesize, sk->sk_pacing_rate >> 10).
For low pacing rates, this approach sets a low limit, reducing throughput dramatically.

Compute the limit as the greater of sysctl_tcp_limit_output_bytes and max(2 * skb->truesize, sk->sk_pacing_rate >> 10).

Test:
netperf -H remote -l -2000000 -- -s 1000000

before patch:

MIGRATED TCP STREAM TEST from 0.0.0.0 () port 0 AF_INET to remote () port 0 AF_INET : demo
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

 87380 327680 327680    250.17      0.06

after patch:

MIGRATED TCP STREAM TEST from 0.0.0.0 () port 0 AF_INET to remote () port 0 AF_INET : demo
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

 87380 327680 327680    1.29       12.54

Signed-off-by: Sergej Benilov <sergej.benilov@googlemail.com>
---
 net/ipv4/tcp_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index e625be56..71efca72 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2054,7 +2054,7 @@ static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
 		 * One example is wifi aggregation (802.11 AMPDU)
 		 */
 		limit = max(2 * skb->truesize, sk->sk_pacing_rate >> 10);
-		limit = min_t(u32, limit, sysctl_tcp_limit_output_bytes);
+		limit = max_t(u32, limit, sysctl_tcp_limit_output_bytes);
 
 		if (atomic_read(&sk->sk_wmem_alloc) > limit) {
 			set_bit(TSQ_THROTTLED, &tp->tsq_flags);
-- 
2.17.1

