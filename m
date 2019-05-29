Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9C292D760
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 10:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbfE2IJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 04:09:54 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33945 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbfE2IJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 04:09:54 -0400
Received: by mail-pl1-f193.google.com with SMTP id w7so738925plz.1;
        Wed, 29 May 2019 01:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=LNT+zg4PSbt9K3xm52PuCoDPdKgmlpZ10u0AIkhHmCQ=;
        b=Ns7/gQCueH8qkz32nkdpNHhe+fi78Ls6j23hl1x4ARc8ypJClLRrkh6FEFr/403n8w
         F3/ElRwB6sJN17ug4AHJLr63hKJnsQVTCjNNEqPktHmpikJ5zo9bKHrwHgs0VF0q6XKl
         Jdc72B5Ul20qtENh6ByszFC5qtSKfkYbY9RvE8XjDDx41tL6MRYPE4rFYvz9EuQS1qIg
         2UM3UcW/nqMOTmMpTBk/MNqOf0Tauqikthr+u8KWD4S+HjvDHg54D9xQ5spRTHMzYjvY
         WHJKVtOAuaT9ah/G3YkdljIufmqxFYw65eSBdyE69krqTnRdK0OKV1CM3fxMrvQXZhis
         c5+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LNT+zg4PSbt9K3xm52PuCoDPdKgmlpZ10u0AIkhHmCQ=;
        b=Ae2Silv3dc1AFskC3yfl/GlIWjUg8Mc7HKam5EatFdtofU08C157oZcPlcjzeAO9tF
         Kiegkp3QoJAGdKhX+QEUZwSQZ2jR5Eom7HhSVLnZlqiR9N3+v9gAVcAwUi95YJ6LgpzF
         s2SeaiHzRTxwlON0fB6X3u4tQUUNGi4oTosQt528KrxxfOW25oUcNeoky7+pu97lB9nq
         nlM4Iaq4cShWNYLDR4pKv+ZUiVjbhWq2PjjqdRFSz+hWEMF2wnyWNH1ZE1ONAeUR4IYV
         LoX4NTC1qOX2yEZCsaK8IEbzuEU9YF+D4VpBLpLf7S5hvOSQNJi3Bnws1ohmgnHRu+MH
         NySA==
X-Gm-Message-State: APjAAAVgn27PxJo8fDvvQc8N7J/C1QQbO6ipJ1WWtewd7iSZPLEGToXx
        1uOWgWLKrfZ1gXxATHLVJNo=
X-Google-Smtp-Source: APXvYqwus4Qs9oLutePxkzGgcVLVX25FwdXFYB0UOW45rzdhECkOdH69gzUmV/QlaYUnOTa/ujS8kQ==
X-Received: by 2002:a17:902:b215:: with SMTP id t21mr21964991plr.152.1559117393602;
        Wed, 29 May 2019 01:09:53 -0700 (PDT)
Received: from xy-data.openstacklocal (ecs-159-138-22-150.compute.hwclouds-dns.com. [159.138.22.150])
        by smtp.gmail.com with ESMTPSA id p7sm16645973pgb.92.2019.05.29.01.09.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 29 May 2019 01:09:53 -0700 (PDT)
From:   Young Xiao <92siuyang@gmail.com>
To:     edumazet@google.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Young Xiao <92siuyang@gmail.com>
Subject: [PATCH] ipv4: tcp_input: fix stack out of bounds when parsing TCP options.
Date:   Wed, 29 May 2019 16:10:59 +0800
Message-Id: <1559117459-27353-1-git-send-email-92siuyang@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TCP option parsing routines in tcp_parse_options function could
read one byte out of the buffer of the TCP options.

1         while (length > 0) {
2                 int opcode = *ptr++;
3                 int opsize;
4
5                 switch (opcode) {
6                 case TCPOPT_EOL:
7                         return;
8                 case TCPOPT_NOP:        /* Ref: RFC 793 section 3.1 */
9                         length--;
10                        continue;
11                default:
12                        opsize = *ptr++; //out of bound access

If length = 1, then there is an access in line2.
And another access is occurred in line 12.
This would lead to out-of-bound access.

Therefore, in the patch we check that the available data length is
larger enough to pase both TCP option code and size.

Signed-off-by: Young Xiao <92siuyang@gmail.com>
---
 net/ipv4/tcp_input.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 20f6fac..9775825 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3791,6 +3791,8 @@ void tcp_parse_options(const struct net *net,
 			length--;
 			continue;
 		default:
+			if (length < 2)
+				return;
 			opsize = *ptr++;
 			if (opsize < 2) /* "silly options" */
 				return;
-- 
2.7.4

