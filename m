Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAF302CEA0
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbfE1S2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 14:28:46 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54044 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbfE1S2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 14:28:45 -0400
Received: by mail-wm1-f67.google.com with SMTP id d17so4052094wmb.3
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 11:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=uYaULYBE0EPgfrtNPGGDLcC6oDPFQtCpwrx2CXp6ATk=;
        b=RZTf1bvdweYMgbRCsPg1j3kj6D3Ai0nimH0pLIjdzD3a8FQacvuujfMoCVfGnO93eW
         7drm+1AucIa3JAyYR/EyJfz2K1GEqxN7Dx1Sxzrk/8VhdjS44llPBjOm1qrbipH6p1y6
         KwphMtWt9ls8505XL+2ltgcLKypDVJADyuyo0viVfHUgqJoymIXODNmrerMEu0fkF+wc
         pDfEeWnMOlKYPJosYHECH1lT1w51uGnusPjERxhGt6lAhXfoZV74OtrGqkOMnS0/NN+7
         gVQdJk4qGdEfF4Pkb/yQyUOn8MmaveTJh/SUKS0HazEFNhIsLHL2s2SoajvFL7PeK+Fc
         E5Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uYaULYBE0EPgfrtNPGGDLcC6oDPFQtCpwrx2CXp6ATk=;
        b=p8yEYOKJg2h2OVbBipt3xxhL0ZaCDaF2R3qw6BQzGFcZQ72EoQOhx2o4r1YhrjpHPb
         7OHmN8UuEqeZsSrfQqS81noDQ3PyF/dBaLb8mRxUCfsM7I/TqnCgyExObY0pu7ypzxAX
         rHN0Sid8Ve83/PGcT2B1h0t5IpAJskCW72LLHjee/hSOOJHeQjnE9lh75rBaFbATgKPO
         VLzKtxPV3nvFaFeQYyxRWFnwJXb4G85DwRVHdeeSGXorj2rt2Ih5qZMF+Th7GabTAvkw
         CVLzC8evsDpzO+WvhjjLpQTDRoOx+WdnMg2QasEUfoX2DqHwe7jycVNqpcHxzb8wOwl2
         9sVQ==
X-Gm-Message-State: APjAAAXcol4T+MN+KvkAuq+zdSKchVJN16PA6jMzL4m14LMzjcf5Q/G0
        NR/ceP/v0Q//qCw1XDPDVQ==
X-Google-Smtp-Source: APXvYqzmaswzZFjq88K95fNgUDJ1iE0GKzuysoQ1XnmPBkbqku78x1sYvgAvVVcV5BZv15P0jmWHzQ==
X-Received: by 2002:a1c:5401:: with SMTP id i1mr4293200wmb.169.1559068123976;
        Tue, 28 May 2019 11:28:43 -0700 (PDT)
Received: from x-Inspiron-15-5568.fritz.box (ip-95-223-112-76.hsi16.unitymediagroup.de. [95.223.112.76])
        by smtp.gmail.com with ESMTPSA id z14sm10504931wrh.86.2019.05.28.11.28.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 11:28:43 -0700 (PDT)
From:   Sergej Benilov <sergej.benilov@googlemail.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Cc:     Sergej Benilov <sergej.benilov@googlemail.com>
Subject: [PATCH] tcp: re-enable high throughput for low pacing rate
Date:   Tue, 28 May 2019 20:28:26 +0200
Message-Id: <20190528182826.31500-1-sergej.benilov@googlemail.com>
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

